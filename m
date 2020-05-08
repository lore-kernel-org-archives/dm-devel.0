From: kj@orbekk.com
Subject: Re: [PATCH] dm: track io errors per mapped device
Date: Fri, 08 May 2020 15:18:26 -0400
Message-ID: <48580ec0-fc4e-4faa-976f-0fb192cd08fa@www.fastmail.com>
References: <20200507230532.5733-1-kj@orbekk.com>
 <20200508001825.GC22266@agk-dp.fab.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20200508001825.GC22266@agk-dp.fab.redhat.com>
Sender: linux-block-owner@vger.kernel.org
To: Alasdair G Kergon <agk@redhat.com>
Cc: Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, linux-block@vger.kernel.org, harshads@google.com, Khazhismel Kumykov <khazhy@google.com>, orbekk@google.com
List-Id: dm-devel.ids

Hi Alasdair,

Thank you for your time and comments.

On Thu, May 7, 2020, at 20:18, Alasdair G Kergon wrote:
> On Thu, May 07, 2020 at 07:05:33PM -0400, Kjetil Orbekk wrote:
> > This will track ioerr_cnt on all dm targets and expose it as
> > <device>/dm/ioerr_cnt.
> 
> How do you propose to use this?
> What are you trying to measure and why?
> - How exact must the number be to meet your requirements?

This is proposed in order to detect if I/O errors have occurred on the dm device. Deriving this from the ioerr_cnt from the underlying device was considered, but it's not reliable for dm devices that tolerate some underlying errors (raid setups and similar).

> Or to put it another way, do you need to know the exact number you are
> exposing, or do you derive something else from this which could also be
> derived from an alternative number?

Our use case is to detect if I/O errors have happened at all. We expect the ioerr_cnt to increase when there are errors, but the precise number is not important in our environment.

> In particular, given the way we split and clone and stack devices (so
> there may be an element of multiplication), and reload tables (so
> existing values might become irrelevant), did you consider alternative
> semantics before selecting this approach?
>
> (Or to put it another way, is there a need to reset it or track
> the value since the last resume?)

I'm not very familiar with dm and I don't follow how the cloning and stacking will lead to multiplication. Do you have any suggestions for how I might deal with that?

Resetting the value would not be desirable for our use case, because the probing process can miss I/O errors that happen right before a device is suspended and then resumed, though I can imagine that there might be cases where one would want that. Users could look at increases in ioerr_cnt instead of the absolute numbers, or I could provide a way to reset the counter if desired.

> (Documentation is also needed - which ought to explain the semantics
> and how the observed values interact with the use of device-mapper
> features.)

I will be happy to provide an updated patch with inline documentation once I have addressed your comments. Are there any other places where I need to update documentation?

-- 
Stay safe!
KJ
