From: Andy Shevchenko <andy.shevchenko@gmail.com>
Subject: Re: [PATCH v2 4/5] Input: gpio-keys - Switch to bitmap_zalloc()
Date: Sat, 16 Jun 2018 21:50:19 +0300
Message-ID: <CAHp75Ve_EMq=+4gvF449z1tM_oMHwRyYx03WCY-Lcet2JwJsjg@mail.gmail.com>
References: <20180615132017.23889-1-andriy.shevchenko@linux.intel.com>
 <20180615132017.23889-5-andriy.shevchenko@linux.intel.com> <20180615220610.GB371@yury-thinkpad>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180615220610.GB371@yury-thinkpad>
Sender: linux-kernel-owner@vger.kernel.org
To: Yury Norov <ynorov@caviumnetworks.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>, agk@redhat.com, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, shli@kernel.org, linux-raid@vger.kernel.org, Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input <linux-input@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Mika Westerberg <mika.westerberg@linux.intel.com>
List-Id: dm-devel.ids

On Sat, Jun 16, 2018 at 1:08 AM Yury Norov <ynorov@caviumnetworks.com> wrote:
>
> On Fri, Jun 15, 2018 at 04:20:16PM +0300, Andy Shevchenko wrote:
> > External Email
> >
> > Switch to bitmap_zalloc() to show clearly what we are allocating.
> > Besides that it returns pointer of bitmap type instead of opaque void *.
>
> Nit. There's no special type for bitmaps, bitmap_zalloc() returns long *.
> Is it less opaque than void *, not sure.

Yes, it enables type checking by compiler, which is good thing.
You can't supply other pointer to this API, like

unsigned char *bar = kmalloc(BITS_PER_LONGS(nbits) * sizeof(unsigned
long), GFP_KERNEL);
...

bitmap_free(bar); //<< compiler will not pass this silently!

Or other way around:

unsigned char *foo = bitmap_alloc(nbits, GFP_KERNEL); //<< wrong types!

-- 
With Best Regards,
Andy Shevchenko
