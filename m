From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v3 1/6] crypto: essiv - create wrapper
 template for ESSIV generation
Date: Thu, 20 Jun 2019 20:53:39 +0800
Message-ID: <20190620125339.gqup5623sw4xrsmi@gondor.apana.org.au>
References: <20190619162921.12509-1-ard.biesheuvel@linaro.org>
	<20190619162921.12509-2-ard.biesheuvel@linaro.org>
	<20190620010417.GA722@sol.localdomain>
	<20190620011325.phmxmeqnv2o3wqtr@gondor.apana.org.au>
	<CAKv+Gu-OwzmoYR5uymSNghEVc9xbkkt5C8MxAYA48UE=yBgb5g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <CAKv+Gu-OwzmoYR5uymSNghEVc9xbkkt5C8MxAYA48UE=yBgb5g@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: linux-fscrypt@vger.kernel.org, Eric Biggers <ebiggers@kernel.org>, Gilad Ben-Yossef <gilad@benyossef.com>, device-mapper development <dm-devel@redhat.com>, "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" <linux-crypto@vger.kernel.org>, Milan Broz <gmazyland@gmail.com>
List-Id: dm-devel.ids

On Thu, Jun 20, 2019 at 09:30:41AM +0200, Ard Biesheuvel wrote:
>
> Is this the right approach? Or are there better ways to convey this
> information when instantiating the template?
> Also, it seems to me that the dm-crypt and fscrypt layers would
> require major surgery in order to take advantage of this.

Oh and you don't have to make dm-crypt use it from the start.  That
is, you can just make things simple by doing it one sector at a
time in the dm-crypt code even though the underlying essiv code
supports multiple sectors.

Someone who cares about this is sure to come along and fix it later.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
