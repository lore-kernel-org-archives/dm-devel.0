From: Christoph Hellwig <hch@lst.de>
Subject: Re: Bisected, with rfc/patch - was Re: BUG: unable to handle
	kernel NULL pointer dereference at sysfs_do_create_link_sd (after
	mdadm)
Date: Fri, 24 Apr 2015 10:27:09 +0200
Message-ID: <20150424082709.GA19218@lst.de>
References: <20150414171537.GH25394@azat> <20150423160551.45345f96@notabene.brown> <20150423073724.GA8139@lst.de> <20150423180314.367c0876@notabene.brown> <20150423161051.GA18971@lst.de> <20150424120932.3d554638@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150424120932.3d554638@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Christoph Hellwig <hch@lst.de>, Azat Khuzhin <a3at.mail@gmail.com>, "Kernel.org-Linux-RAID" <linux-raid@vger.kernel.org>, Guoqing Jiang <GQJiang@suse.com>, Tejun Heo <tj@kernel.org>, Jan Kara <jack@suse.cz>, Jens Axboe <axboe@fb.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

On Fri, Apr 24, 2015 at 12:09:32PM +1000, NeilBrown wrote:
> I'm pretty sure that the md code is already as close to the "dm model" as it
> meaningfully can be.
> 
> If I move bdi_destroy out of blk_release_queue (which really think is too
> later) and place it in blk_cleanup_queue (which seems a credible place for
> it), and then move the blk_cleanup_queue call in md_free up before the
> del_gendisk() call (which is probably the right thing to do anyway, though dm
> has the same order that md currently has) then I don't get any crashes and
> I'm almost convince it is correct...

This looks reasonable to me, thanks.
