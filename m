From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: xts fuzz testing and lack of ciphertext stealing
	support
Date: Fri, 19 Jul 2019 19:14:49 +0200
Message-ID: <CAKv+Gu-_1Bv1WQw+7ENWmjgvbgncKXGYOfxSr2GhVfN3-U3VtQ@mail.gmail.com>
References: <VI1PR0402MB34857BBB18C2BB8CBA2DEC7198C90@VI1PR0402MB3485.eurprd04.prod.outlook.com>
	<20190717172823.GA205944@gmail.com>
	<CAKv+Gu__offPaWvyURJr8v56ig58q-Deo16QhP26EJ32uf5m3w@mail.gmail.com>
	<20190718065223.4xaefcwjoxvujntw@gondor.apana.org.au>
	<CAKv+Gu9-EWNpJ9viSsjhYRdOZb=7a=Mpddmyt8SLEq9aFtawjg@mail.gmail.com>
	<20190718072154.m2umem24x4grbf6w@gondor.apana.org.au>
	<36e78459-1594-6d19-0ab4-95b03a6de036@gmail.com>
	<MN2PR20MB2973E61815F069E8C7D74177CAC80@MN2PR20MB2973.namprd20.prod.outlook.com>
	<20190718152908.xiuze3kb3fdc7ov6@gondor.apana.org.au>
	<MN2PR20MB2973E1A367986303566E80FCCAC80@MN2PR20MB2973.namprd20.prod.outlook.com>
	<20190718155140.b6ig3zq22askmfpy@gondor.apana.org.au>
	<CAKv+Gu9qm8mDZASJasq18bW=4_oE-cKPGKvdF9+8=7VNo==_fA@mail.gmail.com>
	<MN2PR20MB2973DE308D0050DBF3F26870CAC80@MN2PR20MB2973.namprd20.prod.outlook.com>
	<CAKv+Gu8dE6EO1NOwni91cvEWJvPzieC3wKph73j2jWxzx_xKAw@mail.gmail.com>
	<MN2PR20MB297371CEE0F60E58E110C6FDCACB0@MN2PR20MB2973.namprd20.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <MN2PR20MB297371CEE0F60E58E110C6FDCACB0@MN2PR20MB2973.namprd20.prod.outlook.com>
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
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, Herbert Xu <herbert@gondor.apana.org.au>, Horia Geanta <horia.geanta@nxp.com>, Milan Broz <gmazyland@gmail.com>
List-Id: dm-devel.ids

On Fri, 19 Jul 2019 at 09:29, Pascal Van Leeuwen
<pvanleeuwen@verimatrix.com> wrote:
>
> > -----Original Message-----
> > From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> > Sent: Friday, July 19, 2019 7:35 AM
> > To: Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
> > Cc: Herbert Xu <herbert@gondor.apana.org.au>; Milan Broz <gmazyland@gmail.com>; Horia Geanta <horia.geanta@nxp.com>; linux-
> > crypto@vger.kernel.org; dm-devel@redhat.com
> > Subject: Re: xts fuzz testing and lack of ciphertext stealing support
>  >
> > I would argue that these cases are diametrically opposite: you
> > proposed to remove support for zero length input vectors from the
> > entire crypto API to prevent your driver from having to deal with
> > inputs that the hardware cannot handle.
> >
> I did not propose any such thing - I just proposed to make zero length hash support *optional*
> (i.e. don't fail and disable the driver on it) as it's totally irrelevant for 99.99999% of use cases.
> (including *all* use cases I consider relevant for HW acceleration)
>

Fair enough. But it did involve making modifications to the generic
layer, since there are known users of the AF_ALG interface that may
pass zero length inputs (e.g., sha1sum).

> > I am proposing not to add support for cases that we have no need for.
> >
> While you are proposing to stick with an implementation that can only deal with 6.25% (1/16th) of
> *legal* input data for XTS and fails on the remaining 93.75%. That's hardly a corner case anymore.
>

I never said it was a corner case, nor does it make a lot of sense to
reason about fractional compliance, given that 100% of the inputs we
ever encounter are covered by your 6.25% of legal input data.

What i did say was that the moving parts we will add to the code will
never be put into motion, while they do increase the validation space,
and so the value of the contribution will be negative.

Perhaps I should emphasize that my concern is mainly about in-kernel
usage of the sync software ciphers, since they typically have no use
for userland, given that they can simply issue the same instructions
directly. For AF_ALG, I agree that exposing a non-compliant XTS
implementation is a bad idea.

> > XTS without CTS is indistinguishable from XTS with CTS if the inputs
> > are always a multiple of the block size, and in 12 years, nobody has
> > ever raised the issue that our support is limited to that. So what
> > problem are we fixing by changing this? dm-crypt does not care,
> > fscrypt does not care, userland does not care (given that it does not
> > work today and we are only finding out now due to some fuzz test
> > failing on CAAM)
> >
> If it's not supported, then it cannot be used. Most people would not start complaining about that,
> they would just roll their own locally or they'd give up and/or use something else.
> So the fact that it's currently not being used does not mean a whole lot. Also, it does not mean
> that there will not be a relevant use case tomorrow. (and I can assure you there *are* definitely
> real-life use cases, so I have to assume these are currently handled outside of the base kernel)
>
> In any case, if you try to use XTS you would *expect* it to work for any input >= 16 bytes as that's
> how the algorithm is *specified*. Without the CTS part it's simply not XTS.
>

I really don't care what we call it. My point is that we don't need
functionality that we will not use, regardless of how it is called.

> > > I pretty much made the same argument about all these driver workarounds
> > > slowing down my driver fast path but that was considered a non-issue.
> > >
> > > In this particular case, it should not need to be more than:
> > >
> > > if (unlikely(size & 15)) {
> > >   xts_with_partial_last_block();
> > > } else {
> > >   xts_with_only_full_blocks();
> > > }
> > >
> >
> > Of course. But why add this at all if it is known to be dead code?
> >
> But that's just an assumption and assumptions are the root of all evil ;-)
>

I think it was premature optimization that is the root of all evil, no?
