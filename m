From: Jieun Kim <jieun.kim4758@gmail.com>
Subject: Re: [PATCH 1/2] drivers: md: dm-log.c: Remove unused variable 'sz'
Date: Tue, 3 Dec 2019 20:25:51 +0900
Message-ID: <CABjvjx27vwFgm8OeOY+mHtHOfsYSxabiAkQ5KDguVcStZ=He1Q@mail.gmail.com>
References: <20191201054219.13146-1-Jieun.Kim4758@gmail.com>
 <201912011539.mNLLB6ra%lkp@intel.com> <20191202173909.GA15687@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20191202173909.GA15687@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: Alasdair Kergon <agk@redhat.com>, dm-devel@redhat.com, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: dm-devel.ids

Thank you for your reply.
I'm sorry for the compile error. I realized that 'sz' is still used.
Next time, i will keep in mind to check out the compile result
correctly before submitting patches.

On Tue, Dec 3, 2019 at 2:39 AM Mike Snitzer <snitzer@redhat.com> wrote:
>
> As you can see below: your patches to remove the seemingly unused sz
> variables won't even compile.  The sz variable is used by the DMEMIT()
> macro.
>
> Nacked-by: Mike Snitzer <snitzer@redhat.com>
>
> On Sun, Dec 01 2019 at  2:46am -0500,
> kbuild test robot <lkp@intel.com> wrote:
>
> > Hi Jieun,
> >
> > Thank you for the patch! Yet something to improve:
> >
> > [auto build test ERROR on dm/for-next]
> > [also build test ERROR on v5.4 next-20191129]
> > [if your patch is applied to the wrong git tree, please drop us a note to help
> > improve the system. BTW, we also suggest to use '--base' option to specify the
> > base tree in git format-patch, please see https://stackoverflow.com/a/37406982]
> >
> > url:    https://github.com/0day-ci/linux/commits/Jieun-Kim/drivers-md-dm-log-c-Remove-unused-variable-sz/20191201-134548
> > base:   https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git for-next
> > config: i386-defconfig (attached as .config)
> > compiler: gcc-7 (Debian 7.5.0-1) 7.5.0
> > reproduce:
> >         # save the attached .config to linux build tree
> >         make ARCH=i386
> >
> > If you fix the issue, kindly add following tag
> > Reported-by: kbuild test robot <lkp@intel.com>
> >
> > All error/warnings (new ones prefixed by >>):
> >
> >    In file included from include/linux/dm-dirty-log.h:16:0,
> >                     from drivers/md/dm-log.c:13:
> >    drivers/md/dm-log.c: In function 'core_status':
> > >> include/linux/device-mapper.h:551:22: error: 'sz' undeclared (first use in this function); did you mean 's8'?
> >     #define DMEMIT(x...) sz += ((sz >= maxlen) ? \
> >                          ^
> > >> drivers/md/dm-log.c:788:3: note: in expansion of macro 'DMEMIT'
> >       DMEMIT("1 %s", log->type->name);
> >       ^~~~~~
> >    include/linux/device-mapper.h:551:22: note: each undeclared identifier is reported only once for each function it appears in
> >     #define DMEMIT(x...) sz += ((sz >= maxlen) ? \
> >                          ^
> > >> drivers/md/dm-log.c:788:3: note: in expansion of macro 'DMEMIT'
> >       DMEMIT("1 %s", log->type->name);
> >       ^~~~~~
> > --
> >    In file included from include/linux/dm-dirty-log.h:16:0,
> >                     from drivers//md/dm-log.c:13:
> >    drivers//md/dm-log.c: In function 'core_status':
> > >> include/linux/device-mapper.h:551:22: error: 'sz' undeclared (first use in this function); did you mean 's8'?
> >     #define DMEMIT(x...) sz += ((sz >= maxlen) ? \
> >                          ^
> >    drivers//md/dm-log.c:788:3: note: in expansion of macro 'DMEMIT'
> >       DMEMIT("1 %s", log->type->name);
> >       ^~~~~~
> >    include/linux/device-mapper.h:551:22: note: each undeclared identifier is reported only once for each function it appears in
> >     #define DMEMIT(x...) sz += ((sz >= maxlen) ? \
> >                          ^
> >    drivers//md/dm-log.c:788:3: note: in expansion of macro 'DMEMIT'
> >       DMEMIT("1 %s", log->type->name);
> >       ^~~~~~
> >
> > vim +/DMEMIT +788 drivers/md/dm-log.c
> >
> > ^1da177e4c3f41 Linus Torvalds     2005-04-16  776
> > ^1da177e4c3f41 Linus Torvalds     2005-04-16  777  #define    DMEMIT_SYNC \
> > ^1da177e4c3f41 Linus Torvalds     2005-04-16  778     if (lc->sync != DEFAULTSYNC) \
> > ^1da177e4c3f41 Linus Torvalds     2005-04-16  779             DMEMIT("%ssync ", lc->sync == NOSYNC ? "no" : "")
> > ^1da177e4c3f41 Linus Torvalds     2005-04-16  780
> > 416cd17b198221 Heinz Mauelshagen  2008-04-24  781  static int core_status(struct dm_dirty_log *log, status_type_t status,
> > ^1da177e4c3f41 Linus Torvalds     2005-04-16  782                    char *result, unsigned int maxlen)
> > ^1da177e4c3f41 Linus Torvalds     2005-04-16  783  {
> > ^1da177e4c3f41 Linus Torvalds     2005-04-16  784     struct log_c *lc = log->context;
> > ^1da177e4c3f41 Linus Torvalds     2005-04-16  785
> > ^1da177e4c3f41 Linus Torvalds     2005-04-16  786     switch(status) {
> > ^1da177e4c3f41 Linus Torvalds     2005-04-16  787     case STATUSTYPE_INFO:
> > 315dcc226f066c Jonathan E Brassow 2007-05-09 @788             DMEMIT("1 %s", log->type->name);
> > ^1da177e4c3f41 Linus Torvalds     2005-04-16  789             break;
> > ^1da177e4c3f41 Linus Torvalds     2005-04-16  790
> > ^1da177e4c3f41 Linus Torvalds     2005-04-16  791     case STATUSTYPE_TABLE:
> > ^1da177e4c3f41 Linus Torvalds     2005-04-16  792             DMEMIT("%s %u %u ", log->type->name,
> > ^1da177e4c3f41 Linus Torvalds     2005-04-16  793                    lc->sync == DEFAULTSYNC ? 1 : 2, lc->region_size);
> > ^1da177e4c3f41 Linus Torvalds     2005-04-16  794             DMEMIT_SYNC;
> > ^1da177e4c3f41 Linus Torvalds     2005-04-16  795     }
> > ^1da177e4c3f41 Linus Torvalds     2005-04-16  796
> > 2a79ee10b97355 Jieun Kim          2019-12-01  797     return 0;
> > ^1da177e4c3f41 Linus Torvalds     2005-04-16  798  }
> > ^1da177e4c3f41 Linus Torvalds     2005-04-16  799
> >
> > :::::: The code at line 788 was first introduced by commit
> > :::::: 315dcc226f066c1d3cef79283dcde807fe0e32d1 dm log: report fault status
> >
> > :::::: TO: Jonathan E Brassow <jbrassow@redhat.com>
> > :::::: CC: Linus Torvalds <torvalds@woody.linux-foundation.org>
> >
> > ---
> > 0-DAY kernel test infrastructure                 Open Source Technology Center
> > https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org Intel Corporation
>
>
