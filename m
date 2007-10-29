From: Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: Device mapper regression 2.6.23 vs. v2.6.23-6597-gcfa76f0
Date: Mon, 29 Oct 2007 12:59:26 +0100
Message-ID: <1193659166.2773.12.camel@lov.site>
References: <471BA729.6050206@m3y3r.de>
	 <20071029001832.05c0a372.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1753852AbXJ2L5p@vger.kernel.org>
In-Reply-To: <20071029001832.05c0a372.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Thomas Meyer <thomas@m3y3r.de>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, dm-devel@redhat.com, Greg KH <greg@kroah.com>
List-Id: dm-devel.ids

On Mon, 2007-10-29 at 00:18 -0700, Andrew Morton wrote:
> On Sun, 21 Oct 2007 21:23:21 +0200 Thomas Meyer <thomas@m3y3r.de> wrote:
> > 
> > I have an external hard drive with an encrypted partition. I am using
> > kde so all i had to do under 2.6.23 was
> >   "cryptsetup luksOpen /dev/sdb2 crypt-extern"
> > 
> > then udev/hal/kde (?)automatically created an desktop icon. i could
> > click this icon to mount and open the drive.
> > 
> > when i do the luksOpen command with v2.6.23-6597-gcfa76f0 this icon is
> > not created anymore.
> > 
> > a few commits were made in drivers/md, so it seems something broke.
> > 
> > config extract:
> > 
> > CONFIG_MD=y
> > # CONFIG_BLK_DEV_MD is not set
> > CONFIG_BLK_DEV_DM=y
> > # CONFIG_DM_DEBUG is not set
> > CONFIG_DM_CRYPT=y
> > CONFIG_DM_SNAPSHOT=m
> > CONFIG_DM_MIRROR=m
> > CONFIG_DM_ZERO=m
> > # CONFIG_DM_MULTIPATH is not set
> > CONFIG_DM_DELAY=m
> > CONFIG_DM_UEVENT=y
> > # CONFIG_FUSION is not set
> > 
> > any ideas?
> > 
> 
> Could be DM breakage, could be udev/sysfs breakage.  Is it still happening
> in current mainline?

There are no obvious changes, which I would expect to cause a breakage
in this area. 

> And how come I'm seeing unresponded-to-for-a-week regression
> reports on lkml?

It works fine with 2.6.24-rc1+ and GNOME, even without any initial shell
command to set it up. Just inserting a LUKS volume, brings up a password
dialog, and then mounts all automatically.

There was a timing problem fix in HAL (in 0.5.10), maybe that is what
happens here.

Kay
