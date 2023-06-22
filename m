Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8201EC0015E
	for <dm-devel@archiver.kernel.org>; Fri, 23 Jun 2023 05:25:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1687497955;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=ry/Py44SuHtTvKka/71Dj+3s6qL/UuaQYUDGNAYq2vQ=;
	b=IJ64ECz6iUzRfJ8Ymn6II9kEb2wNwFQ75SNgN2Ew4kKAfyGZGU2oGi22O4x1x38CQpSLgt
	YZKNOKvuxoMMBOfHtzyqDN01MxRRFQS6AdfhO4+islzXHQcXZChcjeotaxoAQdgA6FwPIY
	XYH7LSVYiyu7dkswHiv0aRaHNJZj3r4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-172-pSgM7eKUO2iq7VBbl0---g-1; Fri, 23 Jun 2023 01:25:52 -0400
X-MC-Unique: pSgM7eKUO2iq7VBbl0---g-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A4A9A8E44F3;
	Fri, 23 Jun 2023 05:25:49 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 92238200A3AD;
	Fri, 23 Jun 2023 05:25:49 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 5C9BF1946A47;
	Fri, 23 Jun 2023 05:25:41 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 989181946587
 for <dm-devel@listman.corp.redhat.com>; Thu, 22 Jun 2023 08:31:50 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id A7117C1ED97; Thu, 22 Jun 2023 08:31:50 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 9F8CFC1ED96
 for <dm-devel@redhat.com>; Thu, 22 Jun 2023 08:31:50 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 84E25385556F
 for <dm-devel@redhat.com>; Thu, 22 Jun 2023 08:31:50 +0000 (UTC)
Received: from mail-oa1-f53.google.com (mail-oa1-f53.google.com
 [209.85.160.53]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-137-ggNDGcHLNkyQun8HLlQTFA-1; Thu, 22 Jun 2023 04:31:43 -0400
X-MC-Unique: ggNDGcHLNkyQun8HLlQTFA-1
Received: by mail-oa1-f53.google.com with SMTP id
 586e51a60fabf-1aa25c5cf0eso1108879fac.1
 for <dm-devel@redhat.com>; Thu, 22 Jun 2023 01:31:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1687422703; x=1690014703;
 h=content-transfer-encoding:in-reply-to:from:content-language
 :references:cc:to:subject:user-agent:mime-version:date:message-id
 :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=jRx5u0dIx9qFXm7I93dXe9q/QmQ9W+wUToPS3aLpk1M=;
 b=BCgEi529vqyWgw7Z7B6dqkHM+Dt60U2/kOO2C4VnXI9WCUhbXgw6k/p2X7Q4v1NYbZ
 IvVBdwTfq1Tj4UiZKUMW7JGl0i7J9ALFMqn6PzvcIQX24seG22u5sFVYuIMS+JlcSCcF
 FzoLKOLKFR9R+8wqbbGVk8HRlkJH6qJK56nk/TDqXYFdSZtrgkjXs2CZYjlcMmnpFn2/
 E6EjRxoXbStNRZjvgpdFM1XEGEdLZlNHCLrQUhwYwzclnn6J32YE2EC42zXGOD0K8nto
 GtLSb/N8QpUp95Y+vFmvHWCbkX1aXqyCudMR26ZOjRLl/GNdhm0in+QXfKkZY8mdPYkz
 X9rg==
X-Gm-Message-State: AC+VfDwArujvNwCZ/PZtHH1U/8/6IGxFkEK/WYsTnHOgTiZfgTkr4/XB
 N4X0mdG7WHA6kGLOTnkDxc/auQ==
X-Google-Smtp-Source: ACHHUZ4rJo+IPtTRaPya+U1JdMgc+u3gA3krnJKF3F08hxGt0uoHrxZAqg1izlNZ+SOIkOa4AMphOQ==
X-Received: by 2002:a05:6830:19c1:b0:6b1:6db4:556f with SMTP id
 p1-20020a05683019c100b006b16db4556fmr10609999otp.3.1687422702698; 
 Thu, 22 Jun 2023 01:31:42 -0700 (PDT)
Received: from [10.4.168.167] ([139.177.225.254])
 by smtp.gmail.com with ESMTPSA id
 y17-20020a63e251000000b0050a0227a4bcsm4369684pgj.57.2023.06.22.01.31.24
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Thu, 22 Jun 2023 01:31:42 -0700 (PDT)
Message-ID: <52bf599c-3c3a-7dfc-30b3-f3a2af5f29a8@bytedance.com>
Date: Thu, 22 Jun 2023 16:31:22 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.12.0
To: Qi Zheng <qi.zheng@linux.dev>, akpm@linux-foundation.org,
 david@fromorbit.com, tkhai@ya.ru, vbabka@suse.cz, roman.gushchin@linux.dev,
 djwong@kernel.org, brauner@kernel.org, paulmck@kernel.org, tytso@mit.edu
References: <20230622082454.4090236-1-qi.zheng@linux.dev>
From: Qi Zheng <zhengqi.arch@bytedance.com>
In-Reply-To: <20230622082454.4090236-1-qi.zheng@linux.dev>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Mailman-Approved-At: Fri, 23 Jun 2023 05:25:40 +0000
Subject: Re: [dm-devel] [External] [PATCH 00/29] use refcount+RCU method to
 implement lockless slab shrink
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
Cc: mst@redhat.com, jasowang@redhat.com, dri-devel@lists.freedesktop.org,
 virtualization@lists.linux-foundation.org, linux-mm@kvack.org, song@kernel.org,
 dm-devel@redhat.com, ray.huang@amd.com, namit@vmware.com,
 marijn.suijten@somainline.org, airlied@gmail.com, agk@redhat.com,
 robh@kernel.org, senozhatsky@chromium.org, david@redhat.com, clm@fb.com,
 steven.price@arm.com, alyssa.rosenzweig@collabora.com, josef@toxicpanda.com,
 linux-ext4@vger.kernel.org, kent.overstreet@gmail.com,
 xuanzhuo@linux.alibaba.com, linux-arm-msm@vger.kernel.org,
 intel-gfx@lists.freedesktop.org, snitzer@kernel.org, quic_abhinavk@quicinc.com,
 colyli@suse.de, linux-raid@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-bcache@vger.kernel.org, viro@zeniv.linux.org.uk, dsterba@suse.com,
 sean@poorly.run, linux-nfs@vger.kernel.org, tomeu.vizoso@collabora.com,
 kolga@netapp.com, gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
 linux-xfs@vger.kernel.org, minchan@kernel.org, robdclark@gmail.com,
 chuck.lever@oracle.com, daniel@ffwll.ch, jack@suse.com,
 dmitry.baryshkov@linaro.org, adilger.kernel@dilger.ca,
 freedreno@lists.freedesktop.org, christian.koenig@amd.com,
 linux-btrfs@vger.kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: bytedance.com
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

This patch set failed to send due to the following reasons, please ignore.

	4.7.1 Error: too many recipients from 49.7.199.65

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

