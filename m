Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 74174C433EF
	for <dm-devel@archiver.kernel.org>; Tue,  3 May 2022 16:54:33 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-158-XpG9DYcdOduWrSu7GiCHig-1; Tue, 03 May 2022 12:54:30 -0400
X-MC-Unique: XpG9DYcdOduWrSu7GiCHig-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BF5F9811E80;
	Tue,  3 May 2022 16:54:28 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id AC57E4679E9;
	Tue,  3 May 2022 16:54:28 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 64C3F1947049;
	Tue,  3 May 2022 16:54:28 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id C13B01947043
 for <dm-devel@listman.corp.redhat.com>; Tue,  3 May 2022 16:54:27 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 9AB3F9E94; Tue,  3 May 2022 16:54:27 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 940999E8D
 for <dm-devel@redhat.com>; Tue,  3 May 2022 16:54:20 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 51AEE86B8B4
 for <dm-devel@redhat.com>; Tue,  3 May 2022 16:54:20 +0000 (UTC)
Received: from mail-oa1-f51.google.com (mail-oa1-f51.google.com
 [209.85.160.51]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-567-Ws5d6qIVNQeCfeBWtqdqPg-1; Tue, 03 May 2022 12:54:18 -0400
X-MC-Unique: Ws5d6qIVNQeCfeBWtqdqPg-1
Received: by mail-oa1-f51.google.com with SMTP id
 586e51a60fabf-ed9a75c453so7213541fac.11; 
 Tue, 03 May 2022 09:54:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
 :content-language:to:cc:references:from:in-reply-to
 :content-transfer-encoding;
 bh=1eh4gXcwKDJaVq28NyDGAP5u0RiukLhIIz4+qOM8ls8=;
 b=PHGLIJbR2Q8IJxmLBdgWjsQ04xXYlolh76DoKGqMzJ+y3m9WILZUKgmmDuXgkB0QD3
 n38ofW7+TeVaaHMoEOvZpst793JIdP/QYQ1kc+hhibORLNZ3fwiiFNnHKQWUOsxws0g8
 8y6cBO/4TZvT+jHxFOAtsuK4Sl1wP6Q1V5qNEciDdCVWWGzUdQQZdTAulJHENIstjrvG
 taUSLOWTFrgnJOWNGTdkzyJp1rTDkivrCnj0VjTY1AZY8keuEalXTREko/CxAI0B9yRU
 A+eBdFG9fU6Msui8fxf0DzY1uS2HdPVkNKPLD3CdhtcaQgYNkhdZavCmKJQjzqj4Vtb/
 YXTQ==
X-Gm-Message-State: AOAM532FkyUf9CapWJratAVmlTsvlzOA63qS7za4LsIFextBOq75cBeO
 l0Jy04ln4pF+HzBDH2ddeqtD4Hheke4=
X-Google-Smtp-Source: ABdhPJwIYsdQ5p1P5Q1mznCaYxjTnd/hJJG6oVZ/Lc+drskzCLzSd9wtxgyiNOjNc1Eeeh2wyOvvEw==
X-Received: by 2002:a05:6870:b693:b0:de:7356:a3a3 with SMTP id
 cy19-20020a056870b69300b000de7356a3a3mr2077698oab.24.1651596857587; 
 Tue, 03 May 2022 09:54:17 -0700 (PDT)
Received: from [10.10.69.251] ([8.34.116.185])
 by smtp.gmail.com with ESMTPSA id
 v186-20020aca61c3000000b00325cda1ffa1sm3506854oib.32.2022.05.03.09.54.14
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Tue, 03 May 2022 09:54:16 -0700 (PDT)
Message-ID: <78730bd4-a184-e0f0-4634-d09dbaf59958@acm.org>
Date: Tue, 3 May 2022 09:54:13 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
To: Pankaj Raghav <p.raghav@samsung.com>, jaegeuk@kernel.org,
 axboe@kernel.dk, snitzer@kernel.org, hch@lst.de, mcgrof@kernel.org,
 naohiro.aota@wdc.com, sagi@grimberg.me, damien.lemoal@opensource.wdc.com,
 dsterba@suse.com, johannes.thumshirn@wdc.com
References: <20220427160255.300418-1-p.raghav@samsung.com>
 <CGME20220427160302eucas1p1aaba7a309778d3440c3315ad899e4035@eucas1p1.samsung.com>
 <20220427160255.300418-7-p.raghav@samsung.com>
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20220427160255.300418-7-p.raghav@samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
Subject: Re: [dm-devel] [PATCH 06/16] nvmet: use blk_queue_zone_no()
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
Cc: jiangbo.365@bytedance.com, kch@nvidia.com, matias.bjorling@wdc.com,
 gost.dev@samsung.com, chao@kernel.org, linux-kernel@vger.kernel.org,
 linux-nvme@lists.infradead.org, linux-f2fs-devel@lists.sourceforge.net,
 linux-block@vger.kernel.org, clm@fb.com, dm-devel@redhat.com, agk@redhat.com,
 jonathan.derrick@linux.dev, kbusch@kernel.org, linux-fsdevel@vger.kernel.org,
 josef@toxicpanda.com, linux-btrfs@vger.kernel.org
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

On 4/27/22 09:02, Pankaj Raghav wrote:
> From: Luis Chamberlain <mcgrof@kernel.org>
> 
> Instead of open coding the number of zones given a sector, use the helper
                          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
I can't parse this. Please rephrase this.

> blk_queue_zone_no(). This let's us make modifications to the math if
> needed in one place and adds now support for npo2 zone devices.

But since the code looks fine:

Reviewed-by: Bart Van Assche <bvanassche@acm.org>

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

