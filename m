From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm-thin: wakeup worker only when deferred bios exist
Date: Thu, 14 Nov 2019 10:48:48 -0500
Message-ID: <20191114154848.GA21426@redhat.com>
References: <1573740655-104317-1-git-send-email-jefflexu@linux.alibaba.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1573740655-104317-1-git-send-email-jefflexu@linux.alibaba.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Content-Disposition: inline
To: Jeffle Xu <jefflexu@linux.alibaba.com>
Cc: joseph.qi@linux.alibaba.com, ejt@redhat.com, dm-devel@redhat.com, agk@redhat.com
List-Id: dm-devel.ids

On Thu, Nov 14 2019 at  9:10am -0500,
Jeffle Xu <jefflexu@linux.alibaba.com> wrote:

> Single thread fio test (read, bs=3D4k, ioengine=3Dlibaio, iodepth=3D128,
> numjobs=3D1) over dm-thin device has poor performance versus bare nvme
> disk on v5.4.0-rc7.
>=20
> Further investigation with perf indicates that queue_work_on() consumes
> over 20% CPU time when doing IO over dm-thin device. The call stack is
> as follows.
>=20
> - 46.64% thin_map
>    + 22.28% queue_work_on
>    + 12.98% dm_thin_find_block
>    + 5.07% cell_defer_no_holder
>    + 2.42% bio_detain.isra.33
>    + 0.95% inc_all_io_entry.isra.31.part.32
>      0.80% remap.isra.41
>=20
> In cell_defer_no_holder(), wakeup_worker() is always called, no matter wh=
ether
> the cell->bios list is empty or not. In single thread IO model, cell->bio=
s list
> is most likely empty. So skip waking up worker thread if cell->bios list =
is
> empty.
>=20
> A significant IO performance of single thread can be seen with this patch=
.
> The original IO performance is 445 MiB/s with the fio test previously
> described, while it is 643 MiB/s after applying the patch, which is a
> 44% performance improvement.
>=20
> Signed-off-by: Jeffle Xu <jefflexu@linux.alibaba.com>


Nice find, implementation detail questions inlined below.

> ---
>  drivers/md/dm-bio-prison-v1.c |  8 +++++++-
>  drivers/md/dm-bio-prison-v1.h |  2 +-
>  drivers/md/dm-thin.c          | 10 ++++++----
>  3 files changed, 14 insertions(+), 6 deletions(-)
>=20
> diff --git a/drivers/md/dm-bio-prison-v1.c b/drivers/md/dm-bio-prison-v1.=
c
> index b538989..b2a9b8d 100644
> --- a/drivers/md/dm-bio-prison-v1.c
> +++ b/drivers/md/dm-bio-prison-v1.c
> @@ -219,11 +219,17 @@ static void __cell_release_no_holder(struct dm_bio_=
prison *prison,
> =20
>  void dm_cell_release_no_holder(struct dm_bio_prison *prison,
>  =09=09=09       struct dm_bio_prison_cell *cell,
> -=09=09=09       struct bio_list *inmates)
> +=09=09=09       struct bio_list *inmates, int *empty)
>  {
>  =09unsigned long flags;
> =20
>  =09spin_lock_irqsave(&prison->lock, flags);
> +=09/*
> +=09 * The empty flag should represent the list state exactly
> +=09 * when the list is merged into @inmates, thus get the
> +=09 * list state when prison->lock is held.
> +=09 */
> +=09*empty =3D bio_list_empty(&cell->bios);
>  =09__cell_release_no_holder(prison, cell, inmates);
>  =09spin_unlock_irqrestore(&prison->lock, flags);
>  }
> diff --git a/drivers/md/dm-bio-prison-v1.h b/drivers/md/dm-bio-prison-v1.=
h
> index cec52ac..500edbc 100644
> --- a/drivers/md/dm-bio-prison-v1.h
> +++ b/drivers/md/dm-bio-prison-v1.h
> @@ -89,7 +89,7 @@ void dm_cell_release(struct dm_bio_prison *prison,
>  =09=09     struct bio_list *bios);
>  void dm_cell_release_no_holder(struct dm_bio_prison *prison,
>  =09=09=09       struct dm_bio_prison_cell *cell,
> -=09=09=09       struct bio_list *inmates);
> +=09=09=09       struct bio_list *inmates, int *empty);
>  void dm_cell_error(struct dm_bio_prison *prison,
>  =09=09   struct dm_bio_prison_cell *cell, blk_status_t error);
> =20
> diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
> index fcd8877..51fd396 100644
> --- a/drivers/md/dm-thin.c
> +++ b/drivers/md/dm-thin.c
> @@ -480,9 +480,9 @@ static void cell_visit_release(struct pool *pool,
> =20
>  static void cell_release_no_holder(struct pool *pool,
>  =09=09=09=09   struct dm_bio_prison_cell *cell,
> -=09=09=09=09   struct bio_list *bios)
> +=09=09=09=09   struct bio_list *bios, int *empty)
>  {
> -=09dm_cell_release_no_holder(pool->prison, cell, bios);
> +=09dm_cell_release_no_holder(pool->prison, cell, bios, empty);
>  =09dm_bio_prison_free_cell(pool->prison, cell);
>  }
> =20
> @@ -886,12 +886,14 @@ static void cell_defer_no_holder(struct thin_c *tc,=
 struct dm_bio_prison_cell *c
>  {
>  =09struct pool *pool =3D tc->pool;
>  =09unsigned long flags;
> +=09int empty;
> =20
>  =09spin_lock_irqsave(&tc->lock, flags);
> -=09cell_release_no_holder(pool, cell, &tc->deferred_bio_list);
> +=09cell_release_no_holder(pool, cell, &tc->deferred_bio_list, &empty);
>  =09spin_unlock_irqrestore(&tc->lock, flags);
> =20
> -=09wake_worker(pool);
> +=09if (!empty)
> +=09=09wake_worker(pool);
>  }

Think your point is tc->deferred_bio_list may have bios already, before
the call to cell_release_no_holder, so simply checking if it is empty
after the cell_release_no_holder call isn't enough?

But if tc->deferred_bio_list isn't empty then there is work that needs
to be done, regardless of whether this particular cell created work, so
I'm left wondering if you first tried simply checking if
tc->deferred_bio_list is empty after cell_release_no_holder() in
cell_defer_no_holder?

Thanks,
Mike
