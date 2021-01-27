Return-Path: <SRS0=jLbn=G6=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E5D1C433E0
	for <dm-devel@archiver.kernel.org>; Wed, 27 Jan 2021 11:02:04 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 9145420770
	for <dm-devel@archiver.kernel.org>; Wed, 27 Jan 2021 11:02:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9145420770
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-493-_3cqpW7DNV6PuQsFomwjTQ-1; Wed, 27 Jan 2021 06:01:57 -0500
X-MC-Unique: _3cqpW7DNV6PuQsFomwjTQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EA85B801AB1;
	Wed, 27 Jan 2021 11:01:51 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id F35086EF55;
	Wed, 27 Jan 2021 11:01:49 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 16C49180954D;
	Wed, 27 Jan 2021 11:01:48 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 10RB0w5s031916 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 27 Jan 2021 06:00:58 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 03F09100BCB0; Wed, 27 Jan 2021 11:00:58 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id F401C100BFDE
	for <dm-devel@redhat.com>; Wed, 27 Jan 2021 11:00:55 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E3472811E8F
	for <dm-devel@redhat.com>; Wed, 27 Jan 2021 11:00:54 +0000 (UTC)
Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com
	[209.85.221.46]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-568-W3KVmU-GO9aWNJTaNaSNTw-1; Wed, 27 Jan 2021 06:00:50 -0500
X-MC-Unique: W3KVmU-GO9aWNJTaNaSNTw-1
Received: by mail-wr1-f46.google.com with SMTP id a1so1430954wrq.6;
	Wed, 27 Jan 2021 03:00:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:subject:to:cc:references:from:message-id:date
	:user-agent:mime-version:in-reply-to:content-language
	:content-transfer-encoding;
	bh=G6EmUadWcKOfRscrn+MPfwsDA4VtPtLoj1O9YkiVAjw=;
	b=KGqk51ZQhcBj7TZloy6GgxAeOj4GyhwDKf7qlhMc1APaw0MCyQfiz8AoPHdoVd9xhF
	PmzBZnY8lLWoVR+q4UO3EMd3WxlY5yBC4uvW7JGuBiwZR92UTfYuH7PqnvuBT9wRrRP1
	r41cBJjuy5D4BUPF5XTXIAFAQ3kruHXC0RdFPnN6zuxJrSeSZNUwz1LUFuJKYR58SphQ
	owtCKlZ8jNsiP6iFuQsaFrHvRMpqQcSloP50AUNK/oC9b0DP1bIv8TeDDyG7ZRIPjMul
	AyT9cKuIh8b8G6W5VihKvKVHaSw2piuM3BUxMBh2tpq1C9jiW/X0CifgMw1jj57aEiyL
	LWZA==
X-Gm-Message-State: AOAM532WuB1sWXHWFB5OK+hDtVgp6doIsDVkXijxmcbOnpR2RmtFG/uS
	tU1uAA7FeFxyUnVD+atWtKC0tbEXfsg=
X-Google-Smtp-Source: ABdhPJxNlfdDxXyz0WUKqpY8b+C1p7hX8Zq4rcSZdyKLmdj+El5uRx5KsPN5uD0p7ca5tdRxS3N8QA==
X-Received: by 2002:a5d:51cf:: with SMTP id n15mr10341941wrv.303.1611745248916;
	Wed, 27 Jan 2021 03:00:48 -0800 (PST)
Received: from [192.168.2.27] (39.35.broadband4.iol.cz. [85.71.35.39])
	by smtp.gmail.com with ESMTPSA id
	x81sm2239486wmg.40.2021.01.27.03.00.47
	(version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
	Wed, 27 Jan 2021 03:00:48 -0800 (PST)
To: Mike Snitzer <msnitzer@redhat.com>
References: <alpine.LRH.2.02.2101201359160.16623@file01.intranet.prod.int.rdu2.redhat.com>
	<alpine.LRH.2.02.2101210737550.18628@file01.intranet.prod.int.rdu2.redhat.com>
	<alpine.LRH.2.02.2101211009060.13545@file01.intranet.prod.int.rdu2.redhat.com>
	<alpine.LRH.2.02.2101231525540.28834@file01.intranet.prod.int.rdu2.redhat.com>
From: Milan Broz <gmazyland@gmail.com>
Message-ID: <c3892c1d-76db-5590-cf4a-a8321ce29bde@gmail.com>
Date: Wed, 27 Jan 2021 12:00:46 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
	Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <alpine.LRH.2.02.2101231525540.28834@file01.intranet.prod.int.rdu2.redhat.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-loop: dm-devel@redhat.com
Cc: security@kernel.org, =?UTF-8?Q?Daniel_Gl=c3=b6ckner?= <dg@emlix.com>,
	dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>,
	Ondrej Kozina <okozina@redhat.com>, Laura Abbott <laura@labbott.name>,
	Alasdair Kergon <agk@redhat.com>
Subject: Re: [dm-devel] [PATCH v5 2/2] dm-integrity: introduce the
	"fix_hmac" argument
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 23/01/2021 21:26, Mikulas Patocka wrote:
> Introduce the "fix_hmac" arguent. It improves security of journal_mac:
> - the section number is mixed to the mac, so that an attacker can't
>   copy sectors from one journal section to another journal section
> - the superblock is protected by journal_mac
> - mix a 16-byte salt to the mac, so that it can't be detected that two
>   volumes have the same hmac key - and also to disallow the attacker to
>   move sectors from one disk to another
> 
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> Reported-by: Daniel Glockner <dg@emlix.com>

Hi Mike,

not that I like these fixes (I never expected standalone dm-integrity to be used with HMAC;
we have stacked AEAD modes in dmcrypt for cryptographically strong protection) but while it
is there, let's make it at least usable...

I addded support for these flags to integritysetup userspace, currently in merge request
https://gitlab.com/cryptsetup/cryptsetup/-/merge_requests/128
(stable minor version will be released with these changes soon).

Tested with Linus' mainline kernel + this v5 patch (most of changes below were based
on our discussion with Mikulas anyway).

If you want, add
Tested-by: Milan Broz <gmazyland@gmail.com>

Thanks,
m.


> 
> ---
>  Documentation/admin-guide/device-mapper/dm-integrity.rst |   12 +
>  drivers/md/dm-integrity.c                                |  104 +++++++++++++--
>  2 files changed, 105 insertions(+), 11 deletions(-)
> 
> Index: linux-2.6/drivers/md/dm-integrity.c
> ===================================================================
> --- linux-2.6.orig/drivers/md/dm-integrity.c
> +++ linux-2.6/drivers/md/dm-integrity.c
> @@ -40,6 +40,7 @@
>  #define BITMAP_BLOCK_SIZE		4096	/* don't change it */
>  #define BITMAP_FLUSH_INTERVAL		(10 * HZ)
>  #define DISCARD_FILLER			0xf6
> +#define SALT_SIZE			16
>  
>  /*
>   * Warning - DEBUG_PRINT prints security-sensitive data to the log,
> @@ -57,6 +58,7 @@
>  #define SB_VERSION_2			2
>  #define SB_VERSION_3			3
>  #define SB_VERSION_4			4
> +#define SB_VERSION_5			5
>  #define SB_SECTORS			8
>  #define MAX_SECTORS_PER_BLOCK		8
>  
> @@ -72,12 +74,15 @@ struct superblock {
>  	__u8 log2_blocks_per_bitmap_bit;
>  	__u8 pad[2];
>  	__u64 recalc_sector;
> +	__u8 pad2[8];
> +	__u8 salt[SALT_SIZE];
>  };
>  
>  #define SB_FLAG_HAVE_JOURNAL_MAC	0x1
>  #define SB_FLAG_RECALCULATING		0x2
>  #define SB_FLAG_DIRTY_BITMAP		0x4
>  #define SB_FLAG_FIXED_PADDING		0x8
> +#define SB_FLAG_FIXED_HMAC		0x10
>  
>  #define	JOURNAL_ENTRY_ROUNDUP		8
>  
> @@ -259,6 +264,7 @@ struct dm_integrity_c {
>  	bool recalculate_flag;
>  	bool discard;
>  	bool fix_padding;
> +	bool fix_hmac;
>  	bool legacy_recalculate;
>  
>  	struct alg_spec internal_hash_alg;
> @@ -389,8 +395,11 @@ static int dm_integrity_failed(struct dm
>  
>  static bool dm_integrity_disable_recalculate(struct dm_integrity_c *ic)
>  {
> -	if ((ic->internal_hash_alg.key || ic->journal_mac_alg.key) &&
> -	    !ic->legacy_recalculate)
> +	if (ic->legacy_recalculate)
> +		return false;
> +	if (!(ic->sb->flags & cpu_to_le32(SB_FLAG_FIXED_HMAC)) ?
> +	    ic->internal_hash_alg.key || ic->journal_mac_alg.key :
> +	    ic->internal_hash_alg.key && !ic->journal_mac_alg.key)
>  		return true;
>  	return false;
>  }
> @@ -477,7 +486,9 @@ static void wraparound_section(struct dm
>  
>  static void sb_set_version(struct dm_integrity_c *ic)
>  {
> -	if (ic->sb->flags & cpu_to_le32(SB_FLAG_FIXED_PADDING))
> +	if (ic->sb->flags & cpu_to_le32(SB_FLAG_FIXED_HMAC))
> +		ic->sb->version = SB_VERSION_5;
> +	else if (ic->sb->flags & cpu_to_le32(SB_FLAG_FIXED_PADDING))
>  		ic->sb->version = SB_VERSION_4;
>  	else if (ic->mode == 'B' || ic->sb->flags & cpu_to_le32(SB_FLAG_DIRTY_BITMAP))
>  		ic->sb->version = SB_VERSION_3;
> @@ -487,10 +498,58 @@ static void sb_set_version(struct dm_int
>  		ic->sb->version = SB_VERSION_1;
>  }
>  
> +static int sb_mac(struct dm_integrity_c *ic, bool wr)
> +{
> +	SHASH_DESC_ON_STACK(desc, ic->journal_mac);
> +	int r;
> +	unsigned size = crypto_shash_digestsize(ic->journal_mac);
> +
> +	if (sizeof(struct superblock) + size > 1 << SECTOR_SHIFT) {
> +		dm_integrity_io_error(ic, "digest is too long", -EINVAL);
> +		return -EINVAL;
> +	}
> +
> +	desc->tfm = ic->journal_mac;
> +
> +	r = crypto_shash_init(desc);
> +	if (unlikely(r < 0)) {
> +		dm_integrity_io_error(ic, "crypto_shash_init", r);
> +		return r;
> +	}
> +
> +	r = crypto_shash_update(desc, (__u8 *)ic->sb, (1 << SECTOR_SHIFT) - size);
> +	if (unlikely(r < 0)) {
> +		dm_integrity_io_error(ic, "crypto_shash_update", r);
> +		return r;
> +	}
> +
> +	if (likely(wr)) {
> +		r = crypto_shash_final(desc, (__u8 *)ic->sb + (1 << SECTOR_SHIFT) - size);
> +		if (unlikely(r < 0)) {
> +			dm_integrity_io_error(ic, "crypto_shash_final", r);
> +			return r;
> +		}
> +	} else {
> +		__u8 result[HASH_MAX_DIGESTSIZE];
> +		r = crypto_shash_final(desc, result);
> +		if (unlikely(r < 0)) {
> +			dm_integrity_io_error(ic, "crypto_shash_final", r);
> +			return r;
> +		}
> +		if (memcmp((__u8 *)ic->sb + (1 << SECTOR_SHIFT) - size, result, size)) {
> +			dm_integrity_io_error(ic, "superblock mac", -EILSEQ);
> +			return -EILSEQ;
> +		}
> +	}
> +
> +	return 0;
> +}
> +
>  static int sync_rw_sb(struct dm_integrity_c *ic, int op, int op_flags)
>  {
>  	struct dm_io_request io_req;
>  	struct dm_io_region io_loc;
> +	int r;
>  
>  	io_req.bi_op = op;
>  	io_req.bi_op_flags = op_flags;
> @@ -502,10 +561,28 @@ static int sync_rw_sb(struct dm_integrit
>  	io_loc.sector = ic->start;
>  	io_loc.count = SB_SECTORS;
>  
> -	if (op == REQ_OP_WRITE)
> +	if (op == REQ_OP_WRITE) {
>  		sb_set_version(ic);
> +		if (ic->journal_mac && ic->sb->flags & cpu_to_le32(SB_FLAG_FIXED_HMAC)) {
> +			r = sb_mac(ic, true);
> +			if (unlikely(r))
> +				return r;
> +		}
> +	}
>  
> -	return dm_io(&io_req, 1, &io_loc, NULL);
> +	r = dm_io(&io_req, 1, &io_loc, NULL);
> +	if (unlikely(r))
> +		return r;
> +
> +	if (op == REQ_OP_READ) {
> +		if (ic->mode != 'R' && ic->journal_mac && ic->sb->flags & cpu_to_le32(SB_FLAG_FIXED_HMAC)) {
> +			r = sb_mac(ic, false);
> +			if (unlikely(r))
> +				return r;
> +		}
> +	}
> +
> +	return 0;
>  }
>  
>  #define BITMAP_OP_TEST_ALL_SET		0
> @@ -722,15 +799,32 @@ static void section_mac(struct dm_integr
>  	desc->tfm = ic->journal_mac;
>  
>  	r = crypto_shash_init(desc);
> -	if (unlikely(r)) {
> +	if (unlikely(r < 0)) {
>  		dm_integrity_io_error(ic, "crypto_shash_init", r);
>  		goto err;
>  	}
>  
> +	if (ic->sb->flags & cpu_to_le32(SB_FLAG_FIXED_HMAC)) {
> +		uint64_t section_le;
> +
> +		r = crypto_shash_update(desc, (__u8 *)&ic->sb->salt, SALT_SIZE);
> +		if (unlikely(r < 0)) {
> +			dm_integrity_io_error(ic, "crypto_shash_update", r);
> +			goto err;
> +		}
> +
> +		section_le = cpu_to_le64(section);
> +		r = crypto_shash_update(desc, (__u8 *)&section_le, sizeof section_le);
> +		if (unlikely(r < 0)) {
> +			dm_integrity_io_error(ic, "crypto_shash_update", r);
> +			goto err;
> +		}
> +	}
> +
>  	for (j = 0; j < ic->journal_section_entries; j++) {
>  		struct journal_entry *je = access_journal_entry(ic, section, j);
>  		r = crypto_shash_update(desc, (__u8 *)&je->u.sector, sizeof je->u.sector);
> -		if (unlikely(r)) {
> +		if (unlikely(r < 0)) {
>  			dm_integrity_io_error(ic, "crypto_shash_update", r);
>  			goto err;
>  		}
> @@ -740,7 +834,7 @@ static void section_mac(struct dm_integr
>  
>  	if (likely(size <= JOURNAL_MAC_SIZE)) {
>  		r = crypto_shash_final(desc, result);
> -		if (unlikely(r)) {
> +		if (unlikely(r < 0)) {
>  			dm_integrity_io_error(ic, "crypto_shash_final", r);
>  			goto err;
>  		}
> @@ -753,7 +847,7 @@ static void section_mac(struct dm_integr
>  			goto err;
>  		}
>  		r = crypto_shash_final(desc, digest);
> -		if (unlikely(r)) {
> +		if (unlikely(r < 0)) {
>  			dm_integrity_io_error(ic, "crypto_shash_final", r);
>  			goto err;
>  		}
> @@ -1556,6 +1650,14 @@ static void integrity_sector_checksum(st
>  		goto failed;
>  	}
>  
> +	if (ic->sb->flags & cpu_to_le32(SB_FLAG_FIXED_HMAC)) {
> +		r = crypto_shash_update(req, (__u8 *)&ic->sb->salt, SALT_SIZE);
> +		if (unlikely(r < 0)) {
> +			dm_integrity_io_error(ic, "crypto_shash_update", r);
> +			goto failed;
> +		}
> +	}
> +
>  	r = crypto_shash_update(req, (const __u8 *)&sector_le, sizeof sector_le);
>  	if (unlikely(r < 0)) {
>  		dm_integrity_io_error(ic, "crypto_shash_update", r);
> @@ -3149,6 +3251,7 @@ static void dm_integrity_status(struct d
>  		arg_count += !!ic->journal_crypt_alg.alg_string;
>  		arg_count += !!ic->journal_mac_alg.alg_string;
>  		arg_count += (ic->sb->flags & cpu_to_le32(SB_FLAG_FIXED_PADDING)) != 0;
> +		arg_count += (ic->sb->flags & cpu_to_le32(SB_FLAG_FIXED_HMAC)) != 0;
>  		arg_count += ic->legacy_recalculate;
>  		DMEMIT("%s %llu %u %c %u", ic->dev->name, ic->start,
>  		       ic->tag_size, ic->mode, arg_count);
> @@ -3173,6 +3276,8 @@ static void dm_integrity_status(struct d
>  		}
>  		if ((ic->sb->flags & cpu_to_le32(SB_FLAG_FIXED_PADDING)) != 0)
>  			DMEMIT(" fix_padding");
> +		if ((ic->sb->flags & cpu_to_le32(SB_FLAG_FIXED_HMAC)) != 0)
> +			DMEMIT(" fix_hmac");
>  		if (ic->legacy_recalculate)
>  			DMEMIT(" legacy_recalculate");
>  
> @@ -3310,6 +3415,11 @@ static int initialize_superblock(struct
>  	if (!journal_sections)
>  		journal_sections = 1;
>  
> +	if (ic->fix_hmac && (ic->internal_hash_alg.alg_string || ic->journal_mac_alg.alg_string)) {
> +		ic->sb->flags |= cpu_to_le32(SB_FLAG_FIXED_HMAC);
> +		get_random_bytes(ic->sb->salt, SALT_SIZE);
> +	}
> +
>  	if (!ic->meta_dev) {
>  		if (ic->fix_padding)
>  			ic->sb->flags |= cpu_to_le32(SB_FLAG_FIXED_PADDING);
> @@ -3804,7 +3914,7 @@ static int dm_integrity_ctr(struct dm_ta
>  	unsigned extra_args;
>  	struct dm_arg_set as;
>  	static const struct dm_arg _args[] = {
> -		{0, 16, "Invalid number of feature args"},
> +		{0, 17, "Invalid number of feature args"},
>  	};
>  	unsigned journal_sectors, interleave_sectors, buffer_sectors, journal_watermark, sync_msec;
>  	bool should_write_sb;
> @@ -3942,7 +4052,7 @@ static int dm_integrity_ctr(struct dm_ta
>  			if (r)
>  				goto bad;
>  		} else if (!strncmp(opt_string, "journal_mac:", strlen("journal_mac:"))) {
> -			r = get_alg_and_key(opt_string, &ic->journal_mac_alg,  &ti->error,
> +			r = get_alg_and_key(opt_string, &ic->journal_mac_alg, &ti->error,
>  					    "Invalid journal_mac argument");
>  			if (r)
>  				goto bad;
> @@ -3952,6 +4062,8 @@ static int dm_integrity_ctr(struct dm_ta
>  			ic->discard = true;
>  		} else if (!strcmp(opt_string, "fix_padding")) {
>  			ic->fix_padding = true;
> +		} else if (!strcmp(opt_string, "fix_hmac")) {
> +			ic->fix_hmac = true;
>  		} else if (!strcmp(opt_string, "legacy_recalculate")) {
>  			ic->legacy_recalculate = true;
>  		} else {
> @@ -4110,7 +4222,7 @@ static int dm_integrity_ctr(struct dm_ta
>  			should_write_sb = true;
>  	}
>  
> -	if (!ic->sb->version || ic->sb->version > SB_VERSION_4) {
> +	if (!ic->sb->version || ic->sb->version > SB_VERSION_5) {
>  		r = -EINVAL;
>  		ti->error = "Unknown version";
>  		goto bad;
> @@ -4442,7 +4554,7 @@ static void dm_integrity_dtr(struct dm_t
>  
>  static struct target_type integrity_target = {
>  	.name			= "integrity",
> -	.version		= {1, 6, 0},
> +	.version		= {1, 7, 0},
>  	.module			= THIS_MODULE,
>  	.features		= DM_TARGET_SINGLETON | DM_TARGET_INTEGRITY,
>  	.ctr			= dm_integrity_ctr,
> Index: linux-2.6/Documentation/admin-guide/device-mapper/dm-integrity.rst
> ===================================================================
> --- linux-2.6.orig/Documentation/admin-guide/device-mapper/dm-integrity.rst
> +++ linux-2.6/Documentation/admin-guide/device-mapper/dm-integrity.rst
> @@ -186,6 +186,16 @@ fix_padding
>  	space-efficient. If this option is not present, large padding is
>  	used - that is for compatibility with older kernels.
>  
> +fix_hmac
> +	Improve security of internal_hash and journal_mac:
> +	- the section number is mixed to the mac, so that an attacker can't
> +	  copy sectors from one journal section to another journal section
> +	- the superblock is protected by journal_mac
> +	- a 16-byte salt stored in the superblock is mixed to the mac, so
> +	  that the attaker can't detect that two disks have the same hmac
> +	  key and also to disallow the attacker to move sectors from one
> +	  disk to another
> +
>  legacy_recalculate
>  	Allow recalculating of volumes with HMAC keys. This is disabled by
>  	default for security reasons - an attacker could modify the volume,
> 

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

