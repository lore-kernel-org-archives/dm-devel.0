From: huang ying <huang.ying.caritas@gmail.com>
Subject: Re: [dm-devel] [PATCH] DM-CRYPT: Scale to multiple CPUs
Date: Tue, 1 Jun 2010 09:46:17 +0800
Message-ID: <AANLkTimpMn0KJO8u2McP4Z56WeHXqmneFCKkq7BFjhrR@mail.gmail.com>
References: <20100531160425.GA20344@basil.fritz.box>
	<4C03F04D.4040200@redhat.com>
	<20100531174225.GE10766@basil.fritz.box>
	<4C03FB8E.1060109@redhat.com>
	<20100531182724.GG10766@basil.fritz.box>
	<4C040636.8060702@redhat.com>
	<20100531190400.GH10766@basil.fritz.box>
	<20100531220700.GA23076@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20100531220700.GA23076@gondor.apana.org.au>
Sender: linux-kernel-owner@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Andi Kleen <andi@firstfloor.org>, Milan Broz <mbroz@redhat.com>, device-mapper development <dm-devel@redhat.com>, linux-kernel@vger.kernel.org, agk@redhat.com, ak@linux.intel.com
List-Id: dm-devel.ids

On Tue, Jun 1, 2010 at 6:07 AM, Herbert Xu <herbert@gondor.apana.org.au=
> wrote:
> On Mon, May 31, 2010 at 09:04:00PM +0200, Andi Kleen wrote:
>> > I mean how it is implemented now in crypto API, and I was almost
>> > sure that aes-ni acceleration code uses cryptd (iow real asynchron=
ous processing)
>> > and also that not all CPU cores can run these instruction in paral=
lel.
>>
>> I think you can configure it to use cryptd (or pcrypt), but it's not=
 default
>> and usually higher overhead.
>
> Right. =C2=A0The only reason aes-ni uses the async interface is to
> work around the fact that you have to save FPU state when using
> it. =C2=A0For dm-crypt you can consider it to be synchronous.

The reason for aes-ni to use async interface is that the FPU/SSE
instructions enclosed by kernel_fpu_begin and kernel_fpu_end is not
reentranceable. That is, it is not safe to use FPU/SSE instructions in
interrupt context, if the instructions are used in interrupted
context. So irq_fpu_usable is used in the async interface of aes-ni,
and go asynchronous implementation only if !irq_fpu_usable. In most
instances, the async interface of aes-ni will run in synchronous mode.

Best Regards,
Huang Ying
