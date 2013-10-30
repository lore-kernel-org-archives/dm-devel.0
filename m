From: "Merla, ShivaKrishna" <ShivaKrishna.Merla@netapp.com>
Subject: Re: [PATCH]dm-mpath: fix for race condition between
 multipath_dtr and pg_init_done.
Date: Wed, 30 Oct 2013 13:44:07 +0000
Message-ID: <FB8A412F33166C4A930D37BD63236C902AD32515@SACEXCMBX02-PRD.hq.netapp.com>
References: <FB8A412F33166C4A930D37BD63236C902AD2A073@SACEXCMBX02-PRD.hq.netapp.com>
	<20131017185306.GA29909@redhat.com> <52605B07.5070007@suse.de>
	<20131017211014.GA30993@redhat.com>
	<FB8A412F33166C4A930D37BD63236C902AD2A12B@SACEXCMBX02-PRD.hq.netapp.com>
	<20131030005705.GA3569@redhat.com>
	<FB8A412F33166C4A930D37BD63236C902AD324CD@SACEXCMBX02-PRD.hq.netapp.com>
	<20131030134223.GA7581@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20131030134223.GA7581@redhat.com>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>, Mikulas Patocka <mpatocka@redhat.com>, "agk@redhat.com" <agk@redhat.com>
List-Id: dm-devel.ids


> -----Original Message-----
> From: Mike Snitzer [mailto:snitzer@redhat.com]
> Sent: Wednesday, October 30, 2013 8:42 AM
> To: Merla, ShivaKrishna
> Cc: Hannes Reinecke; dm-devel@redhat.com; agk@redhat.com; Mikulas
> Patocka
> Subject: Re: [PATCH]dm-mpath: fix for race condition between
> multipath_dtr and pg_init_done.
> 
> On Wed, Oct 30 2013 at  9:32am -0400,
> Merla, ShivaKrishna <ShivaKrishna.Merla@netapp.com> wrote:
> 
> >
> >
> > > -----Original Message-----
> > > From: Mike Snitzer [mailto:snitzer@redhat.com]
> > > Sent: Tuesday, October 29, 2013 7:57 PM
> > > To: Merla, ShivaKrishna
> > > Cc: Hannes Reinecke; dm-devel@redhat.com; agk@redhat.com; Mikulas
> > > Patocka
> > > Subject: Re: [PATCH]dm-mpath: fix for race condition between
> > > multipath_dtr and pg_init_done.
> ...
> > >
> > > So... do you have an updated patch with proper locking that takes
> > > Hannes' patch into consideration?
> > >
> > > I'll be reviewing hannes patch closer (for v3.13) tomorrow so if you'd
> > > like your issue resolved in the near-term I'd appreciate us getting some
> > > closer on proposed solutions.
> > >
> > > Thanks,
> > > Mike
> >
> > I have re-submitted my patch with locking in multipath_dtr. I
> > revisited Hannes patch and I think we still have this issue when
> > multipath is destroyed and path activation work is queued. This is
> > with the scenario of scsi_dh_rdac returning SCSI_DH_RETRY on
> > mode_select due to 5/91/36 CC's.
> 
> OK, I'll work toward including both patches.
Thanks Mike.
