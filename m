Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D1B70C433EF
	for <dm-devel@archiver.kernel.org>; Wed, 24 Nov 2021 00:29:49 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-29-Qut9ghI7PSGgNuX12b96Gw-1; Tue, 23 Nov 2021 19:29:45 -0500
X-MC-Unique: Qut9ghI7PSGgNuX12b96Gw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D331284BA0B;
	Wed, 24 Nov 2021 00:29:40 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 889D45D6CF;
	Wed, 24 Nov 2021 00:29:40 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 0C1E41832E78;
	Wed, 24 Nov 2021 00:29:40 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
	[10.11.54.1])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1AO07ZUK000606 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 23 Nov 2021 19:07:35 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 1660F40CFD0D; Wed, 24 Nov 2021 00:07:35 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 10A0640CFD04
	for <dm-devel@redhat.com>; Wed, 24 Nov 2021 00:07:35 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E0FC88027FB
	for <dm-devel@redhat.com>; Wed, 24 Nov 2021 00:07:34 +0000 (UTC)
Received: from mail-yb1-f181.google.com (mail-yb1-f181.google.com
	[209.85.219.181]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-261-JDw1Vj8kNVyyht3RyDoGuw-1; Tue, 23 Nov 2021 19:07:33 -0500
X-MC-Unique: JDw1Vj8kNVyyht3RyDoGuw-1
Received: by mail-yb1-f181.google.com with SMTP id x32so1953435ybi.12
	for <dm-devel@redhat.com>; Tue, 23 Nov 2021 16:07:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:mime-version:references:in-reply-to:from:date
	:message-id:subject:to:cc;
	bh=oJEtXdy6wavz4704a9PX8wnOpCxhRXkerzJSgtQUXgw=;
	b=wOUTNW4Ce186E/n0bkM4zX3ncItLGiWiBX0TQS9NpumYdbqUhX+HnCj3bSITqF+mcX
	rXQzj8yF+qOfgPsZcs7hDaESCfF0obkiJHEyRcEiwUP0onrVdxAmjHBcw2MsgZmkGAa7
	cy4QHN9diY/DthGY2UV6XEewu62dEEj9iQZq2OQEUADyOPLSKtR+6hIMnJ8xH5gUIM7C
	UrcO/dSpt08y++b7QcoTDe5n5pRuC+Zd4XquhXXe+LVCxleDdexMIei33AhiUfuetGNm
	lhbb54Q//OBVD7qj00/5xs57UXvNE82OG6ibCGfx6bHK/ngOECNmxiJpVsm8U5tPfhua
	8Jsw==
X-Gm-Message-State: AOAM5309ce59bM7p8y0oke6I1qADEL7UWm+CSd+0wfX7FZ5U9XhNC3Nu
	m4NFn520O7uJhZb+ARnbYsJckz8f3OgHI3AHroKtFw==
X-Google-Smtp-Source: ABdhPJzjD2kVvbjgjJbjpSOGWD7IPL3zcKfXwEuGvp4zOp74ZgVrup5XmKj7tZnjkbyXztIG6AT0I4EmrWmamnSydFs=
X-Received: by 2002:a25:5d08:: with SMTP id r8mr10568201ybb.227.1637712452183; 
	Tue, 23 Nov 2021 16:07:32 -0800 (PST)
MIME-Version: 1.0
References: <alpine.LRH.2.02.2111231421490.24195@file01.intranet.prod.int.rdu2.redhat.com>
In-Reply-To: <alpine.LRH.2.02.2111231421490.24195@file01.intranet.prod.int.rdu2.redhat.com>
From: Akilesh Kailash <akailash@google.com>
Date: Tue, 23 Nov 2021 16:07:21 -0800
Message-ID: <CABSDvDL23UZ8KMrjK+qm0Lw0bfDaWh2TruZ2kLgGXqidgOt0jQ@mail.gmail.com>
To: Mikulas Patocka <mpatocka@redhat.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-loop: dm-devel@redhat.com
Cc: Mike Snitzer <msnitzer@redhat.com>, Heinz Mauelshagen <heinzm@redhat.com>,
	dm-devel@redhat.com, David Anderson <dvander@google.com>,
	Alasdair Kergon <agk@redhat.com>
Subject: Re: [dm-devel] [PATCH] announcing the dm-update target
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, Nov 23, 2021 at 1:03 PM Mikulas Patocka <mpatocka@redhat.com> wrote:
>
> Hi
>
> I announce the first version of the dm-update target. This target will
> perform background update of read-only system partition on embedded
> systems while the system is running.
>
> It performs similar functionality that is described in this presentation:
> https://linuxplumbersconf.org/event/11/contributions/1049/attachments/826/1562/2021%20LPC_%20dm-snapshot%20in%20user%20space.pdf
> (except that dm-update works entirely in kernel space)
>
> See the file Documentation/admin-guide/device-mapper/update.rst at the end
> of this patch for instructions how to use it.
>
> I'd like to ask Akilesh Kailash and David Anderson if they are interested
> in using this in Android. I am willing to extend the update target, so
> that it will handle Android update format.
>
> Mikulas
>
>
> Index: linux-2.6/drivers/md/Kconfig
> ===================================================================
> --- linux-2.6.orig/drivers/md/Kconfig
> +++ linux-2.6/drivers/md/Kconfig
> @@ -652,4 +652,14 @@ config DM_AUDIT
>           Enables audit logging of several security relevant events in the
>           particular device-mapper targets, especially the integrity target.
>
> +config DM_UPDATE
> +       tristate "Update target support"
> +       depends on BLK_DEV_DM
> +       select DM_BUFIO
> +       select CRYPTO
> +       help
> +         The dm-update target allows transparent updates for embedded devices
> +
> +         If unsure, say N.
> +
>  endif # MD
> Index: linux-2.6/drivers/md/Makefile
> ===================================================================
> --- linux-2.6.orig/drivers/md/Makefile
> +++ linux-2.6/drivers/md/Makefile
> @@ -83,6 +83,7 @@ obj-$(CONFIG_DM_LOG_WRITES)   += dm-log-wr
>  obj-$(CONFIG_DM_INTEGRITY)     += dm-integrity.o
>  obj-$(CONFIG_DM_ZONED)         += dm-zoned.o
>  obj-$(CONFIG_DM_WRITECACHE)    += dm-writecache.o
> +obj-$(CONFIG_DM_UPDATE)                += dm-update.o
>
>  ifeq ($(CONFIG_DM_INIT),y)
>  dm-mod-objs                    += dm-init.o
> Index: linux-2.6/drivers/md/dm-update.c
> ===================================================================
> --- /dev/null
> +++ linux-2.6/drivers/md/dm-update.c
> @@ -0,0 +1,751 @@
> +#include <linux/device-mapper.h>
> +#include <linux/module.h>
> +#include <linux/vmalloc.h>
> +#include <linux/dm-io.h>
> +#include <linux/crypto.h>
> +
> +#include "dm-update.h"
> +
> +#define DM_MSG_PREFIX "update"
> +
> +#define N_BUFFERS              16
> +
> +#define B_EMPTY                        0
> +#define B_LOADING              1
> +#define B_VALID                        2
> +
> +struct dm_update_buffer {
> +       int status;
> +       char *compressed_chunk;
> +       char *decompressed_chunk;
> +       uint64_t src;
> +       struct update_entry *e;
> +       struct bio_list waiting_bios;
> +       struct work_struct work;
> +       struct dm_update *u;
> +};
> +
> +struct dm_update {
> +       struct dm_dev *system_dev;
> +       struct dm_dev *update_dev;
> +       struct dm_target *ti;
> +       struct dm_io_client *dm_io;
> +       unsigned update_lbs;
> +       unsigned char update_lbs_bits;
> +       struct update_superblock *sb;
> +       struct crypto_comp *cc;
> +       struct update_entry *entries;
> +
> +       struct mutex mutex;
> +       struct workqueue_struct *decompress_wq;
> +       struct bio_list waiting_bios;
> +
> +       bool no_bg_update;
> +       struct workqueue_struct *bg_wq;
> +       struct work_struct bg_work;
> +       char *bg_compressed_chunk;
> +       char *bg_decompressed_chunk;
> +       size_t bg_index;
> +
> +       unsigned buffer_replacement;
> +       struct dm_update_buffer buffer[N_BUFFERS];
> +};
> +
> +static int update_rw(struct dm_update *u, bool system_dev, int req_op, sector_t sector, sector_t n_sectors, void *ptr)
> +{
> +       struct dm_io_region region;
> +       struct dm_io_request req;
> +
> +       region.bdev = system_dev ? u->system_dev->bdev : u->update_dev->bdev;
> +       region.sector = sector;
> +       region.count = n_sectors;
> +
> +       req.bi_op = req_op;
> +       req.bi_op_flags = REQ_SYNC;
> +       req.mem.type = DM_IO_VMA;
> +       req.mem.ptr.vma = ptr;
> +       req.client = u->dm_io;
> +       req.notify.fn = NULL;
> +       req.notify.context = NULL;
> +
> +       return dm_io(&req, 1, &region, NULL);
> +}
> +
> +static int update_decompress(struct dm_update *u, void *src, size_t src_size, void *dst, size_t dst_size)
> +{
> +       int r;
> +       if (!u->cc) {
> +               if (unlikely(src_size > dst_size))
> +                       return -EOVERFLOW;
> +               memcpy(dst, src, src_size);
> +       } else {
> +               unsigned dst_int;
> +               if (unlikely(src_size != (unsigned)src_size) ||
> +                   unlikely(dst_size != (unsigned)dst_size))
> +                       return -EOVERFLOW;
> +               dst_int = dst_size;
> +               r = crypto_comp_decompress(u->cc, src, src_size, dst, &dst_int);
> +               if (unlikely(r))
> +                       return r;
> +       }
> +       return 0;
> +}
> +
> +static void update_fill_from_buffer(struct dm_update *u, struct dm_update_buffer *b, struct bio *bio)
> +{
> +       struct bio_vec bv;
> +       struct bvec_iter iter;
> +
> +       struct update_entry *e = bio->bi_private;
> +       size_t data_offset = (size_t)le32_to_cpu(e->offset) << u->sb->block_bits;
> +       size_t bio_offset = (bio->bi_iter.bi_sector & ((1 << (u->sb->block_bits - SECTOR_SHIFT)) - 1)) << SECTOR_SHIFT;
> +       const char *data = b->decompressed_chunk + data_offset + bio_offset;
> +
> +       bio_for_each_segment(bv, bio, iter) {
> +               char *addr = kmap_local_page(bv.bv_page);
> +               memcpy(addr + bv.bv_offset, data, bv.bv_len);
> +               flush_dcache_page(bv.bv_page);
> +               kunmap_local(addr);
> +               data += bv.bv_len;
> +       }
> +
> +       bio_endio(bio);
> +}
> +
> +static void update_process_bio(struct dm_update *u, struct bio *bio)
> +{
> +       struct update_entry *e;
> +       struct dm_update_buffer *b;
> +       uint64_t src;
> +       int i;
> +
> +       e = bio->bi_private;
> +
> +       src = le32_to_cpu(e->src_lo) + ((uint64_t)le16_to_cpu(e->src_hi) << 32);
> +       for (i = 0; i < N_BUFFERS; i++) {
> +               b = &u->buffer[i];
> +               if (b->status == B_EMPTY)
> +                       continue;
> +               if (b->src == src) {
> +                       if (b->status == B_LOADING) {
> +                               bio_list_add(&b->waiting_bios, bio);
> +                       } else {
> +                               update_fill_from_buffer(u, b, bio);
> +                       }
> +                       return;
> +               }
> +       }
> +       for (i = 0; i < N_BUFFERS; i++) {
> +               b = &u->buffer[i];
> +               if (b->status == B_EMPTY) {
> +replace_buffer:
> +                       bio_list_add(&b->waiting_bios, bio);
> +                       b->status = B_LOADING;
> +                       b->src = src;
> +                       b->e = e;
> +                       queue_work(u->decompress_wq, &b->work);
> +                       return;
> +               }
> +       }
> +       for (i = 0; i < N_BUFFERS; i++) {
> +               b = &u->buffer[u->buffer_replacement];
> +               u->buffer_replacement = (u->buffer_replacement + 1) % N_BUFFERS;
> +               if (b->status == B_VALID)
> +                       goto replace_buffer;
> +       }
> +       bio_list_add(&u->waiting_bios, bio);
> +}
> +
> +static void dm_update_get_locations(struct dm_update *u, struct update_entry *e, uint64_t *src, sector_t *sector, sector_t *n_sectors, size_t *front_pad, size_t *compressed_length)
> +{
> +       uint64_t next_src;
> +       *src = le32_to_cpu(e->src_lo) + ((uint64_t)le16_to_cpu(e->src_hi) << 32);
> +       do {
> +               e++;
> +               next_src = le32_to_cpu(e->src_lo) + ((uint64_t)le16_to_cpu(e->src_hi) << 32);
> +       } while (next_src == *src);
> +
> +       *compressed_length = next_src - *src;
> +       *front_pad = *src & (u->update_lbs - 1);
> +       *sector = *src >> u->update_lbs_bits << (u->update_lbs_bits - SECTOR_SHIFT);
> +       *n_sectors = round_up(*front_pad + *compressed_length, u->update_lbs) >> SECTOR_SHIFT;
> +}
> +
> +static void dm_update_buffer_work(struct work_struct *w)
> +{
> +       struct dm_update_buffer *b = container_of(w, struct dm_update_buffer, work);
> +       struct dm_update *u = b->u;
> +       uint64_t src;
> +       size_t front_pad, compressed_length;
> +       sector_t sector, n_sectors;
> +       struct bio *bio, *waiting_bios;
> +       int r;
> +
> +       dm_update_get_locations(u, b->e, &src, &sector, &n_sectors, &front_pad, &compressed_length);
> +
> +       r = update_rw(u, false, REQ_OP_READ, sector, n_sectors, b->compressed_chunk);
> +       if (unlikely(r))
> +               goto io_error;
> +
> +       r = update_decompress(u, b->compressed_chunk + front_pad, compressed_length, b->decompressed_chunk, le32_to_cpu(u->sb->chunk_blocks) << u->sb->block_bits);
> +       if (unlikely(r))
> +               goto io_error;
> +
> +io_error:
> +       mutex_lock(&u->mutex);
> +       b->status = likely(!r) ? B_VALID : B_EMPTY;
> +       while ((bio = bio_list_pop(&b->waiting_bios))) {
> +               if (unlikely(r)) {
> +                       bio->bi_status = errno_to_blk_status(r);
> +                       bio_endio(bio);
> +               } else {
> +                       update_fill_from_buffer(u, b, bio);
> +               }
> +       }
> +
> +       waiting_bios = bio_list_get(&u->waiting_bios);
> +       while (waiting_bios != NULL) {
> +               bio = waiting_bios;
> +               waiting_bios = bio->bi_next;
> +               bio->bi_next = NULL;
> +               update_process_bio(u, bio);
> +       }
> +
> +       mutex_unlock(&u->mutex);
> +}
> +
> +static int update_map(struct dm_target *ti, struct bio *bio)
> +{
> +       struct dm_update *u = ti->private;
> +       sector_t block;
> +       size_t first, last, half;
> +       struct update_entry *e;
> +
> +       if (bio_data_dir(bio) == WRITE)
> +               return DM_MAPIO_KILL;
> +
> +       block = bio->bi_iter.bi_sector >> (u->sb->block_bits - SECTOR_SHIFT);
> +
> +       first = 0;
> +       last = le64_to_cpu(u->sb->dir_n) - 1;
> +       while (first < last) {
> +               sector_t test_block;
> +               half = first / 2 + last / 2 + (first & last & 1);
> +               e = &u->entries[half];
> +               test_block = le32_to_cpu(e->dest_lo) + ((uint64_t)le16_to_cpu(e->dest_hi) << 32);
> +               if (test_block == block)
> +                       goto found;
> +               if (test_block < block) {
> +                       first = half + 1;
> +               } else {
> +                       last = half;
> +               }
> +       }
> +
> +       bio_set_dev(bio, u->system_dev->bdev);
> +       return DM_MAPIO_REMAPPED;
> +
> +found:
> +       bio->bi_private = e;
> +
> +       mutex_lock(&u->mutex);
> +       update_process_bio(u, bio);
> +       mutex_unlock(&u->mutex);
> +
> +       return DM_MAPIO_SUBMITTED;
> +}
> +
> +static void update_status(struct dm_target *ti, status_type_t type, unsigned status_flags, char *result, unsigned maxlen)
> +{
> +       struct dm_update *u = ti->private;
> +       unsigned extra_args;
> +       unsigned sz = 0;
> +
> +       switch (type) {
> +               case STATUSTYPE_INFO:
> +                       DMEMIT("%zu %llu", READ_ONCE(u->bg_index), (unsigned long long)(le64_to_cpu(u->sb->dir_n) - 1));
> +                       break;
> +               case STATUSTYPE_TABLE:
> +                       DMEMIT("%s %s ", u->system_dev->name, u->update_dev->name);
> +
> +                       extra_args = 0;
> +                       if (u->no_bg_update)
> +                               extra_args++;
> +
> +                       DMEMIT("%u", extra_args);
> +                       if (u->no_bg_update)
> +                               DMEMIT(" no_bg_update");
> +                       break;
> +               case STATUSTYPE_IMA:
> +                       DMEMIT_TARGET_NAME_VERSION(ti->type);
> +                       DMEMIT(",update_system_device=%s", u->system_dev->name);
> +                       DMEMIT(",update_update_device=%s", u->update_dev->name);
> +                       DMEMIT(";");
> +                       break;
> +       }
> +}
> +
> +static int update_iterate_devices(struct dm_target *ti, iterate_devices_callout_fn fn, void *data)
> +{
> +       struct dm_update *u = ti->private;
> +
> +       return fn(ti, u->system_dev, 0, ti->len, data);
> +}
> +
> +static void update_background_work(struct work_struct *w)
> +{
> +       struct dm_update *u = container_of(w, struct dm_update, bg_work);
> +       uint64_t src;
> +       size_t front_pad, compressed_length;
> +       sector_t sector, n_sectors;
> +       int r;
> +
> +       if (u->bg_index >= le64_to_cpu(u->sb->dir_n) - 1)
> +               return;
> +
> +       dm_update_get_locations(u, &u->entries[u->bg_index], &src, &sector, &n_sectors, &front_pad, &compressed_length);
> +
> +       r = update_rw(u, false, REQ_OP_READ, sector, n_sectors, u->bg_compressed_chunk);
> +       if (unlikely(r)) {
> +               DMERR("error reading update device (%d), aborting backgroup update", r);
> +               return;
> +       }
> +
> +       r = update_decompress(u, u->bg_compressed_chunk + front_pad, compressed_length, u->bg_decompressed_chunk, le32_to_cpu(u->sb->chunk_blocks) << u->sb->block_bits);
> +       if (unlikely(r)) {
> +               DMERR("error decompressing update data (%d), aborting backgroup update", r);
> +               return;
> +       }
> +
> +       while (u->bg_index < le64_to_cpu(u->sb->dir_n) - 1) {
> +               uint64_t s, dest;
> +               size_t offset;
> +               struct update_entry *e = &u->entries[u->bg_index];
> +               s = le32_to_cpu(e->src_lo) + ((uint64_t)le16_to_cpu(e->src_hi) << 32);
> +               if (s != src)
> +                       break;
> +
> +               dest = le32_to_cpu(e->dest_lo) + ((uint64_t)le16_to_cpu(e->dest_hi) << 32);
> +               offset = (size_t)le32_to_cpu(e->offset) << u->sb->block_bits;
> +
> +               r = update_rw(u, true, REQ_OP_WRITE, dest << (u->sb->block_bits - SECTOR_SHIFT), 1UL << (u->sb->block_bits - SECTOR_SHIFT), u->bg_decompressed_chunk + offset);
> +               if (unlikely(r)) {
> +                       DMERR("error writing to the system device (%d), aborting backgroup update", r);
> +                       return;
> +               }
> +
> +               if (unlikely(u->bg_index == le64_to_cpu(u->sb->dir_n) - 2)) {
> +                       r = update_rw(u, true, REQ_OP_WRITE | REQ_PREFLUSH, 0, 0, NULL);
> +                       if (unlikely(r)) {
> +                               DMERR("error synchronizing the system device (%d), aborting backgroup update", r);
> +                               return;
> +                       }
> +               }
> +
> +               WRITE_ONCE(u->bg_index, u->bg_index + 1);
> +       }
> +
> +       queue_work(u->bg_wq, &u->bg_work);
> +}
> +
> +static void update_presuspend(struct dm_target *ti)
> +{
> +       struct dm_update *u = ti->private;
> +       cancel_work_sync(&u->bg_work);
> +}
> +
> +static void update_resume(struct dm_target *ti)
> +{
> +       struct dm_update *u = ti->private;
> +       if (u->no_bg_update)
> +               return;
> +       queue_work(u->bg_wq, &u->bg_work);
> +}
> +
> +static void update_dtr(struct dm_target *ti)
> +{
> +       struct dm_update *u = ti->private;
> +       int i;
> +
> +       if (u->bg_wq)
> +               destroy_workqueue(u->bg_wq);
> +       if (u->decompress_wq)
> +               destroy_workqueue(u->decompress_wq);
> +
> +       vfree(u->bg_compressed_chunk);
> +       vfree(u->bg_decompressed_chunk);
> +
> +       for (i = 0; i < N_BUFFERS; i++) {
> +               vfree(u->buffer[i].compressed_chunk);
> +               vfree(u->buffer[i].decompressed_chunk);
> +       }
> +       vfree(u->sb);
> +       vfree(u->entries);
> +       if (u->dm_io)
> +               dm_io_client_destroy(u->dm_io);
> +       if (u->system_dev)
> +               dm_put_device(ti, u->system_dev);
> +       if (u->update_dev)
> +               dm_put_device(ti, u->update_dev);
> +       if (u->cc)
> +               crypto_free_comp(u->cc);
> +
> +       mutex_init(&u->mutex);
> +
> +       kfree(u);
> +}
> +
> +static char *validate_sb(struct dm_update *u)
> +{
> +       struct update_superblock *sb = u->sb;
> +
> +       if (sb->block_bits < SECTOR_SHIFT || sb->block_bits >= 32)
> +               return "Invalid superblock: block_bits";
> +
> +       if (!le32_to_cpu(sb->chunk_blocks))
> +               return "Invalid superblock: chunk_blocks is zero";
> +
> +       if (le32_to_cpu(u->sb->chunk_blocks) << u->sb->block_bits >> u->sb->block_bits != le32_to_cpu(u->sb->chunk_blocks))
> +               return "Invalid superblock: too large chunk_blocks";
> +
> +       if ((int)(le32_to_cpu(u->sb->chunk_blocks) << u->sb->block_bits) < 0)
> +               return "Invalid superblock: too large chunk_blocks";
> +
> +       if (le64_to_cpu(sb->dir_n) < 1)
> +               return "Invalid superblock: zero dir_n";
> +
> +       if ((size_t)le64_to_cpu(sb->dir_n) * sizeof(struct update_entry) / sizeof(struct update_entry) != le64_to_cpu(sb->dir_n))
> +               return "Invalid superblock: overflow in dir_n";
> +
> +       return NULL;
> +}
> +
> +static char *validate_metadata(struct dm_update *u)
> +{
> +       struct update_superblock *sb = u->sb;
> +       size_t i;
> +       size_t n = le64_to_cpu(sb->dir_n) - 1;
> +
> +       for (i = 0; i < n; i++) {
> +               struct update_entry *e1 = &u->entries[i];
> +               struct update_entry *e2 = &u->entries[i + 1];
> +               uint64_t dest1, dest2;
> +
> +               if (le32_to_cpu(e1->offset) >= le32_to_cpu(sb->chunk_blocks))
> +                       return "Invalid metadata: offset is too high";
> +
> +               dest1 = le32_to_cpu(e1->dest_lo) + ((uint64_t)le16_to_cpu(e1->dest_hi) << 32);
> +               dest2 = le32_to_cpu(e2->dest_lo) + ((uint64_t)le16_to_cpu(e2->dest_hi) << 32);
> +
> +               if (dest1 >= dest2)
> +                       return "Invalid metadata: destination is not monotonic";
> +       }
> +
> +       return NULL;
> +}
> +
> +static int update_ctr(struct dm_target *ti, unsigned argc, char **argv)
> +{
> +       struct dm_update *u;
> +       struct dm_arg_set as;
> +       const char *string;
> +       unsigned opt_params;
> +       char *err;
> +       int r;
> +       uint64_t compressed_dir_size;
> +       void *compressed_dir = NULL;
> +       size_t dst_len;
> +       int i;
> +       size_t o;
> +       sector_t max_compressed_sectors;
> +
> +       static const struct dm_arg _args[] = {
> +               {0, 1, "Invalid number of feature args"},
> +       };
> +
> +       as.argc = argc;
> +       as.argv = argv;
> +
> +       u = kzalloc(sizeof(struct dm_update), GFP_KERNEL);
> +       if (!u) {
> +               ti->error = "Cannot allocate dm_update structure";
> +               return -ENOMEM;
> +       }
> +
> +       ti->private = u;
> +       u->ti = ti;
> +
> +       mutex_init(&u->mutex);
> +       bio_list_init(&u->waiting_bios);
> +       INIT_WORK(&u->bg_work, update_background_work);
> +
> +       string = dm_shift_arg(&as);
> +       if (!string)
> +               goto bad_arguments;
> +
> +       r = dm_get_device(ti, string, FMODE_READ | FMODE_WRITE, &u->system_dev);
> +       if (r) {
> +               ti->error = "System device lookup failed";
> +               goto bad;
> +       }
> +
> +       string = dm_shift_arg(&as);
> +       if (!string)
> +               goto bad_arguments;
> +
> +       r = dm_get_device(ti, string, FMODE_READ | FMODE_WRITE, &u->update_dev);
> +       if (r) {
> +               ti->error = "Update device lookup failed";
> +               goto bad;
> +       }
> +
> +       r = dm_read_arg_group(_args, &as, &opt_params, &ti->error);
> +       if (r)
> +               goto bad;
> +
> +       while (opt_params) {
> +               string = dm_shift_arg(&as), opt_params--;
> +               if (!strcasecmp(string, "no_bg_update")) {
> +                       u->no_bg_update = true;
> +               } else {
> +                       r = -EINVAL;
> +                       ti->error = "Invalid optional argument";
> +                       goto bad;
> +               }
> +       }
> +
> +       u->update_lbs = bdev_logical_block_size(u->update_dev->bdev);
> +       u->update_lbs_bits = __ffs(u->update_lbs);
> +
> +       u->decompress_wq = alloc_workqueue("dm-update", WQ_CPU_INTENSIVE | WQ_MEM_RECLAIM, 0);
> +       if (!u->decompress_wq) {
> +               ti->error = "Cannot allocate workqueue";
> +               r = -ENOMEM;
> +               goto bad;
> +       }
> +
> +       if (!u->no_bg_update) {
> +               u->bg_wq = alloc_workqueue("dm-update-background", WQ_CPU_INTENSIVE | WQ_UNBOUND, 1);
> +               if (!u->bg_wq) {
> +                       ti->error = "Cannot allocate workqueue";
> +                       r = -ENOMEM;
> +                       goto bad;
> +               }
> +       }
> +
> +       u->dm_io = dm_io_client_create();
> +       if (IS_ERR(u->dm_io)) {
> +               r = PTR_ERR(u->dm_io);
> +               u->dm_io = NULL;
> +               ti->error = "Unable to allocate dm-io client";
> +               goto bad;
> +       }
> +
> +       u->sb = vmalloc(u->update_lbs);
> +       if (!u->sb) {
> +               r = -ENOMEM;
> +               ti->error = "Cannot allocate superblock";
> +               goto bad;
> +       }
> +
> +       r = update_rw(u, false, REQ_OP_READ, 0, u->update_lbs >> SECTOR_SHIFT, u->sb);
> +       if (r) {
> +               ti->error = "Cannot read superblock";
> +               goto bad;
> +       }
> +
> +       if (memcmp(u->sb->magic, UPDATE_MAGIC, 8)) {
> +               r = -EINVAL;
> +               ti->error = "Invalid magic in the superblock";
> +               //printk("%02x %02x %02x %02x %02x %02x %02x %02x\n", u->sb->magic[0], u->sb->magic[1], u->sb->magic[2], u->sb->magic[3], u->sb->magic[4], u->sb->magic[5], u->sb->magic[6], u->sb->magic[7]);
> +               goto bad;
> +       }
> +
> +       if (u->sb->version != UPDATE_VERSION) {
> +               r = -EINVAL;
> +               ti->error = "Invalid version in the superblock";
> +               goto bad;
> +       }
> +
> +       if ((err = validate_sb(u))) {
> +               r = -EINVAL;
> +               ti->error = err;
> +               goto bad;
> +       }
> +
> +       r = dm_set_target_max_io_len(ti, (sector_t)1 << (u->sb->block_bits - SECTOR_SHIFT));
> +       if (r) {
> +               ti->error = "Invalid block size in the superblock";
> +               goto bad;
> +       }
> +
> +       if (!memchr(u->sb->compression, 0, sizeof u->sb->compression)) {
> +               r = -EINVAL;
> +               ti->error = "Invalid compression algorithm in the superblock";
> +               goto bad;
> +       }
> +       if (strcmp(u->sb->compression, "none")) {
> +               u->cc = crypto_alloc_comp(u->sb->compression, 0, 0);
> +               if (!u->cc)
> +                       u->cc = ERR_PTR(-ENOMEM);
> +               if (IS_ERR(u->cc)) {
> +                       r = PTR_ERR(u->cc);
> +                       u->cc = NULL;
> +                       ti->error = "Unsupported compression method";
> +                       goto bad;
> +               }
> +       }
> +
> +       compressed_dir_size = roundup((le64_to_cpu(u->sb->dir_offset) & (u->update_lbs - 1)) + le64_to_cpu(u->sb->dir_compressed_size), u->update_lbs);
> +       if (compressed_dir_size != (size_t)compressed_dir_size) {
> +               r = -EOVERFLOW;
> +               ti->error = "Compressed directory is too large for 32-bit system";
> +               goto bad;
> +       }
> +
> +       compressed_dir = vmalloc(compressed_dir_size);
> +       if (!compressed_dir) {
> +               r = -ENOMEM;
> +               ti->error = "Cannot allocate compressed directory";
> +               goto bad;
> +       }
> +
> +       r = update_rw(u, false, REQ_OP_READ, round_down(le64_to_cpu(u->sb->dir_offset), u->update_lbs) >> SECTOR_SHIFT, compressed_dir_size >> SECTOR_SHIFT, compressed_dir);
> +       if (r) {
> +               ti->error = "Cannot read compressed directory";
> +               goto bad;
> +       }
> +
> +       dst_len = le64_to_cpu(u->sb->dir_n) * sizeof(struct update_entry);
> +       u->entries = vmalloc(dst_len);
> +       if (!u->entries) {
> +               r = -ENOMEM;
> +               ti->error = "Cannot allocate decompressed directory";
> +               goto bad;
> +       }
> +
> +       r = update_decompress(u, compressed_dir + (le64_to_cpu(u->sb->dir_offset) & (u->update_lbs - 1)), le64_to_cpu(u->sb->dir_compressed_size), (void *)u->entries, dst_len);
> +       if (r) {
> +               ti->error = "Cannot decompress directory";
> +               goto bad;
> +       }
> +
> +       if (dst_len != le64_to_cpu(u->sb->dir_n) * sizeof(struct update_entry)) {
> +               r = -EINVAL;
> +               ti->error = "Non-matching length of compressed directory";
> +               goto bad;
> +       }
> +
> +       vfree(compressed_dir);
> +       compressed_dir = NULL;
> +
> +       if ((err = validate_metadata(u))) {
> +               r = -EINVAL;
> +               ti->error = err;
> +               goto bad;
> +       }
> +
> +       o = 0;
> +       max_compressed_sectors = 1;
> +       while (o < le64_to_cpu(u->sb->dir_n) - 1) {
> +               struct update_entry *e = &u->entries[o];
> +               uint64_t src, s;
> +               size_t front_pad, compressed_length;
> +               sector_t sector, n_sectors;
> +               dm_update_get_locations(u, e, &src, &sector, &n_sectors, &front_pad, &compressed_length);
> +               if (n_sectors > max_compressed_sectors)
> +                       max_compressed_sectors = n_sectors;
> +               do {
> +                       o++;
> +                       if (o >= le64_to_cpu(u->sb->dir_n) - 1)
> +                               break;
> +                       e = &u->entries[o];
> +                       s = le32_to_cpu(e->src_lo) + ((uint64_t)le16_to_cpu(e->src_hi) << 32);
> +               } while (s == src);
> +       }
> +
> +       for (i = 0; i < N_BUFFERS; i++) {
> +               struct dm_update_buffer *b = &u->buffer[i];
> +               b->decompressed_chunk = vmalloc(le32_to_cpu(u->sb->chunk_blocks) << u->sb->block_bits);
> +               if (!b->decompressed_chunk) {
> +                       r = -ENOMEM;
> +                       ti->error = "Cannot allocate buffers";
> +                       goto bad;
> +               }
> +               //memset(b->decompressed_chunk, 0xfe, le32_to_cpu(u->sb->chunk_blocks) << u->sb->block_bits);
> +               b->compressed_chunk = vmalloc(max_compressed_sectors << SECTOR_SHIFT);
> +               if (!b->compressed_chunk) {
> +                       r = -ENOMEM;
> +                       ti->error = "Cannot allocate buffers";
> +                       goto bad;
> +               }
> +               //memset(b->compressed_chunk, 0xfd, max_compressed_sectors << SECTOR_SHIFT);
> +               bio_list_init(&b->waiting_bios);
> +               INIT_WORK(&b->work, dm_update_buffer_work);
> +               b->u = u;
> +       }
> +
> +       if (!u->no_bg_update) {
> +               u->bg_decompressed_chunk = vmalloc(le32_to_cpu(u->sb->chunk_blocks) << u->sb->block_bits);
> +               if (!u->bg_decompressed_chunk) {
> +                       r = -ENOMEM;
> +                       ti->error = "Cannot allocate buffers";
> +                       goto bad;
> +               }
> +               u->bg_compressed_chunk = vmalloc(max_compressed_sectors << SECTOR_SHIFT);
> +               if (!u->bg_compressed_chunk) {
> +                       r = -ENOMEM;
> +                       ti->error = "Cannot allocate buffers";
> +                       goto bad;
> +               }
> +       }
> +
> +       return 0;
> +
> +bad_arguments:
> +       ti->error = "Not enough arguments";
> +       r = -EINVAL;
> +bad:
> +       if (compressed_dir)
> +               vfree(compressed_dir);
> +       update_dtr(ti);
> +       return r;
> +}
> +
> +static struct target_type update_target = {
> +       .name                   = "update",
> +       .version                = {1, 0, 0},
> +       .module                 = THIS_MODULE,
> +       .ctr                    = update_ctr,
> +       .dtr                    = update_dtr,
> +       .map                    = update_map,
> +       .status                 = update_status,
> +       .iterate_devices        = update_iterate_devices,
> +       .presuspend             = update_presuspend,
> +       .resume                 = update_resume,
> +};
> +
> +static int __init dm_update_init(void)
> +{
> +       int r;
> +
> +       r = dm_register_target(&update_target);
> +       if (r < 0) {
> +               DMERR("register failed %d", r);
> +               return r;
> +       }
> +
> +       return 0;
> +}
> +
> +static void __exit dm_update_exit(void)
> +{
> +       dm_unregister_target(&update_target);
> +}
> +
> +module_init(dm_update_init);
> +module_exit(dm_update_exit);
> +
> +MODULE_DESCRIPTION(DM_NAME " update target");
> +MODULE_AUTHOR("Mikulas Patocka <dm-devel@redhat.com>");
> +MODULE_LICENSE("GPL");
> Index: linux-2.6/drivers/md/dm-update.h
> ===================================================================
> --- /dev/null
> +++ linux-2.6/drivers/md/dm-update.h
> @@ -0,0 +1,23 @@
> +#define UPDATE_MAGIC   "update\0"
> +#define UPDATE_VERSION 0
> +
> +struct update_superblock {
> +       char magic[8];
> +       uint8_t version;
> +       uint8_t block_bits;
> +       uint16_t pad1;
> +       __le32 chunk_blocks;
> +       char compression[16];
> +       __le64 dir_offset;
> +       __le64 dir_compressed_size;
> +       __le64 dir_n;
> +       __le64 pad2;
> +};
> +
> +struct update_entry {
> +       __le32 dest_lo;
> +       __le16 dest_hi;
> +       __le16 src_hi;
> +       __le32 src_lo;
> +       __le32 offset;
> +};
> Index: linux-2.6/Documentation/admin-guide/device-mapper/update.rst
> ===================================================================
> --- /dev/null
> +++ linux-2.6/Documentation/admin-guide/device-mapper/update.rst
> @@ -0,0 +1,54 @@
> +=============
> +Update target
> +=============
> +
> +Embedded devices typically have a read-only partition that stores the operating
> +system image. The purpose of the dm-update target is to transparently update
> +this partition while the system is running.
> +
> +How to use the dm-update target:
> +1. We have files "old.img" and "new.img" that contain the old and new system
> +   image.
> +
> +2. We calculate the difference between these images with the update-diff
> +   utility - it could be downloaded from
> +   http://people.redhat.com/~mpatocka/dm-update/
> +
> +   ./update-diff old.img new.img -o diff.img -a zstd
> +
> +   This command calculates the difference between old.img and new.img,
> +   compresses it with the "zstd" algorithm and stores it in the file diff.img.

Why not extend dm-snapshot; in that way you can have the existing
kernel COW format + support compression.
I understand this for read-only but if dm-snapshot supports it,
existing users  can have the
compression feature if required.

Also, I am curious what are the other real world use case here apart
from Android ?

> +3. The file diff.img is delivered to the embedded system.
> +
> +4. The embedded system is rebooted.
> +
> +5. On next boot, we load the dm-update target (assume that /dev/sda1 is the
> +   system partition and diff.img is the downloaded difference file):
> +   # losetup /dev/loop0 diff.img
> +   # dmsetup create system --table "0 `blockdev --getsize /dev/sda1` update
> +     /dev/sda1 /dev/loop0 0"
> +
> +6. The update target will present the system image as if the update already
> +   happened - if you read from blocks that are modified, it will transparently
> +   load the data from "diff.img" and decompress it.
> +
> +7. On background, the update target will copy the contents of the file
> +   "diff.img" to the partition /dev/sda1
> +
> +8. When the copying finishes (it can be detected by dmsetup status - if the
> +   first two numbers are equal, the copying finished), you can replace the
> +   update target with a linear target. After replacement, you can delete the
> +   loop device /dev/loop0 and the file diff.img. The partition /dev/sda1 is now
> +   equal to the file "new.img".
> +
> +Constructor parameters:
> +1. the system partition
> +2. the device that contains the difference between old and new image
> +3. the number of optional arguments
> +       no_bg_update
> +               don't perform background update of the system partition
> +
> +Status:
> +1. the number of blocks that were updated so far
> +2. the total number of blocks in the difference file
>

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

