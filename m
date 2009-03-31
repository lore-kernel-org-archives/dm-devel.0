From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] Handle multipath paths in a path group
 properly during pg_init
Date: Tue, 31 Mar 2009 08:33:35 +0200
Message-ID: <49D1B93F.6020900@suse.de>
References: <1238436452.5858.2.camel@chandra-ubuntu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1238436452.5858.2.camel@chandra-ubuntu>
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
Cc: Mike Anderson <andmike@us.ibm.com>, dm-devel <dm-devel@redhat.com>, Alasdair G Kergon <agk@redhat.com>, "Moger, Babu" <Babu.Moger@lsi.com>
List-Id: dm-devel.ids

Chandra Seetharaman wrote:
> Resending the patch to get in patchwork...
> -------
> The problem reported by Moger Babu was caused due to the architectural
> change made when we moved from dm hardware handler to SCSI hardware
> handler.
>=20
> Thanks Babu for finding and reporting the bug.
>=20
> All of the hardware handlers, do have a state now, and they are set to
> active and (some form of) inactive. All of them have prep_fn, which use
> this "state" to fail the I/O without it ever being sent to the device.
>=20
> As Babu has noted in his email, the pg_init/activate is sent on only on=
e
> path and the "state" of that path is changed appropriately to "active"
> while other paths in the same path group are never changed as they neve=
r
> got an "activate".
>=20
> Attached is a patch (compiled, tested, but not clean yet), which makes
> changes in the dm-multipath layer to send an "activate" on each paths i=
n
> the path groups.
>=20
> Mike (Anderson) and I had a discussion about whether to implement this
> in the dm-mulitpath layer or in the SCSI hardware handler layer and we
> came to a conclusion that it is best suited to be in the dm-mulitpath
> layer as it is the one that knows the relationship between different
> paths.
>=20
> If it were to be done at the Hardware handler layer, then the hardware
> handler may end up having a different notion of the path relationship
> and hence may not work as expected by the dm-multipath layer.
>=20
> This patch has been tested by Hannes in EMC storage. Babu and I tested =
it
> in LSI storage.
> ----------
>=20
> Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>
>=20
Acked-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Markus Rex, HRB 16746 (AG N=FCrnberg)
