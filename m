From: Andi Kleen <andi@firstfloor.org>
Subject: Re: [dm-devel] [PATCH] DM-CRYPT: Scale to multiple CPUs
Date: Mon, 31 May 2010 21:04:00 +0200
Message-ID: <20100531190400.GH10766@basil.fritz.box>
References: <20100531160425.GA20344@basil.fritz.box> <4C03F04D.4040200@redhat.com> <20100531174225.GE10766@basil.fritz.box> <4C03FB8E.1060109@redhat.com> <20100531182724.GG10766@basil.fritz.box> <4C040636.8060702@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4C040636.8060702@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Milan Broz <mbroz@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>, device-mapper development <dm-devel@redhat.com>, herbert@gondor.hengli.com.au, linux-kernel@vger.kernel.org, agk@redhat.com, ak@linux.intel.com
List-Id: dm-devel.ids

> I mean how it is implemented now in crypto API, and I was almost
> sure that aes-ni acceleration code uses cryptd (iow real asynchronous processing)
> and also that not all CPU cores can run these instruction in parallel.

I think you can configure it to use cryptd (or pcrypt), but it's not default
and usually higher overhead.

Each CPU core has its own support for AES-NI (it's part
of the SSE units), there's no shared crypto hardware between cores.

There are other systems with separate AES units, but they are
considerably more obscure.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
