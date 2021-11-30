Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8892CC433EF
	for <dm-devel@archiver.kernel.org>; Tue, 30 Nov 2021 18:55:44 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-290-1Mqn8lyMOW6QexkzQXCBFA-1; Tue, 30 Nov 2021 13:55:39 -0500
X-MC-Unique: 1Mqn8lyMOW6QexkzQXCBFA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DEF79801B01;
	Tue, 30 Nov 2021 18:55:34 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 76E495D6BA;
	Tue, 30 Nov 2021 18:55:34 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id E6A424BB7C;
	Tue, 30 Nov 2021 18:55:33 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
	[10.11.54.10])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1AUItUjX017094 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 30 Nov 2021 13:55:31 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id CEF27401E23; Tue, 30 Nov 2021 18:55:30 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id CB14F401E31
	for <dm-devel@redhat.com>; Tue, 30 Nov 2021 18:55:30 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B1B5C101AA73
	for <dm-devel@redhat.com>; Tue, 30 Nov 2021 18:55:30 +0000 (UTC)
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182]) by
	relay.mimecast.com with ESMTP id us-mta-365-hfVXaelTPPSWtnMbksJ5qQ-1;
	Tue, 30 Nov 2021 13:55:27 -0500
X-MC-Unique: hfVXaelTPPSWtnMbksJ5qQ-1
Received: from [10.137.106.139] (unknown [131.107.159.11])
	by linux.microsoft.com (Postfix) with ESMTPSA id 7526020DEE27;
	Tue, 30 Nov 2021 10:55:20 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 7526020DEE27
Message-ID: <81d5e825-1ee2-8f6b-cd9d-07b0f8bd36d3@linux.microsoft.com>
Date: Tue, 30 Nov 2021 10:55:20 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
	Thunderbird/91.3.2
To: Roberto Sassu <roberto.sassu@huawei.com>, "corbet@lwn.net"
	<corbet@lwn.net>,
	"axboe@kernel.dk" <axboe@kernel.dk>, "agk@redhat.com" <agk@redhat.com>, 
	"snitzer@redhat.com" <snitzer@redhat.com>,
	"ebiggers@kernel.org" <ebiggers@kernel.org>,
	"tytso@mit.edu" <tytso@mit.edu>, "paul@paul-moore.com"
	<paul@paul-moore.com>, "eparis@redhat.com" <eparis@redhat.com>,
	"jmorris@namei.org" <jmorris@namei.org>, "serge@hallyn.com"
	<serge@hallyn.com>
References: <1634151995-16266-1-git-send-email-deven.desai@linux.microsoft.com>
	<1634151995-16266-12-git-send-email-deven.desai@linux.microsoft.com>
	<721462c3da064d359ca3c83845298ccf@huawei.com>
From: Deven Bowers <deven.desai@linux.microsoft.com>
In-Reply-To: <721462c3da064d359ca3c83845298ccf@huawei.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
X-loop: dm-devel@redhat.com
Cc: "linux-security-module@vger.kernel.org"
	<linux-security-module@vger.kernel.org>,
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
	"jannh@google.com" <jannh@google.com>,
	"linux-fscrypt@vger.kernel.org" <linux-fscrypt@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>,
	"linux-audit@redhat.com" <linux-audit@redhat.com>,
	"tusharsu@linux.microsoft.com" <tusharsu@linux.microsoft.com>,
	"linux-integrity@vger.kernel.org" <linux-integrity@vger.kernel.org>
Subject: Re: [dm-devel] [RFC PATCH v7 11/16] ipe: add support for dm-verity
 as a trust provider
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
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"


On 11/25/2021 1:37 AM, Roberto Sassu wrote:
>> From: deven.desai@linux.microsoft.com
>> [mailto:deven.desai@linux.microsoft.com]
>> Sent: Wednesday, October 13, 2021 9:07 PM
>> From: Deven Bowers <deven.desai@linux.microsoft.com>

..snip

>> diff --git a/security/ipe/modules/Makefile b/security/ipe/modules/Makefile
>> index e0045ec65434..84fadce85193 100644
>> --- a/security/ipe/modules/Makefile
>> +++ b/security/ipe/modules/Makefile
>> @@ -6,3 +6,5 @@
>>   #
>>
>>   obj-$(CONFIG_IPE_PROP_BOOT_VERIFIED) += boot_verified.o
>> +obj-$(CONFIG_IPE_PROP_DM_VERITY_SIGNATURE) += dmverity_signature.o
>> +obj-$(CONFIG_IPE_PROP_DM_VERITY_ROOTHASH) += dmverity_roothash.o
>> diff --git a/security/ipe/modules/dmverity_roothash.c
>> b/security/ipe/modules/dmverity_roothash.c
>> new file mode 100644
>> index 000000000000..0f82bec3b842
>> --- /dev/null
>> +++ b/security/ipe/modules/dmverity_roothash.c
>> @@ -0,0 +1,80 @@
>> +// SPDX-License-Identifier: GPL-2.0
>> +/*
>> + * Copyright (C) Microsoft Corporation. All rights reserved.
>> + */
>> +
>> +#include "ipe_module.h"
>> +
>> +#include <linux/fs.h>
>> +#include <linux/types.h>
>> +
>> +struct counted_array {
>> +	size_t	len;
>> +	u8     *data;
>> +};
>> +
>> +static int dvrh_parse(const char *valstr, void **value)
>> +{
>> +	int rv = 0;
>> +	struct counted_array *arr;
>> +
>> +	arr = kzalloc(sizeof(*arr), GFP_KERNEL);
>> +	if (!arr) {
>> +		rv = -ENOMEM;
>> +		goto err;
>> +	}
>> +
>> +	arr->len = (strlen(valstr) / 2);
>> +
>> +	arr->data = kzalloc(arr->len, GFP_KERNEL);
>> +	if (!arr->data) {
>> +		rv = -ENOMEM;
>> +		goto err;
>> +	}
>> +
>> +	rv = hex2bin(arr->data, valstr, arr->len);
>> +	if (rv != 0)
>> +		goto err2;
>> +
>> +	*value = arr;
>> +	return rv;
>> +err2:
>> +	kfree(arr->data);
>> +err:
>> +	kfree(arr);
>> +	return rv;
>> +}
>> +
>> +static bool dvrh_eval(const struct ipe_eval_ctx *ctx, const void *val)
>> +{
>> +	const u8 *src;
>> +	struct counted_array *expect = (struct counted_array *)val;
>> +
>> +	if (!ctx->ipe_bdev)
>> +		return false;
>> +
>> +	if (ctx->ipe_bdev->hashlen != expect->len)
>> +		return false;
>> +
>> +	src = ctx->ipe_bdev->hash;
>> +
>> +	return !memcmp(expect->data, src, expect->len);
> Hi Deven
>
> I was curious to see if determining the property at run-time
> could apply also to dm-verity. It seems it could be done
> (I omit some checks, I also keep the expected value in hex
> format):
>
> ---
>          md = dm_get_md(file_inode(ctx->file)->i_sb->s_dev);
>          table = dm_get_live_table(md, &srcu_idx);
>          num_targets = dm_table_get_num_targets(table);
>
>          for (i = 0; i < num_targets; i++) {
>                  struct dm_target *ti = dm_table_get_target(table, i);
>
>                  if (strcmp(ti->type->name, "verity"))
>                          continue;
>
>                  ti->type->status(ti, STATUSTYPE_IMA, 0, result, sizeof(result));
>          }
>
>          dm_put_live_table(md, srcu_idx);
>          dm_put(md);
>
>          root_digest_ptr = strstr(result, "root_digest=");
>          return !strncmp(expect->data, root_digest_ptr + 12, expect->len);
> ---
>
> Only dm_table_get_target() is not exported yet, but I guess it could
> be. dm_table_get_num_targets() is exported.

I had tried something similar in a very early draft of IPE. The issue
that comes with this is that when you compile device-mapper as a module
(CONFIG_BLK_DEV_DM=m) you start to get linking errors with this
approach.

Obviously, we can fix this in the IPE's module Kconfig by setting the
dependency to be =y, but it's something to highlight. My general
preference is to support the =m configuration by using these blobs.

The runtime approach does work with fs-verity, because fs-verity is a
file-system level feature that cannot be compiled as a module.

> With this code, you would not have to manage security blobs
> outside IPE. Maybe you could add a blob for the super block, so
> that you verify the dm-verity property just once per filesystem.
>
> Roberto
>
> HUAWEI TECHNOLOGIES Duesseldorf GmbH, HRB 56063
> Managing Director: Li Peng, Zhong Ronghua
>
>> +}
>> +
>> +static int dvrh_free(void **val)
>> +{
>> +	struct counted_array *expect = (struct counted_array *)val;
>> +
>> +	kfree(expect->data);
>> +	kfree(expect);
>> +
>> +	return 0;
>> +}
>> +
>> +IPE_MODULE(dvrh) = {
>> +	.name = "dmverity_roothash",
>> +	.version = 1,
>> +	.parse = dvrh_parse,
>> +	.free = dvrh_free,
>> +	.eval = dvrh_eval,
>> +};
>> diff --git a/security/ipe/modules/dmverity_signature.c
>> b/security/ipe/modules/dmverity_signature.c
>> new file mode 100644
>> index 000000000000..08746fcbcb3e
>> --- /dev/null
>> +++ b/security/ipe/modules/dmverity_signature.c
>> @@ -0,0 +1,25 @@
>> +// SPDX-License-Identifier: GPL-2.0
>> +/*
>> + * Copyright (C) Microsoft Corporation. All rights reserved.
>> + */
>> +
>> +#include "ipe_module.h"
>> +
>> +#include <linux/fs.h>
>> +#include <linux/types.h>
>> +
>> +static bool dvv_eval(const struct ipe_eval_ctx *ctx, const void *val)
>> +{
>> +	bool expect = (bool)val;
>> +	bool eval = ctx->ipe_bdev && (!!ctx->ipe_bdev->sigdata);
>> +
>> +	return expect == eval;
>> +}
>> +
>> +IPE_MODULE(dvv) = {
>> +	.name = "dmverity_signature",
>> +	.version = 1,
>> +	.parse = ipe_bool_parse,
>> +	.free = NULL,
>> +	.eval = dvv_eval,
>> +};
>> --
>> 2.33.0

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

