From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [GIT PULL] block changes to improve device mapper for 4.16
Date: Mon, 15 Jan 2018 08:54:25 -0700
Message-ID: <3ac9e975-f1ec-7215-1b53-03b4daa9576e@kernel.dk>
References: <20180115025913.GA20727@redhat.com>
 <36b17d56-bd2b-220a-08c1-8bd44d33f854@kernel.dk>
 <20180115155220.GA16814@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20180115155220.GA16814@redhat.com>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: Ming Lei <ming.lei@redhat.com>, Bart Van Assche <bart.vanassche@wdc.com>, dm-devel@redhat.com, linux-block@vger.kernel.org
List-Id: dm-devel.ids

On 1/15/18 8:52 AM, Mike Snitzer wrote:
> On Mon, Jan 15 2018 at 10:33am -0500,
> Jens Axboe <axboe@kernel.dk> wrote:
> 
>> On 1/14/18 7:59 PM, Mike Snitzer wrote:
> ...
>>> Ming Lei (3):
>>>       blk-mq: move actual issue into __blk_mq_issue_req helper
>>
>> I don't like this patch at all - it's a 10 line function (if that)
>> that ends up with three outputs, two of them hidden in passed
>> in pointers. On top of that, a function that is named
>> __blk_mq_issue_req() and returns bool, you would logically expect
>> a 'true' return to mean that it succeeded. This is the opposite.
>>
>> Not strongly opposed to the rest.
> 
> OK, I'll have a closer look at how to clean it up (and also get with
> Ming).
> 
> In the meantime, you can either cherry-pick my first 4 patches or feel
> free to use this to pull them in:

I took 1-3 initially, added 4 now as well.

-- 
Jens Axboe
