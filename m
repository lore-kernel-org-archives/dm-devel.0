Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9721C44393
	for <dm-devel@lists.linux.dev>; Thu, 30 May 2024 16:55:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717088107; cv=none; b=aBetu0tAxCprZJgnmyY5YYxeGcVrSzLyQVx5NSjU56FC71ch2yhb04fn1nN1O+F1agPMmEa0TkpLX898LvUEaRKkwpLDrcuVwZHgk39yKbi8qDu3QzKb+LriDjh9AWfXxVSwQH7AcZuQmuV2BhAeeDeyUuvvt0bzod7+koP+gyc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717088107; c=relaxed/simple;
	bh=LURPUF2Z5TZRdCUVfcF1hw9NuRGf6L4qV+hb+p0wV7E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lRbmdUu/J4b4wwSuGgA1A0WMKQvNjDM1J+kOj2vhKOl37JofGLZaSjwlCoeqbzJojutSvVOCH/77j7E95yFqreeNcro7PKuvZPCBt1U+kb5DESUl6vpmgdwftllN+iTLqpN4bZdBPmujV8RwGjASaNg5LxUv+tSkD8lKAzrIJCg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=MrOcOHMy; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MrOcOHMy"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1717088104;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xmZ41vxVifDU+JfQKqrcHNS0nV/QryfMIDYtY/loE5E=;
	b=MrOcOHMygbjIsjSeGLU//8NO6AhKFTurKGmmKDevUxJpP0xX7Xzj4nXa8blBXEbHAE5Qc5
	nk/t0zEsryWx+hKntoAelqAqzJyvRZBjwTmMA7pCI02qCEkPjDrTBsbeiRGs/0MYOL3fUA
	/L4KwKEiPhiNxw5JH2Ouo823w6TLpWg=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-80-Gt_S5nAgMBeXDs9u_fGWfQ-1; Thu,
 30 May 2024 12:55:02 -0400
X-MC-Unique: Gt_S5nAgMBeXDs9u_fGWfQ-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 97B463806701;
	Thu, 30 May 2024 16:55:02 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 8BDE1492BC6;
	Thu, 30 May 2024 16:55:02 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 44UGt2Dn397041
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 30 May 2024 12:55:02 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 44UGt2Pg397040;
	Thu, 30 May 2024 12:55:02 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>,
        Nitin Yewale <nyewale@redhat.com>, Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 4/7] multipathd: Stop double counting map failures for no_path_retry > 0
Date: Thu, 30 May 2024 12:54:57 -0400
Message-ID: <20240530165500.397009-5-bmarzins@redhat.com>
In-Reply-To: <20240530165500.397009-1-bmarzins@redhat.com>
References: <20240530165500.397009-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.9
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

If no_path_retry was greater than 0, multipathd was counting a map
failure when recovery mode was entered, and again when queueing was
disabled. The first one is incorrect, since the map is still queueing.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
Reviewed-by: Martin Wilck <mwilck@suse.com>
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

