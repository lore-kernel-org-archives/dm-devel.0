Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17E14418A44
	for <dm-devel@lists.linux.dev>; Thu, 30 Jul 2026 15:29:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785425366; cv=none; b=NqO6a3gCpkM8ecPQvkEOSvsAeD55JB5aB4c8cQCH3rczoihWSfIj1iL64x3exDWNb1gJdSjzeCtTpzDuhPxtSRtM6bgOnbdJXDWxyei+INzSVSLR6H2XsawUjqHEeYsot6IouwM2qldg62F7xXTTQeBw6Z4/xsN3rkaUsK16k/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785425366; c=relaxed/simple;
	bh=8Qa4LlXzf+eZuxxVykUibwwx71TMhNaMtZ0Gm2hdRlo=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=CIXmGwItzREheBT+h+D0O+32rtOv6bdM7ekAXFCstrI3YD+Z/GGV/GBcXZEktuCwqw5cyD2YIYquapcmWfhR5BUlRxQYB281/uurtmvvEYCAqFLfGexMXPlehyJI8GplDnFF2bktp5iv4myOuCro8mCGQjE9wQ27YH7ieen7iZ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=iJGF0sJl; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="iJGF0sJl"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1785425363;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=OyBMZQ+dIzzeews7QAyJ7Lwc1Y5tP0YfuJUmWti370o=;
	b=iJGF0sJltRcdnE1Z3WP3cHCbbg8pbwOYuZHpi90XLaH8ddQEc+BgN06hnMlEInac847lbD
	HNrAS3Exw/oRNFl08M8Kh2xNExhmtMoFgnNzCQvUcyBxATnLC2hl/+sSXgrpEo3fD/xQe7
	iGkwo/neMTZz2mX/P35H1j7h/5qrb8w=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-5-B9_K6OoeMB6GP3RLvMEliQ-1; Thu,
 30 Jul 2026 11:29:19 -0400
X-MC-Unique: B9_K6OoeMB6GP3RLvMEliQ-1
X-Mimecast-MFC-AGG-ID: B9_K6OoeMB6GP3RLvMEliQ_1785425358
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7FACC1956088;
	Thu, 30 Jul 2026 15:29:17 +0000 (UTC)
Received: from [10.44.32.225] (unknown [10.44.32.225])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E5FBA1956089;
	Thu, 30 Jul 2026 15:29:14 +0000 (UTC)
Date: Thu, 30 Jul 2026 17:29:07 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Shukai Ni <shukai.ni@kuleuven.be>
cc: agk@redhat.com, snitzer@kernel.org, bmarzins@redhat.com, 
    gmazyland@gmail.com, dm-devel@lists.linux.dev, 
    linux-kernel@vger.kernel.org, Jo Van Bulck <jo.vanbulck@cs.kuleuven.be>
Subject: Re: [PATCH v2 1/1] dm-integrity: replace forgeable discard filler
 with a keyed sector marker
In-Reply-To: <20260728143350.44279-2-shukai.ni@kuleuven.be>
Message-ID: <5a838e63-f772-7ef9-ab45-8bc2c1ccae87@redhat.com>
References: <20260728143350.44279-1-shukai.ni@kuleuven.be> <20260728143350.44279-2-shukai.ni@kuleuven.be>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-MFC-PROC-ID: Ydft0Cz4WWsdgyxAvGfcIgLXZ8RFZjN3jFSPQG1azyI_1785425358
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII

Hi

I accepted the patch (and made some small modifications to it).

You can get the updated patch from 
git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git 
branch: for-next

Mikulas

On Tue, 28 Jul 2026, Shukai Ni wrote:

> The discard-block check in dm_integrity_rw_tag() treats a stored tag
> of all 0xf6 bytes (DISCARD_FILLER) as proof a block was discarded and
> skips HMAC verification. allow_discards is only accepted in
> dm-integrity's standalone mode. An attacker with raw write access to
> the backing device, but without the integrity key, can stamp any block
> with an all-0xf6 tag and have it served as authentic.
> 
> Add a new "allow_discards_keyed" target argument that marks discarded
> blocks with a keyed checksum of (salt || sector) instead, computed by
> integrity_discard_checksum().
> 
> Fixes: 84597a44a9d8 ("dm integrity: add optional discard support")
> Co-developed-by: Jo Van Bulck <jo.vanbulck@cs.kuleuven.be>
> Signed-off-by: Jo Van Bulck <jo.vanbulck@cs.kuleuven.be>
> Signed-off-by: Shukai Ni <shukai.ni@kuleuven.be>
> ---
>  .../admin-guide/device-mapper/dm-ima.rst      |   7 +-
>  .../device-mapper/dm-integrity.rst            |  13 ++
>  drivers/md/dm-integrity.c                     | 122 +++++++++++++++---
>  3 files changed, 121 insertions(+), 21 deletions(-)
> 
> diff --git a/Documentation/admin-guide/device-mapper/dm-ima.rst b/Documentation/admin-guide/device-mapper/dm-ima.rst
> index a4aa50a82..2a3b50ffb 100644
> --- a/Documentation/admin-guide/device-mapper/dm-ima.rst
> +++ b/Documentation/admin-guide/device-mapper/dm-ima.rst
> @@ -424,7 +424,8 @@ section above) has the following data format for 'integrity' target.
>  
>   target_attributes := <target_name> "," <target_version> "," <dev_name> "," <start>
>                        <tag_size> "," <mode> "," [<meta_device> ","] [<block_size> ","] <recalculate> ","
> -                      <allow_discards> "," <fix_padding> "," <fix_hmac> "," <legacy_recalculate> ","
> +                      <allow_discards> "," <allow_discards_keyed> "," <fix_padding> "," <fix_hmac> ","
> +                      <legacy_recalculate> ","
>                        <journal_sectors> "," <interleave_sectors> "," <buffer_sectors> ";"
>  
>   target_name := "target_name=integrity"
> @@ -438,6 +439,7 @@ section above) has the following data format for 'integrity' target.
>   block_size := "block_size=" <N>
>   recalculate := "recalculate=" <yes_no>
>   allow_discards := "allow_discards=" <yes_no>
> + allow_discards_keyed := "allow_discards_keyed=" <yes_no>
>   fix_padding := "fix_padding=" <yes_no>
>   fix_hmac := "fix_hmac=" <yes_no>
>   legacy_recalculate := "legacy_recalculate=" <yes_no>
> @@ -455,7 +457,8 @@ section above) has the following data format for 'integrity' target.
>   dm_version=4.45.0;
>   name=integrity1,uuid=,major=253,minor=1,minor_count=1,num_targets=1;
>   target_index=0,target_begin=0,target_len=7856,target_name=integrity,target_version=1.10.0,
> - dev_name=253:0,start=0,tag_size=32,mode=J,recalculate=n,allow_discards=n,fix_padding=n,
> + dev_name=253:0,start=0,tag_size=32,mode=J,recalculate=n,allow_discards=n,
> + allow_discards_keyed=n,fix_padding=n,
>   fix_hmac=n,legacy_recalculate=n,journal_sectors=88,interleave_sectors=32768,buffer_sectors=128;
>  
>  
> diff --git a/Documentation/admin-guide/device-mapper/dm-integrity.rst b/Documentation/admin-guide/device-mapper/dm-integrity.rst
> index c2e18ecc0..9c2130142 100644
> --- a/Documentation/admin-guide/device-mapper/dm-integrity.rst
> +++ b/Documentation/admin-guide/device-mapper/dm-integrity.rst
> @@ -190,6 +190,19 @@ allow_discards
>  	Allow block discard requests (a.k.a. TRIM) for the integrity device.
>  	Discards are only allowed to devices using internal hash.
>  
> +	A discarded block is marked with a constant filler tag that anyone
> +	with raw write access to the backing device can forge without the
> +	key. Use allow_discards_keyed instead on new volumes.
> +
> +allow_discards_keyed
> +	Like allow_discards, but marks a discarded block with a keyed
> +	checksum of the sector number, HMAC_key(salt || sector), instead of
> +	the constant filler tag, so it can't be forged without the
> +	integrity key.
> +
> +	Not compatible with volumes that already have discarded blocks
> +	marked the old way; only use on a freshly formatted volume.
> +
>  fix_padding
>  	Use a smaller padding of the tag area that is more
>  	space-efficient. If this option is not present, large padding is
> diff --git a/drivers/md/dm-integrity.c b/drivers/md/dm-integrity.c
> index 06e805902..03514eb27 100644
> --- a/drivers/md/dm-integrity.c
> +++ b/drivers/md/dm-integrity.c
> @@ -91,6 +91,7 @@ struct superblock {
>  #define SB_FLAG_FIXED_PADDING		0x8
>  #define SB_FLAG_FIXED_HMAC		0x10
>  #define SB_FLAG_INLINE			0x20
> +#define SB_FLAG_DISCARD_KEYED		0x40
>  
>  #define	JOURNAL_ENTRY_ROUNDUP		8
>  
> @@ -277,6 +278,7 @@ struct dm_integrity_c {
>  	bool recalculate_flag;
>  	bool reset_recalculate_flag;
>  	bool discard;
> +	bool discard_keyed;
>  	bool fix_padding;
>  	bool fix_hmac;
>  	bool legacy_recalculate;
> @@ -1414,7 +1416,8 @@ static int dm_integrity_rw_tag(struct dm_integrity_c *ic, unsigned char *tag, se
>  {
>  	unsigned int hash_offset = 0;
>  	unsigned char mismatch_hash = 0;
> -	unsigned char mismatch_filler = !ic->discard;
> +	bool discard_keyed = ic->sb->flags & cpu_to_le32(SB_FLAG_DISCARD_KEYED);
> +	unsigned char mismatch_filler = !ic->discard || discard_keyed;
>  
>  	do {
>  		unsigned char *data, *dp;
> @@ -1466,7 +1469,7 @@ static int dm_integrity_rw_tag(struct dm_integrity_c *ic, unsigned char *tag, se
>  						}
>  						hash_offset = 0;
>  						mismatch_hash = 0;
> -						mismatch_filler = !ic->discard;
> +						mismatch_filler = !ic->discard || discard_keyed;
>  					}
>  				}
>  			}
> @@ -1645,7 +1648,8 @@ static void integrity_end_io(struct bio *bio)
>  }
>  
>  static void integrity_sector_checksum_shash(struct dm_integrity_c *ic, sector_t sector,
> -					    const char *data, unsigned offset, char *result)
> +					    const char *data, unsigned offset,
> +					    unsigned int len, char *result)
>  {
>  	__le64 sector_le = cpu_to_le64(sector);
>  	SHASH_DESC_ON_STACK(req, ic->internal_shash);
> @@ -1674,10 +1678,12 @@ static void integrity_sector_checksum_shash(struct dm_integrity_c *ic, sector_t
>  		goto failed;
>  	}
>  
> -	r = crypto_shash_update(req, data + offset, ic->sectors_per_block << SECTOR_SHIFT);
> -	if (unlikely(r < 0)) {
> -		dm_integrity_io_error(ic, "crypto_shash_update", r);
> -		goto failed;
> +	if (likely(len)) {
> +		r = crypto_shash_update(req, data + offset, len);
> +		if (unlikely(r < 0)) {
> +			dm_integrity_io_error(ic, "crypto_shash_update", r);
> +			goto failed;
> +		}
>  	}
>  
>  	r = crypto_shash_final(req, result);
> @@ -1698,7 +1704,8 @@ static void integrity_sector_checksum_shash(struct dm_integrity_c *ic, sector_t
>  }
>  
>  static void integrity_sector_checksum_ahash(struct dm_integrity_c *ic, struct ahash_request **ahash_req,
> -					    sector_t sector, struct page *page, unsigned offset, char *result)
> +					    sector_t sector, struct page *page, unsigned offset,
> +					    unsigned int len, char *result)
>  {
>  	__le64 sector_le = cpu_to_le64(sector);
>  	struct ahash_request *req;
> @@ -1707,6 +1714,7 @@ static void integrity_sector_checksum_ahash(struct dm_integrity_c *ic, struct ah
>  	int r;
>  	unsigned int digest_size;
>  	unsigned int nbytes = 0;
> +	unsigned int nents = 1 + (len ? 1 : 0);
>  
>  	might_sleep();
>  
> @@ -1720,12 +1728,12 @@ static void integrity_sector_checksum_ahash(struct dm_integrity_c *ic, struct ah
>  	ahash_request_set_callback(req, CRYPTO_TFM_REQ_MAY_SLEEP, crypto_req_done, &wait);
>  
>  	if (ic->sb->flags & cpu_to_le32(SB_FLAG_FIXED_HMAC)) {
> -		sg_init_table(sg, 3);
> +		sg_init_table(sg, nents + 1);
>  		sg_set_buf(s, (const __u8 *)&ic->sb->salt, SALT_SIZE);
>  		nbytes += SALT_SIZE;
>  		s++;
>  	} else {
> -		sg_init_table(sg, 2);
> +		sg_init_table(sg, nents);
>  	}
>  
>  	if (likely(!is_vmalloc_addr(&sector_le))) {
> @@ -1738,8 +1746,10 @@ static void integrity_sector_checksum_ahash(struct dm_integrity_c *ic, struct ah
>  	nbytes += sizeof(sector_le);
>  	s++;
>  
> -	sg_set_page(s, page, ic->sectors_per_block << SECTOR_SHIFT, offset);
> -	nbytes += ic->sectors_per_block << SECTOR_SHIFT;
> +	if (likely(len)) {
> +		sg_set_page(s, page, len, offset);
> +		nbytes += len;
> +	}
>  
>  	ahash_request_set_crypt(req, sg, result, nbytes);
>  
> @@ -1763,10 +1773,40 @@ static void integrity_sector_checksum_ahash(struct dm_integrity_c *ic, struct ah
>  static void integrity_sector_checksum(struct dm_integrity_c *ic, struct ahash_request **ahash_req,
>  				      sector_t sector, const char *data, unsigned offset, char *result)
>  {
> +	unsigned int len = ic->sectors_per_block << SECTOR_SHIFT;
> +
>  	if (likely(ic->internal_shash != NULL))
> -		integrity_sector_checksum_shash(ic, sector, data, offset, result);
> +		integrity_sector_checksum_shash(ic, sector, data, offset, len, result);
>  	else
> -		integrity_sector_checksum_ahash(ic, ahash_req, sector, (struct page *)data, offset, result);
> +		integrity_sector_checksum_ahash(ic, ahash_req, sector, (struct page *)data,
> +						 offset, len, result);
> +}
> +
> +/*
> + * Authenticated marker for a discarded block: HMAC_key(salt || sector), with
> + * no data payload. Because a real data tag's input always covers a full
> + * block, its length differs from this marker's, so the two can never
> + * collide structurally, regardless of block content.
> + */
> +static void integrity_discard_checksum(struct dm_integrity_c *ic, struct ahash_request **ahash_req,
> +				       sector_t sector, char *result)
> +{
> +	if (likely(ic->internal_shash != NULL))
> +		integrity_sector_checksum_shash(ic, sector, NULL, 0, 0, result);
> +	else
> +		integrity_sector_checksum_ahash(ic, ahash_req, sector, NULL, 0, 0, result);
> +}
> +
> +static void integrity_discard_fill_tags(struct dm_integrity_c *ic, struct ahash_request **ahash_req,
> +					unsigned char *checksums, sector_t *sector,
> +					unsigned int blocks)
> +{
> +	unsigned int i;
> +
> +	for (i = 0; i < blocks; i++) {
> +		integrity_discard_checksum(ic, ahash_req, *sector, checksums + i * ic->tag_size);
> +		*sector += ic->sectors_per_block;
> +	}
>  }
>  
>  static void *integrity_kmap(struct dm_integrity_c *ic, struct page *p)
> @@ -1795,6 +1835,29 @@ static void *integrity_identity(struct dm_integrity_c *ic, void *data)
>  		return virt_to_page(data);
>  }
>  
> +static int integrity_recheck_verify_tag(struct dm_integrity_io *dio, char *checksum,
> +					char *on_disk_tag, sector_t logical_sector)
> +{
> +	struct dm_integrity_c *ic = dio->ic;
> +	int r;
> +
> +	if (!(ic->sb->flags & cpu_to_le32(SB_FLAG_DISCARD_KEYED)))
> +		return dm_integrity_rw_tag(ic, checksum, &dio->metadata_block,
> +					   &dio->metadata_offset, ic->tag_size, TAG_CMP);
> +
> +	r = dm_integrity_rw_tag(ic, on_disk_tag, &dio->metadata_block,
> +				&dio->metadata_offset, ic->tag_size, TAG_READ);
> +	if (unlikely(r))
> +		return r;
> +
> +	r = crypto_memneq(on_disk_tag, checksum, ic->tag_size);
> +	if (unlikely(r)) {
> +		integrity_discard_checksum(ic, &dio->ahash_req, logical_sector, checksum);
> +		r = crypto_memneq(on_disk_tag, checksum, ic->tag_size);
> +	}
> +	return r;
> +}
> +
>  static noinline void integrity_recheck(struct dm_integrity_io *dio, char *checksum)
>  {
>  	struct bio *bio = dm_bio_from_per_bio_data(dio, sizeof(struct dm_integrity_io));
> @@ -1820,6 +1883,7 @@ static noinline void integrity_recheck(struct dm_integrity_io *dio, char *checks
>  			char *mem;
>  			char *buffer = page_to_virt(page);
>  			unsigned int buffer_offset;
> +			char on_disk_tag[MAX_T(size_t, HASH_MAX_DIGESTSIZE, MAX_TAG_SIZE)];
>  			int r;
>  			struct dm_io_request io_req;
>  			struct dm_io_region io_loc;
> @@ -1847,8 +1911,8 @@ static noinline void integrity_recheck(struct dm_integrity_io *dio, char *checks
>  			}
>  
>  			integrity_sector_checksum(ic, &dio->ahash_req, logical_sector, integrity_identity(ic, buffer), buffer_offset, checksum);
> -			r = dm_integrity_rw_tag(ic, checksum, &dio->metadata_block,
> -						&dio->metadata_offset, ic->tag_size, TAG_CMP);
> +			r = integrity_recheck_verify_tag(dio, checksum, on_disk_tag,
> +							 logical_sector);
>  			if (r) {
>  				if (r > 0) {
>  					DMERR_LIMIT("%pg: Checksum failed at sector 0x%llx",
> @@ -1914,13 +1978,19 @@ static void integrity_metadata(struct work_struct *w)
>  			unsigned int bi_size = dio->bio_details.bi_iter.bi_size;
>  			unsigned int max_size = likely(checksums != checksums_onstack) ? PAGE_SIZE : HASH_MAX_DIGESTSIZE;
>  			unsigned int max_blocks = max_size / ic->tag_size;
> +			sector_t sector = dio->range.logical_sector;
> +			bool discard_keyed = ic->sb->flags & cpu_to_le32(SB_FLAG_DISCARD_KEYED);
>  
> -			memset(checksums, DISCARD_FILLER, max_size);
> +			if (!discard_keyed)
> +				memset(checksums, DISCARD_FILLER, max_size);
>  
>  			while (bi_size) {
>  				unsigned int this_step_blocks = bi_size >> (SECTOR_SHIFT + ic->sb->log2_sectors_per_block);
>  
>  				this_step_blocks = min(this_step_blocks, max_blocks);
> +				if (discard_keyed)
> +					integrity_discard_fill_tags(ic, &dio->ahash_req, checksums,
> +								    &sector, this_step_blocks);
>  				r = dm_integrity_rw_tag(ic, checksums, &dio->metadata_block, &dio->metadata_offset,
>  							this_step_blocks * ic->tag_size, TAG_WRITE);
>  				if (unlikely(r)) {
> @@ -3795,7 +3865,7 @@ static void dm_integrity_resume(struct dm_target *ti)
>  
>  	ic->wrote_to_journal = false;
>  
> -	flags = ic->sb->flags & cpu_to_le32(SB_FLAG_RECALCULATING);
> +	flags = ic->sb->flags & cpu_to_le32(SB_FLAG_RECALCULATING | SB_FLAG_DISCARD_KEYED);
>  	r = sync_rw_sb(ic, REQ_OP_READ);
>  	if (r)
>  		dm_integrity_io_error(ic, "reading superblock", r);
> @@ -3955,6 +4025,7 @@ static void dm_integrity_status(struct dm_target *ti, status_type_t type,
>  		arg_count += !!ic->journal_mac_alg.alg_string;
>  		arg_count += (ic->sb->flags & cpu_to_le32(SB_FLAG_FIXED_PADDING)) != 0;
>  		arg_count += (ic->sb->flags & cpu_to_le32(SB_FLAG_FIXED_HMAC)) != 0;
> +		arg_count += (ic->sb->flags & cpu_to_le32(SB_FLAG_DISCARD_KEYED)) != 0;
>  		arg_count += ic->legacy_recalculate;
>  		DMEMIT("%s %llu %u %c %u", ic->dev->name, ic->start,
>  		       ic->tag_size, ic->mode, arg_count);
> @@ -3968,6 +4039,8 @@ static void dm_integrity_status(struct dm_target *ti, status_type_t type,
>  			DMEMIT(" reset_recalculate");
>  		if (ic->discard)
>  			DMEMIT(" allow_discards");
> +		if ((ic->sb->flags & cpu_to_le32(SB_FLAG_DISCARD_KEYED)) != 0)
> +			DMEMIT(" allow_discards_keyed");
>  		if (ic->mode != 'I')
>  			DMEMIT(" interleave_sectors:%u", 1U << ic->sb->log2_interleave_sectors);
>  		DMEMIT(" buffer_sectors:%u", 1U << ic->log2_buffer_sectors);
> @@ -4017,6 +4090,8 @@ static void dm_integrity_status(struct dm_target *ti, status_type_t type,
>  		DMEMIT(",recalculate=%c", (ic->sb->flags & cpu_to_le32(SB_FLAG_RECALCULATING)) ?
>  		       'y' : 'n');
>  		DMEMIT(",allow_discards=%c", ic->discard ? 'y' : 'n');
> +		DMEMIT(",allow_discards_keyed=%c",
> +		       ((ic->sb->flags & cpu_to_le32(SB_FLAG_DISCARD_KEYED)) != 0) ? 'y' : 'n');
>  		DMEMIT(",fix_padding=%c",
>  		       ((ic->sb->flags & cpu_to_le32(SB_FLAG_FIXED_PADDING)) != 0) ? 'y' : 'n');
>  		DMEMIT(",fix_hmac=%c",
> @@ -4178,6 +4253,9 @@ static int initialize_superblock(struct dm_integrity_c *ic,
>  		get_random_bytes(ic->sb->salt, SALT_SIZE);
>  	}
>  
> +	if (ic->discard_keyed)
> +		ic->sb->flags |= cpu_to_le32(SB_FLAG_DISCARD_KEYED);
> +
>  	if (!ic->meta_dev) {
>  		if (ic->fix_padding)
>  			ic->sb->flags |= cpu_to_le32(SB_FLAG_FIXED_PADDING);
> @@ -4835,6 +4913,9 @@ static int dm_integrity_ctr(struct dm_target *ti, unsigned int argc, char **argv
>  			ic->reset_recalculate_flag = true;
>  		} else if (!strcmp(opt_string, "allow_discards")) {
>  			ic->discard = true;
> +		} else if (!strcmp(opt_string, "allow_discards_keyed")) {
> +			ic->discard = true;
> +			ic->discard_keyed = true;
>  		} else if (!strcmp(opt_string, "fix_padding")) {
>  			ic->fix_padding = true;
>  		} else if (!strcmp(opt_string, "fix_hmac")) {
> @@ -5212,6 +5293,9 @@ static int dm_integrity_ctr(struct dm_target *ti, unsigned int argc, char **argv
>  		ic->sb->recalc_sector = cpu_to_le64(0);
>  	}
>  
> +	if (ic->discard_keyed)
> +		ic->sb->flags |= cpu_to_le32(SB_FLAG_DISCARD_KEYED);
> +
>  	if (ic->internal_hash) {
>  		ic->recalc_wq = alloc_workqueue("dm-integrity-recalc",
>  						WQ_MEM_RECLAIM | WQ_PERCPU, 1);
> @@ -5430,7 +5514,7 @@ static void dm_integrity_dtr(struct dm_target *ti)
>  
>  static struct target_type integrity_target = {
>  	.name			= "integrity",
> -	.version		= {1, 14, 0},
> +	.version		= {1, 15, 0},
>  	.module			= THIS_MODULE,
>  	.features		= DM_TARGET_SINGLETON | DM_TARGET_INTEGRITY,
>  	.ctr			= dm_integrity_ctr,
> -- 
> 2.53.0
> 

