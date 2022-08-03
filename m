Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 27B9CC19F28
	for <dm-devel@archiver.kernel.org>; Wed,  3 Aug 2022 17:24:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1659547493;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=zMvj1olQLYSldi48lN3Q8AJ6DFmBqQlSwEGhXCAqZu0=;
	b=cdVlBJ0Yavl5E7qh6NMT3TZe19h052tSEcCmXflTarPvLEWBtpwk5FQYoILtcQZ55RPd1V
	qgH3HomC7WzZKHpaswWWQcsJP4jZ8Ah1E1zkbWzQMA16ntIRM3xS/sgrcM2ZBNVEm+lq2m
	07gwWPekuTWgErymbADJEZc7O9miQbo=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-656-1r7h5YfjP-2Om8S9t6I_Mw-1; Wed, 03 Aug 2022 13:24:50 -0400
X-MC-Unique: 1r7h5YfjP-2Om8S9t6I_Mw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CF874185A7B2;
	Wed,  3 Aug 2022 17:24:48 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 813A51415116;
	Wed,  3 Aug 2022 17:24:48 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 52D741945D91;
	Wed,  3 Aug 2022 17:24:48 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 61BEF1946A7D
 for <dm-devel@listman.corp.redhat.com>; Wed,  3 Aug 2022 17:24:47 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 383F51415116; Wed,  3 Aug 2022 17:24:47 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 341A31410F38
 for <dm-devel@redhat.com>; Wed,  3 Aug 2022 17:24:47 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1C10F3817A71
 for <dm-devel@redhat.com>; Wed,  3 Aug 2022 17:24:47 +0000 (UTC)
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com
 [209.85.214.176]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-396-9IlLnk95N32H2-gRDwpZSQ-1; Wed, 03 Aug 2022 13:24:45 -0400
X-MC-Unique: 9IlLnk95N32H2-gRDwpZSQ-1
Received: by mail-pl1-f176.google.com with SMTP id o3so17013130ple.5;
 Wed, 03 Aug 2022 10:24:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=content-transfer-encoding:in-reply-to:from:references:cc:to
 :content-language:subject:user-agent:mime-version:date:message-id
 :x-gm-message-state:from:to:cc;
 bh=PLueRrdRrDSAZCsSnEuO7ryjbF4cDa5AGSQHDpCb7Jo=;
 b=2r2Cuv/8x86bsqO2fQPTyrHNjJ81JuHzUrUKvp3aK2gg/tq4gYUGy19yYRa+Uwfpf8
 Xp4nSsgCxPADIQkZj7BcRQATw3R9WLsO2YCeaiHvZXPaSR6JRcVZhj1pzTrQe3zy9Tiu
 zPrWN8Ki4cvb9mTk2N3AezZZ5Ev+k//5oVQ4RIMIaxu5GQ8m4RgLHRCsX4rM/6f6LUod
 WeR5FodkQbPKgiFgYIF1vYFHDbxzZrl6BaHbkn8rU00iwtbfcEsXkhpU2QSjW4rkDYzm
 400Dt93nxoZYsR8YydSaM4ciAV6re+LXILe8tuvLFcACE5jP+NyNDQKtckdOYDuXCaw1
 KqCg==
X-Gm-Message-State: ACgBeo3PwmckcjK0jfArA23NriXfo0MnBl5jmBFlYiXEio9i6CTdhLLI
 pXXmLFD2/uBMJ7q8Aa/qzrY=
X-Google-Smtp-Source: AA6agR4+errzcNzMPWB0CtPUqoFfU+/HvKqxJd9O453x9LrGJfJ/jGLweL2ivP559rQbToAj4CcR+Q==
X-Received: by 2002:a17:90a:d58e:b0:1f4:f9a5:22a8 with SMTP id
 v14-20020a17090ad58e00b001f4f9a522a8mr5883087pju.58.1659547483870; 
 Wed, 03 Aug 2022 10:24:43 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:db71:edb7:462a:44af?
 ([2620:15c:211:201:db71:edb7:462a:44af])
 by smtp.gmail.com with ESMTPSA id
 i18-20020a170902c95200b0016c2cdea409sm2217726pla.280.2022.08.03.10.24.41
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Wed, 03 Aug 2022 10:24:43 -0700 (PDT)
Message-ID: <9de2428b-96b8-883c-bd96-01a7763758e8@acm.org>
Date: Wed, 3 Aug 2022 10:24:40 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
To: Pankaj Raghav <p.raghav@samsung.com>, Johannes.Thumshirn@wdc.com,
 snitzer@kernel.org, axboe@kernel.dk, damien.lemoal@opensource.wdc.com,
 agk@redhat.com, hch@lst.de
References: <20220803094801.177490-1-p.raghav@samsung.com>
 <CGME20220803094813eucas1p2eab78901e97417ad52be1f8023db3d82@eucas1p2.samsung.com>
 <20220803094801.177490-11-p.raghav@samsung.com>
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20220803094801.177490-11-p.raghav@samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
Subject: Re: [dm-devel] [PATCH v9 10/13] dm-table: allow zoned devices with
 non power-of-2 zone sizes
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
Cc: pankydev8@gmail.com, gost.dev@samsung.com, linux-kernel@vger.kernel.org,
 linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
 dm-devel@redhat.com, jaegeuk@kernel.org, matias.bjorling@wdc.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

On 8/3/22 02:47, Pankaj Raghav wrote:
> Allow dm to support zoned devices with non power-of-2(po2) zone sizes as
> the block layer now supports it.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

