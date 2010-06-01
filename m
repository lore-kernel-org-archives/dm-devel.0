From: Andi Kleen <ak@linux.intel.com>
Subject: Re: [dm-devel] [PATCH] DM-CRYPT: Scale to multiple CPUs
Date: Tue, 01 Jun 2010 08:40:46 +0200
Message-ID: <4C04AB6E.1080305@linux.intel.com>
References: <20100531160425.GA20344@basil.fritz.box> <Pine.LNX.4.64.1005312239520.6372@hs20-bc2-1.build.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.1005312239520.6372@hs20-bc2-1.build.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>, herbert@gondor.hengli.com.au, linux-kernel@vger.kernel.org, agk@redhat.com
List-Id: dm-devel.ids

, Mikulas Patocka wrote:
> Questions:
>
> If you are optimizing it,
>
> 1) why don't you optimize it in such a way that if one CPU submits
> requests, the crypto work is spread among all the CPUs? Currently it
> spreads the work only if different CPUs submit it.

This case is only useful with very slow CPUs and is handled by pcrypt
in theory

(but I haven't tested it)

>
> 2) why not optimize software async crypto daemon (crypt/cryptd.c) instead
> of dm-crypt, so that all kernel subsystems can actually take advantage of
> those multi-CPU optimizations, not just dm-crypt?

Normally most subsystems are multi-CPU already, unless they limit
themselves artitifically like dm-crypt.

For dm-crypt would be wasteful to funnel everything through two single CPU threads just
to spread it out again.  That is why I also used per CPU IO threads too.

-Andi
