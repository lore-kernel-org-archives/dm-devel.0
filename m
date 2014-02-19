From: =?iso-8859-1?Q?Lu=EDs?= Henriques <luis.henriques@canonical.com>
Subject: Re: [PATCH] backport of: dm sysfs: fix a module unload race
Date: Wed, 19 Feb 2014 10:10:51 +0000
Message-ID: <20140219101050.GA14571@hercules>
References: <139190449886@kroah.com>
 <alpine.LRH.2.02.1402101457550.23907@file01.intranet.prod.int.rdu2.redhat.com>
 <20140211000517.GB15453@kroah.com>
 <alpine.LRH.2.02.1402131142410.22991@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.1402131142410.22991@file01.intranet.prod.int.rdu2.redhat.com>
Sender: stable-owner@vger.kernel.org
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Greg KH <gregkh@linuxfoundation.org>, stable@vger.kernel.org, snitzer@redhat.com, dm-devel@redhat.com
List-Id: dm-devel.ids

On Thu, Feb 13, 2014 at 11:49:28AM -0500, Mikulas Patocka wrote:
>=20
>=20
> On Mon, 10 Feb 2014, Greg KH wrote:
>=20
> > On Mon, Feb 10, 2014 at 03:02:24PM -0500, Mikulas Patocka wrote:
> > >=20
> > >=20
> > > On Sat, 8 Feb 2014, gregkh@linuxfoundation.org wrote:
> > >=20
> > > > The patch below does not apply to the 3.13-stable tree.
> > > > If someone wants it applied there, or to any other stable or lo=
ngterm
> > > > tree, then please email the backport, including the original gi=
t commit
> > > > id to <stable@vger.kernel.org>.
> > > >=20
> > > > thanks,
> > > >=20
> > > > greg k-h
> > >=20
> > > Hi
> > >=20
> > > Here I'm sending backported patch=20
> > > 2995fa78e423d7193f3b57835f6c1c75006a0315. It applies to stable ke=
rnels
> > > 3.4 - 3.13 (and maybe also on older versions).
> >=20
> > For 3.10-3.13 this patch works, but for 3.4 I get the build error:
> >=20
> > ERROR: "dm_kobject_release" [drivers/md/dm-mod.ko] undefined!
> > /ssd/gregkh-linux/stable/linux-3.4.y/scripts/Makefile.modpost:91: r=
ecipe for target '__modpost' failed
> > make[1]: *** [__modpost] Error 1
> >=20
> > So I'm dropping it from that branch.  Care to send me a version tha=
t
> > builds properly for that kernel release?
> >=20
> > thanks,
> >=20
> > greg k-h
>=20
>=20
> This is the update of 2995fa78e423d7193f3b57835f6c1c75006a0315 for st=
able=20
> 3.4.
>=20
> Mikulas
>=20

Thanks Mikulas, I'm queuing this backport to the 3.5 kernel as well.

Cheers,
--
Lu=EDs

>=20
>=20
> From: Mikulas Patocka <mpatocka@redhat.com>
>=20
> commit 2995fa78e423d7193f3b57835f6c1c75006a0315
> Author: Mikulas Patocka <mpatocka@redhat.com>
> Date:   Mon Jan 13 19:37:54 2014 -0500
>=20
>     dm sysfs: fix a module unload race
>=20
>     This reverts commit be35f48610 ("dm: wait until embedded kobject =
is
>     released before destroying a device") and provides an improved fi=
x.
>=20
>     The kobject release code that calls the completion must be placed=
 in a
>     non-module file, otherwise there is a module unload race (if the =
process
>     calling dm_kobject_release is preempted and the DM module unloade=
d after
>     the completion is triggered, but before dm_kobject_release return=
s).
>=20
>     To fix this race, this patch moves the completion code to dm-buil=
tin.c
>     which is always compiled directly into the kernel if BLK_DEV_DM i=
s
>     selected.
>=20
>     The patch introduces a new dm_kobject_holder structure, its purpo=
se is
>     to keep the completion and kobject in one place, so that it can b=
e
>     accessed from non-module code without the need to export the layo=
ut of
>     struct mapped_device to that code.
>=20
>     Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
>     Signed-off-by: Mike Snitzer <snitzer@redhat.com>
>     Cc: stable@vger.kernel.org
>=20
> ---
>  drivers/md/Kconfig      |    4 +++
>  drivers/md/Makefile     |    1=20
>  drivers/md/dm-builtin.c |   50 +++++++++++++++++++++++++++++++++++++=
+++++++++++
>  drivers/md/dm-sysfs.c   |    5 ----
>  drivers/md/dm.c         |   26 ++++--------------------
>  drivers/md/dm.h         |   17 +++++++++++++++-
>  6 files changed, 76 insertions(+), 27 deletions(-)
>=20
> Index: linux-stable/drivers/md/dm.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux-stable.orig/drivers/md/dm.c	2014-02-13 15:50:13.000000000 +=
0100
> +++ linux-stable/drivers/md/dm.c	2014-02-13 15:50:39.000000000 +0100
> @@ -191,11 +191,8 @@ struct mapped_device {
>  	/* forced geometry settings */
>  	struct hd_geometry geometry;
> =20
> -	/* sysfs handle */
> -	struct kobject kobj;
> -
> -	/* wait until the kobject is released */
> -	struct completion kobj_completion;
> +	/* kobject and completion */
> +	struct dm_kobject_holder kobj_holder;
> =20
>  	/* zero-length flush that will be cloned and submitted to targets *=
/
>  	struct bio flush_bio;
> @@ -1894,7 +1891,7 @@ static struct mapped_device *alloc_dev(i
>  	init_waitqueue_head(&md->wait);
>  	INIT_WORK(&md->work, dm_wq_work);
>  	init_waitqueue_head(&md->eventq);
> -	init_completion(&md->kobj_completion);
> +	init_completion(&md->kobj_holder.completion);
> =20
>  	md->disk->major =3D _major;
>  	md->disk->first_minor =3D minor;
> @@ -2686,20 +2683,14 @@ struct gendisk *dm_disk(struct mapped_de
> =20
>  struct kobject *dm_kobject(struct mapped_device *md)
>  {
> -	return &md->kobj;
> +	return &md->kobj_holder.kobj;
>  }
> =20
> -/*
> - * struct mapped_device should not be exported outside of dm.c
> - * so use this check to verify that kobj is part of md structure
> - */
>  struct mapped_device *dm_get_from_kobject(struct kobject *kobj)
>  {
>  	struct mapped_device *md;
> =20
> -	md =3D container_of(kobj, struct mapped_device, kobj);
> -	if (&md->kobj !=3D kobj)
> -		return NULL;
> +	md =3D container_of(kobj, struct mapped_device, kobj_holder.kobj);
> =20
>  	if (test_bit(DMF_FREEING, &md->flags) ||
>  	    dm_deleting_md(md))
> @@ -2709,13 +2700,6 @@ struct mapped_device *dm_get_from_kobjec
>  	return md;
>  }
> =20
> -struct completion *dm_get_completion_from_kobject(struct kobject *ko=
bj)
> -{
> -	struct mapped_device *md =3D container_of(kobj, struct mapped_devic=
e, kobj);
> -
> -	return &md->kobj_completion;
> -}
> -
>  int dm_suspended_md(struct mapped_device *md)
>  {
>  	return test_bit(DMF_SUSPENDED, &md->flags);
> Index: linux-stable/drivers/md/Kconfig
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux-stable.orig/drivers/md/Kconfig	2014-02-11 00:01:38.00000000=
0 +0100
> +++ linux-stable/drivers/md/Kconfig	2014-02-13 15:50:39.000000000 +01=
00
> @@ -185,8 +185,12 @@ config MD_FAULTY
> =20
>  	  In unsure, say N.
> =20
> +config BLK_DEV_DM_BUILTIN
> +	boolean
> +
>  config BLK_DEV_DM
>  	tristate "Device mapper support"
> +	select BLK_DEV_DM_BUILTIN
>  	---help---
>  	  Device-mapper is a low level volume manager.  It works by allowin=
g
>  	  people to specify mappings for ranges of logical sectors.  Variou=
s
> Index: linux-stable/drivers/md/Makefile
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux-stable.orig/drivers/md/Makefile	2014-02-11 00:01:38.0000000=
00 +0100
> +++ linux-stable/drivers/md/Makefile	2014-02-13 15:50:39.000000000 +0=
100
> @@ -28,6 +28,7 @@ obj-$(CONFIG_MD_MULTIPATH)	+=3D multipath.
>  obj-$(CONFIG_MD_FAULTY)		+=3D faulty.o
>  obj-$(CONFIG_BLK_DEV_MD)	+=3D md-mod.o
>  obj-$(CONFIG_BLK_DEV_DM)	+=3D dm-mod.o
> +obj-$(CONFIG_BLK_DEV_DM_BUILTIN) +=3D dm-builtin.o
>  obj-$(CONFIG_DM_BUFIO)		+=3D dm-bufio.o
>  obj-$(CONFIG_DM_CRYPT)		+=3D dm-crypt.o
>  obj-$(CONFIG_DM_DELAY)		+=3D dm-delay.o
> Index: linux-stable/drivers/md/dm-builtin.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- /dev/null	1970-01-01 00:00:00.000000000 +0000
> +++ linux-stable/drivers/md/dm-builtin.c	2014-02-13 16:05:16.00000000=
0 +0100
> @@ -0,0 +1,50 @@
> +#include "dm.h"
> +
> +#include <linux/export.h>
> +
> +/*
> + * The kobject release method must not be placed in the module itsel=
f,
> + * otherwise we are subject to module unload races.
> + *
> + * The release method is called when the last reference to the kobje=
ct is
> + * dropped. It may be called by any other kernel code that drops the=
 last
> + * reference.
> + *
> + * The release method suffers from module unload race. We may preven=
t the
> + * module from being unloaded at the start of the release method (us=
ing
> + * increased module reference count or synchronizing against the rel=
ease
> + * method), however there is no way to prevent the module from being
> + * unloaded at the end of the release method.
> + *
> + * If this code were placed in the dm module, the following race may
> + * happen:
> + *  1. Some other process takes a reference to dm kobject
> + *  2. The user issues ioctl function to unload the dm device
> + *  3. dm_sysfs_exit calls kobject_put, however the object is not re=
leased
> + *     because of the other reference taken at step 1
> + *  4. dm_sysfs_exit waits on the completion
> + *  5. The other process that took the reference in step 1 drops it,
> + *     dm_kobject_release is called from this process
> + *  6. dm_kobject_release calls complete()
> + *  7. a reschedule happens before dm_kobject_release returns
> + *  8. dm_sysfs_exit continues, the dm device is unloaded, module re=
ference
> + *     count is decremented
> + *  9. The user unloads the dm module
> + * 10. The other process that was rescheduled in step 7 continues to=
 run,
> + *     it is now executing code in unloaded module, so it crashes
> + *
> + * Note that if the process that takes the foreign reference to dm k=
object
> + * has a low priority and the system is sufficiently loaded with
> + * higher-priority processes that prevent the low-priority process f=
rom
> + * being scheduled long enough, this bug may really happen.
> + *
> + * In order to fix this module unload race, we place the release met=
hod
> + * into a helper code that is compiled directly into the kernel.
> + */
> +
> +void dm_kobject_release(struct kobject *kobj)
> +{
> +	complete(dm_get_completion_from_kobject(kobj));
> +}
> +
> +EXPORT_SYMBOL(dm_kobject_release);
> Index: linux-stable/drivers/md/dm-sysfs.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux-stable.orig/drivers/md/dm-sysfs.c	2014-02-13 15:50:13.00000=
0000 +0100
> +++ linux-stable/drivers/md/dm-sysfs.c	2014-02-13 15:50:39.000000000 =
+0100
> @@ -79,11 +79,6 @@ static const struct sysfs_ops dm_sysfs_o
>  	.show	=3D dm_attr_show,
>  };
> =20
> -static void dm_kobject_release(struct kobject *kobj)
> -{
> -	complete(dm_get_completion_from_kobject(kobj));
> -}
> -
>  /*
>   * dm kobject is embedded in mapped_device structure
>   * no need to define release function here
> Index: linux-stable/drivers/md/dm.h
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux-stable.orig/drivers/md/dm.h	2014-02-13 15:50:13.000000000 +=
0100
> +++ linux-stable/drivers/md/dm.h	2014-02-13 15:50:39.000000000 +0100
> @@ -16,6 +16,7 @@
>  #include <linux/blkdev.h>
>  #include <linux/hdreg.h>
>  #include <linux/completion.h>
> +#include <linux/kobject.h>
> =20
>  /*
>   * Suspend feature flags
> @@ -120,11 +121,25 @@ void dm_interface_exit(void);
>  /*
>   * sysfs interface
>   */
> +struct dm_kobject_holder {
> +	struct kobject kobj;
> +	struct completion completion;
> +};
> +
> +static inline struct completion *dm_get_completion_from_kobject(stru=
ct kobject *kobj)
> +{
> +	return &container_of(kobj, struct dm_kobject_holder, kobj)->complet=
ion;
> +}
> +
>  int dm_sysfs_init(struct mapped_device *md);
>  void dm_sysfs_exit(struct mapped_device *md);
>  struct kobject *dm_kobject(struct mapped_device *md);
>  struct mapped_device *dm_get_from_kobject(struct kobject *kobj);
> -struct completion *dm_get_completion_from_kobject(struct kobject *ko=
bj);
> +
> +/*
> + * The kobject helper
> + */
> +void dm_kobject_release(struct kobject *kobj);
> =20
>  /*
>   * Targets for linear and striped mappings
> --
> To unsubscribe from this list: send the line "unsubscribe stable" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
