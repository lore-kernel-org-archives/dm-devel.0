From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: Re: [PATCH 0/3] New approach at handling changed WWIDs
Date: Mon, 25 Mar 2019 17:27:22 -0500
Message-ID: <20190325222722.GP13295@octiron.msp.redhat.com>
References: <20190318121235.8942-1-mwilck@suse.com>
	<20190319171115.GF13295@octiron.msp.redhat.com>
	<402a4da867abb74c04511e98623e5abb6b144b7e.camel@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <402a4da867abb74c04511e98623e5abb6b144b7e.camel@suse.com>
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

On Tue, Mar 19, 2019 at 07:44:09PM +0100, Martin Wilck wrote:
> On Tue, 2019-03-19 at 12:11 -0500, Benjamin Marzinski wrote:
> > On Mon, Mar 18, 2019 at 01:12:32PM +0100, Martin Wilck wrote:
> > =

> > d) and e) seem to me like by far the most likely scenarios, so doing
> > something suboptimal for them, in order to optimize the very unlikely
> > scenarios seems wrong.
> =

> You've worked on this far more than I did, so I trust your judgement.
> =

> One remark: With the kernel exporting the VPD pages in sysfs
> and my late "multipath -u" patch series, udev should be able to process
> uevents for path devices without a single actual device IO. (*) =

> While there are still possible causes for udev processing to get stuck,
> this would make it much less likely.

For reasons I don't understand, not all devices get a vpd_pg83 sysfs
file, even though they clearly have a page 0x83, since multipath and
sg_inq can read from it via ioctl.  I have a device like this. This is
quite possibly a kernel issue that should get fixed, but regardless,
it's been there for a while, and I just cheked and it still exists in
the 5.0.0-rc6 kernel.

> > > Note also that if a "reconfigure" was carried out in the presence
> > > of
> > > paths with changed WWID, the final outcome would likely be the same
> > > that
> > > my patch now achieves without "reconfigure".
> > =

> > Yeah. I just checked, and this is very broken, and something needs to
> > be
> > done to fix it.  If a device gets a change event while it's down, it
> > will no longer have the udev properties necessary to not be
> > blacklisted,
> > so the device gets blacklisted, and ignored.  Even after it comes
> > back
> > up and gest another change event to restore these values, multipathd
> > still ignores it, because the device was blacklisted during its add
> > event.
> =

> I wasn't aware of that.

I just found it out when I was checking to see what really happened on a
reconfigure with a null wwid path.

> > However, if you just set the wwid of a path to NULL and run
> > reconfigure,
> > it will stay added to the map, and get it's wwid restored to the
> > multipath device's wwid, because configure() calls map_discovery(),
> > which ends up calling disassemble_map(). This will set a NULL path
> > wwid
> > to the multipath device wwid, since disassemble_map() assumes that
> > NULL
> > wwids just mean that multipathd couldn't get the wwid temporarily.
> =

> My thinking was that reconfigure calls path_discovery(), which would
> call pathinfo() on all available paths again. I understand now - if
> there was an error processing the last uevent for a device, the
> information in the udev DB will still be incomplete, and
> path_discovery() will obtain the same broken information, possibly
> blacklisting the device. I thought the WWID might then be restored by
> the INIT_MISSING_UDEV logic, but disassemble_map() would almost
> certainly come first. I'm not sure I like it that disassemble_map()
> tries to fill in path information. It's ok to do this for paths
> that haven't been detected at all (pp =3D=3D NULL case) but in case of
> paths that are present in the udev db, I'm uncertain.
> =

> This would also affect your treatment of "WWID changed to zero", no?
> Any call to setup_multipath() or update_multipath() would call
> disassemble_map(), which would possibly mess with the path's wwid...
> =


No, because my code doesn't change the wwid if moves to NULL, it simply
remembers the old wwid.  This only happens when you do a reconfigure,
because you are getting new paths. But regardless, I agree that we
should avoid setting the path wwid based on the map wwid.

> You'd reverted this change in your patch 12, which confused me quite a
> bit. What is your preference, really?

My preference really is my 07 patch, which is why I didn't simply merge
them to start with.

> Let's go for the removal and re-addition for the non-NULL changed WWID
> case, and use the quick path for the NULL-WWID case (maybe we could
> even try the "fallback" immediately in uev_update_path()?).

That was the whole point of my setting retriggers to the max. So that we
would immediately try the fallback method if we got a NULL wwid, after
we had successfully gotten it in the past.
 =

> You have a more complete understanding of the whole issue than me, so I
> trust that you'll come up with a v3 series addressing all these issues.

I'd like to propose a different compromise; that is my option 1 (patch
07) along with triggering a uevent to update udev for NULL wwids. Here
is my biggest objection to option 2 (patch 12). In the scenario where we
have an incomplete uevent because of a uevent storm, multipathd will
suddenly fail a path that is working fine, simply because the machine is
under load.  I just don't relish the idea of explaining to a customer
that we failed their paths (likely making the situation even worse) even
though we didn't have to, simply because we were worried that the
customer might do something stupid, and we would have a better chance
(although not a certaintly) of protecting them from their own stupid
mistake if we unnecessarily failed working paths.

This might be o.k. if we defaulted this behaviour to "off", but since it
is "on" by default, we are running a very real risk of failing perfectly
working paths, because we think our users might be stupid.

-Ben

> Regards
> Martin
> =

> (*) This works only if the tool used to retrieve the VPDs support
> reading from sysfs, of course, as sg_inq does (scsi_id does not,
> currently).

So, even when I run sg_inq on a device that does have the vpd_pg83 sysfs
file, it still does an ioctl. Do you know if that's just because I'm
using version 1.42, instead of 1.44?  As far as I know, sg_inq always
has done an ioctl.

> =

> -- =

> Dr. Martin Wilck <mwilck@suse.com>, Tel. +49 (0)911 74053 2107
> SUSE Linux GmbH, GF: Felix Imend=F6rffer, Jane Smithard, Graham Norton
> HRB 21284 (AG N=FCrnberg)
> =
