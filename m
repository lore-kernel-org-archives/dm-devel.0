Return-Path: <SRS0=cnJz=DX=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EED0BC433DF
	for <dm-devel@archiver.kernel.org>; Fri, 16 Oct 2020 10:44:09 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 5AA66207F7
	for <dm-devel@archiver.kernel.org>; Fri, 16 Oct 2020 10:44:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5AA66207F7
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-560-YR6z3IZYOfS1eVWwyGhEjA-1; Fri, 16 Oct 2020 06:44:05 -0400
X-MC-Unique: YR6z3IZYOfS1eVWwyGhEjA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 00EE586ABCF;
	Fri, 16 Oct 2020 10:43:58 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D5E965D9DD;
	Fri, 16 Oct 2020 10:43:57 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id A6DCC5810F;
	Fri, 16 Oct 2020 10:43:57 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 09GAhq5H020139 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 16 Oct 2020 06:43:52 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 5FB562011559; Fri, 16 Oct 2020 10:43:52 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 5AE742011557
	for <dm-devel@redhat.com>; Fri, 16 Oct 2020 10:43:49 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 51B97800186
	for <dm-devel@redhat.com>; Fri, 16 Oct 2020 10:43:49 +0000 (UTC)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-70-6DdqKEYAOvKfNYjU5yLGHw-1;
	Fri, 16 Oct 2020 06:43:46 -0400
X-MC-Unique: 6DdqKEYAOvKfNYjU5yLGHw-1
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
	by mx2.suse.de (Postfix) with ESMTP id 07C89AC5F;
	Fri, 16 Oct 2020 10:43:45 +0000 (UTC)
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Date: Fri, 16 Oct 2020 12:43:09 +0200
Message-Id: <20201016104329.8337-2-mwilck@suse.com>
In-Reply-To: <20201016104329.8337-1-mwilck@suse.com>
References: <20201016104329.8337-1-mwilck@suse.com>
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 09GAhq5H020139
X-loop: dm-devel@redhat.com
Cc: Chongyun Wu <wu.chongyun@h3c.com>, dm-devel@redhat.com,
	Martin Wilck <mwilck@suse.com>
Subject: [dm-devel] [PATCH v3 01/21] multipathd: allow shutdown during
	configure()
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Martin Wilck <mwilck@suse.com>

reconfigure() can be a long-running operation; both initial path
discovery and initial map setup can take a long time. Allow
the main program to indicate that the process should be
interrupted if a shutdown signal was received.

We take advantage of the dynamic linker's symbol lookup ordering
here. The default implementation of should_exit never returns
true, but callers (like multipathd) can override it.

Cc: Chongyun Wu <wu.chongyun@h3c.com>
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/configure.c |  6 ++++++
 libmultipath/discovery.c |  3 +++
 libmultipath/util.c      |  5 +++++
 libmultipath/util.h      |  1 +
 multipathd/main.c        | 17 +++++++++++++++++
 5 files changed, 32 insertions(+)

diff --git a/libmultipath/configure.c b/libmultipath/configure.c
index d7afc91..1c8aac0 100644
--- a/libmultipath/configure.c
+++ b/libmultipath/configure.c
@@ -1173,6 +1173,12 @@ int coalesce_paths (struct vectors * vecs, vector newmp, char * refwwid,
 
 	vector_foreach_slot (pathvec, pp1, k) {
 		int invalid;
+
+		if (should_exit()) {
+			ret = CP_FAIL;
+			goto out;
+		}
+
 		/* skip this path for some reason */
 
 		/* 1. if path has no unique id or wwid blacklisted */
diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index 193d712..cbde358 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -200,6 +200,9 @@ path_discovery (vector pathvec, int flag)
 		const char *devtype;
 		const char *devpath;
 
+		if (should_exit())
+			break;
+
 		devpath = udev_list_entry_get_name(entry);
 		condlog(4, "Discover device %s", devpath);
 		udevice = udev_device_new_from_syspath(udev, devpath);
diff --git a/libmultipath/util.c b/libmultipath/util.c
index 1dad90f..66cd721 100644
--- a/libmultipath/util.c
+++ b/libmultipath/util.c
@@ -430,3 +430,8 @@ void _log_bitfield_overflow(const char *f, unsigned int bit, unsigned int len)
 {
 	condlog(0, "%s: bitfield overflow: %u >= %u", f, bit, len);
 }
+
+int should_exit(void)
+{
+	return 0;
+}
diff --git a/libmultipath/util.h b/libmultipath/util.h
index 0f0f6cb..c1ae878 100644
--- a/libmultipath/util.h
+++ b/libmultipath/util.h
@@ -27,6 +27,7 @@ int parse_prkey(const char *ptr, uint64_t *prkey);
 int parse_prkey_flags(const char *ptr, uint64_t *prkey, uint8_t *flags);
 int safe_write(int fd, const void *buf, size_t count);
 void set_max_fds(rlim_t max_fds);
+int should_exit(void);
 
 #define KERNEL_VERSION(maj, min, ptc) ((((maj) * 256) + (min)) * 256 + (ptc))
 #define ARRAY_SIZE(x) (sizeof(x)/sizeof((x)[0]))
diff --git a/multipathd/main.c b/multipathd/main.c
index eedc6c1..fa53e96 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -141,6 +141,11 @@ static inline enum daemon_status get_running_state(void)
 	return st;
 }
 
+int should_exit(void)
+{
+	return get_running_state() == DAEMON_SHUTDOWN;
+}
+
 /*
  * global copy of vecs for use in sig handlers
  */
@@ -2570,6 +2575,9 @@ configure (struct vectors * vecs)
 		goto fail;
 	}
 
+	if (should_exit())
+		goto fail;
+
 	conf = get_multipath_config();
 	pthread_cleanup_push(put_multipath_config, conf);
 	vector_foreach_slot (vecs->pathvec, pp, i){
@@ -2586,6 +2594,9 @@ configure (struct vectors * vecs)
 		goto fail;
 	}
 
+	if (should_exit())
+		goto fail;
+
 	/*
 	 * create new set of maps & push changed ones into dm
 	 * In the first call, use FORCE_RELOAD_WEAK to avoid making
@@ -2600,6 +2611,9 @@ configure (struct vectors * vecs)
 		goto fail;
 	}
 
+	if (should_exit())
+		goto fail;
+
 	/*
 	 * may need to remove some maps which are no longer relevant
 	 * e.g., due to blacklist changes in conf file
@@ -2611,6 +2625,9 @@ configure (struct vectors * vecs)
 
 	dm_lib_release();
 
+	if (should_exit())
+		goto fail;
+
 	sync_maps_state(mpvec);
 	vector_foreach_slot(mpvec, mpp, i){
 		if (remember_wwid(mpp->wwid) == 1)
-- 
2.28.0


--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

