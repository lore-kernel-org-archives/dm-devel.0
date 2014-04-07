From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: block: use kmalloc alignment for bio slab
Date: Mon, 7 Apr 2014 14:15:50 -0400
Message-ID: <20140407181550.GA30132@redhat.com>
References: <1396461856-27243-1-git-send-email-snitzer@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1396461856-27243-1-git-send-email-snitzer@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: axboe@fb.com
Cc: dm-devel@redhat.com, mpatocka@redhat.com, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

On Wed, Apr 02 2014 at  2:04pm -0400,
Mike Snitzer <snitzer@redhat.com> wrote:

> From: Mikulas Patocka <mpatocka@redhat.com>
> 
> Various subsystems can ask the bio subsystem to create a bio slab cache
> with some free space before the bio.  This free space can be used for any
> purpose.  Device mapper uses this per-bio-data feature to place some
> target-specific and device-mapper specific data before the bio, so that
> the target-specific data doesn't have to be allocated separately.
> 
> This per-bio-data mechanism is used in place of kmalloc, so we need the
> allocated slab to have the same memory alignment as memory allocated
> with kmalloc.
> 
> Change bio_find_or_create_slab() so that it uses ARCH_KMALLOC_MINALIGN
> alignment when creating the slab cache.  This is needed so that dm-crypt
> can use per-bio-data for encryption - the crypto subsystem assumes this
> data will have the same alignment as kmalloc'ed memory.
> 
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> Signed-off-by: Mike Snitzer <snitzer@redhat.com>

Hey Jens,

Just wanted to give you a heads up that I staged this patch in
linux-dm.git's 'for-next', here:
https://git.kernel.org/cgit/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=for-next&id=cd433c25f43eb054f62b7b48f1d0349f65b1740c

I rebased it to add this yesterday:
Acked-by: Jens Axboe <axboe@fb.com> # via private exchange on facebook

I put this in place because there is a chance I'll still be sending the
improved dm-crypt parallelization patches to Linus for 3.15 this week.
So having this go through linux-dm.git saves the awkward coordination
where otherwise DM would be depending on the block tree.

You OK with this?
