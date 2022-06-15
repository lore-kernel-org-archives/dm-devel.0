Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CC7E1C43334
	for <dm-devel@archiver.kernel.org>; Wed, 15 Jun 2022 14:20:37 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-641-P1lcjtB9PgujXyaGvto4Pg-1; Wed, 15 Jun 2022 10:20:33 -0400
X-MC-Unique: P1lcjtB9PgujXyaGvto4Pg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BD87780A0AD;
	Wed, 15 Jun 2022 14:20:30 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 429192166B29;
	Wed, 15 Jun 2022 14:20:29 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id B05041947041;
	Wed, 15 Jun 2022 14:20:28 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 02BFF19466DF
 for <dm-devel@listman.corp.redhat.com>; Wed, 15 Jun 2022 14:20:28 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id D158740C128A; Wed, 15 Jun 2022 14:20:27 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id CD1E540C1288
 for <dm-devel@redhat.com>; Wed, 15 Jun 2022 14:20:27 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B55F418E5341
 for <dm-devel@redhat.com>; Wed, 15 Jun 2022 14:20:27 +0000 (UTC)
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-645-Sl2kfoGROrqzFYxviw90oQ-1; Wed, 15 Jun 2022 10:20:23 -0400
X-MC-Unique: Sl2kfoGROrqzFYxviw90oQ-1
X-IronPort-AV: E=McAfee;i="6400,9594,10378"; a="258828979"
X-IronPort-AV: E=Sophos;i="5.91,302,1647327600"; d="scan'208";a="258828979"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
 by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
 15 Jun 2022 07:20:22 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,302,1647327600"; d="scan'208";a="727417450"
Received: from lkp-server01.sh.intel.com (HELO 60dabacc1df6) ([10.239.97.150])
 by fmsmga001.fm.intel.com with ESMTP; 15 Jun 2022 07:20:18 -0700
Received: from kbuild by 60dabacc1df6 with local (Exim 4.95)
 (envelope-from <lkp@intel.com>) id 1o1TsX-000MvF-LV;
 Wed, 15 Jun 2022 14:20:17 +0000
Date: Wed, 15 Jun 2022 22:19:48 +0800
From: kernel test robot <lkp@intel.com>
To: Pankaj Raghav <p.raghav@samsung.com>, hch@lst.de, snitzer@redhat.com,
 damien.lemoal@opensource.wdc.com, axboe@kernel.dk
Message-ID: <202206152257.pnoPyl7X-lkp@intel.com>
References: <20220615101920.329421-14-p.raghav@samsung.com>
MIME-Version: 1.0
In-Reply-To: <20220615101920.329421-14-p.raghav@samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Subject: Re: [dm-devel] [PATCH v7 13/13] dm: add non power of 2 zoned target
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
Cc: Pankaj Raghav <p.raghav@samsung.com>,
 Damien Le Moal <damien.lemoal@wdc.com>, kbuild-all@lists.01.org,
 bvanassche@acm.org, pankydev8@gmail.com, gost.dev@samsung.com,
 jiangbo.365@bytedance.com, linux-nvme@lists.infradead.org,
 linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, dm-devel@redhat.com,
 jonathan.derrick@linux.dev, Johannes.Thumshirn@wdc.com, dsterba@suse.com,
 jaegeuk@kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi Pankaj,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on axboe-block/for-next]
[also build test WARNING on device-mapper-dm/for-next linus/master v5.19-rc2 next-20220615]
[cannot apply to song-md/md-next]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch]

url:    https://github.com/intel-lab-lkp/linux/commits/Pankaj-Raghav/block-make-blkdev_nr_zones-and-blk_queue_zone_no-generic-for-npo2-zsze/20220615-191927
base:   https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux-block.git for-next
config: s390-allmodconfig (https://download.01.org/0day-ci/archive/20220615/202206152257.pnoPyl7X-lkp@intel.com/config)
compiler: s390-linux-gcc (GCC) 11.3.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/add4ab54d5b34d4a2f91f241007f23a56c164fb3
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Pankaj-Raghav/block-make-blkdev_nr_zones-and-blk_queue_zone_no-generic-for-npo2-zsze/20220615-191927
        git checkout add4ab54d5b34d4a2f91f241007f23a56c164fb3
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.3.0 make.cross W=1 O=build_dir ARCH=s390 SHELL=/bin/bash

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

   drivers/md/dm-zoned-npo2-target.c: In function 'dmz_npo2_ctr':
>> drivers/md/dm-zoned-npo2-target.c:62:13: warning: variable 'ret' set but not used [-Wunused-but-set-variable]
      62 |         int ret = 0;
         |             ^~~


vim +/ret +62 drivers/md/dm-zoned-npo2-target.c

    53	
    54	/*
    55	 * <dev-path>
    56	 * This target works on the complete zoned device. Partial mapping is not
    57	 * supported
    58	 */
    59	static int dmz_npo2_ctr(struct dm_target *ti, unsigned int argc, char **argv)
    60	{
    61		struct dmz_npo2_target *dmh = NULL;
  > 62		int ret = 0;
    63		sector_t zsze;
    64		sector_t disk_size;
    65	
    66		if (argc < 1)
    67			return -EINVAL;
    68	
    69		dmh = kmalloc(sizeof(*dmh), GFP_KERNEL);
    70		if (!dmh)
    71			return -ENOMEM;
    72	
    73		ret = dm_get_device(ti, argv[0], dm_table_get_mode(ti->table),
    74				    &dmh->dev);
    75	
    76		zsze = blk_queue_zone_sectors(bdev_get_queue(dmh->dev->bdev));
    77	
    78		disk_size = get_capacity(dmh->dev->bdev->bd_disk);
    79	
    80		if (ti->len != disk_size || ti->begin) {
    81			DMERR("%pg Partial mapping of the target not supported",
    82			      dmh->dev->bdev);
    83			return -EINVAL;
    84		}
    85	
    86		if (is_power_of_2(zsze)) {
    87			DMERR("%pg zone size is power of 2", dmh->dev->bdev);
    88			return -EINVAL;
    89		}
    90	
    91		dmh->zsze = zsze;
    92		dmh->zsze_po2 = 1 << get_count_order_long(zsze);
    93		dmh->zsze_diff = dmh->zsze_po2 - dmh->zsze;
    94	
    95		ti->private = dmh;
    96		ti->num_flush_bios = 1;
    97		ti->num_discard_bios = 1;
    98		ti->num_secure_erase_bios = 1;
    99		ti->num_write_zeroes_bios = 1;
   100	
   101		dmh->nr_zones = npo2_zone_no(dmh, ti->len);
   102		ti->len = dmh->zsze_po2 * dmh->nr_zones;
   103	
   104		return 0;
   105	}
   106	

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

