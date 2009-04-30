From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: Re: rdac priority checker changing priorities
Date: Thu, 30 Apr 2009 11:05:43 -0700
Message-ID: <1241114743.11905.13.camel@chandra-ubuntu>
References: <9ad205140904291534j4cc1a71aq3b4a0e308f1687bd@mail.gmail.com>
	<49F9443E.7040109@suse.de>
Reply-To: sekharan@linux.vnet.ibm.com,
	device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <49F9443E.7040109@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Hannes Reinecke <hare@suse.de>
Cc: dm-devel <dm-devel@redhat.com>
List-Id: dm-devel.ids

Hannes,

I think we need to revisit the priority value we provide for preferred
path(4) relative to active path (2) and non-preferred(1).

Consider the following scenario:

Access to a lun thru 2 preferred and 2 non-preferred path. Lets call
path group with preferred paths as pg1 and with non-preferred paths as
pg2. 

Initially pg1 has priority of 8 and pg2 has priority of 2. pg1 is chosen
and I/O goes thru pg1, all good.

Both the paths in pg1 fails, pg2 has been made the active path group and
I/O is sent thru that path and since it became "active", its priority
raises to 6 ( 2 path times (active + non-preferred)). 

When one of the paths in pg1 comes back, one would expect the failback
to happen. It doesn't happen as pg1's priority (4) is smaller than that
of pg2 (6). Which is not correct.

We can do the same exercise with more than 4 paths also, like 6, 8 etc.,
and the results are worse.

So, IMO we need to give the disproportionately large number for
preferred path w.r.t active and non-preferred. What do you think ?

chandra



On Thu, 2009-04-30 at 08:25 +0200, Hannes Reinecke wrote:
> Hi Lucas,
> 
> Lucas Brasilino wrote:
> > Hi
> > 
> > I don't know if I'm misundertanding something. I've got an DS4700 and I'm
> > switching from RDAC[1] to multipath, since it's natively supported in
> > the distribution I use
> > here (SLES 10 SP2).
> > 
> > Since RDAC[1] works perfect, I'm trying to use 'rdac' priority in multipath.
> > 
> > My /etc/multiconf.conf is quite tiny, since I'm building it step-by-step :-) :
> > 
> > blacklist {
> > 	devnode "^sda[0-9]*"
> > }
> > 
> > defaults {
> > 	user_friendly_names	yes
> > 	prio			rdac
> > 	path_checker		tur
> > }
> > 
> > multipaths {
> > 	multipath {
> > 		wwid	3600a0b8000327b900000107549f85224
> > 		alias	mpath0
> > 	}
> > }
> > 
> > I think that using 'prio rdac' makes multipath to use 'mpath_prio_rdac' tool.
> > 
> >  # multipath -v2 -ll
> > mpath0 (3600a0b8000327b900000107549f85224) dm-0 IBM,1814      FAStT
> > [size=140G][features=1 queue_if_no_path][hwhandler=1 rdac]
> > \_ round-robin 0 [prio=6][active]
> >  \_ 9:0:0:0  sdb 8:16  [active][ready]
> > \_ round-robin 0 [prio=1][enabled]
> >  \_ 10:0:0:0 sdc 8:32  [active][ghost]
> > 
> > So the first path has priority 6, as I can confirm:
> > 
> > # mpath_prio_rdac /dev/sdb
> > 6
> > # mpath_prio_rdac /dev/sdc
> > 1
> > 
> > After the first path (prio=6) failure I get:
> > 
> > # multipath -v2 -ll
> > sdb: rdac prio: inquiry command indicates error
> > mpath0 (3600a0b8000327b900000107549f85224) dm-0 IBM,1814      FAStT
> > [size=140G][features=1 queue_if_no_path][hwhandler=1 rdac]
> > \_ round-robin 0 [prio=0][enabled]
> >  \_ 9:0:0:0  sdb 8:16  [failed][faulty]
> > \_ round-robin 0 [prio=1][enabled]
> >  \_ 10:0:0:0 sdc 8:32  [active][ghost]
> > 
> > Ok.. working great, activating the second path. But after the faulty
> > path is restored:
> > 
> > # multipath -v2 -ll
> > mpath0 (3600a0b8000327b900000107549f85224) dm-0 IBM,1814      FAStT
> > [size=140G][features=1 queue_if_no_path][hwhandler=1 rdac]
> > \_ round-robin 0 [prio=2][enabled]
> >  \_ 9:0:0:0  sdb 8:16  [active][ghost]
> > \_ round-robin 0 [prio=5][active]
> >  \_ 10:0:0:0 sdc 8:32  [active][ready]
> > 
> > Second path is now priority!!! And of course does not fails back! By
> > the way, my LUN is configured in
> > DS4700 in sort a way that the first path *is* the path to preferred controller.
> > 
> > I think path priorities should not change. If so first path goes back
> > to 'active' status.
> > Am I misunderstanding something ? Or messing things up?
> > 
> You are using an old version of multipathing for SLES10 SP2.
> This had a bug triggering priority inversion on RDAC.
> Please update to the latest version.
> 
> Cheers,
> 
> Hannes
