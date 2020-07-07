From: "hch@lst.de" <hch@lst.de>
Subject: Re: [PATCH 05/11] block: get rid of the trace rq insert wrapper
Date: Tue, 7 Jul 2020 08:57:07 +0200
Message-ID: <20200707065707.GA23805@lst.de>
References: <20200629234314.10509-1-chaitanya.kulkarni@wdc.com> <20200629234314.10509-6-chaitanya.kulkarni@wdc.com> <BYAPR04MB4965DFE805071F971DC8C71C866A0@BYAPR04MB4965.namprd04.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <BYAPR04MB4965DFE805071F971DC8C71C866A0@BYAPR04MB4965.namprd04.prod.outlook.com>
Sender: linux-block-owner@vger.kernel.org
To: Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>
Cc: "hch@lst.de" <hch@lst.de>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "jack@suse.czi" <jack@suse.czi>, "rdunlap@infradead.org" <rdunlap@infradead.org>, "sagi@grimberg.me" <sagi@grimberg.me>, "mingo@redhat.com" <mingo@redhat.com>, "rostedt@goodmis.org" <rostedt@goodmis.org>, "snitzer@redhat.com" <snitzer@redhat.com>, "agk@redhat.com" <agk@redhat.com>, "axboe@kernel.dk" <axboe@kernel.dk>, "paolo.valente@linaro.org" <paolo.valente@linaro.org>, "ming.lei@redhat.com" <ming.lei@redhat.com>, "bvanassche@acm.org" <bvanassche@acm.org>, "fangguoju@gmail.com" <fangguoju@gmail.com>, "colyli@suse.de" <colyli@suse.de>
List-Id: dm-devel.ids

On Fri, Jul 03, 2020 at 11:29:25PM +0000, Chaitanya Kulkarni wrote:
> Christoph,
> 
> On 6/29/20 4:44 PM, Chaitanya Kulkarni wrote:
> > Get rid of the wrapper for trace_block_rq_insert() and call the function
> > directly.
> > 
> > Signed-off-by: Chaitanya Kulkarni<chaitanya.kulkarni@wdc.com>
> > ---
> 
> Can we re-consider adding this patch ? here are couple of reasons:-
> 
> 1. Increase in the size of the text region of the object file:-
> 
>     By adding the trace header #include <trace/events/block.h>
>     in io-scheduler where it is calling trace_block_rq_insert()
>     increases the size of the text region of the object file
>     kyber(+215) & bfq (+317) [1].

You really shouldn't have both loaded, never mind used at the same
time.  It also avoid a function call for the scheduler fast path.

> 2. Mandatory io-sched built-in kernel compilation:-
> 
>     When testing with a different io-sched KConfig options ("*" vs "M"),
>     when kyber and bfq compilation option set to "M" having this patch
>     reports error[2].

See EXPORT_TRACEPOINT_SYMBOL_GPL.
