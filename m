From: Andi Kleen <andi@firstfloor.org>
Subject: Re: [dm-devel] [PATCH] DM-CRYPT: Scale to multiple CPUs v2
Date: Tue, 20 Jul 2010 09:26:22 +0200
Message-ID: <20100720072621.GB30592@basil.fritz.box>
References: <20100601075259.GA13333@basil.fritz.box>
 <4C4444C2.6040607@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4C4444C2.6040607@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Milan Broz <mbroz@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>, Andi Kleen <andi@firstfloor.org>, agk@redhat.com, linux-kernel@vger.kernel.org, eric.dumazet@gmail.com
List-Id: dm-devel.ids

On Mon, Jul 19, 2010 at 02:27:46PM +0200, Milan Broz wrote:
>  On 06/01/2010 09:52 AM, Andi Kleen wrote:
> > DM-CRYPT: Scale to multiple CPUs v2
> >
> > Updated version with the per CPU access improvements Eric suggested.
> Hi,
> 
> seems that this approach is probably the best one we can use now...
> (I would better see threads in crypto layer but that's taken of
> the programme for today, seems.)
> 
> I did some tests and it works for me, even tries some strange stacked
> mapping etc.
> Do you have some exact numbers for particular tests btw?

I had some, but can't find them right now, sorry.

The original motivation was one benchmark on encrypted fs 
which gave terrible results. But unfortunately I didn't get updated
numbers with the patch for that one.

The patch also seems to already have a small user base,
at least I got a few requests for it.

> 
> Anyway, I have just one comment - please can we make the per-cpu attribute
> for IV generic? IOW not add explicit ie (ESSIV) but void * iv_private
> - see attached patch.

Fine for me.

> 
> (I'll try discuss this with Alasdair to review for next merge
> window, I think you requested that already in some private mail...)

Yes. Thanks.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
