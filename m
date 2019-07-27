From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: xts fuzz testing and lack of ciphertext stealing
	support
Date: Sat, 27 Jul 2019 08:39:12 +0300
Message-ID: <CAKv+Gu9krpqWYuD2mQFBTspo3y_TwrN6Arbvkcs=e4MpTeitHA@mail.gmail.com>
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
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <MN2PR20MB29732C3B360EB809EDFBFAC5CAC00@MN2PR20MB2973.namprd20.prod.outlook.com>
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
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, Milan Broz <gmazyland@gmail.com>, Horia Geanta <horia.geanta@nxp.com>, Herbert Xu <herbert@gondor.apana.org.au>
List-Id: dm-devel.ids

On Sat, 27 Jul 2019 at 00:43, Pascal Van Leeuwen
<pvanleeuwen@verimatrix.com> wrote:
>
> > -----Original Message-----
> > From: Horia Geanta <horia.geanta@nxp.com>
> > Sent: Friday, July 26, 2019 9:59 PM
> > To: Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>; Ard Biesheuvel <ard.biesheuvel@linaro.org>
> > Cc: Milan Broz <gmazyland@gmail.com>; Herbert Xu <herbert@gondor.apana.org.au>; dm-devel@redhat.com; linux-
> > crypto@vger.kernel.org
> > Subject: Re: [dm-devel] xts fuzz testing and lack of ciphertext stealing support
> >
> > On 7/26/2019 1:31 PM, Pascal Van Leeuwen wrote:
> > > Ok, find below a patch file that adds your vectors from the specification
> > > plus my set of additional vectors covering all CTS alignments combined
> > > with the block sizes you desired. Please note though that these vectors
> > > are from our in-house home-grown model so no warranties.
> > I've checked the test vectors against caam (HW + driver).
> >
> > Test vectors from IEEE 1619-2007 (i.e. up to and including "XTS-AES 18")
> > are fine.
> >
> > caam complains when /* Additional vectors to increase CTS coverage */
> > section starts:
> > alg: skcipher: xts-aes-caam encryption test failed (wrong result) on test vector 9, cfg="in-place"
> >
> > (Unfortunately it seems that testmgr lost the capability of dumping
> > the incorrect output.)
> >
> > IMO we can't rely on test vectors if they are not taken
> > straight out of a spec, or cross-checked with other implementations.
> >
>
> First off, I fully agree with your statement, which is why I did not post this as a straight
> patch. The problem is that specification vectors usually (or actuaclly, always) don't cover
> all the relevant corner cases needed for verification. And "reference" implementations
> by academics are usually shady at best as well.
>
> In this particular case, the reference vectors only cover 5 out of 16 possible alignment
> cases and the current situation proves that this is not sufficient. As we have 2 imple-
> mentations (or actually more, if you count the models used for vector generation)
> that are considered to be correct that disagree on results.
>
> Which is very interesting, because which one is correct? I know that our model and
> hardware implementation were independently developed (by 2 different engineers)
> from the IEEE spec and match on results. And our hardware has been used "out in
> the field" for many years already in disk controllers from major silicon vendors.
> But that's still not a guarantee .... So how do we resolve this? Majority vote? ;-)
>

Thanks for the additional test vectors. They work fine with my SIMD
implementations for ARM [0], so this looks like it might be a CAAM
problem, not a problem with the test vectors.

I will try to find some time today to run them through OpenSSL to double check.


[0] https://git.kernel.org/pub/scm/linux/kernel/git/ardb/linux.git/commit/?h=xts-cts
