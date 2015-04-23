From: Christoph Hellwig <hch@lst.de>
Subject: Re: Bisected, with rfc/patch - was Re: BUG: unable to handle
	kernel NULL pointer dereference at sysfs_do_create_link_sd (after
	mdadm)
Date: Thu, 23 Apr 2015 18:10:51 +0200
Message-ID: <20150423161051.GA18971@lst.de>
References: <20150414171537.GH25394@azat> <20150423160551.45345f96@notabene.brown> <20150423073724.GA8139@lst.de> <20150423180314.367c0876@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150423180314.367c0876@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Christoph Hellwig <hch@lst.de>, Azat Khuzhin <a3at.mail@gmail.com>, "Kernel.org-Linux-RAID" <linux-raid@vger.kernel.org>, Guoqing Jiang <GQJiang@suse.com>, Tejun Heo <tj@kernel.org>, Jan Kara <jack@suse.cz>, Jens Axboe <axboe@fb.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

On Thu, Apr 23, 2015 at 06:03:14PM +1000, NeilBrown wrote:
> On Thu, 23 Apr 2015 09:37:24 +0200 Christoph Hellwig <hch@lst.de> wrote:
> 
> > Plase fix your device name lifetimes.
> 
> Any chance you could be more explicit?
>
> The commit you identified doesn't seem to help much - md and dm are quite
> different in this area.
> 
> It seems that it is no longer safe to call 'add_disk' between calling
> 'del_gendisk' and bdi_destroy being called.  How can I find out if I am in
> that window, or wait for bdi_destroy to be called?

The bdi is only around if the device is open, either through a device
node, or through a blkdev_get from a file system.  If you get duplicate
names that means you're trying to allocate a new gendisk while the old
one is still around.

In theory you're fine once the device gets ->release called.

Except that we can hold sysfs reference to the qeue, eww.  So for now
try to follow the dm model, but I'll need to add a callback to the
queue called once the request_queue actually is released for this.
