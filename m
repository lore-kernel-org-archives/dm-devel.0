From: Pasi =?iso-8859-1?Q?K=E4rkk=E4inen?= <pasik@iki.fi>
Subject: Re: multipath-tools libmultipath/configure.c libmu ...
Date: Wed, 1 Oct 2008 16:03:14 +0300
Message-ID: <20081001130314.GM9714@edu.joroinen.fi>
References: <20080919032710.28653.qmail@sourceware.org>
	<20080919185313.GA2932@thumper2> <20080919215731.GA7172@thumper2>
	<20080923180504.GB3808@ether.msp.redhat.com>
	<20080930092206.GH9714@edu.joroinen.fi>
	<20080930093843.GI9714@edu.joroinen.fi>
	<20080930192046.GE3808@ether.msp.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20080930192046.GE3808@ether.msp.redhat.com>
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

On Tue, Sep 30, 2008 at 02:20:47PM -0500, Benjamin Marzinski wrote:
> On Tue, Sep 30, 2008 at 12:38:43PM +0300, Pasi K=E4rkk=E4inen wrote:
> > On Tue, Sep 30, 2008 at 12:22:06PM +0300, Pasi K=E4rkk=E4inen wrote:
> > > On Tue, Sep 23, 2008 at 01:05:04PM -0500, Benjamin Marzinski wrote:
> > > > >=20
> > > > > Responding to my own mail, I did got the source with the patche=
s from the
> > > > > cvs.  But, the resizing does not work for with with mounted vol=
umes.  There
> > > > > are 4 paths for the volume, so there is no probably with it fai=
ling paths.=20
> > > > > I get "domap(0) failure for create/reload map" when I run multi=
path -v 3.
> > > > >=20
> > > > > I can get dm to reconize the new size if the volume is umounted=
.  But, I
> > > > > really would like it to work while it is mounted.
> > > > >=20
> > > >=20
> > > > It should work for mounted volumes.  Did you try
> > > > multipathd -k"resize map <mapname>"
> > > >=20
> > > > Since this requires suspending without the no_flush option, I did=
n't
> > > > want to have it happen on a normal reload, and since without the =
kernel
> > > > fixes, this required removing and then readding paths, I did it t=
hrough
> > > > multipathd.
> > > >=20
> > > > So just running multipath -v3 after a path resize won't work. In =
fact, I
> > > > think it might leave the devices in the suspended state, since th=
e
> > > > resume fails.
> > > >=20
> > >=20
> > > Hi!
> > >=20
> > > I just tried this but I'm having problems getting it to work..
> > >=20
> > > # multipathd -k"resize map mpath-resize-test"
> > > fail
> > >=20
> > > The underlying SCSI devices have been online resized already, and v=
erified
> > > from dmesg and from /proc/partitions to be bigger.
> > >=20
> > > I'm running rhel5 kernel with scsi online resize patches (2.6.18-93=
.el5.bz444964.2)
> > > and dm-multipath testing packages with support for online resizing
> > > (device-mapper-multipath-0.4.7-19.el5.i386.rpm).
> > >=20
> > > Any ideas?=20
> > >=20
> >=20
> > Actually I think the problem was that I had not yet reloaded multipat=
hd
> > configuration, so my underlying devices were still blacklisted accord=
ing to
> > multipathd -k"show devices".. but still I had the mpath-device up and
> > running :) Oh well..
> >=20
> > I ran "/etc/init.d/multipathd reload" and then:
> >=20
> > # multipathd -k"resize map mpath-resize-test"
> > ok
> >=20
> > But "multipath -ll" still shows the mpath-resize-test device with the
> > same/old size..=20
> >=20
> > What to do/try next?=20
>=20
> Does
>=20
> # blockdev --getsize <scsi_device>
>=20
> show the new size, after you have increased the scsi device size?
>=20

Yep, it does.

> Also, can you start up multipathd with the -v3 option, and copy any
> messages that are printed out when you run=20
>=20
> # multipathd -k"resize map mpath-resize-test"
>=20
> Thanks.
>=20

I don't know what went wrong, but my mpath device went into SUSPENDED mod=
e,
and now also multipathd command just hangs.. actually I can't even reboot
the server, 'reboot' command also hangs. "dmsetup resume" doesn't help..

I guess rebooting doesn't work because I have some IO waiting for executi=
on
for that suspended device/filesystem..

I power cycled the server, and tried again..=20

This time it worked OK!=20

Differences between my first try (which didn't work) and the=20
second (successful) try:

- First time I didn't have multipathd restarted/reloaded to pick up the =20
  complete configuration for the LUNs/devices used in this test.

- First time I didn't understand to do 'del/add path' trick.. I went for
  'resize map' immediately.=20

"Log" of my successful resize experience is here:
http://pasik.reaktio.net/rhel5-online-iscsi-resize-test.txt

Thanks a lot for your help!

-- Pasi
