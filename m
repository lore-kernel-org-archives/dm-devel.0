From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 2/2] block: remove support for bio remapping from ->make_request
Date: Mon, 12 Sep 2011 14:26:03 +0200
Message-ID: <4E6DFA5B.1000305@kernel.dk>
References: <20110911145053.GA28996@infradead.org> <20110911145129.GA29504@infradead.org> <4E6DD818.80902@kernel.dk> <20110912122528.GB12229@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110912122528.GB12229@infradead.org>
Sender: linux-raid-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-raid@vger.kernel.org, dm-devel@redhat.com, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

On 2011-09-12 14:25, Christoph Hellwig wrote:
> On Mon, Sep 12, 2011 at 11:59:52AM +0200, Jens Axboe wrote:
>> On 2011-09-11 16:51, Christoph Hellwig wrote:
>>> There is very little benefit in allowing to let a ->make_request
>>> instance update the bios device and sector and loop around it in
>>> __generic_make_request when we can archive the same through calling
>>> generic_make_request from the driver and letting the loop in
>>> generic_make_request handle it.
>>
>> Agree, this looks good! Will apply for 3.2.
> 
> Are you going to fix the issue Neil pointed out beforehand?

Yep, I merged that one in with the 2/2 patch and added his Acked-by as
well.

-- 
Jens Axboe

