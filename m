From: Ard Biesheuvel <ardb@kernel.org>
Subject: Re: [PATCH] crypto: mark unused ciphers as obsolete
Date: Fri, 11 Sep 2020 19:30:20 +0300
Message-ID: <CAMj1kXHOrGoGv6Tse9Vju9mTV_+ks8cUMqx_iSQHPfc+2DVkmw@mail.gmail.com>
References: <20200911141103.14832-1-ardb@kernel.org> <CY4PR0401MB3652AD749C06D0ACD9F085F3C3240@CY4PR0401MB3652.namprd04.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-crypto-owner@vger.kernel.org>
In-Reply-To: <CY4PR0401MB3652AD749C06D0ACD9F085F3C3240@CY4PR0401MB3652.namprd04.prod.outlook.com>
Sender: linux-crypto-owner@vger.kernel.org
To: "Van Leeuwen, Pascal" <pvanleeuwen@rambus.com>, dm-devel@redhat.com, Milan Broz <gmazyland@gmail.com>
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>, "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>, "ebiggers@kernel.org" <ebiggers@kernel.org>
List-Id: dm-devel.ids

(cc Milan and dm-devel)

On Fri, 11 Sep 2020 at 19:24, Van Leeuwen, Pascal
<pvanleeuwen@rambus.com> wrote:
>
> > -----Original Message-----
> > From: linux-crypto-owner@vger.kernel.org <linux-crypto-owner@vger.kerne=
l.org> On Behalf Of Ard Biesheuvel
> > Sent: Friday, September 11, 2020 4:11 PM
> > To: linux-crypto@vger.kernel.org
> > Cc: herbert@gondor.apana.org.au; ebiggers@kernel.org; Ard Biesheuvel <a=
rdb@kernel.org>
> > Subject: [PATCH] crypto: mark unused ciphers as obsolete
> >
> > <<< External Email >>>
> > We have a few interesting pieces in our cipher museum, which are never
> > used internally, and were only ever provided as generic C implementatio=
ns.
> >
> > Unfortunately, we cannot simply remove this code, as we cannot be sure
> > that it is not being used via the AF_ALG socket API, however unlikely.
> > So let's mark the Anubis, Khazad, SEED and TEA algorithms as obsolete,
> >
> Wouldn't the IKE deamon be able to utilize these algorithms through the X=
FRM API?
> I'm by no means an expert on the subject, but it looks like the cipher te=
mplate is
> provided there directly via XFRM, so it does not need to live in the kern=
el source.
> And I know for a fact that SEED is being used for IPsec (and TLS) in Kore=
a.
>

I have been staring at net/xfrm/xfrm_algo.c, and as far as I can tell,
algorithms have to be mentioned there in order to be usable. None of
the ciphers that this patch touches are listed there or anywhere else
in the kernel.

> The point being, there are more users to consider beyond "internal" (mean=
ing hard
> coded in the kernel source in this context?) and AF_ALG.
>

That is a good point, actually, since dm-crypt could be affected here
as well, hence the CCs.

Milan (or others): are you aware of any of these ciphers being used
for dm-crypt?


> I'm not aware of any real use cases for Anubis, Khazad and TEA though.
>

OK, thanks for confirming. Removing those would be a good start.

> > which means they can only be enabled in the build if the socket API is
> > enabled in the first place.
> >
> > Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> > ---
> > Hopefully, I will be able to convince the distro kernel maintainers to
> > disable CRYPTO_USER_API_ENABLE_OBSOLETE in their v5.10+ builds once the
> > iwd changes for arc4 make it downstream (Debian already has an updated
> > version in its unstable distro). With the joint coverage of their QA,
> > we should be able to confirm that these algos are never used, and
> > actually remove them altogether.
> >
> >  crypto/Kconfig | 4 ++++
> >  1 file changed, 4 insertions(+)
> >
> > diff --git a/crypto/Kconfig b/crypto/Kconfig
> > index e85d8a059489..fac10143d23f 100644
> > --- a/crypto/Kconfig
> > +++ b/crypto/Kconfig
> > @@ -1185,6 +1185,7 @@ config CRYPTO_AES_PPC_SPE
> >
> >  config CRYPTO_ANUBIS
> >  tristate "Anubis cipher algorithm"
> > +depends on CRYPTO_USER_API_ENABLE_OBSOLETE
> >  select CRYPTO_ALGAPI
> >  help
> >    Anubis cipher algorithm.
> > @@ -1424,6 +1425,7 @@ config CRYPTO_FCRYPT
> >
> >  config CRYPTO_KHAZAD
> >  tristate "Khazad cipher algorithm"
> > +depends on CRYPTO_USER_API_ENABLE_OBSOLETE
> >  select CRYPTO_ALGAPI
> >  help
> >    Khazad cipher algorithm.
> > @@ -1487,6 +1489,7 @@ config CRYPTO_CHACHA_MIPS
> >
> >  config CRYPTO_SEED
> >  tristate "SEED cipher algorithm"
> > +depends on CRYPTO_USER_API_ENABLE_OBSOLETE
> >  select CRYPTO_ALGAPI
> >  help
> >    SEED cipher algorithm (RFC4269).
> > @@ -1613,6 +1616,7 @@ config CRYPTO_SM4
> >
> >  config CRYPTO_TEA
> >  tristate "TEA, XTEA and XETA cipher algorithms"
> > +depends on CRYPTO_USER_API_ENABLE_OBSOLETE
> >  select CRYPTO_ALGAPI
> >  help
> >    TEA cipher algorithm.
> > --
> > 2.17.1
>
> Regards,
> Pascal van Leeuwen
> Silicon IP Architect Multi-Protocol Engines, Rambus Security
> Rambus ROTW Holding BV
> +31-73 6581953
>
> Note: The Inside Secure/Verimatrix Silicon IP team was recently acquired =
by Rambus.
> Please be so kind to update your e-mail address book with my new e-mail a=
ddress.
>
>
> ** This message and any attachments are for the sole use of the intended =
recipient(s). It may contain information that is confidential and privilege=
d. If you are not the intended recipient of this message, you are prohibite=
d from printing, copying, forwarding or saving it. Please delete the messag=
e and attachments and notify the sender immediately. **
>
> Rambus Inc.<http://www.rambus.com>
