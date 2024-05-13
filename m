Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D91221342
	for <dm-devel@lists.linux.dev>; Mon, 13 May 2024 17:36:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715621812; cv=none; b=Dj9SMh+K/UZUgOmnD4yDnj96gsdQS4FhZYKWVj9FBkhVbn+42hzim100leW3f/9sYavFYofS2jVd2XzOIy+/fNA6s3gwufNr3R+WNIRl6NUQ+ICdy/brTxTlkoDgOMOIy512ckzEIDNtPOKrmsU2p0lLTzl3RC+BAdSVUxageLA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715621812; c=relaxed/simple;
	bh=XPOyhLpdzjfBjWMJQC++bWMFGB02RkWZmoU0GhkPD2U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dcLp+s/es6kefqYWkToeYG24tR7lfONgM6OdHY4PwlhfQBMfXoyFKQVlSOh65eEODhwq1hwHkscXO5P56LToxWObMDce+l85zdDoYABKet7sx7mUMYwEUOJjuKh0c7uCS8BLGs884vLo06RUrus2ev4zFO/C9lHxReBu0T69R7A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=aipRt1MI; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="aipRt1MI"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1715621809;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5g7QJUMR1aKf71DwzBEMztPeWjUFXk7V/omvaIndiUU=;
	b=aipRt1MI4zTb8xMszVEd7QZ2QaaRlpie12E4sgPKA9uAcAajWTHhmmlQaAnMKWFgokhJ+s
	9snN8oW5hKkYAmjIfSxaSF2qmM5w71Nss6UjpuodVTj7uXTOH+46LG2X/9BFKt6KB0Qyd+
	RJadxID7qFwynAR1egEJmWd8IT/zzkk=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-533-vfIP7DdiOGGspMNPMy8hUw-1; Mon,
 13 May 2024 13:36:48 -0400
X-MC-Unique: vfIP7DdiOGGspMNPMy8hUw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C41873C0009C;
	Mon, 13 May 2024 17:36:47 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id BE478562D;
	Mon, 13 May 2024 17:36:47 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 44DHallH094456
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 13 May 2024 13:36:47 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 44DHalEj094455;
	Mon, 13 May 2024 13:36:47 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>,
        Nitin Yewale <nyewale@redhat.com>
Subject: [PATCH 4/7] multipathd: Stop double counting map failures for no_path_retry > 0
Date: Mon, 13 May 2024 13:36:43 -0400
Message-ID: <20240513173646.94424-5-bmarzins@redhat.com>
In-Reply-To: <20240513173646.94424-1-bmarzins@redhat.com>
References: <20240513173646.94424-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

If no_path_retry was greater than 0, multipathd was counting a map
failure when recovery mode was entered, and again when queueing was
disabled. The first one is incorrect, since the map is still queueing.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/structs_vec.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/libmultipath/structs_vec.c b/libmultipath/structs_vec.c
index c0c5cc90..ccc4efc7 100644
--- a/libmultipath/structs_vec.c
+++ b/libmultipath/structs_vec.c
@@ -844,10 +844,13 @@ int verify_paths(struct multipath *mpp)
 void update_queue_mode_del_path(struct multipath *mpp)
 {
 	int active = count_active_paths(mpp);
+	bool is_queueing = mpp->features &&
+			   strstr(mpp->features, "queue_if_no_path");
 
 	if (active == 0) {
 		enter_recovery_mode(mpp);
-		if (mpp->no_path_retry != NO_PATH_RETRY_QUEUE)
+		if (mpp->no_path_retry == NO_PATH_RETRY_FAIL ||
+		    (mpp->no_path_retry == NO_PATH_RETRY_UNDEF && !is_queueing))
 			mpp->stat_map_failures++;
 	}
 	condlog(2, "%s: remaining active paths: %d", mpp->alias, active);
-- 
2.45.0

