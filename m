From: Yury Norov <ynorov@caviumnetworks.com>
Subject: Re: [PATCH v2 4/5] Input: gpio-keys - Switch to bitmap_zalloc()
Date: Sat, 16 Jun 2018 01:06:10 +0300
Message-ID: <20180615220610.GB371@yury-thinkpad>
References: <20180615132017.23889-1-andriy.shevchenko@linux.intel.com>
 <20180615132017.23889-5-andriy.shevchenko@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180615132017.23889-5-andriy.shevchenko@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, Shaohua Li <shli@kernel.org>, linux-raid@vger.kernel.org, Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, mika.westerberg@linux.intel.com
List-Id: dm-devel.ids

On Fri, Jun 15, 2018 at 04:20:16PM +0300, Andy Shevchenko wrote:
> External Email
> 
> Switch to bitmap_zalloc() to show clearly what we are allocating.
> Besides that it returns pointer of bitmap type instead of opaque void *.

Nit. There's no special type for bitmaps, bitmap_zalloc() returns long *.
Is it less opaque than void *, not sure.
 
> Acked-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> ---
>  drivers/input/keyboard/gpio_keys.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/input/keyboard/gpio_keys.c b/drivers/input/keyboard/gpio_keys.c
> index 052e37675086..492a971b95b5 100644
> --- a/drivers/input/keyboard/gpio_keys.c
> +++ b/drivers/input/keyboard/gpio_keys.c
> @@ -196,7 +196,7 @@ static ssize_t gpio_keys_attr_show_helper(struct gpio_keys_drvdata *ddata,
>         ssize_t ret;
>         int i;
> 
> -       bits = kcalloc(BITS_TO_LONGS(n_events), sizeof(*bits), GFP_KERNEL);
> +       bits = bitmap_zalloc(n_events, GFP_KERNEL);
>         if (!bits)
>                 return -ENOMEM;
> 
> @@ -216,7 +216,7 @@ static ssize_t gpio_keys_attr_show_helper(struct gpio_keys_drvdata *ddata,
>         buf[ret++] = '\n';
>         buf[ret] = '\0';
> 
> -       kfree(bits);
> +       bitmap_free(bits);
> 
>         return ret;
>  }
> @@ -240,7 +240,7 @@ static ssize_t gpio_keys_attr_store_helper(struct gpio_keys_drvdata *ddata,
>         ssize_t error;
>         int i;
> 
> -       bits = kcalloc(BITS_TO_LONGS(n_events), sizeof(*bits), GFP_KERNEL);
> +       bits = bitmap_zalloc(n_events, GFP_KERNEL);
>         if (!bits)
>                 return -ENOMEM;
> 
> @@ -284,7 +284,7 @@ static ssize_t gpio_keys_attr_store_helper(struct gpio_keys_drvdata *ddata,
>         mutex_unlock(&ddata->disable_lock);
> 
>  out:
> -       kfree(bits);
> +       bitmap_free(bits);
>         return error;
>  }
> 
> --
> 2.17.1
