Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 87C9EC433EF
	for <dm-devel@archiver.kernel.org>; Mon, 29 Nov 2021 20:12:38 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-104-iZDPyxKvMIi9-qxHiMzhMQ-1; Mon, 29 Nov 2021 15:12:35 -0500
X-MC-Unique: iZDPyxKvMIi9-qxHiMzhMQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DC0D82F21;
	Mon, 29 Nov 2021 20:12:29 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A0EC660BF1;
	Mon, 29 Nov 2021 20:12:29 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 7A4694BB7C;
	Mon, 29 Nov 2021 20:12:29 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1ATK9sF3002044 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 29 Nov 2021 15:09:54 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 13C8E51E1; Mon, 29 Nov 2021 20:09:54 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 0E6FF51DC
	for <dm-devel@redhat.com>; Mon, 29 Nov 2021 20:09:46 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DABF185A5BC
	for <dm-devel@redhat.com>; Mon, 29 Nov 2021 20:09:46 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-559-IZNLzaLgO7uQ9ndxVSdJaw-1; Mon, 29 Nov 2021 15:09:42 -0500
X-MC-Unique: IZNLzaLgO7uQ9ndxVSdJaw-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id B1B471FD59;
	Mon, 29 Nov 2021 20:09:41 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 66E1E13BDA;
	Mon, 29 Nov 2021 20:09:41 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA id QDsYF4UzpWFsHgAAMHmgww
	(envelope-from <mwilck@suse.com>); Mon, 29 Nov 2021 20:09:41 +0000
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Date: Mon, 29 Nov 2021 21:09:02 +0100
Message-Id: <20211129200902.21817-14-mwilck@suse.com>
In-Reply-To: <20211129200902.21817-1-mwilck@suse.com>
References: <20211129200902.21817-1-mwilck@suse.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 1ATK9sF3002044
X-loop: dm-devel@redhat.com
Cc: Lixiaokeng <lixiaokeng@huawei.com>, dm-devel@redhat.com,
	Martin Wilck <mwilck@suse.com>
Subject: [dm-devel] [PATCH v2 13/13] libmultipath: remove_map(): make sure
	orphaned paths aren't referenced
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Martin Wilck <mwilck@suse.com>

... by the paths and pg vectors of the map to be removed.

Original bug report from Lixiaokeng ("libmultipath: clear removed path from mpp"):

multipathd[3525635]: ==3525635==ERROR: AddressSanitizer: heap-use-after-free on address 0xffffa4902fc0 at pc 0xffffac7d5b88 bp 0xffffa948dac0 sp 0xffffa948dae0
multipathd[3525635]: READ of size 8 at 0xffffa4902fc0 thread T7
multipathd[3525635]:    #0 0xffffac7d5b87 in free_multipath (/usr/lib64/libmultipath.so.0+0x4bb87)
multipathd[3525635]:    #1 0xaaaad6cf7057  (/usr/sbin/multipathd+0x17057)
multipathd[3525635]:    #2 0xaaaad6cf78eb  (/usr/sbin/multipathd+0x178eb)
multipathd[3525635]:    #3 0xaaaad6cff4df  (/usr/sbin/multipathd+0x1f4df)
multipathd[3525635]:    #4 0xaaaad6cfffe7  (/usr/sbin/multipathd+0x1ffe7)
multipathd[3525635]:    #5 0xffffac807be3 in uevent_dispatch (/usr/lib64/libmultipath.so.0+0x7dbe3)
multipathd[3525635]:    #6 0xaaaad6cf563f  (/usr/sbin/multipathd+0x1563f)
multipathd[3525635]:    #7 0xffffac6877af  (/usr/lib64/libpthread.so.0+0x87af)
multipathd[3525635]:    #8 0xffffac44118b  (/usr/lib64/libc.so.6+0xd518b)
multipathd[3525635]: 0xffffa4902fc0 is located 1344 bytes inside of 1440-byte region [0xffffa4902a80,0xffffa4903020)
multipathd[3525635]: freed by thread T7 here:
multipathd[3525635]:    #0 0xffffac97d703 in free (/usr/lib64/libasan.so.4+0xd0703)
multipathd[3525635]:    #1 0xffffac824827 in orphan_paths (/usr/lib64/libmultipath.so.0+0x9a827)
multipathd[3525635]:    #2 0xffffac824a43 in remove_map (/usr/lib64/libmultipath.so.0+0x9aa43)
multipathd[3525635]:    #3 0xaaaad6cf7057  (/usr/sbin/multipathd+0x17057)
multipathd[3525635]:    #4 0xaaaad6cf78eb  (/usr/sbin/multipathd+0x178eb)
multipathd[3525635]:    #5 0xaaaad6cff4df  (/usr/sbin/multipathd+0x1f4df)
multipathd[3525635]:    #6 0xaaaad6cfffe7  (/usr/sbin/multipathd+0x1ffe7)
multipathd[3525635]:    #7 0xffffac807be3 in uevent_dispatch (/usr/lib64/libmultipath.so.0+0x7dbe3)
multipathd[3525635]:    #8 0xaaaad6cf563f  (/usr/sbin/multipathd+0x1563f)
multipathd[3525635]:    #9 0xffffac6877af  (/usr/lib64/libpthread.so.0+0x87af)
multipathd[3525635]:    #10 0xffffac44118b  (/usr/lib64/libc.so.6+0xd518b)

When mpp only has one path and log out the path, there is an asan error.
In remove_mpp, the pp is freed firstly in orphan_path but is accessed,
changed in free_multipath later. Before free_path(pp), the pp should be
cleared from pp->mpp.

Reported-by: Lixiaokeng <lixiaokeng@huawei.com>
Tested-by: Lixiaokeng <lixiaokeng@huawei.com>
Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/structs_vec.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/libmultipath/structs_vec.c b/libmultipath/structs_vec.c
index bfec840..61f8e1b 100644
--- a/libmultipath/structs_vec.c
+++ b/libmultipath/structs_vec.c
@@ -341,6 +341,10 @@ remove_map(struct multipath *mpp, vector pathvec, vector mpvec)
 {
 	int i;
 
+	free_pathvec(mpp->paths, KEEP_PATHS);
+	free_pgvec(mpp->pg, KEEP_PATHS);
+	mpp->paths = mpp->pg = NULL;
+
 	/*
 	 * clear references to this map
 	 */
-- 
2.33.1


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

