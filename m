From: Martin Wilck <Martin.Wilck@suse.com>
Subject: Re: [PATCH 1/1] libmultipath: fix files read from
	config_dir
Date: Fri, 7 Feb 2020 17:08:11 +0000
Message-ID: <39d70ac4e03d9f75b51ef49c078b11e6ed662e0f.camel@suse.com>
References: <20200207144525.16341-1-ematsumiya@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200207144525.16341-1-ematsumiya@suse.de>
Content-Language: en-US
Content-ID: <FB025A6B43E5744E887310A6CF45906B@namprd18.prod.outlook.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "ematsumiya@suse.de" <ematsumiya@suse.de>, "christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Fri, 2020-02-07 at 11:45 -0300, Enzo Matsumiya wrote:
> If config_dir contains a file named, for example, "some.conf.backup",
> this file
> will still be loaded by multipath because process_config_dir()
> (libmultipath/config.c) uses strstr() to check for the ".conf"
> extension, but
> that doesn't guarantee that ".conf" is at the end of the filename.
>=20
> This patch will make sure that only files ending in ".conf" are
> loaded from
> config_dir.
>=20
> This is to comply with config_dir entry description in man 5
> multipath.conf.
>=20
> Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
> ---
>  libmultipath/config.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
>=20
> diff --git a/libmultipath/config.c b/libmultipath/config.c
> index 20e3b8bf..4785ade8 100644
> --- a/libmultipath/config.c
> +++ b/libmultipath/config.c
> @@ -671,8 +671,11 @@ process_config_dir(struct config *conf, vector
> keywords, char *dir)
>  =09sr.n =3D n;
>  =09pthread_cleanup_push_cast(free_scandir_result, &sr);
>  =09for (i =3D 0; i < n; i++) {
> -=09=09if (!strstr(namelist[i]->d_name, ".conf"))
> +=09=09char *ext =3D strrchr(namelist[i]->d_name, '.');
> +
> +=09=09if (!ext || strcmp(ext, ".conf"))
>  =09=09=09continue;
> +
>  =09=09old_hwtable_size =3D VECTOR_SIZE(conf->hwtable);
>  =09=09snprintf(path, LINE_MAX, "%s/%s", dir, namelist[i]-
> >d_name);
>  =09=09path[LINE_MAX-1] =3D '\0';

Reviewed-by: Martin Wilck <mwilck@suse.com>

--=20
Dr. Martin Wilck <mwilck@suse.com>, Tel. +49 (0)911 74053 2107
SUSE  Software Solutions Germany GmbH
HRB 36809, AG N=FCrnberg GF: Felix
Imend=F6rffer
