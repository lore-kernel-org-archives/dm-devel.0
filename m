From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: xts fuzz testing and lack of ciphertext stealing
	support
Date: Thu, 25 Jul 2019 11:01:40 +0300
Message-ID: <CAKv+Gu-j-8-bQS2A46-Kf1KHtkoPJ5Htk8WratqzyngnVu-wpw@mail.gmail.com>
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
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <MN2PR20MB2973CAE4E9CFFE1F417B2509CAC10@MN2PR20MB2973.namprd20.prod.outlook.com>
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

On Thu, 25 Jul 2019 at 10:49, Pascal Van Leeuwen
<pvanleeuwen@verimatrix.com> wrote:
>
>
> > -----Original Message-----
> > From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> > Sent: Thursday, July 25, 2019 8:22 AM
> > To: Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
> > Cc: Milan Broz <gmazyland@gmail.com>; Herbert Xu <herbert@gondor.apana.org.au>; dm-devel@redhat.com; linux-
> > crypto@vger.kernel.org; Horia Geanta <horia.geanta@nxp.com>
> > Subject: Re: [dm-devel] xts fuzz testing and lack of ciphertext stealing support
> >
> > > >
> > > > Actually, that spec has a couple of test vectors. Unfortunately, they
> > > > are all rather short (except the last one in the 'no multiple of 16
> > > > bytes' paragraph, but unfortunately, that one is in fact a multiple of
> > > > 16 bytes)
> > > >
> > > > I added them here [0] along with an arm64 implementation for the AES
> > > > instruction based driver. Could you please double check that these
> > > > work against your driver?
> > > >
> > > I got XTS working with the inside-secure driver and these (and all other) vectors pass :-)
> > >
> >
> > Excellent, thanks for the report. May I add your Tested-by when I post
> > the patch? (just the one that adds the test vectors)
> >
> Sure, feel free
>

Thanks

> > > > That would establish a ground truth against
> > > > which we can implement the generic version as well.
> > > >
> > > > [0] https://git.kernel.org/pub/scm/linux/kernel/git/ardb/linux.git/log/?h=xts-cts
> > > >
> > > > > Besides that, I'd be happy to generate some testvectors from our defacto-standard
> > > > > implementation ;-)
> > > > >
> > > >
> > > > One or two larger ones would be useful, yes.
> > > >
> > > I'll see if I can extract some suitable vectors from our verification suite ...
> > >
> >
> > Great. Once available, I'll run them against my implementations and report back.
> >
> Just wondering ... do you have any particular requirements on the sizes?
> From my implementation's perspective, it doesn't make a whole lot of sense to test vectors
> of more than 3 times the cipher block size, but then I realized that you probably need
> larger vectors due to the loop unrolling you do for the vector implementations?
> You also don't want them to be too big as they take up space in the kernel image ...
>

We have code that operates on 1 block, 3 blocks (ARM), 4-5 blocks
(arm64) or 8 blocks (ARM,arm64) at a time. However, the most important
thing is to test the handover between the block based loop and the
epilogue that operates on the final 17-31 bytes when ciphertext
stealing is being done.

So ideally, we'd have 1 full block + 1 full/1 partial, 3 full blocks +
1 full/1 partial, and so on for 4, 5 and 8 blocks, to cover all the
code flows, but since the unrolled routines all support arbitrary
block counts (and so the handover between the multiblock and the
single block handling is already covered), just having the first two
would  be sufficient IMO.
