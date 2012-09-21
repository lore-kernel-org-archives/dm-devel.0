From: Kent Overstreet <koverstreet@google.com>
Subject: Re: [PATCH v2 19/26] bounce: Refactor __blk_queue_bounce to not use
 bi_io_vec
Date: Thu, 20 Sep 2012 17:34:22 -0700
Message-ID: <20120921003422.GN5519@google.com>
References: <1347322957-25260-1-git-send-email-koverstreet@google.com>
 <1347322957-25260-20-git-send-email-koverstreet@google.com>
 <20120921002706.GW7264@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20120921002706.GW7264@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org, dm-devel@redhat.com, axboe@kernel.dk, neilb@suse.de
List-Id: dm-devel.ids

On Thu, Sep 20, 2012 at 05:27:06PM -0700, Tejun Heo wrote:
> On Mon, Sep 10, 2012 at 05:22:30PM -0700, Kent Overstreet wrote:
> > A bunch of what __blk_queue_bounce() was doing was problematic for the
> > immutable bvec work; this cleans that up and the code is quite a bit
> > smaller, too.
> > 
> > The __bio_for_each_segment() in copy_to_high_bio_irq() was changed
> > because that one's looping over the original bio, not the bounce bio -
> > since the bounce code doesn't own that bio the __ version wasn't
> > correct.
> 
> Also, I can't understand the above at all.  I can think why it
> wouldn't be necessary but why is it wrong because bounce code doesn't
> own it?

Another prep work thing - in current code, it isn't really wrong
(slightly inconsistent though).

But the idea is that anything that doesn't own the bio shouldn't assume
anything about bi_idx; the bounce code should loop over the bio starting
from wherever it was when the bio got to the bounce code, not the start
of the bio.

A later patch makes this clearer - __bio_for_each_segment() gets removed
in favor of bio_for_each_segment_all(), and it documents that
bio_for_each_segment_all() is only for code that owns the bio.
