From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: [PATCH v4 0/5] bitmap: Introduce alloc/free helpers
Date: Wed, 1 Aug 2018 18:03:25 -0700
Message-ID: <20180802010325.GB184797@dtor-ws>
References: <20180630201750.2588-1-andriy.shevchenko@linux.intel.com>
 <CAHp75Vd9RSxVsYrbiAFJKLPL4wNzAtS9qAPjCNJJ4E=QbeTP8A@mail.gmail.com>
 <2310fa540b9e5db3b94f4917ecae76dce2a2ca65.camel@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <2310fa540b9e5db3b94f4917ecae76dce2a2ca65.camel@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Andy Shevchenko <andy.shevchenko@gmail.com>, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, device-mapper development <dm-devel@redhat.com>, Shaohua Li <shli@kernel.org>, linux-raid@vger.kernel.org, linux-input <linux-input@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Yury Norov <ynorov@caviumnetworks.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Mika Westerberg <mika.westerberg@linux.intel.com>, Joe Perches <joe@perches.com>
List-Id: dm-devel.ids

On Tue, Jul 24, 2018 at 02:35:53PM +0300, Andy Shevchenko wrote:
> On Thu, 2018-07-05 at 00:30 +0300, Andy Shevchenko wrote:
> > On Sat, Jun 30, 2018 at 11:17 PM, Andy Shevchenko
> > <andriy.shevchenko@linux.intel.com> wrote:
> > > A lot of code is using allocation of bitmaps using BITS_PER_LONG()
> > > macro and
> > > sizeof(unsigned long) operator. The readability suffers because of
> > > this.
> > > 
> > > The series introduces three helpers, i.e. bitmap_alloc(),
> > > bitmap_zalloc() and
> > > bitmap_free(), to make it more cleaner.
> > > 
> > 
> > Dmitry, it seems we are all set now and if you have no objections
> > against this version, it would be nice to see it in your tree followed
> > by upstream.
> 
> Gentle ping!

I put the first 3 patches into an immutable branch off 4.17:

git://git.kernel.org/pub/scm/linux/kernel/git/dtor/input.git ib/4.17-bitmap

and queued it and the other 2 patches for the next merge window.

Thanks.

-- 
Dmitry
