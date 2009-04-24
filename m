From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 6/7] dm core: disable interrupt when taking
	map_lock
Date: Fri, 24 Apr 2009 11:00:10 +0200
Message-ID: <49F17F9A.9040409@suse.de>
References: <49F17409.4060201@ct.jp.nec.com> <49F17530.2060701@ct.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <49F17530.2060701@ct.jp.nec.com>
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
Cc: Christof Schmitt <christof.schmitt@de.ibm.com>, Alasdair Kergon <agk@redhat.com>
List-Id: dm-devel.ids

Kiyoshi Ueda wrote:
> This patch disables interrupt when taking map_lock to prevent
> needless lockdep warnings in request-based dm.
>=20
> request-based dm takes map_lock after taking queue_lock with
> disabling interrupt:
>   spin_lock_irqsave(queue_lock)
>   q->request_fn() =3D=3D dm_request_fn()
>     =3D> dm_get_table()
>          =3D> read_lock(map_lock)
> while queue_lock could be taken in interrupt context.
>=20
> So lockdep warns that a deadlock can happen:
>   write_lock(map_lock)
>   <interrupt>
>   spin_lock_irqsave(queue_lock)
>   q->request_fn() =3D=3D dm_request_fn()
>     =3D> dm_get_table()
>          =3D> read_lock(map_lock)
>=20
> Currently there is no such code path in request-based dm where
> q->request_fn() is called from interrupt context, so no such deadlock
> happens.
> But such warning messages confuse users, so prevent them by disabling
> interrupt when taking map_lock.
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
