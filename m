Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4F4E6E936ED
	for <dm-devel@archiver.kernel.org>; Thu,  5 Oct 2023 00:34:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1696466052;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=a/0qBSXitZdnLnxdXlGPFnyaGF4123GltAbkyEd6zDI=;
	b=YfQvV7tOu+0o2405L+SZq3l3E9Ws76FGJua5WI2hTWDMUvv67OidqO93Dmk9PlxVJRglYK
	ueRedFlXDtNQx68IGHIC1vP3A3WMvhjMdn4LkiMIHNTZefPGobIkmSRqzf2ULqGZ149293
	IpcYEGT2nqjdjuvbDx9R4nl2dzKi7MA=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-134-kdyZ8NAGOtGa3hwje4vwTQ-1; Wed, 04 Oct 2023 20:34:07 -0400
X-MC-Unique: kdyZ8NAGOtGa3hwje4vwTQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D3544805BAC;
	Thu,  5 Oct 2023 00:34:05 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 37A75440E3;
	Thu,  5 Oct 2023 00:34:04 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id F2A5F1946597;
	Thu,  5 Oct 2023 00:34:03 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 3BDF7194658F
 for <dm-devel@listman.corp.redhat.com>; Thu,  5 Oct 2023 00:34:02 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 23B0A5CC01; Thu,  5 Oct 2023 00:34:02 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 1B7F347CD2
 for <dm-devel@redhat.com>; Thu,  5 Oct 2023 00:34:02 +0000 (UTC)
Received: from us-smtp-inbound-delivery-1.mimecast.com
 (us-smtp-inbound-delivery-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id ED12685A5BD
 for <dm-devel@redhat.com>; Thu,  5 Oct 2023 00:34:01 +0000 (UTC)
Received: from bombadil.infradead.org (bombadil.infradead.org
 [198.137.202.133]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-501-zpPcNcRWNm2stm7Uq3OOMw-1; Wed, 04 Oct 2023 20:34:00 -0400
X-MC-Unique: zpPcNcRWNm2stm7Uq3OOMw-1
Received: from [50.53.46.231] (helo=[192.168.254.15])
 by bombadil.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
 id 1qoBlI-00182U-0V; Wed, 04 Oct 2023 23:58:40 +0000
Message-ID: <7cecea3f-aaca-4df5-9595-324137c3627e@infradead.org>
Date: Wed, 4 Oct 2023 16:58:38 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: Fan Wu <wufan@linux.microsoft.com>, corbet@lwn.net, zohar@linux.ibm.com,
 jmorris@namei.org, serge@hallyn.com, tytso@mit.edu, ebiggers@kernel.org,
 axboe@kernel.dk, agk@redhat.com, snitzer@kernel.org, eparis@redhat.com,
 paul@paul-moore.com
References: <1696457386-3010-1-git-send-email-wufan@linux.microsoft.com>
 <1696457386-3010-17-git-send-email-wufan@linux.microsoft.com>
From: Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <1696457386-3010-17-git-send-email-wufan@linux.microsoft.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: infradead.org
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit



On 10/4/23 15:09, Fan Wu wrote:

| diff --git a/security/ipe/Kconfig b/security/ipe/Kconfig
| index 7afb1ce0cb99..9dd5c4769d79 100644
| --- a/security/ipe/Kconfig
| +++ b/security/ipe/Kconfig
| @@ -30,6 +30,19 @@ config IPE_PROP_DM_VERITY
|  	  that was mounted with a signed root-hash or the volume's
|  	  root hash matches the supplied value in the policy.
|  
| +	  If unsure, answer Y.
| +
| +config IPE_PROP_FS_VERITY
| +	bool "Enable property for fs-verity files"
| +	depends on FS_VERITY && FS_VERITY_BUILTIN_SIGNATURES
| +	help
| +	  This option enables the usage of properties "fsverity_signature"
| +	  and "fsverity_digest". These properties evaluates to TRUE when

	                                          evaluate

| +	  a file is fsverity enabled and with a signed digest or its
| +	  diegst matches the supplied value in the policy.

	  digest

| +
| +	  if unsure, answer Y.
| +
|  endmenu
|  
|  endif


-- 
~Randy

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

