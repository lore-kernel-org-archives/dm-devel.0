From: Andy Shevchenko <andy.shevchenko@gmail.com>
Subject: Re: [PATCH v2 3/5] bitmap: Add bitmap_alloc(), bitmap_zalloc() and bitmap_free()
Date: Sat, 16 Jun 2018 21:42:52 +0300
Message-ID: <CAHp75VfH7ZOQDXv+uDpXv8d_KX23-MWnWeWwd7i3RDvhWu_HnQ@mail.gmail.com>
References: <20180615132017.23889-1-andriy.shevchenko@linux.intel.com>
 <20180615132017.23889-4-andriy.shevchenko@linux.intel.com> <20180615222346.GC371@yury-thinkpad>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180615222346.GC371@yury-thinkpad>
Sender: linux-kernel-owner@vger.kernel.org
To: Yury Norov <ynorov@caviumnetworks.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>, agk@redhat.com, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, shli@kernel.org, linux-raid@vger.kernel.org, Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input <linux-input@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Mika Westerberg <mika.westerberg@linux.intel.com>
List-Id: dm-devel.ids

On Sat, Jun 16, 2018 at 1:24 AM Yury Norov <ynorov@caviumnetworks.com> wrote:
> On Fri, Jun 15, 2018 at 04:20:15PM +0300, Andy Shevchenko wrote:
> > A lot of code become ugly because of open coding allocations for bitmaps.
> >
> > Introduce three helpers to allow users be more clear of intention
> > and keep their code neat.
>
> I like the idea. But in following patches you switch to new API only
> couple of drivers.

I have converted much more, indeed.
I published only for couple of drivers as an example. This is I
mentioned in cover letter.

> I think, it worth to switch more, especially core
> users to make new API visible for developers. Brief grepping for
> candidates showse only 17 suspected places:

Yes, but not in this series. Since it covers many subsystems and
drivers the applying that kind of series would take ages. That's why I
have decided to submit for one subsystem only.

-- 
With Best Regards,
Andy Shevchenko
