From: Martin Wilck <mwilck@suse.de>
Subject: Re: [PATCH 9/9] multipathd: use update_path_groups
 instead of reload_map
Date: Wed, 27 Feb 2019 11:22:49 +0100
Message-ID: <7cc551541a83935fe9567c08a635ed624a30b677.camel@suse.de>
References: <1550854692-19873-1-git-send-email-bmarzins@redhat.com>
	<1550854692-19873-10-git-send-email-bmarzins@redhat.com>
	<15f01e8c1ed5f85acea4d4dc7be953c321eccda7.camel@suse.de>
	<20190226223228.GN3023@octiron.msp.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20190226223228.GN3023@octiron.msp.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: development <dm-devel@redhat.com>, device-mapper
List-Id: dm-devel.ids

On Tue, 2019-02-26 at 16:32 -0600, Benjamin Marzinski wrote:
> On Tue, Feb 26, 2019 at 11:47:29AM +0100, Martin Wilck wrote:
> > On Fri, 2019-02-22 at 10:58 -0600, Benjamin Marzinski wrote:
> > > reload_map() doesn't do the work to sync the state after
> > > reloading
> > > the
> > > map.  Instead of calling it directly, cli_reload() and
> > > uev_update_path()
> > > should call update_path_groups(), which calls reload_map() with
> > > all
> > > the
> > > necessary syncing.
> > > 
> > > Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> > > ---
> > >  multipathd/cli_handlers.c |  2 +-
> > >  multipathd/main.c         | 13 ++++++++-----
> > >  multipathd/main.h         |  2 ++
> > >  3 files changed, 11 insertions(+), 6 deletions(-)
> > 
> > I can see that this makes some sense for the cli_reload() path (see
> > below). But for uev_update_path(), I'm not sure. This is the code
> > path
> > where a paths's "ro" attribute changes. With this change, you'll
> > call
> > update_multipath_strings() for every uevent that arrives, causing a
> > lot
> > of extra work on every uevent. This may hurt, in particular if lots
> > of
> > uevents arrive at the same time. I fail to see what you gain by
> > doing
> > the extra work. If path states change, either dm events or uevents
> > for
> > the other paths in the map will likely arrive soon and cause the
> > other
> > path's states to be fixed, or check_path() will detect the state
> > changes and fix the DM states eventually. No?
> 
> Fair enough. The one issue is that whenever we reload a map, all path
> states in the kernel are reset to active. We need to call
> sync_map_state() to reset them to the correct state.

Right. That was the point I missed, then. You convinced me. So:

Reviewed-by: Martin Wilck <mwilck@suse.com>

I assume you'll resend the series because of 7/9.

>   Obviously, an
> dm event will come in soonish, but if there is a backlog of stuff for
> multipathd to do, those down paths might be reactivated for a while
> before we get that. And if the kernel uses them, it will fail them
> and
> generate even more events for multipathd to deal with.
> 
> Also, we wouldn't call update_path_groups() in uev_update_path() very
> often. Every time that we do, you will see this message
> 
> condlog(2, "%s: update path write_protect to '%d' (uevent)",
> uev->kernel, ro);
> 
> That certainly doesn't happen on every change event for a path.
> right?

Sure, this is only the "DISK_RO=1" path which is rarely executed.

I have a general issue with the fact that the handling of path uevents
may cause lots of redundant actions in multipathd, but it's unrelated
to your patch.

> > For cli_reload() it'd actually be the question if we should re-
> > calculate priorities and path groups in multipathd before calling
> > update_path_groups() / reload_map().
> 

Correcting myself: Reviewing code history, cli_reload() has never done
this ("refresh" parameter to reload_map() was always 0), so changing
that behavior would require a broader discussion.

> Sure.  This isn't a horribly important patch. It isn't fixing any
> issue
> that I've seen. I just noticed that these are the only code paths I
> could see were we reload the map, but don't call setup_multipath()
> and
> sync_map_state(), to make sure all the states are in sync.

Here's a nitpick: if we replace all calls of reload_map() by
update_path_groups(), we might as well pull the functionality of
update_path_groups() into reload_map() altogether. I'd prefer that,
because the function name reload_map() is more descriptive of what the
code actually does.

And while we're at it: the "refresh" parameter of reload_map() (telling
wherer path priorities should be updated) is only set when called via
check_path() / update_path_groups(), in the (!new_path_up) case
(because if new_path_up is set, priorities have already been updated).
Code readability would be improved by pulling the prio update code into
check_path(), and removing the refresh parameter from reload_map().

But both of these nits are future work. No need to add this into the
current patch set.

Best,
Martin
