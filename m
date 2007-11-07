From: "Paul Cote" <paul.cote@incipient.com>
Subject: RE: Reloading multipathd?
Date: Wed, 7 Nov 2007 18:55:02 -0500
Message-ID: <940B4FF1F5958E4F96FC83C055A2F2611B8BA4@exch-2003.incipient.waltham>
References: <1194448727.6012.18.camel@sanderbal>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-class: urn:content-classes:message
In-Reply-To: <1194448727.6012.18.camel@sanderbal>
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


>could you tell me how to do that?=20

You can use the 'rescan SCSI Bus" script found at:
http://www.garloff.de/kurt/linux/

Optionally; if you have FC HBA's ... Emulex and Qlogic both have their
home grown rescan scripts as well.

>and does a rescan have any effect on already active LUN's?

No.

-----Original Message-----
From: dm-devel-bounces@redhat.com [mailto:dm-devel-bounces@redhat.com]
On Behalf Of S. J. van Harmelen
Sent: Wednesday, November 07, 2007 10:19 AM
To: device-mapper development
Subject: RE: [dm-devel] Reloading multipathd?


On Wed, 2007-11-07 at 08:33 -0500, Paul Cote wrote:
> Did you do a rescan so that the O/S "sees" the new LUN?

Nope... Could you tell me how to do that? And does a rescan have any
effect on already active LUN's?


> If so; simply do
> a multipath -v2 to build the new path list.
>=20
> -----Original Message-----
> From: dm-devel-bounces@redhat.com [mailto:dm-devel-bounces@redhat.com]
> On Behalf Of S. J. van Harmelen
> Sent: Wednesday, November 07, 2007 8:08 AM
> To: device-mapper development
> Subject: [dm-devel] Reloading multipathd?
>=20
> Hi...
>=20
> I just added another LUN on our storage (MD3000). But now that I run=20
> multipath -ll I don't see the new LUN.
>=20
> Do I need to reload something (like /etc/init.d/multipath-tools reload

> maybe)? And if so, can I do this without it interrupting the=20
> connectivity of the other (production) LUN's?
>=20
> Sander
>=20
> --
> dm-devel mailing list
> dm-devel@redhat.com https://www.redhat.com/mailman/listinfo/dm-devel
>=20
> --
> dm-devel mailing list
> dm-devel@redhat.com https://www.redhat.com/mailman/listinfo/dm-devel

--
dm-devel mailing list
dm-devel@redhat.com https://www.redhat.com/mailman/listinfo/dm-devel
