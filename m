From: "Kumar, Satish (STSD)" <satish.gandham@hp.com>
Subject: RE: Setting up multipath device
Date: Thu, 8 Jun 2006 19:28:11 +0530
Message-ID: <6B07290940B2C14BA4567FABFDE6024DBC3E2E@bgeexc04.asiapacific.cpqcorp.net>
References: <5485940d0606080647k1fc84114i2c36537008723974@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-class: urn:content-classes:message
In-Reply-To: <5485940d0606080647k1fc84114i2c36537008723974@mail.gmail.com>
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

=20
Hi Pierre,


	May be the following links can help u ..

http://support.novell.com/techcenter/sdb/en/2005/04/sles_multipathing.ht
ml
http://www.redhat.com/docs/manuals/csgfs/browse/rh-cs-en/ap-rhcs-dm-mult
ipath-usagetxt.html

Satish G.

-----Original Message-----
From: dm-devel-bounces@redhat.com [mailto:dm-devel-bounces@redhat.com]
On Behalf Of C'est Pierre
Sent: Thursday, June 08, 2006 7:18 PM
To: dm-devel@redhat.com
Subject: [dm-devel] Setting up multipath device

Hello,

I am trying to setup a multipath device, but I am failing to do so, cuz
I don't have as much documentation as I would wish to.

Here's the output of 'multipath -l'

# multipath -l
3600508b40010130d00006000011c0000
[size=3D50 GB][features=3D0][hwhandler=3D0]
\_ round-robin 0 [prio=3D0][enabled]
 \_ 0:0:0:2 sda 8:0   [active][undef]
 \_ 1:0:0:2 sdb 8:16  [active][undef]

How can I generate a "one device" that's recognizable by lvm, just so I
can setup a VG with it?

Thank you
Pierre

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel
