From: Eric Biggers <ebiggers@kernel.org>
Subject: Re: [dm-devel] [dm-crypt] [RFC PATCH 1/1] Add DM_CRYPT_FORCE_INLINE
 flag to dm-crypt target
Date: Tue, 23 Jun 2020 22:27:39 -0700
Message-ID: <20200624052739.GC844@sol.localdomain>
References: <20200619164132.1648-1-ignat@cloudflare.com>
 <20200619164132.1648-2-ignat@cloudflare.com>
 <20200624050452.GB844@sol.localdomain>
 <CY4PR04MB37515EB3C74CCAE2A006202FE7950@CY4PR04MB3751.namprd04.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CY4PR04MB37515EB3C74CCAE2A006202FE7950@CY4PR04MB3751.namprd04.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Damien Le Moal <Damien.LeMoal@wdc.com>
Cc: Ignat Korchagin <ignat@cloudflare.com>, "snitzer@redhat.com" <snitzer@redhat.com>, "kernel-team@cloudflare.com" <kernel-team@cloudflare.com>, "dm-crypt@saout.de" <dm-crypt@saout.de>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "agk@redhat.com" <agk@redhat.com>
List-Id: dm-devel.ids

On Wed, Jun 24, 2020 at 05:21:24AM +0000, Damien Le Moal wrote:
> >> @@ -1458,13 +1459,18 @@ static void crypt_alloc_req_skcipher(struct crypt_config *cc,
> >>  
> >>  	skcipher_request_set_tfm(ctx->r.req, cc->cipher_tfm.tfms[key_index]);
> >>  
> >> -	/*
> >> -	 * Use REQ_MAY_BACKLOG so a cipher driver internally backlogs
> >> -	 * requests if driver request queue is full.
> >> -	 */
> >> -	skcipher_request_set_callback(ctx->r.req,
> >> -	    CRYPTO_TFM_REQ_MAY_BACKLOG,
> >> -	    kcryptd_async_done, dmreq_of_req(cc, ctx->r.req));
> >> +	if (test_bit(DM_CRYPT_FORCE_INLINE, &cc->flags))
> >> +		/* make sure we zero important fields of the request */
> >> +		skcipher_request_set_callback(ctx->r.req,
> >> +	        0, NULL, NULL);
> >> +	else
> >> +		/*
> >> +		 * Use REQ_MAY_BACKLOG so a cipher driver internally backlogs
> >> +		 * requests if driver request queue is full.
> >> +		 */
> >> +		skcipher_request_set_callback(ctx->r.req,
> >> +	        CRYPTO_TFM_REQ_MAY_BACKLOG,
> >> +	        kcryptd_async_done, dmreq_of_req(cc, ctx->r.req));
> >>  }
> > 
> > This looks wrong.  Unless type=0 and mask=CRYPTO_ALG_ASYNC are passed to
> > crypto_alloc_skcipher(), the skcipher implementation can still be asynchronous,
> > in which case providing a callback is required.
> > 
> > Do you intend that the "force_inline" option forces the use of a synchronous
> > skcipher (alongside the other things it does)?  Or should it still allow
> > asynchronous ones?
> > 
> > We may not actually have a choice in that matter, since xts-aes-aesni has the
> > CRYPTO_ALG_ASYNC bit set (as I mentioned) despite being synchronous in most
> > cases; thus, the crypto API won't give you it if you ask for a synchronous
> > cipher.  So I think you still need to allow async skciphers?  That means a
> > callback is still always required.
> 
> Arg... So it means that some skciphers will not be OK at all for SMR writes. I
> was not aware of these differences (tested with aes-xts-plain64 only). The ugly
> way to support async ciphers would be to just wait inline for the crypto API to
> complete using a completion for instance. But that is very ugly. Back to
> brainstorming, and need to learn more about the crypto API...
> 

It's easy to wait for crypto API requests to complete if you need to --
just use crypto_wait_req().

We do this in fs/crypto/, for example.  (Not many people are using fscrypt with
crypto API based accelerators, so there hasn't yet been much need to support the
complexity of issuing multiple async crypto requests like dm-crypt supports.)

- Eric
