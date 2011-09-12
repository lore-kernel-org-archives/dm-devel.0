From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 1/2] block: export __make_request
Date: Mon, 12 Sep 2011 20:04:46 +0200
Message-ID: <4E6E49BE.6020005@kernel.dk>
References: <20110911145053.GA28996@infradead.org> <4E6DD7F0.8020903@kernel.dk> <20110912122507.GA12229@infradead.org> <4E6DFA8C.3030400@kernel.dk> <20110912133826.GA22548@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110912133826.GA22548@infradead.org>
Sender: linux-raid-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-raid@vger.kernel.org, dm-devel@redhat.com, linux-kernel@vger.kernel.org, bharrosh@panasas.com
List-Id: dm-devel.ids

On 2011-09-12 15:38, Christoph Hellwig wrote:
> On Mon, Sep 12, 2011 at 02:26:52PM +0200, Jens Axboe wrote:
>>> What happens to the existing blk_make_request?
>>
>> I ended up naming __make_request() blk_queue_bio() instead.
> 
> I really hate naming things different from the method they are
> implementing.  I've tried to figure out what the point of the
> old blk_make_request is - why would we not go through
> generic_make_request for this?
> 
> Boaz, any idea?

I tend to agree, we could rename the existing blk_make_request(). It
could be blk_make_request_from_bio() or something like that, since
that's what it does.

-- 
Jens Axboe

