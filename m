Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1EB0BC636D6
	for <dm-devel@archiver.kernel.org>; Mon, 20 Feb 2023 21:57:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1676930271;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=/Hbgri6DahuHHi3Eaxvfacakl/RAQkAZEvL0HuyEuk4=;
	b=DsKQyIuBWxDPwHkrQsLBFI8De++zSb5EKkETXUtXCMVhPOMBSkt+/va5xDyNpW6OBJ2tMf
	v9mD9nEcRDof6Yed9z77RyAMLFfHPZkHoJpfuP0RuII/MUVHhcaasdFLTBoKDt5Pr/0OB3
	wcoWZ2Z964lhQuTR0bsx2DYt+urUccQ=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-589-Gq8pElG8OPWoVNI-XmU5_Q-1; Mon, 20 Feb 2023 16:57:48 -0500
X-MC-Unique: Gq8pElG8OPWoVNI-XmU5_Q-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4ED6B3C0E448;
	Mon, 20 Feb 2023 21:57:46 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 0C533140EBF6;
	Mon, 20 Feb 2023 21:57:44 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id DDE011946587;
	Mon, 20 Feb 2023 21:57:43 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 352811946586
 for <dm-devel@listman.corp.redhat.com>; Mon, 20 Feb 2023 21:57:42 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 142A4C15BAE; Mon, 20 Feb 2023 21:57:42 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 0C135C15BAD
 for <dm-devel@redhat.com>; Mon, 20 Feb 2023 21:57:41 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D3C3685A5A3
 for <dm-devel@redhat.com>; Mon, 20 Feb 2023 21:57:41 +0000 (UTC)
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-584-1IJP6QfBNni0K5otNMoJaQ-1; Mon, 20 Feb 2023 16:57:38 -0500
X-MC-Unique: 1IJP6QfBNni0K5otNMoJaQ-1
X-IronPort-AV: E=McAfee;i="6500,9779,10627"; a="320621935"
X-IronPort-AV: E=Sophos;i="5.97,313,1669104000"; d="scan'208";a="320621935"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
 by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
 20 Feb 2023 13:57:36 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10627"; a="845438006"
X-IronPort-AV: E=Sophos;i="5.97,313,1669104000"; d="scan'208";a="845438006"
Received: from lkp-server01.sh.intel.com (HELO 4455601a8d94) ([10.239.97.150])
 by orsmga005.jf.intel.com with ESMTP; 20 Feb 2023 13:57:31 -0800
Received: from kbuild by 4455601a8d94 with local (Exim 4.96)
 (envelope-from <lkp@intel.com>) id 1pUEA6-000ECb-1f;
 Mon, 20 Feb 2023 21:57:30 +0000
Date: Tue, 21 Feb 2023 05:56:58 +0800
From: kernel test robot <lkp@intel.com>
To: Nitesh Shetty <nj.shetty@samsung.com>, Jens Axboe <axboe@kernel.dk>,
 Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
 dm-devel@redhat.com, Keith Busch <kbusch@kernel.org>,
 Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>,
 James Smart <james.smart@broadcom.com>,
 Chaitanya Kulkarni <kch@nvidia.com>,
 Alexander Viro <viro@zeniv.linux.org.uk>
Message-ID: <202302210520.EIfbuJLy-lkp@intel.com>
References: <20230220105336.3810-5-nj.shetty@samsung.com>
MIME-Version: 1.0
In-Reply-To: <20230220105336.3810-5-nj.shetty@samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
Subject: Re: [dm-devel] [PATCH v7 4/8] fs,
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
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi Nitesh,

Thank you for the patch! Yet something to improve:

[auto build test ERROR on device-mapper-dm/for-next]
[also build test ERROR on linus/master v6.2 next-20230220]
[cannot apply to axboe-block/for-next]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Nitesh-Shetty/block-Add-copy-offload-support-infrastructure/20230220-205057
base:   https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git for-next
patch link:    https://lore.kernel.org/r/20230220105336.3810-5-nj.shetty%40samsung.com
patch subject: [PATCH v7 4/8] fs, block: copy_file_range for def_blk_ops for direct block device.
config: riscv-randconfig-r042-20230219 (https://download.01.org/0day-ci/archive/20230221/202302210520.EIfbuJLy-lkp@intel.com/config)
compiler: riscv64-linux-gcc (GCC) 12.1.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/0f95ad2cb727ac6ac8406a01ff216d9237b403b7
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Nitesh-Shetty/block-Add-copy-offload-support-infrastructure/20230220-205057
        git checkout 0f95ad2cb727ac6ac8406a01ff216d9237b403b7
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=riscv olddefconfig
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=riscv SHELL=/bin/bash

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>
| Link: https://lore.kernel.org/oe-kbuild-all/202302210520.EIfbuJLy-lkp@intel.com/

All errors (new ones prefixed by >>):

   riscv64-linux-ld: fs/read_write.o: in function `__do_compat_sys_preadv2':
>> fs/read_write.c:1134: undefined reference to `I_BDEV'


vim +1134 fs/read_write.c

3ebfd81f7fb3e8 H.J. Lu           2016-07-14  1128  
f17d8b35452cab Milosz Tanski     2016-03-03  1129  COMPAT_SYSCALL_DEFINE6(preadv2, compat_ulong_t, fd,
3523a9d4547898 Christoph Hellwig 2020-09-25  1130  		const struct iovec __user *, vec,
f17d8b35452cab Milosz Tanski     2016-03-03  1131  		compat_ulong_t, vlen, u32, pos_low, u32, pos_high,
ddef7ed2b5cbaf Christoph Hellwig 2017-07-06  1132  		rwf_t, flags)
f17d8b35452cab Milosz Tanski     2016-03-03  1133  {
f17d8b35452cab Milosz Tanski     2016-03-03 @1134  	loff_t pos = ((loff_t)pos_high << 32) | pos_low;
f17d8b35452cab Milosz Tanski     2016-03-03  1135  
f17d8b35452cab Milosz Tanski     2016-03-03  1136  	if (pos == -1)
3523a9d4547898 Christoph Hellwig 2020-09-25  1137  		return do_readv(fd, vec, vlen, flags);
3523a9d4547898 Christoph Hellwig 2020-09-25  1138  	return do_preadv(fd, vec, vlen, pos, flags);
72ec35163f9f72 Al Viro           2013-03-20  1139  }
72ec35163f9f72 Al Viro           2013-03-20  1140  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

