Return-Path: <SRS0=YCRG=D4=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72E88C388F9
	for <dm-devel@archiver.kernel.org>; Wed, 21 Oct 2020 21:41:49 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id C616D223C7
	for <dm-devel@archiver.kernel.org>; Wed, 21 Oct 2020 21:41:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="iCBGlyza"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C616D223C7
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1603316507;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=UsAOG1V4vlYu06rewNf9G8zvVtpOyjwrVskIWKkU7v0=;
	b=iCBGlyzanHl3EoSyfy0ILqfloCnllV20dQYbYm5RP7UBk6beSBOUj1VhlGea3P3SqopCsL
	rCsNbZuQMLXBTFIMRFHyTiY3MwF6lLxY2Igc5ZT+BaAuh5Z0MBCW3GTyt6Q2f8Hlqel0Uj
	d1XJgfrglLvFtlvZtZWJhoC24mXYKxc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-313-XNhvAouuNwCDppj_44X83A-1; Wed, 21 Oct 2020 17:41:45 -0400
X-MC-Unique: XNhvAouuNwCDppj_44X83A-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B08961868431;
	Wed, 21 Oct 2020 21:41:39 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id AC23B10023A5;
	Wed, 21 Oct 2020 21:41:38 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id AF4CA181A06C;
	Wed, 21 Oct 2020 21:41:36 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com
	[10.5.11.15])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 09LLdVk5008755 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 21 Oct 2020 17:39:31 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 610A355760; Wed, 21 Oct 2020 21:39:31 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 758A055773;
	Wed, 21 Oct 2020 21:39:28 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
	by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 09LLdQcO028775; 
	Wed, 21 Oct 2020 16:39:27 -0500
Received: (from bmarzins@localhost)
	by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 09LLdQV3028774;
	Wed, 21 Oct 2020 16:39:26 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Date: Wed, 21 Oct 2020 16:39:22 -0500
Message-Id: <1603316366-28735-1-git-send-email-bmarzins@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-loop: dm-devel@redhat.com
Cc: device-mapper development <dm-devel@redhat.com>,
	Martin Wilck <Martin.Wilck@suse.com>
Subject: [dm-devel] [PATCH v3 0/4] add library to check if device is a valid
	path
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
MIME-Version: 1.0
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

The main part of the this patchset is the first patch, which adds a
new library interface to check whether devices are valid paths. This
was designed for use in the Storage Instantiation Daemon (SID).

https://github.com/sid-project

The seconds patch adds unit tests for this library. The third patch adds
get_uid fallback code for dasd devices. The fourth patch just changes
the get_uid log level for devices configured with uid_attribute "". This
is because it is currently necessary to configure multipath with

overrides {
        uid_attribute ""
}

to claim multipath devices with SID (instead of using multipath.rules),
since SID doesn't currently get the UID information itself, and it is
called by udev before this information is added to the udev database.

changes from v1 to v2
---------------------
0001: This patch is now rebased on top of, and makes use of Martin's
patches that provide a default *_multipath_config, udev, and logsink.
Because of this, mpathvalid_init() now has a parameter used to set
logsink. There is also a new API function, mpathvalid_reload_config().

0003: This is completely new, since Martin pointed out that adding a new
config option to always use the fallback getuid code was unnecessary. It
just makes a uid_attribute of "" log at normal levels.

changes from v2 to v3
---------------------
0001:   rebased on top of Martin's latest patches, fixed some small bugs
        and added documentation to mpath_valid.h
0002:   New
0004:   was 0003. Untangled the logic, at Martin's suggestion.

Benjamin Marzinski (4):
  multipath: add libmpathvalid library
  multipath-tools tests: and unit tests for libmpathvalid
  libmultipath: add uid failback for dasd devices
  libmultipath: change log level for null uid_attribute

 Makefile                            |   3 +-
 Makefile.inc                        |   1 +
 libmpathvalid/Makefile              |  39 +++
 libmpathvalid/libmpathvalid.version |  10 +
 libmpathvalid/mpath_valid.c         | 202 ++++++++++++
 libmpathvalid/mpath_valid.h         | 155 +++++++++
 libmultipath/defaults.h             |   1 +
 libmultipath/discovery.c            |  45 ++-
 libmultipath/libmultipath.version   |   6 +
 tests/Makefile                      |   5 +-
 tests/mpathvalid.c                  | 467 ++++++++++++++++++++++++++++
 11 files changed, 929 insertions(+), 5 deletions(-)
 create mode 100644 libmpathvalid/Makefile
 create mode 100644 libmpathvalid/libmpathvalid.version
 create mode 100644 libmpathvalid/mpath_valid.c
 create mode 100644 libmpathvalid/mpath_valid.h
 create mode 100644 tests/mpathvalid.c

-- 
2.17.2

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

