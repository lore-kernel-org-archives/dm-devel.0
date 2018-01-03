From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [for-4.16 PATCH v2 0/5] block, nvme, dm: allow DM multipath to
 use NVMe's error handler
Date: Tue, 2 Jan 2018 19:24:35 -0500
Message-ID: <20180103002434.GA3199@redhat.com>
References: <20171227032257.8182-1-snitzer@redhat.com>
 <20180102232943.GC26533@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180102232943.GC26533@localhost.localdomain>
Sender: linux-block-owner@vger.kernel.org
To: Keith Busch <keith.busch@intel.com>
Cc: axboe@kernel.dk, hch@lst.de, emilne@redhat.com, james.smart@broadcom.com, hare@suse.de, Bart.VanAssche@wdc.com, linux-block@vger.kernel.org, linux-nvme@lists.infradead.org, dm-devel@redhat.com
List-Id: dm-devel.ids

On Tue, Jan 02 2018 at  6:29pm -0500,
Keith Busch <keith.busch@intel.com> wrote:

> Instead of hiding NVMe path related errors, the NVMe driver needs to
> code an appropriate generic block status from an NVMe status.
> 
> We already do this translation whether or not CONFIG_NVME_MULTIPATHING is
> set, so I think it's silly NVMe native multipathing has a second status
> decoder. This just doubles the work if we need to handle any new NVMe
> status codes in the future.
> 
> I have a counter-proposal below that unifies NVMe-to-block status
> translations, and combines common code for determining if an error is a
> path failure. This should work for both NVMe and DM, and DM won't need
> NVMe specifics.

I'm happy with this approach.

FYI, I did recently invert the logic on dm-mpath.c:noretry_error() and
staged for 4.16, see:
https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=dm-4.16&id=806f913a543e30d0d608a823b11613bbeeba1f6d
But I can drop that patch and rebase accordingly.

Also, I think a better name for blk_path_failure() would be
blk_retryable_error()?  Don't feel that strongly about it though.

> I can split this into a series if there's indication this is ok and
> satisfies the need.

Don't think it needs to be a series, having it be a single patch shows
why it makes sense to elevate the retryable error check to block core.

But maybe Jens will be able to give you more guidance on what he'd like
to see.

I'd very much like to see this land in 4.16.

Thanks!
Mike
