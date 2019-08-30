From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH v3 2/2] mdadm: Introduce new array state
	'broken' for raid0/linear
Date: Fri, 30 Aug 2019 18:17:08 +1000
Message-ID: <87a7brf4or.fsf@notabene.neil.brown.name>
References: <20190822161318.26236-1-gpiccoli@canonical.com>
	<20190822161318.26236-2-gpiccoli@canonical.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============7102104917191092336=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20190822161318.26236-2-gpiccoli@canonical.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "Guilherme G. Piccoli" <gpiccoli@canonical.com>, linux-raid@vger.kernel.org
Cc: Neil F Brown <nfbrown@suse.com>, Song Liu <songliubraving@fb.com>, liu.song.a23@gmail.com, linux-block@vger.kernel.org, dm-devel@redhat.com, jay.vosburgh@canonical.com
List-Id: dm-devel.ids

--===============7102104917191092336==
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 22 2019,  Guilherme G. Piccoli  wrote:

> Currently if a md raid0/linear array gets one or more members removed whi=
le
> being mounted, kernel keeps showing state 'clean' in the 'array_state'
> sysfs attribute. Despite udev signaling the member device is gone, 'mdadm'
> cannot issue the STOP_ARRAY ioctl successfully, given the array is mounte=
d.
>
> Nothing else hints that something is wrong (except that the removed devic=
es
> don't show properly in the output of mdadm 'detail' command). There is no
> other property to be checked, and if user is not performing reads/writes
> to the array, even kernel log is quiet and doesn't give a clue about the
> missing member.
>
> This patch is the mdadm counterpart of kernel new array state 'broken'.
> The 'broken' state mimics the state 'clean' in every aspect, being useful
> only to distinguish if an array has some member missing. All necessary
> paths in mdadm were changed to deal with 'broken' state, and in case the
> tool runs in a kernel that is not updated, it'll work normally, i.e., it
> doesn't require the 'broken' state in order to work.
> Also, this patch changes the way the array state is showed in the 'detail'
> command (for raid0/linear only) - now it takes the 'array_state' sysfs
> attribute into account instead of only rely in the MD_SB_CLEAN flag.
>
> Cc: NeilBrown <neilb@suse.com>
> Cc: Song Liu <songliubraving@fb.com>
> Signed-off-by: Guilherme G. Piccoli <gpiccoli@canonical.com>
> ---
>
> v2 -> v3:
> * Nothing changed.
>
> v1 -> v2:
> * Added handling for md/linear 'broken' state.
>
>
>  Detail.c  | 17 +++++++++++++++--
>  Monitor.c |  9 +++++++--
>  maps.c    |  1 +
>  mdadm.h   |  1 +
>  mdmon.h   |  2 +-
>  monitor.c |  4 ++--
>  6 files changed, 27 insertions(+), 7 deletions(-)
>
> diff --git a/Detail.c b/Detail.c
> index ad60434..cc7e9f1 100644
> --- a/Detail.c
> +++ b/Detail.c
> @@ -81,6 +81,7 @@ int Detail(char *dev, struct context *c)
>  	int external;
>  	int inactive;
>  	int is_container =3D 0;
> +	char arrayst[12] =3D { 0 }; /* no state is >10 chars currently */

Why do you have an array?  Why not just a "char *".
Then all the "strncpy" below become simple pointer assignment.

>=20=20
>  	if (fd < 0) {
>  		pr_err("cannot open %s: %s\n",
> @@ -485,9 +486,21 @@ int Detail(char *dev, struct context *c)
>  			else
>  				st =3D ", degraded";
>=20=20
> +			if (array.state & (1 << MD_SB_CLEAN)) {
> +				if ((array.level =3D=3D 0) ||
> +				    (array.level =3D=3D LEVEL_LINEAR))
> +					strncpy(arrayst,
> +						map_num(sysfs_array_states,
> +							sra->array_state),
> +						sizeof(arrayst)-1);
> +				else
> +					strncpy(arrayst, "clean",
> +						sizeof(arrayst)-1);
> +			} else
> +				strncpy(arrayst, "active", sizeof(arrayst)-1);
> +
>  			printf("             State : %s%s%s%s%s%s \n",
> -			       (array.state & (1 << MD_SB_CLEAN)) ?
> -			       "clean" : "active", st,
> +			       arrayst, st,
>  			       (!e || (e->percent < 0 &&
>  				       e->percent !=3D RESYNC_PENDING &&
>  				       e->percent !=3D RESYNC_DELAYED)) ?
> diff --git a/Monitor.c b/Monitor.c
> index 036103f..9fd5406 100644
> --- a/Monitor.c
> +++ b/Monitor.c
> @@ -1055,8 +1055,12 @@ int Wait(char *dev)
>  	}
>  }
>=20=20
> +/* The state "broken" is used only for RAID0/LINEAR - it's the same as
> + * "clean", but used in case the array has one or more members missing.
> + */
> +#define CLEAN_STATES_LAST_POS	5
>  static char *clean_states[] =3D {
> -	"clear", "inactive", "readonly", "read-auto", "clean", NULL };
> +	"clear", "inactive", "readonly", "read-auto", "clean", "broken", NULL };
>=20=20
>  int WaitClean(char *dev, int verbose)
>  {
> @@ -1116,7 +1120,8 @@ int WaitClean(char *dev, int verbose)
>  			rv =3D read(state_fd, buf, sizeof(buf));
>  			if (rv < 0)
>  				break;
> -			if (sysfs_match_word(buf, clean_states) <=3D 4)

Arg.  That is horrible.  Who wrote that code???
Oh, it was me.  And only 8 years ago.
sysfs_match_word() should return a clear "didn't match" indicator, like
"-1".

Ideally that should be fixed, but I cannot really expect you to do that.

Maybe make it
   if (clean_states[sysfs_match_word(buf, clean_states)] !=3D NULL)
 ??
or
   if (sysfs_match_word(buf, clean_states) < ARRAY_SIZE(clean_states)-1)

Otherwise the patch looks ok.

Thanks,
NeilBrown

> +			if (sysfs_match_word(buf, clean_states)
> +			    <=3D CLEAN_STATES_LAST_POS)
>  				break;
>  			rv =3D sysfs_wait(state_fd, &delay);
>  			if (rv < 0 && errno !=3D EINTR)
> diff --git a/maps.c b/maps.c
> index 02a0474..49b7f2c 100644
> --- a/maps.c
> +++ b/maps.c
> @@ -150,6 +150,7 @@ mapping_t sysfs_array_states[] =3D {
>  	{ "read-auto", ARRAY_READ_AUTO },
>  	{ "clean", ARRAY_CLEAN },
>  	{ "write-pending", ARRAY_WRITE_PENDING },
> +	{ "broken", ARRAY_BROKEN },
>  	{ NULL, ARRAY_UNKNOWN_STATE }
>  };
>=20=20
> diff --git a/mdadm.h b/mdadm.h
> index 43b07d5..c88ceab 100644
> --- a/mdadm.h
> +++ b/mdadm.h
> @@ -373,6 +373,7 @@ struct mdinfo {
>  		ARRAY_ACTIVE,
>  		ARRAY_WRITE_PENDING,
>  		ARRAY_ACTIVE_IDLE,
> +		ARRAY_BROKEN,
>  		ARRAY_UNKNOWN_STATE,
>  	} array_state;
>  	struct md_bb bb;
> diff --git a/mdmon.h b/mdmon.h
> index 818367c..b3d72ac 100644
> --- a/mdmon.h
> +++ b/mdmon.h
> @@ -21,7 +21,7 @@
>  extern const char Name[];
>=20=20
>  enum array_state { clear, inactive, suspended, readonly, read_auto,
> -		   clean, active, write_pending, active_idle, bad_word};
> +		   clean, active, write_pending, active_idle, broken, bad_word};
>=20=20
>  enum sync_action { idle, reshape, resync, recover, check, repair, bad_ac=
tion };
>=20=20
> diff --git a/monitor.c b/monitor.c
> index 81537ed..e0d3be6 100644
> --- a/monitor.c
> +++ b/monitor.c
> @@ -26,7 +26,7 @@
>=20=20
>  static char *array_states[] =3D {
>  	"clear", "inactive", "suspended", "readonly", "read-auto",
> -	"clean", "active", "write-pending", "active-idle", NULL };
> +	"clean", "active", "write-pending", "active-idle", "broken", NULL };
>  static char *sync_actions[] =3D {
>  	"idle", "reshape", "resync", "recover", "check", "repair", NULL
>  };
> @@ -476,7 +476,7 @@ static int read_and_act(struct active_array *a, fd_se=
t *fds)
>  		a->next_state =3D clean;
>  		ret |=3D ARRAY_DIRTY;
>  	}
> -	if (a->curr_state =3D=3D clean) {
> +	if ((a->curr_state =3D=3D clean) || (a->curr_state =3D=3D broken)) {
>  		a->container->ss->set_array_state(a, 1);
>  	}
>  	if (a->curr_state =3D=3D active ||
> --=20
> 2.22.0

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAl1o24QACgkQOeye3VZi
gbngjxAAkEcGFoZoW/C9+5BxEzULa3rbPMf8t5+QuSEl7U1Lrw5XBEWWgMEBGHvx
Ql9UE1z/YKM6UvzqC3mtIjSMLHnO74YPaRh2oKWDS+hnwMuXkusHirQJ11iOtCZL
qSSktC7++yrLFc/QhVaxAm4Hzm1A3g/p/JqBu0riyhbTrcM5NNYH8B2JjVjTHu4D
3BG3jAKuuaOOcpRzOkAX3GKJG14AjO1Mt203TniaOYgmS0sNOkzUReOUaFsrHAKH
n1mOLEVXAawsYxBWSAmX6t984ftWM4nMUVZ2MBxmuoOMa55NbHNUPjeFk8p40LJC
gjz09PkSi89624pNk+3bT69DjUF37CQUPMEvyabSXamMfRLBnHxGkcvweD3TFh4d
+VJMqw33wmmt/qKM21QtiGZ7Boa2VtD/VAnx6DkQuMJl0+eo4fFcnVMhLKVFgZhj
fJbQLySFsRQfWqllcg+SkATrpZnIj/XdWAnbzTB7r3RjmQHm7VS7O1YCtQQCPRuU
ykmD6LkW2ugrMbm4sm+QNboG/tvCZLi22Ut/QI0p+UC4fo9BPagD01/tFTZ1fKX0
hy6Mzihpq66uihDj8ELdeoU1LJfO9LMzUvKvl6k/9I/Y+gcdT6OTxoZ/5FVqwdEh
rZgYwsyVjFDIk8s9+3uEFWrwiObOTDbOeiwAAqvFoFvaJBQsxsk=
=gG14
-----END PGP SIGNATURE-----
--=-=-=--


--===============7102104917191092336==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============7102104917191092336==--
