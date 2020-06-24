From: Eric Biggers <ebiggers@kernel.org>
Subject: Re: [dm-crypt] [RFC PATCH 1/1] Add DM_CRYPT_FORCE_INLINE flag to
 dm-crypt target
Date: Tue, 23 Jun 2020 22:04:52 -0700
Message-ID: <20200624050452.GB844@sol.localdomain>
References: <20200619164132.1648-1-ignat@cloudflare.com>
 <20200619164132.1648-2-ignat@cloudflare.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20200619164132.1648-2-ignat@cloudflare.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Ignat Korchagin <ignat@cloudflare.com>
Cc: agk@redhat.com, snitzer@redhat.com, dm-devel@redhat.com, dm-crypt@saout.de, linux-kernel@vger.kernel.org, kernel-team@cloudflare.com
List-Id: dm-devel.ids

On Fri, Jun 19, 2020 at 05:41:32PM +0100, Ignat Korchagin wrote:
> Sometimes extra thread offloading imposed by dm-crypt hurts IO latency. This is
> especially visible on busy systems with many processes/threads. Moreover, most
> Crypto API implementaions are async, that is they offload crypto operations on
> their own, so this dm-crypt offloading is excessive.

This really should say "some Crypto API implementations are async" instead of
"most Crypto API implementations are async".

Notably, the AES-NI implementation of AES-XTS is synchronous if you call it in a
context where SIMD instructions are usable.  It's only asynchronous when SIMD is
not usable.  (This seems to have been missed in your blog post.)

> This adds a new flag, which directs dm-crypt not to offload crypto operations
> and process everything inline. For cases, where crypto operations cannot happen
> inline (hard interrupt context, for example the read path of the NVME driver),
> we offload the work to a tasklet rather than a workqueue.

This patch both removes some dm-crypt specific queueing, and changes decryption
to use softIRQ context instead of a workqueue.  It would be useful to know how
much of a difference the workqueue => softIRQ change makes by itself.  Such a
change could be useful for fscrypt as well.  (fscrypt uses a workqueue for
decryption, but besides that doesn't use any other queueing.)

> @@ -127,7 +128,7 @@ struct iv_elephant_private {
>   * and encrypts / decrypts at the same time.
>   */
>  enum flags { DM_CRYPT_SUSPENDED, DM_CRYPT_KEY_VALID,
> -	     DM_CRYPT_SAME_CPU, DM_CRYPT_NO_OFFLOAD };
> +	     DM_CRYPT_SAME_CPU, DM_CRYPT_NO_OFFLOAD, DM_CRYPT_FORCE_INLINE = (sizeof(unsigned long) * 8 - 1) };

Assigning a specific enum value isn't necessary.

> @@ -1458,13 +1459,18 @@ static void crypt_alloc_req_skcipher(struct crypt_config *cc,
>  
>  	skcipher_request_set_tfm(ctx->r.req, cc->cipher_tfm.tfms[key_index]);
>  
> -	/*
> -	 * Use REQ_MAY_BACKLOG so a cipher driver internally backlogs
> -	 * requests if driver request queue is full.
> -	 */
> -	skcipher_request_set_callback(ctx->r.req,
> -	    CRYPTO_TFM_REQ_MAY_BACKLOG,
> -	    kcryptd_async_done, dmreq_of_req(cc, ctx->r.req));
> +	if (test_bit(DM_CRYPT_FORCE_INLINE, &cc->flags))
> +		/* make sure we zero important fields of the request */
> +		skcipher_request_set_callback(ctx->r.req,
> +	        0, NULL, NULL);
> +	else
> +		/*
> +		 * Use REQ_MAY_BACKLOG so a cipher driver internally backlogs
> +		 * requests if driver request queue is full.
> +		 */
> +		skcipher_request_set_callback(ctx->r.req,
> +	        CRYPTO_TFM_REQ_MAY_BACKLOG,
> +	        kcryptd_async_done, dmreq_of_req(cc, ctx->r.req));
>  }

This looks wrong.  Unless type=0 and mask=CRYPTO_ALG_ASYNC are passed to
crypto_alloc_skcipher(), the skcipher implementation can still be asynchronous,
in which case providing a callback is required.

Do you intend that the "force_inline" option forces the use of a synchronous
skcipher (alongside the other things it does)?  Or should it still allow
asynchronous ones?

We may not actually have a choice in that matter, since xts-aes-aesni has the
CRYPTO_ALG_ASYNC bit set (as I mentioned) despite being synchronous in most
cases; thus, the crypto API won't give you it if you ask for a synchronous
cipher.  So I think you still need to allow async skciphers?  That means a
callback is still always required.

- Eric
