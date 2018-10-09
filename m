From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: Re: [PATCH v3 18/19] libmultipath: Don't blank
 intialized paths
Date: Tue, 9 Oct 2018 17:20:01 -0500
Message-ID: <20181009222001.GJ3172@octiron.msp.redhat.com>
References: <1537571127-10143-1-git-send-email-bmarzins@redhat.com>
	<1537571127-10143-19-git-send-email-bmarzins@redhat.com>
	<3bb1c108b1e43a85d296eed9a63cefe7a6de2d01.camel@suse.com>
	<f87221ecedb072a7f3551ea0f62e7df586d075f1.camel@suse.com>
	<20181005193843.GF3172@octiron.msp.redhat.com>
	<e5fd9aaf1014224d4ce65f77b3bdbfea362c01a9.camel@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <e5fd9aaf1014224d4ce65f77b3bdbfea362c01a9.camel@suse.com>
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

On Mon, Oct 08, 2018 at 11:41:35AM +0200, Martin Wilck wrote:
> On Fri, 2018-10-05 at 14:38 -0500,  Benjamin Marzinski  wrote:
> > On Wed, Oct 03, 2018 at 12:37:17AM +0200, Martin Wilck wrote:

 =

> > Your analysis looks right. This shouldn't have anything to do with
> > the
> > correctness of the not blanking initialized paths, but we should fix
> > it
> > anyway.  Right now, as you mentioned, if multipathd fails to get the
> > wwid after retrigger_tries new uevents, it only has one shot at the
> > failback methods, and then mutipathd cannot use that path in the
> > future.
> > However, it will still check if the path is up or down, which is
> > pretty
> > pointless. It should either
> > =

> > 1. set pp->intialized to INIT_OK, to keep it from being checked at
> > all
> > in the future, or
> =

> That would be lying to ourselves. I'd rather call it INIT_BROKEN or so,
> or maybe even delete the path from pathvec altogether.
> =

> [ While we're at this: we call pathinfo with DI_ALL from =

> configure->path_discovery(), but with DI_ALL|DI_BLACKLIST from
> uev_add_path(). As a result, paths discovered in uevents won't be added
> to pathvec in the first place if they're blacklisted, while blacklisted
> paths discovered at startup will be in the pathvec, but orphaned. Is
> that intentional, and if yes, why ? ]

I really don't know why configure() works this way. The call to
filter_path() just after path_discovery() will remove the blacklisted
paths, so they won't actually end up in the pathvec. But it does seem
pretty pointless to not just check if they are blacklisted while
initializing them.

> > 2. try to grab the missing pathinfo, so that it can use the path.
> > =

> > The benefit of doing the first is that mutipathd doesn't keep messing
> > with paths that really aren't set up to be multipathed. On the other
> > hand it might ignore some paths that really should be multipathed.
> > perhaps the best idea is to keep trying to get the missing info, but
> > just increase pp->tick (possibly progressively) so we try less often.
> =

> The latter sounds overly complex to me, in particular as in the daemon,
> we're only looking at paths retrieved via udev anyway, as you pointed
> out in your other post. So perhaps INIT_MISSING_UDEV is just about the
> right state for this. We may just consider changing uev_update_path()
> such that the path is passed to uev_add_path() not only for
> INIT_REQUESTED_UDEV, but also for INIT_MISSING_UDEV state.

The thought behind not just using uev_update_path() is that it doesn't
get called very predicably. There's a chance that the path may become
usable, but we won't get any event for it.  There's also a chance that a
path that will never have a wwid (and thus shouldn't be multipathed)
will be part of a uevent storm, and multipath will do a bunch of
pointless work.  If we do the checks in the checkerloop(), we can
control exactly how often we check these paths.
 =

> =

> Summarizing, =

> =

>  a) you convinced me about that one,
>  b) your patch is good, but we may need additional changes in a follow-
> up patch,
>  c) doesn't happen,
>  d) I agreed in the first place.
> =

> And my concern about INIT_MISSING_UDEV was orthogonal to your patch
> anyway. So I'll give your patch a reviewed-by. Sorry for the noise. I
> guess you'll concede the handling of path states in multipath-tools is
> non-trivial. =


Sure. We do need to figure out what to do when we really can't get a
wwid for the device, but that can happen in a different patchset.

-Ben
 =

> Martin
> =

> -- =

> Dr. Martin Wilck <mwilck@suse.com>, Tel. +49 (0)911 74053 2107
> SUSE Linux GmbH, GF: Felix Imend=F6rffer, Jane Smithard, Graham Norton
> HRB 21284 (AG N=FCrnberg)
> =
