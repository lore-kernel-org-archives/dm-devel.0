From: "Michael S. Tsirkin" <m.s.tsirkin@gmail.com>
Subject: 2.6.33-rc6 regression: mdadm Unknown cmd 800c0910 (RAID_VERSION)
Date: Sat, 30 Jan 2010 22:53:55 +0200
Message-ID: <20100130205353.GA3168@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, neilb@suse.de, linux-raid@vger.kernel.org, dm-devel@redhat.com, arnd@arndb.de, maan@systemlinux.org
List-Id: dm-devel.ids

Under 2.6.33-rcX (at least rc5 and rc6, didn't check earlier versions),
I started seeing these messages in dmesg (I do not see these messages on 2.6.32):

[   16.528951] ioctl32(mdadm:2243): Unknown cmd fd(3) cmd(800c0910){t:09;sz:12} arg(ffb7f9c4) on /dev/sda9
[   16.529570] ioctl32(mdadm:2243): Unknown cmd fd(3) cmd(800c0910){t:09;sz:12} arg(ffb7f9e4) on /dev/sda9
[   16.553175] ioctl32(mdadm:2243): Unknown cmd fd(3) cmd(800c0910){t:09;sz:12} arg(ffb7f9c4) on /dev/sda7
[   16.553846] ioctl32(mdadm:2243): Unknown cmd fd(3) cmd(800c0910){t:09;sz:12} arg(ffb7f9e4) on /dev/sda7
[   16.577349] ioctl32(mdadm:2243): Unknown cmd fd(3) cmd(800c0910){t:09;sz:12} arg(ffb7f9c4) on /dev/sda6
[   16.577954] ioctl32(mdadm:2243): Unknown cmd fd(3) cmd(800c0910){t:09;sz:12} arg(ffb7f9e4) on /dev/sda6
[   16.684570] ioctl32(mdadm:2243): Unknown cmd fd(3) cmd(800c0910){t:09;sz:12} arg(ffb7f9c4) on /dev/sda5
[   16.695916] ioctl32(mdadm:2243): Unknown cmd fd(3) cmd(800c0910){t:09;sz:12} arg(ffb7f9e4) on /dev/sda5
[   16.702729] ioctl32(mdadm:2243): Unknown cmd fd(3) cmd(800c0910){t:09;sz:12} arg(ffb7f9c4) on /dev/sda2
[   16.702743] ioctl32(mdadm:2243): Unknown cmd fd(3) cmd(800c0910){t:09;sz:12} arg(ffb7f9e4) on /dev/sda2
[   16.747168] ioctl32(mdadm:2243): Unknown cmd fd(3) cmd(800c0910){t:09;sz:12} arg(ffb7f9c4) on /dev/sda1
[   16.747786] ioctl32(mdadm:2243): Unknown cmd fd(3) cmd(800c0910){t:09;sz:12} arg(ffb7f9e4) on /dev/sda1

I am running 32 bit userspace on 64 bit kernel.

I do not observe any ill effects, possibly because I do not really use raid.

The command in question seems to be RAID_VERSION.

I have verified that reverting
aa98aa31987ad9831711ae71ea2270228ab62532
makes the errors go away.

Didn't yet bother opening a bugzilla for this, let me know if I should.

-- 
MST
