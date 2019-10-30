From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: Re: [PATCH 13/72] libmultipath: alias.c: prepare for
 cancel-safe allocation
Date: Wed, 30 Oct 2019 09:47:16 -0500
Message-ID: <20191030144716.GM25414@octiron.msp.redhat.com>
References: <20191012212703.12989-1-martin.wilck@suse.com>
	<20191012212703.12989-14-martin.wilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20191012212703.12989-14-martin.wilck@suse.com>
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

On Sat, Oct 12, 2019 at 09:27:53PM +0000, Martin Wilck wrote:
> From: Martin Wilck <mwilck@suse.com>
>=20
> In functions that return newly allocated memory, avoid cancellation
> points before returning, and if that's not possible, guard the code
> that contains cancellation points with a cleanup function calling
> free(), and immediately before returning, call pthread_cleanup_pop(0).

This is certainly an improvement. But if we're worried about leaking
memory from a cancellation during this function, shouldn't we be equally
worried about leaking the open file.

-Ben

>=20
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  libmultipath/alias.c | 22 ++++++++++++----------
>  1 file changed, 12 insertions(+), 10 deletions(-)
>=20
> diff --git a/libmultipath/alias.c b/libmultipath/alias.c
> index 15bbc8ed..0fc9e542 100644
> --- a/libmultipath/alias.c
> +++ b/libmultipath/alias.c
> @@ -268,13 +268,12 @@ allocate_binding(int fd, const char *wwid, int id, =
const char *prefix)
>  =09c =3D strchr(buf, ' ');
>  =09if (c)
>  =09=09*c =3D '\0';
> +
> +=09condlog(3, "Created new binding [%s] for WWID [%s]", buf, wwid);
>  =09alias =3D strdup(buf);
>  =09if (alias =3D=3D NULL)
> -=09=09condlog(0, "cannot copy new alias from bindings file : %s",
> -=09=09=09strerror(errno));
> -=09else
> -=09=09condlog(3, "Created new binding [%s] for WWID [%s]", alias,
> -=09=09=09wwid);
> +=09=09condlog(0, "cannot copy new alias from bindings file: out of memor=
y");
> +
>  =09return alias;
>  }
> =20
> @@ -342,7 +341,9 @@ use_existing_alias (const char *wwid, const char *fil=
e, const char *alias_old,
>  =09}
> =20
>  out:
> +=09pthread_cleanup_push(free, alias);
>  =09fclose(f);
> +=09pthread_cleanup_pop(0);
>  =09return alias;
>  }
> =20
> @@ -378,18 +379,19 @@ get_user_friendly_alias(const char *wwid, const cha=
r *file, const char *prefix,
>  =09=09return NULL;
>  =09}
> =20
> +=09pthread_cleanup_push(free, alias);
> +
>  =09if (fflush(f) !=3D 0) {
>  =09=09condlog(0, "cannot fflush bindings file stream : %s",
>  =09=09=09strerror(errno));
>  =09=09free(alias);
> -=09=09fclose(f);
> -=09=09return NULL;
> -=09}
> -
> -=09if (can_write && !bindings_read_only && !alias)
> +=09=09alias =3D NULL;
> +=09} else if (can_write && !bindings_read_only && !alias)
>  =09=09alias =3D allocate_binding(fd, wwid, id, prefix);
> =20
>  =09fclose(f);
> +
> +=09pthread_cleanup_pop(0);
>  =09return alias;
>  }
> =20
> --=20
> 2.23.0
