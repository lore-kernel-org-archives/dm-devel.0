From: "Miller, Mike (OS Dev)" <Mike.Miller@hp.com>
Subject: RE: [libmultipath] Add cciss support
Date: Mon, 16 Jul 2007 16:19:59 -0000
Message-ID: <226E1C65E4F6164E8EA5FD3CC913AE8C0187C3B1@G3W0639.americas.hpqcorp.net>
References: <469B53C9.9000303@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-class: urn:content-classes:message
In-Reply-To: <469B53C9.9000303@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Hannes Reinecke <hare@suse.de>, christophe varoqui <christophe.varoqui@free.fr>, "Sharma, Dinesh (Houston-NSS)" <dinesh.sharma@hp.com>, ISS SB TEAM <isssbteam@hp.com>
Cc: Ahmad Sadeghpour <asadeghpour@novell.com>, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

=20

> -----Original Message-----
> From: Hannes Reinecke [mailto:hare@suse.de]=20
> Sent: Monday, July 16, 2007 6:17 AM
> To: christophe varoqui
> Cc: Steve Reilly; Miller, Mike (OS Dev); Ahmad Sadeghpour;=20
> device-mapper development
> Subject: [libmultipath] Add cciss support
>=20
> Hi Christophe,
>=20
> HP asked me to implement cciss support for multipathing.
> Apparently their newer HBAs are multipathing capable.
> However, I have no idea about the failover method they're

Dinesh, have one of your guys get back to Hannes about what they've done =
in DM.
=20
> using; so I used multibus as a default.
> Maybe someone from HP can comment on this.
>=20
> There were several patches floating around which tried to=20
> achieve the same but given that they're trying to access=20
> /sys/block/cciss!cXdY/device (which doesn't exist for cciss)=20

Hannes,
This does exist. See sles10 sp1. I still owe upstream some updates.

> I doubt they'll do anything sensible.

Thanks for your obvious high level of confidence.

mikem

>=20
> Please commit.
>=20
> Cheers,
>=20
> Hannes
> --=20
> Dr. Hannes Reinecke		      zSeries & Storage
> hare@suse.de			      +49 911 74053 688
> SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
> GF: Markus Rex, HRB 16746 (AG N=FCrnberg)
>=20
