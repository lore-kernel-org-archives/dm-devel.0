Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DF07DECAAD8
	for <dm-devel@archiver.kernel.org>; Thu,  1 Sep 2022 16:10:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1662048648;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=38N0ZT3jfZ9GiHJJeGuB+TEQj7v+ezgTVS0jRlbG/cQ=;
	b=HNkclM5xiFHEdZ7FKe3RfiBJlYFE2nzIka61naTwrK485Z8mvKiRaIELDIytmT8X7IJU4V
	S/1vvH3TH21+AsFB7yr0kfhShMZrY1BwdpB125FCU4fCDjrk8pl8pyYBT6guWmWjWyfAWv
	SyV8wFLKE0Si1vSZK5YTg88OJYbhXkc=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-435-oqIH7B38NMSB4KYu_m6DrQ-1; Thu, 01 Sep 2022 12:10:45 -0400
X-MC-Unique: oqIH7B38NMSB4KYu_m6DrQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 54E483C10698;
	Thu,  1 Sep 2022 16:10:31 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 435BC2026D4C;
	Thu,  1 Sep 2022 16:10:31 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 14DFB1942685;
	Thu,  1 Sep 2022 16:10:31 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 0F5561940346
 for <dm-devel@listman.corp.redhat.com>; Thu,  1 Sep 2022 16:10:15 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id E7D4C40D2831; Thu,  1 Sep 2022 16:10:14 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id E404B40D2830
 for <dm-devel@redhat.com>; Thu,  1 Sep 2022 16:10:14 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CBAF0180A2FE
 for <dm-devel@redhat.com>; Thu,  1 Sep 2022 16:10:14 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_128_GCM_SHA256) id us-mta-195-zwHa6P7qOlOHte1EhULVwg-1; Thu,
 01 Sep 2022 12:10:10 -0400
X-MC-Unique: zwHa6P7qOlOHte1EhULVwg-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out2.suse.de (Postfix) with ESMTPS id C4CB320219;
 Thu,  1 Sep 2022 16:10:07 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 99ABE13A79;
 Thu,  1 Sep 2022 16:10:07 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap2.suse-dmz.suse.de with ESMTPSA id WF/tI1/ZEGMPDQAAMHmgww
 (envelope-from <mwilck@suse.com>); Thu, 01 Sep 2022 16:10:07 +0000
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
 Benjamin Marzinski <bmarzins@redhat.com>
Date: Thu,  1 Sep 2022 18:09:42 +0200
Message-Id: <20220901160952.2167-7-mwilck@suse.com>
In-Reply-To: <20220901160952.2167-1-mwilck@suse.com>
References: <20220901160952.2167-1-mwilck@suse.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Subject: [dm-devel] [PATCH 06/16] tests/Makefile: use $(multipathdir)
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
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Martin Wilck <mwilck@suse.com>

.. instead of hard-coded ../libmultipath.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 tests/Makefile | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/tests/Makefile b/tests/Makefile
index 9866962..e2793d5 100644
--- a/tests/Makefile
+++ b/tests/Makefile
@@ -48,30 +48,30 @@ mpathvalid-test_FLAGS := -I$(mpathvaliddir)
 #    unit test file, e.g. "config-test.o", in XYZ-test_OBJDEPS
 # XYZ-test_LIBDEPS: Additional libs to link for this test
 
-dmevents-test_OBJDEPS = ../libmultipath/devmapper.o
+dmevents-test_OBJDEPS = $(multipathdir)/devmapper.o
 dmevents-test_LIBDEPS = -lpthread -ldevmapper -lurcu
 hwtable-test_TESTDEPS := test-lib.o
-hwtable-test_OBJDEPS := ../libmultipath/discovery.o ../libmultipath/blacklist.o \
-	../libmultipath/structs.o ../libmultipath/propsel.o
+hwtable-test_OBJDEPS := $(multipathdir)/discovery.o $(multipathdir)/blacklist.o \
+	$(multipathdir)/structs.o $(multipathdir)/propsel.o
 hwtable-test_LIBDEPS := -ludev -lpthread -ldl
 blacklist-test_TESTDEPS := test-log.o
-blacklist-test_OBJDEPS := ../libmultipath/blacklist.o
+blacklist-test_OBJDEPS := $(multipathdir)/blacklist.o
 blacklist-test_LIBDEPS := -ludev
-vpd-test_OBJDEPS :=  ../libmultipath/discovery.o
+vpd-test_OBJDEPS :=  $(multipathdir)/discovery.o
 vpd-test_LIBDEPS := -ludev -lpthread -ldl
 alias-test_TESTDEPS := test-log.o
 alias-test_LIBDEPS := -lpthread -ldl
-valid-test_OBJDEPS := ../libmultipath/valid.o ../libmultipath/discovery.o
+valid-test_OBJDEPS := $(multipathdir)/valid.o $(multipathdir)/discovery.o
 valid-test_LIBDEPS := -ludev -lpthread -ldl
 devt-test_LIBDEPS := -ludev
 mpathvalid-test_LIBDEPS := -ludev -lpthread -ldl
-mpathvalid-test_OBJDEPS := ../libmpathvalid/mpath_valid.o
+mpathvalid-test_OBJDEPS := $(mpathvaliddir)/mpath_valid.o
 ifneq ($(DIO_TEST_DEV),)
 directio-test_LIBDEPS := -laio
 endif
-strbuf-test_OBJDEPS := ../libmpathutil/strbuf.o
+strbuf-test_OBJDEPS := $(mpathutildir)/strbuf.o
 sysfs-test_TESTDEPS := test-log.o
-sysfs-test_OBJDEPS := ../libmultipath/sysfs.o ../libmpathutil/util.o
+sysfs-test_OBJDEPS := $(multipathdir)/sysfs.o $(mpathutildir)/util.o
 sysfs-test_LIBDEPS := -ludev -lpthread -ldl
 
 %.o: %.c
@@ -79,7 +79,7 @@ sysfs-test_LIBDEPS := -ludev -lpthread -ldl
 
 lib/libchecktur.so:
 	mkdir -p lib
-	ln ../libmultipath/*/*.so lib
+	ln $(multipathdir)/*/*.so lib
 
 %.out:	%-test lib/libchecktur.so
 	@echo == running $< ==
-- 
2.37.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

