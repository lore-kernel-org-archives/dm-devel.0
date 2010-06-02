From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [dm-devel] [PATCH] DM-CRYPT: Scale to multiple CPUs
Date: Wed, 2 Jun 2010 01:15:43 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.1006020110220.22695@hs20-bc2-1.build.redhat.com>
References: <20100531160425.GA20344@basil.fritz.box>
 <Pine.LNX.4.64.1005312239520.6372@hs20-bc2-1.build.redhat.com>
 <4C04AB6E.1080305@linux.intel.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4C04AB6E.1080305@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andi Kleen <ak@linux.intel.com>
Cc: device-mapper development <dm-devel@redhat.com>, herbert@gondor.hengli.com.au, linux-kernel@vger.kernel.org, agk@redhat.com
List-Id: dm-devel.ids



On Tue, 1 Jun 2010, Andi Kleen wrote:

> , Mikulas Patocka wrote:
> > Questions:
> > 
> > If you are optimizing it,
> > 
> > 1) why don't you optimize it in such a way that if one CPU submits
> > requests, the crypto work is spread among all the CPUs? Currently it
> > spreads the work only if different CPUs submit it.
> 
> This case is only useful with very slow CPUs and is handled by pcrypt
> in theory
> 
> (but I haven't tested it)

Almost every CPU is "very slow" so that it lags behind disk when 
encrypting. CPUs with hardware AES may be the exception.

> > 2) why not optimize software async crypto daemon (crypt/cryptd.c) instead
> > of dm-crypt, so that all kernel subsystems can actually take advantage of
> > those multi-CPU optimizations, not just dm-crypt?
> 
> Normally most subsystems are multi-CPU already, unless they limit
> themselves artitifically like dm-crypt.
> 
> For dm-crypt would be wasteful to funnel everything through two single CPU
> threads just
> to spread it out again.  That is why I also used per CPU IO threads too.

If one CPU submits I/O for 10MB of data, your patch makes no 
paralelization at all. Because all those 10MB will be encrypted by the 
same CPU that submitted it.

> -Andi

Mikulas
