From: Heinz Mauelshagen <mauelshagen@redhat.com>
Subject: Re: Desynchronizing dm-raid1
Date: Mon, 7 Apr 2008 16:25:17 +0200
Message-ID: <20080407142517.GA7327@redhat.com>
References: <20080317215631.GG29322@agk.fab.redhat.com>
	<Pine.LNX.4.64.0803181921380.10939@porkchop.devel.redhat.com>
	<20080318233955.GA12007@agk.fab.redhat.com>
	<Pine.LNX.4.64.0803181942140.20490@porkchop.devel.redhat.com>
	<20080319000241.GB12007@agk.fab.redhat.com>
	<Pine.LNX.4.64.0803182015001.21077@porkchop.devel.redhat.com>
	<20080319011757.GD12007@agk.fab.redhat.com>
	<Pine.LNX.4.64.0804021444120.22485@porkchop.devel.redhat.com>
	<20080403091936.GA9901@redhat.com>
	<20080403142154.GA11878@us.ibm.com>
Reply-To: mauelshagen@redhat.com,
	device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20080403142154.GA11878@us.ibm.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
Cc: hjm@redhat.com
List-Id: dm-devel.ids

On Thu, Apr 03, 2008 at 07:21:54AM -0700, malahal@us.ibm.com wrote:
> Heinz Mauelshagen [mauelshagen@redhat.com] wrote:
> > 
> > [HM] md RAID456 and dm RAID45 don't have the raid1 problem, because
> > they utilize stripe caches, hence tacking page copies. Application pages
> > can change nonetheless vs. stripe cache pages.
> 
> I wish they didn't make copies of data pages for the sake of
> performance! If they did make copies for all of their I/O, they don't
> have this problem.

Me too but it's mandatory to be able to calculate parity chunks ;)

> 
> > > 4. make more region states.
> > > --- If the region is in RH_DIRTY state and all writes drain, the state is 
> > > changed to RH_MAYBE_DIRTY. (we don't know if the region is synchronized or 
> > > not). The disk dirty flag is kept.
> > > --- periodically (once in few minutes, so that it doesn't affect 
> > > performance much), the change all regions in RH_MAYBE_DIRTY state to 
> > > RH_CLEAN_CANDIDATE, then issue sync() on all filesystems. If, after the 
> > > sync(), the region is still in RH_CLEAN_CANDIDATE (i.e. it hasn't been 
> > > written during the sync()), it is moved to RH_CLEAN state and the on-disk 
> > > bit for the region is turned off.
> > 
> > [HM] This is essentially one technical approach for my comment on 2. above.
> > RH_MAYBE_DIRTY sounds superfluous at first glance, because when all writes
> > to a region drained, we can set RH_CLEAN_CANDIDATE, run the sync() and check
> > if that state persists in order to trigger the dirty log update.
> 
> I don't think the state RH_MAYBE_DIRTY is superfluous.  If the region
> state is RH_CLEAN_CANDIDATE after the sync(), that means no 'write'
> happened since we set RH_CLEAN_CANDIDATE. If there was any write, the
> region state would be 'RH_DIRTY' or 'RH_MAYBE_DIRTY'.

Hrm, sound like a contradiction in your statement.
Either it stays RH_CLEAN_CANDIDATE because of no writes *or*
it's state-changing to RH_DIRTY, no ?

Heinz

> 
> --Malahal.
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
