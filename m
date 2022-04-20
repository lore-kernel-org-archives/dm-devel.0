Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3BD38C433EF
	for <dm-devel@archiver.kernel.org>; Thu, 21 Apr 2022 05:51:53 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-631-IG6PsfD3NoKGC8OV3JuJXw-1; Thu, 21 Apr 2022 01:51:49 -0400
X-MC-Unique: IG6PsfD3NoKGC8OV3JuJXw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B4E881C0BF31;
	Thu, 21 Apr 2022 05:51:47 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 45B537AFA;
	Thu, 21 Apr 2022 05:51:45 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id DA9DA1949763;
	Thu, 21 Apr 2022 05:51:44 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id A5BB319451EC
 for <dm-devel@listman.corp.redhat.com>; Wed, 20 Apr 2022 21:14:51 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 97A0D145BA5C; Wed, 20 Apr 2022 21:14:51 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 934B3145B98F
 for <dm-devel@redhat.com>; Wed, 20 Apr 2022 21:14:51 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7575E1C05195
 for <dm-devel@redhat.com>; Wed, 20 Apr 2022 21:14:51 +0000 (UTC)
Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com
 [209.85.216.53]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-52-WTvrWS5fNG-hKqBqXwEqTw-1; Wed, 20 Apr 2022 17:14:49 -0400
X-MC-Unique: WTvrWS5fNG-hKqBqXwEqTw-1
Received: by mail-pj1-f53.google.com with SMTP id
 e62-20020a17090a6fc400b001d2cd8e9b0aso3234145pjk.5
 for <dm-devel@redhat.com>; Wed, 20 Apr 2022 14:14:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=uRbnXmT2UvLhDpzTR7xEDnTe9vcZt6Ox/EpPIaIeBNk=;
 b=UCLMKhDEUsO3bA1RLbcT/0RMygY1dMbAmYn4GY4IBb6u3ZtrYLQZ7HS0QZ3T9C4JQu
 XGv/p+TPFebRFE/J347nlLEJUtj4npfX93NUy06yYS12g34SfvZJfgH84+ap6uMPP/qB
 29I67M88IdGByEL9fO2J2w7JSrVLyt4UAeTGIiKK5v5E0EHtGEFerb291UCLPkXkofxW
 6Ck2NSx3mvJ39p11OG5FPkYC+i79lnKnI8Ce4hQE6WFQtPB04Daw0imbB1hcps6i9qW/
 tQJtMeWQNB3++E9jYIM+a4xPIlZc3eVS36BA30//e2B8XTwjWRCQTKP131x4Glh+z7pS
 /o+A==
X-Gm-Message-State: AOAM531/FlP+yUT2irZwGYTiNi5AcyIanycqQMOkpYCCojuZAQe9p/cZ
 PB2k8836hwbnSUNZJmzJvg3fdg==
X-Google-Smtp-Source: ABdhPJxuHStY/O2yxOF4aGXWY/+6gqi8MOT1wrD1jauKk5sZM7uC/IKuwN7l/Rq7NJ4oi+BhCMosdw==
X-Received: by 2002:a17:903:32d0:b0:158:fe2e:d2a7 with SMTP id
 i16-20020a17090332d000b00158fe2ed2a7mr15806275plr.93.1650489288521; 
 Wed, 20 Apr 2022 14:14:48 -0700 (PDT)
Received: from yoga.purestorage.com ([64.84.68.252])
 by smtp.googlemail.com with ESMTPSA id
 x71-20020a62864a000000b0050ad2c24a39sm869262pfd.205.2022.04.20.14.14.47
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 20 Apr 2022 14:14:47 -0700 (PDT)
From: Casey Chen <cachen@purestorage.com>
To: igor.druzhinin@citrix.com
Date: Wed, 20 Apr 2022 14:14:37 -0700
Message-Id: <20220420211437.101040-1-cachen@purestorage.com>
In-Reply-To: <9758c2f9-5b47-f354-9d11-8235b3dcf93c@citrix.com>
References: <9758c2f9-5b47-f354-9d11-8235b3dcf93c@citrix.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
X-Mailman-Approved-At: Thu, 21 Apr 2022 05:51:43 +0000
Subject: Re: [dm-devel] BUG: unable to handle kernel paging request
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
Cc: bart.vanassche@sandisk.com, dm-devel@redhat.com,
 Casey Chen <cachen@purestorage.com>, snitzer@redhat.com,
 yzhong@purestorage.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi,

It is unclear to me whether the issue has been solved or not from previous discussions.
We found a similar crash on v4.4.262. The crash happened at the exact line of code as
described by Igor. I wonder what's the fix and possible ways to test the fix. Thanks!

[14501930.727650,06] BUG: unable to handle kernel paging request at ffffc901aed4d048
[14501930.730983,06] IP: [<ffffffff816612cf>] dm_softirq_done+0x8f/0x270
[14501930.732776,06] PGD 18fcbb067 PUD 2e3b7b067 PMD 2cab08067 PTE 0
[14501930.734640,06] Oops: 0000 [#1] SMP
[14501930.736507,06] Dumping ftrace buffer:
...
[14501930.818509,06] CPU: 6 PID: 14767 Comm: <masked off> Tainted: P        W  O    4.4.262+
...
[14501930.938477,06] Call Trace:
[14501930.941301,06]  <IRQ>
[14501930.941351,06]  [<ffffffff8130b6c3>] __blk_mq_complete_request+0x83/0xf0
[14501930.946847,06]  [<ffffffff8130b74c>] blk_mq_complete_request+0x1c/0x20
[14501930.949574,06]  [<ffffffff81660494>] dm_complete_request+0x34/0x50
[14501930.952256,06]  [<ffffffff816604df>] end_clone_request+0x2f/0x50
[14501930.954883,06]  [<ffffffff8130a7cd>] blk_mq_end_request+0x3d/0x70
[14501930.957460,06]  [<ffffffffa028484c>] nvme_rdma_complete_rq+0x4c/0x210 [nvme_rdma]
[14501930.962447,06]  [<ffffffff810760ac>] ? __local_bh_enable+0x3c/0x70
[14501930.964972,06]  [<ffffffff813097f0>] ? blkdev_issue_zeroout+0x260/0x260
[14501930.967459,06]  [<ffffffff81309809>] __blk_mq_complete_request_remote+0x19/0x20
[14501930.972291,06]  [<ffffffff810ef099>] flush_smp_call_function_queue+0xa9/0x170
[14501930.977138,06]  [<ffffffff810efaa3>] generic_smp_call_function_single_interrupt+0x13/0x60
[14501930.982005,06]  [<ffffffff810495bd>] smp_call_function_interrupt+0x2d/0x40
[14501930.984492,06]  [<ffffffff810496be>] smp_call_function_single_interrupt+0xe/0x10
[14501930.989316,06]  [<ffffffff817d0221>] call_function_single_interrupt+0x91/0xa0
[14501930.994301,06]  <EOI>
[14501930.994350,06]  [<ffffffff810031a0>] ? exit_to_usermode_loop+0x50/0xb0
[14501930.999364,06]  [<ffffffff81003199>] ? exit_to_usermode_loop+0x49/0xb0
[14501931.001829,06]  [<ffffffff81003b62>] prepare_exit_to_usermode+0x32/0x40
[14501931.004261,06]  [<ffffffff817cf979>] retint_user+0x8/0x20
[14501931.006626,06] Code: 16 41 83 fc 02 0f 85 df 01 00 00 49 8b 76 10 49 8b 3e e8 05 fe ff ff 5b 41 5c 41 5d 41 5e 41 5f 5d c3 49 8b 7e 08 48 85 ff 74 bd <48> 8b 47 08 48 8b 40 60 48 85 c0 74 b0 44 89 e2 49 8d 4e 48 4c
[14501931.014038,06] RIP  [<ffffffff816612cf>] dm_softirq_done+0x8f/0x270
[14501931.016532,06]  RSP <ffff8817e0ac3e28>
[14501931.018971,06] CR2: ffffc901aed4d048
[14501931.021382,06] ---[ end trace 67b8f26e34c76805 ]---

Regards,
Casey

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

