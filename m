From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: Re: [PATCH 9/9] multipathd: use update_path_groups
 instead of reload_map
Date: Tue, 26 Feb 2019 16:32:28 -0600
Message-ID: <20190226223228.GN3023@octiron.msp.redhat.com>
References: <1550854692-19873-1-git-send-email-bmarzins@redhat.com>
	<1550854692-19873-10-git-send-email-bmarzins@redhat.com>
	<15f01e8c1ed5f85acea4d4dc7be953c321eccda7.camel@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <15f01e8c1ed5f85acea4d4dc7be953c321eccda7.camel@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Martin Wilck <mwilck@suse.de>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Tue, Feb 26, 2019 at 11:47:29AM +0100, Martin Wilck wrote:
> On Fri, 2019-02-22 at 10:58 -0600, Benjamin Marzinski wrote:
> > reload_map() doesn't do the work to sync the state after reloading
> > the
> > map.  Instead of calling it directly, cli_reload() and
> > uev_update_path()
> > should call update_path_groups(), which calls reload_map() with all
> > the
> > necessary syncing.
> > 
> > Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> > ---
> >  multipathd/cli_handlers.c |  2 +-
> >  multipathd/main.c         | 13 ++++++++-----
> >  multipathd/main.h         |  2 ++
> >  3 files changed, 11 insertions(+), 6 deletions(-)
> 
> I can see that this makes some sense for the cli_reload() path (see
> below). But for uev_update_path(), I'm not sure. This is the code path
> where a paths's "ro" attribute changes. With this change, you'll call
> update_multipath_strings() for every uevent that arrives, causing a lot
> of extra work on every uevent. This may hurt, in particular if lots of
> uevents arrive at the same time. I fail to see what you gain by doing
> the extra work. If path states change, either dm events or uevents for
> the other paths in the map will likely arrive soon and cause the other
> path's states to be fixed, or check_path() will detect the state
> changes and fix the DM states eventually. No?

Fair enough. The one issue is that whenever we reload a map, all path
states in the kernel are reset to active. We need to call
sync_map_state() to reset them to the correct state.  Obviously, an
dm event will come in soonish, but if there is a backlog of stuff for
multipathd to do, those down paths might be reactivated for a while
before we get that. And if the kernel uses them, it will fail them and
generate even more events for multipathd to deal with.

Also, we wouldn't call update_path_groups() in uev_update_path() very
often. Every time that we do, you will see this message

condlog(2, "%s: update path write_protect to '%d' (uevent)",
uev->kernel, ro);

That certainly doesn't happen on every change event for a path. right?

 
> For cli_reload() it'd actually be the question if we should re-
> calculate priorities and path groups in multipathd before calling
> update_path_groups() / reload_map().

Sure.  This isn't a horribly important patch. It isn't fixing any issue
that I've seen. I just noticed that these are the only code paths I
could see were we reload the map, but don't call setup_multipath() and
sync_map_state(), to make sure all the states are in sync.

> Regards,
> Martin
> 
> 
> 
> > 
> > diff --git a/multipathd/cli_handlers.c b/multipathd/cli_handlers.c
> > index f95813e..60e17d6 100644
> > --- a/multipathd/cli_handlers.c
> > +++ b/multipathd/cli_handlers.c
> > @@ -877,7 +877,7 @@ cli_reload(void *v, char **reply, int *len, void
> > *data)
> >  		return 1;
> >  	}
> >  
> > -	return reload_map(vecs, mpp, 0, 1);
> > +	return update_path_groups(mpp, vecs, 0);
> >  }
> >  
> >  int resize_map(struct multipath *mpp, unsigned long long size,
> > diff --git a/multipathd/main.c b/multipathd/main.c
> > index 81ad6c0..27ff186 100644
> > --- a/multipathd/main.c
> > +++ b/multipathd/main.c
> > @@ -1272,10 +1272,13 @@ uev_update_path (struct uevent *uev, struct
> > vectors * vecs)
> >  			else {
> >  				if (ro == 1)
> >  					pp->mpp->force_readonly = 1;
> > -				retval = reload_map(vecs, mpp, 0, 1);
> > -				pp->mpp->force_readonly = 0;
> > -				condlog(2, "%s: map %s reloaded (retval
> > %d)",
> > -					uev->kernel, mpp->alias,
> > retval);
> > +				retval = update_path_groups(mpp, vecs,
> > 0);
> > +				if (retval == 2)
> > +					condlog(2, "%s: map removed
> > during reload", pp->dev);
> > +				else {
> > +					pp->mpp->force_readonly = 0;
> > +					condlog(2, "%s: map %s reloaded
> > (retval %d)", uev->kernel, mpp->alias, retval);
> > +				}
> >  			}
> >  		}
> >  	}
> > @@ -1831,7 +1834,7 @@ int update_path_groups(struct multipath *mpp,
> > struct vectors *vecs, int refresh)
> >  
> >  	dm_lib_release();
> >  	if (setup_multipath(vecs, mpp) != 0)
> > -		return 1;
> > +		return 2;
> >  	sync_map_state(mpp);
> >  
> >  	return 0;
> > diff --git a/multipathd/main.h b/multipathd/main.h
> > index 8fd426b..e5c1398 100644
> > --- a/multipathd/main.h
> > +++ b/multipathd/main.h
> > @@ -43,5 +43,7 @@ int __setup_multipath (struct vectors * vecs,
> > struct multipath * mpp,
> >  		       int reset);
> >  #define setup_multipath(vecs, mpp) __setup_multipath(vecs, mpp, 1)
> >  int update_multipath (struct vectors *vecs, char *mapname, int
> > reset);
> > +int update_path_groups(struct multipath *mpp, struct vectors *vecs,
> > +		       int refresh);
> >  
> >  #endif /* MAIN_H */
> 
