Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.145.221.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 46C67ECAAD3
	for <dm-devel@archiver.kernel.org>; Mon,  5 Sep 2022 16:13:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1662394430;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=9+QZy1mwgFaOgGXe6b18a0VMh/W2HokIO4j7VC7N8Vg=;
	b=hdKgY5wBbgKCBTonpr401QA6VF1AVTt9g8lbF7QBlP0pShPaECbw3YWoeqxe25nnW9agj0
	F4dsE1e0IZdpE8new7zMUIsDD1LbQj1OOXWlf+jldSNFLV4x974Esm6UcZ7sXAzB5kt4aM
	eqb1S+JaOMzqXBJ1z4Fw7/aqQAVDikA=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-2-lo9hL3gtPDqqSxbXECl21w-1; Mon, 05 Sep 2022 12:13:47 -0400
X-MC-Unique: lo9hL3gtPDqqSxbXECl21w-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4525329AB401;
	Mon,  5 Sep 2022 16:13:46 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id C135E1415137;
	Mon,  5 Sep 2022 16:13:45 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 9BBEA1946A48;
	Mon,  5 Sep 2022 16:13:45 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id B59151946A47
 for <dm-devel@listman.corp.redhat.com>; Mon,  5 Sep 2022 16:13:44 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 493F2492CA2; Mon,  5 Sep 2022 16:13:44 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 4565B492C3B
 for <dm-devel@redhat.com>; Mon,  5 Sep 2022 16:13:44 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2CB6A3C02196
 for <dm-devel@redhat.com>; Mon,  5 Sep 2022 16:13:44 +0000 (UTC)
Received: from box.fidei.email (box.fidei.email [71.19.144.250]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_128_GCM_SHA256) id us-mta-563-mfSUc4o-O5S0zgdZJ-J8oA-1; Mon,
 05 Sep 2022 12:13:42 -0400
X-MC-Unique: mfSUc4o-O5S0zgdZJ-J8oA-1
Received: from authenticated-user (box.fidei.email [71.19.144.250])
 (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits))
 (No client certificate requested)
 by box.fidei.email (Postfix) with ESMTPSA id 902E380100
 for <dm-devel@redhat.com>; Mon,  5 Sep 2022 12:05:36 -0400 (EDT)
Message-ID: <44941d34-385e-b874-2a96-d90550e08cd0@dorminy.me>
Date: Mon, 5 Sep 2022 12:05:34 -0400
MIME-Version: 1.0
To: dm-devel@redhat.com
References: <alpine.LRH.2.02.2209051121410.8614@file01.intranet.prod.int.rdu2.redhat.com>
From: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
In-Reply-To: <alpine.LRH.2.02.2209051121410.8614@file01.intranet.prod.int.rdu2.redhat.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
Subject: Re: [dm-devel] [PATCH 2/2] dm: make it possible to allocate error
 strings
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
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"



On 9/5/22 11:22, Mikulas Patocka wrote:
> Previously, ti->error and ti_error strings were pointing to statically
> allocated memory (the .rodata section) and it was not possible to add
> parameters to the error strings.
> 
> This patch makes possible to allocate error strings dynamically using the
> "kasprintf" function, so we can add arbitrary parameters to the strings.

I am so excited by this change.

> 
> We need to free the error string only if is allocated with kasprintf. So,
> we introduce a function "dm_free_error" that tests if the string points to
> the module area (and doesn't free the string if it does), then it calls
> kfree_const. kfree_const detects if the string points to the kernel
> .rodata section and frees the string if it is not in .rodata.
As I understand this change, if some new user used vmalloc to allocate a 
error string, DM would leak the memory. So I think the struct dm_target 
error member deserves documentation that it can be either constant or 
allocated via kmalloc, but not vmalloc.

All of these dynamic messages seem to add the target type. Might it be 
worth adding a helper macro to set a dynamic ti->error, like DMEMIT etc, 
which added a prefix of "target type %s:": and enforced that 
kasprintf(GFP_NOIO, ...) is used?

Thanks!

Sweet Tea

> 
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> 
> ---
>   drivers/md/dm-ioctl.c         |    8 +++++++-
>   drivers/md/dm-table.c         |   16 ++++++++++------
>   include/linux/device-mapper.h |    6 ++++++
>   3 files changed, 23 insertions(+), 7 deletions(-)
> 
> Index: linux-dm/drivers/md/dm-ioctl.c
> ===================================================================
> --- linux-dm.orig/drivers/md/dm-ioctl.c	2022-09-05 14:31:51.000000000 +0200
> +++ linux-dm/drivers/md/dm-ioctl.c	2022-09-05 14:31:51.000000000 +0200
> @@ -1465,7 +1465,8 @@ static int table_load(struct file *filp,
>   		DMERR("can't replace immutable target type %s",
>   		      immutable_target_type->name);
>   		r = -EINVAL;
> -		ti_error = "can't replace immutable target";
> +		ti_error = kasprintf(GFP_NOIO, "can't replace immutable target type %s",
> +			immutable_target_type->name);
>   		goto err_unlock_md_type;
>   	}
>   
> @@ -1521,11 +1522,16 @@ err_destroy_table:
>   err:
>   	dm_put(md);
>   err0:
> +	if (!ti_error)
> +		ti_error = "can't allocte error string";
>   	if (param->flags & DM_RETURN_ERROR_FLAG) {
>   		param->flags &= ~DM_RETURN_ERROR_FLAG;
>   		strlcpy(param->name, ti_error, sizeof param->name);
>   		param->error = r;
> +		dm_free_error(ti_error);
>   		return 0;
> +	} else {
> +		dm_free_error(ti_error);
>   	}
>   	return r;
>   }
> Index: linux-dm/drivers/md/dm-table.c
> ===================================================================
> --- linux-dm.orig/drivers/md/dm-table.c	2022-09-05 14:31:51.000000000 +0200
> +++ linux-dm/drivers/md/dm-table.c	2022-09-05 14:31:51.000000000 +0200
> @@ -656,32 +656,32 @@ int dm_table_add_target(struct dm_table
>   
>   	ti->type = dm_get_target_type(type);
>   	if (!ti->type) {
> -		ti->error = "unknown target type";
> +		ti->error = kasprintf(GFP_NOIO, "unknown target type %s", type);
>   		r = -EINVAL;
>   		goto bad0;
>   	}
>   
>   	if (dm_target_needs_singleton(ti->type)) {
>   		if (t->num_targets) {
> -			ti->error = "singleton target type must appear alone in table";
> +			ti->error = kasprintf(GFP_NOIO, "singleton target type %s must appear alone in table", type);
>   			goto bad1;
>   		}
>   		t->singleton = true;
>   	}
>   
>   	if (dm_target_always_writeable(ti->type) && !(t->mode & FMODE_WRITE)) {
> -		ti->error = "target type may not be included in a read-only table";
> +		ti->error = kasprintf(GFP_NOIO, "target type %s may not be included in a read-only table", type);
>   		goto bad1;
>   	}
>   
>   	if (t->immutable_target_type) {
>   		if (t->immutable_target_type != ti->type) {
> -			ti->error = "immutable target type cannot be mixed with other target types";
> +			ti->error = kasprintf(GFP_NOIO, "immutable target type %s cannot be mixed with other target types", type);
>   			goto bad1;
>   		}
>   	} else if (dm_target_is_immutable(ti->type)) {
>   		if (t->num_targets) {
> -			ti->error = "immutable target type cannot be mixed with other target types";
> +			ti->error = kasprintf(GFP_NOIO, "immutable target type %s cannot be mixed with other target types", type);
>   			goto bad1;
>   		}
>   		t->immutable_target_type = ti->type;
> @@ -705,7 +705,7 @@ int dm_table_add_target(struct dm_table
>   
>   	r = dm_split_args(&argc, &argv, params);
>   	if (r) {
> -		ti->error = "couldn't split parameters";
> +		ti->error = kasprintf(GFP_NOIO, "couldn't split parameters for target %s", type);
>   		goto bad1;
>   	}
>   
> @@ -728,9 +728,13 @@ int dm_table_add_target(struct dm_table
>   bad1:
>   	dm_put_target_type(ti->type);
>   bad0:
> +	if (!ti->error)
> +		ti->error = "can't allocte error string";

Typo: allocte->allocate.

>   	DMERR("%s: %s: %s (%pe)", dm_device_name(t->md), type, ti->error, ERR_PTR(r));
>   	if (ti_error)
>   		*ti_error = ti->error;
> +	else
> +		dm_free_error(ti->error);
>   	return r;
>   }
>   
> Index: linux-dm/include/linux/device-mapper.h
> ===================================================================
> --- linux-dm.orig/include/linux/device-mapper.h	2022-09-05 14:31:51.000000000 +0200
> +++ linux-dm/include/linux/device-mapper.h	2022-09-05 14:31:51.000000000 +0200
> @@ -679,4 +679,10 @@ static inline unsigned long to_bytes(sec
>   	return (n << SECTOR_SHIFT);
>   }
>   
> +static void dm_free_error(char *ti_error)
> +{
> +	if (!is_vmalloc_or_module_addr(ti_error))
> +		kfree_const(ti_error);
> +}
> +
>   #endif	/* _LINUX_DEVICE_MAPPER_H */
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://listman.redhat.com/mailman/listinfo/dm-devel

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

