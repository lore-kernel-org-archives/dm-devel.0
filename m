From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 1/1] dm-zoned: Zoned block device target
Date: Thu, 9 Feb 2017 17:07:19 +0100
Message-ID: <d2353e66-183c-1f71-7a64-52e4b862bc17@suse.de>
References: <20170209041849.30964-1-damien.lemoal@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20170209041849.30964-1-damien.lemoal@wdc.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Damien Le Moal <damien.lemoal@wdc.com>, dm-devel@redhat.com, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>
Cc: linux-block@vger.kernel.org, Christoph Hellwig <hch@lst.de>
List-Id: dm-devel.ids

On 02/09/2017 05:18 AM, Damien Le Moal wrote:
> The dm-zoned device mapper target provides transparent write access
> to zoned block devices (ZBC and ZAC compliant block devices).
> dm-zoned hides to the device user (a file system or an application
> doing raw block device accesses) any constraint imposed on write
> requests by the device. Write requests are processed using a
> combination of on-disk buffering using the device conventional zones,
> allowing any random write access to be safely executed, or direct in-place
> processing for requests aligned on a zone sequential write pointer positi=
on.
> A background reclaim process ensures that some conventional zones are alw=
ays
> available for executing unaligned write requests. The reclaim process
> overhead is minimized by managing buffer zones in a least-recently-written
> order and first targeting the oldest buffer zones. Doing so, blocks under
> regular write access (such as metadata blocks of an FS) remain stored in
> conventional zones, resulting in no apparent write overhead.
> =

[ .. ]
> +/*
> + * CRC32
> + */
> +static u32 dmz_sb_crc32(u32 crc, const void *buf, size_t length)
> +{
> +	unsigned char *p =3D (unsigned char *)buf;
> +	int i;
> +
> +#define CRCPOLY_LE 0xedb88320
> +
> +	while (length--) {
> +		crc ^=3D *p++;
> +		for (i =3D 0; i < 8; i++)
> +			crc =3D (crc >> 1) ^ ((crc & 1) ? CRCPOLY_LE : 0);
> +	}
> +
> +	return crc;
> +}
> +
Why do you insist on your own CRC32 implementations?
Don't we have enough already?

[ .. ]
> +/*
> + * Write blocks.
> + */
> +static int dmz_reclaim_write(struct dm_zoned_target *dzt,
> +			     struct dm_zone *zone,
> +			     struct dm_zoned_ioreg **ioregs,
> +			     unsigned int nr_ioregs)
> +{
> +	struct dm_zoned_ioreg *ioreg;
> +	sector_t chunk_block;
> +	int i, ret =3D 0;
> +
> +	for (i =3D 0; i < nr_ioregs; i++) {
> +
> +		ioreg =3D ioregs[i];
> +
> +		/* Wait for the read I/O to complete */
> +		wait_for_completion_io(&ioreg->wait);
> +
> +		if (ret || ioreg->err) {
> +			if (ret =3D=3D 0)
> +				ret =3D ioreg->err;
> +			dmz_reclaim_free_ioreg(ioreg);
> +			ioregs[i] =3D NULL;
> +			continue;
> +		}
> +
> +		chunk_block =3D ioreg->chunk_block;
> +
> +		dmz_dev_debug(dzt,
> +			      "Reclaim: Write %s zone %u, block %llu+%u\n",
> +			      dmz_is_rnd(zone) ? "RND" : "SEQ",
> +			      dmz_id(dzt, zone),
> +			      (unsigned long long)chunk_block,
> +			      ioreg->nr_blocks);
> +
> +		/*
> +		 * If we are writing in a sequential zones,
> +		 * we must make sure that writes are sequential. So
> +		 * fill up any eventual hole between writes.
> +		 */
> +		if (dmz_is_seq(zone)) {
> +			ret =3D dmz_reclaim_align_wp(dzt, zone, chunk_block);
> +			if (ret)
> +				break;
> +		}
> +
> +		/* Do write */
> +		dmz_reclaim_submit_ioreg(dzt, zone, ioreg, REQ_OP_WRITE);
> +		wait_for_completion_io(&ioreg->wait);
> +
> +		ret =3D ioreg->err;
> +		if (ret) {
> +			dmz_dev_err(dzt, "Reclaim: Write failed\n");
> +		} else {
> +			if (dmz_is_seq(zone))
> +				zone->wp_block +=3D ioreg->nr_blocks;
> +			ret =3D dmz_validate_blocks(dzt, zone, chunk_block,
> +						  ioreg->nr_blocks);
> +		}
> +
> +		ioregs[i] =3D NULL;
> +		dmz_reclaim_free_ioreg(ioreg);
> +
> +	}
> +
> +	return ret;
> +}
> +
> +/*
> + * Move valid blocks of src_zone into dst_zone.
> + */
> +static int dmz_reclaim_copy_zone(struct dm_zoned_target *dzt,
> +				 struct dm_zone *src_zone,
> +				 struct dm_zone *dst_zone)
> +{
> +	struct dm_zoned_ioreg *ioregs[DMZ_RECLAIM_MAX_IOREGS];
> +	struct dm_zoned_ioreg *ioreg;
> +	sector_t chunk_block =3D 0;
> +	sector_t first_block, end_block;
> +	int nr_ioregs =3D 0, i, ret;
> +
> +	if (dmz_is_seq(src_zone))
> +		end_block =3D src_zone->wp_block;
> +	else
> +		end_block =3D dzt->zone_nr_blocks;
> +
> +	while (chunk_block < end_block) {
> +
> +		/* Read valid regions from source zone */
> +		nr_ioregs =3D 0;
> +		first_block =3D chunk_block;
> +		while (nr_ioregs < DMZ_RECLAIM_MAX_IOREGS &&
> +		       chunk_block < end_block) {
> +
> +			ioreg =3D dmz_reclaim_read(dzt, src_zone, chunk_block);
> +			if (IS_ERR(ioreg)) {
> +				ret =3D PTR_ERR(ioreg);
> +				goto err;
> +			}
> +			if (!ioreg)
> +				break;
> +
> +			chunk_block =3D ioreg->chunk_block + ioreg->nr_blocks;
> +			ioregs[nr_ioregs] =3D ioreg;
> +			nr_ioregs++;
> +
> +		}
> +
> +		/* Are we done ? */
> +		if (!nr_ioregs)
> +			break;
> +
> +		/* Write in destination zone */
> +		ret =3D dmz_reclaim_write(dzt, dst_zone, ioregs, nr_ioregs);
> +		if (ret !=3D 0) {
> +			dmz_invalidate_blocks(dzt, dst_zone,
> +					      first_block,
> +					      end_block - first_block);
> +			goto err;
> +		}
> +
> +	}
> +
> +	return 0;
> +
> +err:
> +	for (i =3D 0; i < nr_ioregs; i++) {
> +		ioreg =3D ioregs[i];
> +		if (ioreg) {
> +			wait_for_completion_io(&ioreg->wait);
> +			dmz_reclaim_free_ioreg(ioreg);
> +		}
> +	}
> +
> +	return ret;
> +}
> +
Have you looked at using dm-kcopyd for doing the reclaim?
What's inhibiting you from using it?

Cheers,

Hannes
-- =

Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
