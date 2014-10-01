From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm-raid: add RAID discard support
Date: Wed, 1 Oct 2014 09:32:37 -0400
Message-ID: <20141001133237.GB16521@redhat.com>
References: <1411491106-23676-1-git-send-email-heinzm@redhat.com>
	<yq18ulaszpk.fsf@sermon.lab.mkp.net>
	<20140924093308.120fe616@notabene.brown>
	<yq1zjdpsqry.fsf@sermon.lab.mkp.net>
	<7C39EB56-623A-4318-A558-258ABA32FF12@redhat.com>
	<20140924142157.33475baa@notabene.brown>
	<5422A4C4.4020707@redhat.com>
	<20141001125625.1e0d356a@notabene.brown>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20141001125625.1e0d356a@notabene.brown>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: NeilBrown <neilb@suse.de>
Cc: Heinz Mauelshagen <heinzm@redhat.com>, device-mapper development <dm-devel@redhat.com>, Shaohua Li <shli@kernel.org>, "Martin K. Petersen" <martin.petersen@oracle.com>
List-Id: dm-devel.ids

On Tue, Sep 30 2014 at 10:56pm -0400,
NeilBrown <neilb@suse.de> wrote:

> On Wed, 24 Sep 2014 13:02:28 +0200 Heinz Mauelshagen <heinzm@redhat.com>
> wrote:
> 
> > 
> > Martin,
> > 
> > thanks for the good explanation of the state of the discard union.
> > Do you have an ETA for the 'zeroout, deallocate' ... support you mentioned?
> > 
> > I was planning to have a followup patch for dm-raid supporting a dm-raid 
> > table
> > line argument to prohibit discard passdown.
> > 
> > In lieu of the fuzzy field situation wrt SSD fw and discard_zeroes_data 
> > support
> > related to RAID4/5/6, we need that in upstream together with the initial 
> > patch.
> > 
> > That 'no_discard_passdown' table line can be added to dm-raid RAID4/5/6 
> > table
> > lines to avoid possible data corruption but can be avoided on RAID1/10 
> > table lines,
> > because the latter are not suffering from any  discard_zeroes_data flaw.
> > 
> > 
> > Neil,
> > 
> > are you going to disable discards in RAID4/5/6 shortly
> > or rather go with your bitmap solution?
> 
> Can I just close my eyes and hope it goes away?
> 
> The idea of a bitmap of uninitialised areas is not a short-term solution.
> But I'm not really keen on simply disabling discard for RAID4/5/6 either. It
> would  mean that people with good sensible hardware wouldn't be able to use
> it properly.
> 
> I would really rather that discard_zeroes_data were only set on devices where
> it was actually true.  Then it wouldn't be my problem any more.
> 
> Maybe I could do a loud warning
>   "Not enabling DISCARD on RAID5 because we cannot trust committees.
>    Set "md_mod.willing_to_risk_discard=Y" if your devices reads discarded
>    sectors as zeros"
> 
> and add an appropriate module parameter......

I had the same thought and would be happy with this too.  I was going to
update Heinz's patch to have the same default off but allow user to
enable:
https://git.kernel.org/cgit/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=for-next&id=8e0cff64f35971135a6de7907bbc8c3a010aff8f

But I'd love to just follow what you arrive at with MD (using the same
name for the module param in dm-raid).

I'm open to getting this done now and included in 3.18 if you are.

Mike
