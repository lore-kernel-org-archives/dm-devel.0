From: Yury Norov <ynorov@caviumnetworks.com>
Subject: Re: [PATCH v2 5/5] Input: evdev - Switch to
	bitmap_zalloc()
Date: Wed, 20 Jun 2018 11:13:21 +0300
Message-ID: <20180620081321.GB19364@yury-thinkpad>
References: <20180615132017.23889-1-andriy.shevchenko@linux.intel.com>
	<20180615132017.23889-6-andriy.shevchenko@linux.intel.com>
	<20180615214231.GA371@yury-thinkpad>
	<20180619183316.GI71788@dtor-ws>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20180619183316.GI71788@dtor-ws>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Mike Snitzer <snitzer@redhat.com>, mika.westerberg@linux.intel.com, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, dm-devel@redhat.com, linux-input@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Shaohua Li <shli@kernel.org>, Alasdair Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On Tue, Jun 19, 2018 at 11:33:16AM -0700, Dmitry Torokhov wrote:
> External Email
> 
> On Sat, Jun 16, 2018 at 12:42:31AM +0300, Yury Norov wrote:
> > Hi Andy,
> >
> > On Fri, Jun 15, 2018 at 04:20:17PM +0300, Andy Shevchenko wrote:
> > > Switch to bitmap_zalloc() to show clearly what we are allocating.
> > > Besides that it returns pointer of bitmap type instead of opaque void *.
> > >
> > > Acked-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> > > Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> > > ---
> > >  drivers/input/evdev.c | 16 +++++++---------
> > >  1 file changed, 7 insertions(+), 9 deletions(-)
> > >
> > > diff --git a/drivers/input/evdev.c b/drivers/input/evdev.c
> > > index c81c79d01d93..370206f987f9 100644
> > > --- a/drivers/input/evdev.c
> > > +++ b/drivers/input/evdev.c
> > > @@ -481,7 +481,7 @@ static int evdev_release(struct inode *inode, struct file *file)
> > >         evdev_detach_client(evdev, client);
> > >
> > >         for (i = 0; i < EV_CNT; ++i)
> > > -               kfree(client->evmasks[i]);
> > > +               bitmap_free(client->evmasks[i]);
> > >
> > >         kvfree(client);
> > >
> > > @@ -925,17 +925,15 @@ static int evdev_handle_get_val(struct evdev_client *client,
> > >  {
> > >         int ret;
> > >         unsigned long *mem;
> > > -       size_t len;
> > >
> > > -       len = BITS_TO_LONGS(maxbit) * sizeof(unsigned long);
> > > -       mem = kmalloc(len, GFP_KERNEL);
> > > +       mem = bitmap_alloc(maxbit, GFP_KERNEL);
> > >         if (!mem)
> > >                 return -ENOMEM;
> >
> > But in commit message you say you switch to bitmap_zalloc(). IIUC
> > bitmap_alloc() is OK here. But could you please update comment to
> > avoid confusing.
> >
> > >
> > >         spin_lock_irq(&dev->event_lock);
> > >         spin_lock(&client->buffer_lock);
> > >
> > > -       memcpy(mem, bits, len);
> > > +       bitmap_copy(mem, bits, maxbit);
> > >
> > >         spin_unlock(&dev->event_lock);
> > >
> > > @@ -947,7 +945,7 @@ static int evdev_handle_get_val(struct evdev_client *client,
> > >         if (ret < 0)
> > >                 evdev_queue_syn_dropped(client);
> > >
> > > -       kfree(mem);
> > > +       bitmap_free(mem);
> > >
> > >         return ret;
> > >  }
> > > @@ -1003,13 +1001,13 @@ static int evdev_set_mask(struct evdev_client *client,
> > >         if (!cnt)
> > >                 return 0;
> > >
> > > -       mask = kcalloc(sizeof(unsigned long), BITS_TO_LONGS(cnt), GFP_KERNEL);
> > > +       mask = bitmap_zalloc(cnt, GFP_KERNEL);
> > >         if (!mask)
> > >                 return -ENOMEM;
> > >
> > >         error = bits_from_user(mask, cnt - 1, codes_size, codes, compat);
> >
> > If my understanding of bits_from_user() correct, here you can also use
> > bitmap_alloc(), true?
> 
> bits_from_user() copies as much as user supplied, we want to zero out
> the tail to make sure there is no garbage, so we want to use
> kcalloc/kzalloc/bitmap_zalloc here.

I don't understand that. Tail bits of bitmap (i.e. after last used bit
till the end of last word) are always ignored by kernel code and there's
no matter what was stored in that bits.

(With the exception of copying bitmap from kernel to userspace. For this
case we have bitmap_copy_clear_tail() to avoid unintended exposing kernel
data to user.)

If you know any bitmap function that don't ignore tail bits, this is a
bug and should be fixed.

By the way, bits_from_user() is bad-designed because it takes 2 size
arguments - maxbit and maxlen, and should be reworked. There's a
single user of this function, and I suspect, it can be switched to
existing core API, like bitmap_from_arr32().

Yury
