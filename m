From: Thomas Backlund <tmb@mandriva.org>
Subject: Re: [dm-devel] [BUG] kernel 2.6.32.x hangs during boot process
Date: Thu, 28 Jan 2010 20:16:34 +0200
Message-ID: <4B61D482.4080907@mandriva.org>
References: <d2deb3241001160158r4baed1e1t7e8f6642de018b4c@mail.gmail.com>	<20100122160740.6c16c22d.akpm@linux-foundation.org> <20100128134205.352044bd@notabene> <4B612F89.7020503@ce.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4B612F89.7020503@ce.jp.nec.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
Cc: =?ISO-8859-1?Q?Fran=E7ois_Figarola?= <francois.figarola@i-consult.fr>, hch@infradead.org, device-mapper development <dm-devel@redhat.com>, linux-kernel@vger.kernel.org, Neil Brown <neilb@suse.de>, Andrew Morton <akpm@linux-foundation.org>, linux-raid@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>
List-Id: dm-devel.ids

28.01.2010 08:32, Jun'ichi Nomura skrev:
>>> On Sat, 16 Jan 2010 10:58:30 +0100
>>> Fran__ois Figarola<francois.figarola@i-consult.fr>  wrote:
>>>> Since I've tried to boot 2.6.32.x kernel, my system hangs during the
>>>> boot process, and I think it could be related to the problem reported
>>>> earlier by Megastorage (http://lkml.org/lkml/2010/1/10/92).
>>>>
>>>> The hardware is a Dell PowerEdge 2950 which runs fine with the
>>>> 2.6.31.x kernel series (actually running with the latest 2.6.31.11),
>>>> and the system is debian etch.
>>>>
>>>> Here is the trace of the bug I've got (using netconsole) with a
>>>> 2.6.32.3 kernel :
>>>>
>>>> BUG: Dentry ffff880667690000{i=41a46,n=sleep} still in use (8)
>>>> [unmount of ext3 dm-4]
>>>> ------------[ cut here ]------------
>>>> kernel BUG at fs/dcache.c:670!
>
> I can reproduce this when suspend/resume read-only mounted dm device.
>
> When MS_RDONLY, both freeze_bdev and thaw_bdev call deactivate_locked_super,
> which seems wrong. The change was introduced with the commit below:
>
>    commit 4504230a71566785a05d3e6b53fa1ee071b864eb
>    Author: Christoph Hellwig<hch@lst.de>
>    Date:   Mon Aug 3 23:28:35 2009 +0200
>
>    freeze_bdev: grab active reference to frozen superblocks
>
> With the attached patch, both remount-ro and remount-rw are
> rejected as EBUSY on freezed device as expected.
>
> Christoph, do you think this is the right fix?
>

I can confirm that both reverting the above patch, or applying the fix 
below fixes the issue on both 2.6.32 and 2.6.33-rc5

So if it's considered the correct fix, it needs to be cc stable@ for 2.6.32

(I reported this same issue this morning here:
  http://marc.info/?l=linux-kernel&m=126467195500908&w=2,
  but then I found this thread/fix)

The system I have tested on is a 4-disk dmraid10 connected to an Intel 
ICH10R on an Asus P7P55D Deluxe running x86_64

> Jun'ichi Nomura, NEC Corporation
>
>
> If MS_RDONLY, freeze_bdev should just up_write(s_umount) instead of
> deactivate_locked_super().
> Also, keep sb->s_frozen consistent so that remount can check the frozen state.
>
> Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
   Tested-by: Thomas Backlund <tmb@mandriva.org>
>
> diff --git a/fs/block_dev.c b/fs/block_dev.c
> index 73d6a73..600261f 100644
> --- a/fs/block_dev.c
> +++ b/fs/block_dev.c
> @@ -246,7 +246,9 @@ struct super_block *freeze_bdev(struct block_device *bdev)
>  	if (!sb)
>  		goto out;
>  	if (sb->s_flags & MS_RDONLY) {
> -		deactivate_locked_super(sb);
> +		sb->s_frozen = SB_FREEZE_TRANS;
> +		smp_wmb();
> +		up_write(&sb->s_umount);
>  		mutex_unlock(&bdev->bd_fsfreeze_mutex);
>  		return sb;
>  	}
> @@ -307,7 +309,7 @@ int thaw_bdev(struct block_device *bdev, struct super_block *sb)
>  	BUG_ON(sb->s_bdev != bdev);
>  	down_write(&sb->s_umount);
>  	if (sb->s_flags & MS_RDONLY)
> -		goto out_deactivate;
> +		goto out_unfrozen;
>
>  	if (sb->s_op->unfreeze_fs) {
>  		error = sb->s_op->unfreeze_fs(sb);
> @@ -321,11 +323,11 @@ int thaw_bdev(struct block_device *bdev, struct super_block *sb)
>  		}
>  	}
>
> +out_unfrozen:
>  	sb->s_frozen = SB_UNFROZEN;
>  	smp_wmb();
>  	wake_up(&sb->s_wait_unfrozen);
>
> -out_deactivate:
>  	if (sb)
>  		deactivate_locked_super(sb);
>  out_unlock:
