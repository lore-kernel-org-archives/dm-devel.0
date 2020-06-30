From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2] dm crypt: add flags to optionally bypass dm-crypt
 workqueues
Date: Tue, 30 Jun 2020 13:09:44 +1000
Message-ID: <20200630030944.GA20706@gondor.apana.org.au>
References: <20200626210302.1813-1-ignat@cloudflare.com>
 <CY4PR04MB375127DC313F70875CAAC841E76F0@CY4PR04MB3751.namprd04.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CY4PR04MB375127DC313F70875CAAC841E76F0@CY4PR04MB3751.namprd04.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Damien Le Moal <Damien.LeMoal@wdc.com>
Cc: Ignat Korchagin <ignat@cloudflare.com>, "agk@redhat.com" <agk@redhat.com>, "snitzer@redhat.com" <snitzer@redhat.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "dm-crypt@saout.de" <dm-crypt@saout.de>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "ebiggers@kernel.org" <ebiggers@kernel.org>, "mpatocka@redhat.com" <mpatocka@redhat.com>, "kernel-team@cloudflare.com" <kernel-team@cloudflare.com>
List-Id: dm-devel.ids

On Tue, Jun 30, 2020 at 02:51:17AM +0000, Damien Le Moal wrote:
>
> > @@ -1463,12 +1465,12 @@ static void crypt_alloc_req_skcipher(struct crypt_config *cc,
> >  	 * requests if driver request queue is full.
> >  	 */
> >  	skcipher_request_set_callback(ctx->r.req,
> > -	    CRYPTO_TFM_REQ_MAY_BACKLOG,
> > +	    nobacklog ? 0 : CRYPTO_TFM_REQ_MAY_BACKLOG,
> >  	    kcryptd_async_done, dmreq_of_req(cc, ctx->r.req));
> 
> Will not specifying CRYPTO_TFM_REQ_MAY_BACKLOG always cause the crypto API to
> return -EBUSY ? From the comment above the skcipher_request_set_callback(), it
> seems that this will be the case only if the skcipher diver queue is full. So in
> other word, keeping the kcryptd_async_done() callback and executing the skcipher
> request through crypt_convert() and crypt_convert_block_skcipher() may still end
> up being an asynchronous operation. Can you confirm this and is it what you
> intended to implement ?

The purpose of MAY_BACKLOG is to make the crypto request reliable.
It has nothing to do with whether the request will be synchronous
or not.

Without the backlog flag, if the hardware queue is full the request
will simply be dropped, which is appropriate in the network stack
with IPsec where congestion can be dealt with at the source.

Block layer on the other hand should always use the backlog flag
and stop sending more requests to the crypto API until the congestion
goes away.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
