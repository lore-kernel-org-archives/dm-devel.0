Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D5735C05027
	for <dm-devel@archiver.kernel.org>; Wed,  1 Feb 2023 08:03:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1675238636;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=pDLc4Z/3SBQjjRtHC/7vYMn/HPfa3EX0K+hhqwX8XPk=;
	b=dO2VMNb71L1+Wqqx8w2zpbwcR6ZnOPb3ibB3Is11tGVV+dLrzg1q2EMwossSPz88GrZwLK
	m1P87k07c1V8SxYrZwhejtQzi9OYHbWHr2fNbrVZn8fVSJRjWrkjNrACRPl48bhVkgaGzR
	RtDmQnfcmstAP1V/bbFcJeYRBIk8RWY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-594-YCoiHlT8PJ2CDO7kig1y4A-1; Wed, 01 Feb 2023 03:03:55 -0500
X-MC-Unique: YCoiHlT8PJ2CDO7kig1y4A-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 59AB4100DEB5;
	Wed,  1 Feb 2023 08:03:53 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 3B737440DD;
	Wed,  1 Feb 2023 08:03:53 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id B3A971946A49;
	Wed,  1 Feb 2023 08:03:52 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 884281946587
 for <dm-devel@listman.corp.redhat.com>; Tue, 31 Jan 2023 12:17:14 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 442ACC15BAD; Tue, 31 Jan 2023 12:17:14 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 3D101C15BAE
 for <dm-devel@redhat.com>; Tue, 31 Jan 2023 12:17:14 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2321A8588E0
 for <dm-devel@redhat.com>; Tue, 31 Jan 2023 12:17:14 +0000 (UTC)
Received: from dfw.source.kernel.org (dfw.source.kernel.org
 [139.178.84.217]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-382-wqBwOj4aOhmFXWaTfQGOZQ-1; Tue, 31 Jan 2023 07:17:11 -0500
X-MC-Unique: wqBwOj4aOhmFXWaTfQGOZQ-1
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 4EAD9614DC;
 Tue, 31 Jan 2023 12:10:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A32A6C4339B;
 Tue, 31 Jan 2023 12:10:17 +0000 (UTC)
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org
 (localhost.localdomain [127.0.0.1])
 by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id
 7574CC4314C; Tue, 31 Jan 2023 12:10:17 +0000 (UTC)
MIME-Version: 1.0
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: <167516701747.19012.10728935395396675001.git-patchwork-notify@kernel.org>
Date: Tue, 31 Jan 2023 12:10:17 +0000
References: <20230129231053.20863-1-rdunlap@infradead.org>
In-Reply-To: <20230129231053.20863-1-rdunlap@infradead.org>
To: Randy Dunlap <rdunlap@infradead.org>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Mailman-Approved-At: Wed, 01 Feb 2023 08:03:52 +0000
Subject: Re: [dm-devel] [PATCH 0/9] Documentation: correct lots of spelling
 errors (series 2)
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
Cc: nvdimm@lists.linux.dev, linux-doc@vger.kernel.org, song@kernel.org,
 dm-devel@redhat.com, netdev@vger.kernel.org, lizefan.x@bytedance.com,
 sparclinux@vger.kernel.org, quic_neeraju@quicinc.com, agk@redhat.com,
 dave.jiang@intel.com, linux-scsi@vger.kernel.org, corbet@lwn.net,
 vishal.l.verma@intel.com, kuba@kernel.org, pabeni@redhat.com,
 jejb@linux.ibm.com, linux@roeck-us.net, linux-media@vger.kernel.org,
 jdelvare@suse.com, paulmck@kernel.org, frederic@kernel.org, snitzer@kernel.org,
 josh@joshtriplett.org, linux-raid@vger.kernel.org, tj@kernel.org,
 jiri@nvidia.com, cgroups@vger.kernel.org, dan.j.williams@intel.com,
 mchehab@kernel.org, linux-hwmon@vger.kernel.org, rcu@vger.kernel.org,
 martin.petersen@oracle.com, edumazet@google.com, linux-mm@kvack.org,
 gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
 linux-kernel@vger.kernel.org, vkoul@kernel.org, hannes@cmpxchg.org,
 dmaengine@vger.kernel.org, davem@davemloft.net
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hello:

This patch was applied to netdev/net-next.git (master)
by Paolo Abeni <pabeni@redhat.com>:

On Sun, 29 Jan 2023 15:10:44 -0800 you wrote:
> Maintainers of specific kernel subsystems are only Cc-ed on their
> respective patches, not the entire series. [if all goes well]
> 
> These patches are based on linux-next-20230127.
> 
> 
>  [PATCH 1/9] Documentation: admin-guide: correct spelling
>  [PATCH 2/9] Documentation: driver-api: correct spelling
>  [PATCH 3/9] Documentation: hwmon: correct spelling
>  [PATCH 4/9] Documentation: networking: correct spelling
>  [PATCH 5/9] Documentation: RCU: correct spelling
>  [PATCH 6/9] Documentation: scsi/ChangeLog*: correct spelling
>  [PATCH 7/9] Documentation: scsi: correct spelling
>  [PATCH 8/9] Documentation: sparc: correct spelling
>  [PATCH 9/9] Documentation: userspace-api: correct spelling
> 
> [...]

Here is the summary with links:
  - [4/9] Documentation: networking: correct spelling
    https://git.kernel.org/netdev/net-next/c/a266ef69b890

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

