From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 3/7] dm core: enable request-based dm
Date: Fri, 24 Apr 2009 10:50:50 +0200
Message-ID: <49F17D6A.3020305@suse.de>
References: <49F17409.4060201@ct.jp.nec.com> <49F174CD.403@ct.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <49F174CD.403@ct.jp.nec.com>
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
> This patch enables request-based dm.
>=20
> o Request-based dm and bio-based dm coexist, since there are
>   some target drivers which are more fitting to bio-based dm.
>   Also, there are other bio-based devices in the kernel
>   (e.g. md, loop).
>   Since bio-based device can't receive struct request,
>   there are some limitations on device stacking between
>   bio-based and request-based.
>=20
>                      type of underlying device
>                    bio-based      requeset-based
>    ----------------------------------------------
>     bio-based         OK                OK
>     request-based     NG                OK
>=20
>   The device type is recognized by the queue flag in the kernel,
>   so dm follows that.
>=20
> o The type of a dm device is decided at the first table binding time.
>   Once the type of a dm device is decided, the type can't be changed.
>=20
> o Mempool allocations are deferred to at the table loading time, since
>   mempools for request-based dm are different from those for bio-based
>   dm and needed mempool type is fixed by the type of table.
>=20
> o Currently, request-based dm supports only tables that have a single
>   target.  To support multiple targets, we need to support request
>   splitting or prevent bio/request from spanning multiple targets.
>   The former needs lots of changes in the block layer, and the latter
>   needs that all target drivers support merge() function.
>   Both will take a time.
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
