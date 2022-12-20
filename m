Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3014FC4167B
	for <dm-devel@archiver.kernel.org>; Tue, 20 Dec 2022 23:41:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1671579698;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=tzqBtAIe5ylq8MobLXPdIQnggjNqQPeXMpxusXeecHA=;
	b=Gzcu5E6ZDkBj9W/DbxKvblwkZLzt4uccNvRAYZH1GF9lMmj8LmDl5xBTAirQFxKe0eHpOF
	ZwT+1lvev+oiYJvI6zLD5wwO2KnNjwnjOgbWF1C6yEugkvatcCFuRh3Chlyi1hnGlnY6EY
	zjg2GiabHfQIj+nEgRd6IXfwCLqnBls=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-437-cMs23T-BMUyZUTY9iWsf-Q-1; Tue, 20 Dec 2022 18:41:34 -0500
X-MC-Unique: cMs23T-BMUyZUTY9iWsf-Q-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5AE2E857A85;
	Tue, 20 Dec 2022 23:41:32 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 6969E40C2004;
	Tue, 20 Dec 2022 23:41:31 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id C508E194704B;
	Tue, 20 Dec 2022 23:41:24 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 28026194704A
 for <dm-devel@listman.corp.redhat.com>; Tue, 20 Dec 2022 23:41:24 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 1A8062166B2B; Tue, 20 Dec 2022 23:41:24 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 06D942166B26;
 Tue, 20 Dec 2022 23:41:23 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
 by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 2BKNfMp9023716;
 Tue, 20 Dec 2022 17:41:22 -0600
Received: (from bmarzins@localhost)
 by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 2BKNfM0R023715;
 Tue, 20 Dec 2022 17:41:22 -0600
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Date: Tue, 20 Dec 2022 17:41:14 -0600
Message-Id: <1671579675-23658-6-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1671579675-23658-1-git-send-email-bmarzins@redhat.com>
References: <1671579675-23658-1-git-send-email-bmarzins@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
Subject: [dm-devel] [PATCH 5/6] libmultipath: skip extra vector work in
 remove_maps
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Instead of repeatedly removing the first vector element, and shifting
the rest to fill in, call remove_map() without a vector, so it just
frees the devices. The vector will be completely cleaned up by
vector_free() immediately afterwards.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/structs_vec.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/libmultipath/structs_vec.c b/libmultipath/structs_vec.c
index 5a618767..f3fdc5a6 100644
--- a/libmultipath/structs_vec.c
+++ b/libmultipath/structs_vec.c
@@ -392,10 +392,8 @@ remove_maps(struct vectors * vecs)
 	if (!vecs)
 		return;
 
-	vector_foreach_slot (vecs->mpvec, mpp, i) {
-		remove_map(mpp, vecs->pathvec, vecs->mpvec);
-		i--;
-	}
+	vector_foreach_slot (vecs->mpvec, mpp, i)
+		remove_map(mpp, vecs->pathvec, NULL);
 
 	vector_free(vecs->mpvec);
 	vecs->mpvec = NULL;
-- 
2.17.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

