From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 1/2] block: export __make_request
Date: Mon, 12 Sep 2011 11:59:12 +0200
Message-ID: <4E6DD7F0.8020903@kernel.dk>
References: <20110911145053.GA28996@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110911145053.GA28996@infradead.org>
Sender: linux-raid-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-raid@vger.kernel.org, dm-devel@redhat.com, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

On 2011-09-11 16:50, Christoph Hellwig wrote:
> Avoid the hacks need for request based device mappers currently by simply
> exporting the symbol instead of trying to get it through the back door.

Good idea, lets rename it to blk_make_request() at the same time though.
I'll merge it as such.

-- 
Jens Axboe

