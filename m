From: Martin Wilck <Martin.Wilck@suse.com>
Subject: Re: [RFC PATCH v2 2/3] libmultipath: make
 sysfs_is_multipathed able to return wwid
Date: Tue, 28 Apr 2020 19:21:33 +0000
Message-ID: <71c582d964fbb8fa6d2b3c87f30c641e050e19a7.camel@suse.com>
References: <1585896641-22896-1-git-send-email-bmarzins@redhat.com>
	<1585896641-22896-3-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1585896641-22896-3-git-send-email-bmarzins@redhat.com>
Content-Language: en-US
Content-ID: <7D07CFDCB1C37E4580B8DA5B33E4A1C0@namprd18.prod.outlook.com>
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

On Fri, 2020-04-03 at 01:50 -0500, Benjamin Marzinski wrote:
> sysfs_is_multipathed reads the wwid of the dm device holding a path
> to
> check if its a multipath device.  Add code to optinally set pp->wwid
> to
> that wwid.  This will be used by a future patch.
>=20
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
>  libmultipath/sysfs.c | 24 +++++++++++++++++++-----
>  libmultipath/sysfs.h |  2 +-
>  multipath/main.c     |  7 ++++---
>  3 files changed, 24 insertions(+), 9 deletions(-)
>=20
> diff --git a/libmultipath/sysfs.c b/libmultipath/sysfs.c
> index 62ec2ed7..12a82d95 100644
> --- a/libmultipath/sysfs.c
> +++ b/libmultipath/sysfs.c
> @@ -295,7 +295,7 @@ static int select_dm_devs(const struct dirent
> *di)
>  =09return fnmatch("dm-*", di->d_name, FNM_FILE_NAME) =3D=3D 0;
>  }
> =20
> -bool sysfs_is_multipathed(const struct path *pp)
> +bool sysfs_is_multipathed(struct path *pp, bool set_wwid)
>  {
>  =09char pathbuf[PATH_MAX];
>  =09struct scandir_result sr;
> @@ -325,7 +325,7 @@ bool sysfs_is_multipathed(const struct path *pp)
>  =09for (i =3D 0; i < r && !found; i++) {
>  =09=09long fd;
>  =09=09int nr;
> -=09=09char uuid[6];
> +=09=09char uuid[WWID_SIZE + UUID_PREFIX_LEN];
> =20
>  =09=09if (safe_snprintf(pathbuf + n, sizeof(pathbuf) - n,
>  =09=09=09=09  "/%s/dm/uuid", di[i]->d_name))
> @@ -339,12 +339,26 @@ bool sysfs_is_multipathed(const struct path
> *pp)
> =20
>  =09=09pthread_cleanup_push(close_fd, (void *)fd);
>  =09=09nr =3D read(fd, uuid, sizeof(uuid));
> -=09=09if (nr =3D=3D sizeof(uuid) && !memcmp(uuid, "mpath-",
> sizeof(uuid)))
> +=09=09if (nr > (int)UUID_PREFIX_LEN &&
> +=09=09    !memcmp(uuid, UUID_PREFIX, UUID_PREFIX_LEN))
>  =09=09=09found =3D true;
>  =09=09else if (nr < 0) {
> -=09=09=09condlog(1, "%s: error reading from %s: %s",
> -=09=09=09=09__func__, pathbuf, strerror(errno));
> +=09=09=09condlog(1, "%s: error reading from %s: %m",
> +=09=09=09=09__func__, pathbuf);
>  =09=09}
> +=09=09if (found && set_wwid) {
> +=09=09=09nr -=3D UUID_PREFIX_LEN;
> +=09=09=09memcpy(pp->wwid, uuid + UUID_PREFIX_LEN, nr);
> +=09=09=09if (nr =3D=3D WWID_SIZE) {
> +=09=09=09=09condlog(4, "%s: overflow while reading
> from %s",
> +=09=09=09=09=09__func__, pathbuf);

I would have checked this condition before calling memcpy(), but that's
just a nit.

Reviewed-by: Martin Wilck <mwilck@suse.com>

--=20
Dr. Martin Wilck <mwilck@suse.com>, Tel. +49 (0)911 74053 2107
SUSE  Software Solutions Germany GmbH
HRB 36809, AG N=FCrnberg GF: Felix
Imend=F6rffer
