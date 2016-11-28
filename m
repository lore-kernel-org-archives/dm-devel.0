From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: Re: Improve processing efficiency for addition and
 deletion of multipath devices
Date: Mon, 28 Nov 2016 12:46:24 -0600
Message-ID: <20161128184624.GF1972@octiron.msp.redhat.com>
References: <OF7C96E124.CD19B12D-ON4825806D.00095E60-4825806D.0009BD8C@zte.com.cn>
	<9797787c-30c5-08fb-f92a-5e68ec0b6333@suse.de>
	<OF1D9DC33E.849B3309-ON4825806D.002C52A8-4825806D.003020B2@zte.com.cn>
	<1479289781.14706.16.camel@suse.com>
	<OF233D7062.48FA865C-ON4825806E.000544C5-4825806E.00093C07@zte.com.cn>
	<1479379712.14706.23.camel@suse.com>
	<20161118222618.GZ1972@octiron.msp.redhat.com>
	<1479979270.13566.7.camel@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1479979270.13566.7.camel@suse.com>
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

On Thu, Nov 24, 2016 at 10:21:10AM +0100, Martin Wilck wrote:
> On Fri, 2016-11-18 at 16:26 -0600, Benjamin Marzinski wrote:
> =

> > The issue is that we simply need to work on processing the whole list
> > at
> > a time.=A0=A0Martin's filtering definitely has a place here. He is
> > correct
> > that if we get a delete uevent for a device, we don't need to process
> > any of the earlier ones.=A0=A0We do need to look at both the add and
> > change
> > uevents individually. For instance, one of the change uevents out of
> > a
> > group could be for changing the read-only status of a device. If we
> > just
> > took the most recent, we would miss that information.=A0=A0The good news
> > is
> > that we don't need to actually call uev_add_path and uev_update_path
> > once for each of these events.=A0=A0All we need to do is read through t=
he
> > uev environment variables for all of them to find the information we
> > need (like change in ro status), and then call the function once with
> > that information.
> =

> Do we need to implement the environment-merging ourselves? AFAICS this
> logic is implemented in udev itself. So if the last event for a given
> device is a change event, we'd just need to fetch the device properties
> from the udev db. Therefore IMO we just have to look at the last
> received event for a given path:
> =

>  - DELETE =3D> discard the device
>  - ADD =3D> use the udev properties coming with the event
>  - CHANGE =3D> query udev db for current set of properties

The issue is that when we get a change event, there may be udev
environment variables that tell us what that specific event is for. For
instance, a change in the Read-only status of the path device. Future
change events will not have those environment variables set.  However,
if we want to only call uev_update_path once, we need to know all of the
things that changed, so we need to examine the approriate udev
environment variables for all the change events, so that when we call
uev_update_path, we can take all the necessary actions (in this
instance, changing the Read-only status of the multipath device).

> > At any rate, I'd rather get rid of the gazillion waiter threads
> > first.
> =

> Hm, I thought the threads are good because this avoids one unresponsive
> device to stall everything?

There is work making dm events pollable, so that you can wait for any
number of them with one thread. At the moment, once we get an event, we
lock the vecs lock, which pretty much keeps everything else from
running, so this doesn't really change that.

-Ben
 =

> Martin
> =

> -- =

> Dr. Martin Wilck <mwilck@suse.com>, Tel.=A0+49 (0)911 74053 2107
> SUSE Linux GmbH, GF: Felix Imend=F6rffer, Jane Smithard, Graham Norton
> HRB 21284 (AG N=FCrnberg)
