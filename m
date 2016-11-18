From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: Re: Improve processing efficiency for addition and
 deletion of multipath devices
Date: Fri, 18 Nov 2016 16:26:18 -0600
Message-ID: <20161118222618.GZ1972@octiron.msp.redhat.com>
References: <OF7C96E124.CD19B12D-ON4825806D.00095E60-4825806D.0009BD8C@zte.com.cn>
	<9797787c-30c5-08fb-f92a-5e68ec0b6333@suse.de>
	<OF1D9DC33E.849B3309-ON4825806D.002C52A8-4825806D.003020B2@zte.com.cn>
	<1479289781.14706.16.camel@suse.com>
	<OF233D7062.48FA865C-ON4825806E.000544C5-4825806E.00093C07@zte.com.cn>
	<1479379712.14706.23.camel@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1479379712.14706.23.camel@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Martin Wilck <mwilck@suse.com>
Cc: dm-devel@redhat.com, tang.junhui@zte.com.cn
List-Id: dm-devel.ids

My $.02

I'm not sure that we want to wait for a predetermined time to grab the
uevents.  If they are coming in slowly, multipathd is more responsive by
processing them immediately, and if they are coming in a storm, they
will naturally pile up faster than we deal with them. I also don't
really like the idea of waiting when we get an event to see if another
one comes along, for the same reasons. That being said, I wouldn't NACK
an config option (turned off by default) that set a minimum wait time
between uevent dispatches, because I might be wrong here.  However, It
sees like what uevent_dispatch() dispatch already does is the right
thing, which is to pull all oustanding uevents off the uevent queue into
a new list.

The issue is that we simply need to work on processing the whole list at
a time.  Martin's filtering definitely has a place here. He is correct
that if we get a delete uevent for a device, we don't need to process
any of the earlier ones.  We do need to look at both the add and change
uevents individually. For instance, one of the change uevents out of a
group could be for changing the read-only status of a device. If we just
took the most recent, we would miss that information.  The good news is
that we don't need to actually call uev_add_path and uev_update_path
once for each of these events.  All we need to do is read through the
uev environment variables for all of them to find the information we
need (like change in ro status), and then call the function once with
that information.

Hannes pointed out that for adding paths we don't need to do any locking
until we want to add the path to the pathvec. We could grab all the
outstanding add events from the list that gets passed to service_uevq,
and collect the pathinfo for all the paths, add them all into the
pathvec, and then create or update the multipath devices. delete uevents
could work similarly, where we find all the paths for a multipath device
in our list, remove them all, and reload the device once.

I'm not sure how much a separate thread for doing the multipath work
would buy us, however. It's true that we could have a seperate lock for
the mpvec, so we didn't need to hold the pathvec lock while updating the
mpvec, but actually updating the mpvec only takes a moment. The time
consuming part is building the multipath device and passing it to the
kernel. For this, we do need the the paths locked. Otherwise what would
keep a path from getting removed while the multipath device was using it
to set get set up. If working with multipath devices and proccessing
path uevents is happening at the same time, this is a very real
possibility.

But even if we keep one thread processing the uevents, simply avoiding
calling uev_add_path and uev_update_path for repeated add and change
events, and batching multiple add and delete events together could
provide a real speedup, IMHO.

Now, the holy grail of multipathd efficiency would be to totally rework
multipathd's locking into something sensible.  We could have locks for
the vectors that only got held when you were actually traversing or
manipulating the vectors, coupled with reference counts on the
individual paths and multipaths, so that they didn't get removed while
they were in use, and probably locks on the individual paths and
multipaths for just the sections that really needed to be protected.
The problem is that this would take a huge amount of code auditting to
get mostly right, and then a while to flush out all the missed corner
cases.  At least I think it would. But I dismissed decoupling the config
structure from the vecs lock as too painful, and clearly that was
possible.

At any rate, I'd rather get rid of the gazillion waiter threads first.

-Ben

On Thu, Nov 17, 2016 at 11:48:32AM +0100, Martin Wilck wrote:
> Hi Tang,
> =

> > As to process several uevents for the same physical devices, I think
> > the opinions=A0
> > different between us is "FILTER" or "MERGER". Personally, I think
> > Merger is more=A0
> > accuracy, for example, we receive 4 paths addition uevent messages
> > from the same=A0
> > physical devices:=A0
> > 1)uevent add sdb=A0
> > 2)uevent add sdc=A0
> > 3)uevent add sdd=A0
> > 4)uevent add sde=A0
> > =

> > We cannot just filter the 1)2)3) uevent messages but only process the
> > 4)uevent message,=A0
> > which would cause losing paths of this multipath devices.=A0
> =

> Of course. My "filtering" idea was meant for cases where several events
> for the same device are queued, e.g.
> =

>   1) add sda
>   2) change sda
>   3) delete sda
> =

> Is it always sufficient to look only at the last event in such a case?
> I think so, but I'm not 100% certain.
> =

> Regards
> Martin
