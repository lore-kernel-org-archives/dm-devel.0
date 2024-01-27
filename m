Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3853FB664
	for <dm-devel@lists.linux.dev>; Sat, 27 Jan 2024 02:35:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706322955; cv=none; b=J31smxH2IC1OBwRnmviHJu5gZYD0JjB2qgC34ZylvdS+hIv4GSOAfnaaeD+Rc1jiOEPC0HEc+biz48HCLlZ6qiCk4bmArHxeE2XDECXMG3H3vaHWrm8YFZG0kyCaqCHpq/3mRvpoUmihFsZf97M94DILbgH0Itul3QcLNtbFD/0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706322955; c=relaxed/simple;
	bh=KaoRTRL5C6livYGuEfVDIBJkVrkspJon714E3ykOBOY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=c2xZUksNfoz0hFk+Q1wcfen9wRyMzb6POQOcHd+FeWbgmQ67PpdjZVpyPCuifSpuft6Qp32qQxjphObY9LsemgiPxKln7yh+rf+GI/M/NKkkg8G4MselGm+9ZtJrEgtkr48MftCkmSj7MTkfB+Vw/4OzIFgiqFThT4BOcuY3Y5Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=H09HM9M1; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="H09HM9M1"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1706322953;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8oo3PRljewoyVY8oguPkv3E6tkhMZMTMVQ4p8SMLD9g=;
	b=H09HM9M1XiX6U08BcNhxBe4/4RlRcAMhzZyGI4nkUzlgh4vHFZ1PR1YXb/4c58JI3gQSnQ
	d4BRUQIJlCspdNv21AjSaKMe8/9IiC/lLPwxW/jud6f/OnWV0zJN1/Yr4YXVAGrqNGBrI0
	bmg9b45YeGQ8cj5srlY8GjyHA/Ivcfc=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-232-Vjn1-xG6P8CH4mwqAsMr2Q-1; Fri,
 26 Jan 2024 21:35:49 -0500
X-MC-Unique: Vjn1-xG6P8CH4mwqAsMr2Q-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5EC463806282;
	Sat, 27 Jan 2024 02:35:49 +0000 (UTC)
Received: from vdo-builder-msakai.permabit.com (vdo-builder-msakai.permabit.lab.eng.bos.redhat.com [10.0.103.170])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 596235012;
	Sat, 27 Jan 2024 02:35:49 +0000 (UTC)
Received: by vdo-builder-msakai.permabit.com (Postfix, from userid 1138)
	id 53B9F560C3; Fri, 26 Jan 2024 21:35:49 -0500 (EST)
From: Matthew Sakai <msakai@redhat.com>
To: dm-devel@lists.linux.dev
Cc: Mike Snitzer <snitzer@kernel.org>,
	Matthew Sakai <msakai@redhat.com>
Subject: [PATCH 2/5] dm vdo block-map: use uds_log_ratelimit() rather than open code it
Date: Fri, 26 Jan 2024 21:35:46 -0500
Message-ID: <96709a3b8f228f826897fd9b5d0ce4c3c0dcb058.1706322049.git.msakai@redhat.com>
In-Reply-To: <cover.1706322049.git.msakai@redhat.com>
References: <cover.1706322049.git.msakai@redhat.com>
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

From: Mike Snitzer <snitzer@kernel.org>

Signed-off-by: Mike Snitzer <snitzer@kernel.org>
Signed-off-by: Matthew Sakai <msakai@redhat.com>
---
 drivers/md/dm-vdo/block-map.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/drivers/md/dm-vdo/block-map.c b/drivers/md/dm-vdo/block-map.c
index 64f893b0721a..eb838e6ae3e6 100644
--- a/drivers/md/dm-vdo/block-map.c
+++ b/drivers/md/dm-vdo/block-map.c
@@ -1014,13 +1014,9 @@ static void handle_page_write_error(struct vdo_completion *completion)
 
 	/* If we're already read-only, write failures are to be expected. */
 	if (result != VDO_READ_ONLY) {
-		static DEFINE_RATELIMIT_STATE(error_limiter, DEFAULT_RATELIMIT_INTERVAL,
-					      DEFAULT_RATELIMIT_BURST);
-
-		if (__ratelimit(&error_limiter)) {
-			uds_log_error("failed to write block map page %llu",
-				      (unsigned long long) info->pbn);
-		}
+		uds_log_ratelimit(uds_log_error,
+				  "failed to write block map page %llu",
+				  (unsigned long long) info->pbn);
 	}
 
 	set_info_state(info, PS_DIRTY);
-- 
2.42.0

