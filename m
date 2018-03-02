From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: Re: [RFC PATCH 19/20] multipathd: use foreign API
Date: Fri, 2 Mar 2018 12:42:49 -0600
Message-ID: <20180302184249.GG14513@octiron.msp.redhat.com>
References: <20180220132658.22295-1-mwilck@suse.com>
	<20180220132658.22295-20-mwilck@suse.com>
	<20180301051306.GO14513@octiron.msp.redhat.com>
	<1520010269.4169.80.camel@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1520010269.4169.80.camel@suse.com>
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

On Fri, Mar 02, 2018 at 06:04:29PM +0100, Martin Wilck wrote:
> On Wed, 2018-02-28 at 23:13 -0600, Benjamin Marzinski wrote:
> > On Tue, Feb 20, 2018 at 02:26:57PM +0100, Martin Wilck wrote:
> > > Call into the foreign library code when paths are discovered,
> > > uevents
> > > are received, and in the checker loop. Furthermore, use the foreign
> > > code to print information in the "multipathd show paths",
> > > "multipathd
> > > show maps", and "multipathd show topology" client commands.
> > > =

> > > We don't support foreign data in the individual "show map" and
> > > "show path"
> > > commands, and neither in the "json" commands. The former is a
> > > deliberate
> > > decision, the latter could be added if desired.
> > > =

> > > Signed-off-by: Martin Wilck <mwilck@suse.com>
> > > ---
> > >  libmultipath/discovery.c  |  4 +++-
> > >  multipathd/cli_handlers.c | 39 ++++++++++++++++++++++++++++++++++-
> > > ----
> > >  multipathd/main.c         | 43
> > > ++++++++++++++++++++++++++++++++++++++++---
> > >  3 files changed, 77 insertions(+), 9 deletions(-)
> > > =

> > > diff --git a/multipathd/main.c b/multipathd/main.c
> > > index b900bb3ec2e3..e1d98861a841 100644
> > > --- a/multipathd/main.c
> > > +++ b/multipathd/main.c
> > > @@ -84,6 +84,7 @@ static int use_watchdog;
> > >  #include "waiter.h"
> > >  #include "io_err_stat.h"
> > >  #include "wwids.h"
> > > +#include "foreign.h"
> > >  #include "../third-party/valgrind/drd.h"
> > >  =

> > >  #define FILE_NAME_SIZE 256
> > > @@ -699,6 +700,15 @@ rescan:
> > >  		mpp->action =3D ACT_RELOAD;
> > >  		extract_hwe_from_path(mpp);
> > >  	} else {
> > > +		switch (add_foreign(pp->udev)) {
> > =

> > There's a rather convoluted issue here. This function will eventually
> > call _find_slaves() in the nvme code, which calls glob(), which isn't
> > strictly multithreading safe for a number of reasons. The only one
> > that
> > effects multipathd is its use of SIGALRM. Now assuming signal
> > processing
> > worked correctly in multipathd (it doesn't. commit 534ec4c broke it.
> > I'm
> > planning on fixing that shortly) there would still be a problem,
> > because
> > of the strict_timing option.  strict_timing calls setitimer(), which
> > sets an alarm in checkerloop, without any locking.  strict_timing
> > also
> > messes with any call to lock_file(). lock_file() and _find_slaves()
> > will
> > never interfere with eachother, since both are only called with the
> > vecs
> > lock held (I think. See below). strict_timing probably needs to get
> > reimplemented using nanosleep() or some other non-signal method, so
> > that
> > there aren't two threads setting alarms and waiting for SIGARLM at
> > the
> > same time.
> =

> Thanks for spotting this. It was lazyness on my side to use glob(). I
> will reimplement this using safer, more elementary functions. =


Sure. But lock_file() already needs this fixed to work correctly, and
once it is, I don't see a problem calling glob() here.
 =

> > =

> > > +		case FOREIGN_CLAIMED:
> > > +		case FOREIGN_OK:
> > > +			orphan_path(pp, "claimed by foreign
> > > library");
> > > +			return 0;
> > > +		default:
> > > +			break;
> > =

> > Is there a purpose to this break?
> =

> I thought this was common style. You find it the kernel's CodingStyle
> document, too. I have no issues with removing it if you insist.

I didn't realize that. I'm fine with keeping it. It's not confusing. I
just thought it was an accident.

> > > 	conf =3D get_multipath_config();
> > >  	disable_changed_wwids =3D conf->disable_changed_wwids;
> > >  	put_multipath_config(conf);
> > > @@ -1122,8 +1149,13 @@ uev_trigger (struct uevent * uev, void *
> > > trigger_data)
> > >  	 * are not fully initialised then.
> > >  	 */
> > >  	if (!strncmp(uev->kernel, "dm-", 3)) {
> > > -		if (!uevent_is_mpath(uev))
> > > +		if (!uevent_is_mpath(uev)) {
> > > +			if (!strncmp(uev->action, "change", 6))
> > > +				(void)add_foreign(uev->udev);
> > > +			else if (!strncmp(uev->action, "remove",
> > > 6))
> > > +				(void)delete_foreign(uev->udev);
> > >  			goto out;
> > > +		}
> > =

> > I'm confused. Should foreign maps ever have uev->kernel set to "dm-"?
> =

> Although I don't see a likely candidate, I didn't want to exclude it in
> general.
> =

> > If this is correct, these calls probably need to get called with the
> > vecs lock held, otherwise they can interfere with calls to
> > lock_file().
> =

> Please explain. These devices are ignored by multipath-tools, because
> !uevent_is_mpath(uev), so they won't be part of any of their data
> structures. And lock_file() is only about fcntl, what does it have to
> do with this code? =


add_foreign will eventually call glob().  Like I said above, as long as
all the functions that use SIGALRM are restricted from being called at
the same time, they can't mess with each other's timeout, and everything
is fine. But if you call add_foreign here without holding the vecs lock,
then there would be nothing to keep it and lock_file() from being called
at the same time. This is yet another example of the headache involved
in removing the vecs lock.  It is protecting a lot of stuff that's
really easy to overlook (I'm not saying that's a good thing.. Just that
it's a thing).

-Ben

> Regards,
> Martin
> =

> -- =

> Dr. Martin Wilck <mwilck@suse.com>, Tel. +49 (0)911 74053 2107
> SUSE Linux GmbH, GF: Felix Imend=F6rffer, Jane Smithard, Graham Norton
> HRB 21284 (AG N=FCrnberg)
