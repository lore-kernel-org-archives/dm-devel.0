From: Milan Broz <gmazyland@gmail.com>
Subject: Re: xts fuzz testing and lack of ciphertext stealing
 support
Date: Sun, 11 Aug 2019 13:12:56 +0200
Message-ID: <d6d0b155-476b-d495-3418-4b171003cdd7@gmail.com>
References: <CAKv+Gu9C2AEbb++W=QTVWbeA_88Fo57NcOwgU5R8HBvzFwXkJw@mail.gmail.com>
	<CAKv+Gu-j-8-bQS2A46-Kf1KHtkoPJ5Htk8WratqzyngnVu-wpw@mail.gmail.com>
	<MN2PR20MB29739591E1A3E54E7A8A8E18CAC00@MN2PR20MB2973.namprd20.prod.outlook.com>
	<20f4832e-e3af-e3c2-d946-13bf8c367a60@nxp.com>
	<VI1PR0402MB34856F03FCE57AB62FC2257998D40@VI1PR0402MB3485.eurprd04.prod.outlook.com>
	<MN2PR20MB2973127E4C159A8F5CFDD0C9CAD70@MN2PR20MB2973.namprd20.prod.outlook.com>
	<VI1PR0402MB3485689B4B65C879BC1D137398D70@VI1PR0402MB3485.eurprd04.prod.outlook.com>
	<20190809024821.GA7186@gondor.apana.org.au>
	<CAKv+Gu9hk=PGpsAWWOU61VrA3mVQd10LudA1qg0LbiX7DG9RjA@mail.gmail.com>
	<VI1PR0402MB3485F94AECC495F133F6B3D798D60@VI1PR0402MB3485.eurprd04.prod.outlook.com>
	<CAKv+Gu-_WObNm+ySXDWjhqe2YPzajX83MofuF-WKPSdLg5t4Ew@mail.gmail.com>
	<MN2PR20MB297361CA3C29C236D6D8F6F4CAD60@MN2PR20MB2973.namprd20.prod.outlook.com>
	<CAKv+Gu-xWxZ58tzyYoH_jDKfJoM+KzOWWpzCeHEmOXQ39Bv15g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CAKv+Gu-xWxZ58tzyYoH_jDKfJoM+KzOWWpzCeHEmOXQ39Bv15g@mail.gmail.com>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>, Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>, Herbert Xu <herbert@gondor.apana.org.au>, Horia Geanta <horia.geanta@nxp.com>, "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
List-Id: dm-devel.ids

On 10/08/2019 06:39, Ard Biesheuvel wrote:
> Truncated IVs are a huge issue, since we already expose the correct
> API via AF_ALG (without any restrictions on how many of the IV bits
> are populated), and apparently, if your AF_ALG request for xts(aes)
> happens to be fulfilled by the CAAM driver and your implementation
> uses more than 64 bits for the IV, the top bits get truncated silently
> and your data might get eaten.

Actually, I think we have already serious problem with in in kernel (no AF_ALG needed).

I do not have the hardware, but please could you check that dm-crypt big-endian IV
(plain64be) produces the same output on CAAM?

It is 64bit IV, but big-endian and we use size of cipher block (16bytes) here,
so the first 8 bytes are zero in this case.

I would expect data corruption in comparison to generic implementation,
if it supports only the first 64bit...

Try this:

# create small null device of 8 sectors,  we use zeroes as fixed ciphertext
dmsetup create zero --table "0 8 zero"

# create crypt device on top of it (with some key), using plain64be IV
dmsetup create crypt --table "0 8 crypt aes-xts-plain64be e8cfa3dbfe373b536be43c5637387786c01be00ba5f730aacb039e86f3eb72f3 0 /dev/mapper/zero 0"

# and compare it with and without your driver, this is what I get here:
# sha256sum /dev/mapper/crypt 
532f71198d0d84d823b8e410738c6f43bc3e149d844dd6d37fa5b36d150501e1  /dev/mapper/crypt
# dmsetup remove crypt

You can try little-endian version (plain64), this should always work even with CAAM
dmsetup create crypt --table "0 8 crypt aes-xts-plain64 e8cfa3dbfe373b536be43c5637387786c01be00ba5f730aacb039e86f3eb72f3 0 /dev/mapper/zero 0"

# sha256sum /dev/mapper/crypt 
f17abd27dedee4e539758eabdb6c15fa619464b509cf55f16433e6a25da42857  /dev/mapper/crypt
# dmsetup remove crypt

# dmsetup remove zero


If you get different plaintext in the first case, your driver is actually creating
data corruption in this configuration and it should be fixed!
(Only the first sector must be the same, because it has IV == 0.)

Milan

p.s.
If you ask why we have this IV, it was added per request to allow map some chipset-based
encrypted drives directly. I guess it is used for some data forensic things.
