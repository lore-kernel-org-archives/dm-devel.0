From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH v2] block: directly insert blk-mq request from
 blk_insert_cloned_request()
Date: Mon, 11 Sep 2017 14:51:07 -0600
Message-ID: <79287d3a-62e0-912e-dcad-e7ab5297ae34@kernel.dk>
References: <20170907155255.GA22848@redhat.com>
 <756D2B3A-CD5A-4351-BC39-C2BAB771C740@linaro.org>
 <20170908164129.GA48286@redhat.com>
 <113c15ac-75f5-ff5b-695d-920dc6d5f708@kernel.dk>
 <20170908170727.GA29318@redhat.com> <20170908195805.GA30517@redhat.com>
 <57b4bb39-f50c-ad5e-d47d-01f0f84ec3ca@kernel.dk>
 <20170908214236.GA49918@redhat.com>
 <49cc6184-48da-2a45-e50e-13430e14e197@kernel.dk>
 <20170908220318.GA31120@redhat.com> <20170911161647.GA55061@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170911161647.GA55061@redhat.com>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: Paolo Valente <paolo.valente@linaro.org>, Bart Van Assche <Bart.VanAssche@wdc.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, dm-devel@redhat.com
List-Id: dm-devel.ids

On 09/11/2017 10:16 AM, Mike Snitzer wrote:
> Here is v2 that should obviate the need to rename blk_mq_insert_request
> (by using bools to control run_queue and async).
> 
> As for inserting directly into dispatch, if that can be done that is
> great but I'd prefer to have that be a follow-up optimization.  This
> fixes the regression in question, and does so in well-known terms.
> 
> What do you think?

I think it looks reasonable. My only concern is the use of the software
queues. Depending on the scheduler, they may or may not be used. I'd
need to review the code, but my first thought is that this would break
if you use blk_mq_insert_request() on a device that is managed by
mq-deadline or bfq, for instance. Schedulers are free to use the
software queues, but they are also free to ignore them and use internal
queuing.

Looking at the code, looks like this was changed slightly at some point,
we always flush the software queues, if any of them contain requests. So
it's probably fine.

My earlier suggestion to use just hctx->dispatch for the IO and bypass
the software queues completely. The use case for the dispatch list is
the same, regardless of whether the device has a scheduler attached or
not.

-- 
Jens Axboe
