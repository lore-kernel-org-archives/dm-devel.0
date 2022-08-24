Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E783BC00140
	for <dm-devel@archiver.kernel.org>; Wed, 24 Aug 2022 08:12:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1661328740;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=Zj5BKXO8blAdz/qxVvVT6iTPLD4I/MkX5qFCMojlfkQ=;
	b=eUzDAAC2ViKwq7/XF2fte5LtK7MGEpCQf3pfgIKyze9ve2m5zW3Xx1iEGnhtUsri2na1ul
	6Dwh6IG7KTHbynUt4aJqhTPpxcMrsMYczULHu5shV3BOVHcvxP0PUn3X0ZpntiPv1br7b6
	f7BJKokL3iMvLrzBUHNh7Q+vVdHDO4o=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-453-uPBh-5jiMTaDfNbE_fawQw-1; Wed, 24 Aug 2022 04:12:17 -0400
X-MC-Unique: uPBh-5jiMTaDfNbE_fawQw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 08C79380115B;
	Wed, 24 Aug 2022 08:12:16 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 64BF02166B26;
	Wed, 24 Aug 2022 08:12:14 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 508161946A42;
	Wed, 24 Aug 2022 08:12:14 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 2D5E71946A40
 for <dm-devel@listman.corp.redhat.com>; Wed, 24 Aug 2022 08:12:13 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 0EAD540315A; Wed, 24 Aug 2022 08:12:13 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 0AC35492C3B
 for <dm-devel@redhat.com>; Wed, 24 Aug 2022 08:12:13 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E7A6085A58C
 for <dm-devel@redhat.com>; Wed, 24 Aug 2022 08:12:12 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_128_GCM_SHA256) id us-mta-389-jA4TXsDIORGVN7Xm-SQiHw-1; Wed,
 24 Aug 2022 04:12:11 -0400
X-MC-Unique: jA4TXsDIORGVN7Xm-SQiHw-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out2.suse.de (Postfix) with ESMTPS id 089F8200B1;
 Wed, 24 Aug 2022 08:12:10 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id B5DDF13AE9;
 Wed, 24 Aug 2022 08:12:09 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap2.suse-dmz.suse.de with ESMTPSA id YDeEKlndBWNqXwAAMHmgww
 (envelope-from <mwilck@suse.com>); Wed, 24 Aug 2022 08:12:09 +0000
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
 Benjamin Marzinski <bmarzins@redhat.com>
Date: Wed, 24 Aug 2022 10:11:45 +0200
Message-Id: <20220824081147.29270-2-mwilck@suse.com>
In-Reply-To: <20220824081147.29270-1-mwilck@suse.com>
References: <20220824081147.29270-1-mwilck@suse.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
Subject: [dm-devel] [PATCH v2 1/3] libmultipath: merge_mptable(): sort table
 by wwid
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
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Martin Wilck <mwilck@suse.com>

If the mptable is very large (for example, in a configuration with
lots of maps assigned individual aliases), merge_mptable may get
very slow because it needs to make O(n^2) string comparisons (with
n being the number of mptable entries). WWID strings often differ
only in the last few bytes, causing a lot of CPU time spent in
strcmp().

merge_mptable is executed whenever multipath or multipathd is started, that
is, also for "multipath -u" and "multipath -U" invocations from udev rules.
Optimize it by sorting the mptable before merging. This way we don't need
to iterate towards the end of the vector searching for duplicates.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/config.c | 24 ++++++++++++++++++++++--
 libmultipath/vector.c |  8 ++++++++
 libmultipath/vector.h |  1 +
 3 files changed, 31 insertions(+), 2 deletions(-)

diff --git a/libmultipath/config.c b/libmultipath/config.c
index ab8b26e..18d7159 100644
--- a/libmultipath/config.c
+++ b/libmultipath/config.c
@@ -520,6 +520,23 @@ merge_mpe(struct mpentry *dst, struct mpentry *src)
 	merge_num(mode);
 }
 
+static int wwid_compar(const void *p1, const void *p2)
+{
+	const char *wwid1 = (*(struct mpentry * const *)p1)->wwid;
+	const char *wwid2 = (*(struct mpentry * const *)p2)->wwid;
+	int cmp = strcmp(wwid1, wwid2);
+
+	if (cmp)
+		return cmp;
+	/*
+	 * qsort by itself is not a stable sorting algorithm: it may permute
+	 * elements with equal keys, which we must avoid because of the way
+	 * merge_mpe() works.  Because the function arguments are offsets into
+	 * the array (struct mpentry **), we can simply compare the pointers.
+	 */
+	return p1 < p2 ? -1 : p1 > p2 ? 1 : 0;
+}
+
 void merge_mptable(vector mptable)
 {
 	struct mpentry *mp1, *mp2;
@@ -533,10 +550,13 @@ void merge_mptable(vector mptable)
 			free_mpe(mp1);
 			continue;
 		}
+	}
+	vector_sort(mptable, wwid_compar);
+	vector_foreach_slot(mptable, mp1, i) {
 		j = i + 1;
 		vector_foreach_slot_after(mptable, mp2, j) {
-			if (!mp2->wwid || strcmp(mp1->wwid, mp2->wwid))
-				continue;
+			if (strcmp(mp1->wwid, mp2->wwid))
+				break;
 			condlog(1, "%s: duplicate multipath config section for %s",
 				__func__, mp1->wwid);
 			merge_mpe(mp2, mp1);
diff --git a/libmultipath/vector.c b/libmultipath/vector.c
index e2d1ec9..0befe71 100644
--- a/libmultipath/vector.c
+++ b/libmultipath/vector.c
@@ -208,3 +208,11 @@ int vector_find_or_add_slot(vector v, void *value)
 	vector_set_slot(v, value);
 	return VECTOR_SIZE(v) - 1;
 }
+
+void vector_sort(vector v, int (*compar)(const void *, const void *))
+{
+	if (!v || !v->slot || !v->allocated)
+		return;
+	return qsort((void *)v->slot, v->allocated, sizeof(void *), compar);
+
+}
diff --git a/libmultipath/vector.h b/libmultipath/vector.h
index 2862dc2..c0b09cb 100644
--- a/libmultipath/vector.h
+++ b/libmultipath/vector.h
@@ -89,4 +89,5 @@ extern void vector_repack(vector v);
 extern void vector_dump(vector v);
 extern void dump_strvec(vector strvec);
 extern int vector_move_up(vector v, int src, int dest);
+void vector_sort(vector v, int (*compar)(const void *, const void *));
 #endif
-- 
2.37.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

