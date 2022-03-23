Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2A27DC433EF
	for <dm-devel@archiver.kernel.org>; Wed, 23 Mar 2022 22:38:24 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-155-gOwrUwSeM9-PStw4AT2DaA-1; Wed, 23 Mar 2022 18:38:20 -0400
X-MC-Unique: gOwrUwSeM9-PStw4AT2DaA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5483F811E78;
	Wed, 23 Mar 2022 22:38:18 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 031E240FF409;
	Wed, 23 Mar 2022 22:38:18 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 8EFCB1940347;
	Wed, 23 Mar 2022 22:38:17 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 8252B1949763
 for <dm-devel@listman.corp.redhat.com>; Wed, 23 Mar 2022 22:38:16 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 6CA4B40FF40C; Wed, 23 Mar 2022 22:38:16 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 68BE140FF409
 for <dm-devel@redhat.com>; Wed, 23 Mar 2022 22:38:16 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4EE323804077
 for <dm-devel@redhat.com>; Wed, 23 Mar 2022 22:38:16 +0000 (UTC)
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-197-tgoXsSLVOmqmFZ6YKQDmTA-1; Wed, 23 Mar 2022 18:38:14 -0400
X-MC-Unique: tgoXsSLVOmqmFZ6YKQDmTA-1
X-IronPort-AV: E=McAfee;i="6200,9189,10295"; a="238183268"
X-IronPort-AV: E=Sophos;i="5.90,205,1643702400"; d="scan'208";a="238183268"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
 by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
 23 Mar 2022 15:38:13 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,205,1643702400"; d="scan'208";a="501175344"
Received: from lkp-server02.sh.intel.com (HELO 89b41b6ae01c) ([10.239.97.151])
 by orsmga003.jf.intel.com with ESMTP; 23 Mar 2022 15:38:11 -0700
Received: from kbuild by 89b41b6ae01c with local (Exim 4.92)
 (envelope-from <lkp@intel.com>)
 id 1nX9cI-000KRJ-Lw; Wed, 23 Mar 2022 22:38:10 +0000
Date: Thu, 24 Mar 2022 06:37:15 +0800
From: kernel test robot <lkp@intel.com>
To: Mike Snitzer <snitzer@kernel.org>
Message-ID: <202203240618.diX27ri2-lkp@intel.com>
MIME-Version: 1.0
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Subject: [dm-devel] [device-mapper-dm:dm-5.19 132/132]
 drivers/md/dm.c:1542:4: error: use of undeclared identifier 'result'
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
Cc: dm-devel@redhat.com, llvm@lists.linux.dev, kbuild-all@lists.01.org,
 linux-kernel@vger.kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git dm-5.19
head:   7f8ac95a6464b895e3d2b6175f7ee64a4c10fcfe
commit: 7f8ac95a6464b895e3d2b6175f7ee64a4c10fcfe [132/132] dm: push error handling down to __split_and_process_bio
config: x86_64-randconfig-a012 (https://download.01.org/0day-ci/archive/20220324/202203240618.diX27ri2-lkp@intel.com/config)
compiler: clang version 15.0.0 (https://github.com/llvm/llvm-project 902f4708fe1d03b0de7e5315ef875006a6adc319)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git/commit/?id=7f8ac95a6464b895e3d2b6175f7ee64a4c10fcfe
        git remote add device-mapper-dm https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git
        git fetch --no-tags device-mapper-dm dm-5.19
        git checkout 7f8ac95a6464b895e3d2b6175f7ee64a4c10fcfe
        # save the config file to linux build tree
        mkdir build_dir
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=x86_64 SHELL=/bin/bash drivers/md/

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

>> drivers/md/dm.c:1542:4: error: use of undeclared identifier 'result'
                   *result = BLK_STS_NOTSUPP;
                    ^
   drivers/md/dm.c:1545:4: error: use of undeclared identifier 'result'
                   *result = BLK_STS_OK;
                    ^
   2 errors generated.


vim +/result +1542 drivers/md/dm.c

  1508	
  1509	static bool __process_abnormal_io(struct clone_info *ci, struct dm_target *ti,
  1510					  blk_status_t *status)
  1511	{
  1512		unsigned num_bios;
  1513	
  1514		if (!is_abnormal_io(ci->bio))
  1515			return false;
  1516	
  1517		num_bios = 0;
  1518		switch (bio_op(ci->bio)) {
  1519		case REQ_OP_DISCARD:
  1520			num_bios = ti->num_discard_bios;
  1521			break;
  1522		case REQ_OP_SECURE_ERASE:
  1523			num_bios = ti->num_secure_erase_bios;
  1524			break;
  1525		case REQ_OP_WRITE_SAME:
  1526			num_bios = ti->num_write_same_bios;
  1527			break;
  1528		case REQ_OP_WRITE_ZEROES:
  1529			num_bios = ti->num_write_zeroes_bios;
  1530			break;
  1531		default:
  1532			return false;
  1533		}
  1534	
  1535		/*
  1536		 * Even though the device advertised support for this type of
  1537		 * request, that does not mean every target supports it, and
  1538		 * reconfiguration might also have changed that since the
  1539		 * check was performed.
  1540		 */
  1541		if (!num_bios)
> 1542			*result = BLK_STS_NOTSUPP;
  1543		else {
  1544			__send_changing_extent_only(ci, ti, num_bios);
  1545			*result = BLK_STS_OK;
  1546		}
  1547		return true;
  1548	}
  1549	

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

