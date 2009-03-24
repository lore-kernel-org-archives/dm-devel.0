From: Pasi =?iso-8859-1?Q?K=E4rkk=E4inen?= <pasik@iki.fi>
Subject: Re: Shell Scripts or Arbitrary Priority Callouts?
Date: Tue, 24 Mar 2009 17:01:04 +0200
Message-ID: <20090324150104.GO5528@edu.joroinen.fi>
References: <7bc80d500903181557x295480feia73d0c23992c6f65@mail.gmail.com>
	<1237460677.6506.5.camel@jaspav.missionsit.net.missionsit.net>
	<7bc80d500903192211k6baadc81ge1b9d8b81ea6a913@mail.gmail.com>
	<1237543283.6572.10.camel@jaspav.missionsit.net.missionsit.net>
	<20090322152730.GC5528@edu.joroinen.fi>
	<1237801596.6577.28.camel@jaspav.missionsit.net.missionsit.net>
	<20090324073935.GK5528@edu.joroinen.fi>
	<1237892561.6560.19.camel@jaspav.missionsit.net.missionsit.net>
	<20090324115708.GM5528@edu.joroinen.fi>
	<1237897305.6560.26.camel@jaspav.missionsit.net.missionsit.net>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1237897305.6560.26.camel@jaspav.missionsit.net.missionsit.net>
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

On Tue, Mar 24, 2009 at 08:21:45AM -0400, John A. Sullivan III wrote:
> > 
> > Core-iscsi developer seems to be active developing at least the 
> > new iSCSI target (LIO target).. I think he has been testing it with
> > core-iscsi, so maybe there's newer version somewhere? 
> > 
> > > We did play with the multipath rr_min_io settings and smaller always
> > > seemed to be better until we got into very large numbers of session.  We
> > > were testing on a dual quad core AMD Shanghai 2378 system with 32 GB
> > > RAM, a quad port Intel e1000 card and two on-board nvidia forcedeth
> > > ports with disktest using 4K blocks to mimic the file system using
> > > sequential reads (and some sequential writes).
> > > 
> > 
> > Nice hardware. Btw are you using jumbo frames or flow control for iSCSI
> > traffic? 
> > 

Dunno if you noticed this.. :) 


> > > 
> > 
> > When you used dm RAID0 you didn't have any multipath configuration, right? 
> Correct although we also did test successfully with multipath in
> failover mode and RAID0.
> > 

OK.

> > What kind of stripe size and other settings you had for RAID0?
> Chunk size was 8KB with four disks.  
> > 

Did you try with much bigger sizes.. 128 kB ?

> > What kind of performance do you get using just a single iscsi session (and
> > thus just a single path), no multipathing, no DM RAID0 ? Just a filesystem
> > directly on top of the iscsi /dev/sd? device.
> Miserable - same roughly 12 MB/s.

OK, Here's your problem. Was this btw reads or writes? Did you tune
readahead-settings? 

Can paste your iSCSI session settings negotiated with the target? 

> > 
> > Sounds like there's some other problem if invidual throughput is bad? Or did
> > you mean performance with a single disktest IO thread is bad, but using multiple
> > disktest threads it's good.. that would make more sense :) 
> Yes, the latter.  Single thread (I assume mimicking a single disk
> operation, e.g., copying a large file) is miserable - much slower than
> local disk despite the availability of huge bandwidth.  We start
> utilizing the bandwidth when multiplying concurrent disk activity into
> the hundreds.
> 
> I am guessing the single thread performance problem is an open-iscsi
> issue but I was hoping multipath would help us work around it by
> utilizing multiple sessions per disk operation.  I suppose that is where
> we run into the command ordering problem unless there is something else
> afoot.  Thanks - John

You should be able to get many times the throughput you get now.. just with
a single path/session.

What kind of latency do you have from the initiator to the target/storage? 

Try with for example 4 kB ping:
ping -s 4096 <ip_of_the_iscsi_target>

1000ms divided by the roundtrip you get from ping should give you maximum
possible IOPS using a single path.. 

4 kB * IOPS == max bandwidth you can achieve.

-- Pasi
