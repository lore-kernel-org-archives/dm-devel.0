Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9CFD2C433EF
	for <dm-devel@archiver.kernel.org>; Tue, 19 Apr 2022 04:33:44 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-548-sSHJHZBKMmKHuzBCgDA7rA-1; Tue, 19 Apr 2022 00:33:39 -0400
X-MC-Unique: sSHJHZBKMmKHuzBCgDA7rA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C626C1C05AC6;
	Tue, 19 Apr 2022 04:33:37 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 0BFFF4087D73;
	Tue, 19 Apr 2022 04:33:36 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id BE3EA1947BBE;
	Tue, 19 Apr 2022 04:33:35 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 1216C1947BBB
 for <dm-devel@listman.corp.redhat.com>; Tue, 19 Apr 2022 04:33:34 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id F2F11401473; Tue, 19 Apr 2022 04:33:33 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id EEF70401472
 for <dm-devel@redhat.com>; Tue, 19 Apr 2022 04:33:33 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BBD133C01D8F
 for <dm-devel@redhat.com>; Tue, 19 Apr 2022 04:33:33 +0000 (UTC)
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-563-igr86AaUNOGqfIX1ZtLw4Q-1; Tue, 19 Apr 2022 00:33:29 -0400
X-MC-Unique: igr86AaUNOGqfIX1ZtLw4Q-1
X-IronPort-AV: E=McAfee;i="6400,9594,10321"; a="262532182"
X-IronPort-AV: E=Sophos;i="5.90,271,1643702400"; d="scan'208";a="262532182"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
 by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
 18 Apr 2022 21:33:28 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,271,1643702400"; d="scan'208";a="575900487"
Received: from lkp-server01.sh.intel.com (HELO 3abc53900bec) ([10.239.97.150])
 by orsmga008.jf.intel.com with ESMTP; 18 Apr 2022 21:33:24 -0700
Received: from kbuild by 3abc53900bec with local (Exim 4.95)
 (envelope-from <lkp@intel.com>) id 1ngfYJ-0005LY-TX;
 Tue, 19 Apr 2022 04:33:23 +0000
Date: Tue, 19 Apr 2022 12:32:43 +0800
From: kernel test robot <lkp@intel.com>
To: Matthias Kaehlcke <mka@chromium.org>, Alasdair Kergon <agk@redhat.com>,
 Mike Snitzer <snitzer@kernel.org>,
 Kees Cook <keescook@chromium.org>, James Morris <jmorris@namei.org>,
 "Serge E . Hallyn" <serge@hallyn.com>
Message-ID: <202204191222.n0HWtNe0-lkp@intel.com>
References: <20220418141545.2.I01c67af41d2f6525c6d023101671d7339a9bc8b5@changeid>
MIME-Version: 1.0
In-Reply-To: <20220418141545.2.I01c67af41d2f6525c6d023101671d7339a9bc8b5@changeid>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
Subject: Re: [dm-devel] [PATCH 2/3] LoadPin: Enable loading from trusted
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
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
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
[also build test ERROR on song-md/md-next kees/for-next/pstore v5.18-rc3 next-20220414]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch]

url:    https://github.com/intel-lab-lkp/linux/commits/Matthias-Kaehlcke/LoadPin-Enable-loading-from-trusted-dm-verity-devices/20220419-051810
base:   https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git for-next
config: powerpc-buildonly-randconfig-r002-20220417 (https://download.01.org/0day-ci/archive/20220419/202204191222.n0HWtNe0-lkp@intel.com/config)
compiler: powerpc-linux-gcc (GCC) 11.2.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/5af892969b227a2602732e4be44a0c4a41967400
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Matthias-Kaehlcke/LoadPin-Enable-loading-from-trusted-dm-verity-devices/20220419-051810
        git checkout 5af892969b227a2602732e4be44a0c4a41967400
        # save the config file to linux build tree
        mkdir build_dir
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.2.0 make.cross O=build_dir ARCH=powerpc SHELL=/bin/bash security/loadpin/

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   security/loadpin/loadpin.c: In function 'loadpin_init':
>> security/loadpin/loadpin.c:404:44: error: 'loadpin_sysctl_path' undeclared (first use in this function)
     404 |                 if (!register_sysctl_paths(loadpin_sysctl_path,
         |                                            ^~~~~~~~~~~~~~~~~~~
   security/loadpin/loadpin.c:404:44: note: each undeclared identifier is reported only once for each function it appears in
>> security/loadpin/loadpin.c:405:44: error: 'loadpin_sysctl_table_verity' undeclared (first use in this function)
     405 |                                            loadpin_sysctl_table_verity))
         |                                            ^~~~~~~~~~~~~~~~~~~~~~~~~~~


vim +/loadpin_sysctl_path +404 security/loadpin/loadpin.c

   395	
   396	static int __init loadpin_init(void)
   397	{
   398		pr_info("ready to pin (currently %senforcing)\n",
   399			enforce ? "" : "not ");
   400		parse_exclude();
   401		security_add_hooks(loadpin_hooks, ARRAY_SIZE(loadpin_hooks), "loadpin");
   402	
   403		if (IS_ENABLED(CONFIG_SECURITY_LOADPIN_VERITY)) {
 > 404			if (!register_sysctl_paths(loadpin_sysctl_path,
 > 405						   loadpin_sysctl_table_verity))
   406				pr_notice("sysctl registration failed!\n");
   407		}
   408	
   409		return 0;
   410	}
   411	

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

