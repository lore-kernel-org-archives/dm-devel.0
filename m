From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: xts fuzz testing and lack of ciphertext stealing
	support
Date: Sun, 4 Aug 2019 11:36:25 +0300
Message-ID: <CAKv+Gu9JuXJspTO9tYbBgkdgmUznhgW+DWc029JWR2bqNsW_Bw@mail.gmail.com>
References: <20190716221639.GA44406@gmail.com>
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
	<VI1PR0402MB34850A016F3228124C0D360698C00@VI1PR0402MB3485.eurprd04.prod.outlook.com>
	<MN2PR20MB29732C3B360EB809EDFBFAC5CAC00@MN2PR20MB2973.namprd20.prod.outlook.com>
	<CAKv+Gu9krpqWYuD2mQFBTspo3y_TwrN6Arbvkcs=e4MpTeitHA@mail.gmail.com>
	<97532fae-4c17-bb8f-d245-04bf97cef4d1@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <97532fae-4c17-bb8f-d245-04bf97cef4d1@gmail.com>
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
Cc: Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>, Herbert Xu <herbert@gondor.apana.org.au>, Horia Geanta <horia.geanta@nxp.com>, "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
List-Id: dm-devel.ids

On Sat, 27 Jul 2019 at 19:04, Milan Broz <gmazyland@gmail.com> wrote:
>
> On 27/07/2019 07:39, Ard Biesheuvel wrote:
> > Thanks for the additional test vectors. They work fine with my SIMD
> > implementations for ARM [0], so this looks like it might be a CAAM
> > problem, not a problem with the test vectors.
> >
> > I will try to find some time today to run them through OpenSSL to double check.
>
> I shamelessly copied your test vectors to my vector test for cryptsetup backend.
>
> Both OpenSSL and gcrypt XTS implementation passed all tests here!
>
> If interested - this is copy of backend we have in cryptsetup, vectors added in crypto-vectors.c
> (there are some hard defines in Makefile, cryptsetup uses autoconf instead).
>   OpenSSL: https://github.com/mbroz/cryptsetup_backend_test
>   gcrypt branch: https://github.com/mbroz/cryptsetup_backend_test/tree/gcrypt
>
> Once kernel AF_ALG supports it, I can easily test it the same way.
>

Thanks for confirming. So we can be reasonably confident that the test
vectors contributed by Pascal are sound.

I'll try to send out my ARM/arm64 changes shortly. However, I won't
have any access to hardware until end of next month, so they are
tested on QEMU only, which means I won't be able to provide any
performance numbers.
