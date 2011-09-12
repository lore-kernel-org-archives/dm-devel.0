From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/2] block: export __make_request
Date: Mon, 12 Sep 2011 08:25:07 -0400
Message-ID: <20110912122507.GA12229@infradead.org>
References: <20110911145053.GA28996@infradead.org>
 <4E6DD7F0.8020903@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4E6DD7F0.8020903@kernel.dk>
Sender: linux-raid-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@infradead.org>, linux-raid@vger.kernel.org, dm-devel@redhat.com, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

On Mon, Sep 12, 2011 at 11:59:12AM +0200, Jens Axboe wrote:
> On 2011-09-11 16:50, Christoph Hellwig wrote:
> > Avoid the hacks need for request based device mappers currently by simply
> > exporting the symbol instead of trying to get it through the back door.
> 
> Good idea, lets rename it to blk_make_request() at the same time though.
> I'll merge it as such.

What happens to the existing blk_make_request?

