From: Pasi =?iso-8859-1?Q?K=E4rkk=E4inen?= <pasik@iki.fi>
Subject: Re: Shell Scripts or Arbitrary Priority Callouts?
Date: Tue, 24 Mar 2009 13:57:08 +0200
Message-ID: <20090324115708.GM5528@edu.joroinen.fi>
References: <7bc80d500903181557x295480feia73d0c23992c6f65@mail.gmail.com>
	<1237460677.6506.5.camel@jaspav.missionsit.net.missionsit.net>
	<7bc80d500903192211k6baadc81ge1b9d8b81ea6a913@mail.gmail.com>
	<1237543283.6572.10.camel@jaspav.missionsit.net.missionsit.net>
	<20090322152730.GC5528@edu.joroinen.fi>
	<1237801596.6577.28.camel@jaspav.missionsit.net.missionsit.net>
	<20090324073935.GK5528@edu.joroinen.fi>
	<1237892561.6560.19.camel@jaspav.missionsit.net.missionsit.net>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1237892561.6560.19.camel@jaspav.missionsit.net.missionsit.net>
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

On Tue, Mar 24, 2009 at 07:02:41AM -0400, John A. Sullivan III wrote:
> > > <snip>
> > > I'm trying to spend a little time on this today and am really feeling my
> > > ignorance on the way iSCSI works :(  It looks like linux-iscsi supports
> > > MC/S but has not been in active development and will not even compile on
> > > my 2.6.27 kernel.
> > > 
> > > To simplify matters, I did put each SAN interface on a separate network.
> > > Thus, all the different sessions.  If I place them all on the same
> > > network and use the iface parameters of open-iscsi, does that eliminate
> > > the out-of-order problem and allow me to achieve the performance
> > > scalability I'm seeking from dm-multipath in multibus mode? Thanks -
> > > John
> > 
> > If you use ifaces feature of open-iscsi, you still get separate sessions.
> > 
> > open-iscsi just does not support MC/s :(
> > 
> > I think core-iscsi does support MC/s.. 
> > 
> > Then you again you should play with the different multipath settings, and
> > tweak how often IOs are split to different paths etc.. maybe that helps.
> > 
> > -- Pasi
> <snip>
> I think we're pretty much at the end of our options here but I document
> what I've found thus far for closure.
> 
> Indeed, there seems to be no way around the session problem.  Core-iscsi
> does seem to support MC/s but has not been updated in years.  It did not
> compile with my 2.6.27 kernel and, given that others seem to have had
> the same problem, I did not spend a lot of time troubleshooting it.
> 

Core-iscsi developer seems to be active developing at least the 
new iSCSI target (LIO target).. I think he has been testing it with
core-iscsi, so maybe there's newer version somewhere? 

> We did play with the multipath rr_min_io settings and smaller always
> seemed to be better until we got into very large numbers of session.  We
> were testing on a dual quad core AMD Shanghai 2378 system with 32 GB
> RAM, a quad port Intel e1000 card and two on-board nvidia forcedeth
> ports with disktest using 4K blocks to mimic the file system using
> sequential reads (and some sequential writes).
> 

Nice hardware. Btw are you using jumbo frames or flow control for iSCSI
traffic? 

> With a single thread, there was no difference at all - only about 12.79
> MB/s no matter what we did.  With 10 threads and only two interfaces,
> there was only a slight difference between rr=1 (81.2B/s), rr=10 (78.87)
> and rr=100 (80).
> 
> However, when we opened to three and four interfaces, there was a huge
> jump for rr=1 (100.4, 105.95) versus rr=10 (80.5, 80.75) and rr=100
> (74.3, 77.6).
> 
> At 100 threads on three or four ports, the best performance shifted to
> rr=10 (327 MB/s, 335) rather than rr=1 (291.7, 290.1) or rr=100 (216.3).
> At 400 threads, rr=100 started to overtake rr=10 slightly.
> 
> This was using all e1000 interfaces. Our first four port test included
> one of the on board ports and performance was dramatically less than
> three e1000 ports.  Subsequent testing tweaking forcedeth parameters
> from defaults yielded no improvement.
> 
> After solving the I/O scheduler problem, dm RAID0 behaved better.  It
> still did not give us anywhere near a fourfold increase (four disks on
> four separate ports) but only marginal improvement (14.3 MB/s) using c=8
> (to fit into a jumbo packet, match the zvol block size on the back end
> and be two block sizes).  It did, however, give the best balance of
> performance being just slightly slower than rr=1 at 10 threads and
> slightly slower than rr=10 at 100 threads though not scaling as well to
> 400 threads.
> 

When you used dm RAID0 you didn't have any multipath configuration, right? 

What kind of stripe size and other settings you had for RAID0?

What kind of performance do you get using just a single iscsi session (and
thus just a single path), no multipathing, no DM RAID0 ? Just a filesystem
directly on top of the iscsi /dev/sd? device.

> Thus, collective throughput is acceptable but individual throughput is
> still awful.
> 

Sounds like there's some other problem if invidual throughput is bad? Or did
you mean performance with a single disktest IO thread is bad, but using multiple
disktest threads it's good.. that would make more sense :) 

-- Pasi
