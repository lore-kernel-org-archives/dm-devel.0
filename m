From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [RFC PATCH] blk-mq: fixup RESTART when queue becomes idle
Date: Thu, 18 Jan 2018 13:11:01 -0700
Message-ID: <deeb2b2e-6d0e-a144-843d-d08626de8aea@kernel.dk>
References: <20180118024124.8079-1-ming.lei@redhat.com>
 <b2e5b7e6-ce4b-6053-adae-63cc44d773af@wdc.com>
 <20180118170353.GB19734@redhat.com> <1516296056.2676.23.camel@wdc.com>
 <20180118183039.GA20121@redhat.com> <1516301278.2676.35.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <1516301278.2676.35.camel@wdc.com>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>, "snitzer@redhat.com" <snitzer@redhat.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>, "hch@infradead.org" <hch@infradead.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "osandov@fb.com" <osandov@fb.com>, "ming.lei@redhat.com" <ming.lei@redhat.com>
List-Id: dm-devel.ids

On 1/18/18 11:47 AM, Bart Van Assche wrote:
>> This is all very tiresome.
> 
> Yes, this is tiresome. It is very annoying to me that others keep
> introducing so many regressions in such important parts of the kernel.
> It is also annoying to me that I get blamed if I report a regression
> instead of seeing that the regression gets fixed.

I agree, it sucks that any change there introduces the regression. I'm
fine with doing the delay insert again until a new patch is proven to be
better.

From the original topic of this email, we have conditions that can cause
the driver to not be able to submit an IO. A set of those conditions can
only happen if IO is in flight, and those cases we have covered just
fine. Another set can potentially trigger without IO being in flight.
These are cases where a non-device resource is unavailable at the time
of submission. This might be iommu running out of space, for instance,
or it might be a memory allocation of some sort. For these cases, we
don't get any notification when the shortage clears. All we can do is
ensure that we restart operations at some point in the future. We're SOL
at that point, but we have to ensure that we make forward progress.

That last set of conditions better not be a a common occurence, since
performance is down the toilet at that point. I don't want to introduce
hot path code to rectify it. Have the driver return if that happens in a
way that is DIFFERENT from needing a normal restart. The driver knows if
this is a resource that will become available when IO completes on this
device or not. If we get that return, we have a generic run-again delay.

This basically becomes the same as doing the delay queue thing from DM,
but just in a generic fashion.

-- 
Jens Axboe
