From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: md: Use new topology calls to indicate alignment and
	I/O sizes
Date: Wed, 24 Jun 2009 12:27:19 -0400
Message-ID: <20090624162718.GA17052@redhat.com>
References: <yq1ws73turf.fsf@sermon.lab.mkp.net>
	<170fa0d20906231444t5432998eo8cc2335c6d4a3a0d@mail.gmail.com>
	<19009.42494.925771.283731@notabene.brown>
	<yq1zlbyrzo9.fsf@sermon.lab.mkp.net>
	<19009.50739.830769.821582@notabene.brown>
	<20090624152748.GA16648@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20090624152748.GA16648@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org, dm-devel@redhat.com, Linus Torvalds <torvalds@linux-foundation.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On Wed, Jun 24 2009 at 11:27am -0400,
Mike Snitzer <snitzer@redhat.com> wrote:

> For some reason I thought you were aware of what Martin had put
> together.  I assumed as much given you helped sort out some MD interface
> compile fixes in linux-next relative to topology-motivated changes.
> Anyway, not your fault that you didn't notice the core topology
> support.. It is likely a function of Martin having implemented the MD
> bits; you got this topology support "for free"; whereas I was forced to
> implement DM's topology support (and a few important changes to the core
> infrastructure).

Got these inverted:

> Here is a thread from April that discusses the core of the topology
> support:

http://marc.info/?t=124055146700007&r=1&w=4
 
> This post touches on naming and how userland tools are expected to
> consume the topology metrics:

http://marc.info/?l=linux-ide&m=124058535512850&w=4

> 
> This post talks about the use of sysfs:
> http://marc.info/?l=linux-ide&m=124058543713031&w=4

...

> While I agree that adding these generic topology metrics to 'queue' may
> not be the perfect place I don't feel 'bdi' really helps userland
> understand them any better.  Nor would userland really care.  But I do
> agree that 'bdi' is likely a better place.
> 
> You had mentioned your goal of removing MD's 'queue' entirely. Well DM
> already had that but Martin exposed a minimalist one as part of
> preparations for the topology support, see commit:
> cd43e26f071524647e660706b784ebcbefbd2e44
> 
> This 'bdi' vs 'queue' discussion really stands to cause problems for
> userland.  It would be unfortunate to force tools be aware of 2 places.
> Rather than "phase out legacy usage" of these brand new topology limits
> it would likely be wise to get it right the first time.  Again, I'm OK
> with 'queue'; but Neil if you feel strongly about 'bdi' we should get a
> patch to Linus ASAP for 2.6.31.
> 
> I can take a stab at it now if you don't have time.

On 2nd thought, bdi is inherently tied to mm and doesn't feel 'right';
I'll defer to Martin and Jens on this.

Regards,
Mike
