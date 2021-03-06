# -*- coding: utf-8 -*-
#
# Project:     weechat-notify-send
# Homepage:    https://github.com/s3rvac/weechat-notify-send
# Description: Sends highlight and private-message notifications through
#              notify-send. Requires libnotify.
# License:     MIT (see below)
#
# Copyright (c) 2015 by Petr Zemek <s3rvac@gmail.com> and contributors
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
#

import os
import re
import subprocess
import sys


# Ensure that we are running under weechat.
try:
    import weechat
except ImportError:
    print('This script has to run under WeeChat (http://www.weechat.org/).')
    sys.exit(1)


# Name of the script.
SCRIPT_NAME = 'notify_send'

# Author of the script.
SCRIPT_AUTHOR = 's3rvac'

# Version of the script.
SCRIPT_VERSION = '0.4 (dev)'

# License under which the script is distributed.
SCRIPT_LICENSE = 'MIT'

# Description of the script.
SCRIPT_DESC = ('Sends highlight and private-message notifications '
               'through notify-send.')

# Name of a function to be called when the script is unloaded.
SCRIPT_SHUTDOWN_FUNC = ''

# Used character set (utf-8 by default).
SCRIPT_CHARSET = ''

# Script settings.
SETTINGS = {
    'notify_when_away': (
        'on',
        'Send also notifications when away.'
    ),
    'notify_for_current_buffer': (
        'on',
        'Send also notifications for the currently active buffer.'
    ),
    'ignore_nicks': (
        '',
        'A comma-separated list of nicks from which no notifications should '
        'be shown.'
    ),
    'ignore_nicks_starting_with': (
        '',
        'A comma-separated list of nick prefixes from which no '
        'notifications should be shown.'
    ),
    'nick_separator': (
        ': ',
        'A separator between a nick and a message.'
    ),
    'escape_html': (
        'on',
        "Escapes the '<', '>', and '&' characters in notification messages."
    ),
    'max_length': (
        '72',
        'Maximal length of a notification (0 means no limit).'
    ),
    'ellipsis': (
        '[..]',
        'Ellipsis to be used for notifications that are too long.'
    ),
    'icon': (
        '/usr/share/icons/hicolor/32x32/apps/weechat.png',
        'Path to an icon to be shown in notifications.'
    ),
    'timeout': (
        '5000',
        'Time after which the notification disappears (in milliseconds; '
        'set to 0 to disable).'
    ),
    'urgency': (
        'normal',
        'Urgency (low, normal, critical).'
    )
}


class Notification(object):
    """A representation of a notification."""

    def __init__(self, source, message, icon, timeout, urgency):
        self.source = source
        self.message = message
        self.icon = icon
        self.timeout = timeout
        self.urgency = urgency


def default_value_of(option):
    """Returns the default value of the given option."""
    return SETTINGS[option][0]


def nick_from_prefix(prefix):
    """Returns a nick from the given prefix.

    The prefix comes from WeeChat. It is a nick with an optional mode (e.g. @
    if the user is an operator or + if the user has voice).
    """
    # We have to remove the mode (if any).
    return re.sub(r'^[@+](.*)', r'\1', prefix)


def notification_cb(data, buffer, date, tags, is_displayed, is_highlight,
                    prefix, message):
    """A callback for notifications from WeeChat."""
    is_highlight = int(is_highlight)
    nick = nick_from_prefix(prefix)

    if notification_should_be_sent(buffer, nick, is_highlight):
        notification = prepare_notification(
            buffer, is_highlight, nick, message
        )
        send_notification(notification)

    return weechat.WEECHAT_RC_OK


def notification_should_be_sent(buffer, nick, is_highlight):
    """Should a notification be sent?"""
    if buffer == weechat.current_buffer():
        if not notify_for_current_buffer():
            return False

    if is_away(buffer):
        if not notify_when_away():
            return False

    if ignore_notifications_from(nick):
        return False

    if is_private_message(buffer):
        if i_am_author_of_message(buffer, nick):
            # Do not send notifications from myself.
            return False
        return True

    if is_highlight:
        return True

    # We send notifications only for private messages or highlights.
    return False


def notify_for_current_buffer():
    """Should we also send notifications for the current buffer?"""
    return weechat.config_get_plugin('notify_for_current_buffer') == 'on'


def notify_when_away():
    """Should we also send notifications when away?"""
    return weechat.config_get_plugin('notify_when_away') == 'on'


def is_away(buffer):
    """Is the user away?"""
    return weechat.buffer_get_string(buffer, 'localvar_away') != ''


def is_private_message(buffer):
    """Has a private message been sent?"""
    return weechat.buffer_get_string(buffer, 'localvar_type') == 'private'


def i_am_author_of_message(buffer, nick):
    """Am I (the current WeeChat user) the author of the message?"""
    return weechat.buffer_get_string(buffer, 'localvar_nick') == nick


def ignore_notifications_from(nick):
    """Should notifications from the given nick be ignored?"""
    if nick in ignored_nicks():
        return True

    for prefix in ignored_nick_prefixes():
        if prefix and nick.startswith(prefix):
            return True

    return False


def ignored_nicks():
    """A generator of nicks from which notifications should be ignored."""
    for nick in weechat.config_get_plugin('ignore_nicks').split(','):
        yield nick.strip()


def ignored_nick_prefixes():
    """A generator of nick prefixes from which notifications should be
    ignored.
    """
    prefixes = weechat.config_get_plugin('ignore_nicks_starting_with')
    for prefix in prefixes.split(','):
        yield prefix.strip()


def prepare_notification(buffer, is_highlight, nick, message):
    """Prepares a notification from the given data."""
    if is_highlight:
        source = (weechat.buffer_get_string(buffer, 'short_name') or
                  weechat.buffer_get_string(buffer, 'name'))
        message = nick + nick_separator() + message
    else:
        # A private message.
        source = nick

    max_length = int(weechat.config_get_plugin('max_length'))
    if max_length > 0:
        ellipsis = weechat.config_get_plugin('ellipsis')
        message = shorten_message(message, max_length, ellipsis)

    if weechat.config_get_plugin('escape_html') == 'on':
        message = escape_html(message)

    message = escape_slashes(message)

    icon = weechat.config_get_plugin('icon')
    timeout = weechat.config_get_plugin('timeout')
    urgency = weechat.config_get_plugin('urgency')

    return Notification(source, message, icon, timeout, urgency)


def nick_separator():
    """Returns a nick separator to be used."""
    separator = weechat.config_get_plugin('nick_separator')
    return separator if separator else default_value_of('nick_separator')


def shorten_message(message, max_length, ellipsis):
    """Shortens the message to at most max_length characters by using the given
    ellipsis.
    """
    if max_length <= 0 or len(message) <= max_length:
        # Nothing to shorten.
        return message

    if len(ellipsis) >= max_length:
        # We cannot include any part of the message.
        return ellipsis[:max_length]

    return message[:max_length - len(ellipsis)] + ellipsis


def escape_html(message):
    """Escapes HTML characters in the given message."""
    # Only the following characters need to be escaped
    # (https://wiki.ubuntu.com/NotificationDevelopmentGuidelines).
    message = message.replace('&', '&amp;')
    message = message.replace('<', '&lt;')
    message = message.replace('>', '&gt;')
    return message


def escape_slashes(message):
    """Escapes slashes in the given message."""
    # We need to escape backslashes to prevent notify-send from interpreting
    # them, e.g. we do not want to print a newline when the message contains
    # '\n'.
    return message.replace('\\', r'\\')


def send_notification(notification):
    """Sends the given notification to the user."""
    notify_cmd = ['notify-send', '--app-name', 'weechat']
    if notification.icon:
        notify_cmd += ['--icon', notification.icon]
    if notification.timeout:
        notify_cmd += ['--expire-time', str(notification.timeout)]
    if notification.urgency:
        notify_cmd += ['--urgency', notification.urgency]
    notify_cmd += [notification.source, notification.message]

    # Prevent notify-send from messing up the WeeChat screen when occasionally
    # emitting assertion messages by redirecting the output to /dev/null (you
    # would need to run /redraw to fix the screen).
    # In Python < 3.3, there is no subprocess.DEVNULL, so we have to use a
    # workaround.
    with open(os.devnull, 'wb') as devnull:
        subprocess.check_call(
            notify_cmd,
            stderr=subprocess.STDOUT,
            stdout=devnull,
        )


if __name__ == '__main__':
    # Registration.
    weechat.register(
        SCRIPT_NAME,
        SCRIPT_AUTHOR,
        SCRIPT_VERSION,
        SCRIPT_LICENSE,
        SCRIPT_DESC,
        SCRIPT_SHUTDOWN_FUNC,
        SCRIPT_CHARSET
    )

    # Initialization.
    for option, (default_value, description) in SETTINGS.items():
        weechat.config_set_desc_plugin(option, description)
        if not weechat.config_is_set_plugin(option):
            weechat.config_set_plugin(option, default_value)
    weechat.hook_print('', 'irc_privmsg', '', 1, 'notification_cb', '')
    weechat.hook_print('', "notify_message", '', 1, 'notification_cb', '')
    # weechat.hook_print("", "notify_private", "", 1, "notification_cb", "")

