From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH] dm writecache: handle REQ_FUA
Date: Tue, 5 Nov 2019 12:56:58 -0500 (EST)
Message-ID: <alpine.LRH.2.02.1911051255320.23929@file01.intranet.prod.int.rdu2.redhat.com>
References: <be77e96c-5d37-a9de-b0ed-ee15d0c59215@petasan.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <be77e96c-5d37-a9de-b0ed-ee15d0c59215@petasan.org>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Maged Mokhtar <mmokhtar@petasan.org>, Mike Snitzer <msnitzer@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Acked-By: Mikulas Patocka <mpatocka@redhat.com>

=09Also add this line, so that it gets backported:

Cc: stable@vger.kernel.org=09# 4.18+

On Wed, 23 Oct 2019, Maged Mokhtar wrote:

> Call writecache_flush() on REQ_FUA.
>=20
> Signed-off-by: Maged Mokhtar <mmokhtar@petasan.org>
> ---
>  drivers/md/dm-writecache.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>=20
> --- a/drivers/md/dm-writecache.c=092019-10-23 22:01:18.480115962 +0200
> +++ b/drivers/md/dm-writecache.c=092019-10-23 22:02:08.616113729 +0200
> @@ -1218,7 +1218,8 @@ bio_copy:
>  =09=09=09}
>  =09=09} while (bio->bi_iter.bi_size);
>=20
> -=09=09if (unlikely(wc->uncommitted_blocks >=3D wc->autocommit_blocks))
> +=09=09if (unlikely(bio->bi_opf & REQ_FUA ||
> +=09=09=09=09wc->uncommitted_blocks >=3D
> wc->autocommit_blocks))
>  =09=09=09writecache_flush(wc);
>  =09=09else
>  =09=09=09writecache_schedule_autocommit(wc);
>=20
