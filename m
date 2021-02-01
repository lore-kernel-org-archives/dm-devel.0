Return-Path: <SRS0=uUVj=HD=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39F8EC433DB
	for <dm-devel@archiver.kernel.org>; Mon,  1 Feb 2021 05:11:11 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 71EBB64E2A
	for <dm-devel@archiver.kernel.org>; Mon,  1 Feb 2021 05:11:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 71EBB64E2A
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-8-7EtXBWAsMdGrdDga-aCpWQ-1; Mon, 01 Feb 2021 00:11:06 -0500
X-MC-Unique: 7EtXBWAsMdGrdDga-aCpWQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1D47A18C8C13;
	Mon,  1 Feb 2021 05:11:02 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id E937627C5F;
	Mon,  1 Feb 2021 05:11:01 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id BE2EF1809CA0;
	Mon,  1 Feb 2021 05:11:01 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1115AdOh015712 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 1 Feb 2021 00:10:39 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 7586810031E5; Mon,  1 Feb 2021 05:10:39 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 7171B100321E
	for <dm-devel@redhat.com>; Mon,  1 Feb 2021 05:10:37 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 19B91858285
	for <dm-devel@redhat.com>; Mon,  1 Feb 2021 05:10:37 +0000 (UTC)
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com
	[209.85.210.201]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-254-Fs2oJEE1Mk2aZdEyhp_NyA-1; Mon, 01 Feb 2021 00:10:33 -0500
X-MC-Unique: Fs2oJEE1Mk2aZdEyhp_NyA-1
Received: by mail-pf1-f201.google.com with SMTP id b81so9953257pfb.21
	for <dm-devel@redhat.com>; Sun, 31 Jan 2021 21:10:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
	:references:subject:from:to:cc;
	bh=NtNlB9U7VtjwopCe74zxMMgND8EJvn8gcUKJfUwC+lg=;
	b=SWZ8dwzX6ttrH6rWWQ1qCD0ojXC3OGMci94yNOHZWCekeTQ/wNTaWeZqbj3bXzEany
	WOj/POkbjc5M7vnx1ErQuDxw5nSm+O19ohTT2BCKgx6Q/c5SH/mJMmde2m4ma9sJiqLa
	U1SsMTO98uORxfBeQocu9qhfF9dUDMxuvAMz9BGmSomCUC3Hl5rg9H65r0lckkiJeD9k
	G1E85+pOaAd+HK5asnusrXUy46texnyNpfJRAc55LXNkfdHMt/X5tNvdOjQN8Bc/UgAc
	PyoCEdxHXo+gfvDVkiqw9u3ypUIjbwyQfsyG9UxEqyYMU1JGQdVg+iYxVtwZq7BLRS61
	zYUw==
X-Gm-Message-State: AOAM533o9s1NgBMomc9LrpAas9bCCW2fhFMDf3EBxXpQx93fZlcWnQAH
	79uZg7lTKtpD7axduK+SSgqb4t6Yhj4=
X-Google-Smtp-Source: ABdhPJzxvkME3ikBqhi+gORlLVg6bi/eVzgjmLoiU5TdzRO9PKQxntzZ51tfnubHSQ/3i4ouCx93UQbCWS0=
X-Received: from satyaprateek.c.googlers.com
	([fda3:e722:ac3:10:24:72f4:c0a8:1092])
	(user=satyat job=sendgmr) by 2002:a17:902:ee4b:b029:de:9cd1:35c8 with
	SMTP id
	11-20020a170902ee4bb02900de9cd135c8mr10516445plo.18.1612156231563;
	Sun, 31 Jan 2021 21:10:31 -0800 (PST)
Date: Mon,  1 Feb 2021 05:10:16 +0000
In-Reply-To: <20210201051019.1174983-1-satyat@google.com>
Message-Id: <20210201051019.1174983-3-satyat@google.com>
Mime-Version: 1.0
References: <20210201051019.1174983-1-satyat@google.com>
From: Satya Tangirala <satyat@google.com>
To: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
	dm-devel@redhat.com
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Mimecast-Bulk-Signature: yes
X-Mimecast-Spam-Signature: bulk
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-loop: dm-devel@redhat.com
Cc: Jens Axboe <axboe@kernel.dk>, Satya Tangirala <satyat@google.com>,
	Mike Snitzer <snitzer@redhat.com>, Alasdair Kergon <agk@redhat.com>,
	Eric Biggers <ebiggers@google.com>
Subject: [dm-devel] [PATCH v4 2/5] block: keyslot-manager: Introduce
 functions for device mapper support
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Introduce blk_ksm_update_capabilities() to update the capabilities of
a keyslot manager (ksm) in-place. The pointer to a ksm in a device's
request queue may not be easily replaced, because upper layers like
the filesystem might access it (e.g. for programming keys/checking
capabilities) at the same time the device wants to replace that
request queue's ksm (and free the old ksm's memory). This function
allows the device to update the capabilities of the ksm in its request
queue directly. Devices can safely update the ksm this way without any
synchronization with upper layers *only* if the updated (new) ksm
continues to support all the crypto capabilities that the old ksm did
(see description below for blk_ksm_is_superset() for why this is so).

Also introduce blk_ksm_is_superset() which checks whether one ksm's
capabilities are a (not necessarily strict) superset of another ksm's.
The blk-crypto framework requires that crypto capabilities that were
advertised when a bio was created continue to be supported by the
device until that bio is ended - in practice this probably means that
a device's advertised crypto capabilities can *never* "shrink" (since
there's no synchronization between bio creation and when a device may
want to change its advertised capabilities) - so a previously
advertised crypto capability must always continue to be supported.
This function can be used to check that a new ksm is a valid
replacement for an old ksm.

Signed-off-by: Satya Tangirala <satyat@google.com>
---
 block/keyslot-manager.c         | 107 ++++++++++++++++++++++++++++++++
 include/linux/keyslot-manager.h |   9 +++
 2 files changed, 116 insertions(+)

diff --git a/block/keyslot-manager.c b/block/keyslot-manager.c
index ac7ce83a76e8..9f9494b80148 100644
--- a/block/keyslot-manager.c
+++ b/block/keyslot-manager.c
@@ -424,6 +424,113 @@ void blk_ksm_unregister(struct request_queue *q)
 	q->ksm = NULL;
 }
 
+/**
+ * blk_ksm_intersect_modes() - restrict supported modes by child device
+ * @parent: The keyslot manager for parent device
+ * @child: The keyslot manager for child device, or NULL
+ *
+ * Clear any crypto mode support bits in @parent that aren't set in @child.
+ * If @child is NULL, then all parent bits are cleared.
+ *
+ * Only use this when setting up the keyslot manager for a layered device,
+ * before it's been exposed yet.
+ */
+void blk_ksm_intersect_modes(struct blk_keyslot_manager *parent,
+			     const struct blk_keyslot_manager *child)
+{
+	if (child) {
+		unsigned int i;
+
+		parent->max_dun_bytes_supported =
+			min(parent->max_dun_bytes_supported,
+			    child->max_dun_bytes_supported);
+		for (i = 0; i < ARRAY_SIZE(child->crypto_modes_supported);
+		     i++) {
+			parent->crypto_modes_supported[i] &=
+				child->crypto_modes_supported[i];
+		}
+	} else {
+		parent->max_dun_bytes_supported = 0;
+		memset(parent->crypto_modes_supported, 0,
+		       sizeof(parent->crypto_modes_supported));
+	}
+}
+EXPORT_SYMBOL_GPL(blk_ksm_intersect_modes);
+
+/**
+ * blk_ksm_is_superset() - Check if a KSM supports a superset of crypto modes
+ *			   and DUN bytes that another KSM supports. Here,
+ *			   "superset" refers to the mathematical meaning of the
+ *			   word - i.e. if two KSMs have the *same* capabilities,
+ *			   they *are* considered supersets of each other.
+ * @ksm_superset: The KSM that we want to verify is a superset
+ * @ksm_subset: The KSM that we want to verify is a subset
+ *
+ * Return: True if @ksm_superset supports a superset of the crypto modes and DUN
+ *	   bytes that @ksm_subset supports.
+ */
+bool blk_ksm_is_superset(struct blk_keyslot_manager *ksm_superset,
+			 struct blk_keyslot_manager *ksm_subset)
+{
+	int i;
+
+	if (!ksm_subset)
+		return true;
+
+	if (!ksm_superset)
+		return false;
+
+	for (i = 0; i < ARRAY_SIZE(ksm_superset->crypto_modes_supported); i++) {
+		if (ksm_subset->crypto_modes_supported[i] &
+		    (~ksm_superset->crypto_modes_supported[i])) {
+			return false;
+		}
+	}
+
+	if (ksm_subset->max_dun_bytes_supported >
+	    ksm_superset->max_dun_bytes_supported) {
+		return false;
+	}
+
+	return true;
+}
+EXPORT_SYMBOL_GPL(blk_ksm_is_superset);
+
+/**
+ * blk_ksm_update_capabilities() - Update the restrictions of a KSM to those of
+ *				   another KSM
+ * @target_ksm: The KSM whose restrictions to update.
+ * @reference_ksm: The KSM to whose restrictions this function will update
+ *		   @target_ksm's restrictions to.
+ *
+ * Blk-crypto requires that crypto capabilities that were
+ * advertised when a bio was created continue to be supported by the
+ * device until that bio is ended. This is turn means that a device cannot
+ * shrink its advertised crypto capabilities without any explicit
+ * synchronization with upper layers. So if there's no such explicit
+ * synchronization, @reference_ksm must support all the crypto capabilities that
+ * @target_ksm does
+ * (i.e. we need blk_ksm_is_superset(@reference_ksm, @target_ksm) == true).
+ *
+ * Note also that as long as the crypto capabilities are being expanded, the
+ * order of updates becoming visible is not important because it's alright
+ * for blk-crypto to see stale values - they only cause blk-crypto to
+ * believe that a crypto capability isn't supported when it actually is (which
+ * might result in blk-crypto-fallback being used if available, or the bio being
+ * failed).
+ */
+void blk_ksm_update_capabilities(struct blk_keyslot_manager *target_ksm,
+				 struct blk_keyslot_manager *reference_ksm)
+{
+	memcpy(target_ksm->crypto_modes_supported,
+	       reference_ksm->crypto_modes_supported,
+	       sizeof(target_ksm->crypto_modes_supported));
+
+	target_ksm->max_dun_bytes_supported =
+				reference_ksm->max_dun_bytes_supported;
+}
+EXPORT_SYMBOL_GPL(blk_ksm_update_capabilities);
+
 /**
  * blk_ksm_init_passthrough() - Init a passthrough keyslot manager
  * @ksm: The keyslot manager to init
diff --git a/include/linux/keyslot-manager.h b/include/linux/keyslot-manager.h
index 323e15dd6fa7..164568f52be7 100644
--- a/include/linux/keyslot-manager.h
+++ b/include/linux/keyslot-manager.h
@@ -103,6 +103,15 @@ void blk_ksm_reprogram_all_keys(struct blk_keyslot_manager *ksm);
 
 void blk_ksm_destroy(struct blk_keyslot_manager *ksm);
 
+void blk_ksm_intersect_modes(struct blk_keyslot_manager *parent,
+			     const struct blk_keyslot_manager *child);
+
 void blk_ksm_init_passthrough(struct blk_keyslot_manager *ksm);
 
+bool blk_ksm_is_superset(struct blk_keyslot_manager *ksm_superset,
+			 struct blk_keyslot_manager *ksm_subset);
+
+void blk_ksm_update_capabilities(struct blk_keyslot_manager *target_ksm,
+				 struct blk_keyslot_manager *reference_ksm);
+
 #endif /* __LINUX_KEYSLOT_MANAGER_H */
-- 
2.30.0.365.g02bc693789-goog

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

