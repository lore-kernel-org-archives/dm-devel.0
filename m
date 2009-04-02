From: christophe.varoqui@free.fr
Subject: Re: Device Mapper MultiPath
Date: Thu, 2 Apr 2009 23:26:37 +0200 (CEST)
Message-ID: <1121320802.2940471238707597676.JavaMail.root@zimbra16-e3.priv.proxad.net>
References: <20090401203108.GA17991@mars.virtualiron.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20090401203108.GA17991@mars.virtualiron.com>
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

applied
minor fix to a condlog() missing arg in a subsequent commit

Thanks for the port.

----- Mail Original -----
De: "Konrad Rzeszutek" <konrad@virtualiron.com>
=C3=80: "device-mapper development" <dm-devel@redhat.com>
Envoy=C3=A9: Mercredi 1 Avril 2009 22h31:08 GMT +01:00 Amsterdam / Berlin=
 / Berne / Rome / Stockholm / Vienne
Objet: Re: [dm-devel] Device Mapper MultiPath

On Wed, Apr 01, 2009 at 03:08:41PM -0500, Andy wrote:
> On Tue, Mar 31, 2009 at 08:25:59PM -0400, Konrad Rzeszutek wrote:
> > On Tue, Mar 31, 2009 at 09:07:08PM -0300, Rodrigo Nascimento wrote:
> > > Hi All,
> > >=20
> > > I'm a student of computer sciences and I'd like to collaborate with=
 the
> > > development of the DM-MP.
> > > I know that maybe you received this kind of message during all time=
, but I
> >=20
> > I think you are the first :-)
> >=20
> > > really want to help, with anything.
> >=20
> > Shakedown help would be nice. As in, trying to yank stuff underneath =
it,=20
> > add new block disks, remove them, add them, remove them, edit the
> > multipath.conf file and issue 'reconfigure', resize the maps,=20
> > then add 1000+LUNs, and while they are being added, start removing th=
e
> > LUNs, then for extra fun call 'dmsetup remove_all' while in another
> > thread you run 'multipath'. Ooh, and see if there are any memory leak=
s
> > while this all is being done.
> >=20
>=20
> What I would really like to see is online resizing of non-partitioned d=
m
> block devices.  I would love to be able to resize an underlying dm-mp b=
lock
> device, and the just grow the filesystem without using a extra, un-need=
ed,

Benjamin posted a CVS patch of this, that I've forward-ported to work wit=
h
the latest git. It is attached.


> volume manager layer.  I remember some of this being talk about a while=
 ago,
> but I don't think anything ever happened.
>=20
> Andy
>=20
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel
