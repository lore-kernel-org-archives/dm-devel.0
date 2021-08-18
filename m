Return-Path: <SRS0=iWw/=NJ=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF0CCC4338F
	for <dm-devel@archiver.kernel.org>; Wed, 18 Aug 2021 02:56:57 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 1A2ED60EB5
	for <dm-devel@archiver.kernel.org>; Wed, 18 Aug 2021 02:56:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 1A2ED60EB5
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-326-lGMt9ZwqO5i8xMwYZJZ0yg-1; Tue, 17 Aug 2021 22:56:53 -0400
X-MC-Unique: lGMt9ZwqO5i8xMwYZJZ0yg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 68F6F107ACF5;
	Wed, 18 Aug 2021 02:56:48 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A1B15669F3;
	Wed, 18 Aug 2021 02:56:44 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id C2D80181A2A6;
	Wed, 18 Aug 2021 02:56:39 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 17I2q6Ss028016 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 17 Aug 2021 22:52:06 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 2FF8CDAF17; Wed, 18 Aug 2021 02:52:06 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 2A54EDAF1A
	for <dm-devel@redhat.com>; Wed, 18 Aug 2021 02:52:02 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AAC7389B846
	for <dm-devel@redhat.com>; Wed, 18 Aug 2021 02:52:02 +0000 (UTC)
Received: from mail-oi1-f175.google.com (mail-oi1-f175.google.com
	[209.85.167.175]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-1-xJ2k5oyFN3WcqOCO7V26zg-1; Tue, 17 Aug 2021 22:51:58 -0400
X-MC-Unique: xJ2k5oyFN3WcqOCO7V26zg-1
Received: by mail-oi1-f175.google.com with SMTP id r5so2394067oiw.7;
	Tue, 17 Aug 2021 19:51:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
	:references:mime-version:content-disposition:in-reply-to;
	bh=gR1veNMGC14is8LPAt1goYpJishKVSHpg56w20pfWgo=;
	b=hS2wjIcrWalQ/FZOgPHT0Ioc4D/0wmpMDO+N/vHMrcTIWfWOYVhE0yhwHhrK/9xlHM
	KgVkC82+mUnE8dU4KnvoJS5TOCDCt60fj9XKG9lrI2PUF64H4Uu5WygZAidMMKqul4Jf
	uS4RSmub9uuYgurRWwmIvK9PRhU8kiDkwHdb4+d9Xg5zAnjzbP7SNlY+s3B3XX8ewC/t
	k0M64FGBygsKhpnqztZGj/RGuV60JE9URvyne1z6/XTDKsML4iMRgAn4RN7uCEt/0Pkz
	BOjXpK3c+OF3CG7iaMVsp876pq2wwYaVnhFtIgOlCVj96erxT9spVOtFw+bDKXbehqlf
	8zMQ==
X-Gm-Message-State: AOAM532B8VzsgM2+efHGZMfmj7JnP+/oHD5nGBd+UHT5KkSq1SJKRVFd
	Y2Yrwpn6M6IOuWFiuu+tzJueEcipQuI=
X-Google-Smtp-Source: ABdhPJxUv6NTZV1Vxnpmo3kV0/q77w+d5RMSzBT6M78NDrnjw/JaNwb/MRdkLeAFsy5Z1LHnlaamkA==
X-Received: by 2002:a54:4791:: with SMTP id o17mr5371146oic.133.1629255116417; 
	Tue, 17 Aug 2021 19:51:56 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
	by smtp.gmail.com with ESMTPSA id
	bf41sm951554oib.41.2021.08.17.19.51.54
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Tue, 17 Aug 2021 19:51:55 -0700 (PDT)
Date: Tue, 17 Aug 2021 19:51:53 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Christoph Hellwig <hch@lst.de>
Message-ID: <20210818025153.GA1053733@roeck-us.net>
References: <20210804094147.459763-1-hch@lst.de>
	<20210804094147.459763-5-hch@lst.de>
	<20210814211309.GA616511@roeck-us.net>
	<20210815070724.GA23276@lst.de>
	<a8d66952-ee44-d3fa-d699-439415b9abfe@roeck-us.net>
	<20210816072158.GA27147@lst.de>
MIME-Version: 1.0
In-Reply-To: <20210816072158.GA27147@lst.de>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-loop: dm-devel@redhat.com
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
	dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>
Subject: Re: [dm-devel] [PATCH 4/8] block: support delayed holder
	registration
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Mon, Aug 16, 2021 at 09:21:58AM +0200, Christoph Hellwig wrote:
> On Sun, Aug 15, 2021 at 07:27:37AM -0700, Guenter Roeck wrote:
> > [   14.467748][    T1]  Possible unsafe locking scenario:
> > [   14.467748][    T1]
> > [   14.467928][    T1]        CPU0                    CPU1
> > [   14.468058][    T1]        ----                    ----
> > [   14.468187][    T1]   lock(&disk->open_mutex);
> > [   14.468317][    T1]                                lock(mtd_table_mutex);
> > [   14.468493][    T1]                                lock(&disk->open_mutex);
> > [   14.468671][    T1]   lock(mtd_table_mutex);
> 
> Oh, that ooks like a really old one, fixed by
> b7abb0516822 ("mtd: fix lock hierarchy in deregister_mtd_blktrans")
> in linux-next.

I tested again with next-20210817. The problem is still there, and
reverting commit d62633873590 ("block: support delayed holder
registration") still fixes it. A complete boot log is attached
for reference.

Guenter

---
Build reference: next-20210817

qemu log:
[    0.010915815,5] OPAL v6.4 starting...
[    0.011392739,7] initial console log level: memory 7, driver 5
[    0.011422553,6] CPU: P9 generation processor (max 4 threads/core)
[    0.011437437,7] CPU: Boot CPU PIR is 0x0000 PVR is 0x004e1200
[    0.011524734,7] OPAL table: 0x30101830 .. 0x30101da0, branch table: 0x30002000
[    0.011667083,7] Assigning physical memory map table for nimbus
[    0.011914730,7] FDT: Parsing fdt @0x1000000
[    0.013589817,5] CHIP: Detected Qemu simulator
[    0.013713155,6] CHIP: Initialised chip 0 from xscom@603fc00000000
[    0.013992710,6] P9 DD2.00 detected
[    0.014006187,5] CHIP: Chip ID 0000 type: P9N DD2.00
[    0.014012448,7] XSCOM: Base address: 0x603fc00000000
[    0.014031889,7] XSTOP: ibm,sw-checkstop-fir prop not found
[    0.014094328,6] MFSI 0:0: Initialized
[    0.014102372,6] MFSI 0:2: Initialized
[    0.014109468,6] MFSI 0:1: Initialized
[    0.014477509,6] LPC: LPC[000]: Initialized
[    0.014483986,7] LPC: access via MMIO @0x6030000000000
[    0.014513616,7] LPC: Default bus on chip 0x0
[    0.014579301,7] CPU: New max PIR set to 0x3
[    0.014944450,7] MEM: parsing reserved memory from reserved-names/-ranges properties
[    0.015013478,7] CPU: decrementer bits 56
[    0.015059057,6] CPU: CPU from DT PIR=0x0000 Server#=0x0 State=3
[    0.015116735,6] CPU:  1 secondary threads
[    0.016079682,5] PLAT: Using SuperIO UART
[    0.016285800,7] UART: Using LPC IRQ 4
[    0.017744314,5] PLAT: Detected QEMU POWER9 platform
[    0.017803645,5] PLAT: Detected BMC platform ast2500:openbmc
[    0.033090750,5] CPU: All 1 processors called in...
[    0.033389379,3] SBE: Master chip ID not found.
[    0.033807105,7] LPC: Routing irq 10, policy: 0 (r=1)
[    0.033866006,7] LPC: SerIRQ 10 using route 0 targetted at OPAL
[    0.055456502,5] HIOMAP: Negotiated hiomap protocol v2
[    0.055559088,5] HIOMAP: Block size is 4KiB
[    0.055635761,5] HIOMAP: BMC suggested flash timeout of 0s
[    0.055732832,5] HIOMAP: Flash size is 32MiB
[    0.055809489,5] HIOMAP: Erase granule size is 4KiB
[    0.072601777,4] FLASH: No ffs info; using raw device only
[    0.078031760,3] FLASH: Can't open ffs handle
[    0.083329630,3] FLASH: Can't open ffs handle
[    0.088614080,3] FLASH: Can't open ffs handle
[    0.093896205,3] FLASH: Can't open ffs handle
[    0.099174034,3] FLASH: Can't open ffs handle
[    0.104454746,3] FLASH: Can't open ffs handle
[    0.115977110,2] NVRAM: Failed to load
[    0.116068253,2] NVRAM: Failed to load
[    0.116173219,5] STB: secure boot not supported
[    0.116283085,5] STB: trusted boot not supported
[    0.116683004,4] FLASH: Can't load resource id:4. No system flash found
[    0.117069713,4] FLASH: Can't load resource id:3. No system flash found
[    0.117269585,2] NVRAM: Failed to load
[    0.117490209,7] LPC: Routing irq 4, policy: 0 (r=1)
[    0.117514888,7] LPC: SerIRQ 4 using route 1 targetted at OPAL
[    0.117933346,3] SLW: HOMER base not set 0
[    0.118081064,5] Unable to log error
[    0.118227237,2] NVRAM: Failed to load
[    0.118442741,3] OCC: No HOMER detected, assuming no pstates
[    0.118501222,5] Unable to log error
[    0.118555649,2] NVRAM: Failed to load
[    0.118604663,2] NVRAM: Failed to load
[    0.118720628,4] FLASH: Can't load resource id:2. No system flash found
[    0.118912385,4] FLASH: Can't load resource id:0. No system flash found
[    0.118983574,4] FLASH: Can't load resource id:1. No system flash found
[    0.119116640,3] IMC: IMC Catalog load failed
[    0.119364768,2] NVRAM: Failed to load
[    0.119406236,2] NVRAM: Failed to load
[    0.119444636,2] NVRAM: Failed to load
[    0.119482315,2] NVRAM: Failed to load
[    0.131102078,3] CAPP: Error loading ucode lid. index=200d1
[    0.150206406,2] NVRAM: Failed to load
[    0.160574726,5] PCI: Resetting PHBs and training links...
[    6.170966934,5] PCI: Probing slots...
[    6.175681253,5] PCI Summary:
[    6.176039126,5] PHB#0000:00:00.0 [ROOT] 1014 04c1 R:00 C:060400 B:01..01 
[    6.176342301,5] PHB#0000:01:00.0 [PCID] 10ec 8139 R:20 C:020000 (      ethernet) 
[    6.176532516,5] PHB#0001:00:00.0 [ROOT] 1014 04c1 R:00 C:060400 B:00..00 
[    6.176658081,5] PHB#0002:00:00.0 [ROOT] 1014 04c1 R:00 C:060400 B:00..00 
[    6.176779913,5] PHB#0003:00:00.0 [ROOT] 1014 04c1 R:00 C:060400 B:00..00 
[    6.176904577,5] PHB#0004:00:00.0 [ROOT] 1014 04c1 R:00 C:060400 B:00..00 
[    6.177035788,5] PHB#0005:00:00.0 [ROOT] 1014 04c1 R:00 C:060400 B:00..00 
[    6.177260815,4] FLASH: Failed to load VERSION data
[    6.312317126,5] INIT: Waiting for kernel...
[    6.312368972,5] INIT: platform wait for kernel load failed
[    6.312433234,5] INIT: Assuming kernel at 0x20000000
[    6.312515708,5] INIT: 64-bit LE kernel discovered
[    6.312673483,3] OCC: Unassigned OCC Common Area. No sensors found
[    6.312827720,2] NVRAM: Failed to load
[    6.370807692,5] INIT: Starting kernel at 0x20010000, fdt at 0x306c9818 24120 bytes

zImage starting: loaded at 0x0000000020010000 (sp: 0x00000000209e7ed8)
Allocating 0x2647d20 bytes for kernel...
Decompressing (0x0000000000000000 <- 0x0000000020021000:0x00000000209e6ea9)...
Done! Decompressed 0x1a7ebf4 bytes

Linux/PowerPC load: panic=-1 slub_debug=FZPUA root=/dev/mtdblock0 console=tty console=hvc0
Finalizing device tree... flat tree at 0x209e8ca0
[    0.000000][    T0] dt-cpu-ftrs: setup for ISA 3000
[    0.000000][    T0] dt-cpu-ftrs: final cpu/mmu features = 0x0003c06b8f5fb187 0x3c007041
[    0.000000][    T0] Activating Kernel Userspace Execution Prevention
[    0.000000][    T0] Activating Kernel Userspace Access Prevention
[    0.000000][    T0] radix-mmu: Mapped 0x0000000000000000-0x0000000001740000 with 64.0 KiB pages (exec)
[    0.000000][    T0] radix-mmu: Mapped 0x0000000001740000-0x0000000080000000 with 64.0 KiB pages
[    0.000000][    T0] radix-mmu: Initializing Radix MMU
[    0.000000][    T0] Linux version 5.14.0-rc6-next-20210817 (groeck@server.roeck-us.net) (powerpc64-linux-gcc.br_real (Buildroot 2019.02-git-00353-g4f20f23) 7.4.0, GNU ld (GNU Binutils) 2.31.1) #1 SMP Tue Aug 17 19:13:07 PDT 2021
[    0.000000][    T0] Using PowerNV machine description
[    0.000000][    T0] printk: bootconsole [udbg0] enabled
[    0.000000][    T0] CPU maps initialized for 1 thread per core
[    0.000000][    T0] -----------------------------------------------------
[    0.000000][    T0] phys_mem_size     = 0x80000000
[    0.000000][    T0] dcache_bsize      = 0x80
[    0.000000][    T0] icache_bsize      = 0x80
[    0.000000][    T0] cpu_features      = 0x0003c06b8f4fb187
[    0.000000][    T0]   possible        = 0x000ffbfbcf5fb187
[    0.000000][    T0]   always          = 0x0000000380008181
[    0.000000][    T0] cpu_user_features = 0xdc0065c2 0xaef00000
[    0.000000][    T0] mmu_features      = 0x3c007641
[    0.000000][    T0] firmware_features = 0x0000000010000000
[    0.000000][    T0] vmalloc start     = 0xc008000000000000
[    0.000000][    T0] IO start          = 0xc00a000000000000
[    0.000000][    T0] vmemmap start     = 0xc00c000000000000
[    0.000000][    T0] -----------------------------------------------------
[    0.000000][    T0] kvm_cma_reserve: reserving 102 MiB for global area
[    0.000000][    T0] cma: Reserved 112 MiB at 0x0000000073000000
[    0.000000][    T0] numa:   NODE_DATA [mem 0x7bf7ae00-0x7bf7ffff]
[    0.000000][    T0] rfi-flush: fallback displacement flush available
[    0.000000][    T0] count-cache-flush: flush disabled.
[    0.000000][    T0] link-stack-flush: flush disabled.
[    0.000000][    T0] stf-barrier: eieio barrier available
[    0.000000][    T0] barrier-nospec: using ORI speculation barrier
[    0.000000][    T0] Zone ranges:
[    0.000000][    T0]   Normal   [mem 0x0000000000000000-0x000000007fffffff]
[    0.000000][    T0] Movable zone start for each node
[    0.000000][    T0] Early memory node ranges
[    0.000000][    T0]   node   0: [mem 0x0000000000000000-0x000000007fffffff]
[    0.000000][    T0] Initmem setup node 0 [mem 0x0000000000000000-0x000000007fffffff]
[    0.000000][    T0] percpu: Embedded 11 pages/cpu s645968 r0 d74928 u720896
[    0.000000][    T0] Built 1 zonelists, mobility grouping on.  Total pages: 32736
[    0.000000][    T0] Policy zone: Normal
[    0.000000][    T0] Kernel command line: panic=-1 slub_debug=FZPUA root=/dev/mtdblock0 console=tty console=hvc0
[    0.000000][    T0] Dentry cache hash table entries: 262144 (order: 5, 2097152 bytes, linear)
[    0.000000][    T0] Inode-cache hash table entries: 131072 (order: 4, 1048576 bytes, linear)
[    0.000000][    T0] mem auto-init: stack:off, heap alloc:off, heap free:off
[    0.000000][    T0] Memory: 0K/2097152K available (17152K kernel code, 3328K rwdata, 4608K rodata, 1984K init, 12063K bss, 173440K reserved, 114688K cma-reserved)
[    0.000000][    T0] **********************************************************
[    0.000000][    T0] **   NOTICE NOTICE NOTICE NOTICE NOTICE NOTICE NOTICE   **
[    0.000000][    T0] **                                                      **
[    0.000000][    T0] ** This system shows unhashed kernel memory addresses   **
[    0.000000][    T0] ** via the console, logs, and other interfaces. This    **
[    0.000000][    T0] ** might reduce the security of your system.            **
[    0.000000][    T0] **                                                      **
[    0.000000][    T0] ** If you see this message and you are not debugging    **
[    0.000000][    T0] ** the kernel, report this immediately to your system   **
[    0.000000][    T0] ** administrator!                                       **
[    0.000000][    T0] **                                                      **
[    0.000000][    T0] **   NOTICE NOTICE NOTICE NOTICE NOTICE NOTICE NOTICE   **
[    0.000000][    T0] **********************************************************
[    0.000000][    T0] SLUB: HWalign=128, Order=0-3, MinObjects=0, CPUs=1, Nodes=1
[    0.000000][    T0] ftrace: allocating 36425 entries in 14 pages
[    0.000000][    T0] ftrace: allocated 14 pages with 3 groups
[    0.000000][    T0] trace event string verifier disabled
[    0.000000][    T0] Running RCU self tests
[    0.000000][    T0] rcu: Hierarchical RCU implementation.
[    0.000000][    T0] rcu: 	RCU event tracing is enabled.
[    0.000000][    T0] rcu: 	RCU lockdep checking is enabled.
[    0.000000][    T0] rcu: 	RCU restricting CPUs from NR_CPUS=2048 to nr_cpu_ids=1.
[    0.000000][    T0] rcu: 	RCU debug extended QS entry/exit.
[    0.000000][    T0] 	Rude variant of Tasks RCU enabled.
[    0.000000][    T0] 	Tracing variant of Tasks RCU enabled.
[    0.000000][    T0] rcu: RCU calculated value of scheduler-enlistment delay is 10 jiffies.
[    0.000000][    T0] rcu: Adjusting geometry for rcu_fanout_leaf=16, nr_cpu_ids=1
[    0.000000][    T0] NR_IRQS: 512, nr_irqs: 512, preallocated irqs: 16
[    0.000000][    T0] xive: Interrupt handling initialized with native backend
[    0.000000][    T0] xive: Using priority 7 for all interrupts
[    0.000000][    T0] xive: Using 64kB queues
[    0.000000][    T0] random: get_random_u64 called from start_kernel+0x680/0x8e8 with crng_init=0
[    0.000090][    T0] time_init: 56 bit decrementer (max: 7fffffffffffff)
[    0.001865][    T0] clocksource: timebase: mask: 0xffffffffffffffff max_cycles: 0x761537d007, max_idle_ns: 440795202126 ns
[    0.004659][    T0] clocksource: timebase mult[1f40000] shift[24] registered
[    0.012714][    T0] Console: colour dummy device 80x25
[    0.026090][    T0] printk: console [tty0] enabled
[    0.026571][    T0] printk: console [hvc0] enabled
[    0.026571][    T0] printk: console [hvc0] enabled
[    0.027221][    T0] printk: bootconsole [udbg0] disabled
[    0.027221][    T0] printk: bootconsole [udbg0] disabled
[    0.028092][    T0] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
[    0.028424][    T0] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.028613][    T0] ... MAX_LOCK_DEPTH:          48
[    0.028800][    T0] ... MAX_LOCKDEP_KEYS:        8192
[    0.028989][    T0] ... CLASSHASH_SIZE:          4096
[    0.029185][    T0] ... MAX_LOCKDEP_ENTRIES:     32768
[    0.029381][    T0] ... MAX_LOCKDEP_CHAINS:      65536
[    0.029574][    T0] ... CHAINHASH_SIZE:          32768
[    0.029768][    T0]  memory used by lock dependency info: 6365 kB
[    0.029997][    T0]  memory used for stack traces: 4224 kB
[    0.030204][    T0]  per task-struct memory footprint: 1920 bytes
[    0.030467][    T0] ------------------------
[    0.030645][    T0] | Locking API testsuite:
[    0.030819][    T0] ----------------------------------------------------------------------------
[    0.035275][    T0]                                  | spin |wlock |rlock |mutex | wsem | rsem |
[    0.035616][    T0]   --------------------------------------------------------------------------
[    0.036183][    T0]                      A-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.049825][    T0]                  A-B-B-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.064240][    T0]              A-B-B-C-C-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.086497][    T0]              A-B-C-A-B-C deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.103109][    T0]          A-B-B-C-C-D-D-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.122436][    T0]          A-B-C-D-B-D-D-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.141864][    T0]          A-B-C-D-B-C-D-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.161418][    T0]                     double unlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.173155][    T0]                   initialize held:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.183712][    T0]   --------------------------------------------------------------------------
[    0.184041][    T0]               recursive read-lock:             |  ok  |             |  ok  |
[    0.187988][    T0]            recursive read-lock #2:             |  ok  |             |  ok  |
[    0.191588][    T0]             mixed read-write-lock:             |  ok  |             |  ok  |
[    0.195301][    T0]             mixed write-read-lock:             |  ok  |             |  ok  |
[    0.198850][    T0]   mixed read-lock/lock-write ABBA:             |  ok  |             |  ok  |
[    0.202797][    T0]    mixed read-lock/lock-read ABBA:             |  ok  |             |  ok  |
[    0.207250][    T0]  mixed write-lock/lock-write ABBA:             |  ok  |             |  ok  |
[    0.211513][    T0]   chain cached mixed R-L/L-W ABBA:             |  ok  |
[    0.213847][    T0]          rlock W1R2/W2R3/W3R1/123:             |  ok  |
[    0.216917][    T0]          rlock W1R2/W2R3/W3R1/132:             |  ok  |
[    0.219589][    T0]          rlock W1R2/W2R3/W3R1/213:             |  ok  |
[    0.222209][    T0]          rlock W1R2/W2R3/W3R1/231:             |  ok  |
[    0.224828][    T0]          rlock W1R2/W2R3/W3R1/312:             |  ok  |
[    0.227578][    T0]          rlock W1R2/W2R3/W3R1/321:             |  ok  |
[    0.230260][    T0]          rlock W1W2/R2R3/W3R1/123:             |  ok  |
[    0.232933][    T0]          rlock W1W2/R2R3/W3R1/132:             |  ok  |
[    0.235588][    T0]          rlock W1W2/R2R3/W3R1/213:             |  ok  |
[    0.238346][    T0]          rlock W1W2/R2R3/W3R1/231:             |  ok  |
[    0.241010][    T0]          rlock W1W2/R2R3/W3R1/312:             |  ok  |
[    0.243660][    T0]          rlock W1W2/R2R3/W3R1/321:             |  ok  |
[    0.246311][    T0]          rlock W1W2/R2R3/R3W1/123:             |  ok  |
[    0.249064][    T0]          rlock W1W2/R2R3/R3W1/132:             |  ok  |
[    0.251699][    T0]          rlock W1W2/R2R3/R3W1/213:             |  ok  |
[    0.254318][    T0]          rlock W1W2/R2R3/R3W1/231:             |  ok  |
[    0.256931][    T0]          rlock W1W2/R2R3/R3W1/312:             |  ok  |
[    0.259677][    T0]          rlock W1W2/R2R3/R3W1/321:             |  ok  |
[    0.262346][    T0]          rlock W1R2/R2R3/W3W1/123:             |  ok  |
[    0.264978][    T0]          rlock W1R2/R2R3/W3W1/132:             |  ok  |
[    0.267613][    T0]          rlock W1R2/R2R3/W3W1/213:             |  ok  |
[    0.270324][    T0]          rlock W1R2/R2R3/W3W1/231:             |  ok  |
[    0.272953][    T0]          rlock W1R2/R2R3/W3W1/312:             |  ok  |
[    0.275577][    T0]          rlock W1R2/R2R3/W3W1/321:             |  ok  |
[    0.278228][    T0]   --------------------------------------------------------------------------
[    0.278553][    T0]      hard-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |
[    0.283971][    T0]      soft-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |
[    0.289507][    T0]      hard-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |
[    0.294903][    T0]      soft-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |
[    0.300069][    T0]        sirq-safe-A => hirqs-on/12:  ok  |  ok  |  ok  |
[    0.305415][    T0]        sirq-safe-A => hirqs-on/21:  ok  |  ok  |  ok  |
[    0.310652][    T0]          hard-safe-A + irqs-on/12:  ok  |  ok  |  ok  |
[    0.316082][    T0]          soft-safe-A + irqs-on/12:  ok  |  ok  |  ok  |
[    0.321303][    T0]          hard-safe-A + irqs-on/21:  ok  |  ok  |  ok  |
[    0.326734][    T0]          soft-safe-A + irqs-on/21:  ok  |  ok  |  ok  |
[    0.331984][    T0]     hard-safe-A + unsafe-B #1/123:  ok  |  ok  |  ok  |
[    0.338422][    T0]     soft-safe-A + unsafe-B #1/123:  ok  |  ok  |  ok  |
[    0.345541][    T0]     hard-safe-A + unsafe-B #1/132:  ok  |  ok  |  ok  |
[    0.356619][    T0]     soft-safe-A + unsafe-B #1/132:  ok  |  ok  |  ok  |
[    0.362796][    T0]     hard-safe-A + unsafe-B #1/213:  ok  |  ok  |  ok  |
[    0.369123][    T0]     soft-safe-A + unsafe-B #1/213:  ok  |  ok  |  ok  |
[    0.375299][    T0]     hard-safe-A + unsafe-B #1/231:  ok  |  ok  |  ok  |
[    0.381629][    T0]     soft-safe-A + unsafe-B #1/231:  ok  |  ok  |  ok  |
[    0.387777][    T0]     hard-safe-A + unsafe-B #1/312:  ok  |  ok  |  ok  |
[    0.393484][    T0]     soft-safe-A + unsafe-B #1/312:  ok  |  ok  |  ok  |
[    0.399117][    T0]     hard-safe-A + unsafe-B #1/321:  ok  |  ok  |  ok  |
[    0.405361][    T0]     soft-safe-A + unsafe-B #1/321:  ok  |  ok  |  ok  |
[    0.411995][    T0]     hard-safe-A + unsafe-B #2/123:  ok  |  ok  |  ok  |
[    0.418450][    T0]     soft-safe-A + unsafe-B #2/123:  ok  |  ok  |  ok  |
[    0.424913][    T0]     hard-safe-A + unsafe-B #2/132:  ok  |  ok  |  ok  |
[    0.431446][    T0]     soft-safe-A + unsafe-B #2/132:  ok  |  ok  |  ok  |
[    0.437784][    T0]     hard-safe-A + unsafe-B #2/213:  ok  |  ok  |  ok  |
[    0.447485][    T0]     soft-safe-A + unsafe-B #2/213:  ok  |  ok  |  ok  |
[    0.455678][    T0]     hard-safe-A + unsafe-B #2/231:  ok  |  ok  |  ok  |
[    0.462876][    T0]     soft-safe-A + unsafe-B #2/231:  ok  |  ok  |  ok  |
[    0.469234][    T0]     hard-safe-A + unsafe-B #2/312:  ok  |  ok  |  ok  |
[    0.475729][    T0]     soft-safe-A + unsafe-B #2/312:  ok  |  ok  |  ok  |
[    0.481936][    T0]     hard-safe-A + unsafe-B #2/321:  ok  |  ok  |  ok  |
[    0.488372][    T0]     soft-safe-A + unsafe-B #2/321:  ok  |  ok  |  ok  |
[    0.494631][    T0]       hard-irq lock-inversion/123:  ok  |  ok  |  ok  |
[    0.501236][    T0]       soft-irq lock-inversion/123:  ok  |  ok  |  ok  |
[    0.507923][    T0]       hard-irq lock-inversion/132:  ok  |  ok  |  ok  |
[    0.514774][    T0]       soft-irq lock-inversion/132:  ok  |  ok  |  ok  |
[    0.521709][    T0]       hard-irq lock-inversion/213:  ok  |  ok  |  ok  |
[    0.528010][    T0]       soft-irq lock-inversion/213:  ok  |  ok  |  ok  |
[    0.535301][    T0]       hard-irq lock-inversion/231:  ok  |  ok  |  ok  |
[    0.541693][    T0]       soft-irq lock-inversion/231:  ok  |  ok  |  ok  |
[    0.548029][    T0]       hard-irq lock-inversion/312:  ok  |  ok  |  ok  |
[    0.554493][    T0]       soft-irq lock-inversion/312:  ok  |  ok  |  ok  |
[    0.561569][    T0]       hard-irq lock-inversion/321:  ok  |  ok  |  ok  |
[    0.568094][    T0]       soft-irq lock-inversion/321:  ok  |  ok  |  ok  |
[    0.574559][    T0]       hard-irq read-recursion/123:      |  ok  |  ok  |
[    0.578977][    T0]       soft-irq read-recursion/123:      |  ok  |  ok  |
[    0.583251][    T0]       hard-irq read-recursion/132:      |  ok  |  ok  |
[    0.587936][    T0]       soft-irq read-recursion/132:      |  ok  |  ok  |
[    0.592573][    T0]       hard-irq read-recursion/213:      |  ok  |  ok  |
[    0.596938][    T0]       soft-irq read-recursion/213:      |  ok  |  ok  |
[    0.600913][    T0]       hard-irq read-recursion/231:      |  ok  |  ok  |
[    0.604965][    T0]       soft-irq read-recursion/231:      |  ok  |  ok  |
[    0.609102][    T0]       hard-irq read-recursion/312:      |  ok  |  ok  |
[    0.613560][    T0]       soft-irq read-recursion/312:      |  ok  |  ok  |
[    0.618017][    T0]       hard-irq read-recursion/321:      |  ok  |  ok  |
[    0.622508][    T0]       soft-irq read-recursion/321:      |  ok  |  ok  |
[    0.626868][    T0]    hard-irq read-recursion #2/123:      |  ok  |  ok  |
[    0.631391][    T0]    soft-irq read-recursion #2/123:      |  ok  |  ok  |
[    0.635753][    T0]    hard-irq read-recursion #2/132:      |  ok  |  ok  |
[    0.640608][    T0]    soft-irq read-recursion #2/132:      |  ok  |  ok  |
[    0.644958][    T0]    hard-irq read-recursion #2/213:      |  ok  |  ok  |
[    0.649470][    T0]    soft-irq read-recursion #2/213:      |  ok  |  ok  |
[    0.653954][    T0]    hard-irq read-recursion #2/231:      |  ok  |  ok  |
[    0.658352][    T0]    soft-irq read-recursion #2/231:      |  ok  |  ok  |
[    0.663008][    T0]    hard-irq read-recursion #2/312:      |  ok  |  ok  |
[    0.667407][    T0]    soft-irq read-recursion #2/312:      |  ok  |  ok  |
[    0.671847][    T0]    hard-irq read-recursion #2/321:      |  ok  |  ok  |
[    0.676744][    T0]    soft-irq read-recursion #2/321:      |  ok  |  ok  |
[    0.681763][    T0]    hard-irq read-recursion #3/123:      |  ok  |  ok  |
[    0.686669][    T0]    soft-irq read-recursion #3/123:      |  ok  |  ok  |
[    0.691021][    T0]    hard-irq read-recursion #3/132:      |  ok  |  ok  |
[    0.695718][    T0]    soft-irq read-recursion #3/132:      |  ok  |  ok  |
[    0.700074][    T0]    hard-irq read-recursion #3/213:      |  ok  |  ok  |
[    0.704752][    T0]    soft-irq read-recursion #3/213:      |  ok  |  ok  |
[    0.713237][    T0]    hard-irq read-recursion #3/231:      |  ok  |  ok  |
[    0.718254][    T0]    soft-irq read-recursion #3/231:      |  ok  |  ok  |
[    0.722683][    T0]    hard-irq read-recursion #3/312:      |  ok  |  ok  |
[    0.727007][    T0]    soft-irq read-recursion #3/312:      |  ok  |  ok  |
[    0.731373][    T0]    hard-irq read-recursion #3/321:      |  ok  |  ok  |
[    0.735706][    T0]    soft-irq read-recursion #3/321:      |  ok  |  ok  |
[    0.739976][    T0]   --------------------------------------------------------------------------
[    0.740294][    T0]   | Wound/wait tests |
[    0.740456][    T0]   ---------------------
[    0.740616][    T0]                   ww api failures:  ok  |  ok  |  ok  |
[    0.747943][    T0]                ww contexts mixing:  ok  |  ok  |
[    0.751839][    T0]              finishing ww context:  ok  |  ok  |  ok  |  ok  |
[    0.759807][    T0]                locking mismatches:  ok  |  ok  |  ok  |
[    0.765794][    T0]                  EDEADLK handling:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.786926][    T0]            spinlock nest unlocked:  ok  |
[    0.788813][    T0]                spinlock nest test:  ok  |
[    0.791472][    T0]   -----------------------------------------------------
[    0.791735][    T0]                                  |block | try  |context|
[    0.792000][    T0]   -----------------------------------------------------
[    0.792252][    T0]                           context:  ok  |  ok  |  ok  |
[    0.798615][    T0]                               try:  ok  |  ok  |  ok  |
[    0.804046][    T0]                             block:  ok  |  ok  |  ok  |
[    0.810770][    T0]                          spinlock:  ok  |  ok  |  ok  |
[    0.821347][    T0]   --------------------------------------------------------------------------
[    0.821673][    T0]   | queued read lock tests |
[    0.821856][    T0]   ---------------------------
[    0.822041][    T0]       hardirq read-lock/lock-read:  ok  |
[    0.824356][    T0]       hardirq lock-read/read-lock:  ok  |
[    0.826567][    T0]                 hardirq inversion:  ok  |
[    0.828774][    T0]   --------------------
[    0.828939][    T0]   | fs_reclaim tests |
[    0.829097][    T0]   --------------------
[    0.829252][    T0]                   correct nesting:  ok  |
[    0.830836][    T0]                     wrong nesting:  ok  |
[    0.832385][    T0]                 protected nesting:  ok  |
[    0.833899][    T0]   --------------------------------------------------------------------------
[    0.834216][    T0]   | local_lock tests |
[    0.834373][    T0]   ---------------------
[    0.834531][    T0]           local_lock inversion  2:  ok  |
[    0.836820][    T0]           local_lock inversion 3A:  ok  |
[    0.839520][    T0]           local_lock inversion 3B:  ok  |
[    0.842690][    T0]       hardirq_unsafe_softirq_safe:  ok  |
[    0.846193][    T0] -------------------------------------------------------
[    0.846452][    T0] Good, all 358 testcases passed! |
[    0.846645][    T0] ---------------------------------
[    0.848247][    T0] pid_max: default: 32768 minimum: 301
[    0.850462][    T0] Mount-cache hash table entries: 8192 (order: 0, 65536 bytes, linear)
[    0.850823][    T0] Mountpoint-cache hash table entries: 8192 (order: 0, 65536 bytes, linear)
[    0.902548][    T1] Running RCU-tasks wait API self tests
[    0.909691][    T1] POWER9 performance monitor hardware support registered
[    0.911844][    T1] rcu: Hierarchical SRCU implementation.
[    0.929941][   T10] Callback from call_rcu_tasks_trace() invoked.
[    0.932539][    T1] smp: Bringing up secondary CPUs ...
[    0.932888][    T1] smp: Brought up 1 node, 1 CPU
[    0.933249][    T1] numa: Node 0 CPUs: 0
[    0.943941][   T16] node 0 deferred pages initialised in 0ms
[    0.948649][   T16] pgdatinit0 (16) used greatest stack depth: 12528 bytes left
[    0.960416][    T1] devtmpfs: initialized
[    1.045777][    T9] Callback from call_rcu_tasks_rude() invoked.
[    1.051318][    T1] Initializing IODA2 PHB (/pciex@600c3c0000000)
[    1.052702][    T1] PCI host bridge /pciex@600c3c0000000 (primary) ranges:
[    1.053465][    T1]  MEM 0x000600c000000000..0x000600c07ffeffff -> 0x0000000080000000 
[    1.054400][    T1]  MEM 0x0006000000000000..0x0006003fffffffff -> 0x0006000000000000 (M64 #1..31)
[    1.054813][    T1]  Using M64 #31 as default window
[    1.056081][    T1]   512 (511) PE's M32: 0x80000000 [segment=0x400000]
[    1.056408][    T1]                  M64: 0x4000000000 [segment=0x20000000]
[    1.056858][    T1]   Allocated bitmap for 4088 MSIs (base IRQ 0xfe000)
[    1.061975][    T1] Initializing IODA2 PHB (/pciex@600c3c0100000)
[    1.062583][    T1] PCI host bridge /pciex@600c3c0100000  ranges:
[    1.062929][    T1]  MEM 0x000600c080000000..0x000600c0fffeffff -> 0x0000000080000000 
[    1.063511][    T1]  MEM 0x0006004000000000..0x0006007fffffffff -> 0x0006004000000000 (M64 #1..15)
[    1.063907][    T1]  Using M64 #15 as default window
[    1.064324][    T1]   256 (255) PE's M32: 0x80000000 [segment=0x800000]
[    1.064617][    T1]                  M64: 0x4000000000 [segment=0x40000000]
[    1.064944][    T1]   Allocated bitmap for 2040 MSIs (base IRQ 0xfd800)
[    1.066901][    T1] Initializing IODA2 PHB (/pciex@600c3c0200000)
[    1.067465][    T1] PCI host bridge /pciex@600c3c0200000  ranges:
[    1.067794][    T1]  MEM 0x000600c100000000..0x000600c17ffeffff -> 0x0000000080000000 
[    1.068359][    T1]  MEM 0x0006008000000000..0x000600bfffffffff -> 0x0006008000000000 (M64 #1..15)
[    1.068745][    T1]  Using M64 #15 as default window
[    1.069417][    T1]   256 (255) PE's M32: 0x80000000 [segment=0x800000]
[    1.069708][    T1]                  M64: 0x4000000000 [segment=0x40000000]
[    1.070032][    T1]   Allocated bitmap for 2040 MSIs (base IRQ 0xfd000)
[    1.072066][    T1] Initializing IODA2 PHB (/pciex@600c3c0300000)
[    1.072637][    T1] PCI host bridge /pciex@600c3c0300000  ranges:
[    1.072969][    T1]  MEM 0x000600c180000000..0x000600c1fffeffff -> 0x0000000080000000 
[    1.073537][    T1]  MEM 0x0006020000000000..0x0006023fffffffff -> 0x0006020000000000 (M64 #1..31)
[    1.073922][    T1]  Using M64 #31 as default window
[    1.074531][    T1]   512 (511) PE's M32: 0x80000000 [segment=0x400000]
[    1.074818][    T1]                  M64: 0x4000000000 [segment=0x20000000]
[    1.075132][    T1]   Allocated bitmap for 4088 MSIs (base IRQ 0xfc000)
[    1.077220][    T1] Initializing IODA2 PHB (/pciex@600c3c0400000)
[    1.077782][    T1] PCI host bridge /pciex@600c3c0400000  ranges:
[    1.078120][    T1]  MEM 0x000600c200000000..0x000600c27ffeffff -> 0x0000000080000000 
[    1.078682][    T1]  MEM 0x0006024000000000..0x0006027fffffffff -> 0x0006024000000000 (M64 #1..15)
[    1.079077][    T1]  Using M64 #15 as default window
[    1.079742][    T1]   256 (255) PE's M32: 0x80000000 [segment=0x800000]
[    1.080035][    T1]                  M64: 0x4000000000 [segment=0x40000000]
[    1.080352][    T1]   Allocated bitmap for 2040 MSIs (base IRQ 0xfb800)
[    1.082665][    T1] Initializing IODA2 PHB (/pciex@600c3c0500000)
[    1.083238][    T1] PCI host bridge /pciex@600c3c0500000  ranges:
[    1.083563][    T1]  MEM 0x000600c280000000..0x000600c2fffeffff -> 0x0000000080000000 
[    1.084123][    T1]  MEM 0x0006028000000000..0x000602bfffffffff -> 0x0006028000000000 (M64 #1..15)
[    1.084504][    T1]  Using M64 #15 as default window
[    1.084916][    T1]   256 (255) PE's M32: 0x80000000 [segment=0x800000]
[    1.085203][    T1]                  M64: 0x4000000000 [segment=0x40000000]
[    1.085519][    T1]   Allocated bitmap for 2040 MSIs (base IRQ 0xfb000)
[    1.088892][    T1] clocksource: jiffies: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 19112604462750000 ns
[    1.089557][    T1] futex hash table entries: 256 (order: -1, 32768 bytes, linear)
[    1.101390][    T1] NET: Registered PF_NETLINK/PF_ROUTE protocol family
[    1.109073][    T1] audit: initializing netlink subsys (disabled)
[    1.118056][    T1] cpuidle: using governor menu
[    1.119320][    T1] Failed to initialize. Disabling HugeTLB
[    1.119642][    T1] nvram: No room to create lnx,oops-log partition, deleting any obsolete OS partitions...
[    1.120368][    T1] nvram: Failed to find or create lnx,oops-log partition, err -28
[    1.120723][    T1] nvram: Failed to initialize oops partition!
[    1.134049][   T20] audit: type=2000 audit(1629254531.000:1): state=initialized audit_enabled=0 res=1
[    1.137609][    T1] EEH: PowerNV platform initialized
[    1.145237][    T1] PCI: Probing PCI hardware
[    1.149106][    T1] PCI host bridge to bus 0000:00
[    1.149625][    T1] pci_bus 0000:00: root bus resource [mem 0x600c000000000-0x600c07ffeffff] (bus address [0x80000000-0xfffeffff])
[    1.150397][    T1] pci_bus 0000:00: root bus resource [mem 0x6000000000000-0x6003fbfffffff 64bit pref]
[    1.151013][    T1] pci_bus 0000:00: root bus resource [bus 00-ff]
[    1.151524][    T1] pci_bus 0000:00: busn_res: [bus 00-ff] end is updated to ff
[    1.154823][    T1] pci 0000:00:00.0: [1014:04c1] type 01 class 0x060400
[    1.167476][    T1] pci 0000:01:00.0: [10ec:8139] type 00 class 0x020000
[    1.168101][    T1] pci 0000:01:00.0: reg 0x10: [io  0x0000-0x00ff]
[    1.168442][    T1] pci 0000:01:00.0: reg 0x14: [mem 0x00000000-0x000000ff]
[    1.168858][    T1] pci 0000:01:00.0: reg 0x30: [mem 0x00000000-0x0003ffff pref]
[    1.169311][    T1] pci 0000:01:00.0: BAR1 [mem size 0x00000100]: requesting alignment to 0x10000
[    1.172922][    T1] pci 0000:00:00.0: PCI bridge to [bus 01]
[    1.174447][    T1] pci_bus 0000:00: busn_res: [bus 00-ff] end is updated to 01
[    1.176415][    T1] PCI host bridge to bus 0001:00
[    1.176674][    T1] pci_bus 0001:00: root bus resource [mem 0x600c080000000-0x600c0fffeffff] (bus address [0x80000000-0xfffeffff])
[    1.177170][    T1] pci_bus 0001:00: root bus resource [mem 0x6004000000000-0x6007f7fffffff 64bit pref]
[    1.177597][    T1] pci_bus 0001:00: root bus resource [bus 00-ff]
[    1.177871][    T1] pci_bus 0001:00: busn_res: [bus 00-ff] end is updated to ff
[    1.178330][    T1] pci 0001:00:00.0: [1014:04c1] type 01 class 0x060400
[    1.184174][    T1] pci 0001:00:00.0: bridge configuration invalid ([bus 00-00]), reconfiguring
[    1.187991][    T1] pci 0001:00:00.0: PCI bridge to [bus 01-ff]
[    1.188371][    T1] pci_bus 0001:01: busn_res: [bus 01-ff] end is updated to 01
[    1.189153][    T1] pci_bus 0001:00: busn_res: [bus 00-ff] end is updated to 01
[    1.190752][    T1] PCI host bridge to bus 0002:00
[    1.191002][    T1] pci_bus 0002:00: root bus resource [mem 0x600c100000000-0x600c17ffeffff] (bus address [0x80000000-0xfffeffff])
[    1.191493][    T1] pci_bus 0002:00: root bus resource [mem 0x6008000000000-0x600bf7fffffff 64bit pref]
[    1.191911][    T1] pci_bus 0002:00: root bus resource [bus 00-ff]
[    1.192184][    T1] pci_bus 0002:00: busn_res: [bus 00-ff] end is updated to ff
[    1.192636][    T1] pci 0002:00:00.0: [1014:04c1] type 01 class 0x060400
[    1.199010][    T1] pci 0002:00:00.0: bridge configuration invalid ([bus 00-00]), reconfiguring
[    1.202319][    T1] pci 0002:00:00.0: PCI bridge to [bus 01-ff]
[    1.202673][    T1] pci_bus 0002:01: busn_res: [bus 01-ff] end is updated to 01
[    1.203269][    T1] pci_bus 0002:00: busn_res: [bus 00-ff] end is updated to 01
[    1.204899][    T1] PCI host bridge to bus 0003:00
[    1.205148][    T1] pci_bus 0003:00: root bus resource [mem 0x600c180000000-0x600c1fffeffff] (bus address [0x80000000-0xfffeffff])
[    1.205642][    T1] pci_bus 0003:00: root bus resource [mem 0x6020000000000-0x6023fbfffffff 64bit pref]
[    1.206748][    T1] pci_bus 0003:00: root bus resource [bus 00-ff]
[    1.207045][    T1] pci_bus 0003:00: busn_res: [bus 00-ff] end is updated to ff
[    1.207505][    T1] pci 0003:00:00.0: [1014:04c1] type 01 class 0x060400
[    1.213117][    T1] pci 0003:00:00.0: bridge configuration invalid ([bus 00-00]), reconfiguring
[    1.216451][    T1] pci 0003:00:00.0: PCI bridge to [bus 01-ff]
[    1.217503][    T1] pci_bus 0003:01: busn_res: [bus 01-ff] end is updated to 01
[    1.218181][    T1] pci_bus 0003:00: busn_res: [bus 00-ff] end is updated to 01
[    1.219717][    T1] PCI host bridge to bus 0004:00
[    1.219968][    T1] pci_bus 0004:00: root bus resource [mem 0x600c200000000-0x600c27ffeffff] (bus address [0x80000000-0xfffeffff])
[    1.220454][    T1] pci_bus 0004:00: root bus resource [mem 0x6024000000000-0x6027f7fffffff 64bit pref]
[    1.220863][    T1] pci_bus 0004:00: root bus resource [bus 00-ff]
[    1.221132][    T1] pci_bus 0004:00: busn_res: [bus 00-ff] end is updated to ff
[    1.221585][    T1] pci 0004:00:00.0: [1014:04c1] type 01 class 0x060400
[    1.227067][    T1] pci 0004:00:00.0: bridge configuration invalid ([bus 00-00]), reconfiguring
[    1.231059][    T1] pci 0004:00:00.0: PCI bridge to [bus 01-ff]
[    1.231411][    T1] pci_bus 0004:01: busn_res: [bus 01-ff] end is updated to 01
[    1.231984][    T1] pci_bus 0004:00: busn_res: [bus 00-ff] end is updated to 01
[    1.233643][    T1] PCI host bridge to bus 0005:00
[    1.233894][    T1] pci_bus 0005:00: root bus resource [mem 0x600c280000000-0x600c2fffeffff] (bus address [0x80000000-0xfffeffff])
[    1.234393][    T1] pci_bus 0005:00: root bus resource [mem 0x6028000000000-0x602bf7fffffff 64bit pref]
[    1.234799][    T1] pci_bus 0005:00: root bus resource [bus 00-ff]
[    1.235079][    T1] pci_bus 0005:00: busn_res: [bus 00-ff] end is updated to ff
[    1.235538][    T1] pci 0005:00:00.0: [1014:04c1] type 01 class 0x060400
[    1.241752][    T1] pci 0005:00:00.0: bridge configuration invalid ([bus 00-00]), reconfiguring
[    1.245089][    T1] pci 0005:00:00.0: PCI bridge to [bus 01-ff]
[    1.245444][    T1] pci_bus 0005:01: busn_res: [bus 01-ff] end is updated to 01
[    1.246021][    T1] pci_bus 0005:00: busn_res: [bus 00-ff] end is updated to 01
[    1.247644][    T1] pci 0000:00:00.0: bridge window [mem 0x20000000-0x1fffffff 64bit pref] to [bus 01] add_size 20000000 add_align 20000000
[    1.249777][    T1] pci 0000:00:00.0: BAR 9: assigned [mem 0x6000000000000-0x600001fffffff 64bit pref]
[    1.250256][    T1] pci 0000:00:00.0: BAR 8: assigned [mem 0x600c000000000-0x600c0003fffff]
[    1.250664][    T1] pci 0000:00:00.0: BAR 7: no space for [io  size 0x1000]
[    1.250986][    T1] pci 0000:00:00.0: BAR 7: failed to assign [io  size 0x1000]
[    1.251724][    T1] pci 0000:00:00.0: BAR 7: no space for [io  size 0x1000]
[    1.252029][    T1] pci 0000:00:00.0: BAR 7: failed to assign [io  size 0x1000]
[    1.252488][    T1] pci 0000:01:00.0: BAR 6: assigned [mem 0x600c000000000-0x600c00003ffff pref]
[    1.252966][    T1] pci 0000:01:00.0: BAR 1: assigned [mem 0x600c000040000-0x600c0000400ff]
[    1.253406][    T1] pci 0000:01:00.0: BAR 0: no space for [io  size 0x0100]
[    1.253698][    T1] pci 0000:01:00.0: BAR 0: failed to assign [io  size 0x0100]
[    1.254222][    T1] pci 0000:00:00.0: PCI bridge to [bus 01]
[    1.254868][    T1] pci 0000:00:00.0:   bridge window [mem 0x600c000000000-0x600c07fefffff]
[    1.255351][    T1] pci 0000:00:00.0:   bridge window [mem 0x6000000000000-0x6003fbff0ffff 64bit pref]
[    1.256063][    T1] pci_bus 0000:00: Some PCI device resources are unassigned, try booting with pci=realloc
[    1.256580][    T1] pci_bus 0000:00: resource 4 [mem 0x600c000000000-0x600c07ffeffff]
[    1.256922][    T1] pci_bus 0000:00: resource 5 [mem 0x6000000000000-0x6003fbfffffff 64bit pref]
[    1.257298][    T1] pci_bus 0000:01: resource 1 [mem 0x600c000000000-0x600c07fefffff]
[    1.257623][    T1] pci_bus 0000:01: resource 2 [mem 0x6000000000000-0x6003fbff0ffff 64bit pref]
[    1.258108][    T1] pci 0001:00:00.0: bridge window [io  0x1000-0x0fff] to [bus 01] add_size 1000
[    1.258537][    T1] pci 0001:00:00.0: bridge window [mem 0x40000000-0x3fffffff 64bit pref] to [bus 01] add_size 40000000 add_align 40000000
[    1.259065][    T1] pci 0001:00:00.0: bridge window [mem 0x00800000-0x007fffff] to [bus 01] add_size 800000 add_align 800000
[    1.259617][    T1] pci 0001:00:00.0: BAR 9: assigned [mem 0x6004000000000-0x600403fffffff 64bit pref]
[    1.260009][    T1] pci 0001:00:00.0: BAR 8: assigned [mem 0x600c080000000-0x600c0807fffff]
[    1.260501][    T1] pci 0001:00:00.0: BAR 7: no space for [io  size 0x1000]
[    1.260808][    T1] pci 0001:00:00.0: BAR 7: failed to assign [io  size 0x1000]
[    1.261239][    T1] pci 0001:00:00.0: BAR 7: no space for [io  size 0x1000]
[    1.261539][    T1] pci 0001:00:00.0: BAR 7: failed to assign [io  size 0x1000]
[    1.261933][    T1] pci 0001:00:00.0: PCI bridge to [bus 01]
[    1.262441][    T1] pci 0001:00:00.0:   bridge window [mem 0x600c080000000-0x600c0ffefffff]
[    1.262836][    T1] pci 0001:00:00.0:   bridge window [mem 0x6004000000000-0x6007f7ff0ffff 64bit pref]
[    1.263456][    T1] pci_bus 0001:00: resource 4 [mem 0x600c080000000-0x600c0fffeffff]
[    1.263827][    T1] pci_bus 0001:00: resource 5 [mem 0x6004000000000-0x6007f7fffffff 64bit pref]
[    1.264186][    T1] pci_bus 0001:01: resource 1 [mem 0x600c080000000-0x600c0ffefffff]
[    1.264507][    T1] pci_bus 0001:01: resource 2 [mem 0x6004000000000-0x6007f7ff0ffff 64bit pref]
[    1.264910][    T1] pci 0002:00:00.0: bridge window [io  0x1000-0x0fff] to [bus 01] add_size 1000
[    1.265291][    T1] pci 0002:00:00.0: bridge window [mem 0x40000000-0x3fffffff 64bit pref] to [bus 01] add_size 40000000 add_align 40000000
[    1.265802][    T1] pci 0002:00:00.0: bridge window [mem 0x00800000-0x007fffff] to [bus 01] add_size 800000 add_align 800000
[    1.266339][    T1] pci 0002:00:00.0: BAR 9: assigned [mem 0x6008000000000-0x600803fffffff 64bit pref]
[    1.266722][    T1] pci 0002:00:00.0: BAR 8: assigned [mem 0x600c100000000-0x600c1007fffff]
[    1.267067][    T1] pci 0002:00:00.0: BAR 7: no space for [io  size 0x1000]
[    1.267352][    T1] pci 0002:00:00.0: BAR 7: failed to assign [io  size 0x1000]
[    1.267712][    T1] pci 0002:00:00.0: BAR 7: no space for [io  size 0x1000]
[    1.268002][    T1] pci 0002:00:00.0: BAR 7: failed to assign [io  size 0x1000]
[    1.268316][    T1] pci 0002:00:00.0: PCI bridge to [bus 01]
[    1.268818][    T1] pci 0002:00:00.0:   bridge window [mem 0x600c100000000-0x600c17fefffff]
[    1.269207][    T1] pci 0002:00:00.0:   bridge window [mem 0x6008000000000-0x600bf7ff0ffff 64bit pref]
[    1.269834][    T1] pci_bus 0002:00: resource 4 [mem 0x600c100000000-0x600c17ffeffff]
[    1.270205][    T1] pci_bus 0002:00: resource 5 [mem 0x6008000000000-0x600bf7fffffff 64bit pref]
[    1.270564][    T1] pci_bus 0002:01: resource 1 [mem 0x600c100000000-0x600c17fefffff]
[    1.271232][    T1] pci_bus 0002:01: resource 2 [mem 0x6008000000000-0x600bf7ff0ffff 64bit pref]
[    1.271649][    T1] pci 0003:00:00.0: bridge window [io  0x1000-0x0fff] to [bus 01] add_size 1000
[    1.272043][    T1] pci 0003:00:00.0: bridge window [mem 0x20000000-0x1fffffff 64bit pref] to [bus 01] add_size 20000000 add_align 20000000
[    1.272563][    T1] pci 0003:00:00.0: bridge window [mem 0x00400000-0x003fffff] to [bus 01] add_size 400000 add_align 400000
[    1.273100][    T1] pci 0003:00:00.0: BAR 9: assigned [mem 0x6020000000000-0x602001fffffff 64bit pref]
[    1.273487][    T1] pci 0003:00:00.0: BAR 8: assigned [mem 0x600c180000000-0x600c1803fffff]
[    1.273832][    T1] pci 0003:00:00.0: BAR 7: no space for [io  size 0x1000]
[    1.274119][    T1] pci 0003:00:00.0: BAR 7: failed to assign [io  size 0x1000]
[    1.274478][    T1] pci 0003:00:00.0: BAR 7: no space for [io  size 0x1000]
[    1.274763][    T1] pci 0003:00:00.0: BAR 7: failed to assign [io  size 0x1000]
[    1.275085][    T1] pci 0003:00:00.0: PCI bridge to [bus 01]
[    1.275632][    T1] pci 0003:00:00.0:   bridge window [mem 0x600c180000000-0x600c1ffefffff]
[    1.276022][    T1] pci 0003:00:00.0:   bridge window [mem 0x6020000000000-0x6023fbff0ffff 64bit pref]
[    1.276634][    T1] pci_bus 0003:00: resource 4 [mem 0x600c180000000-0x600c1fffeffff]
[    1.276999][    T1] pci_bus 0003:00: resource 5 [mem 0x6020000000000-0x6023fbfffffff 64bit pref]
[    1.277359][    T1] pci_bus 0003:01: resource 1 [mem 0x600c180000000-0x600c1ffefffff]
[    1.277679][    T1] pci_bus 0003:01: resource 2 [mem 0x6020000000000-0x6023fbff0ffff 64bit pref]
[    1.278082][    T1] pci 0004:00:00.0: bridge window [io  0x1000-0x0fff] to [bus 01] add_size 1000
[    1.278464][    T1] pci 0004:00:00.0: bridge window [mem 0x40000000-0x3fffffff 64bit pref] to [bus 01] add_size 40000000 add_align 40000000
[    1.278987][    T1] pci 0004:00:00.0: bridge window [mem 0x00800000-0x007fffff] to [bus 01] add_size 800000 add_align 800000
[    1.279526][    T1] pci 0004:00:00.0: BAR 9: assigned [mem 0x6024000000000-0x602403fffffff 64bit pref]
[    1.279925][    T1] pci 0004:00:00.0: BAR 8: assigned [mem 0x600c200000000-0x600c2007fffff]
[    1.280273][    T1] pci 0004:00:00.0: BAR 7: no space for [io  size 0x1000]
[    1.280564][    T1] pci 0004:00:00.0: BAR 7: failed to assign [io  size 0x1000]
[    1.280932][    T1] pci 0004:00:00.0: BAR 7: no space for [io  size 0x1000]
[    1.281223][    T1] pci 0004:00:00.0: BAR 7: failed to assign [io  size 0x1000]
[    1.281688][    T1] pci 0004:00:00.0: PCI bridge to [bus 01]
[    1.282222][    T1] pci 0004:00:00.0:   bridge window [mem 0x600c200000000-0x600c27fefffff]
[    1.282623][    T1] pci 0004:00:00.0:   bridge window [mem 0x6024000000000-0x6027f7ff0ffff 64bit pref]
[    1.283258][    T1] pci_bus 0004:00: resource 4 [mem 0x600c200000000-0x600c27ffeffff]
[    1.283633][    T1] pci_bus 0004:00: resource 5 [mem 0x6024000000000-0x6027f7fffffff 64bit pref]
[    1.284000][    T1] pci_bus 0004:01: resource 1 [mem 0x600c200000000-0x600c27fefffff]
[    1.284324][    T1] pci_bus 0004:01: resource 2 [mem 0x6024000000000-0x6027f7ff0ffff 64bit pref]
[    1.284724][    T1] pci 0005:00:00.0: bridge window [io  0x1000-0x0fff] to [bus 01] add_size 1000
[    1.285109][    T1] pci 0005:00:00.0: bridge window [mem 0x40000000-0x3fffffff 64bit pref] to [bus 01] add_size 40000000 add_align 40000000
[    1.285624][    T1] pci 0005:00:00.0: bridge window [mem 0x00800000-0x007fffff] to [bus 01] add_size 800000 add_align 800000
[    1.286157][    T1] pci 0005:00:00.0: BAR 9: assigned [mem 0x6028000000000-0x602803fffffff 64bit pref]
[    1.286544][    T1] pci 0005:00:00.0: BAR 8: assigned [mem 0x600c280000000-0x600c2807fffff]
[    1.286895][    T1] pci 0005:00:00.0: BAR 7: no space for [io  size 0x1000]
[    1.287182][    T1] pci 0005:00:00.0: BAR 7: failed to assign [io  size 0x1000]
[    1.287543][    T1] pci 0005:00:00.0: BAR 7: no space for [io  size 0x1000]
[    1.287833][    T1] pci 0005:00:00.0: BAR 7: failed to assign [io  size 0x1000]
[    1.288149][    T1] pci 0005:00:00.0: PCI bridge to [bus 01]
[    1.288640][    T1] pci 0005:00:00.0:   bridge window [mem 0x600c280000000-0x600c2ffefffff]
[    1.289031][    T1] pci 0005:00:00.0:   bridge window [mem 0x6028000000000-0x602bf7ff0ffff 64bit pref]
[    1.289663][    T1] pci_bus 0005:00: resource 4 [mem 0x600c280000000-0x600c2fffeffff]
[    1.290038][    T1] pci_bus 0005:00: resource 5 [mem 0x6028000000000-0x602bf7fffffff 64bit pref]
[    1.290415][    T1] pci_bus 0005:01: resource 1 [mem 0x600c280000000-0x600c2ffefffff]
[    1.290744][    T1] pci_bus 0005:01: resource 2 [mem 0x6028000000000-0x602bf7ff0ffff 64bit pref]
[    1.291302][    T1] pci_bus 0000:00: Configuring PE for bus
[    1.292035][    T1] pci 0000:00     : [PE# 1fe] Secondary bus 0x0000000000000000 associated with PE#1fe
[    1.293202][    T1] pci 0000:00:00.0: Configured PE#1fe
[    1.295876][    T1] pci_bus 0000:01: Configuring PE for bus
[    1.296332][    T1] pci 0000:01     : [PE# 1fd] Secondary bus 0x0000000000000001 associated with PE#1fd
[    1.297103][    T1] pci 0000:01:00.0: Configured PE#1fd
[    1.297363][    T1] pci 0000:01     : [PE# 1fd] Setting up 32-bit TCE table at 0..80000000
[    1.298764][    T1] IOMMU table initialized, virtual merging enabled
[    1.299106][    T1] pci 0000:01     : [PE# 1fd] Setting up window#0 0..7fffffff pg=10000
[    1.299875][    T1] pci 0000:01     : [PE# 1fd] Enabling 64-bit DMA bypass
[    1.301127][    T1] pci 0000:01:00.0: Adding to iommu group 0
[    1.303551][    T1] pci_bus 0001:00: Configuring PE for bus
[    1.303821][    T1] pci 0001:00     : [PE# fe] Secondary bus 0x0000000000000000 associated with PE#fe
[    1.304336][    T1] pci 0001:00:00.0: Configured PE#fe
[    1.305333][    T1] pci_bus 0002:00: Configuring PE for bus
[    1.305584][    T1] pci 0002:00     : [PE# fe] Secondary bus 0x0000000000000000 associated with PE#fe
[    1.306093][    T1] pci 0002:00:00.0: Configured PE#fe
[    1.307058][    T1] pci_bus 0003:00: Configuring PE for bus
[    1.307309][    T1] pci 0003:00     : [PE# 1fe] Secondary bus 0x0000000000000000 associated with PE#1fe
[    1.307823][    T1] pci 0003:00:00.0: Configured PE#1fe
[    1.308719][    T1] pci_bus 0004:00: Configuring PE for bus
[    1.308969][    T1] pci 0004:00     : [PE# fe] Secondary bus 0x0000000000000000 associated with PE#fe
[    1.309469][    T1] pci 0004:00:00.0: Configured PE#fe
[    1.310396][    T1] pci_bus 0005:00: Configuring PE for bus
[    1.310646][    T1] pci 0005:00     : [PE# fe] Secondary bus 0x0000000000000000 associated with PE#fe
[    1.311146][    T1] pci 0005:00:00.0: Configured PE#fe
[    1.314106][    T1] pci 0000:00:00.0: enabling device (0105 -> 0107)
[    1.314972][    T1] EEH: Capable adapter found: recovery enabled.
[    1.327661][    T1] cpuidle-powernv: Default stop: psscr = 0x0000000000000330,mask=0x00000000003003ff
[    1.328088][    T1] cpuidle-powernv: Deepest stop: psscr = 0x0000000000300331,mask=0x00000000003003ff
[    1.328467][    T1] cpuidle-powernv: First stop level that may lose SPRs = 0x10
[    1.328771][    T1] cpuidle-powernv: First stop level that may lose timebase = 0x10
[    1.418096][    T1] Kprobes globally optimized
[    1.445284][   T34] cryptomgr_test (34) used greatest stack depth: 10880 bytes left
[    1.477721][   T43] cryptomgr_test (43) used greatest stack depth: 10528 bytes left
[    1.649775][    T1] raid6: vpermxor8 gen()   911 MB/s
[    1.821391][    T1] raid6: vpermxor4 gen()   892 MB/s
[    1.992859][    T1] raid6: vpermxor2 gen()   801 MB/s
[    2.164481][    T1] raid6: vpermxor1 gen()   670 MB/s
[    2.336154][    T1] raid6: altivecx8 gen()  1082 MB/s
[    2.507671][    T1] raid6: altivecx4 gen()  1221 MB/s
[    2.679460][    T1] raid6: altivecx2 gen()  1120 MB/s
[    2.850914][    T1] raid6: altivecx1 gen()   843 MB/s
[    3.022625][    T1] raid6: int64x8  gen()  1612 MB/s
[    3.195010][    T1] raid6: int64x8  xor()  1085 MB/s
[    3.366613][    T1] raid6: int64x4  gen()  2585 MB/s
[    3.539108][    T1] raid6: int64x4  xor()  1289 MB/s
[    3.711797][    T1] raid6: int64x2  gen()  2250 MB/s
[    3.884349][    T1] raid6: int64x2  xor()  1449 MB/s
[    4.055962][    T1] raid6: int64x1  gen()  1654 MB/s
[    4.227577][    T1] raid6: int64x1  xor()  1052 MB/s
[    4.227844][    T1] raid6: using algorithm int64x4 gen() 2585 MB/s
[    4.228126][    T1] raid6: .... xor() 1289 MB/s, rmw enabled
[    4.228428][    T1] raid6: using intx1 recovery algorithm
[    4.229638][    T1] iommu: Default domain type: Translated 
[    4.229925][    T1] iommu: DMA domain TLB invalidation policy: lazy mode 
[    4.237510][    T1] vgaarb: loaded
[    4.246973][    T1] SCSI subsystem initialized
[    4.250526][    T1] usbcore: registered new interface driver usbfs
[    4.251465][    T1] usbcore: registered new interface driver hub
[    4.252078][    T1] usbcore: registered new device driver usb
[    4.270795][    T1] clocksource: Switched to clocksource timebase
[    4.952052][    T1] hugetlbfs: disabling because there are no supported hugepage sizes
[    5.048614][    T1] NET: Registered PF_INET protocol family
[    5.050972][    T1] IP idents hash table entries: 32768 (order: 2, 262144 bytes, linear)
[    5.058507][    T1] tcp_listen_portaddr_hash hash table entries: 1024 (order: 0, 81920 bytes, linear)
[    5.059211][    T1] TCP established hash table entries: 16384 (order: 1, 131072 bytes, linear)
[    5.060165][    T1] TCP bind hash table entries: 16384 (order: 4, 1179648 bytes, linear)
[    5.063161][    T1] TCP: Hash tables configured (established 16384 bind 16384)
[    5.064854][    T1] UDP hash table entries: 1024 (order: 1, 163840 bytes, linear)
[    5.065745][    T1] UDP-Lite hash table entries: 1024 (order: 1, 163840 bytes, linear)
[    5.068316][    T1] NET: Registered PF_UNIX/PF_LOCAL protocol family
[    5.069444][    T1] PCI: CLS 0 bytes, default 128
[   11.698074][    T1] workingset: timestamp_bits=38 max_order=15 bucket_order=0
[   11.863823][    T1] squashfs: version 4.0 (2009/01/31) Phillip Lougher
[   11.868058][    T1] xor: measuring software checksum speed
[   11.871448][    T1]    8regs           :  3419 MB/sec
[   11.875731][    T1]    8regs_prefetch  :  2781 MB/sec
[   11.879196][    T1]    32regs          :  3140 MB/sec
[   11.883403][    T1]    32regs_prefetch :  2606 MB/sec
[   11.887182][    T1]    altivec         :  2876 MB/sec
[   11.887443][    T1] xor: using function: 8regs (3419 MB/sec)
[   11.888066][    T1] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 250)
[   11.888569][    T1] io scheduler mq-deadline registered
[   11.888942][    T1] io scheduler kyber registered
[   12.533563][    T1] String selftests succeeded
[   12.536168][    T1] test_firmware: interface ready
[   12.536606][    T1] test_bitmap: loaded.
[   12.538982][    T1] test_bitmap: parselist: 14: input is '0-2047:128/256' OK, Time: 2500
[   12.540499][    T1] test_bitmap: bitmap_print_to_pagebuf: input is '0-524287
[   12.540499][    T1] ', Time: 196283
[   12.547687][    T1] test_bitmap: all 1943 tests passed
[   12.548124][    T1] test_uuid: all 18 tests passed
[   12.550638][    T1] crc32: CRC_LE_BITS = 64, CRC_BE BITS = 64
[   12.550919][    T1] crc32: self tests passed, processed 225944 bytes in 441546 nsec
[   12.551692][    T1] crc32c: CRC_LE_BITS = 64
[   12.551895][    T1] crc32c: self tests passed, processed 225944 bytes in 210993 nsec
[   12.589245][    T1] crc32_combine: 8373 self tests passed
[   12.625891][    T1] crc32c_combine: 8373 self tests passed
[   12.626772][    T1] glob: 64 self-tests passed, 0 failed
[   12.632624][    T1] rbtree testing
[   12.653861][    T1]  -> test 1 (latency of nnodes insert+delete): 10807 cycles
[   12.666573][    T1]  -> test 2 (latency of nnodes cached insert+delete): 6252 cycles
[   12.669009][    T1]  -> test 3 (latency of inorder traversal): 1046 cycles
[   12.669361][    T1]  -> test 4 (latency to fetch first node)
[   12.669608][    T1]         non-cached: 27 cycles
[   12.669823][    T1]         cached: 0 cycles
[   12.769434][    T1] augmented rbtree testing
[   12.812243][    T1]  -> test 1 (latency of nnodes insert+delete): 21897 cycles
[   12.860505][    T1]  -> test 2 (latency of nnodes cached insert+delete): 24428 cycles
[   12.994713][    T1] interval tree insert/remove
[   13.018177][    T1]  -> 11958 cycles
[   13.018560][    T1] interval tree search
[   13.112939][    T1]  -> 48288 cycles (2692 results)
[   13.114012][    T1] IPMI message handler: version 39.2
[   13.114781][    T1] ipmi device interface
[   13.345730][    T1] ipmi-powernv ibm,opal:ipmi: IPMI message handler: Found new BMC (man_id: 0x000000, prod_id: 0x0000, dev_id: 0x20)
[   13.569872][    T1] hvc0: raw protocol on /ibm,opal/consoles/serial@0 (boot console)
[   13.571124][    T1] hvc0: No interrupts property, using OPAL event
[   13.579830][    T1] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[   13.647596][    T1] loop: module loaded
[   13.650217][    T1] Adaptec aacraid driver 1.2.1[50983]-custom
[   13.652349][    T1] megasas: 07.717.02.00-rc1
[   13.653397][    T1] ipr: IBM Power RAID SCSI Device Driver version: 2.6.4 (March 14, 2017)
[   13.679028][    T1] 1 fixed-partitions partitions found on MTD device flash@0
[   13.679453][    T1] Creating 1 MTD partitions on "flash@0":
[   13.679876][    T1] 0x000000000000-0x000002000000 : "PNOR"
[   13.711952][    T1] libphy: Fixed MDIO Bus: probed
[   13.715189][    T1] e100: Intel(R) PRO/100 Network Driver
[   13.715437][    T1] e100: Copyright(c) 1999-2006 Intel Corporation
[   13.715979][    T1] e1000: Intel(R) PRO/1000 Network Driver
[   13.716232][    T1] e1000: Copyright (c) 1999-2006 Intel Corporation.
[   13.716928][    T1] e1000e: Intel(R) PRO/1000 Network Driver
[   13.717181][    T1] e1000e: Copyright(c) 1999 - 2015 Intel Corporation.
[   13.718728][   T11] 8139cp: 8139cp: 10/100 PCI Ethernet driver v1.3 (Mar 22, 2004)
[   13.719630][   T11] 8139cp 0000:01:00.0: enabling device (0100 -> 0102)
[   13.726664][   T11] 8139cp 0000:01:00.0 eth0: RTL-8139C+ at 0xc00a000080630000, 52:54:00:12:34:56, IRQ 32
[   13.728905][    T1] usbcore: registered new interface driver asix
[   13.729476][    T1] usbcore: registered new interface driver ax88179_178a
[   13.730006][    T1] usbcore: registered new interface driver cdc_ether
[   13.730746][    T1] usbcore: registered new interface driver net1080
[   13.731272][    T1] usbcore: registered new interface driver cdc_subset
[   13.731791][    T1] usbcore: registered new interface driver zaurus
[   13.732528][    T1] usbcore: registered new interface driver cdc_ncm
[   13.732828][    T1] Fusion MPT base driver 3.04.20
[   13.733047][    T1] Copyright (c) 1999-2008 LSI Corporation
[   13.733504][    T1] Fusion MPT SAS Host driver 3.04.20
[   13.735177][    T1] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[   13.735547][    T1] ehci-pci: EHCI PCI platform driver
[   13.736156][    T1] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[   13.738233][    T1] usbcore: registered new interface driver uas
[   13.738956][    T1] usbcore: registered new interface driver usb-storage
[   13.739614][    T1] usbcore: registered new interface driver usbtest
[   13.740123][    T1] usbcore: registered new interface driver usb_ehset_test
[   13.740829][    T1] usbcore: registered new interface driver lvs
[   13.984603][    T1] rtc-opal opal-rtc: registered as rtc0
[   14.191792][    T1] rtc-opal opal-rtc: setting system clock to 2021-08-18T02:42:24 UTC (1629254544)
[   14.193896][    T1] i2c /dev entries driver
[   14.202822][    T1] device-mapper: uevent: version 1.0.3
[   14.209077][    T1] device-mapper: ioctl: 4.45.0-ioctl (2021-03-22) initialised: dm-devel@redhat.com
[   14.209551][    T1] powernv-cpufreq: ibm,pstate-min node not found
[   14.209825][    T1] powernv-cpufreq: Platform driver disabled. System does not support PState control
[   14.213922][    T1] sdhci: Secure Digital Host Controller Interface driver
[   14.214246][    T1] sdhci: Copyright(c) Pierre Ossman
[   14.216479][    T1] ipip: IPv4 and MPLS over IPv4 tunneling driver
[   14.228886][    T1] NET: Registered PF_INET6 protocol family
[   14.243458][    T1] Segment Routing with IPv6
[   14.243966][    T1] In-situ OAM (IOAM) with IPv6
[   14.244762][    T1] NET: Registered PF_PACKET protocol family
[   14.246324][    T1] Key type dns_resolver registered
[   14.246774][    T1] drmem: No dynamic reconfiguration memory found
[   14.258788][    T1] registered taskstats version 1
[   14.282301][    T1] Btrfs loaded, crc32c=crc32c-generic, zoned=no, fsverity=no
[   14.292334][    T1] ### dt-test ### start of unittest - you will see error messages
[   14.296627][    T1] ### dt-test ### EXPECT \ : Duplicate name in testcase-data, renamed to "duplicate-name#1"
[   14.297957][    T1] Duplicate name in testcase-data, renamed to "duplicate-name#1"
[   14.322891][    T1] ### dt-test ### EXPECT / : Duplicate name in testcase-data, renamed to "duplicate-name#1"
[   14.328302][    T1] ### dt-test ### EXPECT \ : OF: /testcase-data/phandle-tests/consumer-a: could not get #phandle-cells-missing for /testcase-data/phandle-tests/provider1
[   14.328760][    T1] OF: /testcase-data/phandle-tests/consumer-a: could not get #phandle-cells-missing for /testcase-data/phandle-tests/provider1
[   14.329967][    T1] ### dt-test ### EXPECT / : OF: /testcase-data/phandle-tests/consumer-a: could not get #phandle-cells-missing for /testcase-data/phandle-tests/provider1
[   14.329990][    T1] ### dt-test ### EXPECT \ : OF: /testcase-data/phandle-tests/consumer-a: could not get #phandle-cells-missing for /testcase-data/phandle-tests/provider1
[   14.330773][    T1] OF: /testcase-data/phandle-tests/consumer-a: could not get #phandle-cells-missing for /testcase-data/phandle-tests/provider1
[   14.331988][    T1] ### dt-test ### EXPECT / : OF: /testcase-data/phandle-tests/consumer-a: could not get #phandle-cells-missing for /testcase-data/phandle-tests/provider1
[   14.332025][    T1] ### dt-test ### EXPECT \ : OF: /testcase-data/phandle-tests/consumer-a: could not find phandle
[   14.332660][    T1] OF: /testcase-data/phandle-tests/consumer-a: could not find phandle 12345678
[   14.333489][    T1] ### dt-test ### EXPECT / : OF: /testcase-data/phandle-tests/consumer-a: could not find phandle
[   14.333533][    T1] ### dt-test ### EXPECT \ : OF: /testcase-data/phandle-tests/consumer-a: could not find phandle
[   14.333966][    T1] OF: /testcase-data/phandle-tests/consumer-a: could not find phandle 12345678
[   14.334811][    T1] ### dt-test ### EXPECT / : OF: /testcase-data/phandle-tests/consumer-a: could not find phandle
[   14.334842][    T1] ### dt-test ### EXPECT \ : OF: /testcase-data/phandle-tests/consumer-a: #phandle-cells = 3 found -1
[   14.335284][    T1] OF: /testcase-data/phandle-tests/consumer-a: #phandle-cells = 3 found -1
[   14.336102][    T1] ### dt-test ### EXPECT / : OF: /testcase-data/phandle-tests/consumer-a: #phandle-cells = 3 found -1
[   14.336124][    T1] ### dt-test ### EXPECT \ : OF: /testcase-data/phandle-tests/consumer-a: #phandle-cells = 3 found -1
[   14.336574][    T1] OF: /testcase-data/phandle-tests/consumer-a: #phandle-cells = 3 found -1
[   14.337380][    T1] ### dt-test ### EXPECT / : OF: /testcase-data/phandle-tests/consumer-a: #phandle-cells = 3 found -1
[   14.338978][    T1] ### dt-test ### EXPECT \ : OF: /testcase-data/phandle-tests/consumer-b: could not get #phandle-missing-cells for /testcase-data/phandle-tests/provider1
[   14.339501][    T1] OF: /testcase-data/phandle-tests/consumer-b: could not get #phandle-missing-cells for /testcase-data/phandle-tests/provider1
[   14.341394][    T1] ### dt-test ### EXPECT / : OF: /testcase-data/phandle-tests/consumer-b: could not get #phandle-missing-cells for /testcase-data/phandle-tests/provider1
[   14.341466][    T1] ### dt-test ### EXPECT \ : OF: /testcase-data/phandle-tests/consumer-b: could not find phandle
[   14.342848][    T1] OF: /testcase-data/phandle-tests/consumer-b: could not find phandle 12345678
[   14.344546][    T1] ### dt-test ### EXPECT / : OF: /testcase-data/phandle-tests/consumer-b: could not find phandle
[   14.344606][    T1] ### dt-test ### EXPECT \ : OF: /testcase-data/phandle-tests/consumer-b: #phandle-cells = 2 found -1
[   14.345657][    T1] OF: /testcase-data/phandle-tests/consumer-b: #phandle-cells = 2 found -1
[   14.347372][    T1] ### dt-test ### EXPECT / : OF: /testcase-data/phandle-tests/consumer-b: #phandle-cells = 2 found -1
[   14.353289][    T1] ### dt-test ### FAIL of_unittest_dma_ranges_one():922 of_dma_get_range: wrong phys addr 0x0000000000000000 (expecting 20000000) on node /testcase-data/address-tests/device@70000000
[   14.354511][    T1] ### dt-test ### FAIL of_unittest_dma_ranges_one():925 of_dma_get_range: wrong DMA addr 0x0000000020000000 (expecting 0) on node /testcase-data/address-tests/device@70000000
[   14.355461][    T1] ### dt-test ### FAIL of_unittest_dma_ranges_one():922 of_dma_get_range: wrong phys addr 0x0000000100000000 (expecting 20000000) on node /testcase-data/address-tests/bus@80000000/device@1000
[   14.356255][    T1] ### dt-test ### FAIL of_unittest_dma_ranges_one():925 of_dma_get_range: wrong DMA addr 0x0000000020000000 (expecting 100000000) on node /testcase-data/address-tests/bus@80000000/device@1000
[   14.357459][    T1] ### dt-test ### FAIL of_unittest_dma_ranges_one():922 of_dma_get_range: wrong phys addr 0x0000000080000000 (expecting 20000000) on node /testcase-data/address-tests/pci@90000000
[   14.358210][    T1] ### dt-test ### FAIL of_unittest_dma_ranges_one():925 of_dma_get_range: wrong DMA addr 0x0000000020000000 (expecting 80000000) on node /testcase-data/address-tests/pci@90000000
[   14.361799][    T1] ### dt-test ### EXPECT \ : platform testcase-data:testcase-device2: IRQ index 0 not found
[   14.361874][    T1] platform testcase-data:testcase-device2: IRQ index 0 not found
[   14.362644][    T1] ### dt-test ### EXPECT / : platform testcase-data:testcase-device2: IRQ index 0 not found
[   14.371513][    T1] ### dt-test ### end of unittest - 184 passed, 6 failed
[   14.375004][    T1] TAP version 14
[   14.375192][    T1] 1..11
[   14.375391][    T1]     # Subtest: sysctl_test
[   14.375460][    T1]     1..10
[   14.378464][    T1]     ok 1 - sysctl_test_api_dointvec_null_tbl_data
[   14.379651][    T1]     ok 2 - sysctl_test_api_dointvec_table_maxlen_unset
[   14.381506][    T1]     ok 3 - sysctl_test_api_dointvec_table_len_is_zero
[   14.382656][    T1]     ok 4 - sysctl_test_api_dointvec_table_read_but_position_set
[   14.384011][    T1]     ok 5 - sysctl_test_dointvec_read_happy_single_positive
[   14.385228][    T1]     ok 6 - sysctl_test_dointvec_read_happy_single_negative
[   14.386628][    T1]     ok 7 - sysctl_test_dointvec_write_happy_single_positive
[   14.387832][    T1]     ok 8 - sysctl_test_dointvec_write_happy_single_negative
[   14.389086][    T1]     ok 9 - sysctl_test_api_dointvec_write_single_less_int_min
[   14.390490][    T1]     ok 10 - sysctl_test_api_dointvec_write_single_greater_int_max
[   14.390881][    T1] # sysctl_test: pass:10 fail:0 skip:0 total:10
[   14.391258][    T1] # Totals: pass:10 fail:0 skip:0 total:10
[   14.391605][    T1] ok 1 - sysctl_test
[   14.392077][    T1]     # Subtest: ext4_inode_test
[   14.392090][    T1]     1..1
[   14.393284][    T1]     # inode_test_xtimestamp_decoding: ok 1 - 1901-12-13 Lower bound of 32bit < 0 timestamp, no extra bits
[   14.394195][    T1]     # inode_test_xtimestamp_decoding: ok 2 - 1969-12-31 Upper bound of 32bit < 0 timestamp, no extra bits
[   14.395457][    T1]     # inode_test_xtimestamp_decoding: ok 3 - 1970-01-01 Lower bound of 32bit >=0 timestamp, no extra bits
[   14.396662][    T1]     # inode_test_xtimestamp_decoding: ok 4 - 2038-01-19 Upper bound of 32bit >=0 timestamp, no extra bits
[   14.397815][    T1]     # inode_test_xtimestamp_decoding: ok 5 - 2038-01-19 Lower bound of 32bit <0 timestamp, lo extra sec bit on
[   14.398969][    T1]     # inode_test_xtimestamp_decoding: ok 6 - 2106-02-07 Upper bound of 32bit <0 timestamp, lo extra sec bit on
[   14.400124][    T1]     # inode_test_xtimestamp_decoding: ok 7 - 2106-02-07 Lower bound of 32bit >=0 timestamp, lo extra sec bit on
[   14.402278][    T1]     # inode_test_xtimestamp_decoding: ok 8 - 2174-02-25 Upper bound of 32bit >=0 timestamp, lo extra sec bit on
[   14.403526][    T1]     # inode_test_xtimestamp_decoding: ok 9 - 2174-02-25 Lower bound of 32bit <0 timestamp, hi extra sec bit on
[   14.404696][    T1]     # inode_test_xtimestamp_decoding: ok 10 - 2242-03-16 Upper bound of 32bit <0 timestamp, hi extra sec bit on
[   14.405854][    T1]     # inode_test_xtimestamp_decoding: ok 11 - 2242-03-16 Lower bound of 32bit >=0 timestamp, hi extra sec bit on
[   14.407020][    T1]     # inode_test_xtimestamp_decoding: ok 12 - 2310-04-04 Upper bound of 32bit >=0 timestamp, hi extra sec bit on
[   14.408178][    T1]     # inode_test_xtimestamp_decoding: ok 13 - 2310-04-04 Upper bound of 32bit>=0 timestamp, hi extra sec bit 1. 1 ns
[   14.409335][    T1]     # inode_test_xtimestamp_decoding: ok 14 - 2378-04-22 Lower bound of 32bit>= timestamp. Extra sec bits 1. Max ns
[   14.411220][    T1]     # inode_test_xtimestamp_decoding: ok 15 - 2378-04-22 Lower bound of 32bit >=0 timestamp. All extra sec bits on
[   14.412401][    T1]     # inode_test_xtimestamp_decoding: ok 16 - 2446-05-10 Upper bound of 32bit >=0 timestamp. All extra sec bits on
[   14.412926][    T1]     # inode_test_xtimestamp_decoding: pass:16 fail:0 skip:0 total:16
[   14.413434][    T1]     ok 1 - inode_test_xtimestamp_decoding
[   14.413780][    T1] # Totals: pass:16 fail:0 skip:0 total:16
[   14.414032][    T1] ok 2 - ext4_inode_test
[   14.414468][    T1]     # Subtest: lib_sort
[   14.414480][    T1]     1..1
[   14.415945][    T1]     ok 1 - test_sort
[   14.416111][    T1] ok 3 - lib_sort
[   14.416444][    T1]     # Subtest: kunit_executor_test
[   14.416455][    T1]     1..3
[   14.417902][    T1]     ok 1 - filter_subsuite_test
[   14.418905][    T1]     ok 2 - filter_subsuite_to_empty_test
[   14.420261][    T1]     ok 3 - filter_suites_test
[   14.421124][    T1] # kunit_executor_test: pass:3 fail:0 skip:0 total:3
[   14.421343][    T1] # Totals: pass:3 fail:0 skip:0 total:3
[   14.421626][    T1] ok 4 - kunit_executor_test
[   14.422053][    T1]     # Subtest: kunit-try-catch-test
[   14.422065][    T1]     1..2
[   14.424075][    T1]     ok 1 - kunit_test_try_catch_successful_try_no_catch
[   14.425713][    T1]     ok 2 - kunit_test_try_catch_unsuccessful_try_does_catch
[   14.426024][    T1] # kunit-try-catch-test: pass:2 fail:0 skip:0 total:2
[   14.426347][    T1] # Totals: pass:2 fail:0 skip:0 total:2
[   14.426633][    T1] ok 5 - kunit-try-catch-test
[   14.427069][    T1]     # Subtest: kunit-resource-test
[   14.427080][    T1]     1..7
[   14.428173][    T1]     ok 1 - kunit_resource_test_init_resources
[   14.429237][    T1]     ok 2 - kunit_resource_test_alloc_resource
[   14.431621][    T1]     ok 3 - kunit_resource_test_destroy_resource
[   14.432898][    T1]     ok 4 - kunit_resource_test_cleanup_resources
[   14.434190][    T1]     ok 5 - kunit_resource_test_proper_free_ordering
[   14.435279][    T1]     ok 6 - kunit_resource_test_static
[   14.436861][    T1]     ok 7 - kunit_resource_test_named
[   14.437112][    T1] # kunit-resource-test: pass:7 fail:0 skip:0 total:7
[   14.437346][    T1] # Totals: pass:7 fail:0 skip:0 total:7
[   14.437627][    T1] ok 6 - kunit-resource-test
[   14.438049][    T1]     # Subtest: kunit-log-test
[   14.438059][    T1]     1..1
[   14.438771][  T104] put this in log.
[   14.438939][  T104] this too.
[   14.439116][  T104] add to suite log.
[   14.439272][  T104] along with this.
[   14.439707][    T1]     ok 1 - kunit_log_test
[   14.439888][    T1] ok 7 - kunit-log-test
[   14.440257][    T1]     # Subtest: kunit_status
[   14.440268][    T1]     1..2
[   14.441840][    T1]     ok 1 - kunit_status_set_failure_test
[   14.442860][    T1]     ok 2 - kunit_status_mark_skipped_test
[   14.443125][    T1] # kunit_status: pass:2 fail:0 skip:0 total:2
[   14.443377][    T1] # Totals: pass:2 fail:0 skip:0 total:2
[   14.443637][    T1] ok 8 - kunit_status
[   14.444039][    T1]     # Subtest: string-stream-test
[   14.444050][    T1]     1..3
[   14.445245][    T1]     ok 1 - string_stream_test_empty_on_creation
[   14.446679][    T1]     ok 2 - string_stream_test_not_empty_after_add
[   14.448202][    T1]     ok 3 - string_stream_test_get_string
[   14.448495][    T1] # string-stream-test: pass:3 fail:0 skip:0 total:3
[   14.448746][    T1] # Totals: pass:3 fail:0 skip:0 total:3
[   14.449023][    T1] ok 9 - string-stream-test
[   14.449446][    T1]     # Subtest: list-kunit-test
[   14.449457][    T1]     1..36
[   14.451451][    T1]     ok 1 - list_test_list_init
[   14.452493][    T1]     ok 2 - list_test_list_add
[   14.453552][    T1]     ok 3 - list_test_list_add_tail
[   14.454616][    T1]     ok 4 - list_test_list_del
[   14.455644][    T1]     ok 5 - list_test_list_replace
[   14.456671][    T1]     ok 6 - list_test_list_replace_init
[   14.457789][    T1]     ok 7 - list_test_list_swap
[   14.458867][    T1]     ok 8 - list_test_list_del_init
[   14.459925][    T1]     ok 9 - list_test_list_move
[   14.461559][    T1]     ok 10 - list_test_list_move_tail
[   14.462757][    T1]     ok 11 - list_test_list_bulk_move_tail
[   14.463787][    T1]     ok 12 - list_test_list_is_first
[   14.464823][    T1]     ok 13 - list_test_list_is_last
[   14.465859][    T1]     ok 14 - list_test_list_empty
[   14.466872][    T1]     ok 15 - list_test_list_empty_careful
[   14.467928][    T1]     ok 16 - list_test_list_rotate_left
[   14.469065][    T1]     ok 17 - list_test_list_rotate_to_front
[   14.470131][    T1]     ok 18 - list_test_list_is_singular
[   14.471588][    T1]     ok 19 - list_test_list_cut_position
[   14.472793][    T1]     ok 20 - list_test_list_cut_before
[   14.473933][    T1]     ok 21 - list_test_list_splice
[   14.475096][    T1]     ok 22 - list_test_list_splice_tail
[   14.476234][    T1]     ok 23 - list_test_list_splice_init
[   14.477388][    T1]     ok 24 - list_test_list_splice_tail_init
[   14.478401][    T1]     ok 25 - list_test_list_entry
[   14.479436][    T1]     ok 26 - list_test_list_first_entry
[   14.481777][    T1]     ok 27 - list_test_list_last_entry
[   14.482916][    T1]     ok 28 - list_test_list_first_entry_or_null
[   14.483933][    T1]     ok 29 - list_test_list_next_entry
[   14.484971][    T1]     ok 30 - list_test_list_prev_entry
[   14.486050][    T1]     ok 31 - list_test_list_for_each
[   14.487135][    T1]     ok 32 - list_test_list_for_each_prev
[   14.488253][    T1]     ok 33 - list_test_list_for_each_safe
[   14.489385][    T1]     ok 34 - list_test_list_for_each_prev_safe
[   14.491430][    T1]     ok 35 - list_test_list_for_each_entry
[   14.492601][    T1]     ok 36 - list_test_list_for_each_entry_reverse
[   14.492868][    T1] # list-kunit-test: pass:36 fail:0 skip:0 total:36
[   14.493149][    T1] # Totals: pass:36 fail:0 skip:0 total:36
[   14.493425][    T1] ok 10 - list-kunit-test
[   14.493848][    T1]     # Subtest: qos-kunit-test
[   14.493859][    T1]     1..3
[   14.495411][    T1]     ok 1 - freq_qos_test_min
[   14.496624][    T1]     ok 2 - freq_qos_test_maxdef
[   14.497716][    T1]     ok 3 - freq_qos_test_readd
[   14.497949][    T1] # qos-kunit-test: pass:3 fail:0 skip:0 total:3
[   14.498176][    T1] # Totals: pass:3 fail:0 skip:0 total:3
[   14.498441][    T1] ok 11 - qos-kunit-test
[   14.505883][    T1] md: Waiting for all devices to be available before autodetect
[   14.506243][    T1] md: If you don't use raid, use raid=noautodetect
[   14.506595][    T1] md: Autodetecting RAID arrays.
[   14.506868][    T1] md: autorun ...
[   14.507051][    T1] md: ... autorun DONE.
[   14.509976][    T1] 
[   14.510063][    T1] ======================================================
[   14.510243][    T1] WARNING: possible circular locking dependency detected
[   14.510463][    T1] 5.14.0-rc6-next-20210817 #1 Not tainted
[   14.510664][    T1] ------------------------------------------------------
[   14.510835][    T1] swapper/0/1 is trying to acquire lock:
[   14.511006][    T1] c00000000192c620 (mtd_table_mutex){+.+.}-{3:3}, at: blktrans_open+0x60/0x300
[   14.511490][    T1] 
[   14.511490][    T1] but task is already holding lock:
[   14.511672][    T1] c000000005a7b118 (&disk->open_mutex){+.+.}-{3:3}, at: blkdev_get_by_dev+0x20c/0x3c0
[   14.511946][    T1] 
[   14.511946][    T1] which lock already depends on the new lock.
[   14.511946][    T1] 
[   14.512198][    T1] 
[   14.512198][    T1] the existing dependency chain (in reverse order) is:
[   14.512434][    T1] 
[   14.512434][    T1] -> #1 (&disk->open_mutex){+.+.}-{3:3}:
[   14.512676][    T1]        __mutex_lock+0xd8/0xaf0
[   14.512849][    T1]        bd_register_pending_holders+0x48/0x190
[   14.513013][    T1]        device_add_disk+0x27c/0x3d0
[   14.513171][    T1]        add_mtd_blktrans_dev+0x358/0x620
[   14.513332][    T1]        mtdblock_add_mtd+0x94/0x120
[   14.513487][    T1]        blktrans_notify_add+0x7c/0xb0
[   14.513644][    T1]        add_mtd_device+0x3f8/0x600
[   14.513789][    T1]        add_mtd_partitions+0xfc/0x2b0
[   14.513944][    T1]        parse_mtd_partitions+0x2b4/0x980
[   14.514115][    T1]        mtd_device_parse_register+0xc0/0x3a0
[   14.514281][    T1]        powernv_flash_probe+0x180/0x240
[   14.514444][    T1]        platform_probe+0x78/0x120
[   14.514598][    T1]        really_probe+0x1cc/0x440
[   14.514738][    T1]        __driver_probe_device+0xb0/0x160
[   14.514892][    T1]        driver_probe_device+0x60/0x130
[   14.515043][    T1]        __driver_attach+0xe8/0x160
[   14.515188][    T1]        bus_for_each_dev+0xb4/0x130
[   14.515328][    T1]        driver_attach+0x34/0x50
[   14.515466][    T1]        bus_add_driver+0x1d8/0x2b0
[   14.515608][    T1]        driver_register+0x98/0x1a0
[   14.515753][    T1]        __platform_driver_register+0x38/0x50
[   14.515923][    T1]        powernv_flash_driver_init+0x2c/0x40
[   14.516084][    T1]        do_one_initcall+0x88/0x480
[   14.516223][    T1]        kernel_init_freeable+0x3dc/0x484
[   14.516392][    T1]        kernel_init+0x3c/0x180
[   14.516522][    T1]        ret_from_kernel_thread+0x5c/0x64
[   14.516718][    T1] 
[   14.516718][    T1] -> #0 (mtd_table_mutex){+.+.}-{3:3}:
[   14.516917][    T1]        __lock_acquire+0x1b5c/0x21d0
[   14.517068][    T1]        lock_acquire+0x2d8/0x4b0
[   14.517208][    T1]        __mutex_lock+0xd8/0xaf0
[   14.517342][    T1]        blktrans_open+0x60/0x300
[   14.517487][    T1]        blkdev_get_whole+0x50/0x110
[   14.517632][    T1]        blkdev_get_by_dev+0x1dc/0x3c0
[   14.517782][    T1]        blkdev_get_by_path+0x90/0xe0
[   14.517931][    T1]        mount_bdev+0x6c/0x2b0
[   14.518063][    T1]        ext4_mount+0x28/0x40
[   14.518207][    T1]        legacy_get_tree+0x4c/0xb0
[   14.518358][    T1]        vfs_get_tree+0x48/0x100
[   14.518489][    T1]        path_mount+0x2d8/0xd30
[   14.518616][    T1]        init_mount+0x7c/0xcc
[   14.518759][    T1]        mount_block_root+0x230/0x454
[   14.518894][    T1]        prepare_namespace+0x1b0/0x204
[   14.519031][    T1]        kernel_init_freeable+0x428/0x484
[   14.519193][    T1]        kernel_init+0x3c/0x180
[   14.519321][    T1]        ret_from_kernel_thread+0x5c/0x64
[   14.519501][    T1] 
[   14.519501][    T1] other info that might help us debug this:
[   14.519501][    T1] 
[   14.519756][    T1]  Possible unsafe locking scenario:
[   14.519756][    T1] 
[   14.519934][    T1]        CPU0                    CPU1
[   14.520065][    T1]        ----                    ----
[   14.520194][    T1]   lock(&disk->open_mutex);
[   14.520326][    T1]                                lock(mtd_table_mutex);
[   14.520506][    T1]                                lock(&disk->open_mutex);
[   14.520693][    T1]   lock(mtd_table_mutex);
[   14.520822][    T1] 
[   14.520822][    T1]  *** DEADLOCK ***
[   14.520822][    T1] 
[   14.521042][    T1] 1 lock held by swapper/0/1:
[   14.521181][    T1]  #0: c000000005a7b118 (&disk->open_mutex){+.+.}-{3:3}, at: blkdev_get_by_dev+0x20c/0x3c0
[   14.521481][    T1] 
[   14.521481][    T1] stack backtrace:
[   14.521733][    T1] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 5.14.0-rc6-next-20210817 #1
[   14.522127][    T1] Call Trace:
[   14.522256][    T1] [c000000002d072b0] [c0000000009106c8] dump_stack_lvl+0xac/0x108 (unreliable)
[   14.522564][    T1] [c000000002d072f0] [c0000000001aa04c] print_circular_bug.isra.44+0x37c/0x3e0
[   14.522812][    T1] [c000000002d07390] [c0000000001aa270] check_noncircular+0x1c0/0x1f0
[   14.523024][    T1] [c000000002d07460] [c0000000001aff3c] __lock_acquire+0x1b5c/0x21d0
[   14.523236][    T1] [c000000002d075a0] [c0000000001ad2b8] lock_acquire+0x2d8/0x4b0
[   14.523439][    T1] [c000000002d076a0] [c0000000010ae868] __mutex_lock+0xd8/0xaf0
[   14.523644][    T1] [c000000002d077b0] [c000000000bad9f0] blktrans_open+0x60/0x300
[   14.523858][    T1] [c000000002d07800] [c000000000540050] blkdev_get_whole+0x50/0x110
[   14.524069][    T1] [c000000002d07840] [c00000000054289c] blkdev_get_by_dev+0x1dc/0x3c0
[   14.524286][    T1] [c000000002d078a0] [c000000000542e90] blkdev_get_by_path+0x90/0xe0
[   14.524499][    T1] [c000000002d078f0] [c0000000004d148c] mount_bdev+0x6c/0x2b0
[   14.524694][    T1] [c000000002d07990] [c00000000064a0f8] ext4_mount+0x28/0x40
[   14.524887][    T1] [c000000002d079b0] [c0000000005315dc] legacy_get_tree+0x4c/0xb0
[   14.525100][    T1] [c000000002d079e0] [c0000000004cf5e8] vfs_get_tree+0x48/0x100
[   14.525298][    T1] [c000000002d07a50] [c00000000050fbe8] path_mount+0x2d8/0xd30
[   14.525489][    T1] [c000000002d07ae0] [c000000001587874] init_mount+0x7c/0xcc
[   14.525694][    T1] [c000000002d07b50] [c000000001551bd8] mount_block_root+0x230/0x454
[   14.525894][    T1] [c000000002d07c50] [c000000001552058] prepare_namespace+0x1b0/0x204
[   14.526106][    T1] [c000000002d07cc0] [c000000001551714] kernel_init_freeable+0x428/0x484
[   14.526335][    T1] [c000000002d07da0] [c000000000012d1c] kernel_init+0x3c/0x180
[   14.526529][    T1] [c000000002d07e10] [c00000000000cfd4] ret_from_kernel_thread+0x5c/0x64
[   14.567502][    T1] EXT4-fs (mtdblock0): mounted filesystem without journal. Opts: (null). Quota mode: disabled.
[   14.568104][    T1] VFS: Mounted root (ext4 filesystem) readonly on device 31:0.
[   14.572575][    T1] devtmpfs: mounted
[   14.632605][    T1] Freeing unused kernel image (initmem) memory: 1984K
[   14.632873][    T1] Kernel memory protection not selected by kernel config.
[   14.633341][    T1] Run /sbin/init as init process
[   14.633475][    T1]   with arguments:
[   14.633586][    T1]     /sbin/init
[   14.633692][    T1]   with environment:
[   14.633814][    T1]     HOME=/
[   14.633912][    T1]     TERM=linux
[   14.651001][    C0] random: fast init done
[   15.671461][  T152] mount (152) used greatest stack depth: 10048 bytes left
mount: mounting devtmpfs on /dev failed: Device or resource busy
[   15.768631][   T48]  (null): opal_flash_async_op(op=0) failed (rc -1)
[   15.773159][   T48] blk_update_request: I/O error, dev mtdblock0, sector 2 op 0x1:(WRITE) flags 0x800 phys_seg 1 prio class 0
[   15.773787][   T48] blk_update_request: I/O error, dev mtdblock0, sector 2 op 0x1:(WRITE) flags 0x800 phys_seg 1 prio class 0
[   15.774151][   T48] Buffer I/O error on dev mtdblock0, logical block 1, lost sync page write
[   15.775037][  T154] EXT4-fs (mtdblock0): I/O error while writing superblock
mount: mounting /dev/root on / failed: Input/output error
Starting syslogd: OK
Starting klogd: OK
Running sysctl: [   16.730207][  T179] logger (179) used greatest stack depth: 9920 bytes left
OK
Saving random seed: SKIP (read-only file system detected)
Starting network: [   17.450126][  T195] 8139cp 0000:01:00.0 eth0: link up, 100Mbps, full-duplex, lpa 0x05E1
udhcpc: started, v1.33.0
udhcpc: sending discover
udhcpc: sending select for 10.0.2.15
udhcpc: lease of 10.0.2.15 obtained, lease time 86400
deleting routers
adding dns 10.0.2.3
OK
Found console hvc0

Linux version 5.14.0-rc6-next-20210817 (groeck@server.roeck-us.net) (powerpc64-linux-gcc.br_real (Buildroot 2019.02-git-00353-g4f20f23) 7.4.0, GNU ld (GNU Binutils) 2.31.1) #1 SMP Tue Aug 17 19:13:07 PDT 2021
[   18.515763][  T227] telnet (227) used greatest stack depth: 8528 bytes left
Network interface test passed
Boot successful.
Rebooting
[   34.724800][  T232] reboot: Restarting system
[   48.142228983,5] OPAL: Reboot request...
[   48.142294919,2] NVRAM: Failed to load
------------

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

