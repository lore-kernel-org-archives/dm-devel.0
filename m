Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5127DC433F5
	for <dm-devel@archiver.kernel.org>; Mon,  9 May 2022 07:53:35 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-554-LTem7YBjOaW9k8FGYmNCmw-1; Mon, 09 May 2022 03:53:31 -0400
X-MC-Unique: LTem7YBjOaW9k8FGYmNCmw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1EC921C161A7;
	Mon,  9 May 2022 07:53:29 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 0DCE4401012B;
	Mon,  9 May 2022 07:53:29 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id A8A7D1947076;
	Mon,  9 May 2022 07:53:26 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 1C09D1947056
 for <dm-devel@listman.corp.redhat.com>; Fri,  6 May 2022 20:35:27 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id E3EEF2166B17; Fri,  6 May 2022 20:35:26 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id E00622166B2D
 for <dm-devel@redhat.com>; Fri,  6 May 2022 20:35:14 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CDC95811E78
 for <dm-devel@redhat.com>; Fri,  6 May 2022 20:35:14 +0000 (UTC)
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182]) by
 relay.mimecast.com with ESMTP id us-mta-395-k86YAX4YOQS9_N7S5spTLQ-1; Fri,
 06 May 2022 16:35:09 -0400
X-MC-Unique: k86YAX4YOQS9_N7S5spTLQ-1
Received: from [10.137.112.111] (unknown [131.107.147.111])
 by linux.microsoft.com (Postfix) with ESMTPSA id 3DBDB20EB6CD;
 Fri,  6 May 2022 13:35:08 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 3DBDB20EB6CD
Message-ID: <b4c21ae2-3980-c7ca-7719-7477d0acaa72@linux.microsoft.com>
Date: Fri, 6 May 2022 13:35:07 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
To: Thore Sommer <public@thson.de>, dm-devel@redhat.com, agk@redhat.com,
 snitzer@redhat.com
References: <20220106203436.281629-1-public@thson.de>
 <20220106203436.281629-3-public@thson.de>
From: Lakshmi Ramasubramanian <nramas@linux.microsoft.com>
In-Reply-To: <20220106203436.281629-3-public@thson.de>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-Mailman-Approved-At: Mon, 09 May 2022 07:53:25 +0000
Subject: Re: [dm-devel] [RFC PATCH 2/3] dm verity: add support for IMA
 target update event
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
> On first corruption the verity targets triggers a dm_target_update event.
> This allows other systems to check using IMA if the state of the device is
> still trustworthy via remote attestation.
In the patch description please state the existing problem (or, 
limitation in the existing implementation) and then describe how the 
proposed change addresses the issue.

> 
> Signed-off-by: Thore Sommer <public@thson.de>
> ---
>   drivers/md/dm-verity-target.c | 6 ++++++
>   1 file changed, 6 insertions(+)
> 
> diff --git a/drivers/md/dm-verity-target.c b/drivers/md/dm-verity-target.c
> index 80133aae0db3..09696e25bf1c 100644
> --- a/drivers/md/dm-verity-target.c
> +++ b/drivers/md/dm-verity-target.c
> @@ -16,6 +16,7 @@
>   #include "dm-verity.h"
>   #include "dm-verity-fec.h"
>   #include "dm-verity-verify-sig.h"
> +#include "dm-ima.h"
>   #include <linux/module.h>
>   #include <linux/reboot.h>
>   #include <linux/scatterlist.h>
> @@ -218,10 +219,15 @@ static int verity_handle_err(struct dm_verity *v, enum verity_block_type type,
>   	char *envp[] = { verity_env, NULL };
>   	const char *type_str = "";
>   	struct mapped_device *md = dm_table_get_md(v->ti->table);
> +	int old_hash_failed = v->hash_failed;
>   
>   	/* Corruption should be visible in device status in all modes */
>   	v->hash_failed = 1;
>   
> +	/* Only remeasure on first failure */
> +	if (!old_hash_failed)
> +		dm_ima_measure_on_target_update(v->ti);
It is not obvious to me why the call to measure on target update is not 
done here immediately. Updating the comment to explain the logic would help.

thanks,
  -lakshmi

> +
>   	if (v->corrupted_errs >= DM_VERITY_MAX_CORRUPTED_ERRS)
>   		goto out;
>   

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

