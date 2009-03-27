From: Pasi =?iso-8859-1?Q?K=E4rkk=E4inen?= <pasik@iki.fi>
Subject: Re: Shell Scripts or Arbitrary Priority Callouts?
Date: Fri, 27 Mar 2009 11:02:00 +0200
Message-ID: <20090327090200.GP24960@edu.joroinen.fi>
References: <1237897305.6560.26.camel@jaspav.missionsit.net.missionsit.net>
	<20090324150104.GO5528@edu.joroinen.fi>
	<1237909400.6560.80.camel@jaspav.missionsit.net.missionsit.net>
	<20090324163603.GQ5528@edu.joroinen.fi>
	<1237915811.6560.135.camel@jaspav.missionsit.net.missionsit.net>
	<20090324181735.GR5528@edu.joroinen.fi>
	<1237952460.6560.204.camel@jaspav.missionsit.net.missionsit.net>
	<20090325155207.GE24960@edu.joroinen.fi>
	<1237998092.6560.233.camel@jaspav.missionsit.net.missionsit.net>
	<1238137415.6574.48.camel@jaspav.missionsit.net.missionsit.net>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1238137415.6574.48.camel@jaspav.missionsit.net.missionsit.net>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: "Ross S. W. Walker" <rwalker@medallion.com>
List-Id: dm-devel.ids

On Fri, Mar 27, 2009 at 03:03:35AM -0400, John A. Sullivan III wrote:
> > > 
> > > > The once piece which is still a mystery is why using four targets on
> > > > four separate interfaces striped with dmadm RAID0 does not produce an
> > > > aggregate of slightly less than four times the IOPS of a single target
> > > > on a single interface. This would not seem to be the out of order SCSI
> > > > command problem of multipath.  One of life's great mysteries yet to be
> > > > revealed.  Thanks again, all - John
> > > 
> > > Hmm.. maybe the out-of-order problem happens at the target? It gets IO
> > > requests to nearby offsets from 4 different sessions and there's some kind
> > > of locking or so going on? 
> > Ross pointed out a flaw in my test methodology.  By running one I/O at a
> > time, it was literally doing that - not one full RAID0 I/O but one disk
> > I/O apparently.  He said to truly test it, I would need to run as many
> > concurrent I/Os as there were disks in the array.  Thanks - John
> > ><snip>
> Argh!!! This turned out to be alarmingly untrue.  This time, we were
> doing some light testing on a different server with two bonded
> interfaces in a single bridge (KVM environment) going to the same SAM we
> used in our four port test.
> 

Is the SAN also using bonded interfaces?

> For kicks and to prove to ourselves that RAID0 scaled with multiple I/O
> as opposed to limiting the test to only single I/O, we tried some actual
> file transfers to the SAN mounted in sync mode.  We found concurrently
> transferring two identical files to the RAID0 array composed of two
> iSCSI attached drives was 57% slower than concurrently transferring the
> files to the drives separately. In other words, copying file1 and file2
> concurrently to RAID0 took 57% longer than concurrently copying file1 to
> disk1 and file2 to disk2.
> 

Hmm.. I wonder why that happens..

> We then took a little different approach and used disktest.  We ran two
> concurrent sessions with -K1.  In one case, we ran both sessions to the
> 2 disk RAID0 array.  The performance was significantly less again, than
> running the two concurrent tests against two separate iSCSI disks.  Just
> to be clear, these were the same disks as composed the array, just not
> grouped in the array.
> 

There has to be some logical explanation to this.. 

> Even more alarmingly, we did the same test using multipath multibus,
> i.e., two concurrent disktest with -K1 (both reads and rights, all
> sequential with 4K block sizes).  The first session completely starved
> the second.  The first one continued at only slightly reduced speed
> while the second one (kicked off just as fast as we could hit the enter
> key) received only roughly 50 IOPS.  Yes, that's fifty.
> 
> Frightening but I thought I had better pass along such extreme results
> to the multipath team.  Thanks - John

Hmm, so you had mpath0 and mpath1, and you ran disktest against both, at the
same time? 

-- Pasi
