From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [dm-devel] [PATCH v3 02/26] block: Convert integrity to
 bvec_alloc_bs()
Date: Tue, 2 Oct 2012 11:12:02 -0400
Message-ID: <20121002151202.GE758@redhat.com>
References: <1348526106-17074-1-git-send-email-koverstreet@google.com>
 <1348526106-17074-3-git-send-email-koverstreet@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1348526106-17074-3-git-send-email-koverstreet@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Kent Overstreet <koverstreet@google.com>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org, dm-devel@redhat.com, axboe@kernel.dk, "Martin K. Petersen" <martin.petersen@oracle.com>, tj@kernel.org
List-Id: dm-devel.ids

On Mon, Sep 24, 2012 at 03:34:42PM -0700, Kent Overstreet wrote:
> This adds a pointer to the bvec array to struct bio_integrity_payload,
> instead of the bvecs always being inline; then the bvecs are allocated
> with bvec_alloc_bs().

Ok, you are introducing bio_vec pointer in this patch. May be we can
do it earlier so that we take care of bio pair related issue.

> 
> Changed bvec_alloc_bs() and bvec_free_bs() to take a pointer to a
> mempool instead of the bioset, so that bio integrity can use a different
> mempool for its bvecs, and thus avoid a potential deadlock.

If you are taking mempool as input, then bvec_alloc_bs() name does not
make sense, as I think the very fact "bs" in the name their suggests
that you are taking a pointer to bio set (and not mempool).

Given the fact that bio_vec pool for integrity inside bio set, why not
take additional boolean/enum argument to function bvec_alloc_bs() and
that argument can tell whehter to allocate bvec from which bvec pool.

> 
> This is eventually for immutable bio vecs - immutable bvecs aren't
> useful if we still have to copy them, hence the need for the pointer.
> Less code is always nice too, though.

Can you explain a bit more about immutable bio vecs. I know there was
some discussion and I missed it. So either point me to right mail thread
or just explain a bit more what are immutable bio vecs, how we are
planning to use these.

Is it about during split we don't want to copy bio vecs and that's why we
need a pointer so that newly created bio/bip can point to parent's bio_vec?

Thanks
Vivek
