From: Arnd Bergmann <arnd@arndb.de>
Subject: compat_ioctl: ignore RAID_VERSION ioctl
Date: Sat, 30 Jan 2010 23:02:10 +0100
Message-ID: <201001302302.10574.arnd@arndb.de>
References: <20100130205353.GA3168@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100130205353.GA3168@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Michael S. Tsirkin" <m.s.tsirkin@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, neilb@suse.de, linux-raid@vger.kernel.org, dm-devel@redhat.com, maan@systemlinux.org
List-Id: dm-devel.ids

md ioctls are now handled by the md driver itself, but mdadm
may call RAID_VERSION on other devices as well. Mark the command
as IGNORE_IOCTL so this fails silently rather than printing
an annoying message.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---

On Saturday 30 January 2010, Michael S. Tsirkin wrote:
> Under 2.6.33-rcX (at least rc5 and rc6, didn't check earlier versions),
> I started seeing these messages in dmesg (I do not see these messages on 2.6.32):
> 
> [   16.528951] ioctl32(mdadm:2243): Unknown cmd fd(3) cmd(800c0910){t:09;sz:12} arg(ffb7f9c4) on /dev/sda9

Does this help?

--- a/fs/compat_ioctl.c
+++ b/fs/compat_ioctl.c
@@ -1038,6 +1038,8 @@ COMPATIBLE_IOCTL(FIOQSIZE)
 #ifdef CONFIG_BLOCK
 /* loop */
 IGNORE_IOCTL(LOOP_CLR_FD)
+/* md calls this on random blockdevs */
+IGNORE_IOCTL(RAID_VERSION)
 /* SG stuff */
 COMPATIBLE_IOCTL(SG_SET_TIMEOUT)
 COMPATIBLE_IOCTL(SG_GET_TIMEOUT)

