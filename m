From: Eric Biggers <ebiggers@kernel.org>
Subject: Re: [dm-crypt] [RFC PATCH 1/1] Add DM_CRYPT_FORCE_INLINE flag to
 dm-crypt target
Date: Wed, 24 Jun 2020 09:24:07 -0700
Message-ID: <20200624162407.GB200774@gmail.com>
References: <20200619164132.1648-1-ignat@cloudflare.com>
 <20200619164132.1648-2-ignat@cloudflare.com>
 <20200624050452.GB844@sol.localdomain>
 <CALrw=nFduv_X83V1Dfz+bt4bZqT19OSi3q5f7umhty1-DQ2SPg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CALrw=nFduv_X83V1Dfz+bt4bZqT19OSi3q5f7umhty1-DQ2SPg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Ignat Korchagin <ignat@cloudflare.com>
Cc: agk@redhat.com, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, dm-crypt@saout.de, linux-kernel <linux-kernel@vger.kernel.org>, kernel-team <kernel-team@cloudflare.com>
List-Id: dm-devel.ids

On Wed, Jun 24, 2020 at 09:24:07AM +0100, Ignat Korchagin wrote:
> On Wed, Jun 24, 2020 at 6:04 AM Eric Biggers <ebiggers@kernel.org> wrote:
> >
> > On Fri, Jun 19, 2020 at 05:41:32PM +0100, Ignat Korchagin wrote:
> > > Sometimes extra thread offloading imposed by dm-crypt hurts IO latency. This is
> > > especially visible on busy systems with many processes/threads. Moreover, most
> > > Crypto API implementaions are async, that is they offload crypto operations on
> > > their own, so this dm-crypt offloading is excessive.
> >
> > This really should say "some Crypto API implementations are async" instead of
> > "most Crypto API implementations are async".
> 
> The most accurate would probably be: most hardware-accelerated Crypto
> API implementations are async
> 
> > Notably, the AES-NI implementation of AES-XTS is synchronous if you call it in a
> > context where SIMD instructions are usable.  It's only asynchronous when SIMD is
> > not usable.  (This seems to have been missed in your blog post.)
> 
> No, it was not. This is exactly why we made xts-proxy Crypto API
> module as a second patch. But it seems now it does not make a big
> difference if a used Crypto API implementation is synchronous as well
> (based on some benchmarks outlined in the cover letter to this patch).
> I think the v2 of this patch will not require a synchronous Crypto
> API. This is probably a right thing to do, as the "inline" flag should
> control the way how dm-crypt itself handles requests, not how Crypto
> API handles requests. If a user wants to ensure a particular
> synchronous Crypto API implementation, they can already reconfigure
> dm-crypt and specify the implementation with a "capi:" prefix in the
> the dm table description.

I think you're missing the point.  Although xts-aes-aesni has the
CRYPTO_ALG_ASYNC bit set, the actual implementation processes the request
synchronously if SIMD instructions are currently usable.  That's always the case
in dm-crypt, as far as I can tell.  This algorithm has the ASYNC flag only
because it's not synchronous when called in hardIRQ context.

That's why your "xts-proxy" doesn't make a difference, and why it's misleading
to suggest that the crypto API is doing its own queueing when you're primarily
talking about xts-aes-aesni.  The crypto API definitely can do its own queueing,
mainly with hardware drivers.  But it doesn't in this common and relevant case.

- Eric
