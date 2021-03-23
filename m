Return-Path: <SRS0=HPtm=IV=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66328C433C1
	for <dm-devel@archiver.kernel.org>; Tue, 23 Mar 2021 15:51:04 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id A9E82619B7
	for <dm-devel@archiver.kernel.org>; Tue, 23 Mar 2021 15:51:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A9E82619B7
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-391-IETMPJBSM76M5sD2YMhFeQ-1; Tue, 23 Mar 2021 11:51:00 -0400
X-MC-Unique: IETMPJBSM76M5sD2YMhFeQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EB82D800D53;
	Tue, 23 Mar 2021 15:50:54 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 9F62960BE5;
	Tue, 23 Mar 2021 15:50:54 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id CA8851809C83;
	Tue, 23 Mar 2021 15:50:53 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 12NFopH1018803 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 23 Mar 2021 11:50:51 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 9538A1012C75; Tue, 23 Mar 2021 15:50:51 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 9127D100F4DA
	for <dm-devel@redhat.com>; Tue, 23 Mar 2021 15:50:49 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3B32285A5A8
	for <dm-devel@redhat.com>; Tue, 23 Mar 2021 15:50:49 +0000 (UTC)
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com
	[209.85.128.41]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-273-60l3lhlZN1WPAIaqJITulg-1; Tue, 23 Mar 2021 11:50:44 -0400
X-MC-Unique: 60l3lhlZN1WPAIaqJITulg-1
Received: by mail-wm1-f41.google.com with SMTP id
	r10-20020a05600c35cab029010c946c95easo11113740wmq.4; 
	Tue, 23 Mar 2021 08:50:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:subject:to:cc:references:from:message-id:date
	:user-agent:mime-version:in-reply-to:content-language
	:content-transfer-encoding;
	bh=ZFq/YPAZRlOAaNjfZWBnXYt9thAFBl7TTZHX8P/6fsw=;
	b=ojDwW+YVhA6pliB/+WSuTH76jW9OeCG39Jaod9vCwBe5fMfMbyqGVCROJTqsdstDHM
	6KmQFr6KBFQYR499z4qQ9FKIYzvvbTxDcB7FmsKCm5rBAbwghjzZ/UTmF5yEGukTFFdH
	KOYZElIL2OOWLyMWJ60wAZRbgnL1VJjSRnXmROf73u/J2a4I8VO09r59yuQuGt5zojsg
	Mz9+dyPpZxQNFG5fwmURxplLWl7R+O0PB/HKHp//5UJhgyH4NBOnJBxl0Y9i4z5diY82
	QRY3c64bBFhHCqkQ9urgxm1oGtyDK4t36Oc9sSojntMHKbiboJmgs+9J8gcvkeue9X+J
	qXnA==
X-Gm-Message-State: AOAM5312JaINPBNoBkEDAgkqNB7jBFzkNXy5qJ17baKgtriUMLfPjfMx
	nAGOkldykqecISasWS3/X+IHf+U/AqY=
X-Google-Smtp-Source: ABdhPJyicvHrUl0LpuS2S3fbaxnMLX3DgDT23tLK8mHDgp1OI6QysLxyr6gVObBBB5IUIA7LPJwsrQ==
X-Received: by 2002:a1c:f406:: with SMTP id z6mr4075432wma.24.1616514643442;
	Tue, 23 Mar 2021 08:50:43 -0700 (PDT)
Received: from [192.168.2.27] (39.35.broadband4.iol.cz. [85.71.35.39])
	by smtp.gmail.com with ESMTPSA id
	v18sm25165696wrf.41.2021.03.23.08.50.42
	(version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
	Tue, 23 Mar 2021 08:50:42 -0700 (PDT)
To: Mike Snitzer <snitzer@redhat.com>, Mikulas Patocka <mpatocka@redhat.com>
References: <alpine.LRH.2.02.2103231058220.2542@file01.intranet.prod.int.rdu2.redhat.com>
	<20210323151238.GA4898@redhat.com>
From: Milan Broz <gmazyland@gmail.com>
Message-ID: <9bad9e38-033a-24b8-5f21-83d6161e583b@gmail.com>
Date: Tue, 23 Mar 2021 16:50:41 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
	Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210323151238.GA4898@redhat.com>
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
Cc: dm-devel@redhat.com
Subject: Re: [dm-devel] dm-integrity - add the "reset_recalculate" flag
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 23/03/2021 16:12, Mike Snitzer wrote:
> On Tue, Mar 23 2021 at 10:59am -0400,
> Mikulas Patocka <mpatocka@redhat.com> wrote:
> 
>> This patch adds a new flag "reset_recalculate" that will restart
>> recalculating from the beginning of the device. It can be used if we want
>> to change the hash function. Example:
>>
>> #!/bin/sh
>> dmsetup remove_all
>> rmmod brd
>> set -e
>> modprobe brd rd_size=1048576
>> dmsetup create in --table '0 2000000 integrity /dev/ram0 0 16 J 2 internal_hash:sha256 recalculate'
>> sleep 10
>> dmsetup status
>> dmsetup remove in
>> dmsetup create in --table '0 2000000 integrity /dev/ram0 0 16 J 2 internal_hash:sha3-256 reset_recalculate'
>>
>> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
>>
>> Index: linux-2.6/drivers/md/dm-integrity.c
>> ===================================================================
>> --- linux-2.6.orig/drivers/md/dm-integrity.c
>> +++ linux-2.6/drivers/md/dm-integrity.c
>> @@ -262,6 +262,7 @@ struct dm_integrity_c {
>>  	bool journal_uptodate;
>>  	bool just_formatted;
>>  	bool recalculate_flag;
>> +	bool reset_recalculate_flag;
>>  	bool discard;
>>  	bool fix_padding;
>>  	bool fix_hmac;
>> @@ -3134,7 +3135,8 @@ static void dm_integrity_resume(struct d
>>  		rw_journal_sectors(ic, REQ_OP_READ, 0, 0,
>>  				   ic->n_bitmap_blocks * (BITMAP_BLOCK_SIZE >> SECTOR_SHIFT), NULL);
>>  		if (ic->mode == 'B') {
>> -			if (ic->sb->log2_blocks_per_bitmap_bit == ic->log2_blocks_per_bitmap_bit) {
>> +			if (ic->sb->log2_blocks_per_bitmap_bit == ic->log2_blocks_per_bitmap_bit &&
>> +			    !ic->reset_recalculate_flag) {
>>  				block_bitmap_copy(ic, ic->recalc_bitmap, ic->journal);
>>  				block_bitmap_copy(ic, ic->may_write_bitmap, ic->journal);
>>  				if (!block_bitmap_op(ic, ic->journal, 0, ic->provided_data_sectors,
>> @@ -3156,7 +3158,8 @@ static void dm_integrity_resume(struct d
>>  			}
>>  		} else {
>>  			if (!(ic->sb->log2_blocks_per_bitmap_bit == ic->log2_blocks_per_bitmap_bit &&
>> -			      block_bitmap_op(ic, ic->journal, 0, ic->provided_data_sectors, BITMAP_OP_TEST_ALL_CLEAR))) {
>> +			      block_bitmap_op(ic, ic->journal, 0, ic->provided_data_sectors, BITMAP_OP_TEST_ALL_CLEAR)) ||
>> +			    ic->reset_recalculate_flag) {
>>  				ic->sb->flags |= cpu_to_le32(SB_FLAG_RECALCULATING);
>>  				ic->sb->recalc_sector = cpu_to_le64(0);
>>  			}
>> @@ -3169,6 +3172,10 @@ static void dm_integrity_resume(struct d
>>  			dm_integrity_io_error(ic, "writing superblock", r);
>>  	} else {
>>  		replay_journal(ic);
>> +		if (ic->reset_recalculate_flag) {
>> +			ic->sb->flags |= cpu_to_le32(SB_FLAG_RECALCULATING);
>> +			ic->sb->recalc_sector = cpu_to_le64(0);
>> +		}
>>  		if (ic->mode == 'B') {
>>  			ic->sb->flags |= cpu_to_le32(SB_FLAG_DIRTY_BITMAP);
>>  			ic->sb->log2_blocks_per_bitmap_bit = ic->log2_blocks_per_bitmap_bit;
>> @@ -3242,6 +3249,7 @@ static void dm_integrity_status(struct d
>>  		arg_count += !!ic->meta_dev;
>>  		arg_count += ic->sectors_per_block != 1;
>>  		arg_count += !!(ic->sb->flags & cpu_to_le32(SB_FLAG_RECALCULATING));
>> +		arg_count += ic->reset_recalculate_flag;
>>  		arg_count += ic->discard;
>>  		arg_count += ic->mode == 'J';
>>  		arg_count += ic->mode == 'J';
>> @@ -3261,6 +3269,8 @@ static void dm_integrity_status(struct d
>>  			DMEMIT(" block_size:%u", ic->sectors_per_block << SECTOR_SHIFT);
>>  		if (ic->sb->flags & cpu_to_le32(SB_FLAG_RECALCULATING))
>>  			DMEMIT(" recalculate");
>> +		if (ic->reset_recalculate_flag)
>> +			DMEMIT(" reset_recalculate");
>>  		if (ic->discard)
>>  			DMEMIT(" allow_discards");
>>  		DMEMIT(" journal_sectors:%u", ic->initial_sectors - SB_SECTORS);
>> @@ -4058,6 +4068,9 @@ static int dm_integrity_ctr(struct dm_ta
>>  				goto bad;
>>  		} else if (!strcmp(opt_string, "recalculate")) {
>>  			ic->recalculate_flag = true;
>> +		} else if (!strcmp(opt_string, "reset_recalculate")) {
>> +			ic->recalculate_flag = true;
>> +			ic->reset_recalculate_flag = true;
>>  		} else if (!strcmp(opt_string, "allow_discards")) {
>>  			ic->discard = true;
>>  		} else if (!strcmp(opt_string, "fix_padding")) {
> 
> Do you need to bump the number of feature args supported (from 17 to
> 18)?

And also update target minor version.

I was just under the impression that we decided not to support such a flag (because we cannot change tag size, so it is not usable in some situations).
But if it is so simple, why not.

For the reference, it was discovered in this report https://gitlab.com/cryptsetup/cryptsetup/-/issues/631

Milan

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

