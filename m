From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: xts fuzz testing and lack of ciphertext stealing
	support
Date: Thu, 18 Jul 2019 15:50:41 +0800
Message-ID: <20190718075041.2mutant44rxx2ipq@gondor.apana.org.au>
References: <VI1PR0402MB34858E4EF0ACA7CDB446FF5798CE0@VI1PR0402MB3485.eurprd04.prod.outlook.com>
	<20190716221639.GA44406@gmail.com>
	<VI1PR0402MB34857BBB18C2BB8CBA2DEC7198C90@VI1PR0402MB3485.eurprd04.prod.outlook.com>
	<20190717172823.GA205944@gmail.com>
	<CAKv+Gu__offPaWvyURJr8v56ig58q-Deo16QhP26EJ32uf5m3w@mail.gmail.com>
	<20190718065223.4xaefcwjoxvujntw@gondor.apana.org.au>
	<CAKv+Gu9-EWNpJ9viSsjhYRdOZb=7a=Mpddmyt8SLEq9aFtawjg@mail.gmail.com>
	<20190718072154.m2umem24x4grbf6w@gondor.apana.org.au>
	<CAKv+Gu_CVBKUkb19yPPHJp3HcnAgxRn834yfKHcuUD5A69786g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <CAKv+Gu_CVBKUkb19yPPHJp3HcnAgxRn834yfKHcuUD5A69786g@mail.gmail.com>
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
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>, "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>, Horia Geanta <horia.geanta@nxp.com>
List-Id: dm-devel.ids

On Thu, Jul 18, 2019 at 09:28:03AM +0200, Ard Biesheuvel wrote:
>
> If we were adding XTS to the kernel today, then I would agree with
> you. But xts() has an established meaning now, and I don't think it
> makes sense to update all implementations for a theoretical use case,
> given that no portable userland code can rely on the correct semantics
> today, since CAAM is the only one that implements them correctly.
> 
> In any case, I won't have time to fix the ARM or arm64 implementations
> (or review the changes if someone else steps up) until the end of
> September.

I'm not asking you or anyone to fix this right away.  I'm just
saying that this is the direction we should be moving in.

After all, there is no immediate crisis as all that is broken
today is a fuzz test.

It should be possible to do this without causing performance
regressions for ARM.  We could rename the existing xts to a
new name (xek perhaps) and add xts into the cts template as
a wrapper around xek.

That way you don't have to touch the ARM code at all and it
should just work.

PS should we mark xek or whatever it's called as internal so
it isn't visible to user-space?

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
