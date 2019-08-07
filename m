From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [RFC PATCH v2] md/dm-crypt - reuse eboiv skcipher
	for IV generation
Date: Wed, 7 Aug 2019 16:17:14 +0300
Message-ID: <CAKv+Gu_jFW26boEhpnAZg9sjWWZf60FXSWuSqNvC5FJiL7EVSA@mail.gmail.com>
References: <20190807055022.15551-1-ard.biesheuvel@linaro.org>
	<MN2PR20MB297336108DF89337DDEEE2F6CAD40@MN2PR20MB2973.namprd20.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <MN2PR20MB297336108DF89337DDEEE2F6CAD40@MN2PR20MB2973.namprd20.prod.outlook.com>
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

On Wed, 7 Aug 2019 at 10:28, Pascal Van Leeuwen
<pvanleeuwen@verimatrix.com> wrote:
>
> Ard,
>
> I've actually been following this discussion with some interest, as it has
> some relevance for some of the things I am doing at the moment as well.
>
> For example, for my CTS implementation I need to crypt one or two
> seperate blocks and for the inside-secure driver I sometimes need to do
> some single crypto block precomputes. (the XTS driver additionally
> also already did such a single block encrypt for the tweak, also using
> a seperate (non-sk)cipher instance - very similar to your IV case)
>
> Long story short, the current approach is to allocate a seperate
> cipher instance so you can conveniently do crypto_cipher_en/decrypt_one.
> (it would be nice to have a matching crypto_skcipher_en/decrypt_one
> function available from the crypto API for these purposes?)
> But if I understand you correctly, you may end up with an insecure
> table-based implementation if you do that. Not what I want :-(
>

Table based AES is known to be vulnerable to plaintext attacks on the
key, since each byte of the input xor'ed with the key is used as an
index for doing Sbox lookups, and so with enough samples, there is an
exploitable statistical correlation between the response time and the
key.

So in the context of EBOIV, where the user might specify a SIMD based
time invariant skcipher, it would be really bad if the known plaintext
encryptions of the byte offsets that occur with the *same* key would
happen with a different cipher that is allocated implicitly and ends
up being fulfilled by, e.g., aes-generic, since in that case, each
block en/decryption is preceded by a single, time-variant AES
invocation with an easily guessable input.

In your case, we are not dealing with known plaintext attacks, and the
higher latency of h/w accelerated crypto makes me less worried that
the final, user observable latency would strongly correlate the way
aes-generic in isolation does.

> However, in many cases there would actually be a very good reason
> NOT to want to use the main skcipher for this. As that is some
> hardware accelerator with terrible latency that you wouldn't want
> to use to process just one cipher block. For that, you want to have
> some SW implementation that is efficient on a single block instead.
>

Indeed. Note that for EBOIV, such performance concerns are deemed
irrelevant, but it is an issue in the general case.

> In my humble opinion, such insecure table based implementations just
> shouldn't exist at all - you can always do better, possibly at the
> expense of some performance degradation. Or you should at least have
> some flag  available to specify you have some security requirements
> and such an implementation is not an acceptable response.
>

We did some work to reduce the time variance of AES: there is the
aes-ti driver, and there is now also the AES library, which is known
to be slower than aes-generic, but does include some mitigations for
cache timing attacks.

Other than that, I have little to offer, given that the performance vs
security tradeoffs were decided long before security became a thing
like it is today, and so removing aes-generic is not an option,
especially since the scalar alternatives we have are not truly time
invariant either.


> > -----Original Message-----
> > From: linux-crypto-owner@vger.kernel.org <linux-crypto-owner@vger.kernel.org> On Behalf Of
> > Ard Biesheuvel
> > Sent: Wednesday, August 7, 2019 7:50 AM
> > To: linux-crypto@vger.kernel.org
> > Cc: herbert@gondor.apana.org.au; ebiggers@kernel.org; agk@redhat.com; snitzer@redhat.com;
> > dm-devel@redhat.com; gmazyland@gmail.com; Ard Biesheuvel <ard.biesheuvel@linaro.org>
> > Subject: [RFC PATCH v2] md/dm-crypt - reuse eboiv skcipher for IV generation
> >
> > Instead of instantiating a separate cipher to perform the encryption
> > needed to produce the IV, reuse the skcipher used for the block data
> > and invoke it one additional time for each block to encrypt a zero
> > vector and use the output as the IV.
> >
> > For CBC mode, this is equivalent to using the bare block cipher, but
> > without the risk of ending up with a non-time invariant implementation
> > of AES when the skcipher itself is time variant (e.g., arm64 without
> > Crypto Extensions has a NEON based time invariant implementation of
> > cbc(aes) but no time invariant implementation of the core cipher other
> > than aes-ti, which is not enabled by default)
> >
> > This approach is a compromise between dm-crypt API flexibility and
> > reducing dependence on parts of the crypto API that should not usually
> > be exposed to other subsystems, such as the bare cipher API.
> >
> > Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> > ---
> >  drivers/md/dm-crypt.c | 70 ++++++++++++++-----------------------------
> >  1 file changed, 22 insertions(+), 48 deletions(-)
> >
> > diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
> > index d5216bcc4649..48cd76c88d77 100644
> > --- a/drivers/md/dm-crypt.c
> > +++ b/drivers/md/dm-crypt.c
> > @@ -120,10 +120,6 @@ struct iv_tcw_private {
> >       u8 *whitening;
> >  };
> >
> > -struct iv_eboiv_private {
> > -     struct crypto_cipher *tfm;
> > -};
> > -
> >  /*
> >   * Crypt: maps a linear range of a block device
> >   * and encrypts / decrypts at the same time.
> > @@ -163,7 +159,6 @@ struct crypt_config {
> >               struct iv_benbi_private benbi;
> >               struct iv_lmk_private lmk;
> >               struct iv_tcw_private tcw;
> > -             struct iv_eboiv_private eboiv;
> >       } iv_gen_private;
> >       u64 iv_offset;
> >       unsigned int iv_size;
> > @@ -847,65 +842,47 @@ static int crypt_iv_random_gen(struct crypt_config *cc, u8 *iv,
> >       return 0;
> >  }
> >
> > -static void crypt_iv_eboiv_dtr(struct crypt_config *cc)
> > -{
> > -     struct iv_eboiv_private *eboiv = &cc->iv_gen_private.eboiv;
> > -
> > -     crypto_free_cipher(eboiv->tfm);
> > -     eboiv->tfm = NULL;
> > -}
> > -
> >  static int crypt_iv_eboiv_ctr(struct crypt_config *cc, struct dm_target *ti,
> >                           const char *opts)
> >  {
> > -     struct iv_eboiv_private *eboiv = &cc->iv_gen_private.eboiv;
> > -     struct crypto_cipher *tfm;
> > -
> > -     tfm = crypto_alloc_cipher(cc->cipher, 0, 0);
> > -     if (IS_ERR(tfm)) {
> > -             ti->error = "Error allocating crypto tfm for EBOIV";
> > -             return PTR_ERR(tfm);
> > +     if (test_bit(CRYPT_MODE_INTEGRITY_AEAD, &cc->cipher_flags)) {
> > +             ti->error = "AEAD transforms not supported for EBOIV";
> > +             return -EINVAL;
> >       }
> >
> > -     if (crypto_cipher_blocksize(tfm) != cc->iv_size) {
> > +     if (crypto_skcipher_blocksize(any_tfm(cc)) != cc->iv_size) {
> >               ti->error = "Block size of EBOIV cipher does "
> >                           "not match IV size of block cipher";
> > -             crypto_free_cipher(tfm);
> >               return -EINVAL;
> >       }
> >
> > -     eboiv->tfm = tfm;
> >       return 0;
> >  }
> >
> > -static int crypt_iv_eboiv_init(struct crypt_config *cc)
> > +static int crypt_iv_eboiv_gen(struct crypt_config *cc, u8 *iv,
> > +                         struct dm_crypt_request *dmreq)
> >  {
> > -     struct iv_eboiv_private *eboiv = &cc->iv_gen_private.eboiv;
> > +     u8 buf[MAX_CIPHER_BLOCKSIZE] __aligned(__alignof__(__le64));
> > +     struct skcipher_request *req;
> > +     struct scatterlist src, dst;
> > +     struct crypto_wait wait;
> >       int err;
> >
> > -     err = crypto_cipher_setkey(eboiv->tfm, cc->key, cc->key_size);
> > -     if (err)
> > -             return err;
> > -
> > -     return 0;
> > -}
> > -
> > -static int crypt_iv_eboiv_wipe(struct crypt_config *cc)
> > -{
> > -     /* Called after cc->key is set to random key in crypt_wipe() */
> > -     return crypt_iv_eboiv_init(cc);
> > -}
> > +     req = skcipher_request_alloc(any_tfm(cc), GFP_KERNEL | GFP_NOFS);
> > +     if (!req)
> > +             return -ENOMEM;
> >
> > -static int crypt_iv_eboiv_gen(struct crypt_config *cc, u8 *iv,
> > -                         struct dm_crypt_request *dmreq)
> > -{
> > -     struct iv_eboiv_private *eboiv = &cc->iv_gen_private.eboiv;
> > +     memset(buf, 0, cc->iv_size);
> > +     *(__le64 *)buf = cpu_to_le64(dmreq->iv_sector * cc->sector_size);
> >
> > -     memset(iv, 0, cc->iv_size);
> > -     *(__le64 *)iv = cpu_to_le64(dmreq->iv_sector * cc->sector_size);
> > -     crypto_cipher_encrypt_one(eboiv->tfm, iv, iv);
> > +     sg_init_one(&src, page_address(ZERO_PAGE(0)), cc->iv_size);
> > +     sg_init_one(&dst, iv, cc->iv_size);
> > +     skcipher_request_set_crypt(req, &src, &dst, cc->iv_size, buf);
> > +     skcipher_request_set_callback(req, 0, crypto_req_done, &wait);
> > +     err = crypto_wait_req(crypto_skcipher_encrypt(req), &wait);
> > +     skcipher_request_free(req);
> >
> > -     return 0;
> > +     return err;
> >  }
> >
> >  static const struct crypt_iv_operations crypt_iv_plain_ops = {
> > @@ -962,9 +939,6 @@ static struct crypt_iv_operations crypt_iv_random_ops = {
> >
> >  static struct crypt_iv_operations crypt_iv_eboiv_ops = {
> >       .ctr       = crypt_iv_eboiv_ctr,
> > -     .dtr       = crypt_iv_eboiv_dtr,
> > -     .init      = crypt_iv_eboiv_init,
> > -     .wipe      = crypt_iv_eboiv_wipe,
> >       .generator = crypt_iv_eboiv_gen
> >  };
> >
> > --
> > 2.17.1
>
