From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: Re: [PATCH 0/3] New approach at handling changed WWIDs
Date: Fri, 22 Mar 2019 09:13:47 -0500
Message-ID: <20190322141347.GO13295@octiron.msp.redhat.com>
References: <20190318121235.8942-1-mwilck@suse.com>
	<20190319171115.GF13295@octiron.msp.redhat.com>
	<402a4da867abb74c04511e98623e5abb6b144b7e.camel@suse.com>
	<5af82a40b76e39542742a3df349d00d32351d7cd.camel@suse.com>
	<20190321223117.GN13295@octiron.msp.redhat.com>
	<45b8e5fd8bfe0806a7ef001f3dbb127669ad7789.camel@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <45b8e5fd8bfe0806a7ef001f3dbb127669ad7789.camel@suse.com>
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
Cc: mwilck+gmail@suse.de, dm-devel@redhat.com
List-Id: dm-devel.ids

On Fri, Mar 22, 2019 at 12:28:56PM +0100, Martin Wilck wrote:
> On Thu, 2019-03-21 at 17:31 -0500, Benjamin Marzinski wrote:
> > =

> > ideally, we would be able to determine whether or not udev was able
> > to
> > get all the necessary information. It would be nice to be notified if
> > scsi_id failed or udev timed out.
> =

> The latter (udev timeout) won't work without significant changes to
> udev/systemd. Currently udevd simply kills hanging workers with
> SIGKILL, and doesn't bother to send an "incomplete uevent" message to
> monitor listeners.
> =

> What we *might* do in multipathd is listen for kernel uevents _and_
> udev uevents, and figuring out possible problems by relating and
> comparing them. It would be a non-trivial task; we'd have to deal with
> the possibility that kernel events might get lost, or might have
> happened before multipathd was started. During startup, this wouldn't
> help us. Rather, it would enable us to react on events during runtime
> which we currently miss. I see this as a feature enhancement -
> possible, but really hard to get right, and not directly related to the
> problems we are currently dealing with.
> =

> If we look at udev information for a block device (either during device
> probing or uevent processing), and the WWID is not set but some other
> properties (e.g. ID_PATH) are, we can be pretty sure that scsi_id or
> sg_inq have failed during processing of the last uevent for that
> device. If, in this case, we used our fallback action to retrieve the
> WWID, we'd be able to determine if it was a very short-lived problem or
> something more serious.
>  =

> > > Whatever we do, we should stop trying to "fix" the path WWID in
> > > disassemble_map(). That's *so* against the separation of concerns
> > > principle. In getuid(), we might check if a path with missing WWID
> > > is
> > > already part of an existing multipath map, and then set the path
> > > WWID
> > > from the map WWID as sort-of a last emergency fallback. But that,
> > > too,
> > > should only be done during startup (assuming that a previous
> > > multipath
> > > or multipathd instance had set up the map correctly, and that udev
> > > information had been "lost" since then), and only after retrying as
> > > described above.
> > =

> > We don't want to remove paths from multipath devices because
> > multipathd
> > started up when the path was missing udev information. The udev
> > properties are trickier, but if we simply have a null WWID, it makes
> > sense to allow it as a last resort if the device otherwise appears to
> > have the same paths as it previously did.
> =

> I agree, but I don't agree with filling in pp->wwid from mpp->wwid.

I'm fine with that.
 =

> >  users can always run
> > =

> > # multipath -f
> > =

> > to remove the device. If it looks like some of the paths are supposed
> > to
> > change on the device, we should quite possibly not include paths with
> > a
> > null WWID, because we don't know what has changed.  But we can do
> > this
> > someplace else than in disassemble_map(). =

> =

> How would you determine that something is "supposed to change"?

Sorry. That was worded badly. For example, if we start up and determine
that mpatha should look just like the existing mpatha, except for a path
that in missing information, it makes sense to assume that path also
belongs. If configure determines that some of the paths that are in the
existing mpatha definitely do not belong there, then it shouldn't assume
the paths that we know nothing about do belong there.

So, if it appears that something has changed in a multipath device,
looking at the paths that we do have information for, we can't make
assumptions about the paths we don't have information for. =


> > =

> > > Note that since by-property blacklisting was introduced in 2013,
> > > significant progress has been made in other areas. We have
> > > blacklisting
> > > by transport now, "find_multipaths", the "failed_wwids" logic that
> > > avoids repeated attempts at setting up maps for busy devices, and
> > > the
> > > INIT_MISSING_UDEV logic to deal with incomplete initialization. The
> > > udev rules have been improved as well. So, doing away with
> > > "required
> > > udev properties" may not be so dangerous, after all. =

> > > =

> > > Thoughts?
> > =

> > Another option would be to do some extra work in reconfigure.  If we
> > held on to the old path, and cleaned up everything but the old udev
> > device and file descriptor, we could be sure that the kernel wouldn't
> > reuse that device major:minor while we were reconfiguring. If we got
> > some paths without their udev information, we would have the old udev
> > information to check against the new config, to see if the device
> > should
> > be removed. Again, this works best if we could determine if we were
> > missing udev information.  Although in this case we could probably
> > just
> > use any path that became blacklisted because of not having the
> > necessary
> > property information.
> =

> IOW, we shouldn't blacklist these paths, which is what I was trying to
> say. Your idea to hold the references until reconfigure() is finished
> sounds clever to me.
> =

> The idea of blacklisting-by-missing-properties is to determine if
> ID_SERIAL for a given WWID is _reliable_. It should be used if we get a
> non-zero ID_SERIAL and at the same time none of the required
> properties, e.g. ID_WWN. IMO, if this is the case, we can be certain
> that scsi_id did *not* fail - after all, it was able to obtain
> ID_SERIAL. OTOH, if neither ID_SERIAL nor ID_WWN is set, failure to
> access the device is likely. Thus the solution here is simple: We
> should apply "blacklisting by missing property" *only* if ID_SERIAL is
> set, but ID_WWN is not.

Sure.

-Ben
 =

> Martin
> =

> -- =

> Dr. Martin Wilck <mwilck@suse.com>, Tel. +49 (0)911 74053 2107
> SUSE Linux GmbH, GF: Felix Imend=F6rffer, Jane Smithard, Graham Norton
> HRB 21284 (AG N=FCrnberg)
> =
