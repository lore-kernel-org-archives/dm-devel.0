From: kbuild test robot <fengguang.wu@intel.com>
Subject: [dm:for-next 30/30] drivers/md/dm-thin.c:338:5: sparse: symbol
 '__blkdev_issue_discard_async' was not declared. Should it be static?
Date: Sat, 23 May 2015 05:37:23 +0800
Message-ID: <201505230502.WN0Nq7Zv%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Joe Thornber <ejt@redhat.com>
Cc: kbuild-all@01.org, Mike Snitzer <snitzer@redhat.com>, Alasdair Kergon <agk@redhat.com>, dm-devel@redhat.com, Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

tree:   git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git for-next
head:   9f1e427e6d6c80f0c3d7b38ddfbd98c9f8f2af41
commit: 9f1e427e6d6c80f0c3d7b38ddfbd98c9f8f2af41 [30/30] dm thin: range discard support
reproduce:
  # apt-get install sparse
  git checkout 9f1e427e6d6c80f0c3d7b38ddfbd98c9f8f2af41
  make ARCH=x86_64 allmodconfig
  make C=1 CF=-D__CHECK_ENDIAN__


sparse warnings: (new ones prefixed by >>)

>> drivers/md/dm-thin.c:338:5: sparse: symbol '__blkdev_issue_discard_async' was not declared. Should it be static?

Please review and possibly fold the followup patch.

---
0-DAY kernel test infrastructure                Open Source Technology Center
http://lists.01.org/mailman/listinfo/kbuild                 Intel Corporation
