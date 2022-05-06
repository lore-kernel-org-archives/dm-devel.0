Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 04307C433EF
	for <dm-devel@archiver.kernel.org>; Mon,  9 May 2022 07:53:33 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-462-x4ka_1oZPiCbk1U3Gik6mg-1; Mon, 09 May 2022 03:53:31 -0400
X-MC-Unique: x4ka_1oZPiCbk1U3Gik6mg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A55A686B8AF;
	Mon,  9 May 2022 07:53:29 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 9138640CF8EC;
	Mon,  9 May 2022 07:53:29 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 5D9A71947054;
	Mon,  9 May 2022 07:53:28 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 61EB41947056
 for <dm-devel@listman.corp.redhat.com>; Fri,  6 May 2022 20:26:02 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id EBFABC27E8E; Fri,  6 May 2022 20:26:01 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id E6E71C15D4F
 for <dm-devel@redhat.com>; Fri,  6 May 2022 20:26:01 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CE85C8015BA
 for <dm-devel@redhat.com>; Fri,  6 May 2022 20:26:00 +0000 (UTC)
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182]) by
 relay.mimecast.com with ESMTP id us-mta-618-Xk4G1g45N2ifR1II2w9lcw-1; Fri,
 06 May 2022 16:25:59 -0400
X-MC-Unique: Xk4G1g45N2ifR1II2w9lcw-1
Received: from [10.137.112.111] (unknown [131.107.147.111])
 by linux.microsoft.com (Postfix) with ESMTPSA id 0954820EB6C2;
 Fri,  6 May 2022 13:25:58 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 0954820EB6C2
Message-ID: <796b7d69-6000-d4bf-d29b-f1fdfec6e332@linux.microsoft.com>
Date: Fri, 6 May 2022 13:25:57 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
To: Thore Sommer <public@thson.de>, dm-devel@redhat.com, agk@redhat.com,
 snitzer@redhat.com
References: <20220106203436.281629-1-public@thson.de>
 <20220106203436.281629-2-public@thson.de>
From: Lakshmi Ramasubramanian <nramas@linux.microsoft.com>
In-Reply-To: <20220106203436.281629-2-public@thson.de>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
X-Mailman-Approved-At: Mon, 09 May 2022 07:53:25 +0000
Subject: Re: [dm-devel] [RFC PATCH 1/3] dm ima: allow targets to remeasure
 their table entry
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/dm-devel/>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=subscribe>
Cc: tusharsu@linux.microsoft.com, linux-integrity@vger.kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

Hi Thore,

On 1/6/2022 12:34 PM, Thore Sommer wrote:
> A new DM event dm_target_update is introduced for targets to remeasure
> their table entry. This is intended for targets that indicate security
> relevant events by updating one of their table entries (e.g. verity for
> corruption).
In the patch description please state the existing problem (or, 
limitation in the existing implementation) and then describe how the 
proposed change addresses the issue.

> 
> In the event the dm version, device metadata and target data gets
> measured.
> 
> This does not update the hash of the active table because it would require
> to rehash the whole table with all the other targets entries.
> 
> Signed-off-by: Thore Sommer <public@thson.de>
> ---
>   drivers/md/dm-ima.c | 76 +++++++++++++++++++++++++++++++++++++++++++++
>   drivers/md/dm-ima.h |  2 ++
>   2 files changed, 78 insertions(+)
> 
> diff --git a/drivers/md/dm-ima.c b/drivers/md/dm-ima.c
> index 957999998d70..3b1bb97263d9 100644
> --- a/drivers/md/dm-ima.c
> +++ b/drivers/md/dm-ima.c
> @@ -750,3 +750,79 @@ void dm_ima_measure_on_device_rename(struct mapped_device *md)
>   	kfree(new_dev_name);
>   	kfree(new_dev_uuid);
>   }
> +
> +/*
> + * Give the option for targets to remeasure on state change.
> + */
> +void dm_ima_measure_on_target_update(struct dm_target *ti)
> +{
> +	char *ima_buf = NULL, *target_metadata_buf = NULL, *target_data_buf = NULL;
> +	struct dm_target *ti2;
> +	size_t target_metadata_buf_len, target_data_buf_len;
> +	unsigned int num_targets, target_index;
> +	struct dm_table *table = ti->table;
> +	struct mapped_device *md = table->md;
> +	bool found = false;
> +	bool noio = true;
> +	int l = 0;
> +
Initializing "ima_buf" to NULL is not necessary since the statement 
below initializes it.

> +	ima_buf = dm_ima_alloc(DM_IMA_MEASUREMENT_BUF_LEN, GFP_KERNEL, noio);
> +	if (!ima_buf)
> +		return;
> +
> +	target_metadata_buf = dm_ima_alloc(DM_IMA_TARGET_METADATA_BUF_LEN, GFP_KERNEL, noio);
> +	if (!target_metadata_buf)
> +		goto exit;
> +
> +	target_data_buf = dm_ima_alloc(DM_IMA_TARGET_DATA_BUF_LEN, GFP_KERNEL, noio);
> +	if (!target_data_buf)
> +		goto exit;
> +
> +	/*
> +	 * Get the index of the target in the table.
> +	 */
> +	num_targets = dm_table_get_num_targets(table);
> +	for (target_index = 0; target_index < num_targets; target_index++) {
> +		ti2 = dm_table_get_target(table, target_index);
> +		if (!ti)
> +			goto exit;
This check for "ti" can be done on function entry to avoid memory 
allocations and calls to dm_table_get_num_targets(), 
dm_table_get_target() when "ti" is NULL.

> +		if (ti == ti2) {
> +			found = true;
> +			break;
> +		}
> +	}
> +	if (!found)
> +		goto exit;
> +
> +	scnprintf(target_metadata_buf, DM_IMA_TARGET_METADATA_BUF_LEN,
> +			  "target_index=%d,target_begin=%llu,target_len=%llu,",
> +			  target_index, ti->begin, ti->len);
Check return status of "scnprintf()" and handle any error.

thanks,
  -lakshmi

> +	target_metadata_buf_len = strlen(target_metadata_buf);
> +
> +	if (ti->type->status)
> +		ti->type->status(ti, STATUSTYPE_IMA, STATUSTYPE_IMA, target_data_buf,
> +					DM_IMA_TARGET_DATA_BUF_LEN);
> +	else
> +		target_data_buf[0] = '\0';
> +	target_data_buf_len = strlen(target_data_buf);
> +
> +	memcpy(ima_buf + l, DM_IMA_VERSION_STR, md->ima.dm_version_str_len);
> +	l += md->ima.dm_version_str_len;
> +
> +	memcpy(ima_buf + l, md->ima.active_table.device_metadata,
> +	       md->ima.active_table.device_metadata_len);
> +	l += md->ima.active_table.device_metadata_len;
> +
> +	memcpy(ima_buf + l, target_metadata_buf, target_metadata_buf_len);
> +	l += target_metadata_buf_len;
> +
> +	memcpy(ima_buf + l, target_data_buf, target_data_buf_len);
> +
> +	dm_ima_measure_data("dm_target_update", ima_buf, strlen(ima_buf), noio);
> +
> +exit:
> +	kfree(ima_buf);
> +	kfree(target_data_buf);
> +	kfree(target_metadata_buf);
> +}
> +EXPORT_SYMBOL_GPL(dm_ima_measure_on_target_update);
> diff --git a/drivers/md/dm-ima.h b/drivers/md/dm-ima.h
> index b8c3b614670b..281a8b65f8a9 100644
> --- a/drivers/md/dm-ima.h
> +++ b/drivers/md/dm-ima.h
> @@ -63,6 +63,7 @@ void dm_ima_measure_on_device_resume(struct mapped_device *md, bool swap);
>   void dm_ima_measure_on_device_remove(struct mapped_device *md, bool remove_all);
>   void dm_ima_measure_on_table_clear(struct mapped_device *md, bool new_map);
>   void dm_ima_measure_on_device_rename(struct mapped_device *md);
> +void dm_ima_measure_on_target_update(struct dm_target *ti);
>   
>   #else
>   
> @@ -72,6 +73,7 @@ static inline void dm_ima_measure_on_device_resume(struct mapped_device *md, boo
>   static inline void dm_ima_measure_on_device_remove(struct mapped_device *md, bool remove_all) {}
>   static inline void dm_ima_measure_on_table_clear(struct mapped_device *md, bool new_map) {}
>   static inline void dm_ima_measure_on_device_rename(struct mapped_device *md) {}
> +static inline void dm_ima_measure_on_target_update(struct dm_target *ti) {}
>   
>   #endif /* CONFIG_IMA */
>   

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

