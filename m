From: Andreas Sundstrom <sunkan@zappa.cx>
Subject: discard + LVM/DM
Date: Sun, 07 Mar 2010 11:37:26 +0100
Message-ID: <4B9381E6.7000401@zappa.cx>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

Hi..

I have an OCZ agility SSD drive with FW 1.5 that supports the TRIM command.

I can see that ext4 mounted with the "discard" option issues the TRIM
command successfully when I use a plain partition to host the
filesystem.

But it does not seem to work together with LVM, and I'm guessing that
it's DM that actually is the problem here since LVM is more like a
admin interface to DM right?

According to a response [1] I got on the ext4 ML it is expected behaviour
right now, my question is whether this is something that is planned to
be supported through DM?

1. http://www.spinics.net/lists/linux-ext4/msg17842.html

If it is being worked on, then of course it's interesting to get an
idea of how far in the future can be expected to work?

Otherwise I guess that I will consider reverting back to plain
partitions on my SSD drive.

Thanks for any help

/Andreas Sundstrom
