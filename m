From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [dm-devel] [PATCH] DM-CRYPT: Scale to multiple CPUs
Date: Wed, 2 Jun 2010 01:25:11 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.1006020119540.22695@hs20-bc2-1.build.redhat.com>
References: <20100531160425.GA20344@basil.fritz.box>
 <Pine.LNX.4.64.1005312239520.6372@hs20-bc2-1.build.redhat.com>
 <20100601043901.GA25693@gondor.apana.org.au>
 <Pine.LNX.4.64.1006020051540.22695@hs20-bc2-1.build.redhat.com>
 <20100602051403.GA5784@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20100602051403.GA5784@gondor.apana.org.au>
Sender: linux-kernel-owner@vger.kernel.org
To: Herbert Xu <herbert@gondor.hengli.com.au>
Cc: device-mapper development <dm-devel@redhat.com>, linux-kernel@vger.kernel.org, agk@redhat.com, ak@linux.intel.com
List-Id: dm-devel.ids



On Wed, 2 Jun 2010, Herbert Xu wrote:

> On Wed, Jun 02, 2010 at 01:10:00AM -0400, Mikulas Patocka wrote:
> >
> > And how can I use pcrypt for dm-crypt? After a quick look at pcrypt 
> > sources, it seems to be dependent on aead and not useable for general 
> > encryption algorithms at all.
> 
> You instantiate a pcrypt variant of whatever algorithm that you're
> using.  For example, if you're using XTS then you should instantiate
> pcrypt(xts(aes)).  Currently you must use tcrypt to instantiate.

I tried "pcrypt(%s(%s))" in dm-crypt and I get "table: 253:0: crypt: Error 
allocating crypto tfm"

Are you sure that you know what you're talking about? pcrypt_alloc 
contains this:
switch (algt->type & algt->mask & CRYPTO_ALG_TYPE_MASK) {
case CRYPTO_ALG_TYPE_AEAD:
        return pcrypt_alloc_aead(tb);
}

return ERR_PTR(-EINVAL);
--- so for anything other byt AEAD it returns -EINVAL.

> > I tried cryptd --- in theory it should work by requesting the algorithm 
> > like cryptd(cbc(aes)) --- but if I replace "%s(%s)" with "cryptd(%s(%s))" 
> > in dm-crypt sources it locks up and doesn't work.
> 
> cryptd is something else altogether.  However, it certainly should
> not lock up.  What kernel version is this?

2.6.34 and cryptsetup 1.1.2. It is a soft lockup interruptible with 
Ctrl-C.

> > > This would be inappropriate for upper layer code as they do not
> > > know whether the underlying algorithm should be parallelised,
> > > e.g., a PCI offload board certainly should not be parallelised.
> > 
> > The upper layer should ideally request "cbc(aes)" and the crypto routine 
> > should select the most efficient implementation --- sync on single-core 
> > system, async with cryptd on multi-core system and async with hardware 
> > implementation if you have HIFN crypto card.
> 
> That's exactly what will happen when the admin instantiates pcrypt.
> dm-crypt simply needs to specify cbc(aes) and it will get pcrypt
> automatically.
> 
> The point is that on a modern processor like Nehalem you don't need
> pcrypt.
>  
> > It is pointless to track the submitting CPU.
> 
> No you are wrong.

For what? For avoiding cache bounces? But the encrypting is 
order-of-magnitude slower than memory speed.

Mikulas
