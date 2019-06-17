From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [RFC PATCH 0/3] crypto: switch to shash for ESSIV
	generation
Date: Mon, 17 Jun 2019 17:20:13 +0800
Message-ID: <20190617092012.gk7wrazxh7bwfmjk@gondor.apana.org.au>
References: <20190614083404.20514-1-ard.biesheuvel@linaro.org>
	<20190616204419.GE923@sol.localdomain>
	<CAOtvUMf86_TGYLoAHWuRW0Jz2=cXbHHJnAsZhEvy6SpSp_xgOQ@mail.gmail.com>
	<CAKv+Gu_r_WXf2y=FVYHL-T8gFSV6e4TmGkLNJ-cw6UjK_s=A=g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <CAKv+Gu_r_WXf2y=FVYHL-T8gFSV6e4TmGkLNJ-cw6UjK_s=A=g@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Eric Biggers <ebiggers@kernel.org>, Gilad Ben-Yossef <gilad@benyossef.com>, device-mapper development <dm-devel@redhat.com>, linux-fscrypt@vger.kernel.org, Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
List-Id: dm-devel.ids

On Mon, Jun 17, 2019 at 11:15:01AM +0200, Ard Biesheuvel wrote:
>
> Ah yes, thanks for reminding me. There was some debate in the past
> about this, but I don't remember the details.

I think there were some controversy regarding whether the resulting
code lived in drivers/md or crypto.  I think as long as drivers/md
is the only user of the said code then having it in drivers/md should
be fine.

However, if we end up using/reusing the same code for others such as
fs/crypto then it might make more sense to have them in crypto.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
