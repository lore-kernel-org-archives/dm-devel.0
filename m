From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: convert dm-thin to use dm-bufio
Date: Fri, 19 Aug 2011 09:49:21 -0400
Message-ID: <20110819134921.GB1335@redhat.com>
References: <20110815090416.GE3159@ubuntu>
	<Pine.LNX.4.64.1108151316300.18170@hs20-bc2-1.build.redhat.com>
	<20110816091600.GA4284@ubuntu>
	<Pine.LNX.4.64.1108161755510.15859@hs20-bc2-1.build.redhat.com>
	<20110817082656.GA3267@ubuntu>
	<Pine.LNX.4.64.1108181830050.7668@hs20-bc2-1.build.redhat.com>
	<20110819070435.GA32300@redhat.com> <20110819091106.GA3193@ubuntu>
	<20110819094604.GA1059@redhat.com> <20110819102215.GA5069@ubuntu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20110819102215.GA5069@ubuntu>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Joe Thornber <thornber@redhat.com>
Cc: dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>, "Alasdair G. Kergon" <agk@redhat.com>
List-Id: dm-devel.ids

On Fri, Aug 19 2011 at  6:22am -0400,
Joe Thornber <thornber@redhat.com> wrote:

> On Fri, Aug 19, 2011 at 05:46:04AM -0400, Mike Snitzer wrote:
> > On Fri, Aug 19 2011 at  5:11am -0400,
> > Joe Thornber <thornber@redhat.com> wrote:
> > 
> > > On Fri, Aug 19, 2011 at 03:04:36AM -0400, Mike Snitzer wrote:
> > > > Question for Joe:
> > > > You're making conflicting changes quick enough that I wonder if you
> > > > and Mikulas will ever converge (e.g. why do multiple block managers need
> > > > to have access to the same metadata device!?).
> > > 
> > > They don't; my issue is with getting an oops if they do through user
> > > error.  I clearly said in the commit message that this was a hack to
> > > get round issues introduced by agk's move to a kmemcache.  Cook
> > > something cleaner up between yourselves, or wait for me to look at it
> > > again once I've got through some more pressing issues.
> > 
> > OK, so this kmemcache problem will go away once you switch over to
> > bufio.
> 
> Assuming agk doesn't decide to switch over to a kmemcache.  Remember
> bm used to allocate via kmalloc or pages like bufio.

Indeed.
 
> > As for stacking, can't we just read the superblock to check if a device
> > is already in use (would work metadata anyway)?  No idea if that'd be
> > too costly -- probably not: read superblock and check if
> > THIN_SUPERBLOCK_MAGIC is set.
> 
> So you've already thought of a scenario where it's worth having two bm
> instances (one read only).

I didn't realize it but excellent point.
