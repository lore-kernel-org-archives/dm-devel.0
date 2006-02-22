From: Greg KH <gregkh@suse.de>
Subject: Re: [PATCH 0/3] sysfs representation of stacked devices
	(dm/md) (rev.2)
Date: Wed, 22 Feb 2006 10:47:29 -0800
Message-ID: <20060222184729.GA13638@suse.de>
References: <43FC8C00.5020600@ce.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <43FC8C00.5020600@ce.jp.nec.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
Cc: device-mapper development <dm-devel@redhat.com>, Lars Marowsky-Bree <lmb@suse.de>, Alasdair Kergon <agk@redhat.com>, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

On Wed, Feb 22, 2006 at 11:06:24AM -0500, Jun'ichi Nomura wrote:
> Hello,
> 
> This is a revised set of pathces which provides common
> representation of dependencies between stacked devices (dm and md)
> in sysfs.
> 
> Variants of bd_claim/bd_release are added to accept a kobject
> and create symlinks between the claimed bdev and the holder.
> 
> dm/md will give a child of its gendisk kobject to bd_claim.
> For example, if dm-0 maps to sda, we have the following symlinks;
>    /sys/block/dm-0/slaves/sda --> /sys/block/sda
>    /sys/block/sda/holders/dm-0 --> /sys/block/dm-0
> 
> Comments are welcome.
> 
> A few points I would appreciate comments/reviews from maintainers:
>   About sysfs
>     - I confirmed sysfs_remove_symlink() and kobject_del() don't
>       allocate memory in 2.6.15 and it seems true on the git head.
>       I would like to make sure it's true in future versions of kernel
>       because they are called during device-mapper's table swapping
>       where I/O to free memory could deadlock on the dm device.
>       What is the recommended way to do that?

But it can possibly sleep.

Hm, wait, the put_device stuff can possibly sleep, the "raw"
kobject_del() stuff looks safe.  Either way, they don't create new
memory, unless you do something really wierd in your release callback.

So you should be safe here.

But if you want to be absolutly safe, look at the thread on lkml about
changing the scsi code to do the final release in a non-interrupt
context.  That looks like it might be the same thing you want to do
here to guarantee that nothing bad happens.

thanks,

greg k-h
