From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: Re: [PATCH 3/6] libmultipath: refactor calls to get dm
 device info
Date: Fri, 12 May 2017 11:59:35 -0500
Message-ID: <20170512165935.GK22856@octiron.msp.redhat.com>
References: <1494349025-6561-1-git-send-email-bmarzins@redhat.com>
	<1494349025-6561-4-git-send-email-bmarzins@redhat.com>
	<1494534360.6093.35.camel@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1494534360.6093.35.camel@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Martin Wilck <mwilck@suse.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Thu, May 11, 2017 at 10:26:00PM +0200, Martin Wilck wrote:
> On Tue, 2017-05-09 at 11:57 -0500, Benjamin Marzinski wrote:
> > Multipath has a number of functions that all do basically the same
> > thing to get members of the dm_info structure. This just refactors
> > them
> > to use common code to do it.
> =

> This is nice, but it might be even better to simply store all relevant
> information from DM_DEVICE_INFO in the mpp structure in the first
> place, avoiding the need to do this ioctl multiple times to get various
> pieces of information.

I totally agree that we are likely underusing mpp->dmi, but in a number
of these cases, you actually need the current information. In still
others, you don't necessarily even have a multipath structure to put it
in.  So, I think dm_get_info needs to simply return the info.

> =

> That can be done in a separate patch, of course.

Yeah. We definitely need to look at all the times where we grab a fresh
copy of the device info, and see if we are actually looking at a field
that can change over time, where we need the current data. mpp->dmi is
great for when we don't need current data, and we should definitely make
sure we're using it there. On the other hand, it's pointless to keep
freeing and mallocing it when we really need current info.

-Ben =


> Reviewed-by: Martin Wilck <mwilck@suse.com>
> =

> Regards
> Martin
> =

> =

> > =

> > Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> > ---
> > =A0libmultipath/devmapper.c=A0=A0| 171 +++++++++-----------------------=
----
> > ----------
> > =A0libmultipath/devmapper.h=A0=A0|=A0=A0=A03 +-
> > =A0multipathd/cli_handlers.c |=A0=A024 ++-----
> > =A03 files changed, 42 insertions(+), 156 deletions(-)
> > =

> > diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
> > index 1c6b87e..2c4a13a 100644
> > --- a/libmultipath/devmapper.c
> > +++ b/libmultipath/devmapper.c
> > @@ -399,16 +399,16 @@ int dm_addmap_reload(struct multipath *mpp,
> > char *params, int flush)
> > =A0	return r;
> > =A0}
> > =A0
> > -int dm_map_present(const char * str)
> > +static int
> > +do_get_info(const char *name, struct dm_info *info)
> > =A0{
> > -	int r =3D 0;
> > +	int r =3D -1;
> > =A0	struct dm_task *dmt;
> > -	struct dm_info info;
> > =A0
> > =A0	if (!(dmt =3D dm_task_create(DM_DEVICE_INFO)))
> > -		return 0;
> > +		return r;
> > =A0
> > -	if (!dm_task_set_name(dmt, str))
> > +	if (!dm_task_set_name(dmt, name))
> > =A0		goto out;
> > =A0
> > =A0	dm_task_no_open_count(dmt);
> > @@ -416,16 +416,25 @@ int dm_map_present(const char * str)
> > =A0	if (!dm_task_run(dmt))
> > =A0		goto out;
> > =A0
> > -	if (!dm_task_get_info(dmt, &info))
> > +	if (!dm_task_get_info(dmt, info))
> > =A0		goto out;
> > =A0
> > -	if (info.exists)
> > -		r =3D 1;
> > +	if (!info->exists)
> > +		goto out;
> > +
> > +	r =3D 0;
> > =A0out:
> > =A0	dm_task_destroy(dmt);
> > =A0	return r;
> > =A0}
> > =A0
> > +int dm_map_present(const char * str)
> > +{
> > +	struct dm_info info;
> > +
> > +	return (do_get_info(str, &info) =3D=3D 0);
> > +}
> > +
> > =A0int dm_get_map(const char *name, unsigned long long *size, char
> > *outparams)
> > =A0{
> > =A0	int r =3D 1;
> > @@ -646,29 +655,15 @@ out:
> > =A0static int
> > =A0dm_dev_t (const char * mapname, char * dev_t, int len)
> > =A0{
> > -	int r =3D 1;
> > -	struct dm_task *dmt;
> > =A0	struct dm_info info;
> > =A0
> > -	if (!(dmt =3D dm_task_create(DM_DEVICE_INFO)))
> > -		return 0;
> > -
> > -	if (!dm_task_set_name(dmt, mapname))
> > -		goto out;
> > -
> > -	if (!dm_task_run(dmt))
> > -		goto out;
> > -
> > -	if (!dm_task_get_info(dmt, &info) || !info.exists)
> > -		goto out;
> > +	if (do_get_info(mapname, &info) !=3D 0)
> > +		return 1;
> > =A0
> > =A0	if (snprintf(dev_t, len, "%i:%i", info.major, info.minor) >
> > len)
> > -		goto out;
> > +		return 1;
> > =A0
> > -	r =3D 0;
> > -out:
> > -	dm_task_destroy(dmt);
> > -	return r;
> > +	return 0;
> > =A0}
> > =A0
> > =A0int
> > @@ -700,59 +695,16 @@ out:
> > =A0}
> > =A0
> > =A0int
> > -dm_get_major (char * mapname)
> > +dm_get_major_minor(const char *name, int *major, int *minor)
> > =A0{
> > -	int r =3D -1;
> > -	struct dm_task *dmt;
> > =A0	struct dm_info info;
> > =A0
> > -	if (!(dmt =3D dm_task_create(DM_DEVICE_INFO)))
> > -		return 0;
> > -
> > -	if (!dm_task_set_name(dmt, mapname))
> > -		goto out;
> > -
> > -	if (!dm_task_run(dmt))
> > -		goto out;
> > -
> > -	if (!dm_task_get_info(dmt, &info))
> > -		goto out;
> > -
> > -	if (!info.exists)
> > -		goto out;
> > -
> > -	r =3D info.major;
> > -out:
> > -	dm_task_destroy(dmt);
> > -	return r;
> > -}
> > -
> > -int
> > -dm_get_minor (char * mapname)
> > -{
> > -	int r =3D -1;
> > -	struct dm_task *dmt;
> > -	struct dm_info info;
> > -
> > -	if (!(dmt =3D dm_task_create(DM_DEVICE_INFO)))
> > -		return 0;
> > -
> > -	if (!dm_task_set_name(dmt, mapname))
> > -		goto out;
> > -
> > -	if (!dm_task_run(dmt))
> > -		goto out;
> > -
> > -	if (!dm_task_get_info(dmt, &info))
> > -		goto out;
> > -
> > -	if (!info.exists)
> > -		goto out;
> > +	if (do_get_info(name, &info) !=3D 0)
> > +		return -1;
> > =A0
> > -	r =3D info.minor;
> > -out:
> > -	dm_task_destroy(dmt);
> > -	return r;
> > +	*major =3D info.major;
> > +	*minor =3D info.minor;
> > +	return 0;
> > =A0}
> > =A0
> > =A0static int
> > @@ -1070,31 +1022,12 @@ out:
> > =A0int
> > =A0dm_geteventnr (char *name)
> > =A0{
> > -	struct dm_task *dmt;
> > =A0	struct dm_info info;
> > -	int event =3D -1;
> > =A0
> > -	if (!(dmt =3D dm_task_create(DM_DEVICE_INFO)))
> > +	if (do_get_info(name, &info) !=3D 0)
> > =A0		return -1;
> > =A0
> > -	if (!dm_task_set_name(dmt, name))
> > -		goto out;
> > -
> > -	dm_task_no_open_count(dmt);
> > -
> > -	if (!dm_task_run(dmt))
> > -		goto out;
> > -
> > -	if (!dm_task_get_info(dmt, &info))
> > -		goto out;
> > -
> > -	if (info.exists)
> > -		event =3D info.event_nr;
> > -
> > -out:
> > -	dm_task_destroy(dmt);
> > -
> > -	return event;
> > +	return info.event_nr;
> > =A0}
> > =A0
> > =A0char *
> > @@ -1262,26 +1195,12 @@ cancel_remove_partmap (const char *name, void
> > *unused)
> > =A0static int
> > =A0dm_get_deferred_remove (char * mapname)
> > =A0{
> > -	int r =3D -1;
> > -	struct dm_task *dmt;
> > =A0	struct dm_info info;
> > =A0
> > -	if (!(dmt =3D dm_task_create(DM_DEVICE_INFO)))
> > +	if (do_get_info(mapname, &info) !=3D 0)
> > =A0		return -1;
> > =A0
> > -	if (!dm_task_set_name(dmt, mapname))
> > -		goto out;
> > -
> > -	if (!dm_task_run(dmt))
> > -		goto out;
> > -
> > -	if (!dm_task_get_info(dmt, &info))
> > -		goto out;
> > -
> > -	r =3D info.deferred_remove;
> > -out:
> > -	dm_task_destroy(dmt);
> > -	return r;
> > +	return info.deferred_remove;
> > =A0}
> > =A0
> > =A0static int
> > @@ -1328,9 +1247,6 @@ alloc_dminfo (void)
> > =A0int
> > =A0dm_get_info (char * mapname, struct dm_info ** dmi)
> > =A0{
> > -	int r =3D 1;
> > -	struct dm_task *dmt =3D NULL;
> > -
> > =A0	if (!mapname)
> > =A0		return 1;
> > =A0
> > @@ -1340,32 +1256,13 @@ dm_get_info (char * mapname, struct dm_info
> > ** dmi)
> > =A0	if (!*dmi)
> > =A0		return 1;
> > =A0
> > -	if (!(dmt =3D dm_task_create(DM_DEVICE_INFO)))
> > -		goto out;
> > -
> > -	if (!dm_task_set_name(dmt, mapname))
> > -		goto out;
> > -
> > -	dm_task_no_open_count(dmt);
> > -
> > -	if (!dm_task_run(dmt))
> > -		goto out;
> > -
> > -	if (!dm_task_get_info(dmt, *dmi))
> > -		goto out;
> > -
> > -	r =3D 0;
> > -out:
> > -	if (r) {
> > +	if (do_get_info(mapname, *dmi) !=3D 0) {
> > =A0		memset(*dmi, 0, sizeof(struct dm_info));
> > =A0		FREE(*dmi);
> > =A0		*dmi =3D NULL;
> > +		return 1;
> > =A0	}
> > -
> > -	if (dmt)
> > -		dm_task_destroy(dmt);
> > -
> > -	return r;
> > +	return 0;
> > =A0}
> > =A0
> > =A0struct rename_data {
> > diff --git a/libmultipath/devmapper.h b/libmultipath/devmapper.h
> > index aca4454..5b66865 100644
> > --- a/libmultipath/devmapper.h
> > +++ b/libmultipath/devmapper.h
> > @@ -52,8 +52,7 @@ int dm_enablegroup(char * mapname, int index);
> > =A0int dm_disablegroup(char * mapname, int index);
> > =A0int dm_get_maps (vector mp);
> > =A0int dm_geteventnr (char *name);
> > -int dm_get_major (char *name);
> > -int dm_get_minor (char *name);
> > +int dm_get_major_minor (const char *name, int *major, int *minor);
> > =A0char * dm_mapname(int major, int minor);
> > =A0int dm_remove_partmaps (const char * mapname, int need_sync,
> > =A0			int deferred_remove);
> > diff --git a/multipathd/cli_handlers.c b/multipathd/cli_handlers.c
> > index d598039..04c7386 100644
> > --- a/multipathd/cli_handlers.c
> > +++ b/multipathd/cli_handlers.c
> > @@ -746,7 +746,7 @@ cli_add_map (void * v, char ** reply, int * len,
> > void * data)
> > =A0	char * param =3D get_keyparam(v, MAP);
> > =A0	int major, minor;
> > =A0	char dev_path[PATH_SIZE];
> > -	char *alias, *refwwid;
> > +	char *refwwid, *alias =3D NULL;
> > =A0	int rc, count =3D 0;
> > =A0	struct config *conf;
> > =A0
> > @@ -763,14 +763,12 @@ cli_add_map (void * v, char ** reply, int *
> > len, void * data)
> > =A0	}
> > =A0	put_multipath_config(conf);
> > =A0	do {
> > -		minor =3D dm_get_minor(param);
> > -		if (minor < 0)
> > +		if (dm_get_major_minor(param, &major, &minor) < 0)
> > =A0			condlog(2, "%s: not a device mapper table",
> > param);
> > -		major =3D dm_get_major(param);
> > -		if (major < 0)
> > -			condlog(2, "%s: not a device mapper table",
> > param);
> > -		sprintf(dev_path, "dm-%d", minor);
> > -		alias =3D dm_mapname(major, minor);
> > +		else {
> > +			sprintf(dev_path, "dm-%d", minor);
> > +			alias =3D dm_mapname(major, minor);
> > +		}
> > =A0		/*if there is no mapname found, we first create the
> > device*/
> > =A0		if (!alias && !count) {
> > =A0			condlog(2, "%s: mapname not found for
> > %d:%d",
> > @@ -804,23 +802,15 @@ cli_del_map (void * v, char ** reply, int *
> > len, void * data)
> > =A0	struct vectors * vecs =3D (struct vectors *)data;
> > =A0	char * param =3D get_keyparam(v, MAP);
> > =A0	int major, minor;
> > -	char dev_path[PATH_SIZE];
> > =A0	char *alias;
> > =A0	int rc;
> > =A0
> > =A0	param =3D convert_dev(param, 0);
> > =A0	condlog(2, "%s: remove map (operator)", param);
> > -	minor =3D dm_get_minor(param);
> > -	if (minor < 0) {
> > -		condlog(2, "%s: not a device mapper table", param);
> > -		return 1;
> > -	}
> > -	major =3D dm_get_major(param);
> > -	if (major < 0) {
> > +	if (dm_get_major_minor(param, &major, &minor) < 0) {
> > =A0		condlog(2, "%s: not a device mapper table", param);
> > =A0		return 1;
> > =A0	}
> > -	sprintf(dev_path,"dm-%d", minor);
> > =A0	alias =3D dm_mapname(major, minor);
> > =A0	if (!alias) {
> > =A0		condlog(2, "%s: mapname not found for %d:%d",
> =

> -- =

> Dr. Martin Wilck <mwilck@suse.com>, Tel.=A0+49 (0)911 74053 2107
> SUSE Linux GmbH, GF: Felix Imend=F6rffer, Jane Smithard, Graham Norton
> HRB 21284 (AG N=FCrnberg)
