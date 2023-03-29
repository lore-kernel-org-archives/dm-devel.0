Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CBB01C74A5B
	for <dm-devel@archiver.kernel.org>; Wed, 29 Mar 2023 15:36:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1680104167;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=oT1ZvG9mNU4B2Zj8n/OFih7ZW+bVB8ykFFYxyIvq2XI=;
	b=TKA19PhxxjaNN8rv3RdbtujVqdePU9ekupagACbyD+mwnFq5MF1shrQ9aip9HV5NFrVsUl
	/P88aqH33yq7U1Yyc+qPqJvwhPtNZDuADQMNb7nww0+gKewUiGxumuPqxbToRFIoFHndb1
	Qv4mnLgchC/Ce2H6avVucpFe5IkJBSY=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-315-qnKGUrqzM7eOOSR_8ZDPaA-1; Wed, 29 Mar 2023 11:36:06 -0400
X-MC-Unique: qnKGUrqzM7eOOSR_8ZDPaA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 25BAA28043D1;
	Wed, 29 Mar 2023 15:36:03 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id B79FA1402C06;
	Wed, 29 Mar 2023 15:36:01 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 737161946588;
	Wed, 29 Mar 2023 15:36:01 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 7ECB61946587
 for <dm-devel@listman.corp.redhat.com>; Wed, 29 Mar 2023 15:35:34 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 6CEF42166B34; Wed, 29 Mar 2023 15:35:34 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 651572166B33
 for <dm-devel@redhat.com>; Wed, 29 Mar 2023 15:35:34 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4753C8030D0
 for <dm-devel@redhat.com>; Wed, 29 Mar 2023 15:35:34 +0000 (UTC)
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-52-KiEsJYZQO1aYc-121qRQ2A-1; Wed, 29 Mar 2023 11:35:32 -0400
X-MC-Unique: KiEsJYZQO1aYc-121qRQ2A-1
X-IronPort-AV: E=McAfee;i="6600,9927,10664"; a="340935266"
X-IronPort-AV: E=Sophos;i="5.98,301,1673942400"; d="scan'208";a="340935266"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
 by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
 29 Mar 2023 08:31:04 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10664"; a="677812139"
X-IronPort-AV: E=Sophos;i="5.98,301,1673942400"; d="scan'208";a="677812139"
Received: from lkp-server01.sh.intel.com (HELO b613635ddfff) ([10.239.97.150])
 by orsmga007.jf.intel.com with ESMTP; 29 Mar 2023 08:30:58 -0700
Received: from kbuild by b613635ddfff with local (Exim 4.96)
 (envelope-from <lkp@intel.com>) id 1phXlK-000JfU-0G;
 Wed, 29 Mar 2023 15:30:58 +0000
Date: Wed, 29 Mar 2023 23:30:26 +0800
From: kernel test robot <lkp@intel.com>
To: Anuj Gupta <anuj20.g@samsung.com>, Jens Axboe <axboe@kernel.dk>,
 Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
 dm-devel@redhat.com, Keith Busch <kbusch@kernel.org>,
 Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>,
 James Smart <james.smart@broadcom.com>,
 Chaitanya Kulkarni <kch@nvidia.com>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>
Message-ID: <202303292349.ED70Fxdw-lkp@intel.com>
References: <20230327084103.21601-5-anuj20.g@samsung.com>
MIME-Version: 1.0
In-Reply-To: <20230327084103.21601-5-anuj20.g@samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
Subject: Re: [dm-devel] [PATCH v8 4/9] fs,
 block: copy_file_range for def_blk_ops for direct block device.
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
Cc: bvanassche@acm.org, joshi.k@samsung.com,
 Nitesh Shetty <nj.shetty@samsung.com>, gost.dev@samsung.com,
 anuj20.g@samsung.com, linux-kernel@vger.kernel.org,
 linux-nvme@lists.infradead.org, ming.lei@redhat.com,
 linux-block@vger.kernel.org, oe-kbuild-all@lists.linux.dev,
 linux-fsdevel@vger.kernel.org, damien.lemoal@opensource.wdc.com,
 nitheshshetty@gmail.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: intel.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi Anuj,

Thank you for the patch! Yet something to improve:

[auto build test ERROR on axboe-block/for-next]
[also build test ERROR on device-mapper-dm/for-next linus/master v6.3-rc4 next-20230329]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Anuj-Gupta/block-Add-copy-offload-support-infrastructure/20230329-162018
base:   https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux-block.git for-next
patch link:    https://lore.kernel.org/r/20230327084103.21601-5-anuj20.g%40samsung.com
patch subject: [PATCH v8 4/9] fs, block: copy_file_range for def_blk_ops for direct block device.
config: x86_64-randconfig-a013 (https://download.01.org/0day-ci/archive/20230329/202303292349.ED70Fxdw-lkp@intel.com/config)
compiler: gcc-11 (Debian 11.3.0-8) 11.3.0
reproduce (this is a W=1 build):
        # https://github.com/intel-lab-lkp/linux/commit/61819d260936954ddd6688548f074e7063dcf39e
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Anuj-Gupta/block-Add-copy-offload-support-infrastructure/20230329-162018
        git checkout 61819d260936954ddd6688548f074e7063dcf39e
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        make W=1 O=build_dir ARCH=x86_64 olddefconfig
        make W=1 O=build_dir ARCH=x86_64 SHELL=/bin/bash

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>
| Link: https://lore.kernel.org/oe-kbuild-all/202303292349.ED70Fxdw-lkp@intel.com/

All errors (new ones prefixed by >>):

   ld: vmlinux.o: in function `generic_copy_file_checks':
>> fs/read_write.c:1453: undefined reference to `I_BDEV'


vim +1453 fs/read_write.c

  1398	
  1399	/*
  1400	 * Performs necessary checks before doing a file copy
  1401	 *
  1402	 * Can adjust amount of bytes to copy via @req_count argument.
  1403	 * Returns appropriate error code that caller should return or
  1404	 * zero in case the copy should be allowed.
  1405	 */
  1406	static int generic_copy_file_checks(struct file *file_in, loff_t pos_in,
  1407					    struct file *file_out, loff_t pos_out,
  1408					    size_t *req_count, unsigned int flags)
  1409	{
  1410		struct inode *inode_in = file_inode(file_in);
  1411		struct inode *inode_out = file_inode(file_out);
  1412		uint64_t count = *req_count;
  1413		loff_t size_in;
  1414		int ret;
  1415	
  1416		ret = generic_file_rw_checks(file_in, file_out);
  1417		if (ret)
  1418			return ret;
  1419	
  1420		/*
  1421		 * We allow some filesystems to handle cross sb copy, but passing
  1422		 * a file of the wrong filesystem type to filesystem driver can result
  1423		 * in an attempt to dereference the wrong type of ->private_data, so
  1424		 * avoid doing that until we really have a good reason.
  1425		 *
  1426		 * nfs and cifs define several different file_system_type structures
  1427		 * and several different sets of file_operations, but they all end up
  1428		 * using the same ->copy_file_range() function pointer.
  1429		 */
  1430		if (flags & COPY_FILE_SPLICE) {
  1431			/* cross sb splice is allowed */
  1432		} else if (file_out->f_op->copy_file_range) {
  1433			if (file_in->f_op->copy_file_range !=
  1434			    file_out->f_op->copy_file_range)
  1435				return -EXDEV;
  1436		} else if (file_inode(file_in)->i_sb != file_inode(file_out)->i_sb) {
  1437			return -EXDEV;
  1438		}
  1439	
  1440		/* Don't touch certain kinds of inodes */
  1441		if (IS_IMMUTABLE(inode_out))
  1442			return -EPERM;
  1443	
  1444		if (IS_SWAPFILE(inode_in) || IS_SWAPFILE(inode_out))
  1445			return -ETXTBSY;
  1446	
  1447		/* Ensure offsets don't wrap. */
  1448		if (pos_in + count < pos_in || pos_out + count < pos_out)
  1449			return -EOVERFLOW;
  1450	
  1451		/* Shorten the copy to EOF */
  1452		if (S_ISBLK(inode_in->i_mode))
> 1453			size_in = bdev_nr_bytes(I_BDEV(file_in->f_mapping->host));
  1454		else
  1455			size_in = i_size_read(inode_in);
  1456	
  1457		if (pos_in >= size_in)
  1458			count = 0;
  1459		else
  1460			count = min(count, size_in - (uint64_t)pos_in);
  1461	
  1462		ret = generic_write_check_limits(file_out, pos_out, &count);
  1463		if (ret)
  1464			return ret;
  1465	
  1466		/* Don't allow overlapped copying within the same file. */
  1467		if (inode_in == inode_out &&
  1468		    pos_out + count > pos_in &&
  1469		    pos_out < pos_in + count)
  1470			return -EINVAL;
  1471	
  1472		*req_count = count;
  1473		return 0;
  1474	}
  1475	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

