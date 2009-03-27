From: "John A. Sullivan III" <jsullivan@opensourcedevel.com>
Subject: RE: Shell Scripts or Arbitrary Priority Callouts?
Date: Fri, 27 Mar 2009 14:06:18 -0400
Message-ID: <1238177178.6574.131.camel@jaspav.missionsit.net.missionsit.net>
References: <20090324073935.GK5528@edu.joroinen.fi>
	<1237892561.6560.19.camel@jaspav.missionsit.net.missionsit.net>
	<20090324115708.GM5528@edu.joroinen.fi>
	<1237897305.6560.26.camel@jaspav.missionsit.net.missionsit.net>
	<20090324150104.GO5528@edu.joroinen.fi>
	<1237909400.6560.80.camel@jaspav.missionsit.net.missionsit.net>
	<20090324163603.GQ5528@edu.joroinen.fi>
	<1237915811.6560.135.camel@jaspav.missionsit.net.missionsit.net>
	<20090324181735.GR5528@edu.joroinen.fi>
	<1237952460.6560.204.camel@jaspav.missionsit.net.missionsit.net>
	<20090325155207.GE24960@edu.joroinen.fi>
	<1237998092.6560.233.camel@jaspav.missionsit.net.missionsit.net>
	<1238137415.6574.48.camel@jaspav.missionsit.net.missionsit.net>
	<2A4646CA-45AF-460A-8E43-A6D9C070842A@medallion.com>
	<1238165063.6574.97.camel@jaspav.missionsit.net.missionsit.net>
	<E2BB8074E5500C42984D980D4BD78EF9029E3CFA@MFG-NYC-EXCH2.mfg.prv>
	<1238174141.6574.109.camel@jaspav.missionsit.net.missionsit.net>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1238174141.6574.109.camel@jaspav.missionsit.net.missionsit.net>
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
Cc: "Ross S. W. Walker" <RWalker@medallion.com>
List-Id: dm-devel.ids

On Fri, 2009-03-27 at 13:15 -0400, John A. Sullivan III wrote:
> On Fri, 2009-03-27 at 10:59 -0400, Ross S. W. Walker wrote:
> > John A. Sullivan III wrote:
> > > 
> > > On Fri, 2009-03-27 at 10:09 -0400, Ross S. W. Walker wrote:
> > > > 
> > > > I'm sorry you lost me here on this test. NFS file transfers are
> > > > completely different then iSCSI as NFS uses the OS' (for better or
> > > > worse) implementation of file io and not block io, so using NFS as a
> > > > test isn't the best.
> > > 
> > > Sorry if I wasn't clear.  These were iSCSI tests but using file
> > > services, e.g., cp, mv.
> > > 
> > > > My whole idea of mentioning the multiple ios was basically if one
> > > > disk's maximum transfer speed is 40MB/s and you put 4 in a RAID0 then
> > > > if you tested that RAID0 with an app that did 1 io at a time you would
> > > > still only see 40MB/s and not the 160MB/s it is capable of. Obviously
> > > > that isn't what's happening here.
> > > 
> > > Yes, that's what I was hoping for :)
> > > 
> > > > One would hope throughput scales up with number of simultaneous ios or
> > > > there is something broken. Maybe it is dm-raid that is broken, or
> > > > maybe it's just dm-raid+iSCSI that's broken, or maybe it's just
> > > > dm-raid+iSCSI+ZFS that's broken? Who knows? Iit's obvious that this
> > > > setup won't work though.
> > > > 
> > <snip>
> > > > 
> > > > I would take a step back at this point and re-evaluate if running
> > > > software RAID over iSCSI is the best. It seems like a highly complex
> > > > system to get the performance you need.
> > > 
> > > Yes, that's what we've decided to do which has forced a bit of redesign
> > > on our part.
> > > 
> > > > The best, most reliably performing results I have seen with iSCSI have
> > > > been those where the target is performing the RAID (software or
> > > > hardware) and the initiator treats it as a plain disk, using interface
> > > > aggregates or multi-paths to gain throughput.
> > > 
> > > Strangely, multipath didn't seem to help as I thought it would.  Thanks
> > > for all your help - John
> > 
> > Not a problem, in fact I have a vested interest in you succeeding because
> > we are looking at moving our iSCSI over from Linux to Solaris to get
> > that warm fuzzy ZFS integrity assurance feeling.
> > 
> > It is just (and we are running Solaris 10u6 and not OpenSolaris here), we
> > find the user space iscsitgt daemon leaves something to be desired over
> > the kernel based iSCSI Enterprise Target on Linux. Also we have noticed
> > strange performance abnormalities in our tests of iSCSI to a ZFS ZVOL
> > as opposed to iSCSI to a raw disk.
> > 
> > Maybe it's just the price you pay doing iSCSI to a COW file system instead
> > of a raw disk? I dunno, I always prefer to get it all then compromise,
> > but sometimes one doesn't have a choice.
> > 
> > Oh BTW ZFS as an NFS server works brilliantly. We have moved 50% of our
> > VMs over from iSCSI to NFS and performance is great as each VM has 
> > a level of guaranteed throughput so no one VM can starve out the others.
> > 
> > We are going to stick with our Linux iSCSI target for a wee bit longer
> > though to see if the ZFS/ZVOL/iscsitgt situation improves in 10u7. Gives
> > me time to learn the Solaris LiveUpgrade feature.
> <snip>
> Hi Ross. I hope you don't mind that I copied the mailing list in case it
> is of interest to anyone.
> 
> We are using COMSTAR which has given a substantial improvement over
> iscsitgt.  I was concerned about the overhead of writing to the file
> system although I'm not sure that's really the issue.  When we run
> bonnie++ tests on the unit itself, we see it able to read at over 500
> MB/s and write at almost 250.  That's in a unit with four mirror
> pairs.  
> 
> The killer issue seems to be latency.  As seen in a previous post, the
> latency on the opensolaris unit is dramatically higher than on the Linux
> unit and more erratic.
> 
> That brings me back to a question about NFS.  I could use NFS for our
> scenario as much of our disk I/O is file system I/O (hence the 4KB block
> size problem and impact of latency).  We've thought about switching to
> NFS and I've just not benchmarked it because we are so behind on our
> project (not a good reason).  However, everything I read says NFS is
> slower iSCSI especially for random file I/O as we expect although I
> wonder if it would help us on sequential I/O since we can change the I/O
> size to something much larger than the file system block size.
> 
> So, what are the downsides of using NFS? Will I see the same problem
> because of latency (since we get plenty of raw throughput on disk) or is
> it a solution to our latency problem because we can tell it to use large
> transfer sizes? Thanks - John
> > 
Ah, I forgot another issue in our environment which mitigates again NFS.
It is very heavily virtualized so there are not a lot of physical
devices.  They do have multiple Ethernet interfaces, (e.g., there are
ten GbE interfaces on the SAN).  However, we have a problem aggregating
throughput.  Because there are only a handful of actual (but very large)
systems, Ethernet bonding doesn't help us very much.  Anything that
passes through the ProCurve switches is mapped by MAC address (as
opposed to being able to hash upon socket).  Thus, all traffic flows
through a single interface.

Moreover, opensolaris only seems to support 802.3ad bonding.  Our
ProCurve switches do not support 802.3ad bonding across multiple
switches so using leaves use vulnerable to a single point of failure
(ironically).  I believe Nortel supports this though I'm not sure about
Cisco.  HP is releasing that capability this or next quarter but not in
our lowly 2810 models.  We thought we got around the problems by using
Linux based balance-xor using hash 3+4 and it seemed to work until we
noticed than the switch CPU shot to 99% under even light traffic
loads :(

That's initially why we wanted to go the RAID0 route with each interface
on a different network for aggregating throughput and dm-multipath
underneath it for fault tolerance.  If we go with NFS, I believe we will
lose the ability to aggregate bandwidth.  Thanks - John
-- 
John A. Sullivan III
Open Source Development Corporation
+1 207-985-7880
jsullivan@opensourcedevel.com

http://www.spiritualoutreach.com
Making Christianity intelligible to secular society
