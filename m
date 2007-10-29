From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Device mapper regression 2.6.23 vs.
	v2.6.23-6597-gcfa76f0
Date: Mon, 29 Oct 2007 00:18:32 -0700
Message-ID: <20071029001832.05c0a372.akpm@linux-foundation.org>
References: <471BA729.6050206@m3y3r.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <471BA729.6050206@m3y3r.de>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Thomas Meyer <thomas@m3y3r.de>
Cc: Greg KH <greg@kroah.com>, dm-devel@redhat.com, Kay Sievers <kay.sievers@vrfy.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: dm-devel.ids

On Sun, 21 Oct 2007 21:23:21 +0200 Thomas Meyer <thomas@m3y3r.de> wrote:

> Hi.
> 
> I have an external hard drive with an encrypted partition. I am using
> kde so all i had to do under 2.6.23 was
>   "cryptsetup luksOpen /dev/sdb2 crypt-extern"
> 
> then udev/hal/kde (?)automatically created an desktop icon. i could
> click this icon to mount and open the drive.
> 
> when i do the luksOpen command with v2.6.23-6597-gcfa76f0 this icon is
> not created anymore.
> 
> a few commits were made in drivers/md, so it seems something broke.
> 
> config extract:
> 
> CONFIG_MD=y
> # CONFIG_BLK_DEV_MD is not set
> CONFIG_BLK_DEV_DM=y
> # CONFIG_DM_DEBUG is not set
> CONFIG_DM_CRYPT=y
> CONFIG_DM_SNAPSHOT=m
> CONFIG_DM_MIRROR=m
> CONFIG_DM_ZERO=m
> # CONFIG_DM_MULTIPATH is not set
> CONFIG_DM_DELAY=m
> CONFIG_DM_UEVENT=y
> # CONFIG_FUSION is not set
> 
> any ideas?
> 

Could be DM breakage, could be udev/sysfs breakage.  Is it still happening
in current mainline?

And how come I'm seeing unresponded-to-for-a-week regression
reports on lkml?
