From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH for-4.2 01/14] block: remove management of bi_remaining
 when restoring original bi_end_io
Date: Mon, 18 May 2015 09:20:40 -0400
Message-ID: <20150518132040.GB13998@redhat.com>
References: <1431637512-64245-1-git-send-email-snitzer@redhat.com>
 <1431637512-64245-2-git-send-email-snitzer@redhat.com>
 <20150518082439.GA5439@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150518082439.GA5439@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: dm-devel@redhat.com, Jens Axboe <axboe@kernel.dk>, Chris Mason <clm@fb.com>, Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

On Mon, May 18 2015 at  4:24am -0400,
Christoph Hellwig <hch@infradead.org> wrote:

> In general this looks good.  But as Jan mentioned you need to
> clear BIO_CHAIN when bi_remaining reaches zero

OK I just replied to Jan -- I'm not yet understanding why.  That said, I
also don't have a problem with doing what you guys are asking.  I'd just
like to understand the problem you're forseeing because in practice I'm
not hitting it in testing.

> and I'd really prefer if bio_inc_remaining wuld not be left exported
> and folded into bio_chain so that we prevent new abuses from showing
> up and keep the code centralized.

Your desire to make bio_inc_remaining() private is noted but I think the
proposed blkdev_issue_discard_async() is useful.  In the context of DM
thinp's use of blkdev_issue_discard_async(): yes it is (ab)using
bio_chain() and bio_inc_remaining() to setup the async IO completion
scheme but it makes for a pretty clean solution to the problem of
wanting to have an async interface for discard.
