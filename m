From: Joe Perches <joe@perches.com>
Subject: Re: [PATCH v2 5/5] Input: evdev - Switch to bitmap_zalloc()
Date: Mon, 18 Jun 2018 13:40:20 -0700
Message-ID: <0ac0c93919e40d0c610419fa12e852e889d490e6.camel@perches.com>
References: <20180615132017.23889-1-andriy.shevchenko@linux.intel.com>
         <20180615132017.23889-6-andriy.shevchenko@linux.intel.com>
         <20180615214231.GA371@yury-thinkpad>
         <CAHp75VcxYPCLYq1J8qqjPdgDdQnWDgZKkavmyEWD8GNxcW2mWg@mail.gmail.com>
         <0a3d86d7746792a2f848cef386941fc182653515.camel@perches.com>
         <8cfbdf809f531f8aa315fe1679c3273858038f41.camel@linux.intel.com>
         <780cba4e119110f2d2a81e237874592cff4d7868.camel@perches.com>
         <CAHp75VcJLEmDTe0bCx7UkH4xMH44VUrvuFqdc++OYyE-JKd_cg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAHp75VcJLEmDTe0bCx7UkH4xMH44VUrvuFqdc++OYyE-JKd_cg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Yury Norov <ynorov@caviumnetworks.com>, agk@redhat.com, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, shli@kernel.org, linux-raid@vger.kernel.org, Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input <linux-input@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Mika Westerberg <mika.westerberg@linux.intel.com>
List-Id: dm-devel.ids

On Mon, 2018-06-18 at 22:56 +0300, Andy Shevchenko wrote:
> On Mon, Jun 18, 2018 at 6:49 PM, Joe Perches <joe@perches.com> wrote:
> > Perhaps bitmap_dup_user [or some better name] could or should
> > be one of the helpers.
> 
> Can you help with estimation how many existing users need this kind of
> functionality? One of them evdev, which has an open coded variant.

My estimation via cocci script below is 1 existing user,
so it's almost certainly not worthwhile.

$ cat copy_from_user.cocci 
@@
unsigned long *p;
expression e1, e2;
@@

*	copy_from_user(p, e1, e2)
