From: Neil Brown <neilb@suse.de>
Subject: Re: md: Use new topology calls to indicate alignment and I/O  sizes
Date: Thu, 25 Jun 2009 09:28:24 +1000
Message-ID: <19010.46744.848750.641185@notabene.brown>
References: <yq1ws73turf.fsf@sermon.lab.mkp.net>
	<170fa0d20906231444t5432998eo8cc2335c6d4a3a0d@mail.gmail.com>
	<19009.42494.925771.283731@notabene.brown>
	<yq1zlbyrzo9.fsf@sermon.lab.mkp.net>
	<19009.50739.830769.821582@notabene.brown>
	<20090624152748.GA16648@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Mike Snitzer on Wednesday June 24
Sender: linux-raid-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, linux-raid@vger.kernel.org, Linus Torvalds <torvalds@linux-foundation.org>, Alasdair G Kergon <agk@redhat.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

On Wednesday June 24, snitzer@redhat.com wrote:
> 
> 
> Hi Neil,
> 
> For some reason I thought you were aware of what Martin had put
> together.  I assumed as much given you helped sort out some MD interface
> compile fixes in linux-next relative to topology-motivated changes.
> Anyway, not your fault that you didn't notice the core topology
> support.. It is likely a function of Martin having implemented the MD
> bits; you got this topology support "for free"; whereas I was forced to
> implement DM's topology support (and a few important changes to the core
> infrastructure).
> 
> Here is a thread from April that discusses the core of the topology
> support:
> http://marc.info/?l=linux-ide&m=124058535512850&w=4

Thanks for these.
I see they were mainly on linux-ide and linux-scsi, neither of which I
read.  They also eventually made an appearance on linux-kernel, but it
is only by luck that I find important stuff there.

Yes, I have been aware of it for a while but had my mind on other
things and figured other people could probably get the details right
without me interfering....

> 
> This post touches on naming and how userland tools are expected to
> consume the topology metrics:
> http://marc.info/?t=124055146700007&r=1&w=4
> 
> This post talks about the use of sysfs:
> http://marc.info/?l=linux-ide&m=124058543713031&w=4
> 
> 
> Martin later shared the following with Alasdair and I and it really
> helped smooth out my understanding of these new topology metrics (I've
> updated it to reflect the current naming of these metrics):

Thanks for this - quite helpful.  I might refer to bit in my reply to
Martin.

> > > 
> > > That being said I don't have a problem moving the limits somewhere else
> > > if that's what people want to do.  I agree that the current sysfs
> > > location for the device limits is mostly a function of implementation
> > > and backwards compatibility.
> > 
> > Who do I have to get on side for you to be comfortable moving the
> > various metrics to 'bdi' (leaving legacy duplicates in 'queue' where
> > that is necessary) ??  i.e. which people need to want it?
> 
> While I agree that adding these generic topology metrics to 'queue' may
> not be the perfect place I don't feel 'bdi' really helps userland
> understand them any better.  Nor would userland really care.  But I do
> agree that 'bdi' is likely a better place.
> 
> You had mentioned your goal of removing MD's 'queue' entirely. Well DM
> already had that but Martin exposed a minimalist one as part of
> preparations for the topology support, see commit:
> cd43e26f071524647e660706b784ebcbefbd2e44

Oh yuck.  I wasn't aware of that.  This is just horrible.
> 
> We _could_ then backout cd43e26f071524647e660706b784ebcbefbd2e44 too?

please please please please please!

(I haven't really paid attention, but I thought everything always had
 a 'queue' - I just ignored in on md devices because it didn't mean
 anything).

NeilBrown
