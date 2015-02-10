From: Dongsu Park <dongsu.park@profitbricks.com>
Subject: Re: [PATCH] dm: fix multipath regression due to initializing wrong
 request
Date: Tue, 10 Feb 2015 11:42:09 +0100
Message-ID: <20150210104209.GA13686@posteo.de>
References: <20150209163856.GA12781@posteo.de>
 <20150209164855.GB1599@redhat.com>
 <alpine.LNX.2.00.1502091651310.15481@localhost.lm.intel.com>
 <20150209171311.GC1599@redhat.com>
 <20150209173514.GA14199@redhat.com>
 <54D8F2A7.6050501@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <54D8F2A7.6050501@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: Mike Snitzer <snitzer@redhat.com>, Keith Busch <keith.busch@intel.com>, dm-devel@redhat.com, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

On 09.02.2015 10:47, Jens Axboe wrote:
> On 02/09/2015 10:35 AM, Mike Snitzer wrote:
> >On Mon, Feb 09 2015 at 12:13P -0500,
> >Mike Snitzer <snitzer@redhat.com> wrote:
> >
> >Jens and I discussed this further and given that linux-block breaks
> >dm-multipath it is best to fix linux-block and let Linus resolve the
> >merge when I send him the linux-dm pull.
> >
> >Here is the patch to fix the regression:
> 
> Added, thanks. I don't think this is worth rebasing for, so just added to
> the top of for-3.20/core (since that's where the buggy commit was added).

Thanks a lot. Now the branch for-3.20/core works without hitting the BUG.

Dongsu

> -- 
> Jens Axboe
> 
