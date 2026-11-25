Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795582954;
	b=dRGqwoMyO4PFFaTWPj1jsC///QK0zGTUcXZ/9babMb0Rqxk/lsCCsNEldd1dugqZwpEs
	 qy5xIyjimA5SZDQ6sxrWoYYVf/QCsrh8WUc38XrmaaC8z6zyCwcc0cGpw8arzLsNNF2PG
	 5jFsk2tPhLNWJDQwNksmfhFOGrwtPINT+qpBt8b+/i7J+otFWE9EtI8q/tHu2xGujYZyP
	 2Ptcif/tu/pcmKVjzAUbpjYnomMRA3+qD7HJc19AW0giZ7kzvKV8xfOxd6Svf6m6B8BiL
	 /wsQzPFVa/dxTp6Bfhtf52cGEQqpERp24vNoXlmpbsy0vv5m+7bESsr/4nnl/QyQ5xw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795582954;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=L9j+W69Jo0+8zovjJGFFXi36YG7e0lpHkp0+CHPuszk=;
	b=IQ4crO1D/IItxesWvXmUZ32AxBt2CSQKXKn8FdcnvUgyIuS5ZO9PixAJEIGAO7BkhiEz
	 6U8GARR6EIgEXJPsFxp9PCfw7PlI4RVz3AuFbJmmiWNQXvI2/jNh1nP+gkTOWfCzKAPqq
	 yVtmNpxu5KDsZfxsC2X/a+60QEhEId37Gd4sIJ1s03eS5NrVweQuw/nsBxbSPfnOu/YlT
	 nFFRpi1DFE6yDFry1HW7S+NB7AUVdcgGqli/rugQ07c5FFTaANuJ6eVftCp+2qXzMJtVI
	 JDSoOi7eNYxoyp2aNwpS2GZYt+m7hbe56VTZ6Yaodx/ch4qWkb09gVP7amamXQtVg6g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="Sl/MDOlP";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F203606A321
	for <dm-devel@lists.linux.dev>; Wed, 25 Nov 2026 05:02:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Sl/MDOlP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F00511F000C0;
	Wed, 25 Nov 2026 05:02:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795582953;
	bh=L9j+W69Jo0+8zovjJGFFXi36YG7e0lpHkp0+CHPuszk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Sl/MDOlP9vnKRxwKWjsLEW709EU+5XsQScvSaboaIuF+iAAWoDr2WyqRTTbtfsGlz
	 HKYshuElvnrMgXx9vkMFOVc4nH38lYLwmXtiJZvK3ZVszN3lo2gqlaON5oX8mrR2ge
	 Tmjp85yxjilfjKkUs0eLU2FjIYq1/LeB6ucdVeQm/jBvfwuooYRgfBzuV1+30ZafPH
	 ERX00rLtWLIQm4VMu8nWsBwKMd4iYZDekZbAbz7gkFqochY3VcAlVjQWo/MC8i9UWV
	 ftT82ffr6mC9a+4QuiBSXMkyfebX0b7qFWFetiXkEteqQMTbGAnFkL2D43tnXE/Ksf
	 nHpS0wRgds04A==
Message-ID: <sashiko-outbox-232600@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 2/2] dm thin: add wait_for_commit pool feature
Reply-To: sashiko-reviews@lists.linux.dev
To: "Peng Yu" <yupeng0921@gmail.com>, "Alasdair Kergon" <agk@redhat.com>, "Mike
 Snitzer" <snitzer@kernel.org>, "Mikulas Patocka" <mpatocka@redhat.com>, "Benjamin
 Marzinski" <bmarzins@redhat.com>
Cc: "Joe Thornber" <ejt@redhat.com>, dm-devel@lists.linux.dev
In-Reply-To: <20261125043325.138351-3-yupeng0921@gmail.com>
References: <20261125043325.138351-1-yupeng0921@gmail.com>
 <20261125043325.138351-3-yupeng0921@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 25 Nov 2026 05:02:32 +0000
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list

Thank you for your contribution! Sashiko AI review found 7 potential
issues to consider:
- [High] dm thin: bio_triggers_commit() misses failed commits on flush
  and FUA bios
- [High] dm thin: process_prepared_discard_passdown_pt2() skips commit
  after passdown
- [High] dm thin: __issue() defers plain writes after releasing virtual
  prison cell
- [High] dm thin: intermediate commit in alloc_data_block() reorders or
  fails writes
- [Medium] dm thin: deferred discard mappings in
  complete_discard_mapping() stall worker
- [Medium] dm thin: process_discard_cell_passdown() completes unmapped
  discards early
- [Medium] dm thin: process_prepared_discard_no_passdown() unlocks cell
  before commit
--

commit 98dea49cd9146a4b359aeeb9b766e485fc31d970
Author: Peng Yu <yupeng0921@gmail.com>

dm thin: add wait_for_commit pool feature

This commit adds the wait_for_commit pool feature to dm-thin so that
writes and discards on a thin device with uncommitted metadata changes
wait for the metadata transaction to be committed before completing.

> diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
> index 358ed77ffb2be..93ce83674c63f 100644
> --- a/drivers/md/dm-thin.c
> +++ b/drivers/md/dm-thin.c
[ ... ]
> @@ -732,10 +734,18 @@ static void remap_to_origin(struct thin_c *tc, stru=
ct bio *bio)
>  	bio_set_dev(bio, tc->origin_dev->bdev);
>  }
> =20
> -static int bio_triggers_commit(struct thin_c *tc, struct bio *bio)
> +static bool wait_for_commit_write(struct thin_c *tc, struct bio *bio)
>  {
> -	return op_is_flush(bio->bi_opf) &&
> -		dm_thin_changed_this_transaction(tc->td);
> +	return tc->pool->pf.wait_for_commit && bio_op(bio) =3D=3D REQ_OP_WRITE =
&&
> +		!op_is_flush(bio->bi_opf);
> +}
> +
> +static int bio_triggers_commit(struct thin_c *tc, struct bio *bio, bool =
hold)
> +{
> +	if (op_is_flush(bio->bi_opf))
> +		return dm_thin_changed_this_transaction(tc->td);
> +
> +	return hold && dm_thin_uncommitted(tc->td);
>  }

[Severity: High]
Can REQ_FUA and REQ_PREFLUSH bios bypass failed-commit detection here when
wait_for_commit is enabled?

In __commit_transaction(), __write_changed_details() clears td->changed on
all open thin devices before dm_sm_commit() and dm_tm_commit() run.  If
the commit fails after __write_changed_details(), td->changed is false
while pmd->commit_failed is true (and abort_transaction() copies the
cleared td->changed into td->aborted_with_changes).

Because bio_triggers_commit() checks dm_thin_changed_this_transaction()
instead of dm_thin_uncommitted() when op_is_flush(bio->bi_opf) is true, it
returns false after such a commit failure.  An in-flight REQ_FUA
whole-block overwrite whose new mapping was rolled back will then complete
with success in complete_overwrite_bio(), and subsequent REQ_FUA or
REQ_PREFLUSH writes in __issue() will be submitted and succeed even though
plain writes fail.

>  static void inc_all_io_entry(struct pool *pool, struct bio *bio)
> @@ -749,11 +759,12 @@ static void inc_all_io_entry(struct pool *pool, str=
uct bio *bio)
>  	h->all_io_entry =3D dm_deferred_entry_inc(pool->all_io_ds);
>  }
> =20
> -static void issue(struct thin_c *tc, struct bio *bio)
> +static void __issue(struct thin_c *tc, struct bio *bio, bool may_hold)
>  {
>  	struct pool *pool =3D tc->pool;
> +	bool hold =3D may_hold && wait_for_commit_write(tc, bio);
> =20
> -	if (!bio_triggers_commit(tc, bio)) {
> +	if (!bio_triggers_commit(tc, bio, hold)) {
>  		dm_submit_bio_remap(bio, NULL);
>  		return;
>  	}
> @@ -777,6 +788,11 @@ static void issue(struct thin_c *tc, struct bio *bio)
>  	spin_unlock_irq(&pool->lock);
>  }
> =20
> +static void issue(struct thin_c *tc, struct bio *bio)
> +{
> +	__issue(tc, bio, true);
> +}

[Severity: High]
Does deferring plain writes to pool->deferred_flush_bios in __issue()
allow reads and later writes to the same block to overtake them once the
virtual prison cell is released?

In process_prepared_mapping() (when m->bio is NULL) and process_cell(),
remap_and_issue() queues the holder write bio onto
pool->deferred_flush_bios without submitting it to the data device, and
inc_remap_and_issue_cell() immediately releases the virtual cell:

kworker (do_worker)               CPU1
process_prepared_mapping()
  remap_and_issue(holder_write)
    __issue()
      bio_list_add(&pool->deferred_flush_bios,
                   holder_write)
  inc_remap_and_issue_cell(m->cell)
    cell_release()
    remap_and_issue(detained_read)
      __issue()
        dm_submit_bio_remap(detained_read)
          <-- submitted before holder_write
                                  thin_bio_map(new_read)
                                    bio_detain(virt_cell)
                                    ...
                                    return DM_MAPIO_REMAPPED
                                      <-- submitted before holder_write
process_deferred_bios()
  commit(pool)
    __write_changed_details()
      td->changed =3D false
                                  thin_bio_map(newer_write)
                                    dm_thin_find_block()
                                      result.changed =3D=3D false
                                    return DM_MAPIO_REMAPPED
                                      <-- overtakes holder_write
  dm_submit_bio_remap(holder_write)

Detained and concurrent reads observe stale pre-write data on the data
device, and a concurrent write arriving in thin_bio_map() right after
__write_changed_details() clears td->changed can be submitted before
process_deferred_bios() drains deferred_flush_bios, causing the older
write to overwrite the newer one.

[ ... ]

> @@ -1056,6 +1074,28 @@ static void process_prepared_discard_success(struc=
t dm_thin_new_mapping *m)
>  	free_discard_mapping(m);
>  }
> =20
> +static void complete_discard_mapping(struct dm_thin_new_mapping *m)
> +{
> +	struct thin_c *tc =3D m->tc;
> +	struct pool *pool =3D tc->pool;
> +
> +	if (!pool->pf.wait_for_commit || !dm_thin_uncommitted(tc->td)) {
> +		bio_endio(m->bio);
> +		mempool_free(m, &pool->mapping_pool);
> +		return;
> +	}
> +
> +	if (dm_thin_aborted_changes(tc->td)) {
> +		bio_io_error(m->bio);
> +		mempool_free(m, &pool->mapping_pool);
> +		return;
> +	}
> +
> +	spin_lock_irq(&pool->lock);
> +	list_add_tail(&m->list, &pool->deferred_discard_completions);
> +	spin_unlock_irq(&pool->lock);
> +}

[Severity: Medium]
When discard_passdown is enabled, can a discard bio complete without
reaching complete_discard_mapping() even though tc->td has uncommitted
metadata changes?

drivers/md/dm-thin.c:process_discard_cell_passdown() {
	...
	h->cell =3D virt_cell;
	break_up_discard_bio(tc, virt_cell->key.block_begin, virt_cell->key.block_=
end, bio);

	bio_endio(bio);
}

If the target range has no mapped blocks in the in-memory btree (for
example, because an earlier discard in the same uncommitted transaction
already removed the mapping), break_up_discard_bio() creates no
dm_thin_new_mapping objects and process_discard_cell_passdown() completes
the discard bio immediately via bio_endio(bio) before the transaction is
committed.

>  static void process_prepared_discard_no_passdown(struct dm_thin_new_mapp=
ing *m)
>  {
>  	int r;
> @@ -1065,11 +1105,13 @@ static void process_prepared_discard_no_passdown(=
struct dm_thin_new_mapping *m)
>  	if (r) {
>  		metadata_operation_failed(tc->pool, "dm_thin_remove_range", r);
>  		bio_io_error(m->bio);
> -	} else
> -		bio_endio(m->bio);
> +		cell_defer_no_holder(tc, m->cell);
> +		mempool_free(m, &tc->pool->mapping_pool);
> +		return;
> +	}
> =20
>  	cell_defer_no_holder(tc, m->cell);
> -	mempool_free(m, &tc->pool->mapping_pool);
> +	complete_discard_mapping(m);
>  }

[Severity: Medium]
In process_prepared_discard_no_passdown(), does calling
cell_defer_no_holder(tc, m->cell) before the discard is committed release
detained bios too early?

When do_worker() runs process_prepared() for prepared_discards,
cell_defer_no_holder() releases the virtual cell and moves any detained
bios onto tc->deferred_bio_list while m is queued on
pool->deferred_discard_completions.  process_deferred_bios() then runs
process_thin_deferred_bios(tc) before calling commit(pool), so a detained
read to the discarded block sees -ENODATA in the uncommitted btree and
completes with zeroes before the discard has been committed (even if
commit(pool) subsequently fails).

> @@ -1206,11 +1248,13 @@ static void process_prepared_discard_passdown_pt2=
(struct dm_thin_new_mapping *m)
>  	if (r) {
>  		metadata_operation_failed(pool, "dm_pool_dec_data_range", r);
>  		bio_io_error(m->bio);
> -	} else
> -		bio_endio(m->bio);
> +		cell_defer_no_holder(tc, m->cell);
> +		mempool_free(m, &pool->mapping_pool);
> +		return;
> +	}
> =20
>  	cell_defer_no_holder(tc, m->cell);
> -	mempool_free(m, &pool->mapping_pool);
> +	complete_discard_mapping(m);
>  }

[Severity: High]
Can complete_discard_mapping() see dm_thin_uncommitted(tc->td) =3D=3D false=
 in
process_prepared_discard_passdown_pt2() and complete the discard without
committing the data space-map decrement?

In process_prepared_discard_passdown_pt1(), dm_thin_remove_range() sets
tc->td->changed =3D true and dm_pool_inc_data_range() pins the data blocks
while the passdown discard bio is in flight.  If a commit runs while the
passdown bio is in flight (for instance, triggered by another write or
discard in the batch), __write_changed_details() clears tc->td->changed to
false.  When the passdown bio finishes and
process_prepared_discard_passdown_pt2() calls dm_pool_dec_data_range(),
that call mutates pool->pmd->data_sm without setting tc->td->changed, so
complete_discard_mapping() sees dm_thin_uncommitted(tc->td) =3D=3D false and
completes m->bio immediately while leaving the freed data blocks
uncommitted on disk.

[ ... ]

> @@ -2359,6 +2404,8 @@ static void process_deferred_bios(struct pool *pool)
>  {
>  	struct bio *bio;
>  	struct bio_list bios, bio_completions;
> +	struct list_head discard_completions;
> +	struct dm_thin_new_mapping *m, *tmp;
>  	struct thin_c *tc;
> =20
>  	tc =3D get_first_thin(pool);
> @@ -2374,6 +2421,7 @@ static void process_deferred_bios(struct pool *pool)
>  	 */
>  	bio_list_init(&bios);
>  	bio_list_init(&bio_completions);
> +	INIT_LIST_HEAD(&discard_completions);
> =20
>  	spin_lock_irq(&pool->lock);
>  	bio_list_merge(&bios, &pool->deferred_flush_bios);
> @@ -2381,9 +2429,12 @@ static void process_deferred_bios(struct pool *poo=
l)
> =20
>  	bio_list_merge(&bio_completions, &pool->deferred_flush_completions);
>  	bio_list_init(&pool->deferred_flush_completions);
> +
> +	list_splice_init(&pool->deferred_discard_completions, &discard_completi=
ons);
>  	spin_unlock_irq(&pool->lock);
> =20
>  	if (bio_list_empty(&bios) && bio_list_empty(&bio_completions) &&
> +	    list_empty(&discard_completions) &&
>  	    !(dm_pool_changed_this_transaction(pool->pmd) && need_commit_due_to=
_time(pool)))
>  		return;
> =20
> @@ -2392,6 +2443,11 @@ static void process_deferred_bios(struct pool *poo=
l)
> =20
>  		while ((bio =3D bio_list_pop(&bios)))
>  			bio_io_error(bio);
> +
> +		list_for_each_entry_safe(m, tmp, &discard_completions, list) {
> +			bio_io_error(m->bio);
> +			mempool_free(m, &pool->mapping_pool);
> +		}
>  		return;
>  	}
>  	pool->last_commit_jiffies =3D jiffies;
> @@ -2399,6 +2455,11 @@ static void process_deferred_bios(struct pool *poo=
l)
>  	while ((bio =3D bio_list_pop(&bio_completions)))
>  		bio_endio(bio);
> =20
> +	list_for_each_entry_safe(m, tmp, &discard_completions, list) {
> +		bio_endio(m->bio);
> +		mempool_free(m, &pool->mapping_pool);
> +	}

[Severity: High]
What happens to bios already queued in deferred_flush_bios,
deferred_flush_completions, and deferred_discard_completions when
alloc_data_block() triggers an intermediate commit(pool) inside the
process_thin_deferred_cells() / process_thin_deferred_bios() loop at the
top of process_deferred_bios()?

When alloc_data_block() runs out of free data or metadata blocks in the
current transaction, it calls commit(pool) directly without draining the
deferred lists:

drivers/md/dm-thin.c:alloc_data_block() {
	...
	if (!free_blocks) {
		/* Let's commit before we use up the metadata reserve. */
		r =3D commit(pool);
		if (r)
			return r;
	}
	...
}

That intermediate commit clears td->changed on all thin devices while
earlier plain writes from process_prepared_mapping() or earlier iterations
of the loop are still sitting unsubmitted in pool->deferred_flush_bios, so
any subsequent write to the same mapped block processed later in
process_thin_deferred_bios() sees td->changed =3D=3D false and is submitted=
 to
the data device ahead of the older write.  In addition, if that
intermediate commit succeeds and check_for_metadata_space() transitions
the pool to PM_OUT_OF_METADATA_SPACE, the second commit(pool) in
process_deferred_bios() returns -EINVAL and fails all waiting bios in
bios, bio_completions, and discard_completions with BLK_STS_IOERR even
though their metadata changes were already committed.

[Severity: Medium]
Can holding struct dm_thin_new_mapping objects in
pool->deferred_discard_completions until the end of
process_deferred_bios() exhaust pool->mapping_pool and stall deferred
work?

Previously, completed discard mappings were freed back to
pool->mapping_pool before process_deferred_bios() ran, so
ensure_next_mapping(pool) only failed when all mappings were in
asynchronous preparation stages whose completion callbacks call
wake_worker(pool).  Now mappings waiting in
pool->deferred_discard_completions remain allocated across
process_thin_deferred_cells() and process_thin_deferred_bios() (and in
no_discard_passdown mode when pool->all_io_ds is empty,
process_discard_cell_no_passdown() synchronously adds another mapping to
deferred_discard_completions on each iteration).  If pool->mapping_pool is
exhausted, ensure_next_mapping(pool) aborts the loop and leaves the
remaining cells and bios on tc->deferred_cells and tc->deferred_bio_list,
and freeing discard_completions after commit(pool) does not call
wake_worker(pool).

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261125043325.1383=
51-1-yupeng0921@gmail.com?part=3D2
