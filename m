From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [RFC PATCH 0/3] crypto: switch to shash for ESSIV
	generation
Date: Mon, 17 Jun 2019 16:39:45 +0200
Message-ID: <CAKv+Gu82BLPWrX1UzUBLf7UB+qJT6ZPtkvJ2Sa9t28OpXArhnw@mail.gmail.com>
References: <20190614083404.20514-1-ard.biesheuvel@linaro.org>
	<20190616204419.GE923@sol.localdomain>
	<CAOtvUMf86_TGYLoAHWuRW0Jz2=cXbHHJnAsZhEvy6SpSp_xgOQ@mail.gmail.com>
	<CAKv+Gu_r_WXf2y=FVYHL-T8gFSV6e4TmGkLNJ-cw6UjK_s=A=g@mail.gmail.com>
	<8e58230a-cf0e-5a81-886b-6aa72a8e5265@gmail.com>
	<CAKv+Gu9sb0t6EC=MwVfqTw5TKtatK-c8k3ryNUhV8O0876NV7g@mail.gmail.com>
	<CAKv+Gu-LFShLW-Tt7hwBpni1vQRvv7k+L_bpP-wU86x88v+eRg@mail.gmail.com>
	<90214c3d-55ef-cc3a-3a04-f200d6f96cfd@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <90214c3d-55ef-cc3a-3a04-f200d6f96cfd@gmail.com>
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
Cc: Herbert Xu <herbert@gondor.apana.org.au>, linux-fscrypt@vger.kernel.org, Eric Biggers <ebiggers@kernel.org>, Gilad Ben-Yossef <gilad@benyossef.com>, device-mapper development <dm-devel@redhat.com>, Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
List-Id: dm-devel.ids

On Mon, 17 Jun 2019 at 16:35, Milan Broz <gmazyland@gmail.com> wrote:
>
> On 17/06/2019 15:59, Ard Biesheuvel wrote:
> >
> > So my main question/showstopper at the moment is: which modes do we
> > need to support for ESSIV? Only CBC? Any skcipher? Or both skciphers
> > and AEADs?
>
> Support, or cover by internal test? I think you nee to support everything
> what dmcrypt currently allows, if you want to port dmcrypt to new API.
>
> I know of many systems that use aes-xts-essiv:sha256 (it does not make sense
> much but people just use it).
>
> Some people use serpent and twofish, but we allow any cipher that fits...
>

Sure,  that is all fine

> For the start, run this
> https://gitlab.com/cryptsetup/cryptsetup/blob/master/tests/mode-test
>
> In other words, if you add some additional limit, we are breaking backward compatibility.
> (Despite the configuration is "wrong" from the security point of view.)
>

Yes, but breaking backward compatibility only happens if you break
something that is actually being *used*. So sure,
xts(aes)-essiv:sha256 makes no sense but people use it anyway. But is
that also true for, say, gcm(aes)-essiv:sha256 ?
