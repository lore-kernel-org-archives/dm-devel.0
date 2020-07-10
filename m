From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 2/6] crypto: algapi - use common mechanism for inheriting
 flags
Date: Fri, 10 Jul 2020 16:37:54 +1000
Message-ID: <20200710063753.GA1974@gondor.apana.org.au>
References: <20200701045217.121126-3-ebiggers@kernel.org>
 <20200709053126.GA5510@gondor.apana.org.au>
 <20200710062403.GB2805@sol.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-crypto-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20200710062403.GB2805@sol.localdomain>
Sender: linux-crypto-owner@vger.kernel.org
To: Eric Biggers <ebiggers@kernel.org>
Cc: mpatocka@redhat.com, linux-crypto@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids

On Thu, Jul 09, 2020 at 11:24:03PM -0700, Eric Biggers wrote:
>
> I decided to make crypto_check_attr_type() return the mask instead, and do so
> via a pointer argument instead of the return value (so that we don't overload an
> errno return value and prevent flag 0x80000000 from working).
> Please take a look at v2.  Thanks!

Looks good.  Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
