Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34A0A369208
	for <dm-devel@lists.linux.dev>; Tue, 24 Mar 2026 18:06:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774375617; cv=none; b=nEoYnjTbpGc4KWVxXJe/cf4Ap37dxhZgmXaQ9Yla4+7LzcxP6l1sAdVTHkCH9P7w6QaujSVWTex5PurEfDk7W4UEkD/YflEJX8gs5g3qSzrrFIHVUo90U5FiDQIW3yKhoMP3eBakLrWVHiNv6SWju9Xr91zQZgt4Qsi3pmU2vvE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774375617; c=relaxed/simple;
	bh=YV+mlLWeYMennSF5W747SsAr7g+tOGP73mcRTizptc8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=lTgjuRgj6G4gf7YqHlEqq3/W34g6hNlilsrOCmxu+co/AXhG4pJroE6n+NjdJ1NaO6Zr68gyWC8Wd7GpfuKGLCIa4tJgnd1qEWKxnGr+eJy9ap22WrSJwRWDDWvKt8PPIFQ1fVqzUEDXibRhJfVQJPDD9UDr6dzqkopA7JJsHc0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=SPi8AV0g; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SPi8AV0g"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774375615;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BFiFIgxR0yAp4lwgjhAQ0yhrSrm1rOu6pnGEPuaJvZQ=;
	b=SPi8AV0gNKpR0hxNPOIytcUTPodcTpbAbpYzRMYeI7js+t2tInDnjJPQL/R0wWkemcePrc
	LbH2T5nK2h2Q+wOD9an+P7eUpbWaIRJz3C746ekFGiK/IcI6NLNdqP7oZfMUrUGSbBQIF2
	BaVSA3tEjC6HLfkfGNONfc/x0ipMaJQ=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-481-IldAqc8GM5eWEVxG1jpC9w-1; Tue,
 24 Mar 2026 14:06:53 -0400
X-MC-Unique: IldAqc8GM5eWEVxG1jpC9w-1
X-Mimecast-MFC-AGG-ID: IldAqc8GM5eWEVxG1jpC9w_1774375613
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 04100180035C
	for <dm-devel@lists.linux.dev>; Tue, 24 Mar 2026 18:06:53 +0000 (UTC)
Received: from vdo-builder-bjohnston.permabit.com (unknown [10.0.101.86])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id D92851955E91;
	Tue, 24 Mar 2026 18:06:52 +0000 (UTC)
Received: by vdo-builder-bjohnston.permabit.com (Postfix, from userid 1142)
	id 626A61D63F; Tue, 24 Mar 2026 14:06:52 -0400 (EDT)
From: Bruce Johnston <bjohnsto@redhat.com>
To: dm-devel@lists.linux.dev
Cc: Bruce Johnston <bjohnsto@redhat.com>
Subject: [PATCH 4/9] dm vdo: add upfront validation for logical size
Date: Tue, 24 Mar 2026 14:06:47 -0400
Message-ID: <20260324180652.69439-5-bjohnsto@redhat.com>
In-Reply-To: <20260324180652.69439-1-bjohnsto@redhat.com>
References: <20260324180652.69439-1-bjohnsto@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: suWLbT7Tkk6Iv0Fw1is0uepUf-tVHVID_DI2iQUA9Q4_1774375613
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

Add a validation check that the logical size passed via the table line
does not exceed MAXIMUM_VDO_LOGICAL_BLOCKS.

Signed-off-by: Bruce Johnston <bjohnsto@redhat.com>
---
 drivers/md/dm-vdo/dm-vdo-target.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/md/dm-vdo/dm-vdo-target.c b/drivers/md/dm-vdo/dm-vdo-target.c
index 1065c88a761c..cee6e4edf768 100644
--- a/drivers/md/dm-vdo/dm-vdo-target.c
+++ b/drivers/md/dm-vdo/dm-vdo-target.c
@@ -792,6 +792,12 @@ static int parse_device_config(int argc, char **argv, struct dm_target *ti,
 	struct device_config *config = NULL;
 	int result;
 
+	if (logical_bytes > (MAXIMUM_VDO_LOGICAL_BLOCKS * VDO_BLOCK_SIZE)) {
+		handle_parse_error(config, error_ptr,
+				   "Logical size exceeds the maximum");
+		return VDO_BAD_CONFIGURATION;
+	}
+
 	if ((logical_bytes % VDO_BLOCK_SIZE) != 0) {
 		handle_parse_error(config, error_ptr,
 				   "Logical size must be a multiple of 4096");
-- 
2.52.0

