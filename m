From: Horia Geanta <horia.geanta@nxp.com>
Subject: Re: xts fuzz testing and lack of ciphertext stealing
 support
Date: Thu, 8 Aug 2019 14:50:19 +0000
Message-ID: <VI1PR0402MB34859FF5C6129DAE01B1CA0098D70@VI1PR0402MB3485.eurprd04.prod.outlook.com>
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
	<VI1PR0402MB34856F03FCE57AB62FC2257998D40@VI1PR0402MB3485.eurprd04.prod.outlook.com>
	<MN2PR20MB2973C16264CA748F147834E9CAD40@MN2PR20MB2973.namprd20.prod.outlook.com>
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

On 8/7/2019 11:58 PM, Pascal Van Leeuwen wrote:
>> -----Original Message-----
>> From: Horia Geanta <horia.geanta@nxp.com>
>> Sent: Wednesday, August 7, 2019 5:52 PM
>> To: Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>; Ard Biesheuvel
>> <ard.biesheuvel@linaro.org>
>> Cc: Milan Broz <gmazyland@gmail.com>; Herbert Xu <herbert@gondor.apana.o=
rg.au>; dm-
>> devel@redhat.com; linux-crypto@vger.kernel.org
>> Subject: Re: [dm-devel] xts fuzz testing and lack of ciphertext stealing=
 support
>>
>> On 7/26/2019 10:59 PM, Horia Geant=E3 wrote:
>>> On 7/26/2019 1:31 PM, Pascal Van Leeuwen wrote:
>>>> Ok, find below a patch file that adds your vectors from the specificat=
ion
>>>> plus my set of additional vectors covering all CTS alignments combined
>>>> with the block sizes you desired. Please note though that these vectors
>>>> are from our in-house home-grown model so no warranties.
>>> I've checked the test vectors against caam (HW + driver).
>>>
>>> Test vectors from IEEE 1619-2007 (i.e. up to and including "XTS-AES 18")
>>> are fine.
>>>
>>> caam complains when /* Additional vectors to increase CTS coverage */
>>> section starts:
>>> alg: skcipher: xts-aes-caam encryption test failed (wrong result) on te=
st vector 9,
>> cfg=3D"in-place"
>>>
>> I've nailed this down to a caam hw limitation.
>> Except for lx2160a and ls1028a SoCs, all the (older) SoCs allow only for
>> 8-byte wide IV (sector index).
>>
> I guess it's easy to say now, but I already suspected a problem with full=
 16 =

> byte random IV's. A problem with CTS itself seemed implausible due to the=
 base
> vectors from the spec running fine and I did happen to notice that all =

> vectors from the spec only use up to the lower 40 bits of the sector numb=
er.
> While my vectors randomize all 16 bytes.
> =

> So I guess that means that 16 byte multiples (i.e. not needing CTS) with
> full 16 byte sector numbers will probably also fail on caam HW ...
> 	=

Yes, the limitation applies for all input sizes.

It's actually mentioned in the commit that added xts support few years back:
c6415a6016bf ("crypto: caam - add support for acipher xts(aes)")

    sector index - HW limitation: CAAM device supports sector index of only
    8 bytes to be used for sector index inside IV, instead of whole 16 bytes
    received on request. This represents 2 ^ 64 =3D 16,777,216 Tera of poss=
ible
    values for sector index.

> As for the tweak size, with very close scrutiny of the IEEE spec I actual=
ly
> noticed some inconsistencies:
> =

> - the text very clearly defines the tweak as 128 bit and starting from an =

> *arbitrary* non-negative integer, this is what I based my implementation =
on
> =

> - all text examples and test vectors max out at 40 bits ... just examples,
> but odd nonetheless (why 40 anyway?)
> =

> - the example code fragment in Annex C actually has the S data unit number
> input as an u64b, further commented as "64 bits" (but then loops 16 times=
 to
> convert it to a byte string ...)
> =

The input I received from our HW design team was something like:

- some P1619 drafts used LRW (instead of XTS), where the tweak "T"
was 16B-wide

- at some point P1619 drafts switched (and eventually standardized) XTS,
where "T" is no longer the tweak - "i" is the (public) tweak, "T" being
an intermediate (hidden) result in the encryption scheme

- since for XTS "i" is supposed to be the sector number,
there is no need to support 16B values - 8B being deemed sufficient

Agree, limiting "i" (XTS tweak) to 8B is out-of-spec - irrespective of the
usefulness of the full 16B.
That's why latest Freescale / NXP SoCs support 16B tweaks.

Thanks,
Horia
