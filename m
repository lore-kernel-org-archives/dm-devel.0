From: Steffen Klassert <steffen.klassert@secunet.com>
Subject: Re: [dm-devel] [PATCH] DM-CRYPT: Scale to multiple CPUs
Date: Wed, 2 Jun 2010 08:30:33 +0200
Message-ID: <20100602063033.GS2184@secunet.com>
References: <20100531160425.GA20344@basil.fritz.box>
 <Pine.LNX.4.64.1005312239520.6372@hs20-bc2-1.build.redhat.com>
 <20100601043901.GA25693@gondor.apana.org.au>
 <Pine.LNX.4.64.1006020051540.22695@hs20-bc2-1.build.redhat.com>
 <20100602051403.GA5784@gondor.apana.org.au>
 <Pine.LNX.4.64.1006020119540.22695@hs20-bc2-1.build.redhat.com>
 <20100602060702.GA6319@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20100602060702.GA6319@gondor.apana.org.au>
Sender: linux-kernel-owner@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Mikulas Patocka <mpatocka@redhat.com>, device-mapper development <dm-devel@redhat.com>, linux-kernel@vger.kernel.org, agk@redhat.com, ak@linux.intel.com
List-Id: dm-devel.ids

On Wed, Jun 02, 2010 at 04:07:02PM +1000, Herbert Xu wrote:
> On Wed, Jun 02, 2010 at 01:25:11AM -0400, Mikulas Patocka wrote:
> >
> > Are you sure that you know what you're talking about? pcrypt_alloc 
> > contains this:
> > switch (algt->type & algt->mask & CRYPTO_ALG_TYPE_MASK) {
> > case CRYPTO_ALG_TYPE_AEAD:
> >         return pcrypt_alloc_aead(tb);
> > }
> > 
> > return ERR_PTR(-EINVAL);
> > --- so for anything other byt AEAD it returns -EINVAL.
> 
> So someone needs to write the ablkcipher plugins for pcrypt.
> 

I did that already for one of the older (remote softirq based)
version of pcrypt. I just never pushed it out because I was focused
on IPsec and the softirq based version I was not that usefull for
dm-crypt. Now, that we use workqueues internally, dm-crypt could
benefit from pcrypt too. Let me see whether I can respin the old
ablkcipher plugin.

Steffen
