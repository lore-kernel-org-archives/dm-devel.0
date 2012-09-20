From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v2 11/26] raid10: Use bio_reset()
Date: Thu, 20 Sep 2012 16:59:25 -0700
Message-ID: <20120920235925.GR7264@google.com>
References: <1347322957-25260-1-git-send-email-koverstreet@google.com>
 <1347322957-25260-12-git-send-email-koverstreet@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1347322957-25260-12-git-send-email-koverstreet@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Kent Overstreet <koverstreet@google.com>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org, dm-devel@redhat.com, axboe@kernel.dk, neilb@suse.de
List-Id: dm-devel.ids

On Mon, Sep 10, 2012 at 05:22:22PM -0700, Kent Overstreet wrote:
> More prep work for immutable bio vecs, mainly getting rid of references
> to bi_idx.
> 
> bio_reset was being open coded in a few places. The one in sync_request
> was a bit nontrivial to convert, so could use some extra eyeballs.
> 
> Signed-off-by: Kent Overstreet <koverstreet@google.com>
> CC: Jens Axboe <axboe@kernel.dk>
> CC: NeilBrown <neilb@suse.de>

No idea at all.  Neil?

Thanks.

-- 
tejun
