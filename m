Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5769EC433F5
	for <dm-devel@archiver.kernel.org>; Wed, 25 May 2022 07:23:04 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-116-NRI11U3VPJyg2KkmpRxnbw-1; Wed, 25 May 2022 03:22:59 -0400
X-MC-Unique: NRI11U3VPJyg2KkmpRxnbw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 487A083397C;
	Wed, 25 May 2022 07:22:58 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 7EAB5404E4AC;
	Wed, 25 May 2022 07:22:56 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 18BE0194EB8E;
	Wed, 25 May 2022 07:22:56 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 86659194EBB4
 for <dm-devel@listman.corp.redhat.com>; Tue, 24 May 2022 15:28:30 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 64BD3112131B; Tue, 24 May 2022 15:28:30 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 6106B1121315
 for <dm-devel@redhat.com>; Tue, 24 May 2022 15:28:30 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 461A61C0514F
 for <dm-devel@redhat.com>; Tue, 24 May 2022 15:28:30 +0000 (UTC)
Received: from dfw.source.kernel.org (dfw.source.kernel.org
 [139.178.84.217]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-358-NHLepWzDM5idPAfnhZ8AGw-1; Tue, 24 May 2022 11:28:28 -0400
X-MC-Unique: NHLepWzDM5idPAfnhZ8AGw-1
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 8C32661718;
 Tue, 24 May 2022 15:22:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA47EC34113;
 Tue, 24 May 2022 15:22:39 +0000 (UTC)
Date: Tue, 24 May 2022 08:22:38 -0700
From: Nathan Chancellor <nathan@kernel.org>
To: Pankaj Raghav <p.raghav@samsung.com>
Message-ID: <Yoz4PsQjWzVxz+YO@dev-arch.thelio-3990X>
References: <20220523161601.58078-6-p.raghav@samsung.com>
 <CGME20220524024108eucas1p26a6384cd77f143bb0fa628f01866e0a0@eucas1p2.samsung.com>
 <202205241034.izkLMTcH-lkp@intel.com>
 <7656fdc2-0511-722e-de6a-c2a2460cb048@samsung.com>
MIME-Version: 1.0
In-Reply-To: <7656fdc2-0511-722e-de6a-c2a2460cb048@samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-Mailman-Approved-At: Wed, 25 May 2022 07:22:55 +0000
Subject: Re: [dm-devel] [PATCH v5 5/7] null_blk: allow non power of 2 zoned
 devices
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
Cc: axboe@kernel.dk, kbuild-all@lists.01.org, kernel test robot <lkp@intel.com>,
 snitzer@redhat.com, Johannes.Thumshirn@wdc.com,
 damien.lemoal@opensource.wdc.com, llvm@lists.linux.dev,
 jiangbo.365@bytedance.com, linux-nvme@lists.infradead.org,
 linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, dm-devel@redhat.com,
 gost.dev@samsung.com, dsterba@suse.com, jaegeuk@kernel.org, hch@lst.de,
 Luis Chamberlain <mcgrof@kernel.org>
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

On Tue, May 24, 2022 at 09:30:41AM +0200, Pankaj Raghav wrote:
> On 5/24/22 04:40, kernel test robot wrote:
> > Hi Pankaj,
> > 
> > Thank you for the patch! Yet something to improve:
> > 
> > [auto build test ERROR on axboe-block/for-next]
> > [also build test ERROR on device-mapper-dm/for-next linus/master hch-configfs/for-next v5.18 next-20220523]
> > [If your patch is applied to the wrong git tree, kindly drop us a note.
> > And when submitting patch, we suggest to use '--base' as documented in
> > https://git-scm.com/docs/git-format-patch]
> > 
> > url:    https://protect2.fireeye.com/v1/url?k=8acc50e6-d557681b-8acddba9-000babff317b-0ca211d60a57a8c6&q=1&e=5ef82219-ef70-445f-a7d0-0ae0a30be69f&u=https%3A%2F%2Fgithub.com%2Fintel-lab-lkp%2Flinux%2Fcommits%2FPankaj-Raghav%2Fblock-make-blkdev_nr_zones-and-blk_queue_zone_no-generic-for-npo2-zsze%2F20220524-011616
> > base:   https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux-block.git for-next
> > config: hexagon-randconfig-r045-20220523 (https://protect2.fireeye.com/v1/url?k=0dc32741-52581fbc-0dc2ac0e-000babff317b-fb6f258f0c80ebb9&q=1&e=5ef82219-ef70-445f-a7d0-0ae0a30be69f&u=https%3A%2F%2Fdownload.01.org%2F0day-ci%2Farchive%2F20220524%2F202205241034.izkLMTcH-lkp%40intel.com%2Fconfig)
> > compiler: clang version 15.0.0 (https://protect2.fireeye.com/v1/url?k=afbb4f4f-f02077b2-afbac400-000babff317b-a4413fa4cefe1877&q=1&e=5ef82219-ef70-445f-a7d0-0ae0a30be69f&u=https%3A%2F%2Fgithub.com%2Fllvm%2Fllvm-project 10c9ecce9f6096e18222a331c5e7d085bd813f75)
> > reproduce (this is a W=1 build):
> >         wget https://protect2.fireeye.com/v1/url?k=718573dc-2e1e4b21-7184f893-000babff317b-b6c06a1c569b0d77&q=1&e=5ef82219-ef70-445f-a7d0-0ae0a30be69f&u=https%3A%2F%2Fraw.githubusercontent.com%2Fintel%2Flkp-tests%2Fmaster%2Fsbin%2Fmake.cross -O ~/bin/make.cross
> >         chmod +x ~/bin/make.cross
> >         # https://protect2.fireeye.com/v1/url?k=247d070f-7be63ff2-247c8c40-000babff317b-6fd7f2f6a5a5bc60&q=1&e=5ef82219-ef70-445f-a7d0-0ae0a30be69f&u=https%3A%2F%2Fgithub.com%2Fintel-lab-lkp%2Flinux%2Fcommit%2F3d3c81da0adbd40eb0d2125327b7e227582b2a37
> >         git remote add linux-review https://protect2.fireeye.com/v1/url?k=081be8db-5780d026-081a6394-000babff317b-d12fdca0fccd0493&q=1&e=5ef82219-ef70-445f-a7d0-0ae0a30be69f&u=https%3A%2F%2Fgithub.com%2Fintel-lab-lkp%2Flinux
> >         git fetch --no-tags linux-review Pankaj-Raghav/block-make-blkdev_nr_zones-and-blk_queue_zone_no-generic-for-npo2-zsze/20220524-011616
> >         git checkout 3d3c81da0adbd40eb0d2125327b7e227582b2a37
> >         # save the config file
> >         mkdir build_dir && cp config build_dir/.config
> >         COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=hexagon SHELL=/bin/bash
> > 
> > If you fix the issue, kindly add following tag where applicable
> > Reported-by: kernel test robot <lkp@intel.com>
> > 
> > All errors (new ones prefixed by >>, old ones prefixed by <<):
> > 
> >>> ERROR: modpost: "__hexagon_umoddi3" [drivers/block/null_blk/null_blk.ko] undefined!
> 
> I am able to apply my patches cleanly against next-20220523, build it
> without any errors with GCC and boot into it in my x86_64 machine. Not
> sure why this error is popping up.

Do a 32-bit build and you'll see it. With GCC 12.1.0, ARCH=i386
defconfig + CONFIG_BLK_DEV_NULL_BLK=y + CONFIG_BLK_DEV_ZONED=y
reproduces it for me:

$ make -skj"$(nproc)" ARCH=i386 defconfig menuconfig all
ld: drivers/block/null_blk/zoned.o: in function `null_init_zoned_dev':
zoned.c:(.text+0x112e): undefined reference to `__umoddi3'
...

roundup() does a plain division with a 64-bit dividend, which will cause
issues with 32-bit architectures. I suspect that you should really be
using DIV_ROUND_UP_SECTOR_T() for the nr_zones calculation or maybe one
of the other rounding macros in include/linux/math.h but I am not sure.

Cheers,
Nathan

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

