From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH v2 0/4] crypto: switch to crypto API for
	ESSIV generation
Date: Wed, 19 Jun 2019 11:14:07 +0200
Message-ID: <CAKv+Gu9q5qTgEeTLCW6ZM6Wu6RK559SjFhsgWis72_6-p6RrZA@mail.gmail.com>
References: <20190618212749.8995-1-ard.biesheuvel@linaro.org>
	<099346ee-af6e-a560-079d-3fb68fb4eeba@gmail.com>
	<CAKv+Gu9MTGSwZgaHyxJKwfiBQzqgNhTs5ue+TC1Ehte-+VBXqg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CAKv+Gu9MTGSwZgaHyxJKwfiBQzqgNhTs5ue+TC1Ehte-+VBXqg@mail.gmail.com>
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
Cc: Herbert Xu <herbert@gondor.apana.org.au>, Eric Biggers <ebiggers@google.com>, linux-fscrypt@vger.kernel.org, Gilad Ben-Yossef <gilad@benyossef.com>, device-mapper development <dm-devel@redhat.com>, "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" <linux-crypto@vger.kernel.org>
List-Id: dm-devel.ids

On Wed, 19 Jun 2019 at 09:11, Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:
>
> On Wed, 19 Jun 2019 at 08:56, Milan Broz <gmazyland@gmail.com> wrote:
> >
> > On 18/06/2019 23:27, Ard Biesheuvel wrote:
> > > This series creates an ESSIV template that produces a skcipher or AEAD
> > > transform based on a tuple of the form '<skcipher>,<cipher>,<shash>'
> > > (or '<aead>,<cipher>,<shash>' for the AEAD case). It exposes the
> > > encapsulated sync or async skcipher/aead by passing through all operations,
> > > while using the cipher/shash pair to transform the input IV into an ESSIV
> > > output IV.
> > >
> > > This matches what both users of ESSIV in the kernel do, and so it is proposed
> > > as a replacement for those, in patches #2 and #4.
> > >
> > > This code has been tested using the fscrypt test suggested by Eric
> > > (generic/549), as well as the mode-test script suggested by Milan for
> > > the dm-crypt case. I also tested the aead case in a virtual machine,
> > > but it definitely needs some wider testing from the dm-crypt experts.
> >
> > Well, I just run "make check" on cyptsetup upstream (32bit VM, Linus' tree
> > with this patcheset applied), and get this on the first api test...
> >
>
> Ugh. Thanks for trying. I will have a look today.
>
>
> > Just try
> > cryptsetup open --type plain -c aes-cbc-essiv:sha256 /dev/sdd test
> >

Apologies, this was a rebase error on my part.

Could you please apply the hunk below and try again?

diff --git a/crypto/essiv.c b/crypto/essiv.c
index 029a65afb4d7..5dc2e592077e 100644
--- a/crypto/essiv.c
+++ b/crypto/essiv.c
@@ -243,6 +243,8 @@ static int essiv_aead_encrypt(struct aead_request *req)
 static int essiv_skcipher_decrypt(struct skcipher_request *req)
 {
        struct essiv_skcipher_request_ctx *rctx = skcipher_request_ctx(req);
+
+       essiv_skcipher_prepare_subreq(req);
        return crypto_skcipher_decrypt(&rctx->blockcipher_req);
 }
