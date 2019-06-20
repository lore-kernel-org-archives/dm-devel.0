From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH v3 1/6] crypto: essiv - create wrapper
	template for ESSIV generation
Date: Thu, 20 Jun 2019 09:30:41 +0200
Message-ID: <CAKv+Gu-OwzmoYR5uymSNghEVc9xbkkt5C8MxAYA48UE=yBgb5g@mail.gmail.com>
References: <20190619162921.12509-1-ard.biesheuvel@linaro.org>
	<20190619162921.12509-2-ard.biesheuvel@linaro.org>
	<20190620010417.GA722@sol.localdomain>
	<20190620011325.phmxmeqnv2o3wqtr@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20190620011325.phmxmeqnv2o3wqtr@gondor.apana.org.au>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-fscrypt@vger.kernel.org, Eric Biggers <ebiggers@kernel.org>, Gilad Ben-Yossef <gilad@benyossef.com>, device-mapper development <dm-devel@redhat.com>, "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" <linux-crypto@vger.kernel.org>, Milan Broz <gmazyland@gmail.com>
List-Id: dm-devel.ids

On Thu, 20 Jun 2019 at 03:14, Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> On Wed, Jun 19, 2019 at 06:04:17PM -0700, Eric Biggers wrote:
> >
> > > +#define ESSIV_IV_SIZE              sizeof(u64)     // IV size of the outer algo
> > > +#define MAX_INNER_IV_SIZE  16              // max IV size of inner algo
> >
> > Why does the outer algorithm declare a smaller IV size?  Shouldn't it just be
> > the same as the inner algorithm's?
>
> In general we allow outer algorithms to have distinct IV sizes
> compared to the inner algorithm.  For example, rfc4106 has a
> different IV size compared to gcm.
>
> In this case, the outer IV size is the block number so that's
> presumably why 64 bits is sufficient.  Do you forsee a case where
> we need 128-bit block numbers?
>

Indeed, the whole point of this template is that it turns a 64-bit
sector number into a n-bit IV, where n equals the block size of the
essiv cipher, and its min/max keysize covers the digest size of the
shash.

I don't think it makes sense to generalize this further, and if I
understand the feedback from Herbert and Gilad correctly, it would
even be better to define the input IV as a LE 64-bit counter
explicitly, so we can auto increment it between sectors.

But that leaves the question how to convey the sector size to the
template. Gilad suggests

essiv(cbc(aes),aes,sha256,xxx)

where xxx is the sector size, and incoming requests whose cryptlen is
an exact multiple of the sector size will have their LE counter auto
incremented between sectors. Note that we could make it optional for
now, and default to 4k, but I will at least have to parse the argument
if it is present and reject values != 4096

Is this the right approach? Or are there better ways to convey this
information when instantiating the template?
Also, it seems to me that the dm-crypt and fscrypt layers would
require major surgery in order to take advantage of this.
