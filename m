From: Edward Goggin <egoggin@vmware.com>
Subject: RE: Re: multipathing pending issues with rhel
Date: Wed, 26 Nov 2008 12:13:53 -0800
Message-ID: <B1FD1A0C73AC4E46A4F95BADC77079D351A9DD81@PA-EXMBX02.vmware.com>
References: <20081008230725.3ece5f56@plop>
	<20081008221148.GC6453@ether.msp.redhat.com>
	<20081009010638.73e556ce@plop>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20081009010638.73e556ce@plop>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: 'device-mapper development' <dm-devel@redhat.com>, Benjamin Marzinski <bmarzins@redhat.com>
List-Id: dm-devel.ids



> -----Original Message-----
> From: dm-devel-bounces@redhat.com=20
> [mailto:dm-devel-bounces@redhat.com] On Behalf Of Christophe Varoqui
> Sent: Wednesday, October 08, 2008 7:07 PM
> To: Benjamin Marzinski
> Cc: dm-devel@redhat.com
> Subject: [dm-devel] Re: multipathing pending issues with rhel
>=20
> Le Wed, 8 Oct 2008 17:11:48 -0500,
> Benjamin Marzinski <bmarzins@redhat.com> a =E9crit :
>=20
> > On Wed, Oct 08, 2008 at 11:07:25PM +0200, Christophe Varoqui wrote:
> > > Ben,
> > >
> > > I'd like to summarize all the issues I raised recently through my=20
> > > employers support channel on the multipath subsystem.
> > > And see if something can be done about it, at least in=20
> the upstream=20
> > > concerned codebases.
> > >
> > > 1/ multipathd private namespace pins lvm2 logical volumes maps=20
> > > mounted at daemon startup, thus making "vgchange -ay" fail, even=20
> > > after umounting the visible mount. In my context, it also means I=20
> > > can't stop a clustered service build on this vg to start it on=20
> > > another node. This problem does not affect upstream which=20
> does not=20
> > > create a private namespace.
> >
> errata: "vgchange -an", though it's clear you read it as I meant :)
>=20
> > This already has a fix queued for 5.3.  Multipathd now=20
> unounts all of=20
> > the unnecessary mount points after creating the private namespace.
> >
> Good to know, thanks for this update.
>=20
> > >
> > > 2/ can't map a rw multipath over read-only paths. Quick=20
> workaround=20
> > > to create ro multipath, but ro->rw promotion is not=20
> automatic when=20
> > > paths become writable. I keep thinking we should allow rw=20
> multipath=20
> > > over ro paths. The ro->rw event might also work, but what will=20
> > > trigger the kernel rw status change in the first place ? To my=20
> > > knowledge, only a manual scsi device rescan can force this status=20
> > > update ... which accounts for a less user-friendly=20
> solution than the=20
> > > former.
> >
> > The workaround is in place for 5.3, but I fully agree that a kernel=20
> > patch to allow rw maps on top of ro devices is the way to go in the=20
> > future.
> >
> Glad we share this point of view. Will you propose patches=20
> for inclusion upstream ? Which update level do you estimate=20
> will include this fix ?
>=20
> > > 3/ Can't use scsi-3 persistent reservations on clariion=20
> multipathed=20
> > > luns : paths reserved on node A, writes submitted on node=20
> B should=20
> > > be errored immediately to ensure data integrity. Instead,=20
> writes get=20
> > > buffered in the "queue_if_no_path" logic, and finally corrupt the=20
> > > data when reservation get cleared. In my context,=20
> reservation is the=20
> > > prefered io fencing method for clusters.
> > > The kernel knows the write io submitted on a path is=20
> refused due to=20
> > > a reservation conflict, but this status is not propagated to=20
> > > multipath for it to react by not queuing this io as it should.
> > >
> This one is hard to understand, I empatize. Nonetheless it=20
> deserves attention, as it is a data-corrupter for the clients=20
> using, or eager to use, persistent reservations on these=20
> widespread Clariion arrays. I know Mike Christie already=20
> tried to address the issue years ago ... he might be willing=20
> to take over again. (hope)
>=20

I think I inadvertantly made this matter worse about two years ago
when I changed the clariion path checker to issue a scsi read via
sg_read in libsg.c after inquiry page 0xc0 in order to discern an
inactive from an active clariion snapshot logical unit.  This change
to multipath-tools/libcheckers/emc_clariion.c causes a path check on
a path to incur a reservation error if the reservation is held
by a different I/T nexus.

A reasonable fix for this problem is to have sg_read in
multipath-tools/libcheckers/libsg.c return PATH_UP even if the
return value from ioctl is < 0 if the returned scsi status
in io_hdr.status is SAM_STAT_RESERVATION_CONFLICT.

The dm-mpath.c =20
> > > Regards,
> > > cvaroqui
>=20
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
>=20
