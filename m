From: Andy Shevchenko <andy.shevchenko@gmail.com>
Subject: Re: [PATCH v1] dm-crypt: replace custom implementation of hex2bin()
Date: Fri, 30 Dec 2016 23:51:24 +0200
Message-ID: <CAHp75VdZWT5vH-JNh_PJgRjzFcwwAGT93igfzLBewFGjwu31nA@mail.gmail.com>
References: <1462922651-6465-1-git-send-email-andy.shevchenko@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1462922651-6465-1-git-send-email-andy.shevchenko@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>, linux-raid@vger.kernel.org
Cc: Andy Shevchenko <andy.shevchenko@gmail.com>
List-Id: dm-devel.ids

On Wed, May 11, 2016 at 2:24 AM, Andy Shevchenko
<andy.shevchenko@gmail.com> wrote:
> There is no need to have a duplication of the generic library, i.e. hex2bin().
> Replace the open coded variant.
>

Ping?

> Signed-off-by: Andy Shevchenko <andy.shevchenko@gmail.com>
> ---
>  drivers/md/dm-crypt.c | 27 ++-------------------------
>  1 file changed, 2 insertions(+), 25 deletions(-)
>
> diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
> index 4f3cb35..eb30284 100644
> --- a/drivers/md/dm-crypt.c
> +++ b/drivers/md/dm-crypt.c
> @@ -1407,30 +1407,6 @@ static void kcryptd_queue_crypt(struct dm_crypt_io *io)
>         queue_work(cc->crypt_queue, &io->work);
>  }
>
> -/*
> - * Decode key from its hex representation
> - */
> -static int crypt_decode_key(u8 *key, char *hex, unsigned int size)
> -{
> -       char buffer[3];
> -       unsigned int i;
> -
> -       buffer[2] = '\0';
> -
> -       for (i = 0; i < size; i++) {
> -               buffer[0] = *hex++;
> -               buffer[1] = *hex++;
> -
> -               if (kstrtou8(buffer, 16, &key[i]))
> -                       return -EINVAL;
> -       }
> -
> -       if (*hex != '\0')
> -               return -EINVAL;
> -
> -       return 0;
> -}
> -
>  static void crypt_free_tfms(struct crypt_config *cc)
>  {
>         unsigned i;
> @@ -1502,7 +1478,8 @@ static int crypt_set_key(struct crypt_config *cc, char *key)
>         if (!cc->key_size && strcmp(key, "-"))
>                 goto out;
>
> -       if (cc->key_size && crypt_decode_key(cc->key, key, cc->key_size) < 0)
> +       /* Decode key from its hex representation. */
> +       if (cc->key_size && hex2bin(cc->key, key, cc->key_size) < 0)
>                 goto out;
>
>         set_bit(DM_CRYPT_KEY_VALID, &cc->flags);
> --
> 2.8.2
>



-- 
With Best Regards,
Andy Shevchenko
