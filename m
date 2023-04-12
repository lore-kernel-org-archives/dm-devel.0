Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0AA26C77B76
	for <dm-devel@archiver.kernel.org>; Thu, 13 Apr 2023 06:55:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1681368916;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=vf/INx7rk+lO62GHYQQLU6O/e9BTYOrKmReKLywP8ko=;
	b=ef1565zYbVmaPy/T7qmfSM/QgGNrwPPIu9bVLQgT1txKCcJ/Edys957RkhwoF8Rb6HHVKL
	Cl7DpmAwUfM9ungR9b3eHWBlh4yxfQJtVVsSsIgo0eHG5EqL3gXdLpkw6Z7cNHpu51zBbY
	rjrPP5l3XlF88TU9HhxYWtkm+kULzcI=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-507-yR71yKlMNmatg-xAdLkxtw-1; Thu, 13 Apr 2023 02:55:12 -0400
X-MC-Unique: yR71yKlMNmatg-xAdLkxtw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BA3F229DD996;
	Thu, 13 Apr 2023 06:55:09 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id A9CDD1415117;
	Thu, 13 Apr 2023 06:55:09 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 7454319465A2;
	Thu, 13 Apr 2023 06:55:09 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id BCB551946587
 for <dm-devel@listman.corp.redhat.com>; Wed, 12 Apr 2023 10:57:46 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 9CB0B492C3E; Wed, 12 Apr 2023 10:57:46 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 95E2D492B00
 for <dm-devel@redhat.com>; Wed, 12 Apr 2023 10:57:46 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 73A5985C6E3
 for <dm-devel@redhat.com>; Wed, 12 Apr 2023 10:57:46 +0000 (UTC)
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com
 [209.85.214.171]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-653-I92lEQqPMWuOxtBAW5ODyg-1; Wed, 12 Apr 2023 06:57:45 -0400
X-MC-Unique: I92lEQqPMWuOxtBAW5ODyg-1
Received: by mail-pl1-f171.google.com with SMTP id h24so11109857plr.1
 for <dm-devel@redhat.com>; Wed, 12 Apr 2023 03:57:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112; t=1681297064; x=1683889064;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=CcYYNtaDxHlH75DVzktS520/qEGVSpcAU/4xvgOpO10=;
 b=6CpIhkb49z0RfCUYbHSUWrOCVWshbY798smPoAPGHA11j+PCP1tJKa3B3j2P9VrjHK
 SwX0npXMvJyqrMJG7VpALb/fn6V0BENcDUR3N8IvxO4qtyo8CHV0KtT9R5PByJSIgNHQ
 N5Mh59YMu5Eg9DCcoUYXleJYkbyoDqkRUGBF1tK7bWw07QEQrdZUgGmjThcbEukR2w1W
 KbYxIaUcV0/NEAXT/YBC3Kt5p56kSSjTBGLxx4EvFOTshCWDAikpQ89GflheeXbD0xi4
 lOIaxjXP5zF8ym3aTDgdCpdnR6XWztkpbsuk9cl9lm2DZG7kZXBlh/bKzv8ieXjsfRfW
 XwjA==
X-Gm-Message-State: AAQBX9eEfS+7JimO1csY3Z5t61niT7572AH6xfc/uZHujLyfw5pANXJB
 3WBAArvHYd7Dcb/4ilwp4fPQww==
X-Google-Smtp-Source: AKy350b6VhmArfjtfG5hPTUB1cljJ9QaEx7TyP53/04DDnKkbVZXFIF0jKcWKxQnKxuBsS2tM1Ls6A==
X-Received: by 2002:a17:902:fa05:b0:1a6:3af1:9c3a with SMTP id
 la5-20020a170902fa0500b001a63af19c3amr9987792plb.22.1681297063711; 
 Wed, 12 Apr 2023 03:57:43 -0700 (PDT)
Received: from localhost.localdomain ([124.123.191.81])
 by smtp.gmail.com with ESMTPSA id
 p10-20020a1709026b8a00b001a6467cfbeasm4942246plk.53.2023.04.12.03.57.37
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 12 Apr 2023 03:57:43 -0700 (PDT)
From: Naresh Kamboju <naresh.kamboju@linaro.org>
To: michael.christie@oracle.com
Date: Wed, 12 Apr 2023 16:27:34 +0530
Message-Id: <20230412105734.293024-1-naresh.kamboju@linaro.org>
In-Reply-To: <20230407200551.12660-1-michael.christie@oracle.com>
References: <20230407200551.12660-1-michael.christie@oracle.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mailman-Approved-At: Thu, 13 Apr 2023 06:55:08 +0000
Subject: [dm-devel] [PATCH v6 00/18] Use block pr_ops in LIO
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
Cc: shy828301@gmail.com, roman.gushchin@linux.dev,
 linux-nvme@lists.infradead.org, james.bottomley@hansenpartnership.com,
 linux-mm@kvack.org, dm-devel@redhat.com, target-devel@vger.kernel.org,
 hch@lst.de, bvanassche@acm.org, linux-scsi@vger.kernel.org,
 willy@infradead.org, chaitanyak@nvidia.com, ryan.roberts@arm.com,
 snitzer@kernel.org, linux-block@vger.kernel.org, lkft-triage@lists.linaro.org,
 kbusch@kernel.org, yuzhao@google.com, axboe@kernel.dk,
 martin.petersen@oracle.com, mkoutny@suse.com, akpm@linux-foundation.org,
 zokeefe@google.com, kirill.shutemov@linux.intel.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: linaro.org
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

[sorry for the adding you in CC]

While running LTP controllers test suite on this patch set applied on top of
the next-20230406 and the following kernel panic noticed on qemu-x86_64.


Lore link: https://lore.kernel.org/linux-block/20230407200551.12660-1-michael.christie@oracle.com/


cpuset_inherit 31 TPASS: mem_exclusive: Inherited information is right!
cpuset_inherit 33 TPASS: mem_hardwall: Inherited information is right!
<4>[ 1234.875309] int3: 0000 [#1] PREEMPT SMP PTI
<4>[ 1234.875748] CPU: 1 PID: 32990 Comm: umount Not tainted 6.3.0-rc5-next-20230406 #1
<4>[ 1234.875946] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.14.0-2 04/01/2014
<4>[ 1234.876062] RIP: 0010:__alloc_pages+0xdf/0x310
<4>[ 1234.876666] Code: 4c 89 45 b0 83 3d b8 1c cb 01 00 0f 85 a2 01 00 00 44 89 f0 c1 e8 03 83 e0 03 89 75 a0 89 45 c0 be 01 00 00 00 4c 89 45 98 0f <1f> 44 00 00 4d 89 c5 44 89 f0 44 89 75 a4 41 f7 c6 00 04 00 00 74
<4>[ 1234.876885] RSP: 0000:ffff8b9305f47c10 EFLAGS: 00000202
<4>[ 1234.877418] RAX: 0000000000000001 RBX: 0000000000000000 RCX: 0000000000000000
<4>[ 1234.877433] RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000140cca
<4>[ 1234.877446] RBP: ffff8b9305f47c78 R08: 0000000000000000 R09: 0000000000000000
<4>[ 1234.877460] R10: 0000000000100cca R11: 0000000000000000 R12: 0000000000000003
<4>[ 1234.877472] R13: ffff88d28b753b00 R14: 0000000000140cca R15: ffff88d2ffffb300
<4>[ 1234.877518] FS:  0000000000000000(0000) GS:ffff88d2fbd00000(0000) knlGS:0000000000000000
<4>[ 1234.877547] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
<4>[ 1234.877568] CR2: 0000000000408ee0 CR3: 0000000111432000 CR4: 00000000000006e0
<4>[ 1234.877662] Call Trace:
<4>[ 1234.877828]  <TASK>
<4>[ 1234.877954]  __folio_alloc+0x1e/0x50
<4>[ 1234.878051]  vma_alloc_folio+0x4af/0x520
<4>[ 1234.878066]  ? _raw_spin_unlock+0x1a/0x40
<4>[ 1234.878079]  ? do_wp_page+0x164/0xdd0
<4>[ 1234.878093]  ? trace_preempt_on+0x1e/0x80
<4>[ 1234.878105]  ? preempt_count_sub+0x63/0x80
<4>[ 1234.878118]  do_wp_page+0x3cb/0xdd0
<4>[ 1234.878129]  ? handle_mm_fault+0x739/0x19e0
<4>[ 1234.878142]  ? _raw_spin_lock+0x23/0x50
<4>[ 1234.878159]  handle_mm_fault+0x770/0x19e0
<4>[ 1234.878170]  ? up_write+0x52/0xe0
<4>[ 1234.878196]  do_user_addr_fault+0x4d4/0x6c0
<4>[ 1234.878210]  ? trace_hardirqs_off_finish+0x38/0x90
<4>[ 1234.878222]  exc_page_fault+0x80/0x1d0
<4>[ 1234.878234]  asm_exc_page_fault+0x2b/0x30
<4>[ 1234.878291] RIP: 0033:0x7f3f910e65f6
<4>[ 1234.878542] Code: 2f 0a 00 00 e8 5b 23 ff ff 48 89 85 60 fd ff ff 48 8b 85 88 fd ff ff 48 8b 80 e8 00 00 00 48 85 c0 74 0b 48 8b 9d 68 fd ff ff <48> 89 58 08 48 8b 85 68 fd ff ff c7 40 18 01 00 00 00 e8 43 2b fe
<4>[ 1234.878552] RSP: 002b:00007fff6f8dce50 EFLAGS: 00000206
<4>[ 1234.878563] RAX: 0000000000408ed8 RBX: 00007f3f910fe0d8 RCX: 00007f3f910c6270
<4>[ 1234.878569] RDX: 0000000000000000 RSI: 00007f3f910fe2a0 RDI: 00007fff6f8dcf10
<4>[ 1234.878575] RBP: 00007fff6f8dd110 R08: 0000000000000000 R09: 0000000000000007
<4>[ 1234.878581] R10: 0000000000000000 R11: 0000000000000008 R12: 0000000000000000
<4>[ 1234.878585] R13: 00007f3f910fe2a0 R14: 00007fff6f8dced0 R15: 0000000000000000
<4>[ 1234.878636]  </TASK>
<4>[ 1234.878693] Modules linked in:
<4>[ 1234.894886] ---[ end trace 0000000000000000 ]---
<4>[ 1234.895879] RIP: 0010:__alloc_pages+0xdf/0x310
<4>[ 1234.895921] Code: 4c 89 45 b0 83 3d b8 1c cb 01 00 0f 85 a2 01 00 00 44 89 f0 c1 e8 03 83 e0 03 89 75 a0 89 45 c0 be 01 00 00 00 4c 89 45 98 0f <1f> 44 00 00 4d 89 c5 44 89 f0 44 89 75 a4 41 f7 c6 00 04 00 00 74
<4>[ 1234.895936] RSP: 0000:ffff8b9305f47c10 EFLAGS: 00000202
<4>[ 1234.895956] RAX: 0000000000000001 RBX: 0000000000000000 RCX: 0000000000000000
<4>[ 1234.895966] RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000140cca
<4>[ 1234.895977] RBP: ffff8b9305f47c78 R08: 0000000000000000 R09: 0000000000000000
<4>[ 1234.895985] R10: 0000000000100cca R11: 0000000000000000 R12: 0000000000000003
<4>[ 1234.895993] R13: ffff88d28b753b00 R14: 0000000000140cca R15: ffff88d2ffffb300
<4>[ 1234.896003] FS:  0000000000000000(0000) GS:ffff88d2fbd00000(0000) knlGS:0000000000000000
<4>[ 1234.896016] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
<4>[ 1234.896026] CR2: 0000000000408ee0 CR3: 0000000111432000 CR4: 00000000000006e0
<0>[ 1234.896379] Kernel panic - not syncing: Fatal exception in interrupt
<0>[ 1234.900046] Kernel Offset: 0x8800000 from 0xffffffff81000000 (relocation range: 0xffffffff80000000-0xffffffffbfffffff)

Links:
https://qa-reports.linaro.org/~anders.roxell/linux-mainline-patches/build/lore_kernel_org_linux-block_20230407200551_12660-1-michael_christie_oracle_com/testrun/16172098/suite/log-parser-test/test/check-kernel-panic/log
https://qa-reports.linaro.org/~anders.roxell/linux-mainline-patches/build/lore_kernel_org_linux-block_20230407200551_12660-1-michael_christie_oracle_com/testrun/16172061/suite/log-parser-test/test/check-kernel-panic/log

https://qa-reports.linaro.org/~anders.roxell/linux-mainline-patches/build/lore_kernel_org_linux-block_20230407200551_12660-1-michael_christie_oracle_com/testrun/16172098/suite/log-parser-test/tests/
https://qa-reports.linaro.org/~anders.roxell/linux-mainline-patches/build/lore_kernel_org_linux-block_20230407200551_12660-1-michael_christie_oracle_com/testrun/16172061/suite/log-parser-test/tests/


Steps to reproduce:
-------------------

# To install tuxrun on your system globally:
# sudo pip3 install -U tuxrun==0.41.0
#
# See https://tuxrun.org/ for complete documentation.

tuxrun   \
 --runtime podman   \
 --device qemu-x86_64   \
 --kernel https://storage.tuxsuite.com/public/linaro/anders/builds/2OGpdVeBBG4Gj6aACnSdSGva2LN/bzImage   \
 --modules https://storage.tuxsuite.com/public/linaro/anders/builds/2OGpdVeBBG4Gj6aACnSdSGva2LN/modules.tar.xz   \
 --rootfs https://storage.tuxsuite.com/public/linaro/lkft/oebuilds/2OFRZUnV2Q9jOFdE3gH3Gq2v692/images/intel-corei7-64/lkft-tux-image-intel-corei7-64-20230410193144.rootfs.ext4.gz   \
 --parameters SKIPFILE=skipfile-lkft.yaml   \
 --parameters SHARD_NUMBER=10   \
 --parameters SHARD_INDEX=10   \
 --image docker.io/lavasoftware/lava-dispatcher:2023.01.0020.gc1598238f   \
 --tests ltp-controllers   \
 --timeouts boot=15 ltp-controllers=80



--
Linaro LKFT
https://lkft.linaro.org

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

