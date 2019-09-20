From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm-crypt error when CONFIG_CRYPTO_AUTHENC is disabled
Date: Fri, 20 Sep 2019 13:37:07 -0400
Message-ID: <20190920173707.GA21143@redhat.com>
References: <20190920154434.GA923@gandi.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190920154434.GA923@gandi.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Thibaut Sautereau <thibaut.sautereau@clip-os.org>, Milan Broz <gmazyland@gmail.com>
Cc: dm-devel@redhat.com, Alasdair Kergon <agk@redhat.com>, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

On Fri, Sep 20 2019 at 11:44am -0400,
Thibaut Sautereau <thibaut.sautereau@clip-os.org> wrote:

> Hi,
> 
> I just got a dm-crypt "crypt: Error allocating crypto tfm" error when
> trying to "cryptsetup open" a volume. I found out that it was only
> happening when I disabled CONFIG_CRYPTO_AUTHENC.
> 
> drivers/md/dm-crypt.c includes the crypto/authenc.h header and seems to
> use some CRYPTO_AUTHENC-related stuff. Therefore, shouldn't
> CONFIG_DM_CRYPT select CONFIG_CRYPTO_AUTHENC?

Yes, it looks like commit ef43aa38063a6 ("dm crypt: add cryptographic
data integrity protection (authenticated encryption)") should've added
'select CRYPTO_AUTHENC' to dm-crypt's Kconfig.  I'll let Milan weigh-in
but that seems like the right way forward.

Thanks for your report!
Mike
