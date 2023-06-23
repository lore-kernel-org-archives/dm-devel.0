Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7314AEB64D7
	for <dm-devel@archiver.kernel.org>; Fri, 23 Jun 2023 03:24:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1687490658;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=tea47q8AL2MeNxnjnQWR8xnIJn5AVFEYTqYE8azmzFo=;
	b=Am7URzOOyjn+dzhwWWFrYDnqP/T4Tgi4/vfR4Z0popFnPO/Ni+OlE4n5BpSGXQTglrs4f9
	mfcJzHA1ijeVMGPvkHWTSBQdDlUCzvFsbt8mp/0UiC/B9o0jraegEAlrsTpqZi8v9d2aFZ
	Wx39vGmZMdY4B+K9or45f60iA+8fH38=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-613-mSNg7EbsMtiu6kwKEwM1bg-1; Thu, 22 Jun 2023 23:24:15 -0400
X-MC-Unique: mSNg7EbsMtiu6kwKEwM1bg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6B9EC88D1B7;
	Fri, 23 Jun 2023 03:24:13 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id CFC49140EBB8;
	Fri, 23 Jun 2023 03:24:09 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 817861946588;
	Fri, 23 Jun 2023 03:24:09 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 5B3F81946587
 for <dm-devel@listman.corp.redhat.com>; Fri, 23 Jun 2023 03:24:08 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 4935E14682FA; Fri, 23 Jun 2023 03:24:08 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 41E6E140EBB8
 for <dm-devel@redhat.com>; Fri, 23 Jun 2023 03:24:08 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-inbound-delivery-1.mimecast.com
 [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 109D53C01BA9
 for <dm-devel@redhat.com>; Fri, 23 Jun 2023 03:24:08 +0000 (UTC)
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-426-pBLajp_nOjOT66h4wfNkFw-1; Thu, 22 Jun 2023 23:24:02 -0400
X-MC-Unique: pBLajp_nOjOT66h4wfNkFw-1
X-IronPort-AV: E=McAfee;i="6600,9927,10749"; a="350440066"
X-IronPort-AV: E=Sophos;i="6.01,150,1684825200"; d="scan'208";a="350440066"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
 by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
 22 Jun 2023 20:22:57 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10749"; a="744849072"
X-IronPort-AV: E=Sophos;i="6.01,150,1684825200"; d="scan'208";a="744849072"
Received: from lkp-server01.sh.intel.com (HELO 783282924a45) ([10.239.97.150])
 by orsmga008.jf.intel.com with ESMTP; 22 Jun 2023 20:22:55 -0700
Received: from kbuild by 783282924a45 with local (Exim 4.96)
 (envelope-from <lkp@intel.com>) id 1qCXNu-0007xN-2o;
 Fri, 23 Jun 2023 03:22:54 +0000
Date: Fri, 23 Jun 2023 11:22:23 +0800
From: kernel test robot <lkp@intel.com>
To: Demi Marie Obenour <demi@invisiblethingslab.com>
Message-ID: <202306231121.8VDClqLC-lkp@intel.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
Subject: [dm-devel] [device-mapper-dm:for-next 19/24]
 drivers/md/dm-ioctl.c:1402:15: warning: format specifies type 'unsigned
 long' but the argument has type 'unsigned int'
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
Cc: Mikulas Patocka <mpatocka@redhat.com>, dm-devel@redhat.com,
 llvm@lists.linux.dev, Mike Snitzer <snitzer@kernel.org>,
 oe-kbuild-all@lists.linux.dev
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: intel.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git for-next
head:   7d8bae011ec676d6c0a6ea18f2b74c9c32d57849
commit: 5df1daff2cc63af7971c0643134f3372aa3b33a1 [19/24] dm ioctl: Check dm_target_spec is sufficiently aligned
config: hexagon-randconfig-r041-20230622 (https://download.01.org/0day-ci/archive/20230623/202306231121.8VDClqLC-lkp@intel.com/config)
compiler: clang version 17.0.0 (https://github.com/llvm/llvm-project.git 4a5ac14ee968ff0ad5d2cc1ffa0299048db4c88a)
reproduce: (https://download.01.org/0day-ci/archive/20230623/202306231121.8VDClqLC-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202306231121.8VDClqLC-lkp@intel.com/

All warnings (new ones prefixed by >>):

   In file included from drivers/md/dm-ioctl.c:9:
   In file included from drivers/md/dm-core.h:15:
   In file included from include/linux/blk-mq.h:5:
   In file included from include/linux/blkdev.h:9:
   In file included from include/linux/blk_types.h:10:
   In file included from include/linux/bvec.h:10:
   In file included from include/linux/highmem.h:12:
   In file included from include/linux/hardirq.h:11:
   In file included from ./arch/hexagon/include/generated/asm/hardirq.h:1:
   In file included from include/asm-generic/hardirq.h:17:
   In file included from include/linux/irq.h:20:
   In file included from include/linux/io.h:13:
   In file included from arch/hexagon/include/asm/io.h:334:
   include/asm-generic/io.h:547:31: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
     547 |         val = __raw_readb(PCI_IOBASE + addr);
         |                           ~~~~~~~~~~ ^
   include/asm-generic/io.h:560:61: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
     560 |         val = __le16_to_cpu((__le16 __force)__raw_readw(PCI_IOBASE + addr));
         |                                                         ~~~~~~~~~~ ^
   include/uapi/linux/byteorder/little_endian.h:37:51: note: expanded from macro '__le16_to_cpu'
      37 | #define __le16_to_cpu(x) ((__force __u16)(__le16)(x))
         |                                                   ^
   In file included from drivers/md/dm-ioctl.c:9:
   In file included from drivers/md/dm-core.h:15:
   In file included from include/linux/blk-mq.h:5:
   In file included from include/linux/blkdev.h:9:
   In file included from include/linux/blk_types.h:10:
   In file included from include/linux/bvec.h:10:
   In file included from include/linux/highmem.h:12:
   In file included from include/linux/hardirq.h:11:
   In file included from ./arch/hexagon/include/generated/asm/hardirq.h:1:
   In file included from include/asm-generic/hardirq.h:17:
   In file included from include/linux/irq.h:20:
   In file included from include/linux/io.h:13:
   In file included from arch/hexagon/include/asm/io.h:334:
   include/asm-generic/io.h:573:61: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
     573 |         val = __le32_to_cpu((__le32 __force)__raw_readl(PCI_IOBASE + addr));
         |                                                         ~~~~~~~~~~ ^
   include/uapi/linux/byteorder/little_endian.h:35:51: note: expanded from macro '__le32_to_cpu'
      35 | #define __le32_to_cpu(x) ((__force __u32)(__le32)(x))
         |                                                   ^
   In file included from drivers/md/dm-ioctl.c:9:
   In file included from drivers/md/dm-core.h:15:
   In file included from include/linux/blk-mq.h:5:
   In file included from include/linux/blkdev.h:9:
   In file included from include/linux/blk_types.h:10:
   In file included from include/linux/bvec.h:10:
   In file included from include/linux/highmem.h:12:
   In file included from include/linux/hardirq.h:11:
   In file included from ./arch/hexagon/include/generated/asm/hardirq.h:1:
   In file included from include/asm-generic/hardirq.h:17:
   In file included from include/linux/irq.h:20:
   In file included from include/linux/io.h:13:
   In file included from arch/hexagon/include/asm/io.h:334:
   include/asm-generic/io.h:584:33: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
     584 |         __raw_writeb(value, PCI_IOBASE + addr);
         |                             ~~~~~~~~~~ ^
   include/asm-generic/io.h:594:59: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
     594 |         __raw_writew((u16 __force)cpu_to_le16(value), PCI_IOBASE + addr);
         |                                                       ~~~~~~~~~~ ^
   include/asm-generic/io.h:604:59: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
     604 |         __raw_writel((u32 __force)cpu_to_le32(value), PCI_IOBASE + addr);
         |                                                       ~~~~~~~~~~ ^
>> drivers/md/dm-ioctl.c:1402:15: warning: format specifies type 'unsigned long' but the argument has type 'unsigned int' [-Wformat]
    1402 |                 DMERR("Next dm_target_spec (offset %u) is not %lu-byte aligned",
         |                                                               ~~~
         |                                                               %u
    1403 |                       next, __alignof__(struct dm_target_spec));
         |                             ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/device-mapper.h:626:47: note: expanded from macro 'DMERR'
     626 | #define DMERR(fmt, ...) pr_err(DM_FMT(fmt), ##__VA_ARGS__)
         |                                       ~~~     ^~~~~~~~~~~
   include/linux/printk.h:498:33: note: expanded from macro 'pr_err'
     498 |         printk(KERN_ERR pr_fmt(fmt), ##__VA_ARGS__)
         |                                ~~~     ^~~~~~~~~~~
   include/linux/printk.h:455:60: note: expanded from macro 'printk'
     455 | #define printk(fmt, ...) printk_index_wrap(_printk, fmt, ##__VA_ARGS__)
         |                                                     ~~~    ^~~~~~~~~~~
   include/linux/printk.h:427:19: note: expanded from macro 'printk_index_wrap'
     427 |                 _p_func(_fmt, ##__VA_ARGS__);                           \
         |                         ~~~~    ^~~~~~~~~~~
   7 warnings generated.


vim +1402 drivers/md/dm-ioctl.c

  1393	
  1394	static int next_target(struct dm_target_spec *last, uint32_t next, void *end,
  1395			       struct dm_target_spec **spec, char **target_params)
  1396	{
  1397		static_assert(__alignof__(struct dm_target_spec) <= 8,
  1398			"struct dm_target_spec must not require more than 8-byte alignment");
  1399	
  1400		if (next % __alignof__(struct dm_target_spec)) {
  1401			DMERR("Next dm_target_spec (offset %u) is not %lu-byte aligned",
> 1402			      next, __alignof__(struct dm_target_spec));
  1403			return -EINVAL;
  1404		}
  1405	
  1406		*spec = (struct dm_target_spec *) ((unsigned char *) last + next);
  1407		*target_params = (char *) (*spec + 1);
  1408	
  1409		if (*spec < (last + 1))
  1410			return -EINVAL;
  1411	
  1412		return invalid_str(*target_params, end);
  1413	}
  1414	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

