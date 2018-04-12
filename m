From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: Re: [PATCH v4 16/20] multipath -u : set
 FIND_MULTIPATHS_WAIT_UNTIL from /dev/shm
Date: Thu, 12 Apr 2018 16:35:03 -0500
Message-ID: <20180412213503.GB3103@octiron.msp.redhat.com>
References: <20180404161627.6244-1-mwilck@suse.com>
	<20180404161627.6244-17-mwilck@suse.com>
	<20180412183639.GR3103@octiron.msp.redhat.com>
	<1523565302.4346.43.camel@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1523565302.4346.43.camel@suse.com>
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
Cc: dm-devel@redhat.com, Julian Andres Klode <julian.klode@canonical.com>
List-Id: dm-devel.ids

On Thu, Apr 12, 2018 at 10:35:02PM +0200, Martin Wilck wrote:
> On Thu, 2018-04-12 at 13:36 -0500, Benjamin Marzinski wrote:
> > On Wed, Apr 04, 2018 at 06:16:23PM +0200, Martin Wilck wrote:
> > > In "find_multipaths smart" mode, use time stamps under
> > > /dev/shm/multipath/find_multipaths to track waiting for multipath
> > > siblings. When a path is first encountered and is "maybe"
> > > multipath, create a
> > > file under /dev/shm, set its modification time to the expiry time
> > > of the
> > > timer, and set the FIND_MULTIPATHS_WAIT_UNTIL variable. On later
> > > calls, also set
> > > FIND_MULTIPATHS_WAIT_UNTIL to the expiry time (but don't change the
> > > time
> > > stamp) if it's not expired yet, or 0 if it is expired. Set
> > > FIND_MULTIPATHS_WAIT_UNTIL even if enough evidence becomes
> > > available to decide
> > > if the path needs to be multipathed - this enables the udev rules
> > > to detect
> > > that this is a device a timer has been started for, and stop it. By
> > > using
> > > /dev/shm, we share information about "smart" timers between initrd
> > > and root
> > > file system, and thus only calculate the timeout once.
> > > =

> > > Signed-off-by: Martin Wilck <mwilck@suse.com>
> > > ---
> > >  libmultipath/file.c |   2 +-
> > >  libmultipath/file.h |   1 +
> > >  multipath/main.c    | 133
> > > ++++++++++++++++++++++++++++++++++++++++++++++++++++
> > >  3 files changed, 135 insertions(+), 1 deletion(-)
> > > =

> > > +
> > > +/**
> > > + * find_multipaths_check_timeout(wwid, tmo)
> > > + * Helper for "find_multipaths smart"
> > > + *
> > > + * @param[in] pp: path to check / record
> > > + * @param[in] tmo: configured timeout for this WWID, or value <=3D 0
> > > for checking
> > > + * @param[out] until: timestamp until we must wait,
> > > CLOCK_REALTIME, if return
> > > + *             value is FIND_MULTIPATHS_WAITING
> > > + * @returns: FIND_MULTIPATHS_WAIT_DONE, if waiting has finished
> > > + * @returns: FIND_MULTIPATHS_ERROR, if internal error occured
> > > + * @returns: FIND_MULTIPATHS_NEVER, if tmo is 0 and we didn't wait
> > > for this
> > > + *           device
> > > + * @returns: FIND_MULTIPATHS_WAITING, if timeout hasn't expired
> > > + */
> > > +static int find_multipaths_check_timeout(const struct path *pp,
> > > long tmo,
> > > +					 struct timespec *until)
> > > +{
> > > +	char path[PATH_MAX];
> > > +	struct timespec now, ftimes[2], tdiff;
> > > +	struct stat st;
> > > +	long fd;
> > > +	int r, err, retries =3D 0;
> > > +
> > > +	clock_gettime(CLOCK_REALTIME, &now);
> > > +
> > =

> > I'm worried about using pp->dev_t here with no method of removing
> > these
> > files.  What happens when a path device, say 8:32 is removed and a
> > completely new device comes in reusing the same dev_t?
> =

> Hm, what else should we use? devnode name is even worse, and most other
> options are a can of worms...  In the worst case, the new device
> wouldn't be waited for (or not long enough), because the marker existed
> before it was detected.
> =

> I could simply add a rule that removes the marker in case of a "remove"
> uevent, ok?

Fair enough. Nothing really bad happens, and removing the markers on
remove uevents would solve it.
 =

> > =

> > > +	if (snprintf(path, sizeof(path), "%s/%s", shm_find_mp_dir,
> > > pp->dev_t)
> > > +	    >=3D sizeof(path)) {
> > > +		condlog(1, "%s: path name overflow", __func__);
> > =

> > shouldn't this be:
> > 		return FIND_MULTIPATHS_ERROR;
> =

> Bah, thank for catching it.
> =

> > >  static int print_cmd_valid(int k, const vector pathvec,
> > >  			   struct config *conf)
> > >  {
> > >  	static const int vals[] =3D { 1, 0, 2 };
> > > +	int wait =3D FIND_MULTIPATHS_NEVER;
> > > +	struct timespec until;
> > > +	struct path *pp;
> > >  =

> > >  	if (k < 0 || k >=3D sizeof(vals))
> > >  		return 1;
> > >  =

> > > +	if (k =3D=3D 2) {
> > > +		/*
> > > +		 * Caller ensures that pathvec[0] is the path to
> > > +		 * examine.
> > > +		 */
> > > +		pp =3D VECTOR_SLOT(pathvec, 0);
> > > +		select_find_multipaths_timeout(conf, pp);
> > > +		wait =3D find_multipaths_check_timeout(
> > > +			pp, pp->find_multipaths_timeout, &until);
> > > +		if (wait !=3D FIND_MULTIPATHS_WAITING)
> > > +			k =3D 1;
> > > +	} else if (pathvec !=3D NULL) {
> > > +		pp =3D VECTOR_SLOT(pathvec, 0);
> > > +		wait =3D find_multipaths_check_timeout(pp, 0,
> > > &until);
> > > +	}
> > > +	if (wait =3D=3D FIND_MULTIPATHS_WAITING)
> > > +		printf("FIND_MULTIPATHS_WAIT_UNTIL=3D\"%ld.%06ld\"\n
> > > ",
> > > +			       until.tv_sec, until.tv_nsec/1000);
> > > +	else if (wait =3D=3D FIND_MULTIPATHS_WAIT_DONE)
> > > +		printf("FIND_MULTIPATHS_WAIT_UNTIL=3D\"0\"\n");
> > =

> > If we get an error trying to check the timeout, should we just keep
> > FIND_MULTIPATHS_WAIT_UNTIL the same? Or would it be better to set it
> > to
> > 0, and fail the smart claiming?
> =

> The latter is what we do. We set k=3D1 if find_multipaths_check_timeout()
> returns anything but FIND_MULTIPATHS_WAITING, resulting in
> DM_MULTIPATH_DEVICE_PATH=3D"0".

Oops.  I got confused here.

-Ben

> Regards
> Martin
> =

> -- =

> Dr. Martin Wilck <mwilck@suse.com>, Tel. +49 (0)911 74053 2107
> SUSE Linux GmbH, GF: Felix Imend=F6rffer, Jane Smithard, Graham Norton
> HRB 21284 (AG N=FCrnberg)
