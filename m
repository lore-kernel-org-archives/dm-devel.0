From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm-crypt error when CONFIG_CRYPTO_AUTHENC is disabled
Date: Fri, 20 Sep 2019 17:27:46 -0400
Message-ID: <20190920212746.GA22061@redhat.com>
References: <20190920154434.GA923@gandi.net>
 <20190920173707.GA21143@redhat.com>
 <13e25b01-f344-ea1d-8f6c-9d0a60eb1e0f@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <13e25b01-f344-ea1d-8f6c-9d0a60eb1e0f@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Milan Broz <gmazyland@gmail.com>
Cc: Thibaut Sautereau <thibaut.sautereau@clip-os.org>, dm-devel@redhat.com, Alasdair Kergon <agk@redhat.com>, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

On Fri, Sep 20 2019 at  3:21pm -0400,
Milan Broz <gmazyland@gmail.com> wrote:

> On 20/09/2019 19:37, Mike Snitzer wrote:
> > On Fri, Sep 20 2019 at 11:44am -0400,
> > Thibaut Sautereau <thibaut.sautereau@clip-os.org> wrote:
> > 
> >> Hi,
> >>
> >> I just got a dm-crypt "crypt: Error allocating crypto tfm" error when
> >> trying to "cryptsetup open" a volume. I found out that it was only
> >> happening when I disabled CONFIG_CRYPTO_AUTHENC.
> >>
> >> drivers/md/dm-crypt.c includes the crypto/authenc.h header and seems to
> >> use some CRYPTO_AUTHENC-related stuff. Therefore, shouldn't
> >> CONFIG_DM_CRYPT select CONFIG_CRYPTO_AUTHENC?
> > 
> > Yes, it looks like commit ef43aa38063a6 ("dm crypt: add cryptographic
> > data integrity protection (authenticated encryption)") should've added
> > 'select CRYPTO_AUTHENC' to dm-crypt's Kconfig.  I'll let Milan weigh-in
> > but that seems like the right way forward.
> 
> No, I don't this so. It is like you use some algorithm that is just not compiled-in,
> or it is disabled in the current state (because of FIPS mode od so) - it fails
> to initialize it.
> 
> I think we should not force dm-crypt to depend on AEAD - most users
> do not use authenticated encryption, it is perfectly ok to keep this compiled out.
> 
> I do not see any principal difference from disabling any other crypto
> (if you disable XTS mode, it fails to open device that uses it).
> 
> IMO the current config dependence is ok.

That is a good point.  I hadn't considered the kernel compiles just fine
without CRYPTO_AUTHENC.. which it clearly does.

SO I retract the question/thought of updating the Kconfig for dm-crypt
in my previous mail.

Though in hindsight: wonder whether the dm-integrity based dm-crypt
authenticated encryption support should have been exposed as a proper
CONFIG option within the DM_CRYPT section?  Rather than lean on the
crypto subsystem to happily stub out the dm-crypt AEAD and AUTHENC
related code dm-crypt could've established #ifdef boundaries for that
code.

I'm open to suggestions and/or confirmation that the way things are now
is perfectly fine.  But I do see this report as something that should
drive some improvement.

Mike
