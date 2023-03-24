Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 49E99C6FD20
	for <dm-devel@archiver.kernel.org>; Fri, 24 Mar 2023 19:46:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1679687204;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=hhk6owF7VttBUj+qVDH/CakD4S83AOdgsWdnRPeIY/Q=;
	b=Hus8O5O48+hkeciHOsr94Gh9qtaHVkjxgtopy+CoHFm5A2UXxhNBp/XJQM3MS2R1kPq4sl
	btlE7uIhPU9UIqDalg0WzOCjCGvcwPuhgdsDIFo73gGBvXIfZIY/syt6JQWyhsoCTz6LwC
	3X2k/bY1V+QcXbbePPvaLtKaTWpD0V0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-158-AZhCgEDnMpaE4c7lvuAXBg-1; Fri, 24 Mar 2023 15:46:42 -0400
X-MC-Unique: AZhCgEDnMpaE4c7lvuAXBg-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1B43E185A790;
	Fri, 24 Mar 2023 19:46:41 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 04B42492B0A;
	Fri, 24 Mar 2023 19:46:41 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id B3F8E1946A5E;
	Fri, 24 Mar 2023 19:46:40 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id A88CB1946A5A
 for <dm-devel@listman.corp.redhat.com>; Fri, 24 Mar 2023 19:46:39 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 88B63C15BB8; Fri, 24 Mar 2023 19:46:39 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 81053C15BA0
 for <dm-devel@redhat.com>; Fri, 24 Mar 2023 19:46:39 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 66A3B3C0F246
 for <dm-devel@redhat.com>; Fri, 24 Mar 2023 19:46:39 +0000 (UTC)
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com
 [209.85.214.181]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-426-Yg4XbaElMBuPV4NEG4huPA-1; Fri, 24 Mar 2023 15:46:37 -0400
X-MC-Unique: Yg4XbaElMBuPV4NEG4huPA-1
Received: by mail-pl1-f181.google.com with SMTP id ja10so2820637plb.5
 for <dm-devel@redhat.com>; Fri, 24 Mar 2023 12:46:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112; t=1679687196;
 h=content-transfer-encoding:in-reply-to:from:references:cc:to
 :content-language:subject:user-agent:mime-version:date:message-id
 :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=4rtTUuCCRIIQVv6MF/hcet5LN6DayoTxhlaNVOhUyvs=;
 b=sgO3cH/eyH8YIwDMGgKBLyaz5/QynxyrmaUlvr2EJzQosgXIc9u7x5dvVQq2dOS2w7
 3S2y/HUpcoYyOt86wqBorXuYgf6yx/CL96yZm00Jboh51gL0yvoav8Rt2xjvYiVmexsY
 DR5yl04xvRom9GSIXnFqaKhqIt2sI/uGh4NsaZ3mQ65HotdDba/x4VM2Wq3zI/nLGrvE
 4hWINnI4Csn/ucXTTANYw3cIsiQKy0IpqYnXXDfy5oqv69Xh9VegJY1o6S2YtheeuQwv
 JoaxqfNDyQVkBQIV9MXtX2vRosfAOHnUzYrBHzpXKt5FHITcfCyMjjqX6DOzeY7bw2uG
 eHvA==
X-Gm-Message-State: AAQBX9ciMPYxK0dYBXYRg7fxz3zaA/PKFxJdHP5g02gVZPBV2t5RPmmr
 RQefGGMceeWROEd5fUSQP+w=
X-Google-Smtp-Source: AKy350bgGq1w2lPDZ+6ZO4UHtm4oCoBNhrnJso4ApZVq060T+JXgY5FqVxTJVceo/xOu2MYuXwm1OQ==
X-Received: by 2002:a17:903:1108:b0:1a1:e867:f2a7 with SMTP id
 n8-20020a170903110800b001a1e867f2a7mr4823486plh.22.1679687196486; 
 Fri, 24 Mar 2023 12:46:36 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:386d:2249:7df8:ecf?
 ([2620:15c:211:201:386d:2249:7df8:ecf])
 by smtp.gmail.com with ESMTPSA id
 d2-20020a170902b70200b0019e31e5f7f9sm14639920pls.71.2023.03.24.12.46.34
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Fri, 24 Mar 2023 12:46:36 -0700 (PDT)
Message-ID: <96910cb2-2a87-420e-1ff5-7427c2971318@acm.org>
Date: Fri, 24 Mar 2023 12:46:34 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
To: Mike Christie <michael.christie@oracle.com>, hch@lst.de,
 martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
 james.bottomley@hansenpartnership.com, linux-block@vger.kernel.org,
 dm-devel@redhat.com, snitzer@kernel.org, axboe@kernel.dk,
 linux-nvme@lists.infradead.org, chaitanyak@nvidia.com, kbusch@kernel.org,
 target-devel@vger.kernel.org
References: <20230324181741.13908-1-michael.christie@oracle.com>
 <20230324181741.13908-4-michael.christie@oracle.com>
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20230324181741.13908-4-michael.christie@oracle.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
Subject: Re: [dm-devel] [PATCH v5 03/18] scsi: Rename sd_pr_command
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
Cc: Chaitanya Kulkarni <kch@nvidia.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: acm.org
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

On 3/24/23 11:17, Mike Christie wrote:
> Rename sd_pr_command to sd_pr_out_command to match a
> sd_pr_in_command helper added in the next patches.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

