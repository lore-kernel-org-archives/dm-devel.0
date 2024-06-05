Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6C83171E43
	for <dm-devel@lists.linux.dev>; Wed,  5 Jun 2024 23:22:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717629781; cv=none; b=iAVgNbfRV4hDmtvtML5fhJByNWOcK2A/aLlxr8XQNqGUlqw/LASKYaCSloGu+Vz3kyWds2hGDolWgCOv2FjzMQoJSYOwFkoqZze0RiTpPjyZz+aHOf43CX3KkFCMQTQ0gyvjllHeUphSWNnLZ/6UrRKy9tLgoGxwPTBIzEiMESc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717629781; c=relaxed/simple;
	bh=jQnCF+Z+SL2tf1TU075Ng399i5CObCCSFMeAeNWck1U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bBlzBxvh0+jzWh1kMlhpCz3BWtD1bGHlJzjvTJD/cWV05/gTo15Mo3wjPn+gstEeW91mWPZM882hC2UJ5J/wIo1ezNVBWZ9Vs7IRHKDoSh5uW5U5nbJZa1L15ojQxzsKP4uf2sMUE6kDqwNS1GKkxiB+4jGgi7LsZT61M2y0seU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=blVipifK; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="blVipifK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1717629778;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NnFJHLzai1GVEFzd2YO3e6xB3RSdXs80S1qUUojzYqw=;
	b=blVipifKpiBChyOfo7B68hlwqq5M+boKSegkF5Z2b+X78kNOegJ4Frsi6PgSmVZd6umtIb
	ga3V4K3n9n6V8FQaZOb266Qyr24NQrlfHlemO1/vyy8AnmzscLEXesCg2/0GfWPpm6pkf/
	wKzqFqf64uwO/EZk0y2M0bQT6vXQ+WY=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-111-OEes_HweOKOQuPhTqyFMPA-1; Wed,
 05 Jun 2024 19:22:55 -0400
X-MC-Unique: OEes_HweOKOQuPhTqyFMPA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3C63329AA387;
	Wed,  5 Jun 2024 23:22:55 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 24DEBFFCF;
	Wed,  5 Jun 2024 23:22:55 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 455NMs5b623310
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 5 Jun 2024 19:22:54 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 455NMs9N623309;
	Wed, 5 Jun 2024 19:22:54 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH 1/7] multipathd: fix flush check in flush_map()
Date: Wed,  5 Jun 2024 19:22:48 -0400
Message-ID: <20240605232254.623290-2-bmarzins@redhat.com>
In-Reply-To: <20240605232254.623290-1-bmarzins@redhat.com>
References: <20240605232254.623290-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.5
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

Forgot the comparison in the "if" statement.

Fixes 8a3898339 ("multipathd: sync features on flush_map failure corner case")

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 multipathd/main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index 09286dd0..58afe14a 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -813,7 +813,7 @@ flush_map(struct multipath * mpp, struct vectors * vecs)
 {
 	int r = dm_suspend_and_flush_map(mpp->alias, 0);
 	if (r != DM_FLUSH_OK) {
-		if (DM_FLUSH_FAIL_CANT_RESTORE)
+		if (r == DM_FLUSH_FAIL_CANT_RESTORE)
 			remove_feature(&mpp->features, "queue_if_no_path");
 		condlog(0, "%s: can't flush", mpp->alias);
 		return r;
-- 
2.45.0

