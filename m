Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 30289C433F5
	for <dm-devel@archiver.kernel.org>; Wed, 18 May 2022 12:42:03 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-350-Rz4BVWj2Op2LNAXEHmTLKg-1; Wed, 18 May 2022 08:42:00 -0400
X-MC-Unique: Rz4BVWj2Op2LNAXEHmTLKg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2BA2A296A609;
	Wed, 18 May 2022 12:41:59 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id A7C2C1410DD9;
	Wed, 18 May 2022 12:41:57 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 758451947B8F;
	Wed, 18 May 2022 12:41:57 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 6B08C1947B84
 for <dm-devel@listman.corp.redhat.com>; Wed, 18 May 2022 12:41:40 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 58528400E114; Wed, 18 May 2022 12:41:40 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 536D640C1244
 for <dm-devel@redhat.com>; Wed, 18 May 2022 12:41:40 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 195F5803D4E
 for <dm-devel@redhat.com>; Wed, 18 May 2022 12:41:40 +0000 (UTC)
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-28-ABSiPtisORCJE_IQ0Lt6_Q-1; Wed, 18 May 2022 08:41:38 -0400
X-MC-Unique: ABSiPtisORCJE_IQ0Lt6_Q-1
X-IronPort-AV: E=McAfee;i="6400,9594,10350"; a="270476137"
X-IronPort-AV: E=Sophos;i="5.91,234,1647327600"; d="scan'208";a="270476137"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
 by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
 18 May 2022 05:41:37 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,234,1647327600"; d="scan'208";a="639243416"
Received: from lkp-server02.sh.intel.com (HELO 242b25809ac7) ([10.239.97.151])
 by fmsmga004.fm.intel.com with ESMTP; 18 May 2022 05:41:33 -0700
Received: from kbuild by 242b25809ac7 with local (Exim 4.95)
 (envelope-from <lkp@intel.com>) id 1nrIzd-0002BR-4H;
 Wed, 18 May 2022 12:41:33 +0000
Date: Wed, 18 May 2022 20:40:33 +0800
From: kernel test robot <lkp@intel.com>
To: Matthias Kaehlcke <mka@chromium.org>, Alasdair Kergon <agk@redhat.com>,
 Mike Snitzer <snitzer@kernel.org>,
 Kees Cook <keescook@chromium.org>, James Morris <jmorris@namei.org>,
 "Serge E . Hallyn" <serge@hallyn.com>
Message-ID: <202205182059.6QY3zspw-lkp@intel.com>
References: <20220517163437.v4.2.I01c67af41d2f6525c6d023101671d7339a9bc8b5@changeid>
MIME-Version: 1.0
In-Reply-To: <20220517163437.v4.2.I01c67af41d2f6525c6d023101671d7339a9bc8b5@changeid>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Subject: Re: [dm-devel] [PATCH v4 2/3] LoadPin: Enable loading from trusted
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
Cc: Douglas Anderson <dianders@chromium.org>, kbuild-all@lists.01.org,
 dm-devel@redhat.com, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
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
[also build test ERROR on song-md/md-next kees/for-next/pstore linus/master v5.18-rc7 next-20220517]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch]

url:    https://github.com/intel-lab-lkp/linux/commits/Matthias-Kaehlcke/LoadPin-Enable-loading-from-trusted-dm-verity-devices/20220518-073635
base:   https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git for-next
config: m68k-allmodconfig (https://download.01.org/0day-ci/archive/20220518/202205182059.6QY3zspw-lkp@intel.com/config)
compiler: m68k-linux-gcc (GCC) 11.3.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/755e5d82e4d054b2b58a54c94681080cc8cb4582
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Matthias-Kaehlcke/LoadPin-Enable-loading-from-trusted-dm-verity-devices/20220518-073635
        git checkout 755e5d82e4d054b2b58a54c94681080cc8cb4582
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.3.0 make.cross W=1 O=build_dir ARCH=m68k SHELL=/bin/bash security/

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   In file included from security/loadpin/loadpin.c:21:
>> include/linux/dm-verity-loadpin.h:22:1: error: expected identifier or '(' before '{' token
      22 | {
         | ^
   include/linux/dm-verity-loadpin.h:21:20: warning: 'dm_verity_loadpin_is_sb_trusted' used but never defined
      21 | static inline bool dm_verity_loadpin_is_sb_trusted(struct super_block *sb);
         |                    ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


vim +22 include/linux/dm-verity-loadpin.h

afd03270f57b8c Matthias Kaehlcke 2022-05-17  17  
afd03270f57b8c Matthias Kaehlcke 2022-05-17  18  #if IS_ENABLED(CONFIG_SECURITY_LOADPIN) && IS_BUILTIN(CONFIG_DM_VERITY)
afd03270f57b8c Matthias Kaehlcke 2022-05-17  19  bool dm_verity_loadpin_is_sb_trusted(struct super_block *sb);
afd03270f57b8c Matthias Kaehlcke 2022-05-17  20  #else
afd03270f57b8c Matthias Kaehlcke 2022-05-17  21  static inline bool dm_verity_loadpin_is_sb_trusted(struct super_block *sb);
afd03270f57b8c Matthias Kaehlcke 2022-05-17 @22  {
afd03270f57b8c Matthias Kaehlcke 2022-05-17  23  	return false;
afd03270f57b8c Matthias Kaehlcke 2022-05-17  24  }
afd03270f57b8c Matthias Kaehlcke 2022-05-17  25  #endif
afd03270f57b8c Matthias Kaehlcke 2022-05-17  26  

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

