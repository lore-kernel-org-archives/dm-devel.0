Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EAC17C4332F
	for <dm-devel@archiver.kernel.org>; Thu, 28 Apr 2022 02:00:54 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-646-jfQhg44-P-Czymnf3dhv3Q-1; Wed, 27 Apr 2022 22:00:50 -0400
X-MC-Unique: jfQhg44-P-Czymnf3dhv3Q-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4DF68833962;
	Thu, 28 Apr 2022 02:00:48 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 6DF4614152FB;
	Thu, 28 Apr 2022 02:00:46 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 220991947046;
	Thu, 28 Apr 2022 02:00:46 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 7FEE81947041
 for <dm-devel@listman.corp.redhat.com>; Thu, 28 Apr 2022 02:00:44 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 6B079111CB82; Thu, 28 Apr 2022 02:00:44 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 668D3111CB81
 for <dm-devel@redhat.com>; Thu, 28 Apr 2022 02:00:44 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4DF7829DD99F
 for <dm-devel@redhat.com>; Thu, 28 Apr 2022 02:00:44 +0000 (UTC)
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-671-xb4mbgU7OGug3I1F9DZIdQ-1; Wed, 27 Apr 2022 22:00:42 -0400
X-MC-Unique: xb4mbgU7OGug3I1F9DZIdQ-1
X-IronPort-AV: E=McAfee;i="6400,9594,10330"; a="263717027"
X-IronPort-AV: E=Sophos;i="5.90,294,1643702400"; d="scan'208";a="263717027"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
 by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
 27 Apr 2022 19:00:27 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,294,1643702400"; d="scan'208";a="617872486"
Received: from lkp-server01.sh.intel.com (HELO 5056e131ad90) ([10.239.97.150])
 by fmsmga008.fm.intel.com with ESMTP; 27 Apr 2022 19:00:24 -0700
Received: from kbuild by 5056e131ad90 with local (Exim 4.95)
 (envelope-from <lkp@intel.com>) id 1njtSB-0004xf-IA;
 Thu, 28 Apr 2022 02:00:23 +0000
Date: Thu, 28 Apr 2022 09:59:41 +0800
From: kernel test robot <lkp@intel.com>
To: Matthias Kaehlcke <mka@chromium.org>, Alasdair Kergon <agk@redhat.com>,
 Mike Snitzer <snitzer@kernel.org>,
 Kees Cook <keescook@chromium.org>, James Morris <jmorris@namei.org>,
 "Serge E . Hallyn" <serge@hallyn.com>
Message-ID: <202204280323.OzDYYX55-lkp@intel.com>
References: <20220426143059.v2.2.I01c67af41d2f6525c6d023101671d7339a9bc8b5@changeid>
MIME-Version: 1.0
In-Reply-To: <20220426143059.v2.2.I01c67af41d2f6525c6d023101671d7339a9bc8b5@changeid>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
Subject: Re: [dm-devel] [PATCH v2 2/3] LoadPin: Enable loading from trusted
 dm-verity devices
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
Cc: kbuild-all@lists.01.org, dm-devel@redhat.com, linux-kernel@vger.kernel.org,
 Douglas Anderson <dianders@chromium.org>, linux-raid@vger.kernel.org,
 Song Liu <song@kernel.org>, linux-security-module@vger.kernel.org,
 Matthias Kaehlcke <mka@chromium.org>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi Matthias,

Thank you for the patch! Yet something to improve:

[auto build test ERROR on device-mapper-dm/for-next]
[also build test ERROR on song-md/md-next kees/for-next/pstore v5.18-rc4 next-20220427]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch]

url:    https://github.com/intel-lab-lkp/linux/commits/Matthias-Kaehlcke/LoadPin-Enable-loading-from-trusted-dm-verity-devices/20220427-053314
base:   https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git for-next
config: alpha-randconfig-r024-20220425 (https://download.01.org/0day-ci/archive/20220428/202204280323.OzDYYX55-lkp@intel.com/config)
compiler: alpha-linux-gcc (GCC) 11.3.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/f3a54909bcd78b9f7f006d7e78acd03987031fae
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Matthias-Kaehlcke/LoadPin-Enable-loading-from-trusted-dm-verity-devices/20220427-053314
        git checkout f3a54909bcd78b9f7f006d7e78acd03987031fae
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.3.0 make.cross W=1 O=build_dir ARCH=alpha SHELL=/bin/bash

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   security/loadpin/loadpin.c: In function 'loadpin_init':
   security/loadpin/loadpin.c:436:44: error: 'loadpin_sysctl_path' undeclared (first use in this function)
     436 |                 if (!register_sysctl_paths(loadpin_sysctl_path,
         |                                            ^~~~~~~~~~~~~~~~~~~
   security/loadpin/loadpin.c:436:44: note: each undeclared identifier is reported only once for each function it appears in
>> security/loadpin/loadpin.c:437:44: error: 'loadpin_sysctl_table_verity_digests' undeclared (first use in this function)
     437 |                                            loadpin_sysctl_table_verity_digests))
         |                                            ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


vim +/loadpin_sysctl_table_verity_digests +437 security/loadpin/loadpin.c

   427	
   428	static int __init loadpin_init(void)
   429	{
   430		pr_info("ready to pin (currently %senforcing)\n",
   431			enforce ? "" : "not ");
   432		parse_exclude();
   433		security_add_hooks(loadpin_hooks, ARRAY_SIZE(loadpin_hooks), "loadpin");
   434	
   435		if (IS_ENABLED(CONFIG_SECURITY_LOADPIN_VERITY)) {
   436			if (!register_sysctl_paths(loadpin_sysctl_path,
 > 437						   loadpin_sysctl_table_verity_digests))
   438				pr_notice("sysctl registration failed!\n");
   439		}
   440	
   441		return 0;
   442	}
   443	

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

