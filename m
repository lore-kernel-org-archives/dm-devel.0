From: Horia Geanta <horia.geanta@nxp.com>
Subject: Re: xts fuzz testing and lack of ciphertext stealing
 support
Date: Wed, 7 Aug 2019 15:51:49 +0000
Message-ID: <VI1PR0402MB34856F03FCE57AB62FC2257998D40@VI1PR0402MB3485.eurprd04.prod.outlook.com>
References: <20190716221639.GA44406@gmail.com>
	<20190718072154.m2umem24x4grbf6w@gondor.apana.org.au>
	<36e78459-1594-6d19-0ab4-95b03a6de036@gmail.com>
	<MN2PR20MB2973E61815F069E8C7D74177CAC80@MN2PR20MB2973.namprd20.prod.outlook.com>
	<b042649c-db98-9710-b063-242bdf520252@gmail.com>
	<20190720065807.GA711@sol.localdomain>
	<0d4d6387-777c-bfd3-e54a-e7244fde0096@gmail.com>
	<CAKv+Gu9UF+a1UhVU19g1XcLaEqEaAwwkSm3-2wTHEAdD-q4mLQ@mail.gmail.com>
	<MN2PR20MB2973B9C2DDC508A81AF4A207CAC40@MN2PR20MB2973.namprd20.prod.outlook.com>
	<CAKv+Gu9C2AEbb++W=QTVWbeA_88Fo57NcOwgU5R8HBvzFwXkJw@mail.gmail.com>
	<MN2PR20MB2973C378AE5674F9E3E29445CAC60@MN2PR20MB2973.namprd20.prod.outlook.com>
	<CAKv+Gu-8n_DoauycDQS_9zzRew1rTuPaLxHyg6xhXMmqEvMaCA@mail.gmail.com>
	<MN2PR20MB2973CAE4E9CFFE1F417B2509CAC10@MN2PR20MB2973.namprd20.prod.outlook.com>
	<CAKv+Gu-j-8-bQS2A46-Kf1KHtkoPJ5Htk8WratqzyngnVu-wpw@mail.gmail.com>
	<MN2PR20MB29739591E1A3E54E7A8A8E18CAC00@MN2PR20MB2973.namprd20.prod.outlook.com>
	<20f4832e-e3af-e3c2-d946-13bf8c367a60@nxp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
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
To: Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, Milan Broz <gmazyland@gmail.com>, Herbert Xu <herbert@gondor.apana.org.au>
List-Id: dm-devel.ids

On 7/26/2019 10:59 PM, Horia Geant=E3 wrote:
> On 7/26/2019 1:31 PM, Pascal Van Leeuwen wrote:
>> Ok, find below a patch file that adds your vectors from the specification
>> plus my set of additional vectors covering all CTS alignments combined
>> with the block sizes you desired. Please note though that these vectors
>> are from our in-house home-grown model so no warranties.
> I've checked the test vectors against caam (HW + driver).
> =

> Test vectors from IEEE 1619-2007 (i.e. up to and including "XTS-AES 18")
> are fine.
> =

> caam complains when /* Additional vectors to increase CTS coverage */
> section starts:
> alg: skcipher: xts-aes-caam encryption test failed (wrong result) on test=
 vector 9, cfg=3D"in-place"
> =

I've nailed this down to a caam hw limitation.
Except for lx2160a and ls1028a SoCs, all the (older) SoCs allow only for
8-byte wide IV (sector index).
Will follow up with 16-byte IV support for the above-mentioned SoCs.

Pascal,

Could you also generate a few test vectors covering CTS with 8-byte IV?

Thanks,
Horia
