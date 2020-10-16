Return-Path: <SRS0=cnJz=DX=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 310EAC352BC
	for <dm-devel@archiver.kernel.org>; Fri, 16 Oct 2020 10:45:43 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 8E76C20878
	for <dm-devel@archiver.kernel.org>; Fri, 16 Oct 2020 10:45:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8E76C20878
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-120-3tV8m1bHPXeNzi3RglBuHw-1; Fri, 16 Oct 2020 06:45:38 -0400
X-MC-Unique: 3tV8m1bHPXeNzi3RglBuHw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5DEFF803F6A;
	Fri, 16 Oct 2020 10:45:27 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 3D0C1100760C;
	Fri, 16 Oct 2020 10:45:27 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 1056D18005A3;
	Fri, 16 Oct 2020 10:45:27 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 09GAjLKf020778 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 16 Oct 2020 06:45:21 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id A31C12156A38; Fri, 16 Oct 2020 10:45:21 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 9E2922166B28
	for <dm-devel@redhat.com>; Fri, 16 Oct 2020 10:45:21 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7698E101A569
	for <dm-devel@redhat.com>; Fri, 16 Oct 2020 10:45:21 +0000 (UTC)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-46-Pl0lzPvjMNKWwhZ4knHoow-1;
	Fri, 16 Oct 2020 06:45:18 -0400
X-MC-Unique: Pl0lzPvjMNKWwhZ4knHoow-1
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
	by mx2.suse.de (Postfix) with ESMTP id EDB9AB2CC;
	Fri, 16 Oct 2020 10:45:16 +0000 (UTC)
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Date: Fri, 16 Oct 2020 12:44:55 +0200
Message-Id: <20201016104501.8700-24-mwilck@suse.com>
In-Reply-To: <20201016104501.8700-1-mwilck@suse.com>
References: <20201016104501.8700-1-mwilck@suse.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 09GAjLKf020778
X-loop: dm-devel@redhat.com
Cc: lixiaokeng@huawei.com, dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
Subject: [dm-devel] [PATCH v2 23/29] multipath-tools: mpath-tools.supp: file
	with valgrind suppressions
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Martin Wilck <mwilck@suse.com>

These leaks are caused by other libraries (libsystemd, glibc,
libgcrypt) and should be ignored when debugging with valgrind

Usage example:

valgrind --suppressions=mpath-tools.supp \
    --leak-check=full --show-leak-kinds=all $COMMAND

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 third-party/valgrind/mpath-tools.supp | 32 +++++++++++++++++++++++++++
 1 file changed, 32 insertions(+)
 create mode 100644 third-party/valgrind/mpath-tools.supp

diff --git a/third-party/valgrind/mpath-tools.supp b/third-party/valgrind/mpath-tools.supp
new file mode 100644
index 0000000..0537fd5
--- /dev/null
+++ b/third-party/valgrind/mpath-tools.supp
@@ -0,0 +1,32 @@
+{
+   glibc _dlerror_run leak: https://stackoverflow.com/questions/1542457/memory-leak-reported-by-valgrind-in-dlopen
+   Memcheck:Leak
+   match-leak-kinds: reachable
+   fun:calloc
+   fun:_dlerror_run
+   fun:dlopen*
+}
+
+{
+   systemd mempools are never freed: https://bugzilla.redhat.com/show_bug.cgi?id=1215670
+   Memcheck:Leak
+   match-leak-kinds: reachable
+   fun:malloc
+   fun:mempool_alloc_tile
+   fun:mempool_alloc0_tile
+   fun:hashmap_base_new
+   fun:hashmap_base_ensure_allocated
+}
+
+{
+   libgcrypt library initialization
+   Memcheck:Leak
+   match-leak-kinds: reachable
+   fun:malloc
+   ...
+   fun:_gcry_xmalloc
+   ...
+   fun:global_init.*
+   ...
+   fun:_dl_init
+}
-- 
2.28.0


--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

