From: Tejun Heo <tj@kernel.org>
Subject: Re: 2.6.27-rc5-mmotm0829 - lvm issues at boot, possible disk_devt()
 related?
Date: Mon, 01 Sep 2008 09:58:40 +0200
Message-ID: <48BBA0B0.5070309@kernel.org>
References: <4963.1220240176@turing-police.cc.vt.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1753787AbYIAIB2@vger.kernel.org>
In-Reply-To: <4963.1220240176@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
To: Valdis.Kletnieks@vt.edu
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, dm-devel@redhat.com, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, Jens Axboe <jens.axboe@oracle.com>
List-Id: dm-devel.ids

Valdis.Kletnieks@vt.edu wrote:
> I bisected this down to the 08/28 version of linux-next.patch that was in
> mmotm-0829.  27-rc3-mmotm0814 works fine.
> 
> System boots, loads the initrd, starts running.  The initrd tries to run lvm
> to find my root file system (the one drive has sda1 a small /boot, and sda2
> is the rest of the disk, and LVM space).  Every single partition complains:
> 
> device-mapper: core: bdget failed in dm_suspend
> device-mapper: resume ioctl failed: invalid argument
> Unable to resume Volgroup00-root (254:0)
> 
> and repeats the 3 lines with different Volgroup-foo and 254:N values for
> each LVM logical volume.  After this, it rolls over and dies because it
> didn't find the root filesystem.  
> 
> This is with an initrd build with Fedora Rawhide current as of last night.
> Using an older initrd that's been working just fine for several releases
> just silently hangs around the lvm startup. (My initrd config does not include
> any .ko files, just nash and lvm and similar early-userspace stuff).
> 
> Any ideas?  Am willing to try patches/debugging code, if anybody can think
> what I should be instrumenting to get more info.
> 
> My gut feeling is an issue in Tejun Heo's patches to implement extended dev
> numbers - one of these two or a related patch:

Yeah, I made a mistake converting two of them and devt lookup fails when
the disk is zero sized.  Bartlomiej debugged the problem and posted a
patch and I followed up with an updated patch.  It should be fine in the
next round.

  http://article.gmane.org/gmane.linux.kernel.next/2663
  http://article.gmane.org/gmane.linux.kernel.next/2676

If you're seeing other problems, please let me know.

Thanks.

-- 
tejun
