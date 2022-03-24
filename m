Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0416EC4332F
	for <dm-devel@archiver.kernel.org>; Thu, 24 Mar 2022 15:34:57 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-338-i86Vw3yFPMmL99cJQ1589g-1; Thu, 24 Mar 2022 11:34:53 -0400
X-MC-Unique: i86Vw3yFPMmL99cJQ1589g-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EDE2C8E2166;
	Thu, 24 Mar 2022 15:34:47 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id D6BDA40E80E2;
	Thu, 24 Mar 2022 15:34:47 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 481FE193F6E4;
	Thu, 24 Mar 2022 15:34:46 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id F2AF81940347
 for <dm-devel@listman.corp.redhat.com>; Thu, 24 Mar 2022 00:32:22 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id B44E5141DEC7; Thu, 24 Mar 2022 00:32:22 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id B052E1410DD5
 for <dm-devel@redhat.com>; Thu, 24 Mar 2022 00:32:22 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5B7E4805A30
 for <dm-devel@redhat.com>; Thu, 24 Mar 2022 00:32:22 +0000 (UTC)
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-567-wp1vG-2PMUS1dliYJslpNA-1; Wed, 23 Mar 2022 20:32:20 -0400
X-MC-Unique: wp1vG-2PMUS1dliYJslpNA-1
X-IronPort-AV: E=McAfee;i="6200,9189,10295"; a="240416200"
X-IronPort-AV: E=Sophos;i="5.90,205,1643702400"; d="scan'208";a="240416200"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
 by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
 23 Mar 2022 17:31:16 -0700
X-IronPort-AV: E=Sophos;i="5.90,205,1643702400"; d="scan'208";a="561150781"
Received: from rongch2-mobl.ccr.corp.intel.com (HELO [10.249.174.249])
 ([10.249.174.249])
 by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
 23 Mar 2022 17:31:14 -0700
To: Mike Snitzer <snitzer@redhat.com>, kernel test robot <lkp@intel.com>
References: <202203240638.crXQjFY5-lkp@intel.com> <YjuoF88MzBALI+l8@redhat.com>
From: "Chen, Rong A" <rong.a.chen@intel.com>
Message-ID: <2c10ed96-4558-3438-e889-f5b9ff4cea84@intel.com>
Date: Thu, 24 Mar 2022 08:31:12 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <YjuoF88MzBALI+l8@redhat.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Mimecast-Bulk-Signature: yes
X-Mimecast-Spam-Signature: bulk
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
X-Mailman-Approved-At: Thu, 24 Mar 2022 15:34:43 +0000
Subject: Re: [dm-devel] [kbuild-all] Re: [device-mapper-dm:dm-5.19 132/132]
 drivers/md/dm.c:1542:18: error: 'result' undeclared
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
Cc: kbuild-all@lists.01.org, dm-devel@redhat.com,
 Mike Snitzer <snitzer@kernel.org>, linux-kernel@vger.kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"



On 3/24/2022 7:07 AM, Mike Snitzer wrote:
> On Wed, Mar 23 2022 at  6:57P -0400,
> kernel test robot <lkp@intel.com> wrote:
> 
>> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git dm-5.19
>> head:   7f8ac95a6464b895e3d2b6175f7ee64a4c10fcfe
>> commit: 7f8ac95a6464b895e3d2b6175f7ee64a4c10fcfe [132/132] dm: push error handling down to __split_and_process_bio
>> config: s390-buildonly-randconfig-r005-20220323 (https://download.01.org/0day-ci/archive/20220324/202203240638.crXQjFY5-lkp@intel.com/config)
>> compiler: s390-linux-gcc (GCC) 11.2.0
>> reproduce (this is a W=1 build):
>>          wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
>>          chmod +x ~/bin/make.cross
>>          # https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git/commit/?id=7f8ac95a6464b895e3d2b6175f7ee64a4c10fcfe
>>          git remote add device-mapper-dm https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git
>>          git fetch --no-tags device-mapper-dm dm-5.19
>>          git checkout 7f8ac95a6464b895e3d2b6175f7ee64a4c10fcfe
>>          # save the config file to linux build tree
>>          mkdir build_dir
>>          COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.2.0 make.cross O=build_dir ARCH=s390 SHELL=/bin/bash drivers/md/
>>
>> If you fix the issue, kindly add following tag as appropriate
>> Reported-by: kernel test robot <lkp@intel.com>
>>
>> All errors (new ones prefixed by >>):
>>
>>     drivers/md/dm.c: In function '__process_abnormal_io':
>>>> drivers/md/dm.c:1542:18: error: 'result' undeclared (first use in this function)
>>      1542 |                 *result = BLK_STS_NOTSUPP;
>>           |                  ^~~~~~
>>     drivers/md/dm.c:1542:18: note: each undeclared identifier is reported only once for each function it appears in
>>
> 
> Yeah, I pushed this too soon, fixed now.
> 
> But why are you even testing this branch? I didn't include dm-5.19 in
> linux-next yet.

Hi Mike,

The bot picks up all branches to test, do you want it to only test few 
branches?


> 
> Given that it seems strange for the bot to just pick up some branch,
> and then spam LKML, dm-devel, etc like it found a meaningful problem.

we also support sending reports privately, do you want this way?

Best Regards,
Rong Chen

> 
> Mike
> _______________________________________________
> kbuild-all mailing list -- kbuild-all@lists.01.org
> To unsubscribe send an email to kbuild-all-leave@lists.01.org
> 

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

