From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: Re: [RFC Patch 3/3] multipath: add libmpathvalid library
Date: Fri, 3 Apr 2020 16:35:29 -0500
Message-ID: <20200403213529.GE5907@octiron.msp.redhat.com>
References: <1585620055-27112-1-git-send-email-bmarzins@redhat.com>
	<1585620055-27112-4-git-send-email-bmarzins@redhat.com>
	<1e138c8f609a34f7fc6cc244f7516797c5e97a2b.camel@suse.com>
	<20200331173103.GI17313@octiron.msp.redhat.com>
	<5d2bfd10f5325e87cddd31477f2f6c51b1dfee9c.camel@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <5d2bfd10f5325e87cddd31477f2f6c51b1dfee9c.camel@suse.com>
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

On Fri, Apr 03, 2020 at 09:14:58AM +0000, Martin Wilck wrote:
> Hi Ben,
>=20
> On Tue, 2020-03-31 at 12:31 -0500, Benjamin Marzinski wrote:
> > On Tue, Mar 31, 2020 at 03:38:25PM +0000, Martin Wilck wrote:
> > > On Mon, 2020-03-30 at 21:00 -0500, Benjamin Marzinski wrote:
> > > > This library allows other programs to check if a path should be
> > > > claimed
> > > > by multipath.  Currently, it only includes one function,
> > > > mpath_is_path(), which takes a device name, mode to for checking
> > > > the
> > > > path, and an optional info structure, to return the wwid. The
> > > > modes
> > > > work
> > > > mostly like they do for "multipath -c/-u", with a few exceptions.
> > > >=20
> > > > 1. If a device is currently multipathed, it is always VALID. This
> > > > perhaps should be true for the existing path valid code.
> > >=20
> > > AFAICS, this is already the case, except if:
> > >=20
> > >  1 WWID_IS_FAILED is set, i.e. dm_addmap() failed to set up
> > >    the multipath with this WWID last time we tried. In this case
> > > it's
> > >    unlikely that the path is currently multipathed. But there may
> > > be
> > >    some corner case in which your new code would return "valid"
> > >    while the current code would not; possibly if someone set up a
> > >    multipath device with "dmsetup" directly, or because of some
> > > race
> > >    condition. I just realized that we don't check for -EBUSY when
> > > we
> > >    create a map...
> > >=20
> > >    I agree that perhaps the "is_multipath" test should be done
> > > before
> > >    the "failed" test in multipath -u, too.
> > >=20
> > >  2 ignore_wwids is off, and check_wwids_file returned a negative
> > >    result. IMO this logic is correct. But you are the inventor of
> > >    the wwids file, so fine with me to change it.
> > >  =20
> > > And also if multipathd is neither running nor enabled, but see
> > > below.
> >=20
> > See below for my thoughts on its placement
> >=20
> > > > 2. There is no seperate "on" mode. It is instead treated like
> > > > "smart".
> > > > This is because the library only looks at a single path, so it
> > > > can
> > > > only
> > > > say that a device could be multpathed, if there was another
> > > > path.  It
> > > > is
> > > > the caller's job to check if another path exists, or to wait for
> > > > another
> > > > path appear.
> > >=20
> > > I'm not sure if I like this. Returning "no" for the first path and
> > > "yes" for the second and later paths is exactly how
> > > "find_multipaths=3Dyes" is supposed to behave. If that's not useful
> > > for
> > > an application, the application should choose a different mode; and
> > > that's what I believe SID should do (assuming that SID will be the
> > > main
> > > / only user of this API for some time).
> >=20
> > SID just wants to be able to look at one path at a time.  It will be
> > storing the information from previous path runs, so it will be able
> > to
> > check if there are other paths with that wwid.=20
>=20
> That's not an argument against returning "false" for the first path
> (find_multipaths=3Don). If that's not appropriate for SID, and it depends
> on "smart" behavior instead, it could just pass mode=3DMPATH_SMART to
> mpath_is_path(), could it not?=20

SID could very well do that. What not returning "maybe" in this case
really does is make it harder use this code for "multipath -u".
multipath needs to know when it should search for other paths.  It
doesn't want to do so before calling mpath_is_path() (or the cut down
libmultipath part). It wants to know that if other paths with the same
wwid exist, then this path would be valid.

But just looking at the SID case, I don't see the problem.  Say SID
passed down an array of known wwids, and this paths wwid wasn't on the
list.  SID needs to know if it should save this WWID for checking
against future paths, so there should be a special return code for this.
That is exactly what "maybe" means in the SMART case. My v2 code makes
is easy for SID to see what the configured mode is.  In this case, it
could set the delay if multipathd was configured as SMART, and not if it
was configured as FIND.  In reality, SID will probably treat SMART and
FIND the same way.  It will eventually have a persistent database, so it
can remember between boots if it has seen a device before. When that
happens it will probably always treat FIND like SMART. Before that
happens, it will probably treat SMART like FIND. So, I'm not totally
aginst removing the maybe, but it can see how that doing so will make
the code simpler for any user of this library (either SID or multipath
-u)
=20
> > > I really don't want to
> > run coalesce_paths in the library,=20
>=20
> Sorry, I wrote nonsense. Of course "multipath -u" does not call
> coalesce_paths(). It just calls path_discovery() and filter_pathvec(),
> which has basically the same effect as building up a vector of WWIDs.
>=20
> multipath -u currently does one more thing, the open(O_RDONLY|O_EXCL)
> test. I recall we had some controversy about that initially, but it
> doesn't seem to have hurt.

SID's job is to replace all the udev hacks to get devices to be claimed
and set up, with a stateful daemon that had modules for each device
type, written in C. It's job is specifically to know what is using which
device. So these checks were left out intentionally. See below for more
explanation.
=20
> > to search repeatedly for all the
> > paths. It's completely unnecessary, since the information will have
> > already been gotten by previous calls to the library.
>=20
> But IIUC this means that for the 2nd path of a given WWID,
> mpath_is_path() will still return false, because the first path will
> not be multipathed (yet) when the second one appears and is checked by
> udev rules. This would happen both if multipathd was not running, and
> if multipathd was in "find_multipaths=3Don" or "smart" mode. Even for
> path 3 and beyond, the functionality depends on multipathd running and
> doing the right thing.
>=20
> So I gather that SID will rely only partially on this function. By
> comparing the path WWID with WWIDs in its stores, it could conclude
> that a given device was a multipath path, even if mpath_is_path()
> returned false. Correct?=20

yes. SID will have a multipath module that calls this library. That will
live in the SID project, but they will clearly take patches from
multipath developers.

> This bears the risk that the logic of multipathd and SID could
> diverge. It took us a lot of effort to fix the issues arising from=20
> different interpretation of path status between multipathd and
> multipath -u, and I'd recommend not to resuscitate that beast.

You have to elaborate on this risk, because I don't see it. In the v2
code there are 3 non-error states that can be returns

MPATH_IS_NOT_VALID
MPATH_IS_VALID
MPATH_IS_MAYBE_VALID

I will likely add a fourth state MPATH_IS_CLAIMED, that will only be
returned when a path currently is multipathed, to differentiate it from
the others, which state multipath's desire.  But all SID needs to know
is that MPATH_IS_NOT_VALID, means that multipath isn't claiming it now.
MPATH_IS_VALID means that multipath wants to claim it now, and
MPATH_IS_MAYBE_VALID means that multipath would want to claim the device
if another path with the same WWID came around.  I admit, SID will
likely deal with SMART differently than multipath + udev currently does,
but that doesn't effect how it interfaces with multipathd.

> For example, if mpath_is_path() returns false, but SID finds more than
> one path with the given WWID, how would SID know whether was just a
> case of "second path always false", or the WWID was blacklisted or
> failed? Perhaps mpath_is_path() should provide different return codes
> for different reject reasons?

Perhaps there would be more return states necessary, but aside from
MPATH_IS_CLAIMED, I don't see why another state is needed. Maybe I'm
misunderstanding what you mean by "second path always false".

> Thinking about it, the safest bet might be to invent a multipathd cli
> command for this functionality, and ask multipathd about it's own
> judgement about the device's status. We don't do that in udev rules in
> order not to depend on multipathd too much, but for SID it might be an
> option, if it depends on multipathd anyway.

The same issue exists here, where we want to be able to respond quickly.
that's why I'm trying to strip even more unnecessary code out (creating
a lock file just to read if multipathd failed to create the device).

> > To deal with SID, I could have the function take an array of
> > path_info
> > structures holding all the known wwids. This would allow the function
> > to
> > return "No" for the first path in the "find_multipaths=3Dyes" case.
> > However, this would make the library worse for use by "multipath -u",
> > since multipath would have to gather the existing path wwids before
> > it
> > knew if it needed them.
>=20
> The function could gather this information itself in case it needs it.
> Which is what "multipath -u" does, by calling path_discovery() and
> filter_pathvec(). You could pass an optional pathvec argument, and have
> mpath_is_path() call path_discovery() only if that pathvec was NULL /
> empty.

But that's not necessary to do each time, when we can just return the
data to SID, which can store it for future library calls.


I do think that we can move the meat of this library into libmultipath
Here's the claiming logic for my v2 code:

If the device is currently multipathed: valid
If multipathd is not running: not valid
If the device is blacklisted: not valid
If the device does not have a wwid: not valid
If the device wwid is multipathed: valid
If the device failed to be multipathed: not valid
If the mode is GREEDY: valid
If the device wwid is in the wwids file: valid
If the mode is STRICT: not valid
If another path with the same wwid exists: valid
else: maybe valid

Here's the claiming logic for multipath -u

If multipathd is not running: not valid
If the device is blacklisted: not valid
If the device does not have a wwid: not valid
If the device failed to be multipathed: not valid
If the mode is STRICT or FIND and the device is in the wwids file: valid
If the mode is STRICT or FIND and the device is not in the wwids file:
=09not valid
If the device is currently multipathed: valid
If the device has been released to systemd: not valid
If the mode is GREEDY: valid
If the device wwid is multipathed: valid
If the device is not in use and another path with the same wwid exists:
=09valid
If the device is not in use: maybe valid
else: not valid

Differences:

"If the device is currently multipathed" is now first. I think that this
is correct, but I would be willing to move it down. If you get
multipathd into a state where there is a multipath device with what it
thinks are blacklisted paths. When uevent happen on those paths, it
doesn't remove the from the device. So the claiming logic should mirror
that.

"If the device has been released to systemd" doesn't exist. This is by
design, but it could probably use some work.  The idea is that SID (or
anything calling this library) is smarter than udev. The goal of SID is
to move device activation out of udev, and into a daemon that tracks
what is using what device without needing udev rules.  Since SID keeps
track of who has claimed the device, Multipath doesn't need to try and
track if something else was allowed to use the device. On the flip side,
multipath should communicate its ownship a little better.  So, i think
it could have a new state MPATH_IS_CLAIMED. This would only be returned
if the device is currently multipathed. This will make it easy for SID
to know that this device really is claimed by multipath, instead of
multipath simply wanting to claim it. This change is probably not
necessary, since as soon as the multipath device is created, SID get a
uevent for, and could match the WWID with the paths, and claim them for
multipath. But it doesn't hurt anything.

"If the device wwid is multipathed" has been moved above "If the device
wwid is in the wwids file". This means that STRICT will allow the path
event if its not in the wwids file. I think that this is correct on the
same grounds that I think "If the device is currently multipathed"
should be above "If multipathd is not running". It's simply reporing the
actual truth instead of the configured goal. Also, if you look at
ev_add_path(), should_multpath() is only called if the multipath device
doesn't exist. So this is simply matching the claiming behavior to what
multipathd will actually do in this case.

"If the device wwid is multipathed" is also moved above "If the device
failed to be multipathed". Again. If there is currently a multipath
device with that wwid, the the failed file is simply wrong.

"If the device is not in use" doesn't exist.  Again, it is SID (or the
calling program's) job to know if a device is already in use.

Aside from those issues, the checks should return the same results,
unless I'm overlooking something. To make this work for multipath -u we
would have to accept the changes to where "If the device is currently
multipathed" and "If the device wwid is multipathed" are, or move them
in the library code (but like I said, I think the library placement is
more correct to actual multipathd behavior than the multipath -u code
is).

To deal with "If the device has been released to systemd", multipath
would check this if the library returned MPATH_IS_VALID or
MPATH_IS_MAYBE_VALID (but not MPATH_IS_CLAIMED). This would cause a
difference for find_multipaths =3D on or strict.  In this case, once a path
had been released, it would not be claimed simply because it was in the
wwids file.  The path would have to be multipathed.  This doesn't seem
like to big of an issue, but we could always add another return state to
the library, to make this work like it currently does.

To deal with "If the device is not in use", we would simply check this
for "maybe" paths if find_multipaths is "smart".  Since multipath
wouldn't pass any wwids in, this is the case where it currently does
the open O_EXCL check.

-Ben

> > Assuming we are moving the main part of this into libmultipath, I
> > could
> > make that run in two modes. One would be like it currently works and
> > not
> > require the array of wwids, which would be for the "multipath -u"
> > code.
> > The other would require the array, and that would be what
> > libmpathvalid
> > used. Perhaps something as simply as passing -1 for the array length
> > could mean make no assumptions about other paths, and return "maybe",
> > if
> > this path needs a second path in order to be claimed. Then the
> > "multipath -u" could run coalesce_paths() later, if necessary.
> >=20
>=20
> See above.
>=20
>=20
> > > > 3. The library does check if there already is an existing
> > > > multipath
> > > > device with the same wwid, and if so, will declare the path
> > > > valid.
> > >=20
> > > What if there are other paths, not multipathed (yet) but with the
> > > same
> > > wwid as the path in question? The current code checks that by
> > > calling
> > > coalesce_paths() in "dry-run" mode, which would cover both this
> > > case
> > > and your case 3.
> > >=20
> > >=20
> > > > In order to act more library-like, libmpathvalid doesn't set its
> > > > own
> > > > device-mapper log functions. It leaves this to the caller. It
> > > > currently
> > > > keeps condlog() from printing anything, but should eventually
> > > > include
> > > > a
> > > > function to allow the caller set the logging. It also uses a
> > > > statically
> > > > compiled version of libmultipath, both to keep that library from
> > > > polluting the namespace of the caller, and to avoid the caller
> > > > needing
> > > > to set up the variables and functions (like logsink, and
> > > > get_multipath_config) that it expects.
> > >=20
> > > All fair, but I'd prefer a solution where we use as much common
> > > code
> > > as possible, to avoid bit rot of either code path in the future.
> > > Your
> > > new function has the advantage to be much better readable than the
> > > current code in multipath/main.c. Maybe we can find a way to use it
> > > from "multipath -u"? The mentioned semantic changes are minor and
> > > could
> > > be resolved (not sure about the coalesce_paths() call, I guess you
> > > had
> > > a reason to skip it).
> > >=20
> > > The namespace issue could be fixed by using=20
> > > "-fvisibility=3Dhidden" and using explicit visibility attributes for
> > > those functions we want to export. The logsink and
> > > get_multipath_config
> > > issues should be solvable by using a sane default implementation
> > > and
> > > allowing applications to change it.
> > >=20
> > > Both would be improvements for libmultipath that we should have
> > > made
> > > long ago.
> >=20
> > Having libmultipath store logsink and get_multipath_config, and
> > making
> > getter and setter functions would be great. But I'm worried that
> > making
> > that change might mess with current users of libmpathpersist.
> >=20
> > There are still a number of functions that multipath, multipathd, and
> > libmpathpersist need from libmultipath, that libmpathvalid doesn't,
> > but
> > -fvisibility=3Dhidden would fix a large part of my dislike with the
> > namesapce polution. I'm still not crazy about telling people to link
> > against a library with a number of exposed, undocumented functions,
> > but
> > we already been doing it for a while with libmpathpersist.
>=20
> Hm, yes I think libmpathpersist uses quite a bit of libmultipath.
> And well, multipath and libmultipath use essentially every symbol.
> So right, a simplistic -fvisibility=3Dhidden won't work.
>=20
> Regards
> Martin
>=20
>=20
> --=20
> Dr. Martin Wilck <mwilck@suse.com>, Tel. +49 (0)911 74053 2107
> SUSE  Software Solutions Germany GmbH
> HRB 36809, AG N=FCrnberg GF: Felix
> Imend=F6rffer
>=20
