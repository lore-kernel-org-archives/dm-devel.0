Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7BE14C433F5
	for <dm-devel@archiver.kernel.org>; Sat, 29 Jan 2022 17:03:52 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-527-avkdVJqxPg6GWdC5Tx0ikQ-1; Sat, 29 Jan 2022 12:03:45 -0500
X-MC-Unique: avkdVJqxPg6GWdC5Tx0ikQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 34F5C14755;
	Sat, 29 Jan 2022 17:03:40 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 899EA2BCDA;
	Sat, 29 Jan 2022 17:03:37 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 3FB1B4BB7C;
	Sat, 29 Jan 2022 17:03:32 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
	[10.11.54.2])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 20TH3TD4025566 for <dm-devel@listman.util.phx.redhat.com>;
	Sat, 29 Jan 2022 12:03:29 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 9C0E640885CB; Sat, 29 Jan 2022 17:03:29 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 9866640885BC
	for <dm-devel@redhat.com>; Sat, 29 Jan 2022 17:03:29 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6DC503C00109
	for <dm-devel@redhat.com>; Sat, 29 Jan 2022 17:03:29 +0000 (UTC)
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-184-jubDuxUqM0qbUtTLaBFU6Q-1; Sat, 29 Jan 2022 12:03:27 -0500
X-MC-Unique: jubDuxUqM0qbUtTLaBFU6Q-1
X-IronPort-AV: E=McAfee;i="6200,9189,10242"; a="247054804"
X-IronPort-AV: E=Sophos;i="5.88,327,1635231600"; d="scan'208";a="247054804"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
	by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
	29 Jan 2022 09:02:23 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,327,1635231600"; d="scan'208";a="522063039"
Received: from lkp-server01.sh.intel.com (HELO 276f1b88eecb) ([10.239.97.150])
	by orsmga007.jf.intel.com with ESMTP; 29 Jan 2022 09:02:21 -0800
Received: from kbuild by 276f1b88eecb with local (Exim 4.92)
	(envelope-from <lkp@intel.com>)
	id 1nDr7E-000PQO-Vz; Sat, 29 Jan 2022 17:02:20 +0000
Date: Sun, 30 Jan 2022 01:01:37 +0800
From: kernel test robot <lkp@intel.com>
To: Jordy Zomer <jordy@jordyzomer.github.io>, linux-kernel@vger.kernel.org
Message-ID: <202201300033.eThgyeLo-lkp@intel.com>
References: <20220129143722.3460829-1-jordy@pwning.systems>
MIME-Version: 1.0
In-Reply-To: <20220129143722.3460829-1-jordy@pwning.systems>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-loop: dm-devel@redhat.com
Cc: kbuild-all@lists.01.org, Jordy Zomer <jordy@jordyzomer.github.io>,
	Mike Snitzer <snitzer@redhat.com>, llvm@lists.linux.dev,
	dm-devel@redhat.com, Alasdair Kergon <agk@redhat.com>
Subject: Re: [dm-devel] [PATCH] dm ioct: prevent potential specter v1 gadget
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi Jordy,

Thank you for the patch! Yet something to improve:

[auto build test ERROR on device-mapper-dm/for-next]
[also build test ERROR on linux/master linus/master v5.17-rc1 next-20220128]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch]

url:    https://github.com/0day-ci/linux/commits/Jordy-Zomer/dm-ioct-prevent-potential-specter-v1-gadget/20220129-223840
base:   https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git for-next
config: hexagon-buildonly-randconfig-r001-20220129 (https://download.01.org/0day-ci/archive/20220130/202201300033.eThgyeLo-lkp@intel.com/config)
compiler: clang version 14.0.0 (https://github.com/llvm/llvm-project 33b45ee44b1f32ffdbc995e6fec806271b4b3ba4)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/0day-ci/linux/commit/494fed5461aa05e0efaf098b57a2a47dc19ba226
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review Jordy-Zomer/dm-ioct-prevent-potential-specter-v1-gadget/20220129-223840
        git checkout 494fed5461aa05e0efaf098b57a2a47dc19ba226
        # save the config file to linux build tree
        mkdir build_dir
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=hexagon SHELL=/bin/bash drivers/md/

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

>> drivers/md/dm-ioctl.c:1791:8: error: implicit declaration of function 'array_index_nospec' [-Werror,-Wimplicit-function-declaration]
           cmd = array_index_nospec(cmd, ARRAY_SIZE(_ioctls));
                 ^
   1 error generated.


vim +/array_index_nospec +1791 drivers/md/dm-ioctl.c

  1752	
  1753	/*-----------------------------------------------------------------
  1754	 * Implementation of open/close/ioctl on the special char
  1755	 * device.
  1756	 *---------------------------------------------------------------*/
  1757	static ioctl_fn lookup_ioctl(unsigned int cmd, int *ioctl_flags)
  1758	{
  1759		static const struct {
  1760			int cmd;
  1761			int flags;
  1762			ioctl_fn fn;
  1763		} _ioctls[] = {
  1764			{DM_VERSION_CMD, 0, NULL}, /* version is dealt with elsewhere */
  1765			{DM_REMOVE_ALL_CMD, IOCTL_FLAGS_NO_PARAMS | IOCTL_FLAGS_ISSUE_GLOBAL_EVENT, remove_all},
  1766			{DM_LIST_DEVICES_CMD, 0, list_devices},
  1767	
  1768			{DM_DEV_CREATE_CMD, IOCTL_FLAGS_NO_PARAMS | IOCTL_FLAGS_ISSUE_GLOBAL_EVENT, dev_create},
  1769			{DM_DEV_REMOVE_CMD, IOCTL_FLAGS_NO_PARAMS | IOCTL_FLAGS_ISSUE_GLOBAL_EVENT, dev_remove},
  1770			{DM_DEV_RENAME_CMD, IOCTL_FLAGS_ISSUE_GLOBAL_EVENT, dev_rename},
  1771			{DM_DEV_SUSPEND_CMD, IOCTL_FLAGS_NO_PARAMS, dev_suspend},
  1772			{DM_DEV_STATUS_CMD, IOCTL_FLAGS_NO_PARAMS, dev_status},
  1773			{DM_DEV_WAIT_CMD, 0, dev_wait},
  1774	
  1775			{DM_TABLE_LOAD_CMD, 0, table_load},
  1776			{DM_TABLE_CLEAR_CMD, IOCTL_FLAGS_NO_PARAMS, table_clear},
  1777			{DM_TABLE_DEPS_CMD, 0, table_deps},
  1778			{DM_TABLE_STATUS_CMD, 0, table_status},
  1779	
  1780			{DM_LIST_VERSIONS_CMD, 0, list_versions},
  1781	
  1782			{DM_TARGET_MSG_CMD, 0, target_message},
  1783			{DM_DEV_SET_GEOMETRY_CMD, 0, dev_set_geometry},
  1784			{DM_DEV_ARM_POLL, IOCTL_FLAGS_NO_PARAMS, dev_arm_poll},
  1785			{DM_GET_TARGET_VERSION, 0, get_target_version},
  1786		};
  1787	
  1788		if (unlikely(cmd >= ARRAY_SIZE(_ioctls)))
  1789			return NULL;
  1790	
> 1791		cmd = array_index_nospec(cmd, ARRAY_SIZE(_ioctls));
  1792		*ioctl_flags = _ioctls[cmd].flags;
  1793		return _ioctls[cmd].fn;
  1794	}
  1795	

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

