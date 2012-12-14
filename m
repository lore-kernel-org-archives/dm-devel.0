From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: Another cache target
Date: Thu, 13 Dec 2012 23:23:30 -0500
Message-ID: <20121214042330.GA30180@redhat.com>
References: <1355429956-22785-1-git-send-email-ejt@redhat.com>
	<20121213215715.GA19419@redhat.com>
	<20121214011643.GB9845@blackbox.djwong.org>
	<20121214021918.GA29561@redhat.com>
	<20121214022702.GB29561@redhat.com>
	<20121214024231.GH9453@blackbox.djwong.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20121214024231.GH9453@blackbox.djwong.org>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: device-mapper development <dm-devel@redhat.com>, Joe Thornber <ejt@redhat.com>
List-Id: dm-devel.ids

On Thu, Dec 13 2012 at  9:42pm -0500,
Darrick J. Wong <darrick.wong@oracle.com> wrote:

> On Thu, Dec 13, 2012 at 09:27:02PM -0500, Mike Snitzer wrote:
> > On Thu, Dec 13 2012 at  9:19pm -0500,
> > Mike Snitzer <snitzer@redhat.com> wrote:
> > 
> > > On Thu, Dec 13 2012 at  8:16pm -0500,
> > > Darrick J. Wong <darrick.wong@oracle.com> wrote:
> > > 
> > > > On Thu, Dec 13, 2012 at 04:57:15PM -0500, Mike Snitzer wrote:
> > > > > 
> > > > > agk's patches are here:
> > > > > http://people.redhat.com/agk/patches/linux/editing/series.html
> > > > > 
> > > > > But agk hasn't staged all the required patches yet.  I've imported agk's
> > > > > editing tree (and a couple other required patches that I previously
> > > > > posted to dm-devel, which aren't yet in agk's tree) into the
> > > > > 'dm-for-3.8' branch on my github tree here:
> > > > > git://github.com/snitm/linux.git
> > > > > 
> > > > > This 8 patch patchset from Joe should apply cleanly ontop of my
> > > > > 'dm-for-3.8' branch.
> > > > > 
> > > > > But if all you care about is a tree with all the changes then please
> > > > > just use Joe's github 'thin-dev' branch.
> > > > 
> > > > A full list of broken-out patches would've been nice, but oh well, I ate this
> > > > git tree. :)
> > > > 
> > > > Curiously, the Documentation/device-mapper/dm-cache.txt says to specify devices
> > > > in the order: metadata, origin, and cache, but the code (and Joe's mail) seeem
> > > > to want metadata, cache, origin.  This sort of makes me wonder what's going on?
> > > 
> > > The patch Joe posted has the proper order (metadata, cache, origin -- I
> > > fixed the ordering in dm-cache,txt and Joe pulled it in before posting
> > > the patches).  Seems Joe forgot to push his last few tweaks to his
> > > thin-dev branch.
> > > 
> > > > Also, I found a bug when using the mru policy.  If I do this:
> > > 
> > > Pretty sure you'd be best served to focus on the code Joe posted.  Maybe
> > > best to clone my github tree and start with my 'dm-for-3.8' branch.  And
> > > then apply all the patches Joe posted.
> > 
> > Also, AFAIK Joe pulled Linus latest tree from this afternoon into his
> > thin-dev; which included a bunch of bleeding v3.8 merge changes.
> > That makes his thin-dev inappropriate for stable testing.  You could
> > eaisly be hitting some early v3.8 issue.
> > 
> > My "dm-for-3.8" is v3.7 + the bulk of the DM patches destined for v3.8.
> 
> Ok, I'll go grab that. :)

To make life easier for you, and others, I've created a new
'dm-devel-cache' branch on my github tree (It is a branched from my
'dm-for-3.8').

I applied the 8 patches Joe posted to dm-devel and one extra compiler
warning fix.

Again my github tree is git://github.com/snitm/linux.git

Mike
