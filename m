From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm mpath: switch IO scheduler of underlying paths to "none"
 [was: Re: BFQ + dm-mpath]
Date: Fri, 8 Sep 2017 15:58:05 -0400
Message-ID: <20170908195805.GA30517@redhat.com>
References: <1503611578.2899.69.camel@wdc.com>
 <AE77899A-0365-4C7C-91E4-5ACCC396B26B@linaro.org>
 <ED23C7AC-F202-40E3-8421-E714BF446399@linaro.org>
 <1504620914.4135.11.camel@wdc.com>
 <20170907155255.GA22848@redhat.com>
 <756D2B3A-CD5A-4351-BC39-C2BAB771C740@linaro.org>
 <20170908164129.GA48286@redhat.com>
 <113c15ac-75f5-ff5b-695d-920dc6d5f708@kernel.dk>
 <20170908170727.GA29318@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170908170727.GA29318@redhat.com>
Sender: linux-block-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: Paolo Valente <paolo.valente@linaro.org>, Bart Van Assche <Bart.VanAssche@wdc.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, dm-devel@redhat.com
List-Id: dm-devel.ids

On Fri, Sep 08 2017 at  1:07pm -0400,
Mike Snitzer <snitzer@redhat.com> wrote:

> On Fri, Sep 08 2017 at 12:48pm -0400,
> Jens Axboe <axboe@kernel.dk> wrote:
> 
> > > Please see the following untested patch.  All
> > > testing/review/comments/acks appreciated.
> > > 
> > > I elected to use elevator_change() rather than fiddle with adding a new
> > > blk-mq elevator hook (e.g. ->request_prepared) to verify that each
> > > blk-mq elevator enabled request did in fact get prepared.
> > > 
> > > Bart, please test this patch and reply with your review/feedback.
> > > 
> > > Jens, if you're OK with this solution please reply with your Ack and
> > > I'll send it to Linus along with the rest of the handful of DM changes I
> > > have for 4.14.
> > 
> > I am not - we used to have this elevator change functionality from
> > inside the kernel, and finally got rid of it when certain drivers killed
> > it. I don't want to be bringing it back.
> 
> Fine.

BTW, while I conceded "Fine": I think your justification for not
reintroducing elevator_change() lacks substance.  What is inherently
problematic about elevator_change()?

Having an elevator attached to a DM multipath device's underlying path's
request_queue just asks for trouble (especially given the blk-mq
elevator interface).

Please own this issue as a regression and help me arrive at a timely way
forward.

Thanks,
Mike
