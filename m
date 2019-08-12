From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: xts fuzz testing and lack of ciphertext stealing
 support
Date: Mon, 12 Aug 2019 14:51:18 +1000
Message-ID: <20190812045118.GA17383@gondor.apana.org.au>
References: <MN2PR20MB2973127E4C159A8F5CFDD0C9CAD70@MN2PR20MB2973.namprd20.prod.outlook.com>
	<VI1PR0402MB3485689B4B65C879BC1D137398D70@VI1PR0402MB3485.eurprd04.prod.outlook.com>
	<20190809024821.GA7186@gondor.apana.org.au>
	<CAKv+Gu9hk=PGpsAWWOU61VrA3mVQd10LudA1qg0LbiX7DG9RjA@mail.gmail.com>
	<VI1PR0402MB3485F94AECC495F133F6B3D798D60@VI1PR0402MB3485.eurprd04.prod.outlook.com>
	<CAKv+Gu-_WObNm+ySXDWjhqe2YPzajX83MofuF-WKPSdLg5t4Ew@mail.gmail.com>
	<MN2PR20MB297361CA3C29C236D6D8F6F4CAD60@MN2PR20MB2973.namprd20.prod.outlook.com>
	<CAKv+Gu-xWxZ58tzyYoH_jDKfJoM+KzOWWpzCeHEmOXQ39Bv15g@mail.gmail.com>
	<d6d0b155-476b-d495-3418-4b171003cdd7@gmail.com>
	<MN2PR20MB2973D499FDBC5652CC3FEE6BCAD00@MN2PR20MB2973.namprd20.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <MN2PR20MB2973D499FDBC5652CC3FEE6BCAD00@MN2PR20MB2973.namprd20.prod.outlook.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, Milan Broz <gmazyland@gmail.com>, Horia Geanta <horia.geanta@nxp.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>
List-Id: dm-devel.ids

On Sun, Aug 11, 2019 at 09:29:38PM +0000, Pascal Van Leeuwen wrote:
>
> It will very likely fail with that CAAM h/w, but that only proves that you
> should not use plain64be IV's together with CAAM h/w. Which should be

It doesn't matter whether it's wrong or not.

The fact is that this is an interface that we export to user-space
and we must NEVER break that.  So if your driver is breaking this
interface then your driver is broken and needs to be fixed.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
