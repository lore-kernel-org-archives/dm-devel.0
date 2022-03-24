Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DA20EC433EF
	for <dm-devel@archiver.kernel.org>; Thu, 24 Mar 2022 00:35:29 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-528-FeVJTSFTMaSBFtYpl0cZHg-1; Wed, 23 Mar 2022 20:35:25 -0400
X-MC-Unique: FeVJTSFTMaSBFtYpl0cZHg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 619143803915;
	Thu, 24 Mar 2022 00:35:23 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 05F13141DEC7;
	Thu, 24 Mar 2022 00:35:22 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 51199194034B;
	Thu, 24 Mar 2022 00:35:20 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 4AB701940347
 for <dm-devel@listman.corp.redhat.com>; Thu, 24 Mar 2022 00:25:11 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 16568C28106; Thu, 24 Mar 2022 00:25:11 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 11A79C28103
 for <dm-devel@redhat.com>; Thu, 24 Mar 2022 00:25:11 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C75C13C01C3C
 for <dm-devel@redhat.com>; Thu, 24 Mar 2022 00:25:10 +0000 (UTC)
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com
 [209.85.210.170]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-479-UR-jJ1LPPueiwC7BY3zkOA-1; Wed, 23 Mar 2022 20:25:08 -0400
X-MC-Unique: UR-jJ1LPPueiwC7BY3zkOA-1
Received: by mail-pf1-f170.google.com with SMTP id p8so2696953pfh.8
 for <dm-devel@redhat.com>; Wed, 23 Mar 2022 17:25:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
 :content-language:to:cc:references:from:in-reply-to
 :content-transfer-encoding;
 bh=DLXwEQVoWDDsKhgb9WrIVEN4Frk4SugcJXU3mLlQoa8=;
 b=7zt4abPLLTXR3MkW/CGtDktIQ7HP5OqyqkJkcb7V5GP2r1st2/+L9vtRKF09xk/PWw
 xBilI5yEExovjT4SdA/ZdQyEVnPLSnv3u58HiO3NnTh2dsWTWXR5/GfPSty523w3C6uU
 YwbhyCh6/Npun31TKsk1au+h/JcROuYNuMlI/KmKI7mEC1PmW3jd7LTT13iM/FNMYtA/
 UZQUNKypsf3gHXUUSM9x+0cntJ+II9vEPxZQRRCgJd9MbZVWq6p/rCPyjFOoHum5Vzqz
 k+1dL9+RIFh8nWIrZQWPl1uOPn6K9kXhqH6PVKD/KNsoroUWi1T/iyDf9YjRWyI57gia
 kAQA==
X-Gm-Message-State: AOAM532fJhhdq3h/lD22F9iOCo3vUPkUunl+jfu8GeTGLEpo7d1JOXbf
 45epSkVC76odBYJrlilJAgfgBrzqdwHZeJ/8
X-Google-Smtp-Source: ABdhPJxpUJvas/aHL0BqsaaE+UmpRki4f4WUW7prIIy8r1Nmg/onImt86e4hrZ6A4wbAnPuHrWxKyw==
X-Received: by 2002:a63:4e26:0:b0:386:1839:3bde with SMTP id
 c38-20020a634e26000000b0038618393bdemr1928819pgb.603.1648081507485; 
 Wed, 23 Mar 2022 17:25:07 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
 by smtp.gmail.com with ESMTPSA id
 ep2-20020a17090ae64200b001c6a7c22aedsm730331pjb.37.2022.03.23.17.25.06
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Wed, 23 Mar 2022 17:25:07 -0700 (PDT)
Message-ID: <30acea65-293a-7049-2dad-9e81e025ce61@kernel.dk>
Date: Wed, 23 Mar 2022 18:25:06 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
To: Mike Snitzer <snitzer@redhat.com>
References: <20220323194524.5900-1-snitzer@kernel.org>
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20220323194524.5900-1-snitzer@kernel.org>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
Subject: Re: [dm-devel] [PATCH v2 0/4] block/dm: use BIOSET_PERCPU_CACHE
 from bio_alloc_bioset
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
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com, hch@lst.de,
 ming.lei@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 3/23/22 1:45 PM, Mike Snitzer wrote:
> Hi Jens,
> 
> I ran with your suggestion and DM now sees a ~7% improvement in hipri
> bio polling with io_uring (using dm-linear on null_blk, IOPS went from
> 900K to 966K).
> 
> Christoph,
> 
> I tried to address your review of the previous set. Patch 1 and 2 can
> obviously be folded but I left them split out for review purposes.
> Feel free to see if these changes are meaningful for nvme's use.
> Happy for either you to take on iterating on these block changes
> further or you letting me know what changes you'd like made.

Ran the usual peak testing, and it's good for about a 20% improvement
for me. 5.6M -> 6.6M IOPS on a single core, dm-linear.

-- 
Jens Axboe

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

