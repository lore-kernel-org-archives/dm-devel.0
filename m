From: Eric Biggers <ebiggers@kernel.org>
Subject: Re: xts fuzz testing and lack of ciphertext stealing
 support
Date: Fri, 19 Jul 2019 23:58:07 -0700
Message-ID: <20190720065807.GA711@sol.localdomain>
References: <20190716221639.GA44406@gmail.com>
	<VI1PR0402MB34857BBB18C2BB8CBA2DEC7198C90@VI1PR0402MB3485.eurprd04.prod.outlook.com>
	<20190717172823.GA205944@gmail.com>
	<CAKv+Gu__offPaWvyURJr8v56ig58q-Deo16QhP26EJ32uf5m3w@mail.gmail.com>
	<20190718065223.4xaefcwjoxvujntw@gondor.apana.org.au>
	<CAKv+Gu9-EWNpJ9viSsjhYRdOZb=7a=Mpddmyt8SLEq9aFtawjg@mail.gmail.com>
	<20190718072154.m2umem24x4grbf6w@gondor.apana.org.au>
	<36e78459-1594-6d19-0ab4-95b03a6de036@gmail.com>
	<MN2PR20MB2973E61815F069E8C7D74177CAC80@MN2PR20MB2973.namprd20.prod.outlook.com>
	<b042649c-db98-9710-b063-242bdf520252@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <b042649c-db98-9710-b063-242bdf520252@gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Milan Broz <gmazyland@gmail.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, Horia Geanta <horia.geanta@nxp.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>, "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
List-Id: dm-devel.ids

On Thu, Jul 18, 2019 at 01:19:41PM +0200, Milan Broz wrote:
> 
> > From that perspective - to prevent people from doing cryptographically stupid things -
> > IMHO it would be better to just pull the CTS into the XTS implementation i.e. make
> > xts natively support blocks that are not a multiple of (but >=) the cipher blocksize ...
> 
> I would definitely prefer adding CTS directly to XTS (as it is in gcrypt or OpenSSL now)
> instead of some new compositions.
> 
> Also, I would like to avoid another "just because it is nicer" module dependence (XTS->XEX->ECB).
> Last time (when XTS was reimplemented using ECB) we have many reports with initramfs
> missing ECB module preventing boot from AES-XTS encrypted root after kernel upgrade...
> Just saying. (Despite the last time it was keyring what broke encrypted boot ;-)
> 

Can't the "missing modules in initramfs" issue be solved by using a
MODULE_SOFTDEP()?  Actually, why isn't that being used for xts -> ecb already?

(There was also a bug where CONFIG_CRYPTO_XTS didn't select CONFIG_CRYPTO_ECB,
but that was simply a bug, which was fixed.)

Or "xts" and "xex" could go in the same kernel module xts.ko, which would make
this a non-issue.

Anyway, I agree that the partial block support, if added, should just be made
available under the name "xts", as people would expect.  It doesn't need a new
name.

- Eric
