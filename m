From: Martin Wilck <mwilck@suse.de>
Subject: Re: [PATCH 6/9] multipathd: Fix miscounting active paths
Date: Tue, 26 Feb 2019 11:16:16 +0100
Message-ID: <dc5cd0d638eb7c0bc1c7aa3a909b04591da502ac.camel@suse.de>
References: <1550854692-19873-1-git-send-email-bmarzins@redhat.com>
	<1550854692-19873-7-git-send-email-bmarzins@redhat.com>
	<5b1f0b54b1e025ca69304984df8ca9eec1eea14c.camel@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <5b1f0b54b1e025ca69304984df8ca9eec1eea14c.camel@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Tue, 2019-02-26 at 10:15 +0100, Martin Wilck wrote:
> On Fri, 2019-02-22 at 10:58 -0600, Benjamin Marzinski wrote:
> > When multipathd gets a change uevent, it calls pathinfo with
> > DI_NOIO.
> > This sets the path state to the return value of path_offline(). If
> > a
> > path is in the PATH_DOWN state but path_offline() returns PATH_UP,
> > when
> > that path gets a change event, its state will get moved to PATH_UP
> > without either reinstating the path, or reloading the map.  The
> > next
> > call to check_path() will move the path back to PATH_DOWN. Since
> > check_path() simply increments and decrements nr_active instead of
> > calculating it based on the actual number of active paths,
> > nr_active
> > will get decremented a second time for this failed path,
> > potentially
> > putting the multipath device into recovery mode.
> > 
> > This commit does two things to avoid this situation. It makes the
> > DI_NOIO flag only set pp->state in pathinfo() if DI_CHECKER is also
> > set.
> > This isn't set in uev_update_path() to avoid changing the path
> > state
> > in
> > this case.  Also, to guard against pp->state getting changed in
> > some
> > other code path without properly updating the map state,
> > check_path()
> > now calls set_no_path_retry, which recalculates nr_active based on
> > the
> > actual number of active paths, and makes sure that the
> > queue_if_no_path
> > value in the features line is correct.
> > 
> > Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> > ---
> >  libmultipath/discovery.c | 11 ++++++-----
> >  multipath/main.c         |  2 +-
> >  multipathd/main.c        |  4 +++-
> >  3 files changed, 10 insertions(+), 7 deletions(-)
> 
> Thanks a lot for catching this! I was just hunting down a similar
> problem. You may have saved me lots of hair-pulling.
> 
> While I'm excited abouot the first hunk, I'm a bit unsure about the
> second one. I like the general idea (I'd be happy to do away with the
> "blind" incrementing and decrementing of nr_active), but I see a
> problem with PATH_PENDING paths, along the lines of thought layed out
> in commit adf551f "setup_map: wait for pending path checkers to
> finish". By counting only PATH_UP and PATH_GHOST in check_path(), we
> are very likely to falsely regard some pending paths as "inactive"
> just
> because their checker hasn't completed within a millisecond.
> Consequently, we may falsely set a map to queuing (or worse, failing)
> mode just because a few path checkers are still pending.
> 
> So for the time being, I'd rather apply the first hunk only. If we
> still see multipathd's internal nr_active deviating from the real
> situation, we need to put in some debugging code to find out where it
> diverges.
> 
> In the long run, IMO we should separate the "queueing mode" logic
> (which is map-related) from check_path() (which is path-related). We
> should check all paths of a given map, and when we're done, decide
> upon
> the queuing mode. PATH_PENDING will still need some extra thought.

After having reviewed patch 8/9 of this series ("libmutipath: continue
to use old state on PATH_PENDING"), I see this differently now. The
last paragraph of my first assessment is still worth consideration, but
only as future work.

Reviewed-by: Martin Wilck <mwilck@suse.com>
