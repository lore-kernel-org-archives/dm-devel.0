From: Pasi =?iso-8859-1?Q?K=E4rkk=E4inen?= <pasik@iki.fi>
Subject: Re: Shell Scripts or Arbitrary Priority Callouts?
Date: Wed, 25 Mar 2009 17:52:07 +0200
Message-ID: <20090325155207.GE24960@edu.joroinen.fi>
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
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1237952460.6560.204.camel@jaspav.missionsit.net.missionsit.net>
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

On Tue, Mar 24, 2009 at 11:41:00PM -0400, John A. Sullivan III wrote:
> > > Latency seems to be our key.  If I can add only 20 micro-seconds of
> > > latency from initiator and target each, that would be roughly 200 micro
> > > seconds.  That would almost triple the throughput from what we are
> > > currently seeing.
> > > 
> > 
> > Indeed :) 
> > 
> > > Unfortunately, I'm a bit ignorant of tweaking networks on opensolaris.
> > > I can certainly learn but am I headed in the right direction or is this
> > > direction of investigation misguided? Thanks - John
> > > 
> > 
> > Low latency is the key for good (iSCSI) SAN performance, as it directly
> > gives you more (possible) IOPS. 
> > 
> > Other option is to configure software/settings so that there are multiple
> > outstanding IO's on the fly.. then you're not limited with the latency (so much).
> > 
> > -- Pasi
> <snip>
> Ross has been of enormous help offline.  Indeed, disabling jumbo packets
> produced an almost 50% increase in single threaded throughput.  We are
> pretty well set although still a bit disappointed in the latency we are
> seeing in opensolaris and have escalated to the vendor about addressing
> it.
> 

Ok. That's pretty big increase. Did you figure out why that happens? 

> The once piece which is still a mystery is why using four targets on
> four separate interfaces striped with dmadm RAID0 does not produce an
> aggregate of slightly less than four times the IOPS of a single target
> on a single interface. This would not seem to be the out of order SCSI
> command problem of multipath.  One of life's great mysteries yet to be
> revealed.  Thanks again, all - John

Hmm.. maybe the out-of-order problem happens at the target? It gets IO
requests to nearby offsets from 4 different sessions and there's some kind
of locking or so going on? 

Just guessing. 

-- Pasi
