From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH 00/24] dm-raid456 support using md/raid5.c,
 now with dirty-log
Date: Fri, 18 Jun 2010 13:52:31 +1000
Message-ID: <20100618135231.124065ef@notabene.brown>
References: <20100601094414.565.3638.stgit@notabene.brown>
	<1276608206.22425.11.camel@o>
	<20100616094518.5aa632fd@notabene.brown>
	<1276687587.22425.62.camel@o>
	<20100617154131.3920fee0@notabene.brown>
	<1276771620.10854.18.camel@o>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1276771620.10854.18.camel@o>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: heinzm@redhat.com
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Thu, 17 Jun 2010 12:47:00 +0200
Heinz Mauelshagen <heinzm@redhat.com> wrote:

> On Thu, 2010-06-17 at 15:41 +1000, Neil Brown wrote:
> > On Wed, 16 Jun 2010 13:26:27 +0200
> > Heinz Mauelshagen <heinzm@redhat.com> wrote:
> > 
> > > On Wed, 2010-06-16 at 09:45 +1000, Neil Brown wrote:
> > > > Hi Heinz,
> > > > 
> > > > On Tue, 15 Jun 2010 15:23:26 +0200
> > > > Heinz Mauelshagen <heinzm@redhat.com> wrote:
> > > > 
> > > > > 
> > > > > Neil,
> > > > > 
> > > > > for missing devices we (re)load the table with error mapped device(s) in
> > > > > their place rather than identifying them with a special char/string.
> > > > > Did you go for the later in order to avoid some MD hassle with error
> > > > > targets being accessed by the MD personalities? If not so, we can drop
> > > > > the special '-' char support to identify missing devices.
> > > > 
> > > > When raid5 determines that a device has failed and so it will not write to it
> > > > again, it must be sure that the failure is record in the metadata before it
> > > > proceeds with that decision not to even try writing to the failed device.
> > > 
> > > Yes, that's the mandatory order to avoid data loss.
> > > 
> > > > Otherwise a crash/restart before the metadata was safely updated would result
> > > > in corruption.
> > > > 
> > > > This means that it must be possible for user-space to explicitly tell the
> > > > raid5 that a device is known to be faulty.
> > > > Doing that through the constructor seems the natural way to do it.
> > > 
> > > If /dev/mapper/error with an error target mapping would be used instead,
> > > would that cause consistency troubles to the MD personality if accessing
> > > those rather than the NULL device solution with the '-' argument you
> > > have now?
> > > If not so, we could drop the '-' support, which I'm aiming at.
> > > 
> > 
> > I would need to differentiate between /dev/mapper/error (where errors are
> > expected) and any other device (where errors are not expected).  How do you
> > propose I do that?
> 
> Is that differentiation mandatory for the MD personality at all?

I thought we had already agreed that it was.

If the metadata records that a device is working, then raid5 will not expect
an error and if it gets one it must wait for the metadata to be updated.
If the metadata records that a device is not working, then raid5 will never
bother even trying to write to that device.

So yes, and important distinction.

I imagine that the dmevent handler would handle a failure by updating the
metadata, then dismantling the array and recreating it with the failed device
missing.  Given that in some cases it would want to do this anyway to
introduce a spare, and as I think this is how dm-raid1 errors are handled, it
seems the logical approach.
I note that your dm-raid45 code uses a message to "allow_writes".
Using that could be racy unless you suspend the device before updating the
metadata, and if you do that you may as well use the suspend/resume sequence
as part of re-enabling writes. (???)

This is probably just a question of interface design, and we both naturally
prefer the one we came up with first :-)

I guess it just feels clumsy for the raid5 driver to have to try to read and
fail rather than simply being told up front not to bother trying.
With md/raid5, a read failure will be followed by an attempt to write out the
good data in case it was a simple media error.  Having it do that every time
you start a degraded array seems extra pointless....


> 
> You'll get immediate and durable errors from the error target and hence
> you'd instantly drop the leg.
> 
> > 
> > > > 
> > > > > 
> > > > > I'm thinking about adding a ctr wrapper to allow us to keep the "raid45"
> > > > > ctr interfaces semantics (ie. the arguments) and the new interface to
> > > > > "raid456" if you don't have objections. That would be implemented by 2
> > > > > targets being registered implemented in one module.
> > > > 
> > > > I have no strong objections, though having two targets that do almost the
> > > > same things seems rather ugly.
> > > 
> > > Keep in mind it'll only be another target_type structs, another
> > > raid_ctr() function plus another (de)registration of the respective
> > > target. The ctr functions for raid45 and raid456 can share moset of the
> > > code anyway.
> > 
> > Sure.
> > 
> > > 
> > > > 
> > > > Is there existing published code that uses the extra arguments to raid45?
> > > 
> > > Yes, dmraid with a list of RAID5 supporting metadata format handlers.
> > 
> > I just had a look at the latest dmraid from CVS and the only place that I can
> > find where a raid45 target is created is in lib/activate/activate.c in
> > _dm_raid45_bol.
> > This only uses arguments that my code understands.
> > What am I missing?
> 
> I was arguing against breaking API compatibility.
> dm-raid45.c is being shipped by distros.
> 

Shipped by distros which all have an 'upstream first' policy, and are fully
aware of the possible consequences of not following it :-)

I'm not really that fussed about the API.  I don't like seeing APIs that I
think are badly designed go into Linux, but plenty of them do and one more
isn't going to make much difference.

Approving an API is really a job for the dm maintainer.  Is that Alasdair?
Having stated my case I'm happy to accept whatever he prefers.

NeilBrown

> Thanks,
> Heinz
> 
> > Thanks,
> > NeilBrown
> 
