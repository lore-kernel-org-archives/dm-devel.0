From: "T S, Veena (STSD)" <veena-s.t@hp.com>
Subject: RE: [PATCH] multipath: Add compability 'command' prio
	handler
Date: Tue, 5 Feb 2008 16:05:50 +0530
Message-ID: <4640E676B7B93749BC82C75D50E500FB05E7F786@BGEEXC07.asiapacific.cpqcorp.net>
References: <20080201150805.GK27779@ochil.suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-class: urn:content-classes:message
In-Reply-To: <20080201150805.GK27779@ochil.suse.de>
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

Hi,
=20
With this implementation,I think it is not necessary to have the
'getprio' field in the mpentry structure.

We want to have 'getprio' in the mpentry strcture and some more
modifications in order to have LUN specific prio_callouts in device
mapper.Here is the link for the patch.
http://www.redhat.com/archives/dm-devel/2007-December/msg00026.html


Thanks,
Veena

> -----Original Message-----
> From: dm-devel-bounces@redhat.com=20
> [mailto:dm-devel-bounces@redhat.com] On Behalf Of Hannes Reinecke
> Sent: Friday, February 01, 2008 8:38 PM
> To: device-mapper development
> Subject: [dm-devel] [PATCH] multipath: Add compability=20
> 'command' prio handler
>=20
> Hi all,
>=20
> with the move to the libprio framework we change the layout=20
> of the configuration file. Without advance warning to the user.
>=20
> Not good.
>=20
> So here's a patch to implement a compatible 'command' prio=20
> handler, which re-implements the old 'getprio' keyword=20
> handling on top of the existing libprio framework.
> And we print a nice fat warning to the user.
>=20
> As usual, comments etc are welcome.
>=20
> Cheers,
>=20
> Hannes
> --=20
> Dr. Hannes Reinecke		      zSeries & Storage
> hare@suse.de			      +49 911 74053 688
> SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N rnberg
> GF: Markus Rex, HRB 16746 (AG N rnberg)
>=20
