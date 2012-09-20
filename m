From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v2 00/26] Prep work for immutable bio vecs
Date: Thu, 20 Sep 2012 16:22:45 -0700
Message-ID: <20120920232245.GH7264@google.com>
References: <1347322957-25260-1-git-send-email-koverstreet@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1347322957-25260-1-git-send-email-koverstreet@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Kent Overstreet <koverstreet@google.com>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org, dm-devel@redhat.com, axboe@kernel.dk, neilb@suse.de, Vivek Goyal <vgoyal@redhat.com>
List-Id: dm-devel.ids

On Mon, Sep 10, 2012 at 05:22:11PM -0700, Kent Overstreet wrote:
> Random assortment of refactoring and trivial cleanups;
> 
> Immutable bio vecs and efficient bio splitting require auditing and
> removing pretty much all bi_idx uses, among other things.
> 
> The reason is that with immutable bio vecs we can't use the bvec array
> directly; if we have a partially completed bvec, that'll be indicated
> with a field in struct bvec_iter (which gets embedded in struct bio) -
> bi_bvec_done.
> 
> bio_for_each_segments() will handle this transparently, so code needs to
> be converted to use it or some other generic accessor.
> 
> Also, bio splitting means that when a driver gets a bio, bi_idx and
> bi_bvec_done may both be nonzero. Again, just need to use generic
> accessors.
> 
> v2: Patch series now has all the prep work to be done before abstracting
> out the bio iterator, I think.

Cc'ing Vivek.  Kent, can you please add Vivek to Cc on block layer
patches?

Vivek, can you please review this series?  It's generic block stuff
and definitely can use your review.

  http://thread.gmane.org/gmane.linux.kernel.bcache.devel/1055

Thanks.

-- 
tejun
