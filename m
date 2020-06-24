From: Ignat Korchagin <ignat@cloudflare.com>
Subject: Re: [dm-crypt] [RFC PATCH 1/1] Add DM_CRYPT_FORCE_INLINE flag to
 dm-crypt target
Date: Wed, 24 Jun 2020 18:00:45 +0100
Message-ID: <CALrw=nG-aduc2F0q=d1LXRG_mxJUSrE3xQHQDRQ_UbAx7TQeiQ@mail.gmail.com>
References: <20200619164132.1648-1-ignat@cloudflare.com> <20200619164132.1648-2-ignat@cloudflare.com>
 <20200624050452.GB844@sol.localdomain> <CALrw=nFduv_X83V1Dfz+bt4bZqT19OSi3q5f7umhty1-DQ2SPg@mail.gmail.com>
 <20200624162407.GB200774@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20200624162407.GB200774@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Eric Biggers <ebiggers@kernel.org>
Cc: agk@redhat.com, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, dm-crypt@saout.de, linux-kernel <linux-kernel@vger.kernel.org>, kernel-team <kernel-team@cloudflare.com>
List-Id: dm-devel.ids

On Wed, Jun 24, 2020 at 5:24 PM Eric Biggers <ebiggers@kernel.org> wrote:
>
> On Wed, Jun 24, 2020 at 09:24:07AM +0100, Ignat Korchagin wrote:
> > On Wed, Jun 24, 2020 at 6:04 AM Eric Biggers <ebiggers@kernel.org> wrote:
> > >
> > > On Fri, Jun 19, 2020 at 05:41:32PM +0100, Ignat Korchagin wrote:
> > > > Sometimes extra thread offloading imposed by dm-crypt hurts IO latency. This is
> > > > especially visible on busy systems with many processes/threads. Moreover, most
> > > > Crypto API implementaions are async, that is they offload crypto operations on
> > > > their own, so this dm-crypt offloading is excessive.
> > >
> > > This really should say "some Crypto API implementations are async" instead of
> > > "most Crypto API implementations are async".
> >
> > The most accurate would probably be: most hardware-accelerated Crypto
> > API implementations are async
> >
> > > Notably, the AES-NI implementation of AES-XTS is synchronous if you call it in a
> > > context where SIMD instructions are usable.  It's only asynchronous when SIMD is
> > > not usable.  (This seems to have been missed in your blog post.)
> >
> > No, it was not. This is exactly why we made xts-proxy Crypto API
> > module as a second patch. But it seems now it does not make a big
> > difference if a used Crypto API implementation is synchronous as well
> > (based on some benchmarks outlined in the cover letter to this patch).
> > I think the v2 of this patch will not require a synchronous Crypto
> > API. This is probably a right thing to do, as the "inline" flag should
> > control the way how dm-crypt itself handles requests, not how Crypto
> > API handles requests. If a user wants to ensure a particular
> > synchronous Crypto API implementation, they can already reconfigure
> > dm-crypt and specify the implementation with a "capi:" prefix in the
> > the dm table description.
>
> I think you're missing the point.  Although xts-aes-aesni has the
> CRYPTO_ALG_ASYNC bit set, the actual implementation processes the request
> synchronously if SIMD instructions are currently usable.  That's always the case
> in dm-crypt, as far as I can tell.  This algorithm has the ASYNC flag only
> because it's not synchronous when called in hardIRQ context.
>
> That's why your "xts-proxy" doesn't make a difference, and why it's misleading
> to suggest that the crypto API is doing its own queueing when you're primarily
> talking about xts-aes-aesni.  The crypto API definitely can do its own queueing,
> mainly with hardware drivers.  But it doesn't in this common and relevant case.

I think we're talking about the same things but from different points
of view. I would like to clarify that the whole post and this change
does not have the intention to focus on aesni (or any x86-specific
crypto optimizations). In fact it is quite the opposite: we want to
optimize the generic dm-crypt regardless of which crypto is used
(that's why I just used a NULL cipher in the cover letter). We also
have some arm64 machines [1] and I bet they would benefit here as
well. The important point my post tries to make is that the original
workqueue offloading in dm-crypt was added because the Crypto API was
synchronous back in the day and, exactly as you say, you may not be
able to use some hw-accelerated crypto in hard IRQ context as well as
doing non-hw crypto in hard IRQ context is a bad idea. Now, most
Crypto API are smart enough to figure out on their own if they should
process the request inline or offload it to a workqueue, so the
workarounds in the dm-crypt itself most likely are not needed. Though,
the generic Crypto API "cipher walk" function does refuse to "walk"
the buffers in hard IRQ context, so the "tasklet" functionality is
still required.

But from the dm-crypt perspective - it should not take into account if
a particular xts-aes-aesni implementation is MOSTLY synchronous -
those are details of the implementation of this particular cipher
dm-crypt has no visibility into. So it would be right to say in my
opinion if the cipher has the CRYPTO_ALG_ASYNC flag set - it can
offload the crypto request to a workqueue at any time. How often does
it do it - that's another story and probably should be reviewed
elsewhere, if it does it too often.

Ignat

[1]: https://blog.cloudflare.com/arm-takes-wing/

> - Eric
