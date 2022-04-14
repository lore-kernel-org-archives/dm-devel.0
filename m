Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 08881C433FE
	for <dm-devel@archiver.kernel.org>; Thu, 14 Apr 2022 04:27:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1649910471;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=u58zYEJsO+K4X7esxcq/0Vhr/nuSAR8p3Hh6XmtVWCo=;
	b=eUC3lPaLpXrcOu1hZBXna1RpNP4R5r9fkDxJ3A4127sQ6MZC2oWAQ+GiS8EijefQzeuy7r
	LivfjyK9UZyXEvbXVxtPmpGKViHDHLOOFNJNju3JjOGLqiZcg8qrf2rjjxGgBt4G6tJo2R
	BLitbL1buSuAAf3joSGX+PXRGYDWPGo=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-370-otrfQUsDPhOsjhOu1dQ0Ng-1; Thu, 14 Apr 2022 00:27:48 -0400
X-MC-Unique: otrfQUsDPhOsjhOu1dQ0Ng-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BF99929DD9B5;
	Thu, 14 Apr 2022 04:27:46 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 130B1141ADA5;
	Thu, 14 Apr 2022 04:27:46 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id C4CBD1940345;
	Thu, 14 Apr 2022 04:27:45 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id D83F61940344
 for <dm-devel@listman.corp.redhat.com>; Thu, 14 Apr 2022 04:27:43 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id B9848C28127; Thu, 14 Apr 2022 04:27:43 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id A6A97C28114;
 Thu, 14 Apr 2022 04:27:43 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
 by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 23E4RgbL025301;
 Wed, 13 Apr 2022 23:27:42 -0500
Received: (from bmarzins@localhost)
 by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 23E4RfC7025300;
 Wed, 13 Apr 2022 23:27:41 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Date: Wed, 13 Apr 2022 23:27:34 -0500
Message-Id: <1649910461-25263-1-git-send-email-bmarzins@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
Subject: [dm-devel] [PATCH v2 0/7] Add protocol specific config subsection
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
 Martin Wilck <Martin.Wilck@suse.com>
MIME-Version: 1.0
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Some storage arrays can be accessed using multiple protocols at the same
time.  I've have customers request the ability to set different values
for the path specific timeouts, like fast_io_fail_tmo, based on the
protocol used to access the path. In order to make this possible, this
patchset adds a new protocol subsection to the overrides section. This
allows users to set a device config's path specific timeouts, such as
dev_loss_tmo, fast_io_fail_tmo, and eh_deadline on a per-protocol basis.

Changes from v1 (all based on suggestions from Martin Wilck):
0003: Adds the protocol subsection to the overrides section instead of
      the device subsection, pulling in code from original patch 0007
0005: Checks the pctable of the overrides section instead of the
      hwes, pulling in code from original patch 0007
Original patches 0006 and 0007 have been removed.
0007: (original patch 0009) modified the man page to no longer
      reference the protocol subsection under the device
      subsection

Benjamin Marzinski (7):
  libmultipath: steal the src string pointer in merge_str()
  libmultipath: make protocol_name global
  libmultipath: add a protocol subsection to multipath.conf
  libmultipath: Set the scsi timeout parameters by path
  libmultipath: check the overrides pctable for path variables
  libmultipath: fix eh_deadline documentation
  libmultipath: Add documentation for the protocol subsection

 libmultipath/config.c      |  99 ++++++++++++++++++---
 libmultipath/config.h      |  10 +++
 libmultipath/configure.c   |   5 +-
 libmultipath/dict.c        |  99 +++++++++++++++++++++
 libmultipath/discovery.c   | 174 +++++++++++++++++++++----------------
 libmultipath/discovery.h   |   2 +-
 libmultipath/print.c       |  67 ++++++++++----
 libmultipath/propsel.c     |  65 +++++++++-----
 libmultipath/propsel.h     |   6 +-
 libmultipath/structs.c     |  19 +++-
 libmultipath/structs.h     |   7 +-
 multipath/multipath.conf.5 |  36 ++++++++
 12 files changed, 452 insertions(+), 137 deletions(-)

-- 
2.17.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

