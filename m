Return-Path: <SRS0=33od=EL=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF314C388F7
	for <dm-devel@archiver.kernel.org>; Thu,  5 Nov 2020 10:21:07 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 1203B20684
	for <dm-devel@archiver.kernel.org>; Thu,  5 Nov 2020 10:21:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1203B20684
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-231-x6z661BsPC2FYa2ltOBqLA-1; Thu, 05 Nov 2020 05:21:02 -0500
X-MC-Unique: x6z661BsPC2FYa2ltOBqLA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 408DC186DD24;
	Thu,  5 Nov 2020 10:20:58 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id DF9AB5B4CA;
	Thu,  5 Nov 2020 10:20:57 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id B77455812C;
	Thu,  5 Nov 2020 10:20:54 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0A5AKrm8029217 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 5 Nov 2020 05:20:53 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 8ABD5200E1F7; Thu,  5 Nov 2020 10:20:53 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 858E720235B9
	for <dm-devel@redhat.com>; Thu,  5 Nov 2020 10:20:51 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 651CE1021F7C
	for <dm-devel@redhat.com>; Thu,  5 Nov 2020 10:20:51 +0000 (UTC)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-451-9KXvnmdKOy-LMLnTmhAlRg-1;
	Thu, 05 Nov 2020 05:20:48 -0500
X-MC-Unique: 9KXvnmdKOy-LMLnTmhAlRg-1
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
	by mx2.suse.de (Postfix) with ESMTP id 01DB9AC2E;
	Thu,  5 Nov 2020 10:20:47 +0000 (UTC)
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Date: Thu,  5 Nov 2020 11:20:32 +0100
Message-Id: <20201105102033.18411-2-mwilck@suse.com>
In-Reply-To: <20201105102033.18411-1-mwilck@suse.com>
References: <20201105102033.18411-1-mwilck@suse.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 0A5AKrm8029217
X-loop: dm-devel@redhat.com
Cc: dm-devel@redhat.com, Xose Vazquez Perez <xose.vazquez@gmail.com>,
	Martin Wilck <mwilck@suse.com>
Subject: [dm-devel] [PATCH 1/2] libmultipath tests: delete test-log.d during
	"make clean"
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
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Martin Wilck <mwilck@suse.com>

test-log.d was not cleaned out. Fix it.

Reported-by: Xose Vasquez Perez <xose.vazquez@gmail.com>
Tested-by: Xose Vasquez Perez <xose.vazquez@gmail.com>
Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 tests/Makefile | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tests/Makefile b/tests/Makefile
index 3bacabd..d26b3ce 100644
--- a/tests/Makefile
+++ b/tests/Makefile
@@ -14,6 +14,7 @@ LIBDEPS += -L$(multipathdir) -L$(mpathcmddir) -lmultipath -lmpathcmd -lcmocka
 
 TESTS := uevent parser util dmevents hwtable blacklist unaligned vpd pgpolicy \
 	 alias directio valid devt
+HELPERS := test-lib.o test-log.o
 
 .SILENT: $(TESTS:%=%.o)
 .PRECIOUS: $(TESTS:%=%-test)
@@ -74,7 +75,7 @@ lib/libchecktur.so:
 	@LD_LIBRARY_PATH=$(multipathdir):$(mpathcmddir) \
 		valgrind --leak-check=full --error-exitcode=128 ./$< >$@ 2>&1
 
-OBJS = $(TESTS:%=%.o) test-lib.o
+OBJS = $(TESTS:%=%.o) $(HELPERS)
 
 test_clean:
 	$(RM) $(TESTS:%=%.out) $(TESTS:%=%.vgr)
-- 
2.29.0


--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

