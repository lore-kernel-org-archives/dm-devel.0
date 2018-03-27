From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: Re: [PATCH v2 17/20] multipath.rules: find_multipaths
	"smart" logic
Date: Tue, 27 Mar 2018 18:07:06 -0500
Message-ID: <20180327230706.GY3103@octiron.msp.redhat.com>
References: <20180319150155.5363-1-mwilck@suse.com>
	<20180319150155.5363-18-mwilck@suse.com>
	<20180327210339.GX3103@octiron.msp.redhat.com>
	<1522186440.13140.47.camel@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1522186440.13140.47.camel@suse.com>
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
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Tue, Mar 27, 2018 at 11:34:00PM +0200, Martin Wilck wrote:
> On Tue, 2018-03-27 at 16:03 -0500, Benjamin Marzinski wrote:
> > On Mon, Mar 19, 2018 at 04:01:52PM +0100, Martin Wilck wrote:
> > > When the first path to a device appears, we don't know if more
> > > paths are going
> > > to follow. find_multipath "smart" logic attempts to solve this
> > > dilemma by
> > > waiting for additional paths for a configurable time before giving
> > > up
> > > and releasing single paths to upper layers.
> > > =

> > > These rules apply only if both find_multipaths is set to "smart" in
> > > multipath.conf. In this mode, multipath -u sets
> > > DM_MULTIPATH_DEVICE_PATH=3D2 if
> > > there's no clear evidence wheteher a given device should be a
> > > multipath member
> > > (not blacklisted, not listed as "failed", not in WWIDs file, not
> > > member of an
> > > exisiting map, only one path seen yet).
> > > =

> > > In this case, pretend that the path is multipath member, disallow
> > > further
> > > processing by systemd (allowing multipathd some time to grab the
> > > path),
> > > and check again after some time. If the path is still not
> > > multipathed by then,
> > > pass it on to systemd for further processing.
> > > =

> > > The timeout is controlled by the "find_multipaths_timeout" config
> > > option.
> > > Note that delays caused by waiting don't "add up" during boot,
> > > because the
> > > timers run concurrently.
> > > =

> > > Implementation note: This logic requires obtaining the current
> > > time. It's not
> > > trivial to do this in udev rules in a portable way, because
> > > "/bin/date" is
> > > often not available in restricted environments such as the initrd.
> > > I chose
> > > the sysfs method, because /sys/class/rtc/rtc0 seems to be quite
> > > universally
> > > available. I'm open for better suggestions if there are any.
> > =

> > I have a couple of code issues, that I'll point out below, but I have
> > an
> > overall question.  If multipath exists in the initramfs, and a device
> > is
> > not claimed there, then after the pivot, multipath will not
> > temporarily
> > claim it, correct? =

> =

> Incorrect, it will do the temporary claim.
> =

> >  I'm pretty sure, but not totally certain, that udev
> > database persists between the udev running in the initramfs and the
> > regular system.
> =

> That's only true for devices that set OPTIONS+=3D"db_persist", and dracut
> sets this only for dm and md devices. For other devices,
> /usr/lib/systemd/system/initrd-udevadm-cleanup-db.service cleans up the
> udev data base, and devices are seen as "new" during coldplug. So, if
> there's still only one path and no other information (e.g. wwids file)
> after pivot, we'll wait.
> =

> >  On the other hand, if multipth isn't in the initramfs
> > but it is in the regular system, then AFAICS, once the system pivots
> > to
> > the regular fs, there is nothing to warn multipath that these devices
> > could already be in use, correct? =

> =

> Correct.
> =

> >  So, even if you don't need to
> > multipath any devices in your initramfs, you will need multipath in
> > your
> > initramfs, or it could go setting devices to not ready. right?
> =

> The following happens: multipath -u temporarily claims the device. When
> multipathd starts, it fails to set up the map, sets the "failed"
> marker, and retriggers udev. The second time, multipath -u unclaims the
> device because it recognizes it as failed.

But if that device is already in use because multipath didn't claim it
in the initramfs, and you suddenly mark it as ENV{SYSTEMD_READY}=3D"0",
this can cause systemd to automatically unmount any filesystem on it.
This isn't just a problem with Red Hat's setup.  If it's not a
configured device type, there will only be a short timeout, but that's
still enough to mess with devices that are already in use.  I'm pretty
sure that the multipath temporary claiming is only safe the very first
time a device appears. Otherwise, it's possible that something else will
claim it first, and then multipath will claim it and mess with that
other user.

> I admit I haven't tested the default Red Hat setup with a very
> restrictive multipath.conf in the initrd. But I'm pretty certain that
> in that case, the same thing happens.
> I'd be grateful if you could give it a try :-)
> =

> > =

> > > =

> > > Signed-off-by: Martin Wilck <mwilck@suse.com>
> > > ---
> > >  multipath/multipath.rules | 80
> > > +++++++++++++++++++++++++++++++++++++++++++++--
> > >  1 file changed, 78 insertions(+), 2 deletions(-)
> > > =

> > > diff --git a/multipath/multipath.rules b/multipath/multipath.rules
> > > index aab64dc7182c..32d33991db3d 100644
> > > --- a/multipath/multipath.rules
> > > +++ b/multipath/multipath.rules
> > > @@ -21,7 +21,83 @@ TEST!=3D"$env{MPATH_SBIN_PATH}/multipath",
> > > ENV{MPATH_SBIN_PATH}=3D"/usr/sbin"
> > >  =

> > >  # multipath -u sets DM_MULTIPATH_DEVICE_PATH
> > >  ENV{DM_MULTIPATH_DEVICE_PATH}!=3D"1",
> > > IMPORT{program}=3D"$env{MPATH_SBIN_PATH}/multipath -u %k"
> > > -ENV{DM_MULTIPATH_DEVICE_PATH}=3D=3D"1",
> > > ENV{ID_FS_TYPE}=3D"mpath_member", \
> > > -	ENV{SYSTEMD_READY}=3D"0"
> > > +
> > > +# case 1: this is definitely multipath
> > > +ENV{DM_MULTIPATH_DEVICE_PATH}=3D=3D"1", \
> > > +	ENV{ID_FS_TYPE}=3D"mpath_member", ENV{SYSTEMD_READY}=3D"0", \
> > > +	ENV{FIND_MULTIPATHS_WAIT_UNTIL}=3D"finished", \
> > > +	GOTO=3D"end_mpath"
> > > +
> > > +# case 2: this is definitely not multipath
> > > +ENV{DM_MULTIPATH_DEVICE_PATH}!=3D"2", \
> > > +	ENV{FIND_MULTIPATHS_WAIT_UNTIL}=3D"finished", \
> > > +	GOTO=3D"end_mpath"
> > > +
> > > +# All code below here is only run in "smart" mode.
> > > +
> > > +# FIND_MULTIPATHS_WAIT_UNTIL is the timeout (in seconds after the
> > > +# epoch). If waiting ends for any reason, it is set to "finished".
> > > +IMPORT{db}=3D"FIND_MULTIPATHS_WAIT_UNTIL"
> > > +
> > > +# At this point we know DM_MULTIPATH_DEVICE_PATH=3D=3D2.
> > > +# (multipath -u indicates this is "maybe" multipath)
> > > +
> > > +# case 3: waiting has already finished. Treat as non-multipath.
> > > +ENV{FIND_MULTIPATHS_WAIT_UNTIL}=3D=3D"finished", \
> > > +	ENV{DM_MULTIPATH_DEVICE_PATH}=3D"", GOTO=3D"end_mpath"
> > > +
> > > +# The timeout should have been set by the multipath -u call above,
> > > set a default
> > > +# value it that didn't happen for whatever reason
> > > +ENV{FIND_MULTIPATHS_PATH_TMO}!=3D"?*",
> > > ENV{FIND_MULTIPATHS_PATH_TMO}=3D"5"
> > > +
> > =

> > This code adds three more callouts.  I know that the udev people
> > dislike
> > these, and they do eat up time that can cause udev to timeout on busy
> > systems.  To avoid the overhead of these execs, as well as to make
> > the
> > rules simpler, what do you thing about moving the =

> > =

> > IMPORT{db}=3D"FIND_MULTIPATHS_WAIT_UNTIL"
> > =

> > line before the "multipath -u" call, and passing that as a parameter
> > if
> > present.  Then multipath could check the current time and compare it.
> > It could also return an updated FIND_MULTIPATHS_WAIT_UNTIL as a udev
> > environment variable, instead of returning FIND_MULTIPATHS_PATH_TMO,
> > and
> > forcing udev to calculate the new timeout. That would remove the need
> > for the other PROGRAM calls.
> =

> That's a nice idea. Why didn't I have it?
> =

> Martin
> =

> -- =

> Dr. Martin Wilck <mwilck@suse.com>, Tel. +49 (0)911 74053 2107
> SUSE Linux GmbH, GF: Felix Imend=F6rffer, Jane Smithard, Graham Norton
> HRB 21284 (AG N=FCrnberg)
