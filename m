From: Yury Norov <ynorov@caviumnetworks.com>
Subject: Re: [PATCH v2 5/5] Input: evdev - Switch to bitmap_zalloc()
Date: Sat, 16 Jun 2018 00:42:31 +0300
Message-ID: <20180615214231.GA371@yury-thinkpad>
References: <20180615132017.23889-1-andriy.shevchenko@linux.intel.com>
 <20180615132017.23889-6-andriy.shevchenko@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180615132017.23889-6-andriy.shevchenko@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, Shaohua Li <shli@kernel.org>, linux-raid@vger.kernel.org, Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, mika.westerberg@linux.intel.com
List-Id: dm-devel.ids

Hi Andy,

On Fri, Jun 15, 2018 at 04:20:17PM +0300, Andy Shevchenko wrote:
> Switch to bitmap_zalloc() to show clearly what we are allocating.
> Besides that it returns pointer of bitmap type instead of opaque void *.
> 
> Acked-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> ---
>  drivers/input/evdev.c | 16 +++++++---------
>  1 file changed, 7 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/input/evdev.c b/drivers/input/evdev.c
> index c81c79d01d93..370206f987f9 100644
> --- a/drivers/input/evdev.c
> +++ b/drivers/input/evdev.c
> @@ -481,7 +481,7 @@ static int evdev_release(struct inode *inode, struct file *file)
>         evdev_detach_client(evdev, client);
> 
>         for (i = 0; i < EV_CNT; ++i)
> -               kfree(client->evmasks[i]);
> +               bitmap_free(client->evmasks[i]);
> 
>         kvfree(client);
> 
> @@ -925,17 +925,15 @@ static int evdev_handle_get_val(struct evdev_client *client,
>  {
>         int ret;
>         unsigned long *mem;
> -       size_t len;
> 
> -       len = BITS_TO_LONGS(maxbit) * sizeof(unsigned long);
> -       mem = kmalloc(len, GFP_KERNEL);
> +       mem = bitmap_alloc(maxbit, GFP_KERNEL);
>         if (!mem)
>                 return -ENOMEM;

But in commit message you say you switch to bitmap_zalloc(). IIUC
bitmap_alloc() is OK here. But could you please update comment to
avoid confusing.

> 
>         spin_lock_irq(&dev->event_lock);
>         spin_lock(&client->buffer_lock);
> 
> -       memcpy(mem, bits, len);
> +       bitmap_copy(mem, bits, maxbit);
> 
>         spin_unlock(&dev->event_lock);
> 
> @@ -947,7 +945,7 @@ static int evdev_handle_get_val(struct evdev_client *client,
>         if (ret < 0)
>                 evdev_queue_syn_dropped(client);
> 
> -       kfree(mem);
> +       bitmap_free(mem);
> 
>         return ret;
>  }
> @@ -1003,13 +1001,13 @@ static int evdev_set_mask(struct evdev_client *client,
>         if (!cnt)
>                 return 0;
> 
> -       mask = kcalloc(sizeof(unsigned long), BITS_TO_LONGS(cnt), GFP_KERNEL);
> +       mask = bitmap_zalloc(cnt, GFP_KERNEL);
>         if (!mask)
>                 return -ENOMEM;
> 
>         error = bits_from_user(mask, cnt - 1, codes_size, codes, compat);

If my understanding of bits_from_user() correct, here you can also use
bitmap_alloc(), true?

>         if (error < 0) {
> -               kfree(mask);
> +               bitmap_free(mask);
>                 return error;
>         }
> 
> @@ -1018,7 +1016,7 @@ static int evdev_set_mask(struct evdev_client *client,
>         client->evmasks[type] = mask;
>         spin_unlock_irqrestore(&client->buffer_lock, flags);
> 
> -       kfree(oldmask);
> +       bitmap_free(oldmask);
> 
>         return 0;
>  }
> --
> 2.17.1
