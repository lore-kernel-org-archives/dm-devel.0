Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B0E48E82CB7
	for <dm-devel@archiver.kernel.org>; Wed, 27 Sep 2023 17:34:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1695836063;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=DAG9t+HaLKeqfEWh16glpFV8tbWg6qpPSqzs+ceiG30=;
	b=d67BFbiTf6jZEyXt885l0g5ReSDmQ0s+wFhk2FWZLIhWkZUEjLleGNAi/gWOwCWExmC43M
	2fNS33yO9W5f1/hN5JiY5muZX/8NBbROhMYe7LW3WCAc92/j54E8kAp/sucJA9cRzgvAA7
	MBP/khYzz0yfUPFtE8i+FQtNrMCKEzQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-13-SZJONaJ_MzCR5q63blJEVA-1; Wed, 27 Sep 2023 13:34:20 -0400
X-MC-Unique: SZJONaJ_MzCR5q63blJEVA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 593E3811E8E;
	Wed, 27 Sep 2023 17:34:18 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id E1E2F2026D4B;
	Wed, 27 Sep 2023 17:34:17 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 9B0E81946588;
	Wed, 27 Sep 2023 17:34:12 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 3BB1A194658F
 for <dm-devel@listman.corp.redhat.com>; Wed, 27 Sep 2023 17:11:48 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 16B6F14027BB; Wed, 27 Sep 2023 17:11:48 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 0E41114027B9
 for <dm-devel@redhat.com>; Wed, 27 Sep 2023 17:11:48 +0000 (UTC)
Received: from us-smtp-inbound-delivery-1.mimecast.com (us-smtp-2.mimecast.com
 [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E1CEB3C0D184
 for <dm-devel@redhat.com>; Wed, 27 Sep 2023 17:11:47 +0000 (UTC)
Received: from mail-lf1-f72.google.com (mail-lf1-f72.google.com
 [209.85.167.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-111-1fDgPCyRMZuTN-ZYF6wH2A-1; Wed, 27 Sep 2023 13:11:45 -0400
X-MC-Unique: 1fDgPCyRMZuTN-ZYF6wH2A-1
Received: by mail-lf1-f72.google.com with SMTP id
 2adb3069b0e04-504319087d9so16491574e87.1
 for <dm-devel@redhat.com>; Wed, 27 Sep 2023 10:11:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20230601; t=1695834704; x=1696439504;
 h=content-transfer-encoding:in-reply-to:from:references:cc:to
 :content-language:subject:user-agent:mime-version:date:message-id
 :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=26ZECuIzAzrHSPBpB0H3QfUZnnLT0zZT0ILMAOLj/qo=;
 b=m4K11Xmv2xbrW2bJ9+1TuhcQIqW5Rc9zCRSXofMI5XG08ucNSDR4dZJkMvmT3khaoU
 u8RfZ3EyM4PAOH9Kz6M+3L2QRyFUHXeOyQpadnF46MicsQ2LTZC1smLyV9V2LwtvlUEy
 ELQwrmOwP4c4HDD/lWjHi6C/In0SLYa6nnf/bzYAAcLvNnamJUtisNsddmntuE7YQuMO
 qeuaENW5yjiY9R9AcuWUG7Vabt4+UjvGHYWlbguBOjIBWgaIALYtUDO4/I/f/hl5h0T7
 AzM0q2GaeuoNHSN7fvMmffOKanebIJFyoqjL3K8k2arTf27Y+f6BBCS+OyEGdFyaHHLs
 /5uA==
X-Gm-Message-State: AOJu0YyXZtmPLWhES2B8CtyEcuYregaYcxsrGiu4bBMrrD4QXA752+Yt
 KyBnl/PrbYxLAYsp7C35Z7CUfj0wqgRixVgc4yNn0/dNwztDAXWLQiXDIHkStErXYoGY0Wu4b7L
 NUt5B2xGjVfJzF7g=
X-Received: by 2002:a05:6512:2350:b0:502:fe11:a694 with SMTP id
 p16-20020a056512235000b00502fe11a694mr2554996lfu.45.1695834704177; 
 Wed, 27 Sep 2023 10:11:44 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHLwBPlXrmnb4AHD26hUp4ZPo2eKW8J8eyw+zBWId4dlPqrr3HlDYhpvIRYNLY7H1Jl/xXg5g==
X-Received: by 2002:a05:6512:2350:b0:502:fe11:a694 with SMTP id
 p16-20020a056512235000b00502fe11a694mr2554982lfu.45.1695834703656; 
 Wed, 27 Sep 2023 10:11:43 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89?
 ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
 by smtp.googlemail.com with ESMTPSA id
 ck15-20020a0564021c0f00b005342fa19070sm3665635edb.89.2023.09.27.10.11.41
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Wed, 27 Sep 2023 10:11:42 -0700 (PDT)
Message-ID: <3c25ec6f-cd33-9445-a76f-6ec2c30755f5@redhat.com>
Date: Wed, 27 Sep 2023 19:11:37 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
 Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>,
 Vlastimil Babka <vbabka@suse.cz>, David Hildenbrand <david@redhat.com>,
 quic_jhugo@quicinc.com, snitzer@kernel.org, dm <dm-devel@redhat.com>,
 Mikulas Patocka <mpatocka@redhat.com>
References: <20230315113133.11326-1-kirill.shutemov@linux.intel.com>
From: Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20230315113133.11326-1-kirill.shutemov@linux.intel.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
Subject: Re: [dm-devel] [PATCH 00/10] Fix confusion around MAX_ORDER
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
Cc: linux-arch@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

On 3/15/23 12:31, Kirill A. Shutemov wrote:
> MAX_ORDER currently defined as number of orders page allocator supports:
> user can ask buddy allocator for page order between 0 and MAX_ORDER-1.
> 
> This definition is counter-intuitive and lead to number of bugs all over
> the kernel.
> 
> Fix the bugs and then change the definition of MAX_ORDER to be
> inclusive: the range of orders user can ask from buddy allocator is
> 0..MAX_ORDER now.

Looks like this crossed with three changes that introduced new
uses of MAX_ORDER:

drivers/accel/qaic/qaic_data.c:         max_order = min(MAX_ORDER - 1, get_order(size));
drivers/md/dm-crypt.c:  unsigned int order = MAX_ORDER - 1;
drivers/md/dm-flakey.c: order = MAX_ORDER - 1;

The bugs are all benign, MAX_ORDER - 1 can simply be changed
to MAX_ORDER to be consistent with the new world order.

CCing relevant maintainers...

Paolo

> Kirill A. Shutemov (10):
>    sparc/mm: Fix MAX_ORDER usage in tsb_grow()
>    um: Fix MAX_ORDER usage in linux_main()
>    floppy: Fix MAX_ORDER usage
>    drm/i915: Fix MAX_ORDER usage in i915_gem_object_get_pages_internal()
>    genwqe: Fix MAX_ORDER usage
>    perf/core: Fix MAX_ORDER usage in rb_alloc_aux_page()
>    mm/page_reporting: Fix MAX_ORDER usage in page_reporting_register()
>    mm/slub: Fix MAX_ORDER usage in calculate_order()
>    iommu: Fix MAX_ORDER usage in __iommu_dma_alloc_pages()
>    mm, treewide: Redefine MAX_ORDER sanely
> 
>   .../admin-guide/kdump/vmcoreinfo.rst          |  2 +-
>   .../admin-guide/kernel-parameters.txt         |  2 +-
>   arch/arc/Kconfig                              |  4 +-
>   arch/arm/Kconfig                              |  9 ++---
>   arch/arm/configs/imx_v6_v7_defconfig          |  2 +-
>   arch/arm/configs/milbeaut_m10v_defconfig      |  2 +-
>   arch/arm/configs/oxnas_v6_defconfig           |  2 +-
>   arch/arm/configs/pxa_defconfig                |  2 +-
>   arch/arm/configs/sama7_defconfig              |  2 +-
>   arch/arm/configs/sp7021_defconfig             |  2 +-
>   arch/arm64/Kconfig                            | 27 ++++++-------
>   arch/arm64/include/asm/sparsemem.h            |  2 +-
>   arch/arm64/kvm/hyp/include/nvhe/gfp.h         |  2 +-
>   arch/arm64/kvm/hyp/nvhe/page_alloc.c          | 10 ++---
>   arch/csky/Kconfig                             |  2 +-
>   arch/ia64/Kconfig                             |  8 ++--
>   arch/ia64/include/asm/sparsemem.h             |  4 +-
>   arch/ia64/mm/hugetlbpage.c                    |  2 +-
>   arch/loongarch/Kconfig                        | 15 +++-----
>   arch/m68k/Kconfig.cpu                         |  5 +--
>   arch/mips/Kconfig                             | 19 ++++------
>   arch/nios2/Kconfig                            |  7 +---
>   arch/powerpc/Kconfig                          | 27 ++++++-------
>   arch/powerpc/configs/85xx/ge_imp3a_defconfig  |  2 +-
>   arch/powerpc/configs/fsl-emb-nonhw.config     |  2 +-
>   arch/powerpc/mm/book3s64/iommu_api.c          |  2 +-
>   arch/powerpc/mm/hugetlbpage.c                 |  2 +-
>   arch/powerpc/platforms/powernv/pci-ioda.c     |  2 +-
>   arch/sh/configs/ecovec24_defconfig            |  2 +-
>   arch/sh/mm/Kconfig                            | 17 ++++-----
>   arch/sparc/Kconfig                            |  5 +--
>   arch/sparc/kernel/pci_sun4v.c                 |  2 +-
>   arch/sparc/kernel/traps_64.c                  |  2 +-
>   arch/sparc/mm/tsb.c                           |  4 +-
>   arch/xtensa/Kconfig                           |  5 +--
>   drivers/base/regmap/regmap-debugfs.c          |  8 ++--
>   drivers/block/floppy.c                        |  2 +-
>   drivers/crypto/ccp/sev-dev.c                  |  2 +-
>   drivers/crypto/hisilicon/sgl.c                |  6 +--
>   .../gpu/drm/i915/gem/selftests/huge_pages.c   |  2 +-
>   drivers/gpu/drm/ttm/ttm_pool.c                | 22 +++++------
>   drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   |  2 +-
>   drivers/iommu/dma-iommu.c                     |  4 +-
>   drivers/irqchip/irq-gic-v3-its.c              |  4 +-
>   drivers/md/dm-bufio.c                         |  2 +-
>   drivers/misc/genwqe/card_utils.c              |  2 +-
>   .../net/ethernet/hisilicon/hns3/hns3_enet.c   |  2 +-
>   drivers/net/ethernet/ibm/ibmvnic.h            |  2 +-
>   drivers/video/fbdev/hyperv_fb.c               |  4 +-
>   drivers/video/fbdev/vermilion/vermilion.c     |  2 +-
>   drivers/virtio/virtio_balloon.c               |  2 +-
>   drivers/virtio/virtio_mem.c                   | 12 +++---
>   fs/ramfs/file-nommu.c                         |  2 +-
>   include/drm/ttm/ttm_pool.h                    |  2 +-
>   include/linux/hugetlb.h                       |  2 +-
>   include/linux/mmzone.h                        | 10 ++---
>   include/linux/pageblock-flags.h               |  4 +-
>   include/linux/slab.h                          |  6 +--
>   kernel/crash_core.c                           |  2 +-
>   kernel/dma/pool.c                             |  6 +--
>   mm/Kconfig                                    |  6 +--
>   mm/compaction.c                               |  8 ++--
>   mm/debug_vm_pgtable.c                         |  4 +-
>   mm/huge_memory.c                              |  2 +-
>   mm/hugetlb.c                                  |  4 +-
>   mm/kmsan/init.c                               |  6 +--
>   mm/memblock.c                                 |  2 +-
>   mm/memory_hotplug.c                           |  4 +-
>   mm/page_alloc.c                               | 38 +++++++++----------
>   mm/page_isolation.c                           | 12 +++---
>   mm/page_owner.c                               |  6 +--
>   mm/page_reporting.c                           |  4 +-
>   mm/shuffle.h                                  |  2 +-
>   mm/slab.c                                     |  2 +-
>   mm/slub.c                                     |  4 +-
>   mm/vmscan.c                                   |  2 +-
>   mm/vmstat.c                                   | 14 +++----
>   net/smc/smc_ib.c                              |  2 +-
>   security/integrity/ima/ima_crypto.c           |  2 +-
>   tools/testing/memblock/linux/mmzone.h         |  6 +--
>   80 files changed, 210 insertions(+), 240 deletions(-)
> 

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

