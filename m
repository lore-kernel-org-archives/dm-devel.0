From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: Re: Improve processing efficiency for addition and
 deletion of multipath devices
Date: Tue, 29 Nov 2016 11:41:42 -0600
Message-ID: <20161129174142.GB3099@octiron.msp.redhat.com>
References: <OF7C96E124.CD19B12D-ON4825806D.00095E60-4825806D.0009BD8C@zte.com.cn>
	<9797787c-30c5-08fb-f92a-5e68ec0b6333@suse.de>
	<OF1D9DC33E.849B3309-ON4825806D.002C52A8-4825806D.003020B2@zte.com.cn>
	<1479289781.14706.16.camel@suse.com>
	<OF233D7062.48FA865C-ON4825806E.000544C5-4825806E.00093C07@zte.com.cn>
	<1479379712.14706.23.camel@suse.com>
	<20161118222618.GZ1972@octiron.msp.redhat.com>
	<1479979270.13566.7.camel@suse.com>
	<20161128184624.GF1972@octiron.msp.redhat.com>
	<1480406238.7926.5.camel@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1480406238.7926.5.camel@suse.com>
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

On Tue, Nov 29, 2016 at 08:57:18AM +0100, Martin Wilck wrote:
> On Mon, 2016-11-28 at 12:46 -0600, Benjamin Marzinski wrote:
> > On Thu, Nov 24, 2016 at 10:21:10AM +0100, Martin Wilck wrote:
> > > =

> > > from the udev db. Therefore IMO we just have to look at the last
> > > received event for a given path:
> > > =

> > > =A0- DELETE =3D> discard the device
> > > =A0- ADD =3D> use the udev properties coming with the event
> > > =A0- CHANGE =3D> query udev db for current set of properties
> > =

> > The issue is that when we get a change event, there may be udev
> > environment variables that tell us what that specific event is for.
> > For
> > instance, a change in the Read-only status of the path device. Future
> > change events will not have those environment variables set.
> =

> And the udev db will not have records of the environment variables of
> previous change events? IOW, in your example, we can't derive the read-
> only status of a device by looking at the current set of udev
> properties of the device, only by tracking the full uevent history?

Correct, when a device's read only status is changed, the kernel will
send a change uevent with the udev environment variable "DISK_RO=3D<n>"
where <n> is 1 if the device changed to read-only, and 0 if it changed
to read-write.  This environment variable is only set for this change
event.

Now, it's totally possible that in every call to uev_update_path,
multipathd could check a device's read-only status in sysfs and take
action if it had changed. Otherwise, it needs to look though all the
change events in the batch it is processing to see if any of them have
the DISK_RO evironment variable set, and it would need to pass this
information to uev_update_path. I personally favor this second approach.
I can easily imagine multipath wanting to deal a specific way with
certain change events, especially if we go the route of ignoring dm
events completely, and relying only on uevents for updating multipath.
In these cases, it may not always be possible to look in sysfs to find
out what caused a previous change event, and we would have to read the
uevent environment variables for all the events we are processing.

-Ben

> =

> Regards
> Martin
> =

> -- =

> Dr. Martin Wilck <mwilck@suse.com>, Tel.=A0+49 (0)911 74053 2107
> SUSE Linux GmbH, GF: Felix Imend=F6rffer, Jane Smithard, Graham Norton
> HRB 21284 (AG N=FCrnberg)
