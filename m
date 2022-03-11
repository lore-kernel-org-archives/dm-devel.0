Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D911AC433F5
	for <dm-devel@archiver.kernel.org>; Fri, 11 Mar 2022 02:02:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1646964144;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=X/dna4REZgNukaabGkxMvc5LINVXTWJCVUhixIIq2uw=;
	b=hcGO6E9virbeUFbiaW1OT/Bx4lOIXEl1NejCKnHcrTsGqDsXujWCSYUH8HL43CL4p3CZv5
	+umO2tyuvs8163xStkm5/KILk4elC2Zq8VLg9nLkQFjUIMTEvfZp1jtLWGNBGpD8mlQlBA
	RlehOKkiWYZErxmuLxOwRGoNovp+Les=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-613-qrpAVwXONmGXYE8UkCifLw-1; Thu, 10 Mar 2022 21:02:21 -0500
X-MC-Unique: qrpAVwXONmGXYE8UkCifLw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6AFA0899EC1;
	Fri, 11 Mar 2022 02:02:19 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 601DE1121315;
	Fri, 11 Mar 2022 02:02:17 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id D617B19679FF;
	Fri, 11 Mar 2022 02:02:14 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com
 [10.5.11.12])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 8BFA919641B9
 for <dm-devel@listman.corp.redhat.com>; Fri, 11 Mar 2022 02:02:13 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 1CFFD183CA; Fri, 11 Mar 2022 02:02:13 +0000 (UTC)
Received: from octiron.msp.redhat.com (unknown [10.15.80.209])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 0483161077;
 Fri, 11 Mar 2022 02:02:12 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
 by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 22B22AC7021838;
 Thu, 10 Mar 2022 20:02:10 -0600
Received: (from bmarzins@localhost)
 by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 22B22AWu021837;
 Thu, 10 Mar 2022 20:02:10 -0600
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Date: Thu, 10 Mar 2022 20:02:08 -0600
Message-Id: <1646964130-21800-1-git-send-email-bmarzins@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Subject: [dm-devel] [PATCH 0/2] fix looping when reconfigure is delayed
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
Cc: device-mapper development <dm-devel@redhat.com>,
 Guozhonghua <guozh88@chinatelecom.cn>, Martin Wilck <Martin.Wilck@suse.com>
MIME-Version: 1.0
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

This patchset fixes Guozhonghua's looping issue for me. It's the first
patch from Martin's patchset, plus a simple patch to make sure that we
really do switch to the idle state when we're delaying the reconfigure,
and that we stop delaying the reconfigure if we schedule a reconfigure.

Benjamin Marzinski (1):
  multipathd: don't keep looping when config is delayed

Martin Wilck (1):
  multipathd: set reload_type in when calling reconfigure()

 multipathd/main.c | 36 ++++++++++++++++++------------------
 1 file changed, 18 insertions(+), 18 deletions(-)

-- 
2.17.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

