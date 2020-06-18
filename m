From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: Re: [PATCH 0/7] Fix muitpath/multipathd flush issue
Date: Thu, 18 Jun 2020 13:04:58 -0500
Message-ID: <20200618180458.GI5894@octiron.msp.redhat.com>
References: <1592439867-18427-1-git-send-email-bmarzins@redhat.com>
	<f60b8ea30ee0ce68a46ce8f5c9ebaee6314d57e4.camel@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <f60b8ea30ee0ce68a46ce8f5c9ebaee6314d57e4.camel@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Content-Disposition: inline
To: Martin Wilck <Martin.Wilck@suse.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Thu, Jun 18, 2020 at 09:00:49AM +0000, Martin Wilck wrote:
> On Wed, 2020-06-17 at 19:24 -0500, Benjamin Marzinski wrote:
> >=20
> > One source of complexity in these patches is that multipath suspends
> > the
> > device with flushing before removing it, while multipathd
> > doesn't.  It
> > does seem possible that the suspend could hang for a while, so I can
> > understand multipathd not using it.  However, that would take the
> > multipath device getting opened and IO being issued, between the time
> > when _dm_flush_map() verifies that the device isn't opened, and when
> > it
> > suspends the device.  But more importantly, I don't understand how
> > suspending the device is useful. =20
>=20
> I've looked up the origin of 9a4ff93 in SUSE bugzilla. The problem that
> the patch tried to solve was that if map without healthy paths and with
> queue_if_no_path set was removed, the removal might fail with=20
> "map is in use".  Hannes' comment at the time was this:
>=20
>  "Problem is that we're not waiting for all outstanding I/Os to
>  complete. So the check for 'map in use' might trigger a false
>  positive, as the outstanding I/O will keep the map busy. Once it's
>  finished we can remove the map."
>=20
>  "I'll add an explicit 'suspend/resume' cycle here, which will wait for
>  all outstanding I/O to finish. That should resolve the situation."
>=20
> Thus setting queue_if_no_paths =3D 0 and doing a suspend/resume was
> basically a trick to force dm to flush outstanding IO.

I get the intention, I just don't think it currently is doing anything.

> > If the device were to be opened
> > between when _dm_flush_map() checks the usage, and when it tries to
> > delete the device, device-mapper would simply fail the remove.  And
> > if
> > the device isn't in use, there can't be any outstanding IO to flush.
> > When this code was added in commit 9a4ff93, there was no check if the
> > device was in use,
>=20
> Hm, I see this in the code preceding 9a4ff93:
>=20
> extern int
> _dm_flush_map (const char * mapname, int need_sync)
> {
> [...]
>         if (dm_get_opencount(mapname)) {
>                 condlog(2, "%s: map in use", mapname);
>                 return 1;
>         }
>=20
> ... so it seems that there was a check, even back then.

oops. I missed that.=20

> >  and disabling queue_if_no_path could cause anything
> > that had the device open to error out and close it. But now that
> > multipath checks first if the device is open, I don't see the benefit
> > to
> > doing this anymore. Removing it would allow multipathd and multipath
> > to
> > use the same code to remove maps. Any thoughts?
>=20
> With queue_if_no_paths, there could be outstanding IO even if the
> opencount was 0.

This is what I don't accept at face value. I wrote a little test
program that fired off an async read, closed the fd without waiting for
a response, and then tried to exit.  running this on a queueing
multipath device causes the exit to hang like this

 cat /proc/22655/task/22655/stack
[<0>] exit_aio+0xdc/0xf0
[<0>] mmput+0x33/0x130
[<0>] do_exit+0x27f/0xb30
[<0>] do_group_exit+0x3a/0xa0
[<0>] __x64_sys_exit_group+0x14/0x20
[<0>] do_syscall_64+0x5b/0x160
[<0>] entry_SYSCALL_64_after_hwframe+0x44/0xa9
[<0>] 0xffffffffffffffff

and the multipath device to remain in use

# dmsetup info mpathb
Name:              mpathb
State:             ACTIVE
Read Ahead:        256
Tables present:    LIVE
Open count:        0
Event number:      7
Major, minor:      253, 5
Number of targets: 1
UUID: mpath-3600d0230000000000e13954ed5f89301

I've asked around, and device-mapper is certainly supposed to flush all
IO before the last close. Of course, there may be a corner case where it
doesn't. If you know of one, that would be worth sharing.

What I think that flush previously accomplished is that, just like the
flush_on_last_del code, if you stop queueing and error out the IO, then
whatever is waiting on it will get those errors, and likely close the
device soon after, hopefully in time for multipath to remove the device.

However, since multipath now checks if the device is in use before
disabling queue_if_no_path, it don't think this code is actually helpful
right now.

> This IO must be flushed somehow before the map can be
> removed. Apparently just setting queue_if_no_path =3D 0 was not enough,
> that's why Hannes added the suspend/resume. Maybe today we have some
> better way to force the flush? libdm has the _error_device() function=20
> (aka dmsetup wipe_table) that replaces the map's table by the error
> target. But this does a map reload, which implies a suspend, too.
> Perhaps simply an fsync() on the dm device, or just wait a while until
> all outstanding IO has errored out? But these alternatives don't
> actually look better to me than Hannes' suspend/resume, they will take
> at least as much time. Do you have a better idea?

To go back to the old behavior, we would need to move the check if the
device is in use until after we suspended the device. Or we can keep the
current behavior, and simply remove the flushing and suspending.

> multipathd=20
>=20
> Regards
> Martin
>=20
> --=20
> Dr. Martin Wilck <mwilck@suse.com>, Tel. +49 (0)911 74053 2107
> SUSE  Software Solutions Germany GmbH
> HRB 36809, AG N=FCrnberg GF: Felix
> Imend=F6rffer
>=20
