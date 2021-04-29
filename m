Return-Path: <SRS0=Ylab=J3=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5514C433ED
	for <dm-devel@archiver.kernel.org>; Fri, 30 Apr 2021 07:18:52 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 6AF6361424
	for <dm-devel@archiver.kernel.org>; Fri, 30 Apr 2021 07:18:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6AF6361424
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=canonical.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-298-EKW6JPugP7uK15tpUEpzAw-1; Fri, 30 Apr 2021 03:18:49 -0400
X-MC-Unique: EKW6JPugP7uK15tpUEpzAw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DA7F01A8A69;
	Fri, 30 Apr 2021 07:18:44 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 0672F19C45;
	Fri, 30 Apr 2021 07:18:42 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id CC63044A69;
	Fri, 30 Apr 2021 07:18:39 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 13TMUCBp019478 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 29 Apr 2021 18:30:12 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 4CF9B10CD616; Thu, 29 Apr 2021 22:30:12 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 483AD1054FB8
	for <dm-devel@redhat.com>; Thu, 29 Apr 2021 22:30:10 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0D94E185A7A5
	for <dm-devel@redhat.com>; Thu, 29 Apr 2021 22:30:10 +0000 (UTC)
Received: from youngberry.canonical.com (youngberry.canonical.com
	[91.189.89.112]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-411-pXo8qosEN7Cq7_4OtfjG-Q-1; Thu, 29 Apr 2021 18:30:08 -0400
X-MC-Unique: pXo8qosEN7Cq7_4OtfjG-Q-1
Received: from mail-pf1-f199.google.com ([209.85.210.199])
	by youngberry.canonical.com with esmtps
	(TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128) (Exim 4.86_2)
	(envelope-from <matthew.ruffell@canonical.com>) id 1lcEv7-0006TZ-FY
	for dm-devel@redhat.com; Thu, 29 Apr 2021 22:14:05 +0000
Received: by mail-pf1-f199.google.com with SMTP id
	h22-20020aa786d60000b029027d0956e914so3740448pfo.23
	for <dm-devel@redhat.com>; Thu, 29 Apr 2021 15:14:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
	:mime-version:content-language:content-transfer-encoding;
	bh=QgsWf7Yqqo+/RN9txyd7qvZjC+YxWkPrNWjS7tr+Hig=;
	b=HDCmLmnL7ShRmpIvJGbvardaAqIr5XCHVuzTu2b06aFZ1znjxtcktuMHsKJprGSyTr
	aGKA3jD1LUm66coXDbsRsTSr+fl0DB1lKi+FE8+7KX+PsiZlNBno60iF/z0hwrT8LHsL
	jotex8a5hgMkpInTB5lLrYAdlYEVvibWaAdS4dIextrpS+ZmLC2tQx0drBp9PIdDQIOH
	E5lFGz4GnDp5b2BG28P/WpKbnj+qpNDR0iWnQt9aR38UhBm0n78bs3SJNBPy0hEQeem2
	NjUh0NgpjsHeNYNlw5uNkmLYOmPanMx+7OB5fS6/3CfoRzAb2J+qwJgcrMwZlYsTwBdW
	3PAg==
X-Gm-Message-State: AOAM5323yoLPQQzdMljM5WOxlKM+qhPNXg92YhNH1UYK4lHoakJfc/bX
	2Y+7+GiYr/Szqzo0BqpdsTGc2NjW6iNm0CKunUYy2YU092BrR5uQ32/ZKp2zw5+HSJQhwxS6vDw
	e4fIQZ6rPzGX1zVzBtlLdtD2UlWAVDg==
X-Received: by 2002:a05:6a00:150d:b029:27a:ce95:bb0e with SMTP id
	q13-20020a056a00150db029027ace95bb0emr1867082pfu.64.1619734443996;
	Thu, 29 Apr 2021 15:14:03 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxjb2FNHAo8qT/cTKTND0W0E5SX3CTE/GBTiKsKTK0gpPeOj9qqn7zYzH74htmkVEXtb4+Vmw==
X-Received: by 2002:a05:6a00:150d:b029:27a:ce95:bb0e with SMTP id
	q13-20020a056a00150db029027ace95bb0emr1867068pfu.64.1619734443733;
	Thu, 29 Apr 2021 15:14:03 -0700 (PDT)
Received: from [192.168.1.107] (122-58-78-211-adsl.sparkbb.co.nz.
	[122.58.78.211])
	by smtp.gmail.com with ESMTPSA id n20sm890386pgv.15.2021.04.29.15.14.00
	(version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
	Thu, 29 Apr 2021 15:14:03 -0700 (PDT)
To: Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com
From: Matthew Ruffell <matthew.ruffell@canonical.com>
Message-ID: <158e5646-ee2c-ae9c-adb1-1c0d4db1ca6d@canonical.com>
Date: Fri, 30 Apr 2021 10:13:57 +1200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
	Thunderbird/78.8.1
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Fri, 30 Apr 2021 03:15:55 -0400
Cc: linux-raid <linux-raid@vger.kernel.org>, Xiao Ni <xni@redhat.com>
Subject: [dm-devel] Raid1 and Raid10 Discard Limit Fixups for 5.13 Merge
	Window
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
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi Mike,

The Raid10 block discard performance patchset from Xiao Ni has reached mainline
this morning in the following commits:

254c271da071 md/raid10: improve discard request for far layout
d30588b2731f md/raid10: improve raid10 discard request
f2e7e269a752 md/raid10: pull the code that wait for blocked dev into one function
c2968285925a md/raid10: extend r10bio devs to raid disks
cf78408f937a md: add md_submit_discard_bio() for submitting discard bio

I was wondering, are you planning to resubmit your patches to fixup discard
limits for raid1 and raid10 this merge cycle?

commit e0910c8e4f87bb9f767e61a778b0d9271c4dc512
Author: Mike Snitzer <snitzer@redhat.com>
Date: Thu Sep 24 13:14:52 2020 -0400
Subject: dm raid: fix discard limits for raid1 and raid10
Link: https://github.com/torvalds/linux/commit/e0910c8e4f87bb9f767e61a778b0d9271c4dc512

commit f0e90b6c663a7e3b4736cb318c6c7c589f152c28
Author: Mike Snitzer <snitzer@redhat.com>
Date: Thu Sep 24 16:40:12 2020 -0400
Subject: dm raid: remove unnecessary discard limits for raid10
Link: https://github.com/torvalds/linux/commit/f0e90b6c663a7e3b4736cb318c6c7c589f152c28

Thanks,
Matthew

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

