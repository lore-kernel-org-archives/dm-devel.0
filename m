From: Martin Wilck <Martin.Wilck@suse.com>
Subject: Re: [RFC Patch 2/3] libmultipath: make
 sysfs_is_multipathed able to return wwid
Date: Tue, 31 Mar 2020 13:06:01 +0000
Message-ID: <5a85f7b0c9ef459ea8a7308dda4f21af8da687f5.camel@suse.com>
References: <1585620055-27112-1-git-send-email-bmarzins@redhat.com>
	<1585620055-27112-3-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1585620055-27112-3-git-send-email-bmarzins@redhat.com>
Content-Language: en-US
Content-ID: <C11DDAE73E785349928526FA6AB18518@namprd18.prod.outlook.com>
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

On Mon, 2020-03-30 at 21:00 -0500, Benjamin Marzinski wrote:
> sysfs_is_multipathed reads the wwid of the dm device holding a path
> to
> check if its a multipath device.  Add code to optinally set pp->wwid
> to
> that wwid.  This will be used by a future patch.
>=20
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
>  libmultipath/sysfs.c | 22 +++++++++++++++++++---
>  libmultipath/sysfs.h |  2 +-
>  multipath/main.c     |  7 ++++---
>  3 files changed, 24 insertions(+), 7 deletions(-)
>=20
> diff --git a/libmultipath/sysfs.c b/libmultipath/sysfs.c
> index 62ec2ed7..034f082f 100644
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
> @@ -342,9 +342,25 @@ bool sysfs_is_multipathed(const struct path *pp)
>  =09=09if (nr =3D=3D sizeof(uuid) && !memcmp(uuid, "mpath-",
> sizeof(uuid)))
>  =09=09=09found =3D true;
>  =09=09else if (nr < 0) {
> -=09=09=09condlog(1, "%s: error reading from %s: %s",
> -=09=09=09=09__func__, pathbuf, strerror(errno));
> +=09=09=09condlog(1, "%s: error reading from %s: %m",
> +=09=09=09=09__func__, pathbuf);
>  =09=09}
> +=09=09if (found && set_wwid) {
> +=09=09=09nr =3D read(fd, pp->wwid, WWID_SIZE);

I'd rather read the whole UUID in a single syscall (i.e. merge this
with the previous read() that fetched the first 6 chars).

Regards,
Martin


--=20
Dr. Martin Wilck <mwilck@suse.com>, Tel. +49 (0)911 74053 2107
SUSE  Software Solutions Germany GmbH
HRB 36809, AG N=FCrnberg GF: Felix
Imend=F6rffer
