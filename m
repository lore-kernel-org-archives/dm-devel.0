From: Hannes Reinecke <hare@suse.de>
Subject: Re: [RESEND] [PATCH] Use Average path priority value for
	path switching
Date: Fri, 31 Jul 2009 08:06:17 +0200
Message-ID: <4A7289D9.8000208@suse.de>
References: <1246583474.30568.2.camel@chandra-ubuntu>
	<1248984835.18243.5.camel@chandra-ubuntu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1248984835.18243.5.camel@chandra-ubuntu>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: sekharan@linux.vnet.ibm.com
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Chandra Seetharaman wrote:
> Hi Christophe,
>=20
> I submitted this patch on Jul 2
> (http://marc.info/?l=3Ddm-devel&m=3D124658334721911&w=3D2). Resending i=
t.
>=20
> Only change is a field name from up_paths to enabled_paths.
>=20
> Hi Hannes,
>=20
> Need an ACK from you :-).
>=20
> regards,
>=20
> chandra
>=20
> -----------------------------------------------------------------------=
=20
> Failback happens only when the sum of priorities of all paths
> (on the higher priority path group) is greater than the sum
> of priorities of all paths on the lower priority path group.
>=20
> This leads into problems when there are more than one paths
> in each of the path groups, and the sum of all paths in the
> lower priority path group is greater than that of path priority
> of a single high priority path.
>=20
> This patch fixes the problem by using average priority of=20
> the path group to decide on which path group to switch over.
>=20
> Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>
Acked-by: Hannes Reinecke <hare@suse.de>

Thanks for this, Chandra.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Markus Rex, HRB 16746 (AG N=FCrnberg)
