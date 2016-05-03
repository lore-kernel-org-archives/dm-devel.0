From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: Re: [PATCH 36/57] libmultipath: pass in 'cookie' as
 argument for dm_addmap()
Date: Tue, 3 May 2016 09:39:40 -0500
Message-ID: <20160503143940.GC26117@octiron.msp.redhat.com>
References: <1461755458-29225-1-git-send-email-hare@suse.de>
	<1461755458-29225-37-git-send-email-hare@suse.de>
	<20160502222313.GU26117@octiron.msp.redhat.com>
	<57286FE7.7000402@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <57286FE7.7000402@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Hannes Reinecke <hare@suse.de>
Cc: dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>, Christophe Varoqui <christophe.varoqui@gmail.com>
List-Id: dm-devel.ids

On Tue, May 03, 2016 at 11:31:19AM +0200, Hannes Reinecke wrote:
> On 05/03/2016 12:23 AM, Benjamin Marzinski wrote:
> > On Wed, Apr 27, 2016 at 01:10:37PM +0200, Hannes Reinecke wrote:
> >> Instead of generating the cookie internally we should be
> >> passing in the cookie to dm_addmap().
> > =

> > These look like they could actually cause problems. With
> > dm_addmap_create and dm_addmap_reload, you could be in a situation where
> > you get a cookie back on your first call to dm_task_set_cookie, wait on
> > it, so that cookie is no longer in use, and then use that same cookie
> > id again. It's possible that after you first waited on the cookie,
> > someone else could have been given that cookie id (without looking into
> > the dm cookie code more, I'm not sure how likely this is). If that is
> > so, the second call to dm_addmap would be adding its command to the list
> > of other commands for that cookie (since you are allowed to use a cookie
> > for multiple dm commands). Calling dm_udev_wait would make it wait of
> > all the commands.
> > =

> > We can use a cookie multiple times and then wait on it once. But we
> > can't keep reusing the cookie after we've waited on it, because someone
> > else could be using the same cookie.
> > =

> > -Ben
> > =

> >>
> >> Signed-off-by: Hannes Reinecke <hare@suse.de>
> >> ---
> >>  libmultipath/devmapper.c | 23 ++++++++++++++---------
> >>  1 file changed, 14 insertions(+), 9 deletions(-)
> >>
> >> diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
> >> index e6156f7..a96cc0e 100644
> >> --- a/libmultipath/devmapper.c
> >> +++ b/libmultipath/devmapper.c
> >> @@ -274,11 +274,10 @@ dm_device_remove (const char *name, int needsync=
, int deferred_remove) {
> >>  =

> >>  extern int
> >>  dm_addmap (int task, const char *target, struct multipath *mpp,
> >> -	   char * params, int ro) {
> >> +	   char * params, int ro, uint32_t *cookie) {
> >>  	int r =3D 0;
> >>  	struct dm_task *dmt;
> >>  	char *prefixed_uuid =3D NULL;
> >> -	uint32_t cookie =3D 0;
> >>  =

> >>  	if (!(dmt =3D dm_task_create (task)))
> >>  		return 0;
> >> @@ -319,18 +318,18 @@ dm_addmap (int task, const char *target, struct =
multipath *mpp,
> >>  	dm_task_no_open_count(dmt);
> >>  =

> >>  	if (task =3D=3D DM_DEVICE_CREATE &&
> >> -	    !dm_task_set_cookie(dmt, &cookie,
> >> +	    !dm_task_set_cookie(dmt, cookie,
> >>  				DM_UDEV_DISABLE_LIBRARY_FALLBACK)) {
> >> -		dm_udev_complete(cookie);
> >> +		dm_udev_complete(*cookie);
> >>  		goto freeout;
> >>  	}
> >>  	r =3D dm_task_run (dmt);
> >>  =

> >>  	if (task =3D=3D DM_DEVICE_CREATE) {
> >>  		if (!r)
> >> -			dm_udev_complete(cookie);
> >> +			dm_udev_complete(*cookie);
> >>  		else
> >> -			dm_udev_wait(cookie);
> >> +			dm_udev_wait(*cookie);
> >>  	}
> >>  	freeout:
> >>  	if (prefixed_uuid)
> >> @@ -345,11 +344,13 @@ dm_addmap (int task, const char *target, struct =
multipath *mpp,
> >>  extern int
> >>  dm_addmap_create (struct multipath *mpp, char * params) {
> >>  	int ro;
> >> +	uint32_t cookie =3D 0;
> >>  =

> >>  	for (ro =3D 0; ro <=3D 1; ro++) {
> >>  		int err;
> >>  =

> >> -		if (dm_addmap(DM_DEVICE_CREATE, TGT_MPATH, mpp, params, ro))
> >> +		if (dm_addmap(DM_DEVICE_CREATE, TGT_MPATH,
> >> +			      mpp, params, ro, &cookie))
> >>  			return 1;
> >>  		/*
> >>  		 * DM_DEVICE_CREATE is actually DM_DEV_CREATE + DM_TABLE_LOAD.
> >> @@ -374,11 +375,15 @@ dm_addmap_create (struct multipath *mpp, char * =
params) {
> >>  =

> >>  extern int
> >>  dm_addmap_reload (struct multipath *mpp, char *params) {
> >> -	if (dm_addmap(DM_DEVICE_RELOAD, TGT_MPATH, mpp, params, ADDMAP_RW))
> >> +	uint32_t cookie =3D 0;
> >> +
> >> +	if (dm_addmap(DM_DEVICE_RELOAD, TGT_MPATH, mpp, params,
> >> +		      ADDMAP_RW, &cookie))
> >>  		return 1;
> >>  	if (errno !=3D EROFS)
> >>  		return 0;
> >> -	return dm_addmap(DM_DEVICE_RELOAD, TGT_MPATH, mpp, params, ADDMAP_RO=
);
> >> +	return dm_addmap(DM_DEVICE_RELOAD, TGT_MPATH, mpp, params,
> >> +			 ADDMAP_RO, &cookie);
> >>  }
> >>  =

> >>  extern int
> >> -- =

> >> 2.6.6
> Looking closer, this entire section looks fishy.
> >From the lvm source code I couldn't figure out _how_ we could get
> into a situation where dm_task_run() would return 0 (ie no error
> occurred), but errno would be set to EROFS.

dm_task_run returns a 0 on error, not success.

-Ben

> =

> _If_ we could rely on dm_task_run() to return an error here this
> whole issue wouldn't occur, as we haven't actually waited on the
> cookie, and the second dm_addmap() call would be legit, even with
> the same cookie.
> =

> Checking with git how the above came about.
> =

> Cheers,
> =

> Hannes
> -- =

> Dr. Hannes Reinecke		   Teamlead Storage & Networking
> hare@suse.de			               +49 911 74053 688
> SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
> GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
> HRB 21284 (AG N=FCrnberg)
