From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Subject: Partition tables on devices
Date: Thu, 21 Jun 2007 17:32:46 +0200 (CEST)
Message-ID: <Pine.LNX.4.62.0706211726260.3710@pademelon.sonytel.be>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED;
	BOUNDARY="-584337861-1794152911-1182439966=:3710"
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
Cc: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>, Christophe Saout <christophe@saout.de>
List-Id: dm-devel.ids

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---584337861-1794152911-1182439966=:3710
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

	Hi,

I have a disk that embeds another disk image (including a partition table=
 and
partitions).  Using dmsetup and the linear target I created a new device =
to
access the embedded disk image. Cfdisk shows me the partitions on the new
device, but the kernel didn't scan for partitions and hence didn't create=
d
devices for them.

Does there exist a way to let the kernel scan for partition tables on a d=
evice
created using dmsetup? Or should I use a script like the one proposed by
Christophe Saout in http://lkml.org/lkml/2003/7/18/141?

Thanks in advance!

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
---584337861-1794152911-1182439966=:3710
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


---584337861-1794152911-1182439966=:3710--
