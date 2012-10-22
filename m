From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH v4 1/2] block: Fix a buffer overrun in
 bio_integrity_split()
Date: Mon, 22 Oct 2012 11:39:07 -0400
Message-ID: <20121022153907.GC3401@redhat.com>
References: <1350331769-14856-1-git-send-email-koverstreet@google.com>
 <1350331769-14856-28-git-send-email-koverstreet@google.com>
 <20121019203015.GS13370@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20121019203015.GS13370@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: Kent Overstreet <koverstreet@google.com>, linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org, dm-devel@redhat.com, axboe@kernel.dk, martin.petersen@oracle.com
List-Id: dm-devel.ids

On Fri, Oct 19, 2012 at 01:30:15PM -0700, Tejun Heo wrote:
> On Mon, Oct 15, 2012 at 01:09:01PM -0700, Kent Overstreet wrote:
> > bio_integrity_split() seemed to be confusing pointers and arrays -
> > bip_vec in bio_integrity_payload was an array appended to the end of the
> > payload, so the bio_vecs in struct bio_pair should have come after the
> > bio_integrity_payload they're for.
> > 
> > Fix it by making bip_vec a pointer to the inline vecs - a later patch is
> > going to make more use of this pointer.
> > 
> > Signed-off-by: Kent Overstreet <koverstreet@google.com>
> > CC: Jens Axboe <axboe@kernel.dk>
> > CC: Martin K. Petersen <martin.petersen@oracle.com>
> 
> This being an apparent bug, I think it would be better to create a
> patch to simply reorder bio_pair fields to fix it and mark it w/ Cc:
> stable and introduce bip_vec pointer separately.

Initially he had reordered the bio_pair fields but there were couple of
issues. We could not assume that there is no padding between fields and
secondly some of the initializtion of looked plain ugly.

IMHO, introduction of bip_vec to fix this issue is small and cleaner
then reordering fields.

Thanks
Vivek
