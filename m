From: Herbert Xu <herbert.xu@redhat.com>
Subject: Re: [0/3] [DM] dm-crypt: Add async crypto support
Date: Wed, 25 Jul 2007 17:23:32 +0800
Message-ID: <20070725092332.GA21912@gondor.apana.org.au>
References: <20070711030303.GA6730@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-crypto-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20070711030303.GA6730@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
To: Alasdair G Kergon <agk@redhat.com>, dm-devel@redhat.com
Cc: Christophe Saout <christophe@saout.de>, Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
List-Id: dm-devel.ids

On Wed, Jul 11, 2007 at 11:03:03AM +0800, Herbert Xu wrote:
> 
> I've rebased the async dm-crypt patches for 2.6.22.  In doing
> so I've refactored the kcryptd split so that all crypto operations
> happen in kcryptd while all IO submissions occur in kcryptd-io.

Hi Alasdair:

Do you have any further comments on these patches?

If you're OK with them then I could drop them into
the cryptodev tree.

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
