From: Ming Zhang <mingz@ele.uri.edu>
Subject: Re: Re: Was: [patch 1/1] md/dm: Reduce stack usage with
	stacked block devices
Date: Thu, 12 Jan 2006 14:52:01 -0500
Message-ID: <1137095521.8585.47.camel@localhost.localdomain>
References: <62b0912f0601110445w34d480c4n56d8f02056baef26@mail.gmail.com>
	<20060111135301.GY4346@agk.surrey.redhat.com>
	<62b0912f0601111226q4732fc23qee79b7a2fc215fe9@mail.gmail.com>
	<1137012072.10270.113.camel@localhost.localdomain>
	<20060111205437.GD4346@agk.surrey.redhat.com>
	<1137013229.10270.117.camel@localhost.localdomain>
	<170fa0d20601121132o5e031e55ge291b883250781af@mail.gmail.com>
Reply-To: mingz@ele.uri.edu,
	device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <170fa0d20601121132o5e031e55ge291b883250781af@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@gmail.com>
Cc: akpm@osdl.org, device-mapper development <dm-devel@redhat.com>, phillips@redhat.com, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On Thu, 2006-01-12 at 14:32 -0500, Mike Snitzer wrote:
> On 1/11/06, Ming Zhang <mingz@ele.uri.edu> wrote:
> > On Wed, 2006-01-11 at 20:54 +0000, Alasdair G Kergon wrote:
> 
> > > Efficient, unlikely with the current implemention - hence the need
> > > for a rewrite.
> >
> > >
> > > If you have 5 snapshots of the same origin, the current implemention
> > > takes 5 copies of the data when you change it. That approach is
> > > never going to scale well!  And it uses lots of memory.
> >
> > yes, you are right. is there any new rewrite action proposed or planned?
> 
> My understanding is that much of RedHat's Cluster Snapshot Block
> Device (CSNAP) core is a candidate for the dm-snapshot rewrite:
> http://sources.redhat.com/cluster/csnap/csnap.ps
> 
> Along with other improvements, performance would be addressed with a
> shared exception table (tree) for all snapshots (only one copy of each
> exception).  When I spoke with Daniel Phillips (author of CSNAP
> stuffs) a few months ago he said CSNAP is on the back burner until
> others realize just how bad the existing dm-snapshot is.  He is
> looking/waiting for others who are willing to contribute in moving
> CSNAP's snapshot improvements into dm-snapshot++.  Unfortunately I'd
> only be able to contribute testing at this time...

Thanks a lot for this information! Just have a quick glimpse on
abstract. Looks interesting.


> 
> Mike
