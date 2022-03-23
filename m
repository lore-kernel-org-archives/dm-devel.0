Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A0527C433EF
	for <dm-devel@archiver.kernel.org>; Wed, 23 Mar 2022 23:14:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1648077249;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=FsWPCBasvc0IDPm+mfygbtidJTJ/+bQu7ZQLh95HkCo=;
	b=DqP435q8NJsw93JSw8po1fpaxgpD7Mfqi5dbs2qQCkTPCmYbQdlMI0J0ZJ5Fub8skTe0uo
	Ei+kWW/kVd6ki6JHSY0IxwkPt/UNU8cCUKiUCJNFmoKpdfS+Az6KDHQvlXEh0g+sfwI0xQ
	TDbP73K4wpHR65ScRB3jcBGLJmDlAyA=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-38-rzPUpErGO0CLYMGTamPeCA-1; Wed, 23 Mar 2022 19:14:05 -0400
X-MC-Unique: rzPUpErGO0CLYMGTamPeCA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BE9E4101AA46;
	Wed, 23 Mar 2022 23:14:03 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 68BF32166B2D;
	Wed, 23 Mar 2022 23:14:03 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 011611940347;
	Wed, 23 Mar 2022 23:14:03 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 049CB1940347
 for <dm-devel@listman.corp.redhat.com>; Wed, 23 Mar 2022 23:07:06 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id E5618401E50; Wed, 23 Mar 2022 23:07:06 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id E1F67401E25
 for <dm-devel@redhat.com>; Wed, 23 Mar 2022 23:07:06 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C92731C06901
 for <dm-devel@redhat.com>; Wed, 23 Mar 2022 23:07:06 +0000 (UTC)
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-558-Hsj30OfnMA26fzAuyj45KA-1; Wed, 23 Mar 2022 19:07:05 -0400
X-MC-Unique: Hsj30OfnMA26fzAuyj45KA-1
Received: by mail-qt1-f198.google.com with SMTP id
 u8-20020ac858c8000000b002e1b3ceb167so2340037qta.10
 for <dm-devel@redhat.com>; Wed, 23 Mar 2022 16:07:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=AeE76UaTYeKfGTHUnXSHySwumYli4lVrVB6Ua4GUIIk=;
 b=rMirVraacZH1sHO33Koy87yjIEwR+VwWi/CKfaUai3WizAOModmWB1ShceguH3YIzU
 ylRFT68uapWsqRe7FnZDKb7RNMI51MW5zZnLFyBRpBbCRp1CEvO+Y75etAZELg4t3Blw
 vJxzFpub32DAXoMLXhjfgus8hBSyTMCIsrU5Ly/vVDdO+lX8uq8wy+Ex+DmWIpY2Ii8N
 wB0h9zPmTn2YxZ9KnVjEkYNcumYJZcRg/w7t4amGmCmOKbQXahBKSBlIw2ZoYgUig7JY
 eEjBQG0No36kG5x845d3f1fZGnwDH9iH1L2RBt5+eFm6N3njs8ebXUI1VAImzlVBZ3Bb
 cEuw==
X-Gm-Message-State: AOAM532Ve+zpfbdoZ1Q+LdPJKzC/zZYaRNySoHG0YbVirOAkkWafe0cW
 wNjjBhIhBAagbhhlA/L2GVgHX4pdsRAhvdVpwTZbklKLfhdkgL/ToQvHOrgSfhimk2eBoqFbM2S
 /7tTMLJmXE65mPA==
X-Received: by 2002:a05:620a:4554:b0:67d:6750:6a3 with SMTP id
 u20-20020a05620a455400b0067d675006a3mr1618759qkp.439.1648076824998; 
 Wed, 23 Mar 2022 16:07:04 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy4cizB/SoNIm4ab298xlavH6M9Ey73WflczZsQIKYfKAtTDPuv/lVMEGZ8IxLT/JR4E7epBA==
X-Received: by 2002:a05:620a:4554:b0:67d:6750:6a3 with SMTP id
 u20-20020a05620a455400b0067d675006a3mr1618743qkp.439.1648076824778; 
 Wed, 23 Mar 2022 16:07:04 -0700 (PDT)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net.
 [68.160.176.52]) by smtp.gmail.com with ESMTPSA id
 g21-20020ac85815000000b002e06e2623a7sm1025395qtg.0.2022.03.23.16.07.04
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 23 Mar 2022 16:07:04 -0700 (PDT)
Date: Wed, 23 Mar 2022 19:07:03 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: kernel test robot <lkp@intel.com>
Message-ID: <YjuoF88MzBALI+l8@redhat.com>
References: <202203240638.crXQjFY5-lkp@intel.com>
MIME-Version: 1.0
In-Reply-To: <202203240638.crXQjFY5-lkp@intel.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
Subject: Re: [dm-devel] [device-mapper-dm:dm-5.19 132/132]
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
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, Mar 23 2022 at  6:57P -0400,
kernel test robot <lkp@intel.com> wrote:

> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git dm-5.19
> head:   7f8ac95a6464b895e3d2b6175f7ee64a4c10fcfe
> commit: 7f8ac95a6464b895e3d2b6175f7ee64a4c10fcfe [132/132] dm: push error handling down to __split_and_process_bio
> config: s390-buildonly-randconfig-r005-20220323 (https://download.01.org/0day-ci/archive/20220324/202203240638.crXQjFY5-lkp@intel.com/config)
> compiler: s390-linux-gcc (GCC) 11.2.0
> reproduce (this is a W=1 build):
>         wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
>         chmod +x ~/bin/make.cross
>         # https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git/commit/?id=7f8ac95a6464b895e3d2b6175f7ee64a4c10fcfe
>         git remote add device-mapper-dm https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git
>         git fetch --no-tags device-mapper-dm dm-5.19
>         git checkout 7f8ac95a6464b895e3d2b6175f7ee64a4c10fcfe
>         # save the config file to linux build tree
>         mkdir build_dir
>         COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.2.0 make.cross O=build_dir ARCH=s390 SHELL=/bin/bash drivers/md/
> 
> If you fix the issue, kindly add following tag as appropriate
> Reported-by: kernel test robot <lkp@intel.com>
> 
> All errors (new ones prefixed by >>):
> 
>    drivers/md/dm.c: In function '__process_abnormal_io':
> >> drivers/md/dm.c:1542:18: error: 'result' undeclared (first use in this function)
>     1542 |                 *result = BLK_STS_NOTSUPP;
>          |                  ^~~~~~
>    drivers/md/dm.c:1542:18: note: each undeclared identifier is reported only once for each function it appears in
> 

Yeah, I pushed this too soon, fixed now.

But why are you even testing this branch? I didn't include dm-5.19 in
linux-next yet.

Given that it seems strange for the bot to just pick up some branch,
and then spam LKML, dm-devel, etc like it found a meaningful problem.

Mike

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

