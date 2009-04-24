From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 7/7] dm-mpath: convert to request-based
Date: Fri, 24 Apr 2009 11:04:26 +0200
Message-ID: <49F1809A.1020906@suse.de>
References: <49F17409.4060201@ct.jp.nec.com> <49F1754F.3050706@ct.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <49F1754F.3050706@ct.jp.nec.com>
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
Cc: Alasdair Kergon <agk@redhat.com>
List-Id: dm-devel.ids

Kiyoshi Ueda wrote:
> This patch converts dm-multipath target to request-based from bio-based=
.
>=20
> Basically, the patch just converts the I/O unit from struct bio
> to struct request.
> In the course of the conversion, it also changes the I/O queueing
> mechanism.  The change in the I/O queueing is described in details
> as follows.
>=20
> I/O queueing mechanism change
> -----------------------------
> In I/O submission, map_io(), there is no mechanism change from
> bio-based, since the clone request is ready for retry as it is.
> However, in I/O complition, do_end_io(), there is a mechanism change
> from bio-based, since the clone request is not ready for retry.
>=20
> In do_end_io() of bio-based, the clone bio has all needed memory
> for resubmission.  So the target driver can queue it and resubmit
> it later without memory allocations.
> The mechanism has almost no overhead.
>=20
> On the other hand, in do_end_io() of request-based, the clone request
> doesn't have clone bios, so the target driver can't resubmit it
> as it is.  To resubmit the clone request, memory allocation for
> clone bios is needed, and it takes some overheads.
> To avoid the overheads just for queueing, the target driver doesn't
> queue the clone request inside itself.
> Instead, the target driver asks dm core for queueing and remapping
> the original request of the clone request, since the overhead for
> queueing is just a freeing memory for the clone request.
>=20
> As a result, the target driver doesn't need to record/restore
> the information of the original request for resubmitting
> the clone request.  So dm_bio_details in dm_mpath_io is removed.
>=20
>=20
> multipath_busy()
> ---------------------
> The target driver returns "busy", only when the following case:
>   o The target driver will map I/Os, if map() function is called
>   and
>   o The mapped I/Os will wait on underlying device's queue due to
>     their congestions, if map() function is called now.
>=20
> In other cases, the target driver doesn't return "busy".
> Otherwise, dm core will keep the I/Os and the target driver can't
> do what it wants.
> (e.g. the target driver can't map I/Os now, so wants to kill I/Os.)
>=20
>=20
> Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
> Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
Acked-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
GF: Markus Rex, HRB 16746 (AG N=C3=BCrnberg)
