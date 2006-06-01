From: Hannes Reinecke <hare@suse.de>
Subject: Re: IBM DS4300
Date: Thu, 01 Jun 2006 10:55:32 +0200
Message-ID: <447EAB84.9070404@suse.de>
References: <OFB2DC3C68.165CC670-ONC1257180.002CC9D2-C1257180.002D51F4@de.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <OFB2DC3C68.165CC670-ONC1257180.002CC9D2-C1257180.002D51F4@de.ibm.com>
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

Holger Smolinski wrote:
> Gil,
>=20
> DS4300 has two modes:
>=20
> AVT, which means only one path can be used at any point in time. Using =
an
> alternate path will cause Automated Volume Transfer and add significant
> latency.
> RDAC, which means only one path can be used at any point in time. Using=
 an
> alternate path will cause an I/O error unless the volume has been migra=
ted
> manually or by a hardware_handler.
>=20
And you _really_ will want to use AVT. RDAC mode is currently _not_
supported by multipath-tools.
For AVT mode you should use the pp_tpc prioritizer.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke			hare@suse.de
SuSE Linux Products GmbH		S390 & zSeries
Maxfeldstra=DFe 5				+49 911 74053 688
90409 N=FCrnberg				http://www.suse.de
