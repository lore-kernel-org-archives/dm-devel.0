From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/2] block: refactor generic_make_request
Date: Mon, 12 Sep 2011 11:13:10 -0400
Message-ID: <20110912151310.GA7188@infradead.org>
References: <20110911145053.GA28996@infradead.org>
 <20110912134202.GA22953@infradead.org>
 <20110912150935.GA27453@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20110912150935.GA27453@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@kernel.dk>, linux-raid@vger.kernel.org, dm-devel@redhat.com, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

On Mon, Sep 12, 2011 at 11:09:35AM -0400, Vivek Goyal wrote:
> On Mon, Sep 12, 2011 at 09:42:02AM -0400, Christoph Hellwig wrote:
> 
> [..]
> > +
> >  	/* following loop may be a bit non-obvious, and so deserves some
> >  	 * explanation.
> >  	 * Before entering the loop, bio->bi_next is NULL (as all callers
> > @@ -1557,16 +1561,15 @@ void generic_make_request(struct bio *bi
> >  	 * from the top.  In this case we really did just take the bio
> >  	 * of the top of the list (no pretending) and so remove it from
> >  	 * bio_list, and call into __generic_make_request again.
>                                    ^^^^^^^^^^
> You got rid of __generic_make_request(). Now above comment has stale
> reference to it.

Yeah, this should be ->make_request now.

