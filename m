From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: Re: [PATCH 0/3] New approach at handling changed WWIDs
Date: Thu, 21 Mar 2019 17:31:18 -0500
Message-ID: <20190321223117.GN13295@octiron.msp.redhat.com>
References: <20190318121235.8942-1-mwilck@suse.com>
	<20190319171115.GF13295@octiron.msp.redhat.com>
	<402a4da867abb74c04511e98623e5abb6b144b7e.camel@suse.com>
	<5af82a40b76e39542742a3df349d00d32351d7cd.camel@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <5af82a40b76e39542742a3df349d00d32351d7cd.camel@suse.com>
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

On Wed, Mar 20, 2019 at 09:37:35AM +0100, Martin Wilck wrote:
> On Tue, 2019-03-19 at 19:44 +0100, Martin Wilck wrote:
> > On Tue, 2019-03-19 at 12:11 -0500, Benjamin Marzinski wrote:
> > > On Mon, Mar 18, 2019 at 01:12:32PM +0100, Martin Wilck wrote:
> > > > =

> > > > Note also that if a "reconfigure" was carried out in the presence
> > > > of
> > > > paths with changed WWID, the final outcome would likely be the
> > > > same
> > > > that
> > > > my patch now achieves without "reconfigure".
> > > =

> > > Yeah. I just checked, and this is very broken, and something needs
> > > to
> > > be
> > > done to fix it.  If a device gets a change event while it's down,
> > > it
> > > will no longer have the udev properties necessary to not be
> > > blacklisted,
> > > so the device gets blacklisted, and ignored.  Even after it comes
> > > back
> > > up and gest another change event to restore these values,
> > > multipathd
> > > still ignores it, because the device was blacklisted during its add
> > > event.
> > =

> > I wasn't aware of that.
> =

> We have a general problem in multipath-tools here. Our method of
> blacklisting devices that don't have whitelisted udev properties
> doesn't go together with the notion that udev may fail to set the
> properties correctly, and the notion that paths shouldn't be removed or
> failed (let alone blacklisted) without good reason.
> =

> Either we find a way to distinguish "devices that have incomplete udev
> information because of temporary failure" and "devices that are missing
> required udev properties permanently", or we must say goodbye to the
> special treatment of blacklisting by property.
> =

> One obvious thing to do before blacklisting a path is to retry when we
> encounter devices with missing properties. We can also check the
> fallback UID methods - if they are successful and udev fails
> repeatedly, the admin likely has messed up the udev rules.
> =

> Ben's approach to ignore WWIDs "changed to 0" at least temporarily
> makes a lot of sense in this context. Paths that once used to have a
> good WWID should be given up only after a reasonable number of retries.
> Paths for which we'd never seen a valid WWID are treated by the
> INIT_MISSING_UDEV logic.

ideally, we would be able to determine whether or not udev was able to
get all the necessary information. It would be nice to be notified if
scsi_id failed or udev timed out.
 =

> Whatever we do, we should stop trying to "fix" the path WWID in
> disassemble_map(). That's *so* against the separation of concerns
> principle. In getuid(), we might check if a path with missing WWID is
> already part of an existing multipath map, and then set the path WWID
> from the map WWID as sort-of a last emergency fallback. But that, too,
> should only be done during startup (assuming that a previous multipath
> or multipathd instance had set up the map correctly, and that udev
> information had been "lost" since then), and only after retrying as
> described above.

We don't want to remove paths from multipath devices because multipathd
started up when the path was missing udev information. The udev
properties are trickier, but if we simply have a null WWID, it makes
sense to allow it as a last resort if the device otherwise appears to
have the same paths as it previously did. users can always run

# multipath -f

to remove the device. If it looks like some of the paths are supposed to
change on the device, we should quite possibly not include paths with a
null WWID, because we don't know what has changed.  But we can do this
someplace else than in disassemble_map(). =


> Note that since by-property blacklisting was introduced in 2013,
> significant progress has been made in other areas. We have blacklisting
> by transport now, "find_multipaths", the "failed_wwids" logic that
> avoids repeated attempts at setting up maps for busy devices, and the
> INIT_MISSING_UDEV logic to deal with incomplete initialization. The
> udev rules have been improved as well. So, doing away with "required
> udev properties" may not be so dangerous, after all. =

> =

> Thoughts?

Another option would be to do some extra work in reconfigure.  If we
held on to the old path, and cleaned up everything but the old udev
device and file descriptor, we could be sure that the kernel wouldn't
reuse that device major:minor while we were reconfiguring. If we got
some paths without their udev information, we would have the old udev
information to check against the new config, to see if the device should
be removed. Again, this works best if we could determine if we were
missing udev information.  Although in this case we could probably just
use any path that became blacklisted because of not having the necessary
property information.

-Ben

> Martin
> =

> -- =

> Dr. Martin Wilck <mwilck@suse.com>, Tel. +49 (0)911 74053 2107
> SUSE Linux GmbH, GF: Felix Imend=F6rffer, Jane Smithard, Graham Norton
> HRB 21284 (AG N=FCrnberg)
> =
