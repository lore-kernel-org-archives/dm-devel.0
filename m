From: Lukas Straub <lukasstraub2@web.de>
Subject: [PATCH] dm-integrity: Prevent RMW for full tag area writes
Date: Thu, 20 Feb 2020 19:04:45 +0100
Message-ID: <20200220190445.2222af54@luklap>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, dm-devel <dm-devel@redhat.com>
List-Id: dm-devel.ids

If a full tag area is being written, don't read it first. This prevents a
read-modify-write cycle and increases performance on HDDs considerably.

To do this we now calculate the checksums for all sectors in the bio in on=
e
go in integrity_metadata and then pass the result to dm_integrity_rw_tag,
which now checks if we overwrite the whole tag area.

Benchmarking with a 5400RPM HDD with bitmap mode:
integritysetup format --no-wipe --batch-mode --interleave-sectors $((64*10=
24)) -t 4 -s 512 -I crc32c -B /dev/sdc
integritysetup open -I crc32c -B /dev/sdc hdda_integ
dd if=3D/dev/zero of=3D/dev/mapper/hdda_integ bs=3D64K count=3D$((16*1024*=
4)) conv=3Dfsync oflag=3Ddirect status=3Dprogress

Without patch:
4294967296 bytes (4.3 GB, 4.0 GiB) copied, 400.326 s, 10.7 MB/s

With patch:
4294967296 bytes (4.3 GB, 4.0 GiB) copied, 41.2057 s, 104 MB/s

Signed-off-by: Lukas Straub <lukasstraub2@web.de>
=2D--
 drivers/md/dm-integrity.c | 80 ++++++++++++++++++++++-----------------
 1 file changed, 46 insertions(+), 34 deletions(-)

diff --git a/drivers/md/dm-integrity.c b/drivers/md/dm-integrity.c
index b225b3e445fa..0e5ddcf44935 100644
=2D-- a/drivers/md/dm-integrity.c
+++ b/drivers/md/dm-integrity.c
@@ -1309,9 +1309,16 @@ static int dm_integrity_rw_tag(struct dm_integrity_=
c *ic, unsigned char *tag, se
 		if (unlikely(r))
 			return r;

-		data =3D dm_bufio_read(ic->bufio, *metadata_block, &b);
-		if (IS_ERR(data))
-			return PTR_ERR(data);
+		/* Don't read tag area from disk if we're going to overwrite it complet=
ely */
+		if (op =3D=3D TAG_WRITE && *metadata_offset =3D=3D 0 && total_size >=3D=
 ic->metadata_run) {
+			data =3D dm_bufio_new(ic->bufio, *metadata_block, &b);
+			if (IS_ERR(data))
+				return PTR_ERR(data);
+		} else {
+			data =3D dm_bufio_read(ic->bufio, *metadata_block, &b);
+			if (IS_ERR(data))
+				return PTR_ERR(data);
+		}

 		to_copy =3D min((1U << SECTOR_SHIFT << ic->log2_buffer_sectors) - *meta=
data_offset, total_size);
 		dp =3D data + *metadata_offset;
@@ -1514,6 +1521,8 @@ static void integrity_metadata(struct work_struct *w=
)
 {
 	struct dm_integrity_io *dio =3D container_of(w, struct dm_integrity_io, =
work);
 	struct dm_integrity_c *ic =3D dio->ic;
+	unsigned sectors_to_process =3D dio->range.n_sectors;
+	sector_t sector =3D dio->range.logical_sector;

 	int r;

@@ -1522,16 +1531,14 @@ static void integrity_metadata(struct work_struct =
*w)
 		struct bio_vec bv;
 		unsigned digest_size =3D crypto_shash_digestsize(ic->internal_hash);
 		struct bio *bio =3D dm_bio_from_per_bio_data(dio, sizeof(struct dm_inte=
grity_io));
-		char *checksums;
+		char *checksums, *checksums_ptr;
 		unsigned extra_space =3D unlikely(digest_size > ic->tag_size) ? digest_=
size - ic->tag_size : 0;
 		char checksums_onstack[HASH_MAX_DIGESTSIZE];
-		unsigned sectors_to_process =3D dio->range.n_sectors;
-		sector_t sector =3D dio->range.logical_sector;

 		if (unlikely(ic->mode =3D=3D 'R'))
 			goto skip_io;

-		checksums =3D kmalloc((PAGE_SIZE >> SECTOR_SHIFT >> ic->sb->log2_sector=
s_per_block) * ic->tag_size + extra_space,
+		checksums =3D kmalloc((dio->range.n_sectors >> ic->sb->log2_sectors_per=
_block) * ic->tag_size + extra_space,
 				    GFP_NOIO | __GFP_NORETRY | __GFP_NOWARN);
 		if (!checksums) {
 			checksums =3D checksums_onstack;
@@ -1542,49 +1549,45 @@ static void integrity_metadata(struct work_struct =
*w)
 			}
 		}

+		checksums_ptr =3D checksums;
 		__bio_for_each_segment(bv, bio, iter, dio->orig_bi_iter) {
 			unsigned pos;
-			char *mem, *checksums_ptr;
-
-again:
+			char *mem;
 			mem =3D (char *)kmap_atomic(bv.bv_page) + bv.bv_offset;
 			pos =3D 0;
-			checksums_ptr =3D checksums;
 			do {
 				integrity_sector_checksum(ic, sector, mem + pos, checksums_ptr);
-				checksums_ptr +=3D ic->tag_size;
-				sectors_to_process -=3D ic->sectors_per_block;
+
+				if (likely(checksums !=3D checksums_onstack)) {
+					checksums_ptr +=3D ic->tag_size;
+				} else {
+					r =3D dm_integrity_rw_tag(ic, checksums, &dio->metadata_block, &dio-=
>metadata_offset,
+								ic->tag_size, !dio->write ? TAG_CMP : TAG_WRITE);
+					if (unlikely(r))
+						goto internal_hash_error;
+				}
+
 				pos +=3D ic->sectors_per_block << SECTOR_SHIFT;
 				sector +=3D ic->sectors_per_block;
-			} while (pos < bv.bv_len && sectors_to_process && checksums !=3D check=
sums_onstack);
+				sectors_to_process -=3D ic->sectors_per_block;
+			} while (pos < bv.bv_len && sectors_to_process);
 			kunmap_atomic(mem);

-			r =3D dm_integrity_rw_tag(ic, checksums, &dio->metadata_block, &dio->m=
etadata_offset,
-						checksums_ptr - checksums, !dio->write ? TAG_CMP : TAG_WRITE);
-			if (unlikely(r)) {
-				if (r > 0) {
-					DMERR_LIMIT("Checksum failed at sector 0x%llx",
-						    (unsigned long long)(sector - ((r + ic->tag_size - 1) / ic->tag=
_size)));
-					r =3D -EILSEQ;
-					atomic64_inc(&ic->number_of_mismatches);
-				}
-				if (likely(checksums !=3D checksums_onstack))
-					kfree(checksums);
-				goto error;
-			}
-
 			if (!sectors_to_process)
 				break;
+		}

-			if (unlikely(pos < bv.bv_len)) {
-				bv.bv_offset +=3D pos;
-				bv.bv_len -=3D pos;
-				goto again;
+		if (likely(checksums !=3D checksums_onstack)) {
+			r =3D dm_integrity_rw_tag(ic, checksums, &dio->metadata_block, &dio->m=
etadata_offset,
+						(dio->range.n_sectors >> ic->sb->log2_sectors_per_block) * ic->tag_=
size,
+						!dio->write ? TAG_CMP : TAG_WRITE);
+			if (unlikely(r)) {
+				kfree(checksums);
+				goto internal_hash_error;
 			}
+			kfree(checksums);
 		}

-		if (likely(checksums !=3D checksums_onstack))
-			kfree(checksums);
 	} else {
 		struct bio_integrity_payload *bip =3D dio->orig_bi_integrity;

@@ -1615,6 +1618,13 @@ static void integrity_metadata(struct work_struct *=
w)
 skip_io:
 	dec_in_flight(dio);
 	return;
+internal_hash_error:
+	if (r > 0) {
+		DMERR_LIMIT("Checksum failed at sector 0x%llx",
+				(unsigned long long)(sector - ((r + ic->tag_size - 1) / ic->tag_size)=
));
+		r =3D -EILSEQ;
+		atomic64_inc(&ic->number_of_mismatches);
+	}
 error:
 	dio->bi_status =3D errno_to_blk_status(r);
 	dec_in_flight(dio);
@@ -3019,6 +3029,8 @@ static void dm_integrity_io_hints(struct dm_target *=
ti, struct queue_limits *lim
 		limits->physical_block_size =3D ic->sectors_per_block << SECTOR_SHIFT;
 		blk_limits_io_min(limits, ic->sectors_per_block << SECTOR_SHIFT);
 	}
+
+	blk_limits_io_opt(limits, (1U << ic->sb->log2_interleave_sectors));
 }

 static void calculate_journal_section_size(struct dm_integrity_c *ic)
=2D-
2.20.1
