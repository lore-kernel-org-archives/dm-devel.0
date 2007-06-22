From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Subject: Re: Partition tables on devices
Date: Fri, 22 Jun 2007 10:49:34 +0200 (CEST)
Message-ID: <Pine.LNX.4.62.0706221048510.13100@pademelon.sonytel.be>
References: <Pine.LNX.4.62.0706211726260.3710@pademelon.sonytel.be>
	<1182456876.14602.13.camel@leto.intern.saout.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED;
	BOUNDARY="-584337861-1774412065-1182502174=:13100"
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1182456876.14602.13.camel@leto.intern.saout.de>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Saout <christophe@saout.de>
Cc: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---584337861-1774412065-1182502174=:13100
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

	Hi Christophe,

On Thu, 21 Jun 2007, Christophe Saout wrote:
> > I have a disk that embeds another disk image (including a partition t=
able and
> > partitions).  Using dmsetup and the linear target I created a new dev=
ice to
> > access the embedded disk image. Cfdisk shows me the partitions on the=
 new
> > device, but the kernel didn't scan for partitions and hence didn't cr=
eated
> > devices for them.
> >=20
> > Does there exist a way to let the kernel scan for partition tables on=
 a device
> > created using dmsetup? Or should I use a script like the one proposed=
 by
> > Christophe Saout in http://lkml.org/lkml/2003/7/18/141?
>=20
> There's a small tool
> "kpartx" ( http://www.die.net/doc/linux/man/man8/kpartx.8.html ), which
> I think, IIRC is a simple port of the kernel partition detection code t=
o
> userspace, which uses the device mapper to set things up. I have used i=
t
> at times, it works nicely (it can even replace the kernel detection cod=
e
> seamlessly, if put into an initramfs for instance).=20
>=20
> There's a copy of it in the distributed with the multipath tools.

Great! Exactly what I needed. I did `apt-get install multipath-tools', an=
d now
it works fine. Thanks!

With kind regards,
=20
Geert Uytterhoeven
Software Architect

Sony Network and Software Technology Center Europe
The Corporate Village =C2=B7 Da Vincilaan 7-D1 =C2=B7 B-1935 Zaventem =C2=
=B7 Belgium
=20
Phone:    +32 (0)2 700 8453=09
Fax:      +32 (0)2 700 8622=09
E-mail:   Geert.Uytterhoeven@sonycom.com=09
Internet: http://www.sony-europe.com/
 =09
Sony Network and Software Technology Center Europe=09
A division of Sony Service Centre (Europe) N.V.=09
Registered office: Technologielaan 7 =C2=B7 B-1840 Londerzeel =C2=B7 Belg=
ium=09
VAT BE 0413.825.160 =C2=B7 RPR Brussels=09
Fortis Bank Zaventem =C2=B7 Swift GEBABEBB08A =C2=B7 IBAN BE3900138235861=
9
---584337861-1774412065-1182502174=:13100
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


---584337861-1774412065-1182502174=:13100--
