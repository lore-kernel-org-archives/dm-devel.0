Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 72E48C001DD
	for <dm-devel@archiver.kernel.org>; Mon, 10 Jul 2023 06:47:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1688971623;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=w17EDxoM/J6MRWif0qFsFwJsW7tLxij8wreC+5aQcHI=;
	b=Zt7Rz4yEjLZbwfMawtDNA8wlOL11bP3RrXULgpBj/2ThHpp7BZJr7dcWH9Wo2MxYEq1uGr
	6LF0h4H8owud+BUo6bcZe3iQ1oJ1N/f189VQJf0UZYBMiADVyAFTOySniAE8MbIyDL6Dj6
	tB4q4yZm1ZMCCYTctNj/o1315GHdeEc=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-595-iHHTpTzhOlOWI6RwmInFog-1; Mon, 10 Jul 2023 02:46:59 -0400
X-MC-Unique: iHHTpTzhOlOWI6RwmInFog-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B95AD38149C0;
	Mon, 10 Jul 2023 06:46:57 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 9E670C54FBC;
	Mon, 10 Jul 2023 06:46:57 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 7BA3419451D8;
	Mon, 10 Jul 2023 06:46:56 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id A65D4194658C
 for <dm-devel@listman.corp.redhat.com>; Fri, 23 Jun 2023 13:12:58 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 866291121314; Fri, 23 Jun 2023 13:12:58 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 7F4E01121320
 for <dm-devel@redhat.com>; Fri, 23 Jun 2023 13:12:58 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 63AD3104458E
 for <dm-devel@redhat.com>; Fri, 23 Jun 2023 13:12:58 +0000 (UTC)
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com
 [209.85.214.170]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-452-67Q4kmAfNL-acsOyPG-1Bw-1; Fri, 23 Jun 2023 09:12:52 -0400
X-MC-Unique: 67Q4kmAfNL-acsOyPG-1Bw-1
Received: by mail-pl1-f170.google.com with SMTP id
 d9443c01a7336-1b515ec39feso1388055ad.0
 for <dm-devel@redhat.com>; Fri, 23 Jun 2023 06:12:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1687525972; x=1690117972;
 h=content-transfer-encoding:in-reply-to:from:references:cc:to
 :content-language:subject:user-agent:mime-version:date:message-id
 :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=ztC9JD/gutKJP42tTw7xRzDnyP1Mlz22AqRtCxWHul4=;
 b=eCPDgdFR2n/vFvmiIzo4JOJ588B9t+bm3GY5Wzy3r5h7A/ucwwTEhxrdjBGk+Kck1r
 OYrE4Ke9tFko/bXZLSHK5RpwOmAxJ6Ml7XUX8tlxoPW9u9s4Imd4aa5ABq3er6zbo4DW
 8nK+RX6Z+xF0XDB40ppvbXGItnIp/T6tRyMxrUyhqS9h3ZCf22CBUyMqnIWHYV0+6gX6
 ePNb6camf4qa4cciKwnwaQpxlv/PV7a4nRZBQzPUvKYNJjpYwgMcaQnyhNziDlrJ/wQz
 kzxbcjmhq8IW3IR2jB01lpUeFf6kVFa4JxT8OEsXu5JJmklKdIfeWa84t4hyIw4RGOUH
 yH8A==
X-Gm-Message-State: AC+VfDy/k/RAUR99LyQjzfIz5bJtx3gxJR6V9wrYYq5A1S1Vd8Q8j2z6
 gCKXV08+M6HXXlr8TUWyQ3YF9A==
X-Google-Smtp-Source: ACHHUZ78dOQlFEQQrAnXInKb8JKnRB3NkeUnqCzTvDvkAqdG76W+IPYWNvfD8Ue2cdvcaNnPedDi+w==
X-Received: by 2002:a17:902:dac6:b0:1ac:656f:a68d with SMTP id
 q6-20020a170902dac600b001ac656fa68dmr25602985plx.4.1687525971804; 
 Fri, 23 Jun 2023 06:12:51 -0700 (PDT)
Received: from [10.4.168.167] ([139.177.225.254])
 by smtp.gmail.com with ESMTPSA id
 c15-20020a170903234f00b001b694130c05sm5473889plh.1.2023.06.23.06.12.44
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Fri, 23 Jun 2023 06:12:51 -0700 (PDT)
Message-ID: <792beadd-7597-ec8c-e3b1-d8274d68d8c1@bytedance.com>
Date: Fri, 23 Jun 2023 21:12:42 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.12.0
To: Vlastimil Babka <vbabka@suse.cz>, akpm@linux-foundation.org,
 david@fromorbit.com, tkhai@ya.ru, roman.gushchin@linux.dev,
 djwong@kernel.org, brauner@kernel.org, paulmck@kernel.org, tytso@mit.edu
References: <20230622085335.77010-1-zhengqi.arch@bytedance.com>
 <20230622085335.77010-30-zhengqi.arch@bytedance.com>
 <f90772f6-11fe-0d8a-7b1c-d630b884d775@suse.cz>
From: Qi Zheng <zhengqi.arch@bytedance.com>
In-Reply-To: <f90772f6-11fe-0d8a-7b1c-d630b884d775@suse.cz>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Mailman-Approved-At: Mon, 10 Jul 2023 06:46:55 +0000
Subject: Re: [dm-devel] [PATCH 29/29] mm: shrinker: move shrinker-related
 code into a separate file
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
Cc: linux-bcache@vger.kernel.org, linux-xfs@vger.kernel.org,
 linux-nfs@vger.kernel.org, linux-arm-msm@vger.kernel.org,
 intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
 dri-devel@lists.freedesktop.org, virtualization@lists.linux-foundation.org,
 linux-raid@vger.kernel.org, linux-mm@kvack.org, dm-devel@redhat.com,
 linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
 linux-btrfs@vger.kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: bytedance.com
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

Hi Vlastimil,

On 2023/6/22 22:53, Vlastimil Babka wrote:
> On 6/22/23 10:53, Qi Zheng wrote:
>> The mm/vmscan.c file is too large, so separate the shrinker-related
>> code from it into a separate file. No functional changes.
>>
>> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
> 
> Maybe do this move as patch 01 so the further changes are done in the new
> file already?

Sure, I will do it in the v2.

Thanks,
Qi

> 

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

