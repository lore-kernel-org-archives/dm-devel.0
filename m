From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/2] block: export __make_request
Date: Mon, 12 Sep 2011 09:38:26 -0400
Message-ID: <20110912133826.GA22548@infradead.org>
References: <20110911145053.GA28996@infradead.org>
 <4E6DD7F0.8020903@kernel.dk>
 <20110912122507.GA12229@infradead.org>
 <4E6DFA8C.3030400@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4E6DFA8C.3030400@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@infradead.org>, linux-raid@vger.kernel.org, dm-devel@redhat.com, linux-kernel@vger.kernel.org, bharrosh@panasas.com
List-Id: dm-devel.ids

On Mon, Sep 12, 2011 at 02:26:52PM +0200, Jens Axboe wrote:
> > What happens to the existing blk_make_request?
> 
> I ended up naming __make_request() blk_queue_bio() instead.

I really hate naming things different from the method they are
implementing.  I've tried to figure out what the point of the
old blk_make_request is - why would we not go through
generic_make_request for this?

Boaz, any idea?
