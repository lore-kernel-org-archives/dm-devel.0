From: Lukas Straub <lukasstraub2@web.de>
Subject: Re: [dm-devel] [PATCH] dm-integrity: Prevent RMW for full tag area
 writes
Date: Wed, 26 Feb 2020 09:27:05 +0100
Message-ID: <20200226092705.61b7dcf4@luklap>
References: <20200220190445.2222af54@luklap>
 <alpine.LRH.2.02.2002251127070.1014@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.LRH.2.02.2002251127070.1014@file01.intranet.prod.int.rdu2.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, dm-devel <dm-devel@redhat.com>, Mike Snitzer <snitzer@redhat.com>, Alasdair Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On Tue, 25 Feb 2020 11:41:45 -0500 (EST)
Mikulas Patocka <mpatocka@redhat.com> wrote:

> On Thu, 20 Feb 2020, Lukas Straub wrote:
>
> > If a full tag area is being written, don't read it first. This prevent=
s a
> > read-modify-write cycle and increases performance on HDDs considerably=
.
> >
> > To do this we now calculate the checksums for all sectors in the bio i=
n one
> > go in integrity_metadata and then pass the result to dm_integrity_rw_t=
ag,
> > which now checks if we overwrite the whole tag area.
> >
> > Benchmarking with a 5400RPM HDD with bitmap mode:
> > integritysetup format --no-wipe --batch-mode --interleave-sectors $((6=
4*1024)) -t 4 -s 512 -I crc32c -B /dev/sdc
> > integritysetup open -I crc32c -B /dev/sdc hdda_integ
> > dd if=3D/dev/zero of=3D/dev/mapper/hdda_integ bs=3D64K count=3D$((16*1=
024*4)) conv=3Dfsync oflag=3Ddirect status=3Dprogress
> >
> > Without patch:
> > 4294967296 bytes (4.3 GB, 4.0 GiB) copied, 400.326 s, 10.7 MB/s
> >
> > With patch:
> > 4294967296 bytes (4.3 GB, 4.0 GiB) copied, 41.2057 s, 104 MB/s
> >
> > Signed-off-by: Lukas Straub <lukasstraub2@web.de>
> > ---
> >  drivers/md/dm-integrity.c | 80 ++++++++++++++++++++++----------------=
-
> >  1 file changed, 46 insertions(+), 34 deletions(-)
> >
> > diff --git a/drivers/md/dm-integrity.c b/drivers/md/dm-integrity.c
> > index b225b3e445fa..0e5ddcf44935 100644
> > --- a/drivers/md/dm-integrity.c
> > +++ b/drivers/md/dm-integrity.c
> > @@ -1309,9 +1309,16 @@ static int dm_integrity_rw_tag(struct dm_integr=
ity_c *ic, unsigned char *tag, se
> >  		if (unlikely(r))
> >  			return r;
> >
> > -		data =3D dm_bufio_read(ic->bufio, *metadata_block, &b);
> > -		if (IS_ERR(data))
> > -			return PTR_ERR(data);
> > +		/* Don't read tag area from disk if we're going to overwrite it com=
pletely */
> > +		if (op =3D=3D TAG_WRITE && *metadata_offset =3D=3D 0 && total_size =
>=3D ic->metadata_run) {
>
> Hi
>
> This is incorrect logic because ic->metadata_run is in the units of
> 512-byte sectors and total_size is in bytes.
>
> If I correct the bug and change it to "if (op =3D=3D TAG_WRITE &&
> *metadata_offset =3D=3D 0 && total_size >=3D ic->metadata_run << SECTOR_=
SHIFT)",
> then the benchmark doesn't show any performance advantage at all.

Uh oh, looking at it again i have mixed up sectors/bytes elsewhere too.
Actually, could we rewrite this check like
 total_size >=3D (1U << SECTOR_SHIFT << ic->log2_buffer_sectors)?
this should work, right?
So we only have to overwrite part of the tag area, as long as it's whole s=
ectors.

> You would need much bigger bios to take advantage for this - for example=
,
> if we have 4k block size and 64k metadata buffer size and 4-byte crc32,
> there are 65536/4=3D16384 tags in one metadata buffer and we would need
> 16384*4096=3D64MiB bio to completely overwrite the metadata buffer. Such=
 big
> bios are not realistic.

What prevents us from using a single sector as the tag area? (Which was my=
 assumption with this patch)
Then we would have (with 512b sectors) 512/4 =3D 128 tags =3D 64k bio, whi=
ch is still below the optimal write
size of raid5/6.
I just tried to accomplish this, but there seems to be minimum limit of in=
terleave_sectors.

Regards,
Lukas Straub

> Mikulas
>
>
> > +			data =3D dm_bufio_new(ic->bufio, *metadata_block, &b);
> > +			if (IS_ERR(data))
> > +				return PTR_ERR(data);
> > +		} else {
> > +			data =3D dm_bufio_read(ic->bufio, *metadata_block, &b);
> > +			if (IS_ERR(data))
> > +				return PTR_ERR(data);
> > +		}
> >
> >  		to_copy =3D min((1U << SECTOR_SHIFT << ic->log2_buffer_sectors) - *=
metadata_offset, total_size);
> >  		dp =3D data + *metadata_offset;
> > @@ -1514,6 +1521,8 @@ static void integrity_metadata(struct work_struc=
t *w)
> >  {
> >  	struct dm_integrity_io *dio =3D container_of(w, struct dm_integrity_=
io, work);
> >  	struct dm_integrity_c *ic =3D dio->ic;
> > +	unsigned sectors_to_process =3D dio->range.n_sectors;
> > +	sector_t sector =3D dio->range.logical_sector;
> >
> >  	int r;
> >
> > @@ -1522,16 +1531,14 @@ static void integrity_metadata(struct work_str=
uct *w)
> >  		struct bio_vec bv;
> >  		unsigned digest_size =3D crypto_shash_digestsize(ic->internal_hash)=
;
> >  		struct bio *bio =3D dm_bio_from_per_bio_data(dio, sizeof(struct dm_=
integrity_io));
> > -		char *checksums;
> > +		char *checksums, *checksums_ptr;
> >  		unsigned extra_space =3D unlikely(digest_size > ic->tag_size) ? dig=
est_size - ic->tag_size : 0;
> >  		char checksums_onstack[HASH_MAX_DIGESTSIZE];
> > -		unsigned sectors_to_process =3D dio->range.n_sectors;
> > -		sector_t sector =3D dio->range.logical_sector;
> >
> >  		if (unlikely(ic->mode =3D=3D 'R'))
> >  			goto skip_io;
> >
> > -		checksums =3D kmalloc((PAGE_SIZE >> SECTOR_SHIFT >> ic->sb->log2_se=
ctors_per_block) * ic->tag_size + extra_space,
> > +		checksums =3D kmalloc((dio->range.n_sectors >> ic->sb->log2_sectors=
_per_block) * ic->tag_size + extra_space,
> >  				    GFP_NOIO | __GFP_NORETRY | __GFP_NOWARN);
> >  		if (!checksums) {
> >  			checksums =3D checksums_onstack;
> > @@ -1542,49 +1549,45 @@ static void integrity_metadata(struct work_str=
uct *w)
> >  			}
> >  		}
> >
> > +		checksums_ptr =3D checksums;
> >  		__bio_for_each_segment(bv, bio, iter, dio->orig_bi_iter) {
> >  			unsigned pos;
> > -			char *mem, *checksums_ptr;
> > -
> > -again:
> > +			char *mem;
> >  			mem =3D (char *)kmap_atomic(bv.bv_page) + bv.bv_offset;
> >  			pos =3D 0;
> > -			checksums_ptr =3D checksums;
> >  			do {
> >  				integrity_sector_checksum(ic, sector, mem + pos, checksums_ptr);
> > -				checksums_ptr +=3D ic->tag_size;
> > -				sectors_to_process -=3D ic->sectors_per_block;
> > +
> > +				if (likely(checksums !=3D checksums_onstack)) {
> > +					checksums_ptr +=3D ic->tag_size;
> > +				} else {
> > +					r =3D dm_integrity_rw_tag(ic, checksums, &dio->metadata_block, &=
dio->metadata_offset,
> > +								ic->tag_size, !dio->write ? TAG_CMP : TAG_WRITE);
> > +					if (unlikely(r))
> > +						goto internal_hash_error;
> > +				}
> > +
> >  				pos +=3D ic->sectors_per_block << SECTOR_SHIFT;
> >  				sector +=3D ic->sectors_per_block;
> > -			} while (pos < bv.bv_len && sectors_to_process && checksums !=3D c=
hecksums_onstack);
> > +				sectors_to_process -=3D ic->sectors_per_block;
> > +			} while (pos < bv.bv_len && sectors_to_process);
> >  			kunmap_atomic(mem);
> >
> > -			r =3D dm_integrity_rw_tag(ic, checksums, &dio->metadata_block, &di=
o->metadata_offset,
> > -						checksums_ptr - checksums, !dio->write ? TAG_CMP : TAG_WRITE);
> > -			if (unlikely(r)) {
> > -				if (r > 0) {
> > -					DMERR_LIMIT("Checksum failed at sector 0x%llx",
> > -						    (unsigned long long)(sector - ((r + ic->tag_size - 1) / ic-=
>tag_size)));
> > -					r =3D -EILSEQ;
> > -					atomic64_inc(&ic->number_of_mismatches);
> > -				}
> > -				if (likely(checksums !=3D checksums_onstack))
> > -					kfree(checksums);
> > -				goto error;
> > -			}
> > -
> >  			if (!sectors_to_process)
> >  				break;
> > +		}
> >
> > -			if (unlikely(pos < bv.bv_len)) {
> > -				bv.bv_offset +=3D pos;
> > -				bv.bv_len -=3D pos;
> > -				goto again;
> > +		if (likely(checksums !=3D checksums_onstack)) {
> > +			r =3D dm_integrity_rw_tag(ic, checksums, &dio->metadata_block, &di=
o->metadata_offset,
> > +						(dio->range.n_sectors >> ic->sb->log2_sectors_per_block) * ic->=
tag_size,
> > +						!dio->write ? TAG_CMP : TAG_WRITE);
> > +			if (unlikely(r)) {
> > +				kfree(checksums);
> > +				goto internal_hash_error;
> >  			}
> > +			kfree(checksums);
> >  		}
> >
> > -		if (likely(checksums !=3D checksums_onstack))
> > -			kfree(checksums);
> >  	} else {
> >  		struct bio_integrity_payload *bip =3D dio->orig_bi_integrity;
> >
> > @@ -1615,6 +1618,13 @@ static void integrity_metadata(struct work_stru=
ct *w)
> >  skip_io:
> >  	dec_in_flight(dio);
> >  	return;
> > +internal_hash_error:
> > +	if (r > 0) {
> > +		DMERR_LIMIT("Checksum failed at sector 0x%llx",
> > +				(unsigned long long)(sector - ((r + ic->tag_size - 1) / ic->tag_s=
ize)));
> > +		r =3D -EILSEQ;
> > +		atomic64_inc(&ic->number_of_mismatches);
> > +	}
> >  error:
> >  	dio->bi_status =3D errno_to_blk_status(r);
> >  	dec_in_flight(dio);
> > @@ -3019,6 +3029,8 @@ static void dm_integrity_io_hints(struct dm_targ=
et *ti, struct queue_limits *lim
> >  		limits->physical_block_size =3D ic->sectors_per_block << SECTOR_SHI=
FT;
> >  		blk_limits_io_min(limits, ic->sectors_per_block << SECTOR_SHIFT);
> >  	}
> > +
> > +	blk_limits_io_opt(limits, (1U << ic->sb->log2_interleave_sectors));
> >  }
> >
> >  static void calculate_journal_section_size(struct dm_integrity_c *ic)
> > --
> > 2.20.1
> >
> >
> > --
> > dm-devel mailing list
> > dm-devel@redhat.com
> > https://www.redhat.com/mailman/listinfo/dm-devel
> >
>
