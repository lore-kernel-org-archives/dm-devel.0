From: Martin Wilck <Martin.Wilck@suse.com>
Subject: Re: [PATCH 2/7] multipathd: fix check_path errors with
	removed map
Date: Thu, 18 Jun 2020 19:34:38 +0000
Message-ID: <f09ec3b6537a7b7ac1ae26433e43846176f1dd48.camel@suse.com>
References: <1592439867-18427-1-git-send-email-bmarzins@redhat.com>
	<1592439867-18427-3-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1592439867-18427-3-git-send-email-bmarzins@redhat.com>
Content-Language: en-US
Content-ID: <8FD549361DF7BD42955A32E64635A909@eurprd04.prod.outlook.com>
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

On Wed, 2020-06-17 at 19:24 -0500, Benjamin Marzinski wrote:
> If a multipath device is removed during, or immediately before the
> call
> to check_path(), multipathd can behave incorrectly. A missing
> multpath
> device will cause update_multipath_strings() to fail, setting
> pp->dmstate to PSTATE_UNDEF.  If the path is up, this state will
> cause
> reinstate_path() to be called, which will also fail.  This will
> trigger
> a reload, restoring the recently removed device.
>=20
> If update_multipath_strings() fails because there is no multipath
> device, check_path should just quit, since the remove dmevent and
> uevent
> are likely already queued up. Also, I don't see any reason to reload
> the
> multipath device if reinstate fails. This code was added by
> fac68d7a99ef17d496079538a5c6836acd7911ab, which clamined that
> reinstate
> could fail if the path was disabled.  Looking through the current
> kernel
> code, I can't see any reason why a reinstate would fail, where a
> reload
> would help. If the path was missing from the multipath device,
> update_multipath_strings() would already catch that, and quit
> check_path() early, which make more sense to me than reloading does.

fac68d7 is related to the famous "dm-multipath: Accept failed paths for
multipath maps" patch (e.g.=20
https://patchwork.kernel.org/patch/3368381/#7193001), which never made
it upstream. SUSE kernels have shipped this patch for a long time, but
we don't apply it any more in recent kernels.

With this patch, The reinstate_path() failure would occur if multipathd
had created a table with a "disabled" device (one which would be
present in a dm map even though the actual block device didn't exist),
and then tried to reinstate such a path. It sounds unlikely, but it
might be possible if devices are coming and going in quick succession.
In that situation, and with the "accept failed path" patch applied, a
reload makes some sense, because reload (unlike reinstate) would not
fail (at least not for this reason) and would actually add that just-
reinstated path. OTOH, it's not likely that the reload would improve
matters, either. After all, multipathd is just trying to reinstate a
non-existing path. So, I'm fine with skipping the reload.

>=20
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
>  multipathd/main.c | 36 ++++++++++++++----------------------
>  1 file changed, 14 insertions(+), 22 deletions(-)
>=20
> diff --git a/multipathd/main.c b/multipathd/main.c
> index 6b7db2c0..8fb73922 100644
> --- a/multipathd/main.c
> +++ b/multipathd/main.c
> @@ -1611,22 +1611,18 @@ fail_path (struct path * pp, int del_active)
>  /*
>   * caller must have locked the path list before calling that
> function
>   */
> -static int
> +static void
>  reinstate_path (struct path * pp)
>  {
> -=09int ret =3D 0;
> -
>  =09if (!pp->mpp)
> -=09=09return 0;
> +=09=09return;
> =20
> -=09if (dm_reinstate_path(pp->mpp->alias, pp->dev_t)) {
> +=09if (dm_reinstate_path(pp->mpp->alias, pp->dev_t))
>  =09=09condlog(0, "%s: reinstate failed", pp->dev_t);
> -=09=09ret =3D 1;
> -=09} else {
> +=09else {
>  =09=09condlog(2, "%s: reinstated", pp->dev_t);
>  =09=09update_queue_mode_add_path(pp->mpp);
>  =09}
> -=09return ret;
>  }
>  static void
> @@ -2088,8 +2084,13 @@ check_path (struct vectors * vecs, struct path
> * pp, unsigned int ticks)
>  =09 * Synchronize with kernel state
>  =09 */
>  =09if (update_multipath_strings(pp->mpp, vecs->pathvec, 1)) {
> +=09=09struct dm_info info;
>  =09=09condlog(1, "%s: Could not synchronize with kernel
> state",
>  =09=09=09pp->dev);
> +=09=09if (pp->mpp && pp->mpp->alias &&
> +=09=09    do_dm_get_info(pp->mpp->alias, &info) =3D=3D 0)
> +=09=09=09/* multipath device missing. Likely removed */
> +=09=09=09return 0;
>  =09=09pp->dmstate =3D PSTATE_UNDEF;

It would be more elegant if we could distinguish different failure
modes from update_multipath_strings() directly, without having to call
do_dm_get_info() again.

>  =09}
>  =09/* if update_multipath_strings orphaned the path, quit early */
> @@ -2179,12 +2180,8 @@ check_path (struct vectors * vecs, struct path
> * pp, unsigned int ticks)
>  =09=09/*
>  =09=09 * reinstate this path
>  =09=09 */
> -=09=09if (!disable_reinstate && reinstate_path(pp)) {
> -=09=09=09condlog(3, "%s: reload map", pp->dev);
> -=09=09=09ev_add_path(pp, vecs, 1);
> -=09=09=09pp->tick =3D 1;
> -=09=09=09return 0;
> -=09=09}
> +=09=09if (!disable_reinstate)
> +=09=09=09reinstate_path(pp);
>  =09=09new_path_up =3D 1;
> =20
>  =09=09if (oldchkrstate !=3D PATH_UP && oldchkrstate !=3D
> PATH_GHOST)
> @@ -2200,15 +2197,10 @@ check_path (struct vectors * vecs, struct
> path * pp, unsigned int ticks)
>  =09else if (newstate =3D=3D PATH_UP || newstate =3D=3D PATH_GHOST) {
>  =09=09if ((pp->dmstate =3D=3D PSTATE_FAILED ||
>  =09=09    pp->dmstate =3D=3D PSTATE_UNDEF) &&
> -=09=09    !disable_reinstate) {
> +=09=09    !disable_reinstate)
>  =09=09=09/* Clear IO errors */
> -=09=09=09if (reinstate_path(pp)) {
> -=09=09=09=09condlog(3, "%s: reload map", pp->dev);
> -=09=09=09=09ev_add_path(pp, vecs, 1);
> -=09=09=09=09pp->tick =3D 1;
> -=09=09=09=09return 0;
> -=09=09=09}
> -=09=09} else {
> +=09=09=09reinstate_path(pp);
> +=09=09else {
>  =09=09=09LOG_MSG(4, verbosity, pp);
>  =09=09=09if (pp->checkint !=3D max_checkint) {
>  =09=09=09=09/*

--=20
Dr. Martin Wilck <mwilck@suse.com>, Tel. +49 (0)911 74053 2107
SUSE  Software Solutions Germany GmbH
HRB 36809, AG N=FCrnberg GF: Felix
Imend=F6rffer
