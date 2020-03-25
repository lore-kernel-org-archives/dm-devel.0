From: Martin Wilck <Martin.Wilck@suse.com>
Subject: Re: [PATCH 2/3] libmutipath: don't close fd on
	dm_lib_release
Date: Wed, 25 Mar 2020 15:16:50 +0000
Message-ID: <ebfcb22b005314635b77e4820e205971d708d07d.camel@suse.com>
References: <1585083834-14237-1-git-send-email-bmarzins@redhat.com>
	<1585083834-14237-2-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1585083834-14237-2-git-send-email-bmarzins@redhat.com>
Content-Language: en-US
Content-ID: <80FDBD23751841418EAA875693D719CA@namprd18.prod.outlook.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "bmarzins@redhat.com" <bmarzins@redhat.com>, "christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Tue, 2020-03-24 at 16:03 -0500, Benjamin Marzinski wrote:
> If dm_hold_control_open() isn't set, when dm_lib_release() is called,
> it
> will close the control fd. The control fd will get re-opened on the
> next
> dm_task_run() call, but if there is a dm_task_run() call already
> in progress in another thread, it can fail. Since many of the
> device-mapper callouts happen with the vecs lock held, this wasn't
> too
> noticeable, but there is code that calls dm_task_run() without the
> vecs lock held, notably the dmevent waiter code.
>=20
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
>  libmultipath/devmapper.c | 1 +
>  1 file changed, 1 insertion(+)
>=20
> diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
> index bed8ddc6..d96472fe 100644
> --- a/libmultipath/devmapper.c
> +++ b/libmultipath/devmapper.c
> @@ -254,6 +254,7 @@ void libmp_dm_init(void)
>  =09memcpy(conf->version, version, sizeof(version));
>  =09put_multipath_config(conf);
>  =09dm_init(verbosity);
> +=09dm_hold_control_dev(1);
>  =09dm_udev_set_sync_support(libmp_dm_udev_sync);
>  }

AFAICS, this function has been in libdm since 1.02.111. We support
1.02.89 (if all features enabled, otherwise even older). Perhaps we
should make this function call conditional on the libdm verson?

But perhaps more importantly, why do we still need to call
dm_lib_release()? AFAICS it's only needed for systems that have no udev
support for creating device nodes (to call update_devs() via
dm_lib_release()), and we don't support that anymore anyway, do we?=20

Since 26c4bb0, we're always setting the
DM_UDEV_DISABLE_LIBRARY_FALLBACK flag, and the cookie, too
(we aren't setting it for DM_DEVICE_RELOAD, but it isn't needed for
that, either, since no device nodes need to be created or removed); so
dm_lib_release() should really have no effect.

Regards
Martin

--=20
Dr. Martin Wilck <mwilck@suse.com>, Tel. +49 (0)911 74053 2107
SUSE  Software Solutions Germany GmbH
HRB 36809, AG N=FCrnberg GF: Felix
Imend=F6rffer
