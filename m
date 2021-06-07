Return-Path: <SRS0=RkM6=LB=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1A7EC47082
	for <dm-devel@archiver.kernel.org>; Mon,  7 Jun 2021 14:58:28 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 4434B61159
	for <dm-devel@archiver.kernel.org>; Mon,  7 Jun 2021 14:58:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4434B61159
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=canonical.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-512-pjcUrr-sPN-LZ3Sb0Aunwg-1; Mon, 07 Jun 2021 10:58:25 -0400
X-MC-Unique: pjcUrr-sPN-LZ3Sb0Aunwg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CDDC51013721;
	Mon,  7 Jun 2021 14:58:20 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 9EEDC5D9C0;
	Mon,  7 Jun 2021 14:58:19 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id BD31944A5C;
	Mon,  7 Jun 2021 14:58:17 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 157Etgui008763 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 7 Jun 2021 10:55:42 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 1E5021111A5B; Mon,  7 Jun 2021 14:55:42 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 18D11100213D
	for <dm-devel@redhat.com>; Mon,  7 Jun 2021 14:55:39 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 515C418E0936
	for <dm-devel@redhat.com>; Mon,  7 Jun 2021 14:55:39 +0000 (UTC)
Received: from youngberry.canonical.com (youngberry.canonical.com
	[91.189.89.112]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-405-b_NPQuWLNb2sF-paQH1T1A-1; Mon, 07 Jun 2021 10:55:35 -0400
X-MC-Unique: b_NPQuWLNb2sF-paQH1T1A-1
Received: from mail-yb1-f200.google.com ([209.85.219.200])
	by youngberry.canonical.com with esmtps (TLS1.2) tls
	TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256 (Exim 4.93)
	(envelope-from <utkarsh.gupta@canonical.com>) id 1lqGP7-0000eF-CV
	for dm-devel@redhat.com; Mon, 07 Jun 2021 14:39:01 +0000
Received: by mail-yb1-f200.google.com with SMTP id
	m194-20020a2526cb0000b02905375d41acd7so22520678ybm.22
	for <dm-devel@redhat.com>; Mon, 07 Jun 2021 07:39:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
	bh=2qz9LBH6BxZtYGbia0aVaE+yaCUO1saX7V4G9e/gt6A=;
	b=EIcPY6Js1RdGx+fTL4clLWhC3EVf82jOisF/K7cX06Ag4/yL8fVeO4b88pfKGCVvWZ
	blc6XZTt2r0wXzBw4roBO7wr38CUsf7V07yh9Bl100ep9Jp27+pVEoTA64EVM+HGxZo8
	WHR8ePl8SpNEkI4JngQ9RONczT7/hV1iLTZq5XWiuLZy3rofbniL19czU8kEKDMjh7Qd
	hCnykhYWMmwj/tBAr/EU9xaoppF5alGeVFXSNZmn1wHFlhpt6GXlXfbKGzmm+MktHfsP
	LXqF3iFAfoNH12owKTkLuDfLwh367qNOVTNekLFDFTzpF/djdknYk2GQ1CH+ZziD+uwj
	Z8Dw==
X-Gm-Message-State: AOAM533kmv3tWbdEppJewZkDNjJ71CePNrszxIVdZzrt7VAtgdphSPZg
	OwVYnytqQ/VhAT/mMEDZb0w0PCtFhiXH+8I19bo2I1udEWwAvsrrt65A6zXXCUTc5Wb3V4s2I7c
	T8pLJCpAofczhLax/6lfM7T8D4S0IQ1dqnylsMwBvTKIMtw==
X-Received: by 2002:a25:3406:: with SMTP id b6mr24869370yba.318.1623076740424; 
	Mon, 07 Jun 2021 07:39:00 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyyS+wjcfVE14cm77FsZkCULzNs6cHTTH7gD03R5c3qOGkF40ev8WOeL+9aS8jfXV0FLkJHs3bRZGyERZnce0Y=
X-Received: by 2002:a25:3406:: with SMTP id b6mr24869346yba.318.1623076740282; 
	Mon, 07 Jun 2021 07:39:00 -0700 (PDT)
MIME-Version: 1.0
From: Utkarsh Gupta <utkarsh.gupta@canonical.com>
Date: Mon, 7 Jun 2021 20:08:24 +0530
Message-ID: <CADnr9J9-+cOtVQKxt+5QQ53efwvqfQZv6F0wdwWzMw+TZXN_tw@mail.gmail.com>
To: dm-devel@redhat.com
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
Subject: [dm-devel] [PATCH] multipathd: don't start in containers
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Do not attempt to start multipath-tools in containers,
should switch for on-demand udev/socket based
activation in the future.

Originally reported as:
https://bugs.launchpad.net/ubuntu/+source/multipath-tools/+bug/1823093

Author: Dimitri John Ledkov <xnox@ubuntu.com>
Co-Author: Utkarsh Gupta <utkarsh@debian.org>

---
 multipathd/multipathd.service | 1 +
 1 file changed, 1 insertion(+)

--- a/multipathd/multipathd.service
+++ b/multipathd/multipathd.service
@@ -8,6 +8,7 @@ DefaultDependencies=no
 Conflicts=shutdown.target
 ConditionKernelCommandLine=!nompath
 ConditionKernelCommandLine=!multipath=off
+ConditionVirtualization=!container

 [Service]
 Type=notify


- u

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

