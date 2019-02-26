From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: Re: [PATCH 8/9] libmutipath: continue to use old state
 on PATH_PENDING
Date: Tue, 26 Feb 2019 14:37:35 -0600
Message-ID: <20190226203735.GM3023@octiron.msp.redhat.com>
References: <1550854692-19873-1-git-send-email-bmarzins@redhat.com>
	<1550854692-19873-9-git-send-email-bmarzins@redhat.com>
	<308cf00c2437770c538a8c35717eb9dfdafe60ec.camel@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <308cf00c2437770c538a8c35717eb9dfdafe60ec.camel@suse.de>
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

On Tue, Feb 26, 2019 at 11:12:47AM +0100, Martin Wilck wrote:
> On Fri, 2019-02-22 at 10:58 -0600, Benjamin Marzinski wrote:
> > When pathinfo() sets pp->state to PATH_PENDING, it can cause problems
> > with path checking.  It should act more like check_path(). When
> > check_path() sees a new state of PATH_PENDING, it doesn't update the
> > path state at all, so a path's old state is normally never
> > PATH_PENDING.
> > 
> > As and example of the problems of setting a path to PATH_PENDING, If
> > check_path() sets a path's state to PATH_UP, then a call to
> > pathinfo()
> > sets the state to PATH_PENDING, and then another call the
> > check_path()
> > sets the state to PATH_DOWN, multipathd won't fail the path in the
> > kernel. 
> 
> I can see what you mean, but I'm unsure how this example would come to
> pass in practice (AFAICS, pathinfo(DI_CHECKER) is only called during
> path discovery / reconfigure(), or when new paths are detected /
> added).
> 

This can happen when you add or remove paths, if something goes wrong
and you don't actually do the reload. For instance, if you call
ev_add_path(), it calls adopt_paths(). If adopt_paths() fails, some of
the paths may have had their state updated by a call to pathinfo().

> > Also, if a path's state is PATH_PENDING, and nr_active is
> > recalculated, that path will count as down, even if the state was
> > previously PATH_UP.
> 
> Ah, this is how you deal with what I remarked on the second hunk of
> patch 6/9. This is smart.
> 
> >  If a path already has a state of PATH_WILD or
> > PATH_UNCHECKED, changing it to PATH_PENDING won't hurt anything, and
> > it
> > will help anyone who sees it know what's actually happening. But
> > otherwise, pathinfo() should leave the previous state alone.
> > 
> > Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> > ---
> >  libmultipath/discovery.c | 7 +++++--
> >  1 file changed, 5 insertions(+), 2 deletions(-)
> 
> My gut feeling is that we should distinguish between the case where
> PATH_PENDING is set in path_offline() (sysfs state "quiesce",
> "blocked", "pending" etc.), and the case where the async checker is
> simply not finished yet. The first case does tell us something about
> the path (being temporarily inaccessible), whereas the second basically
> just says that we're ignorant.
> 
> Anyway, that's future work, so:
> 
> Reviewed-by: Martin Wilck <mwilck@suse.com>
> 
> 
> 
> > 
> > diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
> > index 729bcb9..d3585f9 100644
> > --- a/libmultipath/discovery.c
> > +++ b/libmultipath/discovery.c
> > @@ -1946,8 +1946,11 @@ int pathinfo(struct path *pp, struct config
> > *conf, int mask)
> >  
> >  	if (mask & DI_CHECKER) {
> >  		if (path_state == PATH_UP) {
> > -			pp->chkrstate = pp->state = get_state(pp, conf,
> > 0,
> > -							      path_stat
> > e);
> > +			int newstate = get_state(pp, conf, 0,
> > path_state);
> > +			if (newstate != PATH_PENDING ||
> > +			    pp->state == PATH_UNCHECKED ||
> > +			    pp->state == PATH_WILD)
> > +				pp->chkrstate = pp->state = newstate;
> >  			if (pp->state == PATH_TIMEOUT)
> >  				pp->state = PATH_DOWN;
> >  			if (pp->state == PATH_UP && !pp->size) {
> 
