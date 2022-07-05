Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C5544C433EF
	for <dm-devel@archiver.kernel.org>; Tue,  5 Jul 2022 22:05:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1657058754;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=fRIHRq/3U/bpZjgSSnb/4/DQ2kTzF6hTfZ45uqcf6bo=;
	b=Z15+ovfCtQiXNtgIgsLFZJWuguBYMzAVPxHyZrOVesDyq/fXPl97U4SDsy1FqRKWAoD14E
	UH/UdsijIDFh0GzBeVLbw2AP859CMB7cUqnIdVCGdGRZhsiseEAb8Jb52lD38aQzp+UxLx
	IdTC7bnh/rF9MbY/5n+ZtIej9kx17Qk=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-370-tsNfBOg9MAWjyjTR4zL9hg-1; Tue, 05 Jul 2022 18:05:17 -0400
X-MC-Unique: tsNfBOg9MAWjyjTR4zL9hg-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 699E8101A58E;
	Tue,  5 Jul 2022 22:02:06 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id D950C492CA3;
	Tue,  5 Jul 2022 22:02:03 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id B251C194705E;
	Tue,  5 Jul 2022 22:02:03 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 1D521194705D
 for <dm-devel@listman.corp.redhat.com>; Tue,  5 Jul 2022 22:02:02 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 119941402400; Tue,  5 Jul 2022 22:02:02 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 0D270140EBE4
 for <dm-devel@redhat.com>; Tue,  5 Jul 2022 22:02:01 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D29E61C05EB9
 for <dm-devel@redhat.com>; Tue,  5 Jul 2022 22:02:01 +0000 (UTC)
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-455-aGALGCBuPjeAuD8KToksng-1; Tue, 05 Jul 2022 18:01:59 -0400
X-MC-Unique: aGALGCBuPjeAuD8KToksng-1
X-IronPort-AV: E=McAfee;i="6400,9594,10399"; a="283557588"
X-IronPort-AV: E=Sophos;i="5.92,248,1650956400"; d="scan'208";a="283557588"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
 by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
 05 Jul 2022 15:01:58 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,248,1650956400"; d="scan'208";a="839280084"
Received: from lkp-server01.sh.intel.com (HELO 68b931ab7ac1) ([10.239.97.150])
 by fmsmga006.fm.intel.com with ESMTP; 05 Jul 2022 15:01:57 -0700
Received: from kbuild by 68b931ab7ac1 with local (Exim 4.95)
 (envelope-from <lkp@intel.com>) id 1o8qcG-000JdI-W0;
 Tue, 05 Jul 2022 22:01:56 +0000
Date: Wed, 6 Jul 2022 06:01:08 +0800
From: kernel test robot <lkp@intel.com>
To: Mike Snitzer <snitzer@kernel.org>
Message-ID: <202207060517.Wb6x2AW3-lkp@intel.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
Subject: [dm-devel] [device-mapper-dm:dm-5.20 6/7]
 drivers/md/dm-io-rewind.c:95:39: error: 'struct bio' has no member named
 'bi_crypt_context'
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
Cc: dm-devel@redhat.com, kbuild-all@lists.01.org, linux-kernel@vger.kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git dm-5.20
head:   e08bc02c4a6c7cdcbe85ce84db9307203de01926
commit: fa88c146eb6b5d9c2c0946e39a4b19ade94b47a0 [6/7] dm: move bio_rewind local to DM core
config: i386-defconfig (https://download.01.org/0day-ci/archive/20220706/202207060517.Wb6x2AW3-lkp@intel.com/config)
compiler: gcc-11 (Debian 11.3.0-3) 11.3.0
reproduce (this is a W=1 build):
        # https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git/commit/?id=fa88c146eb6b5d9c2c0946e39a4b19ade94b47a0
        git remote add device-mapper-dm https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git
        git fetch --no-tags device-mapper-dm dm-5.20
        git checkout fa88c146eb6b5d9c2c0946e39a4b19ade94b47a0
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        make W=1 O=build_dir ARCH=i386 SHELL=/bin/bash

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   drivers/md/dm-io-rewind.c: In function '__bio_crypt_rewind':
>> drivers/md/dm-io-rewind.c:95:39: error: 'struct bio' has no member named 'bi_crypt_context'
      95 |         struct bio_crypt_ctx *bc = bio->bi_crypt_context;
         |                                       ^~


vim +95 drivers/md/dm-io-rewind.c

    92	
    93	static void __bio_crypt_rewind(struct bio *bio, unsigned int bytes)
    94	{
  > 95		struct bio_crypt_ctx *bc = bio->bi_crypt_context;
    96	
    97		bio_crypt_dun_decrement(bc->bc_dun,
    98					bytes >> bc->bc_key->data_unit_size_bits);
    99	}
   100	

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

