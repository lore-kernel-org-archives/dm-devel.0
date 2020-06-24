From: Ignat Korchagin <ignat@cloudflare.com>
Subject: Re: [dm-crypt] [RFC PATCH 1/1] Add DM_CRYPT_FORCE_INLINE flag to
 dm-crypt target
Date: Wed, 24 Jun 2020 09:24:07 +0100
Message-ID: <CALrw=nFduv_X83V1Dfz+bt4bZqT19OSi3q5f7umhty1-DQ2SPg@mail.gmail.com>
References: <20200619164132.1648-1-ignat@cloudflare.com> <20200619164132.1648-2-ignat@cloudflare.com>
 <20200624050452.GB844@sol.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20200624050452.GB844@sol.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
To: Eric Biggers <ebiggers@kernel.org>
Cc: agk@redhat.com, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, dm-crypt@saout.de, linux-kernel <linux-kernel@vger.kernel.org>, kernel-team <kernel-team@cloudflare.com>
List-Id: dm-devel.ids

On Wed, Jun 24, 2020 at 6:04 AM Eric Biggers <ebiggers@kernel.org> wrote:
>
> On Fri, Jun 19, 2020 at 05:41:32PM +0100, Ignat Korchagin wrote:
> > Sometimes extra thread offloading imposed by dm-crypt hurts IO latency. This is
> > especially visible on busy systems with many processes/threads. Moreover, most
> > Crypto API implementaions are async, that is they offload crypto operations on
> > their own, so this dm-crypt offloading is excessive.
>
> This really should say "some Crypto API implementations are async" instead of
> "most Crypto API implementations are async".

The most accurate would probably be: most hardware-accelerated Crypto
API implementations are async

> Notably, the AES-NI implementation of AES-XTS is synchronous if you call it in a
> context where SIMD instructions are usable.  It's only asynchronous when SIMD is
> not usable.  (This seems to have been missed in your blog post.)

No, it was not. This is exactly why we made xts-proxy Crypto API
module as a second patch. But it seems now it does not make a big
difference if a used Crypto API implementation is synchronous as well
(based on some benchmarks outlined in the cover letter to this patch).
I think the v2 of this patch will not require a synchronous Crypto
API. This is probably a right thing to do, as the "inline" flag should
control the way how dm-crypt itself handles requests, not how Crypto
API handles requests. If a user wants to ensure a particular
synchronous Crypto API implementation, they can already reconfigure
dm-crypt and specify the implementation with a "capi:" prefix in the
the dm table description.

> > This adds a new flag, which directs dm-crypt not to offload crypto operations
> > and process everything inline. For cases, where crypto operations cannot happen
> > inline (hard interrupt context, for example the read path of the NVME driver),
> > we offload the work to a tasklet rather than a workqueue.
>
> This patch both removes some dm-crypt specific queueing, and changes decryption
> to use softIRQ context instead of a workqueue.  It would be useful to know how
> much of a difference the workqueue => softIRQ change makes by itself.  Such a
> change could be useful for fscrypt as well.  (fscrypt uses a workqueue for
> decryption, but besides that doesn't use any other queueing.)
>
> > @@ -127,7 +128,7 @@ struct iv_elephant_private {
> >   * and encrypts / decrypts at the same time.
> >   */
> >  enum flags { DM_CRYPT_SUSPENDED, DM_CRYPT_KEY_VALID,
> > -          DM_CRYPT_SAME_CPU, DM_CRYPT_NO_OFFLOAD };
> > +          DM_CRYPT_SAME_CPU, DM_CRYPT_NO_OFFLOAD, DM_CRYPT_FORCE_INLINE = (sizeof(unsigned long) * 8 - 1) };
>
> Assigning a specific enum value isn't necessary.

Yes, this is a leftover from our "internal" patch which I wanted to
make "future proof" in case future iterations of dm-crypt will add
some flags to avoid flag collisions. Will remove in v2.

>
> > @@ -1458,13 +1459,18 @@ static void crypt_alloc_req_skcipher(struct crypt_config *cc,
> >
> >       skcipher_request_set_tfm(ctx->r.req, cc->cipher_tfm.tfms[key_index]);
> >
> > -     /*
> > -      * Use REQ_MAY_BACKLOG so a cipher driver internally backlogs
> > -      * requests if driver request queue is full.
> > -      */
> > -     skcipher_request_set_callback(ctx->r.req,
> > -         CRYPTO_TFM_REQ_MAY_BACKLOG,
> > -         kcryptd_async_done, dmreq_of_req(cc, ctx->r.req));
> > +     if (test_bit(DM_CRYPT_FORCE_INLINE, &cc->flags))
> > +             /* make sure we zero important fields of the request */
> > +             skcipher_request_set_callback(ctx->r.req,
> > +             0, NULL, NULL);
> > +     else
> > +             /*
> > +              * Use REQ_MAY_BACKLOG so a cipher driver internally backlogs
> > +              * requests if driver request queue is full.
> > +              */
> > +             skcipher_request_set_callback(ctx->r.req,
> > +             CRYPTO_TFM_REQ_MAY_BACKLOG,
> > +             kcryptd_async_done, dmreq_of_req(cc, ctx->r.req));
> >  }
>
> This looks wrong.  Unless type=0 and mask=CRYPTO_ALG_ASYNC are passed to
> crypto_alloc_skcipher(), the skcipher implementation can still be asynchronous,
> in which case providing a callback is required.
>
> Do you intend that the "force_inline" option forces the use of a synchronous
> skcipher (alongside the other things it does)?  Or should it still allow
> asynchronous ones?

As mentioned above, I don't think we should require synchronous crypto
with the "force_inline" flag anymore. Although we may remove
CRYPTO_TFM_REQ_MAY_BACKLOG with the inline flag.

> We may not actually have a choice in that matter, since xts-aes-aesni has the
> CRYPTO_ALG_ASYNC bit set (as I mentioned) despite being synchronous in most
> cases; thus, the crypto API won't give you it if you ask for a synchronous
> cipher.  So I think you still need to allow async skciphers?  That means a
> callback is still always required.
>
> - Eric
