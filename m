From: Joe Perches <joe@perches.com>
Subject: Re: [PATCH v2 5/5] Input: evdev - Switch to bitmap_zalloc()
Date: Mon, 18 Jun 2018 08:49:37 -0700
Message-ID: <780cba4e119110f2d2a81e237874592cff4d7868.camel@perches.com>
References: <20180615132017.23889-1-andriy.shevchenko@linux.intel.com>
         <20180615132017.23889-6-andriy.shevchenko@linux.intel.com>
         <20180615214231.GA371@yury-thinkpad>
         <CAHp75VcxYPCLYq1J8qqjPdgDdQnWDgZKkavmyEWD8GNxcW2mWg@mail.gmail.com>
         <0a3d86d7746792a2f848cef386941fc182653515.camel@perches.com>
         <8cfbdf809f531f8aa315fe1679c3273858038f41.camel@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <8cfbdf809f531f8aa315fe1679c3273858038f41.camel@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Andy Shevchenko <andy.shevchenko@gmail.com>, Yury Norov <ynorov@caviumnetworks.com>
Cc: agk@redhat.com, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, shli@kernel.org, linux-raid@vger.kernel.org, Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input <linux-input@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Mika Westerberg <mika.westerberg@linux.intel.com>
List-Id: dm-devel.ids

On Mon, 2018-06-18 at 15:02 +0300, Andy Shevchenko wrote:
> On Sat, 2018-06-16 at 12:16 -0700, Joe Perches wrote:
> > On Sat, 2018-06-16 at 21:45 +0300, Andy Shevchenko wrote:
> > > On Sat, Jun 16, 2018 at 12:46 AM Yury Norov <ynorov@caviumnetworks.c
> > > om> wrote:
> > > > On Fri, Jun 15, 2018 at 04:20:17PM +0300, Andy Shevchenko wrote:
> > > > > Switch to bitmap_zalloc() to show clearly what we are
> > > > > allocating.
> > > > > Besides that it returns pointer of bitmap type instead of opaque
> > > > > void *.
> > > 
> > > 
> > > > > +       mem = bitmap_alloc(maxbit, GFP_KERNEL);
> > > > >         if (!mem)
> > > > >                 return -ENOMEM;
> > > > 
> > > > But in commit message you say you switch to bitmap_zalloc(). IIUC
> > > > bitmap_alloc() is OK here. But could you please update comment to
> > > > avoid confusing.
> > > 
> > > There are two places, one with alloc, another with zalloc.
> > > I will clarify this in commit message of next version.
> > > 
> > > > > +       mask = bitmap_zalloc(cnt, GFP_KERNEL);
> > > > >         if (!mask)
> > > > >                 return -ENOMEM;
> > > > > 
> > > > >         error = bits_from_user(mask, cnt - 1, codes_size, codes,
> > > > > compat);
> > > > 
> > > > If my understanding of bits_from_user() correct, here you can also
> > > > use
> > > > bitmap_alloc(), true?
> > 
> > Also it might be useful to have a separate bitmap_from_user
> > to alloc and copy.
> 
> Maybe. I didn't check if there are such users except this driver.
> 
> Anyway, it's out of scope of the series.

That seems incorrect as you are introducing alloc/free helpers.

Perhaps bitmap_dup_user [or some better name] could or should
be one of the helpers.
