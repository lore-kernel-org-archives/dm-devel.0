From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: Re: [RFC PATCH 05/20] libmultipath: don't update path
 groups when printing
Date: Wed, 28 Feb 2018 17:40:16 -0600
Message-ID: <20180228234016.GI14513@octiron.msp.redhat.com>
References: <20180220132658.22295-1-mwilck@suse.com>
	<20180220132658.22295-6-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20180220132658.22295-6-mwilck@suse.com>
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

On Tue, Feb 20, 2018 at 02:26:43PM +0100, Martin Wilck wrote:
> Updating the prio values for printing makes no sense. The user wants to see
> the prio values multipath is actually using for path group selection, and
> updating the values here means actually lying to the user if the prio values
> have changed, but multipathd hasn't updated them internally.
> 
> If we really don't update the pathgroup prios when we need to, this should be
> fixed elsewhere. The current wrong output would just hide that if it occured.
> 
> Moreover, correctness forbids changing properties so deeply in a code path
> that's supposed to print them only. Finally, this piece of code prevents the
> print.c code to be converted to proper "const" usage.

Well, it is true that we've only been updating the path group priority
when we've needed it, and we've only need it to be uptodate when we are
picking a new pathgroup, or are printing it out. When failback is set to
"manual", we rarely are picking a new pathgroup, so we rarely update the
pathgroup prio. 

If we really want to be honest with the user, we probably want to reload
the multipath device whenever a path group's priority changes enough to
make their order change.  Otherwise, the kernel will still failover to
the wrong path group.  We currently only do this for FAILBACK_IMMEDIATE,
and we don't even do that very well. For instance, we will currently
reorder pathgroups when their priority has gone to 0 because they have
no valid paths. In this case, we should expect that when the paths
return, they will most likely have the same priority as they previously
had. Thus, we shouldn't lower that path group's priority while they are
down, since it will just cause two pointless table reloads (one when the
last path in the group goes down, and another when the first path comes
back). But I digress.

I'd be fine with simply updating the path group priority whever we change a
path's priority, if we aren't updating it when printing it. The bigger
work of actually making sure that the path group order it the table
is always uptodate needs to happen, but it doesn't need to happen in
this patchset.

-Ben
> 
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  libmultipath/print.c | 7 -------
>  1 file changed, 7 deletions(-)
> 
> diff --git a/libmultipath/print.c b/libmultipath/print.c
> index 8fb5c5058965..b5c00bfe69a5 100644
> --- a/libmultipath/print.c
> +++ b/libmultipath/print.c
> @@ -484,13 +484,6 @@ snprint_pg_selector (char * buff, size_t len, struct pathgroup * pgp)
>  static int
>  snprint_pg_pri (char * buff, size_t len, struct pathgroup * pgp)
>  {
> -	/*
> -	 * path group priority is not updated for every path prio change,
> -	 * but only on switch group code path.
> -	 *
> -	 * Printing is another reason to update.
> -	 */
> -	path_group_prio_update(pgp);
>  	return snprint_int(buff, len, pgp->priority);
>  }
>  
> -- 
> 2.16.1
