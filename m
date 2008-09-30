From: Pasi =?iso-8859-1?Q?K=E4rkk=E4inen?= <pasik@iki.fi>
Subject: Re: multipath-tools libmultipath/configure.c libmu ...
Date: Tue, 30 Sep 2008 12:38:43 +0300
Message-ID: <20080930093843.GI9714@edu.joroinen.fi>
References: <20080919032710.28653.qmail@sourceware.org>
	<20080919185313.GA2932@thumper2> <20080919215731.GA7172@thumper2>
	<20080923180504.GB3808@ether.msp.redhat.com>
	<20080930092206.GH9714@edu.joroinen.fi>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20080930092206.GH9714@edu.joroinen.fi>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Tue, Sep 30, 2008 at 12:22:06PM +0300, Pasi K=E4rkk=E4inen wrote:
> On Tue, Sep 23, 2008 at 01:05:04PM -0500, Benjamin Marzinski wrote:
> > >=20
> > > Responding to my own mail, I did got the source with the patches fr=
om the
> > > cvs.  But, the resizing does not work for with with mounted volumes=
.  There
> > > are 4 paths for the volume, so there is no probably with it failing=
 paths.=20
> > > I get "domap(0) failure for create/reload map" when I run multipath=
 -v 3.
> > >=20
> > > I can get dm to reconize the new size if the volume is umounted.  B=
ut, I
> > > really would like it to work while it is mounted.
> > >=20
> >=20
> > It should work for mounted volumes.  Did you try
> > multipathd -k"resize map <mapname>"
> >=20
> > Since this requires suspending without the no_flush option, I didn't
> > want to have it happen on a normal reload, and since without the kern=
el
> > fixes, this required removing and then readding paths, I did it throu=
gh
> > multipathd.
> >=20
> > So just running multipath -v3 after a path resize won't work. In fact=
, I
> > think it might leave the devices in the suspended state, since the
> > resume fails.
> >=20
>=20
> Hi!
>=20
> I just tried this but I'm having problems getting it to work..
>=20
> # multipathd -k"resize map mpath-resize-test"
> fail
>=20
> The underlying SCSI devices have been online resized already, and verif=
ied
> from dmesg and from /proc/partitions to be bigger.
>=20
> I'm running rhel5 kernel with scsi online resize patches (2.6.18-93.el5=
.bz444964.2)
> and dm-multipath testing packages with support for online resizing
> (device-mapper-multipath-0.4.7-19.el5.i386.rpm).
>=20
> Any ideas?=20
>=20

Actually I think the problem was that I had not yet reloaded multipathd
configuration, so my underlying devices were still blacklisted according =
to
multipathd -k"show devices".. but still I had the mpath-device up and
running :) Oh well..

I ran "/etc/init.d/multipathd reload" and then:

# multipathd -k"resize map mpath-resize-test"
ok

But "multipath -ll" still shows the mpath-resize-test device with the
same/old size..=20

What to do/try next?=20

-- Pasi
