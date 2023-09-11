Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D0709EEB57E
	for <dm-devel@archiver.kernel.org>; Mon, 11 Sep 2023 16:39:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1694450373;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=OU+QyGjgfWGBfL0VNwRFlLd/VOUIlp4JzCR1Lv4mdM8=;
	b=Mul5ncV+9UsrkUuL2yBLX+V4HQ0Z1fatDzyKzSVhrX7IOCUKUtnEKzpeSd2gi6QXHML2Zn
	CAxfsKMYncOzvj+KO1lJMYaJvkETQZRHSSNNQINMoQjD+PhOk6eOcxckBH5jimHsTIp+vH
	/HtO6+j32dXJrzvlMPtJtP1kjj0TSL0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-85-pzkhRBe2MeeKuhiR5-ZLlw-1; Mon, 11 Sep 2023 12:39:29 -0400
X-MC-Unique: pzkhRBe2MeeKuhiR5-ZLlw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 48EBB945E6D;
	Mon, 11 Sep 2023 16:39:23 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 311E540C200D;
	Mon, 11 Sep 2023 16:39:23 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 2237719465B8;
	Mon, 11 Sep 2023 16:39:23 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 05E1819465A8
 for <dm-devel@listman.corp.redhat.com>; Mon, 11 Sep 2023 16:39:21 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id DCAED40C200A; Mon, 11 Sep 2023 16:39:20 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id D540440C200D
 for <dm-devel@redhat.com>; Mon, 11 Sep 2023 16:39:20 +0000 (UTC)
Received: from us-smtp-inbound-delivery-1.mimecast.com
 (us-smtp-delivery-1.mimecast.com [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AA3A2928B8A
 for <dm-devel@redhat.com>; Mon, 11 Sep 2023 16:39:20 +0000 (UTC)
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-473-UlfD15EyOjaF9bLWM5nbWw-1; Mon,
 11 Sep 2023 12:39:17 -0400
X-MC-Unique: UlfD15EyOjaF9bLWM5nbWw-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out1.suse.de (Postfix) with ESMTPS id CF6C021863;
 Mon, 11 Sep 2023 16:39:15 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id A0921139CC;
 Mon, 11 Sep 2023 16:39:15 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap2.suse-dmz.suse.de with ESMTPSA id cGuLJbNC/2RzEAAAMHmgww
 (envelope-from <mwilck@suse.com>); Mon, 11 Sep 2023 16:39:15 +0000
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
 Benjamin Marzinski <bmarzins@redhat.com>
Date: Mon, 11 Sep 2023 18:38:14 +0200
Message-ID: <20230911163846.27197-6-mwilck@suse.com>
In-Reply-To: <20230911163846.27197-1-mwilck@suse.com>
References: <20230911163846.27197-1-mwilck@suse.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
Subject: [dm-devel] [PATCH v2 05/37] libmultipath: lookup_binding: add
 comment about the algorithm
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: suse.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Martin Wilck <mwilck@suse.com>

When I read this code, I always get confused. Adding comments to
explain the algorithm.

Signed-off-by: Martin Wilck <mwilck@suse.com>
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/alias.c | 35 +++++++++++++++++++++++++++++++++++
 1 file changed, 35 insertions(+)

diff --git a/libmultipath/alias.c b/libmultipath/alias.c
index b5248f2..b95cbbe 100644
--- a/libmultipath/alias.c
+++ b/libmultipath/alias.c
@@ -172,6 +172,41 @@ lookup_binding(FILE *f, const char *map_wwid, char **map_alias,
 		alias = strtok_r(buf, " \t", &saveptr);
 		if (!alias) /* blank line */
 			continue;
+
+		/*
+		 * Find an unused index - explanation of the algorithm
+		 *
+		 * ID: 1 = mpatha, 2 = mpathb, ...
+		 *
+		 * We assume the bindings are unsorted. The only constraint
+		 * is that no ID occurs more than once. IDs that occur in the
+		 * bindings are called "used".
+		 *
+		 * We call the list 1,2,3,..., exactly in this order, the list
+		 * of "expected" IDs. The variable "id" always holds the next
+		 * "expected" ID, IOW the last "expected" ID encountered plus 1.
+		 * Thus all IDs below "id" are known to be used. However, at the
+		 * end of the loop, the value of "id" isn't necessarily unused.
+		 *
+		 * "smallest_bigger_id" is the smallest used ID that was
+		 * encountered while it was larger than the next "expected" ID
+		 * at that iteration. Let X be some used ID. If all IDs below X
+		 * are used and encountered in the right sequence before X, "id"
+		 * will be > X when the loop ends. Otherwise, X was encountered
+		 * "out of order", the condition (X > id) holds when X is
+		 * encountered, and "smallest_bigger_id" will be set to X; i.e.
+		 * it will be less or equal than X when the loop ends.
+		 *
+		 * At the end of the loop, (id < smallest_bigger_id) means that
+		 * the value of "id" had been encountered neither in order nor
+		 * out of order, and is thus unused. (id >= smallest_bigger_id)
+		 * means that "id"'s value is in use. In this case, we play safe
+		 * and use "biggest_id + 1" as the next value to try.
+		 *
+		 * biggest_id is always > smallest_bigger_id, except in the
+		 * "perfectly ordered" case.
+		 */
+
 		curr_id = scan_devname(alias, prefix);
 		if (curr_id == id) {
 			if (id < INT_MAX)
-- 
2.42.0

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

