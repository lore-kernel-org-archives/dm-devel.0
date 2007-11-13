From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: Re: [RFC] How to fix system stall on root volume multipath
Date: Tue, 13 Nov 2007 16:02:23 -0600
Message-ID: <20071113220222.GM28113@ether.msp.redhat.com>
References: <20071109.181719.115904569.k-ueda@ct.jp.nec.com>
	<20071110033113.GA22843@agk.fab.redhat.com>
	<20071112.112454.71086888.k-ueda@ct.jp.nec.com>
	<1194915684.6724.66.camel@localhost.localdomain>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1194915684.6724.66.camel@localhost.localdomain>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@free.fr>
Cc: dm-devel@redhat.com, agk@redhat.com
List-Id: dm-devel.ids

On Tue, Nov 13, 2007 at 02:01:24AM +0100, Christophe Varoqui wrote:
>=20
> Le lundi 12 novembre 2007 =E0 11:24 -0500, Kiyoshi Ueda a =E9crit :
> > Hi Alasdair,
> >=20
> > On Sat, 10 Nov 2007 03:31:13 +0000, Alasdair G Kergon <agk@redhat.com=
> wrote:
> > > On Fri, Nov 09, 2007 at 06:17:19PM -0500, Kiyoshi Ueda wrote:
> > > > If we use multipath for "/", temporal all-paths failure could lea=
d to
> > > > system stall because multipathd depends on callout programs on "/=
".
> > > > I would like to hear your comments about my idea to fix it.
> > > =20
> > > I thought it avoided that problem by pre-loading everything into a =
ramdisk:
> > > did that code get dropped for some reason?
> >=20
> > Thank you for the information!  I had forgotten it!
> > Yes, we used to have it, and it seems to be removed by the commit bel=
ow:
> >     http://git.kernel.org/gitweb.cgi?p=3Dlinux/storage/multipath-tool=
s/.git;a=3Dcommitdiff;h=3Dcad20ecf8919b2126ab6f4f793a1a738e9864f59
> >=20
> > And probably the following thread is related to the commit.
> >     https://www.redhat.com/archives/dm-devel/2005-July/msg00044.html
> >=20
> >=20
> > Ben, Christophe,
> > Is that code still problem for current multipathd?
> > And what do you think about my proposal?
> >=20
> I'm not found of yet-another user-visible ramfs for multipathd use,
> that's why I started with the private namespace tricks. The problems ar=
e
> still there, and will stay till we stop using pthreads.

The original problem that I found wasn't a design issue, it was that
pthreads were not working to correctly. When I try the pthread test progr=
am that
I posted in

https://www.redhat.com/archives/dm-devel/2005-July/msg00044.html

on RHEL 5, the problem seems to be fixed.=20

-Ben

> That may happen someday, as one of the main reason for pthread was the
> (blocking ioctl) libdevmapper event collection. And this is being
> superseded by path status uevents.
>=20
> But not soon enough, and the private namespace stuff suffers from lack
> of friendliness anyway : we can't expect users to grasp easily that
> changing their prioritizer in /sbin won't be seen by the multipath
> daemon till restart, for example.
>=20
> So I propose to start playing with your prioritizers-as-lib idea to see
> if it's practical.
>=20
> I prepared the following patch to that effect. It is not complete
> (actually segfaults, no useful prioritizer ported) but can start fixing
> bugs and go where ever your personnal interest leads.
>=20
> Looking forward to your fixes,
> Thanks,
> cvaroqui

> diff --git a/Makefile.inc b/Makefile.inc
> index 7e2d4e6..1b07ab0 100644
> --- a/Makefile.inc
> +++ b/Makefile.inc
> @@ -24,6 +24,7 @@ exec_prefix =3D $(prefix)
>  bindir      =3D $(exec_prefix)/sbin
>  libudevdir  =3D ${prefix}/lib/udev
>  checkersdir =3D $(TOPDIR)/libcheckers
> +libpriodir  =3D $(TOPDIR)/libprio
>  multipathdir =3D $(TOPDIR)/libmultipath
>  mandir      =3D $(prefix)/usr/share/man/man8
>  man5dir     =3D $(prefix)/usr/share/man/man5
> @@ -33,6 +34,7 @@ GZIP        =3D /bin/gzip -9 -c
> =20
>  CHECKERSLIB =3D $(checkersdir)/libcheckers
>  MULTIPATHLIB =3D $(multipathdir)/libmultipath
> +LIBPRIO =3D $(libpriodir)/libprio
> =20
>  INSTALL_PROGRAM =3D install -s
> =20
> diff --git a/libmultipath/Makefile b/libmultipath/Makefile
> index 511f5ad..04761e4 100644
> --- a/libmultipath/Makefile
> +++ b/libmultipath/Makefile
> @@ -6,7 +6,7 @@ BUILD =3D glibc
> =20
>  include ../Makefile.inc
> =20
> -CFLAGS +=3D -I$(checkersdir)
> +CFLAGS +=3D -I$(checkersdir) -I$(libpriodir)
> =20
>  OBJS =3D memory.o parser.o vector.o devmapper.o callout.o \
>         hwtable.o blacklist.o util.o dmparser.o config.o \
> diff --git a/libmultipath/config.c b/libmultipath/config.c
> index a39af8a..fcca5d8 100644
> --- a/libmultipath/config.c
> +++ b/libmultipath/config.c
> @@ -135,9 +135,6 @@ free_hwe (struct hwentry * hwe)
>  	if (hwe->getuid)
>  		FREE(hwe->getuid);
> =20
> -	if (hwe->getprio)
> -		FREE(hwe->getprio);
> -
>  	if (hwe->features)
>  		FREE(hwe->features);
> =20
> @@ -265,9 +262,6 @@ store_hwe (vector hwtable, struct hwentry * dhwe)
>  	if (dhwe->getuid && !(hwe->getuid =3D set_param_str(dhwe->getuid)))
>  		goto out;
> =20
> -	if (dhwe->getprio && !(hwe->getprio =3D set_param_str(dhwe->getprio))=
)
> -		goto out;
> -			=09
>  	if (dhwe->features && !(hwe->features =3D set_param_str(dhwe->feature=
s)))
>  		goto out;
>  =09
> @@ -283,6 +277,7 @@ store_hwe (vector hwtable, struct hwentry * dhwe)
>  	hwe->no_path_retry =3D dhwe->no_path_retry;
>  	hwe->minio =3D dhwe->minio;
>  	hwe->checker =3D dhwe->checker;
> +	hwe->prio =3D dhwe->prio;
> =20
>  	if (dhwe->bl_product && !(hwe->bl_product =3D set_param_str(dhwe->bl_=
product)))
>  		goto out;
> @@ -321,9 +316,6 @@ free_config (struct config * conf)
>  	if (conf->getuid)
>  		FREE(conf->getuid);
> =20
> -	if (conf->getprio)
> -		FREE(conf->getprio);
> -
>  	if (conf->features)
>  		FREE(conf->features);
> =20
> diff --git a/libmultipath/config.h b/libmultipath/config.h
> index a25b3ad..7f7b2a9 100644
> --- a/libmultipath/config.h
> +++ b/libmultipath/config.h
> @@ -16,11 +16,11 @@ struct hwentry {
>  	char * product;
>  	char * revision;
>  	char * getuid;
> -	char * getprio;
>  	char * features;
>  	char * hwhandler;
>  	char * selector;
>  	char * checker_name;
> +	char * prio_name;
> =20
>  	int pgpolicy;
>  	int pgfailback;
> @@ -28,6 +28,7 @@ struct hwentry {
>  	int no_path_retry;
>  	int minio;
>  	int pg_timeout;
> +	struct prio * prio;
>  	struct checker * checker;
>  	char * bl_product;
>  };
> @@ -53,6 +54,7 @@ struct config {
>  	int pgpolicy_flag;
>  	int with_sysfs;
>  	int pgpolicy;
> +	struct prio * prio;
>  	struct checker * checker;
>  	enum devtypes dev_type;
>  	int minio;
> @@ -70,7 +72,6 @@ struct config {
>  	char * udev_dir;
>  	char * selector;
>  	char * getuid;
> -	char * getprio;
>  	char * features;
>  	char * hwhandler;
>  	char * bindings_file;
> diff --git a/libmultipath/defaults.h b/libmultipath/defaults.h
> index df7d971..97a3dd7 100644
> --- a/libmultipath/defaults.h
> +++ b/libmultipath/defaults.h
> @@ -4,7 +4,6 @@
>  #define DEFAULT_FEATURES	"0"
>  #define DEFAULT_HWHANDLER	"0"
>  #define DEFAULT_MINIO		1000
> -#define DEFAULT_GETPRIO		NULL
>  #define DEFAULT_PGPOLICY       FAILOVER
>  #define DEFAULT_FAILBACK       -FAILBACK_MANUAL
>  #define DEFAULT_RR_WEIGHT      RR_WEIGHT_NONE
> diff --git a/libmultipath/dict.c b/libmultipath/dict.c
> index 4572a7d..bf08a44 100644
> --- a/libmultipath/dict.c
> +++ b/libmultipath/dict.c
> @@ -5,6 +5,7 @@
>   * Copyright (c) 2005 Kiyoshi Ueda, NEC
>   */
>  #include <checkers.h>
> +#include <libprio.h>
> =20
>  #include "vector.h"
>  #include "hwtable.h"
> @@ -82,19 +83,16 @@ def_getuid_callout_handler(vector strvec)
>  }
> =20
>  static int
> -def_prio_callout_handler(vector strvec)
> +def_prio_handler(vector strvec)
>  {
> -	conf->getprio =3D set_value(strvec);
> +	char * buff;
> =20
> -	if (!conf->getprio)
> +	buff =3D set_value(strvec);
> +	if (!buff)
>  		return 1;
> -=09
> -	if (strlen(conf->getprio) =3D=3D 4 &&
> -	    !strcmp(conf->getprio, "none")) {
> -		FREE(conf->getprio);
> -		conf->getprio =3D NULL;
> -	}
> -	=09
> +
> +	conf->prio =3D prio_lookup(buff);
> +	FREE(buff);
>  	return 0;
>  }
> =20
> @@ -571,23 +569,20 @@ hw_handler_handler(vector strvec)
>  }
> =20
>  static int
> -prio_callout_handler(vector strvec)
> +prio_handler(vector strvec)
>  {
>  	struct hwentry * hwe =3D VECTOR_LAST_SLOT(conf->hwtable);
> +	char * buff;
>  =09
>  	if (!hwe)
>  		return 1;
> =20
> -	hwe->getprio =3D set_value(strvec);
> -
> -	if (!hwe->getprio)
> +	buff =3D set_value(strvec);
> +	if (!buff)
>  		return 1;
> -
> -	if (strlen(hwe->getprio) =3D=3D 4 && !strcmp(hwe->getprio, "none")) {
> -		FREE(hwe->getprio);
> -		hwe->getprio =3D NULL;
> -	}
> -
> +=09
> +	hwe->prio =3D prio_lookup(buff);
> +	FREE(buff);
>  	return 0;
>  }
> =20
> @@ -1115,23 +1110,18 @@ snprint_hw_getuid_callout (char * buff, int len=
, void * data)
>  }
> =20
>  static int
> -snprint_hw_prio_callout (char * buff, int len, void * data)
> +snprint_hw_prio (char * buff, int len, void * data)
>  {
>  	struct hwentry * hwe =3D (struct hwentry *)data;
> =20
> -	if (!conf->getprio && !hwe->getprio)
> +	if (!hwe->prio)
>  		return 0;
> -	if (!conf->getprio && hwe->getprio)
> -		return snprintf(buff, len, "%s", hwe->getprio);
> -	if (conf->getprio && !hwe->getprio)
> -		return snprintf(buff, len, "none");
> -
> -	/* conf->getprio && hwe->getprio */
> -	if (strlen(hwe->getprio) =3D=3D strlen(conf->getprio) &&
> -	    !strcmp(hwe->getprio, conf->getprio))
> +	if (!prio_selected(hwe->prio))
>  		return 0;
> -
> -	return snprintf(buff, len, "%s", hwe->getprio);
> +	if (hwe->prio =3D=3D conf->prio)
> +		return 0;
> +=09
> +	return snprintf(buff, len, "%s", prio_name(hwe->prio));
>  }
> =20
>  static int
> @@ -1364,12 +1354,12 @@ snprint_def_getuid_callout (char * buff, int le=
n, void * data)
>  }
> =20
>  static int
> -snprint_def_getprio_callout (char * buff, int len, void * data)
> +snprint_def_prio (char * buff, int len, void * data)
>  {
> -	if (!conf->getprio)
> +	if (!conf->prio)
>  		return 0;
> =20
> -	return snprintf(buff, len, "%s", conf->getprio);
> +	return snprintf(buff, len, "%s", prio_name(conf->prio));
>  }
> =20
>  static int
> @@ -1523,7 +1513,7 @@ init_keywords(void)
>  	install_keyword("selector", &def_selector_handler, &snprint_def_selec=
tor);
>  	install_keyword("path_grouping_policy", &def_pgpolicy_handler, &snpri=
nt_def_path_grouping_policy);
>  	install_keyword("getuid_callout", &def_getuid_callout_handler, &snpri=
nt_def_getuid_callout);
> -	install_keyword("prio_callout", &def_prio_callout_handler, &snprint_d=
ef_getprio_callout);
> +	install_keyword("prio", &def_prio_handler, &snprint_def_prio);
>  	install_keyword("features", &def_features_handler, &snprint_def_featu=
res);
>  	install_keyword("path_checker", &def_path_checker_handler, &snprint_d=
ef_path_checker);
>  	install_keyword("failback", &default_failback_handler, &snprint_def_f=
ailback);
> @@ -1535,7 +1525,7 @@ init_keywords(void)
>  	__deprecated install_keyword("default_selector", &def_selector_handle=
r, NULL);
>  	__deprecated install_keyword("default_path_grouping_policy", &def_pgp=
olicy_handler, NULL);
>  	__deprecated install_keyword("default_getuid_callout", &def_getuid_ca=
llout_handler, NULL);
> -	__deprecated install_keyword("default_prio_callout", &def_prio_callou=
t_handler, NULL);
> +	__deprecated install_keyword("default_prio", &def_prio_handler, NULL)=
;
>  	__deprecated install_keyword("default_features", &def_features_handle=
r, NULL);
>  	__deprecated install_keyword("default_path_checker", &def_path_checke=
r_handler, NULL);
> =20
> @@ -1579,7 +1569,7 @@ init_keywords(void)
>  	install_keyword("path_checker", &hw_path_checker_handler, &snprint_hw=
_path_checker);
>  	install_keyword("features", &hw_features_handler, &snprint_hw_feature=
s);
>  	install_keyword("hardware_handler", &hw_handler_handler, &snprint_hw_=
hardware_handler);
> -	install_keyword("prio_callout", &prio_callout_handler, &snprint_hw_pr=
io_callout);
> +	install_keyword("prio", &prio_handler, &snprint_hw_prio);
>  	install_keyword("failback", &hw_failback_handler, &snprint_hw_failbac=
k);
>  	install_keyword("rr_weight", &hw_weight_handler, &snprint_hw_rr_weigh=
t);
>  	install_keyword("no_path_retry", &hw_no_path_retry_handler, &snprint_=
hw_no_path_retry);
> diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
> index c842eb0..eb096ef 100644
> --- a/libmultipath/discovery.c
> +++ b/libmultipath/discovery.c
> @@ -12,6 +12,7 @@
>  #include <errno.h>
> =20
>  #include <checkers.h>
> +#include <libprio.h>
> =20
>  #include "vector.h"
>  #include "memory.h"
> @@ -626,27 +627,16 @@ get_state (struct path * pp)
>  static int
>  get_prio (struct path * pp)
>  {
> -	char buff[CALLOUT_MAX_SIZE];
> -	char prio[16];
> -
> -	if (!pp->getprio_selected) {
> -		select_getprio(pp);
> -		pp->getprio_selected =3D 1;
> -	}
> -	if (!pp->getprio) {
> -		pp->priority =3D PRIO_DEFAULT;
> -	} else if (apply_format(pp->getprio, &buff[0], pp)) {
> -		condlog(0, "error formatting prio callout command");
> -		pp->priority =3D PRIO_UNDEF;
> -		return 1;
> -	} else if (execute_program(buff, prio, 16)) {
> -		condlog(0, "error calling out %s", buff);
> +	if (!prio_selected(pp->prio))
> +		select_prio(pp);
> +	pp->priority =3D prio_getprio(pp->prio, pp);
> +	if (pp->priority < 0) {
> +		condlog(0, "%s: %s prio error", pp->dev, prio_name(pp->prio));
>  		pp->priority =3D PRIO_UNDEF;
>  		return 1;
> -	} else
> -		pp->priority =3D atoi(prio);
> -
> -	condlog(3, "%s: prio =3D %u", pp->dev, pp->priority);
> +	}
> +	condlog(3, "%s: %s prio =3D %u",
> +		pp->dev, prio_name(pp->prio), pp->priority);
>  	return 0;
>  }
> =20
> diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
> index 43c1310..80b8dd2 100644
> --- a/libmultipath/hwtable.c
> +++ b/libmultipath/hwtable.c
> @@ -1,6 +1,7 @@
>  #include <stdio.h>
> =20
>  #include <checkers.h>
> +#include <libprio.h>
> =20
>  #include "vector.h"
>  #include "defaults.h"
> @@ -27,7 +28,6 @@ static struct hwentry default_hw[] =3D {
>  		.vendor        =3D "APPLE*",
>  		.product       =3D "Xserve RAID ",
>  		.getuid        =3D DEFAULT_GETUID,
> -		.getprio       =3D NULL,
>  		.features      =3D DEFAULT_FEATURES,
>  		.hwhandler     =3D DEFAULT_HWHANDLER,
>  		.selector      =3D DEFAULT_SELECTOR,
> @@ -37,6 +37,7 @@ static struct hwentry default_hw[] =3D {
>  		.no_path_retry =3D NO_PATH_RETRY_UNDEF,
>  		.minio         =3D DEFAULT_MINIO,
>  		.checker_name  =3D DEFAULT_CHECKER,
> +		.prio_name     =3D DEFAULT_PRIO,
>  	},
>  	/*
>  	 * StorageWorks controller family
> @@ -48,7 +49,6 @@ static struct hwentry default_hw[] =3D {
>  		.vendor        =3D "3PARdata",
>  		.product       =3D "VV",
>  		.getuid        =3D DEFAULT_GETUID,
> -		.getprio       =3D NULL,
>  		.features      =3D DEFAULT_FEATURES,
>  		.hwhandler     =3D DEFAULT_HWHANDLER,
>  		.selector      =3D DEFAULT_SELECTOR,
> @@ -58,12 +58,12 @@ static struct hwentry default_hw[] =3D {
>  		.no_path_retry =3D NO_PATH_RETRY_UNDEF,
>  		.minio         =3D DEFAULT_MINIO,
>  		.checker_name  =3D DEFAULT_CHECKER,
> +		.prio_name     =3D DEFAULT_PRIO,
>  	},
>  	{
>  		.vendor        =3D "DEC",
>  		.product       =3D "HSG80",
>  		.getuid        =3D DEFAULT_GETUID,
> -		.getprio       =3D "/sbin/mpath_prio_hp_sw /dev/%n",
>  		.features      =3D "1 queue_if_no_path",
>  		.hwhandler     =3D "1 hp-sw",
>  		.selector      =3D DEFAULT_SELECTOR,
> @@ -73,12 +73,12 @@ static struct hwentry default_hw[] =3D {
>  		.no_path_retry =3D NO_PATH_RETRY_UNDEF,
>  		.minio         =3D DEFAULT_MINIO,
>  		.checker_name  =3D HP_SW,
> +		.prio_name     =3D PRIO_HP_SW,
>  	},
>  	{
>  		.vendor        =3D "HP",
>  		.product       =3D "A6189A",
>  		.getuid        =3D DEFAULT_GETUID,
> -		.getprio       =3D NULL,
>  		.features      =3D DEFAULT_FEATURES,
>  		.hwhandler     =3D DEFAULT_HWHANDLER,
>  		.selector      =3D DEFAULT_SELECTOR,
> @@ -87,14 +87,14 @@ static struct hwentry default_hw[] =3D {
>  		.rr_weight     =3D RR_WEIGHT_NONE,
>  		.no_path_retry =3D NO_PATH_RETRY_UNDEF,
>  		.minio         =3D DEFAULT_MINIO,
> -		.checker_name  =3D READSECTOR0,
> +		.checker_name  =3D DIRECTIO,
> +		.prio_name     =3D DEFAULT_PRIO,
>  	},
>  	{
>  		/* MSA 1000/MSA1500 EVA 3000/5000 with old firmware */
>  		.vendor        =3D "(COMPAQ|HP)",
>  		.product       =3D "(MSA|HSV)1.0.*",
>  		.getuid        =3D DEFAULT_GETUID,
> -		.getprio       =3D "/sbin/mpath_prio_hp_sw /dev/%n",
>  		.features      =3D "1 queue_if_no_path",
>  		.hwhandler     =3D "1 hp-sw",
>  		.selector      =3D DEFAULT_SELECTOR,
> @@ -104,13 +104,13 @@ static struct hwentry default_hw[] =3D {
>  		.no_path_retry =3D NO_PATH_RETRY_UNDEF,
>  		.minio         =3D DEFAULT_MINIO,
>  		.checker_name  =3D HP_SW,
> +		.prio_name     =3D PRIO_HP_SW,
>  	},
>  	{
>  		/* MSA 1000/1500 with new firmware */
>  		.vendor        =3D "HP",
>  		.product       =3D "MSA VOLUME",
>  		.getuid        =3D DEFAULT_GETUID,
> -		.getprio       =3D "/sbin/mpath_prio_alua /dev/%n",
>  		.features      =3D DEFAULT_FEATURES,
>  		.hwhandler     =3D DEFAULT_HWHANDLER,
>  		.selector      =3D DEFAULT_SELECTOR,
> @@ -120,12 +120,12 @@ static struct hwentry default_hw[] =3D {
>  		.no_path_retry =3D NO_PATH_RETRY_UNDEF,
>  		.minio         =3D DEFAULT_MINIO,
>  		.checker_name  =3D TUR,
> +		.prio_name     =3D PRIO_ALUA,
>  	},
>  	{
>  		.vendor        =3D "HP",
>  		.product       =3D "MSA2000s*",
>  		.getuid        =3D "/sbin/cciss_id %n",
> -		.getprio       =3D NULL,
>  		.features      =3D DEFAULT_FEATURES,
>  		.hwhandler     =3D DEFAULT_HWHANDLER,
>  		.selector      =3D DEFAULT_SELECTOR,
> @@ -135,13 +135,13 @@ static struct hwentry default_hw[] =3D {
>  		.no_path_retry =3D 12,
>  		.minio         =3D DEFAULT_MINIO,
>  		.checker_name  =3D TUR,
> +		.prio_name     =3D DEFAULT_PRIO,
>  	},
>  	{
>  		/* EVA 3000/5000 with new firmware */
>  		.vendor        =3D "(COMPAQ|HP)",
>  		.product       =3D "(MSA|HSV)1.1.*",
>  		.getuid        =3D DEFAULT_GETUID,
> -		.getprio       =3D "/sbin/mpath_prio_alua /dev/%n",
>  		.features      =3D DEFAULT_FEATURES,
>  		.hwhandler     =3D DEFAULT_HWHANDLER,
>  		.selector      =3D DEFAULT_SELECTOR,
> @@ -151,13 +151,13 @@ static struct hwentry default_hw[] =3D {
>  		.no_path_retry =3D NO_PATH_RETRY_UNDEF,
>  		.minio         =3D DEFAULT_MINIO,
>  		.checker_name  =3D TUR,
> +		.prio_name     =3D PRIO_ALUA,
>  	},
>  	{
>  		/* EVA 4000/6000/8000 */
>  		.vendor        =3D "HP",
>  		.product       =3D "HSV2.*",
>  		.getuid        =3D DEFAULT_GETUID,
> -		.getprio       =3D "/sbin/mpath_prio_alua /dev/%n",
>  		.features      =3D DEFAULT_FEATURES,
>  		.hwhandler     =3D DEFAULT_HWHANDLER,
>  		.selector      =3D DEFAULT_SELECTOR,
> @@ -167,13 +167,13 @@ static struct hwentry default_hw[] =3D {
>  		.no_path_retry =3D NO_PATH_RETRY_UNDEF,
>  		.minio         =3D DEFAULT_MINIO,
>  		.checker_name  =3D TUR,
> +		.prio_name     =3D PRIO_ALUA,
>  	},
>  	{
>  		/* HP Smart Array */
>  		.vendor        =3D "HP",
>  		.product       =3D "LOGICAL VOLUME.*",
>  		.getuid        =3D "/lib/udev/scsi_id -n -g -u -s /block/%n",
> -		.getprio       =3D NULL,
>  		.features      =3D DEFAULT_FEATURES,
>  		.hwhandler     =3D DEFAULT_HWHANDLER,
>  		.selector      =3D DEFAULT_SELECTOR,
> @@ -183,6 +183,7 @@ static struct hwentry default_hw[] =3D {
>  		.no_path_retry =3D NO_PATH_RETRY_UNDEF,
>  		.minio         =3D DEFAULT_MINIO,
>  		.checker_name  =3D TUR,
> +		.prio_name     =3D DEFAULT_PRIO,
>  	},
>  	/*
>  	 * DDN controller family
> @@ -194,7 +195,6 @@ static struct hwentry default_hw[] =3D {
>  		.vendor        =3D "DDN",
>  		.product       =3D "SAN DataDirector",
>  		.getuid        =3D DEFAULT_GETUID,
> -		.getprio       =3D NULL,
>  		.features      =3D DEFAULT_FEATURES,
>  		.hwhandler     =3D DEFAULT_HWHANDLER,
>  		.selector      =3D DEFAULT_SELECTOR,
> @@ -204,6 +204,7 @@ static struct hwentry default_hw[] =3D {
>  		.no_path_retry =3D NO_PATH_RETRY_UNDEF,
>  		.minio         =3D DEFAULT_MINIO,
>  		.checker_name  =3D DIRECTIO,
> +		.prio_name     =3D DEFAULT_PRIO,
>  	},
>  	/*
>  	 * EMC / Clariion controller family
> @@ -215,7 +216,6 @@ static struct hwentry default_hw[] =3D {
>  		.vendor        =3D "EMC",
>  		.product       =3D "SYMMETRIX",
>  		.getuid        =3D "/lib/udev/scsi_id -g -u -ppre-spc3-83 -s /block/=
%n",
> -		.getprio       =3D NULL,
>  		.features      =3D DEFAULT_FEATURES,
>  		.hwhandler     =3D DEFAULT_HWHANDLER,
>  		.selector      =3D DEFAULT_SELECTOR,
> @@ -224,14 +224,14 @@ static struct hwentry default_hw[] =3D {
>  		.rr_weight     =3D RR_WEIGHT_NONE,
>  		.no_path_retry =3D NO_PATH_RETRY_UNDEF,
>  		.minio         =3D DEFAULT_MINIO,
> -		.checker_name  =3D READSECTOR0,
> +		.checker_name  =3D DIRECTIO,
> +		.prio_name     =3D DEFAULT_PRIO,
>  	},
>  	{
>  		.vendor        =3D "DGC",
>  		.product       =3D ".*",
>  		.bl_product    =3D "LUNZ",
>  		.getuid        =3D DEFAULT_GETUID,
> -		.getprio       =3D "/sbin/mpath_prio_emc /dev/%n",
>  		.features      =3D "1 queue_if_no_path",
>  		.hwhandler     =3D "1 emc",
>  		.selector      =3D DEFAULT_SELECTOR,
> @@ -241,6 +241,7 @@ static struct hwentry default_hw[] =3D {
>  		.no_path_retry =3D (300 / DEFAULT_CHECKINT),
>  		.minio         =3D DEFAULT_MINIO,
>  		.checker_name  =3D EMC_CLARIION,
> +		.prio_name     =3D PRIO_EMC,
>  	},
>  	/*
>  	 * Fujitsu controller family
> @@ -252,7 +253,6 @@ static struct hwentry default_hw[] =3D {
>  		.vendor        =3D "FSC",
>  		.product       =3D "CentricStor",
>  		.getuid        =3D DEFAULT_GETUID,
> -		.getprio       =3D NULL,
>  		.features      =3D DEFAULT_FEATURES,
>  		.hwhandler     =3D DEFAULT_HWHANDLER,
>  		.selector      =3D DEFAULT_SELECTOR,
> @@ -261,7 +261,8 @@ static struct hwentry default_hw[] =3D {
>  		.rr_weight     =3D RR_WEIGHT_NONE,
>  		.no_path_retry =3D NO_PATH_RETRY_UNDEF,
>  		.minio         =3D DEFAULT_MINIO,
> -		.checker_name  =3D READSECTOR0,
> +		.checker_name  =3D DIRECTIO,
> +		.prio_name     =3D DEFAULT_PRIO,
>  	},
>  	/*
>  	 * Hitachi controller family
> @@ -273,7 +274,6 @@ static struct hwentry default_hw[] =3D {
>  		.vendor        =3D "(HITACHI|HP)",
>  		.product       =3D "OPEN-.*",
>  		.getuid        =3D DEFAULT_GETUID,
> -		.getprio       =3D NULL,
>  		.features      =3D "1 queue_if_no_path",
>  		.hwhandler     =3D DEFAULT_HWHANDLER,
>  		.selector      =3D DEFAULT_SELECTOR,
> @@ -283,12 +283,12 @@ static struct hwentry default_hw[] =3D {
>  		.no_path_retry =3D NO_PATH_RETRY_UNDEF,
>  		.minio         =3D DEFAULT_MINIO,
>  		.checker_name  =3D TUR,
> +		.prio_name     =3D DEFAULT_PRIO,
>  	},
>  	{
>  		.vendor        =3D "HITACHI",
>  		.product       =3D "DF.*",
>  		.getuid        =3D DEFAULT_GETUID,
> -		.getprio       =3D "/sbin/mpath_prio_hds_modular /dev/%n",
>  		.features      =3D "1 queue_if_no_path",
>  		.hwhandler     =3D DEFAULT_HWHANDLER,
>  		.selector      =3D DEFAULT_SELECTOR,
> @@ -298,6 +298,7 @@ static struct hwentry default_hw[] =3D {
>  		.no_path_retry =3D NO_PATH_RETRY_UNDEF,
>  		.minio         =3D DEFAULT_MINIO,
>  		.checker_name  =3D TUR,
> +		.prio_name     =3D PRIO_HDS,
>  	},
>  	/*
>  	 * IBM controller family
> @@ -309,7 +310,6 @@ static struct hwentry default_hw[] =3D {
>  		.vendor        =3D "IBM",
>  		.product       =3D "ProFibre 4000R",
>  		.getuid        =3D DEFAULT_GETUID,
> -		.getprio       =3D NULL,
>  		.features      =3D DEFAULT_FEATURES,
>  		.hwhandler     =3D DEFAULT_HWHANDLER,
>  		.selector      =3D DEFAULT_SELECTOR,
> @@ -318,14 +318,14 @@ static struct hwentry default_hw[] =3D {
>  		.rr_weight     =3D RR_WEIGHT_NONE,
>  		.no_path_retry =3D NO_PATH_RETRY_UNDEF,
>  		.minio         =3D DEFAULT_MINIO,
> -		.checker_name  =3D READSECTOR0,
> +		.checker_name  =3D DIRECTIO,
> +		.prio_name     =3D DEFAULT_PRIO,
>  	},
>  	{
>  		/* IBM DS4100 / FAStT100 */
>  		.vendor        =3D "IBM",
>  		.product       =3D "1742",
>  		.getuid        =3D DEFAULT_GETUID,
> -		.getprio       =3D "/sbin/mpath_prio_rdac /dev/%n",
>  		.features      =3D DEFAULT_FEATURES,
>  		.hwhandler     =3D DEFAULT_HWHANDLER,
>  		.selector      =3D DEFAULT_SELECTOR,
> @@ -335,13 +335,13 @@ static struct hwentry default_hw[] =3D {
>  		.no_path_retry =3D NO_PATH_RETRY_UNDEF,
>  		.minio         =3D DEFAULT_MINIO,
>  		.checker_name  =3D TUR,
> +		.prio_name     =3D PRIO_RDAC,
>  	},
>  	{
>  		/* IBM Netfinity Fibre Channel RAID Controller Unit */
>  		.vendor        =3D "IBM",
>  		.product       =3D "3526",
>  		.getuid        =3D DEFAULT_GETUID,
> -		.getprio       =3D "/sbin/mpath_prio_rdac /dev/%n",
>  		.features      =3D DEFAULT_FEATURES,
>  		.hwhandler     =3D DEFAULT_HWHANDLER,
>  		.selector      =3D DEFAULT_SELECTOR,
> @@ -351,13 +351,13 @@ static struct hwentry default_hw[] =3D {
>  		.no_path_retry =3D NO_PATH_RETRY_UNDEF,
>  		.minio         =3D DEFAULT_MINIO,
>  		.checker_name  =3D TUR,
> +		.prio_name     =3D PRIO_RDAC,
>  	},
>  	{
>  		/* IBM DS4200 / FAStT200 */
>  		.vendor        =3D "IBM",
>  		.product       =3D "3542",
>  		.getuid        =3D DEFAULT_GETUID,
> -		.getprio       =3D NULL,
>  		.features      =3D DEFAULT_FEATURES,
>  		.hwhandler     =3D DEFAULT_HWHANDLER,
>  		.selector      =3D DEFAULT_SELECTOR,
> @@ -367,13 +367,13 @@ static struct hwentry default_hw[] =3D {
>  		.no_path_retry =3D NO_PATH_RETRY_UNDEF,
>  		.minio         =3D DEFAULT_MINIO,
>  		.checker_name  =3D TUR,
> +		.prio_name     =3D DEFAULT_PRIO,
>  	},
>  	{
>  		/* IBM ESS F20 aka Shark */
>  		.vendor        =3D "IBM",
>  		.product       =3D "2105(800|F20)",
>  		.getuid        =3D DEFAULT_GETUID,
> -		.getprio       =3D NULL,
>  		.features      =3D "1 queue_if_no_path",
>  		.hwhandler     =3D DEFAULT_HWHANDLER,
>  		.selector      =3D DEFAULT_SELECTOR,
> @@ -383,13 +383,13 @@ static struct hwentry default_hw[] =3D {
>  		.no_path_retry =3D NO_PATH_RETRY_UNDEF,
>  		.minio         =3D DEFAULT_MINIO,
>  		.checker_name  =3D TUR,
> +		.prio_name     =3D DEFAULT_PRIO,
>  	},
>  	{
>  		/* IBM DS6000 */
>  		.vendor        =3D "IBM",
>  		.product       =3D "1750500",
>  		.getuid        =3D DEFAULT_GETUID,
> -		.getprio       =3D "/sbin/mpath_prio_alua /dev/%n",
>  		.features      =3D "1 queue_if_no_path",
>  		.hwhandler     =3D DEFAULT_HWHANDLER,
>  		.selector      =3D DEFAULT_SELECTOR,
> @@ -399,13 +399,13 @@ static struct hwentry default_hw[] =3D {
>  		.no_path_retry =3D NO_PATH_RETRY_UNDEF,
>  		.minio         =3D DEFAULT_MINIO,
>  		.checker_name  =3D TUR,
> +		.prio_name     =3D PRIO_ALUA,
>  	},
>  	{
>  		/* IBM DS8000 */
>  		.vendor        =3D "IBM",
>  		.product       =3D "2107900",
>  		.getuid        =3D DEFAULT_GETUID,
> -		.getprio       =3D NULL,
>  		.features      =3D "1 queue_if_no_path",
>  		.hwhandler     =3D DEFAULT_HWHANDLER,
>  		.selector      =3D DEFAULT_SELECTOR,
> @@ -415,13 +415,13 @@ static struct hwentry default_hw[] =3D {
>  		.no_path_retry =3D NO_PATH_RETRY_UNDEF,
>  		.minio         =3D DEFAULT_MINIO,
>  		.checker_name  =3D TUR,
> +		.prio_name     =3D DEFAULT_PRIO,
>  	},
>  	{
>  		/* IBM SAN Volume Controller */
>  		.vendor        =3D "IBM",
>  		.product       =3D "2145",
>  		.getuid        =3D DEFAULT_GETUID,
> -		.getprio       =3D "/sbin/mpath_prio_alua /dev/%n",
>  		.features      =3D "1 queue_if_no_path",
>  		.hwhandler     =3D DEFAULT_HWHANDLER,
>  		.selector      =3D DEFAULT_SELECTOR,
> @@ -431,6 +431,7 @@ static struct hwentry default_hw[] =3D {
>  		.no_path_retry =3D NO_PATH_RETRY_UNDEF,
>  		.minio         =3D DEFAULT_MINIO,
>  		.checker_name  =3D TUR,
> +		.prio_name     =3D PRIO_ALUA,
>  	},
>  	{
>  		/* IBM S/390 ECKD DASD */
> @@ -438,7 +439,6 @@ static struct hwentry default_hw[] =3D {
>  		.product       =3D "S/390 DASD ECKD",
>  		.bl_product       =3D "S/390.*",
>  		.getuid        =3D "/sbin/dasdinfo -u -b %n",
> -		.getprio       =3D NULL,
>  		.features      =3D "1 queue_if_no_path",
>  		.hwhandler     =3D DEFAULT_HWHANDLER,
>  		.selector      =3D DEFAULT_SELECTOR,
> @@ -448,6 +448,7 @@ static struct hwentry default_hw[] =3D {
>  		.no_path_retry =3D NO_PATH_RETRY_UNDEF,
>  		.minio         =3D DEFAULT_MINIO,
>  		.checker_name  =3D DIRECTIO,
> +		.prio_name     =3D DEFAULT_PRIO,
>  	},
>   	/*
>  	 * NETAPP controller family
> @@ -459,7 +460,6 @@ static struct hwentry default_hw[] =3D {
>  		.vendor        =3D "NETAPP",
>  		.product       =3D "LUN.*",
>  		.getuid        =3D DEFAULT_GETUID,
> -		.getprio       =3D "/sbin/mpath_prio_netapp /dev/%n",
>  		.features      =3D "1 queue_if_no_path",
>  		.hwhandler     =3D DEFAULT_HWHANDLER,
>  		.selector      =3D DEFAULT_SELECTOR,
> @@ -468,7 +468,8 @@ static struct hwentry default_hw[] =3D {
>  		.rr_weight     =3D RR_WEIGHT_NONE,
>  		.no_path_retry =3D NO_PATH_RETRY_UNDEF,
>  		.minio         =3D 128,
> -		.checker_name  =3D READSECTOR0,
> +		.checker_name  =3D DIRECTIO,
> +		.prio_name     =3D PRIO_NETAPP,
>  	},
>   	/*
>  	 * IBM NSeries (NETAPP) controller family
> @@ -480,7 +481,6 @@ static struct hwentry default_hw[] =3D {
>  		.vendor        =3D "IBM",
>  		.product       =3D "Nseries.*",
>  		.getuid        =3D DEFAULT_GETUID,
> -		.getprio       =3D "/sbin/mpath_prio_netapp /dev/%n",
>  		.features      =3D "1 queue_if_no_path",
>  		.hwhandler     =3D DEFAULT_HWHANDLER,
>  		.selector      =3D DEFAULT_SELECTOR,
> @@ -489,7 +489,8 @@ static struct hwentry default_hw[] =3D {
>  		.rr_weight     =3D RR_WEIGHT_NONE,
>  		.no_path_retry =3D NO_PATH_RETRY_UNDEF,
>  		.minio         =3D 128,
> -		.checker_name  =3D READSECTOR0,
> +		.checker_name  =3D DIRECTIO,
> +		.prio_name     =3D PRIO_NETAPP,
>  	},
>  	/*
>  	 * Pillar Data controller family
> @@ -501,7 +502,6 @@ static struct hwentry default_hw[] =3D {
>  		.vendor        =3D "Pillar",
>  		.product       =3D "Axiom.*",
>  		.getuid        =3D DEFAULT_GETUID,
> -		.getprio       =3D "/sbin/mpath_prio_alua %n",
>  		.features      =3D DEFAULT_FEATURES,
>  		.hwhandler     =3D DEFAULT_HWHANDLER,
>  		.selector      =3D DEFAULT_SELECTOR,
> @@ -511,6 +511,7 @@ static struct hwentry default_hw[] =3D {
>  		.no_path_retry =3D NO_PATH_RETRY_UNDEF,
>  		.minio         =3D DEFAULT_MINIO,
>  		.checker_name  =3D TUR,
> +		.prio_name     =3D PRIO_ALUA,
>  	},
>  	/*
>  	 * SGI arrays
> @@ -522,7 +523,6 @@ static struct hwentry default_hw[] =3D {
>  		.vendor        =3D "SGI",
>  		.product       =3D "TP9[13]00",
>  		.getuid        =3D DEFAULT_GETUID,
> -		.getprio       =3D NULL,
>  		.features      =3D DEFAULT_FEATURES,
>  		.hwhandler     =3D DEFAULT_HWHANDLER,
>  		.selector      =3D DEFAULT_SELECTOR,
> @@ -531,13 +531,13 @@ static struct hwentry default_hw[] =3D {
>  		.rr_weight     =3D RR_WEIGHT_NONE,
>  		.no_path_retry =3D NO_PATH_RETRY_UNDEF,
>  		.minio         =3D DEFAULT_MINIO,
> -		.checker_name  =3D READSECTOR0,
> +		.checker_name  =3D DIRECTIO,
> +		.prio_name     =3D DEFAULT_PRIO,
>  	},
>  	{
>  		.vendor        =3D "SGI",
>  		.product       =3D "TP9[45]00",
>  		.getuid        =3D DEFAULT_GETUID,
> -		.getprio       =3D "/sbin/mpath_prio_rdac /dev/%n",
>  		.features      =3D DEFAULT_FEATURES,
>  		.hwhandler     =3D DEFAULT_HWHANDLER,
>  		.selector      =3D DEFAULT_SELECTOR,
> @@ -547,12 +547,12 @@ static struct hwentry default_hw[] =3D {
>  		.no_path_retry =3D NO_PATH_RETRY_QUEUE,
>  		.minio         =3D DEFAULT_MINIO,
>  		.checker_name  =3D RDAC,
> +		.prio_name     =3D PRIO_RDAC,
>  	},
>  	{
>  		.vendor        =3D "SGI",
>  		.product       =3D "IS.*",
>  		.getuid        =3D DEFAULT_GETUID,
> -		.getprio       =3D "/sbin/mpath_prio_rdac /dev/%n",
>  		.features      =3D DEFAULT_FEATURES,
>  		.hwhandler     =3D DEFAULT_HWHANDLER,
>  		.selector      =3D DEFAULT_SELECTOR,
> @@ -562,6 +562,7 @@ static struct hwentry default_hw[] =3D {
>  		.no_path_retry =3D NO_PATH_RETRY_QUEUE,
>  		.minio         =3D DEFAULT_MINIO,
>  		.checker_name  =3D RDAC,
> +		.prio_name     =3D PRIO_RDAC,
>  	},
>  	/*
>  	 * STK arrays
> @@ -573,7 +574,6 @@ static struct hwentry default_hw[] =3D {
>  		.vendor        =3D "STK",
>  		.product       =3D "OPENstorage D280",
>  		.getuid        =3D DEFAULT_GETUID,
> -		.getprio       =3D "/sbin/mpath_prio_rdac /dev/%n",
>  		.features      =3D DEFAULT_FEATURES,
>  		.hwhandler     =3D DEFAULT_HWHANDLER,
>  		.selector      =3D DEFAULT_SELECTOR,
> @@ -583,6 +583,7 @@ static struct hwentry default_hw[] =3D {
>  		.no_path_retry =3D NO_PATH_RETRY_UNDEF,
>  		.minio         =3D DEFAULT_MINIO,
>  		.checker_name  =3D TUR,
> +		.prio_name     =3D PRIO_RDAC,
>  	},
>  	/*
>  	 * SUN arrays
> @@ -594,7 +595,6 @@ static struct hwentry default_hw[] =3D {
>  		.vendor        =3D "SUN",
>  		.product       =3D "(StorEdge 3510|T4)",
>  		.getuid        =3D DEFAULT_GETUID,
> -		.getprio       =3D NULL,
>  		.features      =3D DEFAULT_FEATURES,
>  		.hwhandler     =3D DEFAULT_HWHANDLER,
>  		.selector      =3D DEFAULT_SELECTOR,
> @@ -603,7 +603,8 @@ static struct hwentry default_hw[] =3D {
>  		.rr_weight     =3D RR_WEIGHT_NONE,
>  		.no_path_retry =3D NO_PATH_RETRY_UNDEF,
>  		.minio         =3D DEFAULT_MINIO,
> -		.checker_name  =3D READSECTOR0,
> +		.checker_name  =3D DIRECTIO,
> +		.prio_name     =3D DEFAULT_PRIO,
>  	},
>   	/*
>  	 * Pivot3 RAIGE
> @@ -615,7 +616,6 @@ static struct hwentry default_hw[] =3D {
>  		.vendor        =3D "PIVOT3",
>  		.product       =3D "RAIGE VOLUME",
>  		.getuid        =3D "/sbin/scsi_id -p 0x80 -g -u -s /block/%n",
> -		.getprio       =3D NULL,
>  		.features      =3D "1 queue_if_no_path",
>  		.hwhandler     =3D DEFAULT_HWHANDLER,
>  		.selector      =3D DEFAULT_SELECTOR,
> @@ -625,6 +625,7 @@ static struct hwentry default_hw[] =3D {
>  		.no_path_retry =3D NO_PATH_RETRY_UNDEF,
>  		.minio         =3D 100,
>  		.checker_name  =3D TUR,
> +		.prio_name     =3D DEFAULT_PRIO,
>  	},
>  	/*
>  	 * EOL
> @@ -633,7 +634,6 @@ static struct hwentry default_hw[] =3D {
>  		.vendor        =3D NULL,
>  		.product       =3D NULL,
>  		.getuid        =3D NULL,
> -		.getprio       =3D NULL,
>  		.features      =3D NULL,
>  		.hwhandler     =3D NULL,
>  		.selector      =3D NULL,
> @@ -643,6 +643,7 @@ static struct hwentry default_hw[] =3D {
>  		.no_path_retry =3D 0,
>  		.minio         =3D 0,
>  		.checker_name  =3D NULL,
> +		.prio_name     =3D NULL,
>  	},
>  };
> =20
> diff --git a/libmultipath/propsel.c b/libmultipath/propsel.c
> index 45a3728..bb2b2b7 100644
> --- a/libmultipath/propsel.c
> +++ b/libmultipath/propsel.c
> @@ -6,6 +6,7 @@
>  #include <stdio.h>
> =20
>  #include <checkers.h>
> +#include <libprio.h>
> =20
>  #include "memory.h"
>  #include "vector.h"
> @@ -257,22 +258,23 @@ select_getuid (struct path * pp)
>  }
> =20
>  extern int
> -select_getprio (struct path * pp)
> +select_prio (struct path * pp)
>  {
> -	if (pp->hwe && pp->hwe->getprio) {
> -		pp->getprio =3D pp->hwe->getprio;
> -		condlog(3, "%s: getprio =3D %s (controller setting)",
> -			pp->dev, pp->getprio);
> +	if (pp->hwe && pp->hwe->prio) {
> +		pp->prio =3D pp->hwe->prio;
> +		condlog(3, "%s: prio =3D %s (controller setting)",
> +			pp->dev, prio_name(pp->prio));
>  		return 0;
>  	}
> -	if (conf->getprio) {
> -		pp->getprio =3D conf->getprio;
> -		condlog(3, "%s: getprio =3D %s (config file default)",
> -			pp->dev, pp->getprio);
> +	if (conf->prio) {
> +		pp->prio =3D conf->prio;
> +		condlog(3, "%s: prio =3D %s (config file default)",
> +			pp->dev, prio_name(pp->prio));
>  		return 0;
>  	}
> -	pp->getprio =3D DEFAULT_GETPRIO;
> -	condlog(3, "%s: getprio =3D NULL (internal default)", pp->dev);
> +	pp->prio =3D prio_default();
> +	condlog(3, "%s: prio =3D %s (internal default)",
> +		pp->dev, prio_name(pp->prio));
>  	return 0;
>  }
> =20
> diff --git a/libmultipath/propsel.h b/libmultipath/propsel.h
> index afd1f88..62802f8 100644
> --- a/libmultipath/propsel.h
> +++ b/libmultipath/propsel.h
> @@ -7,7 +7,7 @@ int select_features (struct multipath * mp);
>  int select_hwhandler (struct multipath * mp);
>  int select_checker(struct path *pp);
>  int select_getuid (struct path * pp);
> -int select_getprio (struct path * pp);
> +int select_prio (struct path * pp);
>  int select_no_path_retry(struct multipath *mp);
>  int select_pg_timeout(struct multipath *mp);
>  int select_minio(struct multipath *mp);
> diff --git a/libmultipath/structs.h b/libmultipath/structs.h
> index f821f87..90605c6 100644
> --- a/libmultipath/structs.h
> +++ b/libmultipath/structs.h
> @@ -121,8 +121,7 @@ struct path {
>  	int priority;
>  	int pgindex;
>  	char * getuid;
> -	char * getprio;
> -	int getprio_selected;
> +	struct prio * prio;
>  	struct checker checker;
>  	struct multipath * mpp;
>  	int fd;
> diff --git a/libmultipath/structs_vec.c b/libmultipath/structs_vec.c
> index 1cc6028..a5dc573 100644
> --- a/libmultipath/structs_vec.c
> +++ b/libmultipath/structs_vec.c
> @@ -3,6 +3,7 @@
>  #include <unistd.h>
> =20
>  #include <checkers.h>
> +#include <libprio.h>
> =20
>  #include "vector.h"
>  #include "defaults.h"
> @@ -81,8 +82,7 @@ orphan_path (struct path * pp)
>  	pp->mpp =3D NULL;
>  	pp->dmstate =3D PSTATE_UNDEF;
>  	pp->getuid =3D NULL;
> -	pp->getprio =3D NULL;
> -	pp->getprio_selected =3D 0;
> +	prio_put(pp->prio);
>  	checker_put(&pp->checker);
>  	if (pp->fd >=3D 0)
>  		close(pp->fd);
> diff --git a/multipath.conf.annotated b/multipath.conf.annotated
> index e6cfe9a..f617876 100644
> --- a/multipath.conf.annotated
> +++ b/multipath.conf.annotated
> @@ -52,14 +52,14 @@
>  #	getuid_callout	"/lib/udev/scsi_id -g -u -s /block/%n"
>  #
>  #	#
> -#	# name    : prio_callout
> +#	# name    : prio
>  #	# scope   : multipath
> -#	# desc    : the default program and args to callout to obtain a path=
=20
> +#	# desc    : the default function to call to obtain a path=20
>  #	#           priority value. The ALUA bits in SPC-3 provide an
> -#	#           exploitable prio value for example. "none" is a valid va=
lue
> +#	#           exploitable prio value for example.
>  #	# default : (null)
>  #	#
> -#	#prio_callout	"/bin/true"
> +#	#prio	"alua"
>  #
>  #	#
>  #	# name    : path_checker
> @@ -296,15 +296,14 @@
>  #		getuid_callout          "/lib/udev/scsi_id -g -u -s /block/%n"
>  #
>  #		#
> -#		# name    : prio_callout
> +#		# name    : prio
>  #		# scope   : multipath
> -#		# desc    : the program and args to callout to obtain a path=20
> +#		# desc    : the function to call to obtain a path=20
>  #		#           weight. Weights are summed for each path group to
>  #		#	    determine the next PG to use case of failure.
> -#		#	    "none" is a valid value.
>  #		# default : no callout, all paths equals
>  #		#
> -#		prio_callout          "/sbin/mpath_prio_balance_units %d"
> +#		prio          "hp_sw"
>  #
>  #		#
>  #		# name    : path_checker
> diff --git a/multipath.conf.synthetic b/multipath.conf.synthetic
> index 633d625..0c05b4c 100644
> --- a/multipath.conf.synthetic
> +++ b/multipath.conf.synthetic
> @@ -8,7 +8,7 @@
>  #	selector		"round-robin 0"
>  #	path_grouping_policy	multibus
>  #	getuid_callout		"/lib/udev/scsi_id -g -u -s /block/%n"
> -#	prio_callout		/bin/true
> +#	prio			const
>  #	path_checker		directio
>  #	rr_min_io		100
>  #	rr_weight		priorities
> diff --git a/multipathd/Makefile b/multipathd/Makefile
> index b430b94..b82f159 100644
> --- a/multipathd/Makefile
> +++ b/multipathd/Makefile
> @@ -21,6 +21,7 @@ LDFLAGS =3D -lpthread -ldevmapper -lreadline -lncurse=
s -laio
>  #
>  OBJS =3D main.o pidfile.o uxlsnr.o uxclnt.o cli.o cli_handlers.o \
>         $(MULTIPATHLIB)-glibc.a $(CHECKERSLIB)-glibc.a \
> +       $(LIBPRIO)-glibc.a
> =20
> =20
>  #
> @@ -37,6 +38,9 @@ $(EXEC): clean $(OBJS)
>  	$(CC) $(OBJS) -o $(EXEC) $(LDFLAGS)
>  	$(GZIP) $(EXEC).8 > $(EXEC).8.gz
> =20
> +$(LIBPRIO)-glibc.a:
> +	$(MAKE) -C $(libpriodir) BUILD=3Dglibc glibc
> +
>  $(CHECKERSLIB)-glibc.a:
>  	$(MAKE) -C $(checkersdir) BUILD=3Dglibc glibc
> =20
