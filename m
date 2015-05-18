From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH for-4.2 01/14] block: remove management of bi_remaining
 when restoring original bi_end_io
Date: Mon, 18 May 2015 11:59:48 -0400
Message-ID: <20150518155948.GE13998@redhat.com>
References: <1431637512-64245-1-git-send-email-snitzer@redhat.com>
 <1431637512-64245-2-git-send-email-snitzer@redhat.com>
 <20150518072237.GE26351@quack.suse.cz>
 <20150518131358.GA13998@redhat.com>
 <20150518153644.GA10187@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150518153644.GA10187@quack.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Cc: Jens Axboe <axboe@kernel.dk>, Chris Mason <clm@fb.com>, dm-devel@redhat.com, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

On Mon, May 18 2015 at 11:36am -0400,
Jan Kara <jack@suse.cz> wrote:
 
>   No, I'm not referring to your proposed interface. I'm referring to
> current kernel + your patch to remove bio_inc_remaining() from all the dm
> targets. Ah, after checking again I see where misunderstanding may have
> come from - the device below has to be handled by drivers/md/linear.c which
> is MD linear driver, not DM one. I confused those two. Anyway here is the
> failure I envision (and frankly, I don't understand dm details much so I may
> be just completely wrong but I'd like to understand what prevents the following
> from happening):
> * We have dm-thin stacked on top of drivers/dm/linear.c
> * FS issues bio to dm-thin. remap_and_issue_overwrite() sets bi_end_io to
>   overwrite_endio. dm-thin eventually calls generic_make_request(bio).
> * Now linear_make_request() gets called and it ends up calling
>   bio_chain(split, bio). This sets BIO_CHAIN on bio.
> * IO for all chained bios is completed. So bio->bi_remaining is now zero,
>   bio still has BIO_CHAIN set and overwrite_endio gets called.
> * process_prepared_mapping() will eventually try to call original bi_end_io
>   callback but that never happens because bi_remaining is 0 and BIO_CHAIN
>   remained set.

Makes sense, you have a valid concern (I knew you and hch must, I just
didn't understand).

I'll clear the BIO_CHAIN like you suggest and post v2.

Thanks!
