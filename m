Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 43AF0E936ED
	for <dm-devel@archiver.kernel.org>; Thu,  5 Oct 2023 02:46:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1696473994;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=raOLEGMcZZz68VLaV6Ly5YHRWkYgLxx83TRJ3xZjWc0=;
	b=NiSZgd0ftUmoKKXIkh7Lycd5f/qp5Irj4U+BDGV2ImcZ0yVPw6cjNsj/UrsSJEh/MRA3cU
	HAFuhMyXAMM4QxzV9lqlZep9m9vonBQ9aREFfdd0qlqthqpx1fRIZebzOfGDomrDYVrbh7
	/BphzpGhGYyDHtsm6FHuU8+uaU4o/VQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-596-_3Uq2j7NNH6QZKvFijjTfA-1; Wed, 04 Oct 2023 22:46:31 -0400
X-MC-Unique: _3Uq2j7NNH6QZKvFijjTfA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8175118312C1;
	Thu,  5 Oct 2023 02:46:29 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 1070840C6EC1;
	Thu,  5 Oct 2023 02:46:29 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id CF24F1946597;
	Thu,  5 Oct 2023 02:46:28 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id DAECF194658F
 for <dm-devel@listman.corp.redhat.com>; Thu,  5 Oct 2023 02:46:27 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id C6AB440C6EC1; Thu,  5 Oct 2023 02:46:27 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id BED3E40C6EA8
 for <dm-devel@redhat.com>; Thu,  5 Oct 2023 02:46:27 +0000 (UTC)
Received: from us-smtp-inbound-delivery-1.mimecast.com
 (us-smtp-delivery-1.mimecast.com [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A00EC805BAC
 for <dm-devel@redhat.com>; Thu,  5 Oct 2023 02:46:27 +0000 (UTC)
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182]) by
 relay.mimecast.com with ESMTP id us-mta-433-dDEqFUL5Pl-Nx7-6BIFUPw-1; Wed,
 04 Oct 2023 22:46:24 -0400
X-MC-Unique: dDEqFUL5Pl-Nx7-6BIFUPw-1
Received: from [10.137.106.151] (unknown [131.107.159.23])
 by linux.microsoft.com (Postfix) with ESMTPSA id 4A2ED20B74C0;
 Wed,  4 Oct 2023 19:46:23 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 4A2ED20B74C0
Message-ID: <a58cc269-1a95-445d-85c9-ecf997b47294@linux.microsoft.com>
Date: Wed, 4 Oct 2023 19:45:50 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: Randy Dunlap <rdunlap@infradead.org>, corbet@lwn.net,
 zohar@linux.ibm.com, jmorris@namei.org, serge@hallyn.com, tytso@mit.edu,
 ebiggers@kernel.org, axboe@kernel.dk, agk@redhat.com, snitzer@kernel.org,
 eparis@redhat.com, paul@paul-moore.com
References: <1696457386-3010-1-git-send-email-wufan@linux.microsoft.com>
 <1696457386-3010-17-git-send-email-wufan@linux.microsoft.com>
 <7cecea3f-aaca-4df5-9595-324137c3627e@infradead.org>
From: Fan Wu <wufan@linux.microsoft.com>
In-Reply-To: <7cecea3f-aaca-4df5-9595-324137c3627e@infradead.org>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
Subject: Re: [dm-devel] [RFC PATCH v11 16/19] ipe: enable support for
 fs-verity as a trust provider
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
Cc: dm-devel@redhat.com, linux-doc@vger.kernel.org,
 Deven Bowers <deven.desai@linux.microsoft.com>, roberto.sassu@huawei.com,
 linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-block@vger.kernel.org, audit@vger.kernel.org,
 linux-fscrypt@vger.kernel.org, linux-integrity@vger.kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: linux.microsoft.com
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"



On 10/4/2023 4:58 PM, Randy Dunlap wrote:
> 
> 
> On 10/4/23 15:09, Fan Wu wrote:
> 
> | diff --git a/security/ipe/Kconfig b/security/ipe/Kconfig
> | index 7afb1ce0cb99..9dd5c4769d79 100644
> | --- a/security/ipe/Kconfig
> | +++ b/security/ipe/Kconfig
> | @@ -30,6 +30,19 @@ config IPE_PROP_DM_VERITY
> |  	  that was mounted with a signed root-hash or the volume's
> |  	  root hash matches the supplied value in the policy.
> |
> | +	  If unsure, answer Y.
> | +
> | +config IPE_PROP_FS_VERITY
> | +	bool "Enable property for fs-verity files"
> | +	depends on FS_VERITY && FS_VERITY_BUILTIN_SIGNATURES
> | +	help
> | +	  This option enables the usage of properties "fsverity_signature"
> | +	  and "fsverity_digest". These properties evaluates to TRUE when
> 
> 	                                          evaluate
> 
> | +	  a file is fsverity enabled and with a signed digest or its
> | +	  diegst matches the supplied value in the policy.
> 
> 	  digest
> 
> | +
> | +	  if unsure, answer Y.
> | +
> |  endmenu
> |
> |  endif
> 
> 

Thanks for catching the typo/error. Not sure why my spell script didn't 
find them. Maybe I should consider using a better tool.

-Fan

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

