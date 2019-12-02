From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 1/2] drivers: md: dm-log.c: Remove unused variable 'sz'
Date: Mon, 2 Dec 2019 12:39:10 -0500
Message-ID: <20191202173909.GA15687@redhat.com>
References: <20191201054219.13146-1-Jieun.Kim4758@gmail.com>
 <201912011539.mNLLB6ra%lkp@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <201912011539.mNLLB6ra%lkp@intel.com>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Jieun Kim <jieun.kim4758@gmail.com>
Cc: Alasdair Kergon <agk@redhat.com>, dm-devel@redhat.com, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: dm-devel.ids

As you can see below: your patches to remove the seemingly unused sz
variables won't even compile.  The sz variable is used by the DMEMIT()
macro.

Nacked-by: Mike Snitzer <snitzer@redhat.com>

On Sun, Dec 01 2019 at  2:46am -0500,
kbuild test robot <lkp@intel.com> wrote:

> Hi Jieun,
>=20
> Thank you for the patch! Yet something to improve:
>=20
> [auto build test ERROR on dm/for-next]
> [also build test ERROR on v5.4 next-20191129]
> [if your patch is applied to the wrong git tree, please drop us a note to=
 help
> improve the system. BTW, we also suggest to use '--base' option to specif=
y the
> base tree in git format-patch, please see https://stackoverflow.com/a/374=
06982]
>=20
> url:    https://github.com/0day-ci/linux/commits/Jieun-Kim/drivers-md-dm-=
log-c-Remove-unused-variable-sz/20191201-134548
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/lin=
ux-dm.git for-next
> config: i386-defconfig (attached as .config)
> compiler: gcc-7 (Debian 7.5.0-1) 7.5.0
> reproduce:
>         # save the attached .config to linux build tree
>         make ARCH=3Di386=20
>=20
> If you fix the issue, kindly add following tag
> Reported-by: kbuild test robot <lkp@intel.com>
>=20
> All error/warnings (new ones prefixed by >>):
>=20
>    In file included from include/linux/dm-dirty-log.h:16:0,
>                     from drivers/md/dm-log.c:13:
>    drivers/md/dm-log.c: In function 'core_status':
> >> include/linux/device-mapper.h:551:22: error: 'sz' undeclared (first us=
e in this function); did you mean 's8'?
>     #define DMEMIT(x...) sz +=3D ((sz >=3D maxlen) ? \
>                          ^
> >> drivers/md/dm-log.c:788:3: note: in expansion of macro 'DMEMIT'
>       DMEMIT("1 %s", log->type->name);
>       ^~~~~~
>    include/linux/device-mapper.h:551:22: note: each undeclared identifier=
 is reported only once for each function it appears in
>     #define DMEMIT(x...) sz +=3D ((sz >=3D maxlen) ? \
>                          ^
> >> drivers/md/dm-log.c:788:3: note: in expansion of macro 'DMEMIT'
>       DMEMIT("1 %s", log->type->name);
>       ^~~~~~
> --
>    In file included from include/linux/dm-dirty-log.h:16:0,
>                     from drivers//md/dm-log.c:13:
>    drivers//md/dm-log.c: In function 'core_status':
> >> include/linux/device-mapper.h:551:22: error: 'sz' undeclared (first us=
e in this function); did you mean 's8'?
>     #define DMEMIT(x...) sz +=3D ((sz >=3D maxlen) ? \
>                          ^
>    drivers//md/dm-log.c:788:3: note: in expansion of macro 'DMEMIT'
>       DMEMIT("1 %s", log->type->name);
>       ^~~~~~
>    include/linux/device-mapper.h:551:22: note: each undeclared identifier=
 is reported only once for each function it appears in
>     #define DMEMIT(x...) sz +=3D ((sz >=3D maxlen) ? \
>                          ^
>    drivers//md/dm-log.c:788:3: note: in expansion of macro 'DMEMIT'
>       DMEMIT("1 %s", log->type->name);
>       ^~~~~~
>=20
> vim +/DMEMIT +788 drivers/md/dm-log.c
>=20
> ^1da177e4c3f41 Linus Torvalds     2005-04-16  776 =20
> ^1da177e4c3f41 Linus Torvalds     2005-04-16  777  #define=09DMEMIT_SYNC =
\
> ^1da177e4c3f41 Linus Torvalds     2005-04-16  778  =09if (lc->sync !=3D D=
EFAULTSYNC) \
> ^1da177e4c3f41 Linus Torvalds     2005-04-16  779  =09=09DMEMIT("%ssync "=
, lc->sync =3D=3D NOSYNC ? "no" : "")
> ^1da177e4c3f41 Linus Torvalds     2005-04-16  780 =20
> 416cd17b198221 Heinz Mauelshagen  2008-04-24  781  static int core_status=
(struct dm_dirty_log *log, status_type_t status,
> ^1da177e4c3f41 Linus Torvalds     2005-04-16  782  =09=09       char *res=
ult, unsigned int maxlen)
> ^1da177e4c3f41 Linus Torvalds     2005-04-16  783  {
> ^1da177e4c3f41 Linus Torvalds     2005-04-16  784  =09struct log_c *lc =
=3D log->context;
> ^1da177e4c3f41 Linus Torvalds     2005-04-16  785 =20
> ^1da177e4c3f41 Linus Torvalds     2005-04-16  786  =09switch(status) {
> ^1da177e4c3f41 Linus Torvalds     2005-04-16  787  =09case STATUSTYPE_INF=
O:
> 315dcc226f066c Jonathan E Brassow 2007-05-09 @788  =09=09DMEMIT("1 %s", l=
og->type->name);
> ^1da177e4c3f41 Linus Torvalds     2005-04-16  789  =09=09break;
> ^1da177e4c3f41 Linus Torvalds     2005-04-16  790 =20
> ^1da177e4c3f41 Linus Torvalds     2005-04-16  791  =09case STATUSTYPE_TAB=
LE:
> ^1da177e4c3f41 Linus Torvalds     2005-04-16  792  =09=09DMEMIT("%s %u %u=
 ", log->type->name,
> ^1da177e4c3f41 Linus Torvalds     2005-04-16  793  =09=09       lc->sync =
=3D=3D DEFAULTSYNC ? 1 : 2, lc->region_size);
> ^1da177e4c3f41 Linus Torvalds     2005-04-16  794  =09=09DMEMIT_SYNC;
> ^1da177e4c3f41 Linus Torvalds     2005-04-16  795  =09}
> ^1da177e4c3f41 Linus Torvalds     2005-04-16  796 =20
> 2a79ee10b97355 Jieun Kim          2019-12-01  797  =09return 0;
> ^1da177e4c3f41 Linus Torvalds     2005-04-16  798  }
> ^1da177e4c3f41 Linus Torvalds     2005-04-16  799 =20
>=20
> :::::: The code at line 788 was first introduced by commit
> :::::: 315dcc226f066c1d3cef79283dcde807fe0e32d1 dm log: report fault stat=
us
>=20
> :::::: TO: Jonathan E Brassow <jbrassow@redhat.com>
> :::::: CC: Linus Torvalds <torvalds@woody.linux-foundation.org>
>=20
> ---
> 0-DAY kernel test infrastructure                 Open Source Technology C=
enter
> https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org Intel Corpor=
ation
