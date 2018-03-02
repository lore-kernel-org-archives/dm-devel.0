From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: Re: [RFC PATCH 05/20] libmultipath: don't update path
 groups when printing
Date: Fri, 2 Mar 2018 09:31:57 -0600
Message-ID: <20180302153157.GD14513@octiron.msp.redhat.com>
References: <20180220132658.22295-1-mwilck@suse.com>
	<20180220132658.22295-6-mwilck@suse.com>
	<20180228234016.GI14513@octiron.msp.redhat.com>
	<1519999180.4169.60.camel@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1519999180.4169.60.camel@suse.com>
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

On Fri, Mar 02, 2018 at 02:59:40PM +0100, Martin Wilck wrote:
> On Wed, 2018-02-28 at 17:40 -0600, Benjamin Marzinski wrote:
> > On Tue, Feb 20, 2018 at 02:26:43PM +0100, Martin Wilck wrote:
> >
> > I'd be fine with simply updating the path group priority whever we
> > change a
> > path's priority, if we aren't updating it when printing it. The
> > bigger
> > work of actually making sure that the path group order it the table
> > is always uptodate needs to happen, but it doesn't need to happen in
> > this patchset.
> =

> I just reviewed the code flow in check_path(), and here's what I see:
> =

> 1. calls update_prio(pp, new_path_up)
>    -> updates path's prio, or all paths' prios if the path was
>       reinstated
> =

> Now it calls either
> =

> 2a. update_path_groups() (for group_by_prio and failback immediate)
>   (-> reload_map() -> setup_map() -> select_path_group()
>   -> path_group_prio_update()), or
>   =

> 2b. need_switch_pathgroup() (otherwise)
>   =

> So all we need to make sure is that need_switch_pathgroup() calls =

> select_path_group(). It does that already, except for the "failback
> manual" case.
> =

> So all we need is IMO the attached patch. Tell me what you think.
> =

> [All of the above is only called if (!mpp->wait_for_udev), but if
> wait_for_udev is set, either when the event arrives or the wait times
> out, we'll call reconfigure() which makes sure all priorities are
> correct].

looks good.

Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>

I haven't looked through the code for them, but I think there are case
where we zero out a path's or pathgroup's priority, simply because it is
down.  It looks weird when all the failed paths get lumped together in
one path group, or when the high priority path group suddenly stops
being listed as high priority.  Obviously, this gets fixed as soon as
the paths come back online, so no harm is done, but it seems like
multipathd is doing a bunch of busy-work, just to make the output less
clear.

I realize there isn't an obvious and simple answer here, because
sometimes when all the paths in a pathgroup fail, and you switch
pathgroups, you really do change the priority of paths, which gets
updated in the still-working ones.  This means that if you leave the
priorities of the failed paths as they were, you can still get incorrect
groupings. But, like I said, all this has nothing to do with your
current patchset.
 =

> Best,
> Martin
> =

> -- =

> Dr. Martin Wilck <mwilck@suse.com>, Tel. +49 (0)911 74053 2107
> SUSE Linux GmbH, GF: Felix Imend=F6rffer, Jane Smithard, Graham Norton
> HRB 21284 (AG N=FCrnberg)

> From 149f4458d138d504ee5947aaa6e38d134b21368a Mon Sep 17 00:00:00 2001
> From: Martin Wilck <mwilck@suse.com>
> Date: Fri, 2 Mar 2018 14:51:52 +0100
> Subject: [PATCH] multipathd: update path group prio in check_path
> =

> The previous patch "libmultipath: don't update path groups when printing"
> removed the call to path_group_prio_update() in the printing code path.
> To compensate for that, recalculate path group prio also when it's not
> strictly necessary (i.e. if failback "manual" is set).
> =

> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  multipathd/main.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> =

> diff --git a/multipathd/main.c b/multipathd/main.c
> index e1d98861a841..61739ac6ea59 100644
> --- a/multipathd/main.c
> +++ b/multipathd/main.c
> @@ -252,8 +252,9 @@ need_switch_pathgroup (struct multipath * mpp, int re=
fresh)
>  	struct path * pp;
>  	unsigned int i, j;
>  	struct config *conf;
> +	int bestpg;
>  =

> -	if (!mpp || mpp->pgfailback =3D=3D -FAILBACK_MANUAL)
> +	if (!mpp)
>  		return 0;
>  =

>  	/*
> @@ -272,8 +273,11 @@ need_switch_pathgroup (struct multipath * mpp, int r=
efresh)
>  	if (!mpp->pg || VECTOR_SIZE(mpp->paths) =3D=3D 0)
>  		return 0;
>  =

> -	mpp->bestpg =3D select_path_group(mpp);
> +	bestpg =3D select_path_group(mpp);
> +	if (mpp->pgfailback =3D=3D -FAILBACK_MANUAL)
> +		return 0;
>  =

> +	mpp->bestpg =3D bestpg;
>  	if (mpp->bestpg !=3D mpp->nextpg)
>  		return 1;
>  =

> -- =

> 2.16.1
> =
