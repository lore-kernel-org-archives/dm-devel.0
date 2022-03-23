Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 08206C433EF
	for <dm-devel@archiver.kernel.org>; Wed, 23 Mar 2022 02:57:49 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-301-N0oAiRstOy2yXKd8eDep6w-1; Tue, 22 Mar 2022 22:57:45 -0400
X-MC-Unique: N0oAiRstOy2yXKd8eDep6w-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A07B7899EC4;
	Wed, 23 Mar 2022 02:57:41 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 62B6943E8F4;
	Wed, 23 Mar 2022 02:57:38 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 017E11940340;
	Wed, 23 Mar 2022 02:57:38 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id AF6891949762
 for <dm-devel@listman.corp.redhat.com>; Wed, 23 Mar 2022 02:57:36 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 81CB343E8F3; Wed, 23 Mar 2022 02:57:36 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 7DD1E43E8F6
 for <dm-devel@redhat.com>; Wed, 23 Mar 2022 02:57:36 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 668011C05EB6
 for <dm-devel@redhat.com>; Wed, 23 Mar 2022 02:57:36 +0000 (UTC)
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com
 [209.85.214.172]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-534-ZOrwXvSSMY-ZOeHRblza6g-1; Tue, 22 Mar 2022 22:57:32 -0400
X-MC-Unique: ZOrwXvSSMY-ZOeHRblza6g-1
Received: by mail-pl1-f172.google.com with SMTP id w4so301379ply.13;
 Tue, 22 Mar 2022 19:57:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
 :content-language:to:cc:references:from:in-reply-to
 :content-transfer-encoding;
 bh=XdtGK4rmRWu9kbcb/j+mRwJrjPioe83qUnPzzHWXTQM=;
 b=FU5fF9qyRHESID/CB/bJzwtpXG0HOw5c7dEqXbxYlGIWrGrfTCpXwAnP7i461MXdBm
 7l3eaDuyJ2Ato7vK5QWyxtlnpxKAB96L3xGl5qVIT++2nTcvsAN1rCoOxCG2U0f6YFG+
 BK1erE/r5TiCorRB26fc7vE4rJhfWBytS6ZYaz2OzUzjwUsklMhKAlLKGpUowI4A1jaI
 JtbYMP5MA1bncMawzr+knPl42FiEAQ1+ozg+NACtpWf8aL8C+TaP4eHcBXMGTm3G8uJ1
 3ECNj5shdMFQeGFG8Ze4DBfovyM+jEuLq0gYu43kXXN4RbnRfaWf6ePYHAryBI0WvW+F
 3eiA==
X-Gm-Message-State: AOAM531XAGwt013/DAhcW5uIO7tXoc3rcJhzep5ulIFu36jqzLrIGFSW
 iBmjZtWCKPlZsJn+C2oaxgA=
X-Google-Smtp-Source: ABdhPJwSFEIHiVSTOmzTD2GpstiC4F+wLHyntg8/TEzIPpoV27kY2teF1rJv/n+nM+gczQuBLAtydA==
X-Received: by 2002:a17:902:8605:b0:151:b6a2:8a1 with SMTP id
 f5-20020a170902860500b00151b6a208a1mr21517901plo.64.1648004251166; 
 Tue, 22 Mar 2022 19:57:31 -0700 (PDT)
Received: from ?IPV6:2601:647:4000:d7:feaa:14ff:fe9d:6dbd?
 ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
 by smtp.gmail.com with ESMTPSA id
 16-20020a17090a005000b001c7511dc31esm4019995pjb.41.2022.03.22.19.57.28
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Tue, 22 Mar 2022 19:57:30 -0700 (PDT)
Message-ID: <e74776f0-505b-8b4f-effd-519bce9bdc79@acm.org>
Date: Tue, 22 Mar 2022 19:57:27 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
To: John Garry <john.garry@huawei.com>, axboe@kernel.dk,
 damien.lemoal@opensource.wdc.com, jejb@linux.ibm.com,
 martin.petersen@oracle.com, hch@lst.de, ming.lei@redhat.com, hare@suse.de
References: <1647945585-197349-1-git-send-email-john.garry@huawei.com>
 <1647945585-197349-2-git-send-email-john.garry@huawei.com>
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <1647945585-197349-2-git-send-email-john.garry@huawei.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
Subject: Re: [dm-devel] [PATCH 01/11] blk-mq: Add blk_mq_init_queue_ops()
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
Cc: linux-scsi@vger.kernel.org, chenxiang66@hisilicon.com,
 linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
 linux-ide@vger.kernel.org, dm-devel@redhat.com, beanhuo@micron.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

On 3/22/22 03:39, John Garry wrote:
> Add an API to allocate a request queue which accepts a custom set of
> blk_mq_ops for that request queue.
> 
> The reason which we may want custom ops is for queuing requests which we
> don't want to go through the normal queuing path.

Custom ops shouldn't be required for this. See e.g. how tmf_queue
is used in the UFS driver for an example of a queue implementation
with custom operations and that does not require changes of the block
layer core.

Thanks,

Bart.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

