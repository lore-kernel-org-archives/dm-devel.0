From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: Re: [PATCH 16/72] libmultipath: make path_discovery()
 pthread_cancel()-safe
Date: Wed, 30 Oct 2019 09:53:33 -0500
Message-ID: <20191030145333.GN25414@octiron.msp.redhat.com>
References: <20191012212703.12989-1-martin.wilck@suse.com>
	<20191012212703.12989-17-martin.wilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20191012212703.12989-17-martin.wilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Content-Disposition: inline
To: Martin Wilck <Martin.Wilck@suse.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Sat, Oct 12, 2019 at 09:27:57PM +0000, Martin Wilck wrote:
> From: Martin Wilck <mwilck@suse.com>
>=20
> The udev_enumerate and udev_device refs wouldn't be released
> if the thread was cancelled. Fix it.
>=20
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  libmultipath/discovery.c | 51 +++++++++++++++++++++++++++++++---------
>  1 file changed, 40 insertions(+), 11 deletions(-)
>=20
> diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
> index e68b0e9f..d217ca92 100644
> --- a/libmultipath/discovery.c
> +++ b/libmultipath/discovery.c
> @@ -140,19 +140,47 @@ path_discover (vector pathvec, struct config * conf=
,
>  =09return pathinfo(pp, conf, flag);
>  }
> =20
> +static void cleanup_udev_enumerate_ptr(void *arg)
> +{
> +=09struct udev_enumerate *ue;
> +
> +=09if (!arg)
> +=09=09return;
> +=09ue =3D *((struct udev_enumerate**) arg);
> +=09if (ue)
> +=09=09(void)udev_enumerate_unref(ue);
> +}
> +
> +static void cleanup_udev_device_ptr(void *arg)
> +{
> +=09struct udev_device *ud;
> +
> +=09if (!arg)
> +=09=09return;
> +=09ud =3D *((struct udev_device**) arg);
> +=09if (ud)
> +=09=09(void)udev_device_unref(ud);
> +}
> +
>  int
>  path_discovery (vector pathvec, int flag)
>  {
> -=09struct udev_enumerate *udev_iter;
> +=09struct udev_enumerate *udev_iter =3D NULL;
>  =09struct udev_list_entry *entry;
> -=09struct udev_device *udevice;
> +=09struct udev_device *udevice =3D NULL;
>  =09struct config *conf;
> -=09const char *devpath;
>  =09int num_paths =3D 0, total_paths =3D 0, ret;
> =20
> +=09pthread_cleanup_push(cleanup_udev_enumerate_ptr, &udev_iter);
> +=09pthread_cleanup_push(cleanup_udev_device_ptr, &udevice);
> +=09conf =3D get_multipath_config();
> +=09pthread_cleanup_push(put_multipath_config, conf);
> +
>  =09udev_iter =3D udev_enumerate_new(udev);
> -=09if (!udev_iter)
> -=09=09return -ENOMEM;
> +=09if (!udev_iter) {
> +=09=09ret =3D -ENOMEM;
> +=09=09goto out;
> +=09}
> =20
>  =09if (udev_enumerate_add_match_subsystem(udev_iter, "block") < 0 ||
>  =09    udev_enumerate_add_match_is_initialized(udev_iter) < 0 ||
> @@ -165,6 +193,8 @@ path_discovery (vector pathvec, int flag)
>  =09udev_list_entry_foreach(entry,
>  =09=09=09=09udev_enumerate_get_list_entry(udev_iter)) {
>  =09=09const char *devtype;
> +=09=09const char *devpath;
> +
>  =09=09devpath =3D udev_list_entry_get_name(entry);
>  =09=09condlog(4, "Discover device %s", devpath);
>  =09=09udevice =3D udev_device_new_from_syspath(udev, devpath);
> @@ -175,19 +205,18 @@ path_discovery (vector pathvec, int flag)
>  =09=09devtype =3D udev_device_get_devtype(udevice);
>  =09=09if(devtype && !strncmp(devtype, "disk", 4)) {
>  =09=09=09total_paths++;
> -=09=09=09conf =3D get_multipath_config();
> -=09=09=09pthread_cleanup_push(put_multipath_config, conf);

Why move grabbing the config RCU lock out of the loop? All things being
equal, it seems like we'd rather hold this for less time, and
rcu_read_lock() is designed to be lightweight, so calling it more times
shouldn't be an issue.=20

-Ben

>  =09=09=09if (path_discover(pathvec, conf,
>  =09=09=09=09=09  udevice, flag) =3D=3D PATHINFO_OK)
>  =09=09=09=09num_paths++;
> -=09=09=09pthread_cleanup_pop(1);
>  =09=09}
> -=09=09udev_device_unref(udevice);
> +=09=09udevice =3D udev_device_unref(udevice);
>  =09}
>  =09ret =3D total_paths - num_paths;
> -out:
> -=09udev_enumerate_unref(udev_iter);
>  =09condlog(4, "Discovered %d/%d paths", num_paths, total_paths);
> +out:
> +=09pthread_cleanup_pop(1);
> +=09pthread_cleanup_pop(1);
> +=09pthread_cleanup_pop(1);
>  =09return ret;
>  }
> =20
> --=20
> 2.23.0
