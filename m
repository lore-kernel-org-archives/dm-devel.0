From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [RFC PATCH v2] md/dm-crypt - reuse eboiv skcipher
	for IV generation
Date: Wed, 7 Aug 2019 18:39:40 +0300
Message-ID: <CAKv+Gu8fgg=gt4LSnCfShnf0-PZ=B1TNwM3zdQr+V6hkozgDOA@mail.gmail.com>
References: <20190807055022.15551-1-ard.biesheuvel@linaro.org>
	<MN2PR20MB297336108DF89337DDEEE2F6CAD40@MN2PR20MB2973.namprd20.prod.outlook.com>
	<CAKv+Gu_jFW26boEhpnAZg9sjWWZf60FXSWuSqNvC5FJiL7EVSA@mail.gmail.com>
	<MN2PR20MB2973A02FC4D6F1D11BA80792CAD40@MN2PR20MB2973.namprd20.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <MN2PR20MB2973A02FC4D6F1D11BA80792CAD40@MN2PR20MB2973.namprd20.prod.outlook.com>
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
Cc: "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>, "snitzer@redhat.com" <snitzer@redhat.com>, "ebiggers@kernel.org" <ebiggers@kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>, "gmazyland@gmail.com" <gmazyland@gmail.com>, "agk@redhat.com" <agk@redhat.com>
List-Id: dm-devel.ids

On Wed, 7 Aug 2019 at 16:52, Pascal Van Leeuwen
<pvanleeuwen@verimatrix.com> wrote:
>
> Ard,
>
> > -----Original Message-----
> > From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> > Sent: Wednesday, August 7, 2019 3:17 PM
> > To: Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
> > Cc: linux-crypto@vger.kernel.org; herbert@gondor.apana.org.au; ebiggers@kernel.org;
> > agk@redhat.com; snitzer@redhat.com; dm-devel@redhat.com; gmazyland@gmail.com
> > Subject: Re: [RFC PATCH v2] md/dm-crypt - reuse eboiv skcipher for IV generation
> >
> > On Wed, 7 Aug 2019 at 10:28, Pascal Van Leeuwen
> > <pvanleeuwen@verimatrix.com> wrote:
> > >
> > > Ard,
> > >
> > > I've actually been following this discussion with some interest, as it has
> > > some relevance for some of the things I am doing at the moment as well.
> > >
> > > For example, for my CTS implementation I need to crypt one or two
> > > seperate blocks and for the inside-secure driver I sometimes need to do
> > > some single crypto block precomputes. (the XTS driver additionally
> > > also already did such a single block encrypt for the tweak, also using
> > > a seperate (non-sk)cipher instance - very similar to your IV case)
> > >
> > > Long story short, the current approach is to allocate a seperate
> > > cipher instance so you can conveniently do crypto_cipher_en/decrypt_one.
> > > (it would be nice to have a matching crypto_skcipher_en/decrypt_one
> > > function available from the crypto API for these purposes?)
> > > But if I understand you correctly, you may end up with an insecure
> > > table-based implementation if you do that. Not what I want :-(
> > >
> >
> > Table based AES is known to be vulnerable to plaintext attacks on the
> > key, since each byte of the input xor'ed with the key is used as an
> > index for doing Sbox lookups, and so with enough samples, there is an
> > exploitable statistical correlation between the response time and the
> > key.
> >
> > So in the context of EBOIV, where the user might specify a SIMD based
> > time invariant skcipher, it would be really bad if the known plaintext
> > encryptions of the byte offsets that occur with the *same* key would
> > happen with a different cipher that is allocated implicitly and ends
> > up being fulfilled by, e.g., aes-generic, since in that case, each
> > block en/decryption is preceded by a single, time-variant AES
> > invocation with an easily guessable input.
> >
> No need to tell me, doing crypto has been my dayjob for nearly 18.5 years
> now :-)
>

I didn't mean to imply that you don't know your stuff :-) I am just
reiterating the EBOIV issue so we can compare it to the issue you are
bringing up

> > In your case, we are not dealing with known plaintext attacks,
> >
> Since this is XTS, which is used for disk encryption, I would argue
> we do! For the tweak encryption, the sector number is known plaintext,
> same as for EBOIV. Also, you may be able to control data being written
> to the disk encrypted, either directly or indirectly.
> OK, part of the data into the CTS encryption will be previous ciphertext,
> but that may be just 1 byte with the rest being the known plaintext.
>

The tweak encryption uses a dedicated key, so leaking it does not have
the same impact as it does in the EBOIV case. And a plaintext attack
on the data encryption part of XTS involves knowing the value of the
tweak as well, so you'd have to successfully attack the tweak before
you can attack the data. So while your point is valid, it's definitely
less broken than EBOIV.

> > and the
> > higher latency of h/w accelerated crypto makes me less worried that
> > the final, user observable latency would strongly correlate the way
> > aes-generic in isolation does.
> >
> If that latency is constant - which it usually is - then it doesn't
> really matter for correlation, it just filters out.
>

Due to the asynchronous nature of the driver, we'll usually be calling
into the OS scheduler after queuing one or perhaps several blocks for
processing by the hardware. Even if the processing time is fixed, the
time it takes for the OS to respond to the completion IRQ and process
the output is unlikely to correlate the way a table based software
implementation does, especially if several blocks can be in flight at
the same time.

But note that we are basically in agreement here: falling back to
table based AES is undesirable, but for EBOIV it is just much worse
than for other modes.

> > > However, in many cases there would actually be a very good reason
> > > NOT to want to use the main skcipher for this. As that is some
> > > hardware accelerator with terrible latency that you wouldn't want
> > > to use to process just one cipher block. For that, you want to have
> > > some SW implementation that is efficient on a single block instead.
> > >
> >
> > Indeed. Note that for EBOIV, such performance concerns are deemed
> > irrelevant, but it is an issue in the general case.
> >
> Yes, my interest was purely in the generic case.
>
> > > In my humble opinion, such insecure table based implementations just
> > > shouldn't exist at all - you can always do better, possibly at the
> > > expense of some performance degradation. Or you should at least have
> > > some flag  available to specify you have some security requirements
> > > and such an implementation is not an acceptable response.
> > >
> >
> > We did some work to reduce the time variance of AES: there is the
> > aes-ti driver, and there is now also the AES library, which is known
> > to be slower than aes-generic, but does include some mitigations for
> > cache timing attacks.
> >
> > Other than that, I have little to offer, given that the performance vs
> > security tradeoffs were decided long before security became a thing
> > like it is today, and so removing aes-generic is not an option,
> > especially since the scalar alternatives we have are not truly time
> > invariant either.
> >
> Replacing aes-generic with a truly time-invariant implementation could
> be an option.

If you can find a truly time-invariant C implementation of AES that
isn't orders of magnitude slower than aes-generic, I'm sure we can
merge it.

> Or selecting aes-generic only if some (new) "allow_insecure"
> flag is set on the cipher request. (Obviously, you want to default to
> secure, not insecure. Speaking as someone who earns his living doing
> security :-)
>

We all do. But we all have different use cases to worry about, and
different experiences and backgrounds :-)

The main problem is that banning aes-generic is a bit too rigorous
imo. It highly depends on whether there is known plaintext and whether
there are observable latencies in the first place.

> (Disclaimer: I do not know anything about the aes-generic implementation,
> I'm just taking your word for it that it is not secure (enough) ...)
>
