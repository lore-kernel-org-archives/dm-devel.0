From: "Stefan Bader" <Stefan.Bader@de.ibm.com>
Subject: Re: Designing a new prio_callout
Date: Wed, 15 Aug 2007 10:45:11 +0200
Message-ID: <5201e28f0708150145s42ff46a5t8dab865931cb09d@mail.gmail.com>
References: <d61540a40706211442w1ef3bacflddd44f74c8883a3f@mail.gmail.com>
	<46A735E1.4070206@suse.de>
	<d61540a40707290903q359cc7c8g52f07627b4b9fba7@mail.gmail.com>
	<46AD85A5.1060609@suse.de>
	<d61540a40708091055u725fa5e4wa182ac1d778323be@mail.gmail.com>
	<46BC7F14.80302@suse.de>
	<d61540a40708100840m541e198dg88c12d031febf968@mail.gmail.com>
	<d61540a40708141005n4eb06cebx14559f055b0df3d6@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <d61540a40708141005n4eb06cebx14559f055b0df3d6@mail.gmail.com>
Content-Disposition: inline
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
List-Id: dm-devel.ids

Hi Ethan,

I might not understand the problem completely but I do not understand
the benefit of changing rr_min_io. As far as I can see from your
multipath output, both of the devices consist of two path groups with
one path. This means, as long as there is no path failure I/O will
never be sent to the inactive group.
I guess the only thing you need is a script that might find out from a
given scsi device (like sdc) whether this would be the preferred path
and then print a number that represents the priority (the lower, the
higher). Then use this as priority callout and group by priority with
failback set to immediate.

Regards,
Stefan

2007/8/14, Ethan John <ethan.john@gmail.com>:
> For the record, setting rr_min_io to something extremely large (we're using
> 2 billion now, since I'm assuming it's a C integer) solves the immediate
> problem that we're having (overhead in path switching causing poor

> > mpath45 (20002c9020020001a00151b6b46bb57b0) dm-1
> company,iSCSI target
> > [size=15G][features=0][hwhandler=0]
> > \_ round-robin 0 [prio=1][active]
> >  \_ 22:0:0:1 sdc 8:32  [active][ready]
> > \_ round-robin 0 [prio=1][enabled]
> >  \_ 23:0:0:1 sde 8:64  [active][ready]
> > mpath44 (20002c9020020001200151b6b46bb57ae) dm-0
> company,iSCSI target
> > [size=15G][features=0][hwhandler=0]
> > \_ round-robin 0 [prio=1][enabled]
> >  \_ 22:0:0:0 sdb 8:16  [active][ready]
> > \_ round-robin 0 [prio=1][enabled]
> >  \_ 23:0:0:0 sdd 8:48  [active][ready]
> >
