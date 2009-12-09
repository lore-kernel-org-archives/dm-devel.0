From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH v3 0/4] dm-replicator: introduce new remote
 replication target
Date: Wed, 9 Dec 2009 14:14:51 -0500
Message-ID: <20091209191450.GA1968@redhat.com>
References: <1259683507-12455-1-git-send-email-heinzm@redhat.com>
	<20091201164142.GL19238@suse.de> <1259687919.9639.15.camel@o>
	<1260297747.4147.30.camel@mulgrave.site>
	<20091209103941.GA920@infradead.org>
	<1260382357.2532.201.camel@mulgrave.site>
	<20091209183830.GC30947@redhat.com>
	<1260384405.2532.218.camel@mulgrave.site>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1260384405.2532.218.camel@mulgrave.site>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: heinzm@redhat.com, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Wed, Dec 09 2009 at  1:46pm -0500,
James Bottomley <James.Bottomley@HansenPartnership.com> wrote:

> On Wed, 2009-12-09 at 13:38 -0500, Mike Snitzer wrote:
> > On Wed, Dec 09 2009 at  1:12pm -0500,
> > James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
> > 
> > > On Wed, 2009-12-09 at 05:39 -0500, Christoph Hellwig wrote:
> > > > On Tue, Dec 08, 2009 at 12:42:27PM -0600, James Bottomley wrote:
> > > > > Could I just echo Lars' statement.  With the upstream inclusion of drbd,
> > > > > dm-replicator becomes a *third* replication system asking to be in
> > > > > kernel.  It is definitely a kernel policy question of whether we want
> > > > > three separate replicators, and so should be Cc'd to lkml so that people
> > > > > interested in that can weigh in.
> > > > 
> > > > And unliley the previous two this one actually offers the benefit of
> > > > beeing integrated with our major block device management framework.
> > > 
> > > md/nbd *is* integrated with a major block management framework.  The
> > > fact that it's md not dm reflects the fact that it leverages the md
> > > raid1 framework to perform the replication and merely uses nbd as a
> > > remote block transmission pipe.  I'd submit this is the correct way to
> > > do things.
> > 
> > Yes and no...
> > 
> > As someone who producticized md+nbd for a previous proprietary employer
> > (standing on the shoulders of the work that was done by steeleye) I can
> > say that md+nbd can provide the core plumbing but you need quite a bit
> > of higher-level tools integration to make it _really_ approachable for
> > the enterprise.  command line and UI interface and backend DB to store
> > all relations, etc... And all sorts of nasty corner cases (e.g. split
> > brain and double failure scenarios) are left as an exercise to the
> > md+nbd user.
> 
> I didn't advocate using it as a framework ... I said it was done the
> right way (leveraging the existing RAID engines).  What's actually
> missing from it is the framework.
> 
> > > The problem now is that the md raid framework isn't integrated into dm,
> > > but I think someone else is looking at that ...
> > > 
> > > > Interesting that the question comes up now after I was shot down for it
> > > > in the drbd discussion.
> > > 
> > > So the value add of drbd over md/nbd is symmetric active.  I think that
> > > could be pulled into the md raid infrastructure as well, but someone has
> > > to figure out how.
> > 
> > md+nbd really isn't the way forward here IMHO..  if anything I think we
> > need to focus on melding drbd and dm-replicator into the DM framework.
> 
> Actually, I think we need to focus on the goal, which should be a single
> replication engine.  The problem with dm-replicator is that it brings
> yet another network RAID-1 engine to the table.  The benefit is that it
> does actually come with a framework.
> 
> The problem with network replicators is that they're hard to get right
> and very time consuming to debug and test.  Since we've already invested
> the correctness and testing effort twice over already (and it took
> several years in each case) doing it yet again looks to be a big waste
> to me.
> 
> > A single system management tool-chain and interface is increasingly
> > important in the enterprise.
> 
> So isn't the way forwards then to prototype using this framework to
> absorb both our existing in-kernel replicators?  A side bonus is that
> the logging framework should be extensible to md to verify we're getting
> it right.  If it's done correctly, it could even facilitate the eventual
> raid unification goal of pulling together md and dm ... which would be a
> huge benefit to the enterprise.

Sure, I'd say we're in [violent] agreement on the way forward.

But the buy-off from others (Heinz, drbd devs, Neil B, etc) and the
strategy for when/how to phase this integration work is better for
others to say.

Mike
