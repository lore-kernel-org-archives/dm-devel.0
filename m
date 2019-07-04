From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH 3/3] dm-crypt: Implement eboiv - encrypted
 byte-offset initialization vector.
Date: Thu, 4 Jul 2019 16:30:36 +0200
Message-ID: <CAKv+Gu8a6cBQYsbYs8CDyGbhHx0E=+1SU7afqoy9Cs+K8PMfqA@mail.gmail.com>
References: <20190704131033.9919-1-gmazyland@gmail.com>
	<20190704131033.9919-3-gmazyland@gmail.com>
	<7a8d13ee-2d3f-5357-48c6-37f56d7eff07@gmail.com>
	<CAKv+Gu_c+OpOwrr0dSM=j=HiDpfM4sarq6u=6AXrU8jwLaEr-w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CAKv+Gu_c+OpOwrr0dSM=j=HiDpfM4sarq6u=6AXrU8jwLaEr-w@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Milan Broz <gmazyland@gmail.com>, Eric Biggers <ebiggers@google.com>
Cc: device-mapper development <dm-devel@redhat.com>, Herbert Xu <herbert@gondor.apana.org.au>, "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" <linux-crypto@vger.kernel.org>
List-Id: dm-devel.ids

On Thu, 4 Jul 2019 at 16:28, Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:
>
> (+ Eric)
>
> On Thu, 4 Jul 2019 at 15:29, Milan Broz <gmazyland@gmail.com> wrote:
> >
> > Hi Herbert,
> >
> > I have a question about the crypto_cipher API in dm-crypt:
> >
> > We are apparently trying to deprecate cryto_cipher API (see the ESSIV patchset),
> > but I am not sure what API now should be used instead.
> >
>
> Not precisely - what I would like to do is to make the cipher part of
> the internal crypto API. The reason is that there are too many
> occurrences where non-trivial chaining modes have been cobbled
> together from the cipher API.
>
> > See the patch below - all we need is to one block encryption for IV.
> >
> > This algorithm makes sense only for FDE (old compatible Bitlocker devices),
> > I really do not want this to be shared in some crypto module...
> >
> > What API should I use here? Sync skcipher? Is the crypto_cipher API
> > really a problem in this case?
> >
>
> Are arbitrary ciphers supported? Or are you only interested in AES? In
> the former case, I'd suggest the sync skcipher API to instantiate
> "ecb(%s)", otherwise, use the upcoming AES library interface.
>

Actually, if CBC is the only supported mode, you could also use the
skcipher itself to encrypt a single block of input (just encrypt the
IV using CBC but with an IV of all zeroes)


> > On 04/07/2019 15:10, Milan Broz wrote:
> > > This IV is used in some BitLocker devices with CBC encryption mode.
> > >
> > > NOTE: maybe we need to use another crypto API if the bare cipher
> > >       API is going to be deprecated.
> > >
> > > Signed-off-by: Milan Broz <gmazyland@gmail.com>
> > > ---
> > >  drivers/md/dm-crypt.c | 82 ++++++++++++++++++++++++++++++++++++++++++-
> > >  1 file changed, 81 insertions(+), 1 deletion(-)
> > >
> > > diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
> > > index 96ead4492787..a5ffa1ac6a28 100644
> > > --- a/drivers/md/dm-crypt.c
> > > +++ b/drivers/md/dm-crypt.c
> > > @@ -120,6 +120,10 @@ struct iv_tcw_private {
> > >       u8 *whitening;
> > >  };
> > >
> > > +struct iv_eboiv_private {
> > > +     struct crypto_cipher *tfm;
> > > +};
> > > +
> > >  /*
> > >   * Crypt: maps a linear range of a block device
> > >   * and encrypts / decrypts at the same time.
> > > @@ -159,6 +163,7 @@ struct crypt_config {
> > >               struct iv_benbi_private benbi;
> > >               struct iv_lmk_private lmk;
> > >               struct iv_tcw_private tcw;
> > > +             struct iv_eboiv_private eboiv;
> > >       } iv_gen_private;
> > >       u64 iv_offset;
> > >       unsigned int iv_size;
> > > @@ -290,6 +295,10 @@ static struct crypto_aead *any_tfm_aead(struct crypt_config *cc)
> > >   *       is calculated from initial key, sector number and mixed using CRC32.
> > >   *       Note that this encryption scheme is vulnerable to watermarking attacks
> > >   *       and should be used for old compatible containers access only.
> > > + *
> > > + * eboiv: Encrypted byte-offset IV (used in Bitlocker in CBC mode)
> > > + *        The IV is encrypted little-endian byte-offset (with the same key
> > > + *        and cipher as the volume).
> > >   */
> > >
> > >  static int crypt_iv_plain_gen(struct crypt_config *cc, u8 *iv,
> > > @@ -838,6 +847,67 @@ static int crypt_iv_random_gen(struct crypt_config *cc, u8 *iv,
> > >       return 0;
> > >  }
> > >
> > > +static void crypt_iv_eboiv_dtr(struct crypt_config *cc)
> > > +{
> > > +     struct iv_eboiv_private *eboiv = &cc->iv_gen_private.eboiv;
> > > +
> > > +     crypto_free_cipher(eboiv->tfm);
> > > +     eboiv->tfm = NULL;
> > > +}
> > > +
> > > +static int crypt_iv_eboiv_ctr(struct crypt_config *cc, struct dm_target *ti,
> > > +                         const char *opts)
> > > +{
> > > +     struct iv_eboiv_private *eboiv = &cc->iv_gen_private.eboiv;
> > > +     struct crypto_cipher *tfm;
> > > +
> > > +     tfm = crypto_alloc_cipher(cc->cipher, 0, 0);
> > > +     if (IS_ERR(tfm)) {
> > > +             ti->error = "Error allocating crypto tfm for EBOIV";
> > > +             return PTR_ERR(tfm);
> > > +     }
> > > +
> > > +     if (crypto_cipher_blocksize(tfm) != cc->iv_size) {
> > > +             ti->error = "Block size of EBOIV cipher does "
> > > +                         "not match IV size of block cipher";
> > > +             crypto_free_cipher(tfm);
> > > +             return -EINVAL;
> > > +     }
> > > +
> > > +     eboiv->tfm = tfm;
> > > +     return 0;
> > > +}
> > > +
> > > +static int crypt_iv_eboiv_init(struct crypt_config *cc)
> > > +{
> > > +     struct iv_eboiv_private *eboiv = &cc->iv_gen_private.eboiv;
> > > +     int err;
> > > +
> > > +     err = crypto_cipher_setkey(eboiv->tfm, cc->key, cc->key_size);
> > > +     if (err)
> > > +             return err;
> > > +
> > > +     return 0;
> > > +}
> > > +
> > > +static int crypt_iv_eboiv_wipe(struct crypt_config *cc)
> > > +{
> > > +     /* Called after cc->key is set to random key in crypt_wipe() */
> > > +     return crypt_iv_eboiv_init(cc);
> > > +}
> > > +
> > > +static int crypt_iv_eboiv_gen(struct crypt_config *cc, u8 *iv,
> > > +                         struct dm_crypt_request *dmreq)
> > > +{
> > > +     struct iv_eboiv_private *eboiv = &cc->iv_gen_private.eboiv;
> > > +
> > > +     memset(iv, 0, cc->iv_size);
> > > +     *(__le64 *)iv = cpu_to_le64(dmreq->iv_sector * cc->sector_size);
> > > +     crypto_cipher_encrypt_one(eboiv->tfm, iv, iv);
> > > +
> > > +     return 0;
> > > +}
> > > +
> > >  static const struct crypt_iv_operations crypt_iv_plain_ops = {
> > >       .generator = crypt_iv_plain_gen
> > >  };
> > > @@ -890,6 +960,14 @@ static struct crypt_iv_operations crypt_iv_random_ops = {
> > >       .generator = crypt_iv_random_gen
> > >  };
> > >
> > > +static struct crypt_iv_operations crypt_iv_eboiv_ops = {
> > > +     .ctr       = crypt_iv_eboiv_ctr,
> > > +     .dtr       = crypt_iv_eboiv_dtr,
> > > +     .init      = crypt_iv_eboiv_init,
> > > +     .wipe      = crypt_iv_eboiv_wipe,
> > > +     .generator = crypt_iv_eboiv_gen
> > > +};
> > > +
> > >  /*
> > >   * Integrity extensions
> > >   */
> > > @@ -2293,6 +2371,8 @@ static int crypt_ctr_ivmode(struct dm_target *ti, const char *ivmode)
> > >               cc->iv_gen_ops = &crypt_iv_benbi_ops;
> > >       else if (strcmp(ivmode, "null") == 0)
> > >               cc->iv_gen_ops = &crypt_iv_null_ops;
> > > +     else if (strcmp(ivmode, "eboiv") == 0)
> > > +             cc->iv_gen_ops = &crypt_iv_eboiv_ops;
> > >       else if (strcmp(ivmode, "lmk") == 0) {
> > >               cc->iv_gen_ops = &crypt_iv_lmk_ops;
> > >               /*
> > > @@ -3093,7 +3173,7 @@ static void crypt_io_hints(struct dm_target *ti, struct queue_limits *limits)
> > >
> > >  static struct target_type crypt_target = {
> > >       .name   = "crypt",
> > > -     .version = {1, 18, 1},
> > > +     .version = {1, 19, 0},
> > >       .module = THIS_MODULE,
> > >       .ctr    = crypt_ctr,
> > >       .dtr    = crypt_dtr,
> > >
