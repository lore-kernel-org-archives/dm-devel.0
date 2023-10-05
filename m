Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7C1D1E936F8
	for <dm-devel@archiver.kernel.org>; Thu,  5 Oct 2023 02:49:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1696474166;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=IOcWVN8kQo2GyBEv3/NHtmo+M2VjobiunUmKQ4uwSKs=;
	b=IlLCZ75VdyBNK0j7d/c5c0WcZttoFNOYRB3WGLlvGSH/2XW7u4N+Nxuo536zLYn0+g6RtC
	b7LksOXke3xSx1FeRHOsgmbiLauEFiMr8u+tvKgH4rmfIIoPW+Vrg5YXhjRiadf83RRCOd
	POno+WXi80bPHOyP+wIaIWy5Pqu/mkA=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-119-V5UD_e_NMHq17vn1L6YvgA-1; Wed, 04 Oct 2023 22:49:22 -0400
X-MC-Unique: V5UD_e_NMHq17vn1L6YvgA-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 155E98039C8;
	Thu,  5 Oct 2023 02:49:21 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 00B1647AD4A;
	Thu,  5 Oct 2023 02:49:21 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id A896D1946597;
	Thu,  5 Oct 2023 02:49:20 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 15ECA194658F
 for <dm-devel@listman.corp.redhat.com>; Thu,  5 Oct 2023 02:49:19 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id DF3C6C158BA; Thu,  5 Oct 2023 02:49:18 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id D8BE9C15BB8
 for <dm-devel@redhat.com>; Thu,  5 Oct 2023 02:49:18 +0000 (UTC)
Received: from us-smtp-inbound-delivery-1.mimecast.com
 (us-smtp-delivery-1.mimecast.com [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BC9D4800045
 for <dm-devel@redhat.com>; Thu,  5 Oct 2023 02:49:18 +0000 (UTC)
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182]) by
 relay.mimecast.com with ESMTP id us-mta-84-c7L5mUqLO2e_XSAnSDOuZQ-1; Wed,
 04 Oct 2023 22:49:15 -0400
X-MC-Unique: c7L5mUqLO2e_XSAnSDOuZQ-1
Received: from [10.137.106.151] (unknown [131.107.159.23])
 by linux.microsoft.com (Postfix) with ESMTPSA id B993820B74C2;
 Wed,  4 Oct 2023 19:49:13 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com B993820B74C2
Message-ID: <d95c06e5-60e7-4adb-896f-5c99e7f4db52@linux.microsoft.com>
Date: Wed, 4 Oct 2023 19:49:13 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: Eric Biggers <ebiggers@kernel.org>
References: <1696457386-3010-1-git-send-email-wufan@linux.microsoft.com>
 <1696457386-3010-16-git-send-email-wufan@linux.microsoft.com>
 <20231005022707.GA1688@quark.localdomain>
From: Fan Wu <wufan@linux.microsoft.com>
In-Reply-To: <20231005022707.GA1688@quark.localdomain>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
Subject: Re: [dm-devel] [RFC PATCH v11 15/19] fsverity: consume builtin
 signature via LSM hook
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
Cc: axboe@kernel.dk, tytso@mit.edu, paul@paul-moore.com, dm-devel@redhat.com,
 corbet@lwn.net, roberto.sassu@huawei.com,
 Deven Bowers <deven.desai@linux.microsoft.com>, linux-doc@vger.kernel.org,
 snitzer@kernel.org, jmorris@namei.org, zohar@linux.ibm.com,
 linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
 audit@vger.kernel.org, linux-security-module@vger.kernel.org,
 eparis@redhat.com, linux-fscrypt@vger.kernel.org,
 linux-integrity@vger.kernel.org, agk@redhat.com, serge@hallyn.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: linux.microsoft.com
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"



On 10/4/2023 7:27 PM, Eric Biggers wrote:
> On Wed, Oct 04, 2023 at 03:09:42PM -0700, Fan Wu wrote:
>> +#ifdef CONFIG_FS_VERITY_BUILTIN_SIGNATURES
>> +static int fsverity_inode_setsecurity(struct inode *inode,
>> +				      struct fsverity_descriptor *desc)
>> +{
>> +	return security_inode_setsecurity(inode, FS_VERITY_INODE_SEC_NAME,
>> +					  desc->signature,
>> +					  le32_to_cpu(desc->sig_size), 0);
>> +}
> 
> Why isn't the type of the second argument 'const struct fsverity_descriptor *'?
> 
> - Eric

Thanks for the suggestion. I agree that adding 'const' here is a better 
approach. I will update this in the next version.

-Fan

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

