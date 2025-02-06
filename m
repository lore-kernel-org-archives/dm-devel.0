Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F20223642A
	for <dm-devel@lists.linux.dev>; Thu,  6 Feb 2025 15:22:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738855339; cv=none; b=AYex067FTy+vKBU38z2h1c9LGQj8KqQW2dKb32qppXfeMiS5Sh9F/3kw9w/jVGjumlFFN1KsjkncqpjMD/Mz32lhoDykCanqwFEA6mWxvnOwuYQCXWxrkbBRXlLEaqC192OYZjATPGz9IOeVdO8Afm5tEXodziawudUD70pG1FM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738855339; c=relaxed/simple;
	bh=bJ03wllYQ/0NmFP3kdqcykzBKraQaizhLFuxdAdQtBw=;
	h=MIME-Version:Date:From:To:Cc:Subject:In-Reply-To:References:
	 Message-ID:Content-Type; b=M7ks/C/vbPWoeS1uSn9hJO2BG0pu8U7n7rAc/TlTJvkE29BISsJbEOq1VW1EEejVODhT5QIVRDE6q4UYnNCpBg9470oMZ5aDD1loCxePTNrPniE14/2bIaUjkFnqxJ13BjRG2BKf95ccCoMULDHzzQ2u8tfRCOV97ge8RkHjtY8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=guhXha2s; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="guhXha2s"
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 516ESKxH020811;
	Thu, 6 Feb 2025 15:22:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:reply-to:subject:to; s=pp1;
	 bh=8zlxKLKL2TCxyEHALKKNCaf5iad3Lp1Zi2WxKsKBGqw=; b=guhXha2sobls
	W8rOj0RwhCMB14Ux3l4JAQEeDYKf7desUryaEZ8Nxbo8QrGmQBafBqk4aL93B4/Q
	Om7aW+uqWfkdQcxAzxVGjNvPb62teZQ7btlLuQi9nbonh+W8gN0mJuBG7IVjft9d
	qUYTiKjVXZI59KC07FasWCKb4EXIjYe3LHoKZtQUBabPxj8u2CFquB6G6L7K+oFZ
	gFSCoJvxpQ3q52vBNl7l5e1EEj5iA56/Ql51ZXCZPvskousnh8AsGIm78e9LeZ5N
	rivupvSoCy8mEdVDtzbx4vd9gJjovav86VFvHoY/JkaBNYSCLHY9HeL6u7JKPzQ7
	/bL4mo9/tQ==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 44matteb1x-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 06 Feb 2025 15:22:08 +0000 (GMT)
Received: from m0356516.ppops.net (m0356516.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 516FM80r032320;
	Thu, 6 Feb 2025 15:22:08 GMT
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 44matteb1t-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 06 Feb 2025 15:22:08 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 516EOP72016416;
	Thu, 6 Feb 2025 15:22:07 GMT
Received: from smtprelay07.wdc07v.mail.ibm.com ([172.16.1.74])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 44hwxsq5qp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 06 Feb 2025 15:22:07 +0000
Received: from smtpav04.dal12v.mail.ibm.com (smtpav04.dal12v.mail.ibm.com [10.241.53.103])
	by smtprelay07.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 516FM5oO30868030
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 6 Feb 2025 15:22:05 GMT
Received: from smtpav04.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7BED158052;
	Thu,  6 Feb 2025 15:22:05 +0000 (GMT)
Received: from smtpav04.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0A6AD5805A;
	Thu,  6 Feb 2025 15:22:05 +0000 (GMT)
Received: from ltc.linux.ibm.com (unknown [9.5.196.140])
	by smtpav04.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Thu,  6 Feb 2025 15:22:04 +0000 (GMT)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Date: Thu, 06 Feb 2025 16:22:04 +0100
From: Harald Freudenberger <freude@linux.ibm.com>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: dengler@linux.ibm.com, ifranzki@linux.ibm.com, agk@redhat.com,
        snitzer@kernel.org, linux-s390@vger.kernel.org,
        dm-devel@lists.linux.dev, herbert@gondor.apana.org.au,
        Milan Broz <gmazyland@gmail.com>
Subject: Re: [PATCH v4 2/2] dm-integrity: introduce ahash support for the
 internal hash
Reply-To: freude@linux.ibm.com
Mail-Reply-To: freude@linux.ibm.com
In-Reply-To: <50a28342-9d3c-b4e4-de13-40304eabb8b1@redhat.com>
References: <50a28342-9d3c-b4e4-de13-40304eabb8b1@redhat.com>
Message-ID: <a852fb7677f9e1bc53c7cefb9b7b4d54@linux.ibm.com>
X-Sender: freude@linux.ibm.com
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: XR9hO7rVPb7_j_JT2Cr_IeBwCmpU8HVi
X-Proofpoint-ORIG-GUID: vfyKTUkkCUDRpzparYUKLdxLUN21OihN
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-06_03,2025-02-05_03,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 spamscore=0 suspectscore=0 adultscore=0 mlxscore=0 clxscore=1015
 mlxlogscore=999 bulkscore=0 phishscore=0 malwarescore=0 impostorscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2501170000 definitions=main-2502060123

On 2025-02-05 21:23, Mikulas Patocka wrote:
> Introduce ahash support for the "internal hash" algorithm.
> 
> Rework the dm-integrity code to be able to run the "internal hash"
> either with a synchronous ("shash") or asynchronous ("ahash") hash
> algorithm implementation.
> 
> The get_mac() function now tries to decide which of the digest
> implemenations to use if there is a choice:
> - If an ahash and shash tfm is available and both are backed by the
>   same driver name it is assumed that the shash is the faster
>   implementation and thus the shash tfm is delivered to the caller.
> - If an ahash and shash tfm is available but the backing device driver
>   divers (different driver names) it is assumed that the ahash
>   implementation is a "better" hardware based implementation and thus
>   the ahash tfm is delivered to the caller.
> - If there is no choice, for example only an ahash or an shash
>   implementation is available then this tfm is delivered to the
>   caller. Especially in cases where only an ahash implementation is
>   available this is now used instead of failing.
> - The caller can steer this choice by passing a NULL to the ahash or
>   shash parameter, thus enforcing to only allocate an algorithm of the
>   remaining possibility.
> 
> The function integrity_sector_checksum() is now only a dispatcher
> function calling one of the two new functions
> integrity_ahash_sector_checksum() or integrity_shash_sector_checksum()
> based on which tfm is allocated based on the two new fields
> internal_shash and internal_ahash in struct dm_integrity_c.
> 
> Together with this comes some slight rework around availability and
> digest size of the internal hash in use.
> 
> Signed-off-by: Harald Freudenberger <freude@linux.ibm.com>
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> ---
>  drivers/md/dm-integrity.c |  350 
> +++++++++++++++++++++++++++++++++-------------
>  1 file changed, 252 insertions(+), 98 deletions(-)
> 
> Index: linux-2.6/drivers/md/dm-integrity.c
> ===================================================================
> --- linux-2.6.orig/drivers/md/dm-integrity.c	2025-02-05 
> 18:50:42.000000000 +0100
> +++ linux-2.6/drivers/md/dm-integrity.c	2025-02-05 20:17:42.000000000 
> +0100
> @@ -221,7 +221,9 @@ struct dm_integrity_c {
> 
>  	int failed;
> 
> -	struct crypto_shash *internal_hash;
> +	bool have_internal_hash;
> +	struct crypto_shash *internal_shash;
> +	struct crypto_ahash *internal_ahash;
>  	unsigned int internal_hash_digestsize;
> 
>  	struct dm_target *ti;
> @@ -288,6 +290,8 @@ struct dm_integrity_c {
>  	struct bio_set recalc_bios;
> 
>  	struct notifier_block reboot_notifier;
> +
> +	struct dm_integrity_io *dummy_dio;
>  };
> 
>  struct dm_integrity_range {
> @@ -326,6 +330,8 @@ struct dm_integrity_io {
>  	unsigned payload_len;
>  	bool integrity_payload_from_mempool;
>  	bool integrity_range_locked;
> +
> +	__u64 sector_le;
>  };
> 
>  struct journal_completion {
> @@ -1560,7 +1566,7 @@ static void submit_flush_bio(struct dm_i
>  	unsigned long flags;
> 
>  	spin_lock_irqsave(&ic->endio_wait.lock, flags);
> -	bio = dm_bio_from_per_bio_data(dio, sizeof(struct dm_integrity_io));
> +	bio = dm_bio_from_per_bio_data(dio, ic->ti->per_io_data_size);
>  	bio_list_add(&ic->flush_bio_list, bio);
>  	spin_unlock_irqrestore(&ic->endio_wait.lock, flags);
> 
> @@ -1588,7 +1594,7 @@ static void do_endio(struct dm_integrity
> 
>  static void do_endio_flush(struct dm_integrity_c *ic, struct
> dm_integrity_io *dio)
>  {
> -	struct bio *bio = dm_bio_from_per_bio_data(dio, sizeof(struct
> dm_integrity_io));
> +	struct bio *bio = dm_bio_from_per_bio_data(dio, 
> ic->ti->per_io_data_size);
> 
>  	if (unlikely(dio->fua) && likely(!bio->bi_status) &&
> likely(!dm_integrity_failed(ic)))
>  		submit_flush_bio(ic, dio);
> @@ -1607,7 +1613,7 @@ static void dec_in_flight(struct dm_inte
>  		if (dio->op == REQ_OP_WRITE || unlikely(dio->op == REQ_OP_DISCARD))
>  			schedule_autocommit(ic);
> 
> -		bio = dm_bio_from_per_bio_data(dio, sizeof(struct dm_integrity_io));
> +		bio = dm_bio_from_per_bio_data(dio, ic->ti->per_io_data_size);
>  		if (unlikely(dio->bi_status) && !bio->bi_status)
>  			bio->bi_status = dio->bi_status;
>  		if (likely(!bio->bi_status) && unlikely(bio_sectors(bio) !=
> dio->range.n_sectors)) {
> @@ -1623,7 +1629,7 @@ static void dec_in_flight(struct dm_inte
> 
>  static void integrity_end_io(struct bio *bio)
>  {
> -	struct dm_integrity_io *dio = dm_per_bio_data(bio, sizeof(struct
> dm_integrity_io));
> +	struct dm_integrity_io *dio = bio->bi_private;
> 
>  	dm_bio_restore(&dio->bio_details, bio);
>  	if (bio->bi_integrity)
> @@ -1635,63 +1641,121 @@ static void integrity_end_io(struct bio
>  	dec_in_flight(dio);
>  }
> 
> -static void integrity_sector_checksum(struct dm_integrity_c *ic,
> sector_t sector,
> -				      const char *data, char *result)
> +static bool integrity_shash_sector_checksum(struct dm_integrity_io 
> *dio,
> +					    sector_t sector, const char *data,
> +					    char *result)
>  {
> +	struct dm_integrity_c *ic = dio->ic;
>  	__le64 sector_le = cpu_to_le64(sector);
> -	SHASH_DESC_ON_STACK(req, ic->internal_hash);
> +	SHASH_DESC_ON_STACK(req, ic->internal_shash);
>  	int r;
> -	unsigned int digest_size;
> 
> -	req->tfm = ic->internal_hash;
> +	req->tfm = ic->internal_shash;
> 
>  	r = crypto_shash_init(req);
>  	if (unlikely(r < 0)) {
>  		dm_integrity_io_error(ic, "crypto_shash_init", r);
> -		goto failed;
> +		return false;
>  	}
> 
>  	if (ic->sb->flags & cpu_to_le32(SB_FLAG_FIXED_HMAC)) {
>  		r = crypto_shash_update(req, (__u8 *)&ic->sb->salt, SALT_SIZE);
>  		if (unlikely(r < 0)) {
>  			dm_integrity_io_error(ic, "crypto_shash_update", r);
> -			goto failed;
> +			return false;
>  		}
>  	}
> 
>  	r = crypto_shash_update(req, (const __u8 *)&sector_le, 
> sizeof(sector_le));
>  	if (unlikely(r < 0)) {
>  		dm_integrity_io_error(ic, "crypto_shash_update", r);
> -		goto failed;
> +		return false;
>  	}
> 
>  	r = crypto_shash_update(req, data, ic->sectors_per_block << 
> SECTOR_SHIFT);
>  	if (unlikely(r < 0)) {
>  		dm_integrity_io_error(ic, "crypto_shash_update", r);
> -		goto failed;
> +		return false;
>  	}
> 
>  	r = crypto_shash_final(req, result);
>  	if (unlikely(r < 0)) {
>  		dm_integrity_io_error(ic, "crypto_shash_final", r);
> -		goto failed;
> +		return false;
>  	}
> 
> -	digest_size = ic->internal_hash_digestsize;
> -	if (unlikely(digest_size < ic->tag_size))
> -		memset(result + digest_size, 0, ic->tag_size - digest_size);
> +	return true;
> +}
> 
> -	return;
> +static bool integrity_ahash_sector_checksum(struct dm_integrity_io 
> *dio,
> +					    sector_t sector, const char *data,
> +					    char *result)
> +{
> +	struct dm_integrity_c *ic = dio->ic;
> +	struct ahash_request *req = (struct ahash_request *)(dio + 1);
> +	__le64 *sector_le = &dio->sector_le;
> +	struct scatterlist sg[3], *s;
> +	DECLARE_CRYPTO_WAIT(wait);
> +	int nbytes = 0;
> +	int r;
> +
> +	ahash_request_set_tfm(req, ic->internal_ahash);
> +	ahash_request_set_callback(req, 0, crypto_req_done, &wait);
> +
> +	s = sg;
> +	if (ic->sb->flags & cpu_to_le32(SB_FLAG_FIXED_HMAC)) {
> +		sg_init_table(sg, 3);
> +		sg_set_buf(s, (const __u8 *)&ic->sb->salt, SALT_SIZE);
> +		nbytes += SALT_SIZE;
> +		s++;
> +	} else {
> +		sg_init_table(sg, 2);
> +	}
> +
> +	*sector_le = cpu_to_le64(sector);
> +	sg_set_buf(s, (const __u8 *)sector_le, sizeof(*sector_le));
> +	nbytes += sizeof(*sector_le);
> +	s++;
> +
> +	sg_set_buf(s, data, ic->sectors_per_block << SECTOR_SHIFT);
> +	nbytes += ic->sectors_per_block << SECTOR_SHIFT;
> +
> +	ahash_request_set_crypt(req, sg, result, nbytes);
> 
> -failed:
> -	/* this shouldn't happen anyway, the hash functions have no reason to 
> fail */
> -	get_random_bytes(result, ic->tag_size);
> +	r = crypto_wait_req(crypto_ahash_digest(req), &wait);
> +	if (r) {
> +		dm_integrity_io_error(ic, "crypto_ahash_digest", r);
> +		return false;
> +	}
> +
> +	return true;
> +}
> +
> +static void integrity_sector_checksum(struct dm_integrity_io *dio,
> +				      sector_t sector, const char *data,
> +				      char *result)
> +{
> +	struct dm_integrity_c *ic = dio->ic;
> +	bool r;
> +
> +	if (likely(ic->internal_shash))
> +		r = integrity_shash_sector_checksum(dio, sector, data, result);
> +	else
> +		r = integrity_ahash_sector_checksum(dio, sector, data, result);
> +
> +	if (unlikely(!r)) {
> +		get_random_bytes(result, ic->tag_size);
> +	} else {
> +		if (unlikely(ic->internal_hash_digestsize < ic->tag_size))
> +			memset(result + ic->internal_hash_digestsize,
> +			       0, ic->tag_size - ic->internal_hash_digestsize);
> +	}
>  }
> 
>  static noinline void integrity_recheck(struct dm_integrity_io *dio,
> char *checksum)
>  {
> -	struct bio *bio = dm_bio_from_per_bio_data(dio, sizeof(struct
> dm_integrity_io));
>  	struct dm_integrity_c *ic = dio->ic;
> +	struct bio *bio = dm_bio_from_per_bio_data(dio, 
> ic->ti->per_io_data_size);
>  	struct bvec_iter iter;
>  	struct bio_vec bv;
>  	sector_t sector, logical_sector, area, offset;
> @@ -1738,7 +1802,7 @@ static noinline void integrity_recheck(s
>  				goto free_ret;
>  			}
> 
> -			integrity_sector_checksum(ic, logical_sector, buffer, checksum);
> +			integrity_sector_checksum(dio, logical_sector, buffer, checksum);
>  			r = dm_integrity_rw_tag(ic, checksum, &dio->metadata_block,
>  						&dio->metadata_offset, ic->tag_size, TAG_CMP);
>  			if (r) {
> @@ -1774,11 +1838,11 @@ static void integrity_metadata(struct wo
> 
>  	int r;
> 
> -	if (ic->internal_hash) {
> +	if (ic->have_internal_hash) {
>  		struct bvec_iter iter;
>  		struct bio_vec bv;
>  		unsigned int digest_size = ic->internal_hash_digestsize;
> -		struct bio *bio = dm_bio_from_per_bio_data(dio, sizeof(struct
> dm_integrity_io));
> +		struct bio *bio = dm_bio_from_per_bio_data(dio, 
> ic->ti->per_io_data_size);
>  		char *checksums;
>  		unsigned int extra_space = unlikely(digest_size > ic->tag_size) ?
> digest_size - ic->tag_size : 0;
>  		char checksums_onstack[MAX_T(size_t, HASH_MAX_DIGESTSIZE, 
> MAX_TAG_SIZE)];
> @@ -1842,7 +1906,7 @@ again:
>  			pos = 0;
>  			checksums_ptr = checksums;
>  			do {
> -				integrity_sector_checksum(ic, sector, mem + pos, checksums_ptr);
> +				integrity_sector_checksum(dio, sector, mem + pos, checksums_ptr);
>  				checksums_ptr += ic->tag_size;
>  				sectors_to_process -= ic->sectors_per_block;
>  				pos += ic->sectors_per_block << SECTOR_SHIFT;
> @@ -1942,7 +2006,7 @@ static inline bool dm_integrity_check_li
>  static int dm_integrity_map(struct dm_target *ti, struct bio *bio)
>  {
>  	struct dm_integrity_c *ic = ti->private;
> -	struct dm_integrity_io *dio = dm_per_bio_data(bio, sizeof(struct
> dm_integrity_io));
> +	struct dm_integrity_io *dio = dm_per_bio_data(bio, 
> ic->ti->per_io_data_size);
>  	struct bio_integrity_payload *bip;
> 
>  	sector_t area, offset;
> @@ -1992,7 +2056,7 @@ static int dm_integrity_map(struct dm_ta
>  		return DM_MAPIO_KILL;
> 
>  	bip = bio_integrity(bio);
> -	if (!ic->internal_hash) {
> +	if (!ic->have_internal_hash) {
>  		if (bip) {
>  			unsigned int wanted_tag_size = bio_sectors(bio) >>
> ic->sb->log2_sectors_per_block;
> 
> @@ -2073,10 +2137,10 @@ retry_kmap:
>  					mem_ptr += 1 << SECTOR_SHIFT;
>  				} while (++s < ic->sectors_per_block);
>  #ifdef INTERNAL_VERIFY
> -				if (ic->internal_hash) {
> +				if (ic->have_internal_hash) {
>  					char checksums_onstack[MAX_T(size_t, HASH_MAX_DIGESTSIZE, 
> MAX_TAG_SIZE)];
> 
> -					integrity_sector_checksum(ic, logical_sector, mem +
> bv.bv_offset, checksums_onstack);
> +					integrity_sector_checksum(dio, logical_sector, mem +
> bv.bv_offset, checksums_onstack);
>  					if (unlikely(memcmp(checksums_onstack, journal_entry_tag(ic,
> je), ic->tag_size))) {
>  						DMERR_LIMIT("Checksum failed when reading from journal, at
> sector 0x%llx",
>  							    logical_sector);
> @@ -2087,7 +2151,7 @@ retry_kmap:
>  #endif
>  			}
> 
> -			if (!ic->internal_hash) {
> +			if (!ic->have_internal_hash) {
>  				struct bio_integrity_payload *bip = bio_integrity(bio);
>  				unsigned int tag_todo = ic->tag_size;
>  				char *tag_ptr = journal_entry_tag(ic, je);
> @@ -2124,16 +2188,16 @@ retry_kmap:
>  					je->last_bytes[s] = js[s].commit_id;
>  				} while (++s < ic->sectors_per_block);
> 
> -				if (ic->internal_hash) {
> +				if (ic->have_internal_hash) {
>  					unsigned int digest_size = ic->internal_hash_digestsize;
> 
>  					if (unlikely(digest_size > ic->tag_size)) {
>  						char checksums_onstack[HASH_MAX_DIGESTSIZE];
> 
> -						integrity_sector_checksum(ic, logical_sector, (char *)js,
> checksums_onstack);
> +						integrity_sector_checksum(dio, logical_sector, (char *)js,
> checksums_onstack);
>  						memcpy(journal_entry_tag(ic, je), checksums_onstack, 
> ic->tag_size);
>  					} else
> -						integrity_sector_checksum(ic, logical_sector, (char *)js,
> journal_entry_tag(ic, je));
> +						integrity_sector_checksum(dio, logical_sector, (char *)js,
> journal_entry_tag(ic, je));
>  				}
> 
>  				journal_entry_set_sector(je, logical_sector);
> @@ -2181,13 +2245,13 @@ retry_kmap:
>  static void dm_integrity_map_continue(struct dm_integrity_io *dio,
> bool from_map)
>  {
>  	struct dm_integrity_c *ic = dio->ic;
> -	struct bio *bio = dm_bio_from_per_bio_data(dio, sizeof(struct
> dm_integrity_io));
> +	struct bio *bio = dm_bio_from_per_bio_data(dio, 
> ic->ti->per_io_data_size);
>  	unsigned int journal_section, journal_entry;
>  	unsigned int journal_read_pos;
>  	sector_t recalc_sector;
>  	struct completion read_comp;
>  	bool discard_retried = false;
> -	bool need_sync_io = ic->internal_hash && dio->op == REQ_OP_READ;
> +	bool need_sync_io = ic->have_internal_hash && dio->op == REQ_OP_READ;
> 
>  	if (unlikely(dio->op == REQ_OP_DISCARD) && ic->mode != 'D')
>  		need_sync_io = true;
> @@ -2360,6 +2424,7 @@ offload_to_thread:
>  	bio_set_dev(bio, ic->dev->bdev);
>  	bio->bi_integrity = NULL;
>  	bio->bi_opf &= ~REQ_INTEGRITY;
> +	bio->bi_private = dio;
>  	bio->bi_end_io = integrity_end_io;
>  	bio->bi_iter.bi_size = dio->range.n_sectors << SECTOR_SHIFT;
> 
> @@ -2410,7 +2475,7 @@ journal_read_write:
>  static int dm_integrity_map_inline(struct dm_integrity_io *dio, bool 
> from_map)
>  {
>  	struct dm_integrity_c *ic = dio->ic;
> -	struct bio *bio = dm_bio_from_per_bio_data(dio, sizeof(struct
> dm_integrity_io));
> +	struct bio *bio = dm_bio_from_per_bio_data(dio, 
> ic->ti->per_io_data_size);
>  	struct bio_integrity_payload *bip;
>  	unsigned ret;
>  	sector_t recalc_sector;
> @@ -2509,7 +2574,7 @@ skip_spinlock:
>  			const char *mem = bvec_kmap_local(&bv);
>  			if (ic->tag_size < ic->tuple_size)
>  				memset(dio->integrity_payload + pos + ic->tag_size, 0,
> ic->tuple_size - ic->tuple_size);
> -			integrity_sector_checksum(ic, dio->bio_details.bi_iter.bi_sector,
> mem, dio->integrity_payload + pos);
> +			integrity_sector_checksum(dio, dio->bio_details.bi_iter.bi_sector,
> mem, dio->integrity_payload + pos);
>  			kunmap_local(mem);
>  			pos += ic->tuple_size;
>  			bio_advance_iter_single(bio, &dio->bio_details.bi_iter,
> ic->sectors_per_block << SECTOR_SHIFT);
> @@ -2541,8 +2606,8 @@ static inline void dm_integrity_free_pay
>  static void dm_integrity_inline_recheck(struct work_struct *w)
>  {
>  	struct dm_integrity_io *dio = container_of(w, struct dm_integrity_io, 
> work);
> -	struct bio *bio = dm_bio_from_per_bio_data(dio, sizeof(struct
> dm_integrity_io));
>  	struct dm_integrity_c *ic = dio->ic;
> +	struct bio *bio = dm_bio_from_per_bio_data(dio, 
> ic->ti->per_io_data_size);
>  	struct bio *outgoing_bio;
>  	void *outgoing_data;
> 
> @@ -2595,7 +2660,7 @@ static void dm_integrity_inline_recheck(
>  		}
>  		bio_put(outgoing_bio);
> 
> -		integrity_sector_checksum(ic, dio->bio_details.bi_iter.bi_sector,
> outgoing_data, digest);
> +		integrity_sector_checksum(dio, dio->bio_details.bi_iter.bi_sector,
> outgoing_data, digest);
>  		if (unlikely(memcmp(digest, dio->integrity_payload,
>  				    min(ic->internal_hash_digestsize, ic->tag_size)))) {
>  			DMERR_LIMIT("%pg: Checksum failed at sector 0x%llx",
> @@ -2620,34 +2685,63 @@ static void dm_integrity_inline_recheck(
>  	bio_endio(bio);
>  }
> 
> +static bool dm_integrity_inline_verify(struct dm_integrity_io *dio)
> +{
> +	struct dm_integrity_c *ic = dio->ic;
> +	struct bio *bio = dm_bio_from_per_bio_data(dio, 
> ic->ti->per_io_data_size);
> +	unsigned pos = 0;
> +
> +	while (dio->bio_details.bi_iter.bi_size) {
> +		char digest[HASH_MAX_DIGESTSIZE];
> +		struct bio_vec bv = bio_iter_iovec(bio, dio->bio_details.bi_iter);
> +		char *mem = bvec_kmap_local(&bv);
> +		//memset(mem, 0xff, ic->sectors_per_block << SECTOR_SHIFT);
> +		integrity_sector_checksum(dio, dio->bio_details.bi_iter.bi_sector,
> mem, digest);
> +		if (unlikely(memcmp(digest, dio->integrity_payload + pos,
> +				min(ic->internal_hash_digestsize, ic->tag_size)))) {
> +			kunmap_local(mem);
> +			dm_integrity_free_payload(dio);
> +			INIT_WORK(&dio->work, dm_integrity_inline_recheck);
> +			queue_work(ic->offload_wq, &dio->work);
> +			return false;
> +		}
> +		kunmap_local(mem);
> +		pos += ic->tuple_size;
> +		bio_advance_iter_single(bio, &dio->bio_details.bi_iter,
> ic->sectors_per_block << SECTOR_SHIFT);
> +	}
> +	return true;
> +}
> +
> +static void dm_integrity_inline_offload(struct work_struct *w)
> +{
> +	struct dm_integrity_io *dio = container_of(w, struct dm_integrity_io, 
> work);
> +	struct bio *bio;
> +
> +	if (unlikely(!dm_integrity_inline_verify(dio)))
> +		return;
> +
> +	dm_integrity_free_payload(dio);
> +
> +	bio = dm_bio_from_per_bio_data(dio, dio->ic->ti->per_io_data_size);
> +	bio_endio(bio);
> +}
> +
>  static int dm_integrity_end_io(struct dm_target *ti, struct bio *bio,
> blk_status_t *status)
>  {
>  	struct dm_integrity_c *ic = ti->private;
>  	if (ic->mode == 'I') {
> -		struct dm_integrity_io *dio = dm_per_bio_data(bio, sizeof(struct
> dm_integrity_io));
> +		struct dm_integrity_io *dio = dm_per_bio_data(bio, 
> ic->ti->per_io_data_size);
>  		if (dio->op == REQ_OP_READ && likely(*status == BLK_STS_OK)) {
> -			unsigned pos = 0;
> -			if (ic->sb->flags & cpu_to_le32(SB_FLAG_RECALCULATING) &&
> -			    unlikely(dio->integrity_range_locked))
> +			if (unlikely(dio->integrity_range_locked) ||
> +			    !dio->bio_details.bi_iter.bi_size)
>  				goto skip_check;
> -			while (dio->bio_details.bi_iter.bi_size) {
> -				char digest[HASH_MAX_DIGESTSIZE];
> -				struct bio_vec bv = bio_iter_iovec(bio, dio->bio_details.bi_iter);
> -				char *mem = bvec_kmap_local(&bv);
> -				//memset(mem, 0xff, ic->sectors_per_block << SECTOR_SHIFT);
> -				integrity_sector_checksum(ic, dio->bio_details.bi_iter.bi_sector,
> mem, digest);
> -				if (unlikely(memcmp(digest, dio->integrity_payload + pos,
> -						min(ic->internal_hash_digestsize, ic->tag_size)))) {
> -					kunmap_local(mem);
> -					dm_integrity_free_payload(dio);
> -					INIT_WORK(&dio->work, dm_integrity_inline_recheck);
> -					queue_work(ic->offload_wq, &dio->work);
> -					return DM_ENDIO_INCOMPLETE;
> -				}
> -				kunmap_local(mem);
> -				pos += ic->tuple_size;
> -				bio_advance_iter_single(bio, &dio->bio_details.bi_iter,
> ic->sectors_per_block << SECTOR_SHIFT);
> +			if (unlikely(ic->internal_ahash != NULL)) {
> +				INIT_WORK(&dio->work, dm_integrity_inline_offload);
> +				queue_work(ic->offload_wq, &dio->work);
> +				return DM_ENDIO_INCOMPLETE;
>  			}
> +			if (unlikely(!dm_integrity_inline_verify(dio)))
> +				return DM_ENDIO_INCOMPLETE;
>  		}
>  skip_check:
>  		dm_integrity_free_payload(dio);
> @@ -2663,7 +2757,7 @@ static void integrity_bio_wait(struct wo
>  	struct dm_integrity_c *ic = dio->ic;
> 
>  	if (ic->mode == 'I') {
> -		struct bio *bio = dm_bio_from_per_bio_data(dio, sizeof(struct
> dm_integrity_io));
> +		struct bio *bio = dm_bio_from_per_bio_data(dio, 
> ic->ti->per_io_data_size);
>  		int r = dm_integrity_map_inline(dio, false);
>  		switch (r) {
>  			case DM_MAPIO_KILL:
> @@ -2904,14 +2998,11 @@ static void do_journal_write(struct dm_i
>  				int r;
>  				struct journal_entry *je2 = access_journal_entry(ic, i, l);
> 
> -				if (
> -#ifndef INTERNAL_VERIFY
> -				    unlikely(from_replay) &&
> -#endif
> -				    ic->internal_hash) {
> +				if (unlikely(from_replay) &&
> +				    ic->have_internal_hash) {
>  					char test_tag[MAX_T(size_t, HASH_MAX_DIGESTSIZE, MAX_TAG_SIZE)];
> 
> -					integrity_sector_checksum(ic, sec + ((l - j) <<
> ic->sb->log2_sectors_per_block),
> +					integrity_sector_checksum(ic->dummy_dio, sec + ((l - j) <<
> ic->sb->log2_sectors_per_block),
>  								  (char *)access_journal_data(ic, i, l), test_tag);
>  					if (unlikely(memcmp(test_tag, journal_entry_tag(ic, je2),
> ic->tag_size))) {
>  						dm_integrity_io_error(ic, "tag mismatch when replaying
> journal", -EILSEQ);
> @@ -3105,7 +3196,7 @@ next_chunk:
> 
>  	t = recalc_tags;
>  	for (i = 0; i < n_sectors; i += ic->sectors_per_block) {
> -		integrity_sector_checksum(ic, logical_sector + i, recalc_buffer +
> (i << SECTOR_SHIFT), t);
> +		integrity_sector_checksum(ic->dummy_dio, logical_sector + i,
> recalc_buffer + (i << SECTOR_SHIFT), t);
>  		t += ic->tag_size;
>  	}
> 
> @@ -3225,7 +3316,7 @@ next_chunk:
>  	t = recalc_tags;
>  	for (i = 0; i < range.n_sectors; i += ic->sectors_per_block) {
>  		memset(t, 0, ic->tuple_size);
> -		integrity_sector_checksum(ic, range.logical_sector + i,
> recalc_buffer + (i << SECTOR_SHIFT), t);
> +		integrity_sector_checksum(ic->dummy_dio, range.logical_sector + i,
> recalc_buffer + (i << SECTOR_SHIFT), t);
>  		t += ic->tuple_size;
>  	}
> 
> @@ -3296,7 +3387,7 @@ static void bitmap_block_work(struct wor
>  	while ((bio = bio_list_pop(&bio_queue))) {
>  		struct dm_integrity_io *dio;
> 
> -		dio = dm_per_bio_data(bio, sizeof(struct dm_integrity_io));
> +		dio = dm_per_bio_data(bio, ic->ti->per_io_data_size);
> 
>  		if (block_bitmap_op(ic, ic->may_write_bitmap, 
> dio->range.logical_sector,
>  				    dio->range.n_sectors, BITMAP_OP_TEST_ALL_SET)) {
> @@ -3318,7 +3409,7 @@ static void bitmap_block_work(struct wor
>  			   BITMAP_BLOCK_SIZE >> SECTOR_SHIFT, NULL);
> 
>  	while ((bio = bio_list_pop(&waiting))) {
> -		struct dm_integrity_io *dio = dm_per_bio_data(bio, sizeof(struct
> dm_integrity_io));
> +		struct dm_integrity_io *dio = dm_per_bio_data(bio, 
> ic->ti->per_io_data_size);
> 
>  		block_bitmap_op(ic, ic->may_write_bitmap, dio->range.logical_sector,
>  				dio->range.n_sectors, BITMAP_OP_SET);
> @@ -3905,7 +3996,7 @@ static void dm_integrity_io_hints(struct
>  		limits->discard_granularity = ic->sectors_per_block << SECTOR_SHIFT;
>  	}
> 
> -	if (!ic->internal_hash) {
> +	if (!ic->have_internal_hash) {
>  		struct blk_integrity *bi = &limits->integrity;
> 
>  		memset(bi, 0, sizeof(*bi));
> @@ -4213,32 +4304,76 @@ nomem:
>  	return -ENOMEM;
>  }
> 
> -static int get_mac(struct crypto_shash **hash, struct alg_spec *a,
> char **error,
> +static int get_mac(struct crypto_shash **shash, struct crypto_ahash 
> **ahash,
> +		   struct alg_spec *a, char **error,
>  		   char *error_alg, char *error_key)
>  {
> +	const char *ahash_driver_name = NULL;
>  	int r;
> 
> -	if (a->alg_string) {
> -		*hash = crypto_alloc_shash(a->alg_string, 0, 
> CRYPTO_ALG_ALLOCATES_MEMORY);
> -		if (IS_ERR(*hash)) {
> +	if (!a->alg_string)
> +		return 0;
> +
> +	if (ahash) {
> +		*ahash = crypto_alloc_ahash(a->alg_string, 0, 
> CRYPTO_ALG_ALLOCATES_MEMORY);
> +		if (IS_ERR(*ahash)) {
>  			*error = error_alg;
> -			r = PTR_ERR(*hash);
> -			*hash = NULL;
> +			r = PTR_ERR(*ahash);
> +			*ahash = NULL;
>  			return r;
>  		}
> +		ahash_driver_name = crypto_ahash_driver_name(*ahash);
> +	}
> 
> -		if (a->key) {
> -			r = crypto_shash_setkey(*hash, a->key, a->key_size);
> -			if (r) {
> -				*error = error_key;
> -				return r;
> +	if (shash) {
> +		*shash = crypto_alloc_shash(a->alg_string, 0, 
> CRYPTO_ALG_ALLOCATES_MEMORY);
> +		if (IS_ERR(*shash) && !ahash_driver_name) {
> +			*error = error_alg;
> +			r = PTR_ERR(*shash);
> +			*shash = NULL;
> +			return r;
> +		}
> +		if (!IS_ERR(*shash) && ahash_driver_name) {
> +			if (strcmp(crypto_shash_driver_name(*shash), ahash_driver_name)) {
> +				/*
> +				 * ahash gave a different driver than shash, so probably
> +				 * this is a case of real hardware offload.  Use ahash.
> +				 */
> +				crypto_free_shash(*shash);
> +				*shash = NULL;
> +			} else {
> +				/* ahash and shash are same driver. Use shash. */
> +				crypto_free_ahash(*ahash);
> +				*ahash = NULL;
>  			}
> -		} else if (crypto_shash_get_flags(*hash) & CRYPTO_TFM_NEED_KEY) {
> +		}
> +	}
> +
> +	/* either *ahash or *shash is set now */
> +
> +	if (a->key) {
> +		r = shash && *shash ?
> +			crypto_shash_setkey(*shash, a->key, a->key_size) :
> +			crypto_ahash_setkey(*ahash, a->key, a->key_size);
> +		if (r) {
>  			*error = error_key;
> -			return -ENOKEY;
> +			return r;
>  		}
> +	} else if ((shash && *shash ?
> +		    crypto_shash_get_flags(*shash) :
> +		    crypto_ahash_get_flags(*ahash))
> +		   & CRYPTO_TFM_NEED_KEY) {
> +		*error = error_key;
> +		return -ENOKEY;
>  	}
> 
> +	pr_debug("Using %s %s (driver name %s)\n",
> +		 ahash && *ahash ? "ahash" : "shash",
> +		 a->alg_string,
> +		 ahash && *ahash ?
> +		 crypto_ahash_driver_name(*ahash) :
> +		 crypto_shash_driver_name(*shash));
> +
>  	return 0;
>  }
> 
> @@ -4693,20 +4828,35 @@ static int dm_integrity_ctr(struct dm_ta
>  		buffer_sectors = 1;
>  	ic->log2_buffer_sectors = min((int)__fls(buffer_sectors), 31 - 
> SECTOR_SHIFT);
> 
> -	r = get_mac(&ic->internal_hash, &ic->internal_hash_alg, &ti->error,
> +	r = get_mac(&ic->internal_shash, &ic->internal_ahash,
> +		    &ic->internal_hash_alg, &ti->error,
>  		    "Invalid internal hash", "Error setting internal hash key");
>  	if (r)
>  		goto bad;
> -	if (ic->internal_hash)
> -		ic->internal_hash_digestsize = 
> crypto_shash_digestsize(ic->internal_hash);
> +	ic->have_internal_hash = ic->internal_shash || ic->internal_ahash;
> +	if (ic->internal_ahash)
> +		ti->per_io_data_size += sizeof(struct ahash_request) +
> +					crypto_ahash_reqsize(ic->internal_ahash);
> +	if (ic->have_internal_hash)
> +		ic->internal_hash_digestsize = ic->internal_shash ?
> +			crypto_shash_digestsize(ic->internal_shash) :
> +			crypto_ahash_digestsize(ic->internal_ahash);
> +
> +	ic->dummy_dio = kmalloc(ti->per_io_data_size, GFP_KERNEL);
> +	if (!ic->dummy_dio) {
> +		ti->error = "Cannot allocate dummy dio";
> +		r = -ENOMEM;
> +		goto bad;
> +	}
> +	ic->dummy_dio->ic = ic;
> 
> -	r = get_mac(&ic->journal_mac, &ic->journal_mac_alg, &ti->error,
> +	r = get_mac(&ic->journal_mac, NULL, &ic->journal_mac_alg, &ti->error,
>  		    "Invalid journal mac", "Error setting journal mac key");
>  	if (r)
>  		goto bad;
> 
>  	if (!ic->tag_size) {
> -		if (!ic->internal_hash) {
> +		if (!ic->have_internal_hash) {
>  			ti->error = "Unknown tag size";
>  			r = -EINVAL;
>  			goto bad;
> @@ -4770,13 +4920,13 @@ static int dm_integrity_ctr(struct dm_ta
>  		}
>  	}
> 
> -	if (ic->mode == 'B' && !ic->internal_hash) {
> +	if (ic->mode == 'B' && !ic->have_internal_hash) {
>  		r = -EINVAL;
>  		ti->error = "Bitmap mode can be only used with internal hash";
>  		goto bad;
>  	}
> 
> -	if (ic->discard && !ic->internal_hash) {
> +	if (ic->discard && !ic->have_internal_hash) {
>  		r = -EINVAL;
>  		ti->error = "Discard can be only used with internal hash";
>  		goto bad;
> @@ -5038,7 +5188,7 @@ try_smaller_buffer:
>  		ic->sb->recalc_sector = cpu_to_le64(0);
>  	}
> 
> -	if (ic->internal_hash) {
> +	if (ic->have_internal_hash) {
>  		ic->recalc_wq = alloc_workqueue("dm-integrity-recalc", 
> WQ_MEM_RECLAIM, 1);
>  		if (!ic->recalc_wq) {
>  			ti->error = "Cannot allocate workqueue";
> @@ -5232,8 +5382,10 @@ static void dm_integrity_dtr(struct dm_t
>  	if (ic->sb)
>  		free_pages_exact(ic->sb, SB_SECTORS << SECTOR_SHIFT);
> 
> -	if (ic->internal_hash)
> -		crypto_free_shash(ic->internal_hash);
> +	if (ic->internal_shash)
> +		crypto_free_shash(ic->internal_shash);
> +	if (ic->internal_ahash)
> +		crypto_free_ahash(ic->internal_ahash);
>  	free_alg(&ic->internal_hash_alg);
> 
>  	if (ic->journal_crypt)
> @@ -5244,13 +5396,15 @@ static void dm_integrity_dtr(struct dm_t
>  		crypto_free_shash(ic->journal_mac);
>  	free_alg(&ic->journal_mac_alg);
> 
> +	kfree(ic->dummy_dio);
> +
>  	kfree(ic);
>  	dm_audit_log_dtr(DM_MSG_PREFIX, ti, 1);
>  }
> 
>  static struct target_type integrity_target = {
>  	.name			= "integrity",
> -	.version		= {1, 13, 0},
> +	.version		= {1, 14, 0},
>  	.module			= THIS_MODULE,
>  	.features		= DM_TARGET_SINGLETON | DM_TARGET_INTEGRITY,
>  	.ctr			= dm_integrity_ctr,

great, Thanks
I will give this a try with the phmac on my test mainframe :-)
