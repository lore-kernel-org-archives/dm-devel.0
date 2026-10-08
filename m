Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4134336B932
	for <dm-devel@lists.linux.dev>; Thu,  8 Oct 2026 20:28:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791491301; cv=none; b=L/TVs85Gu0cOVULzifaOdoMbX6QHAcWs5p9zf1FzBfm6MA1RGpgEhR9mg+UC06Qu1SzKPkqDFVfMeUeSYX+e/xUfnSgDFQnNX1YzXzN4O7Q3jCh8LpdRCJrnn1mtyODWHPuMH9slpmgd8SQ4G9l5FVX2VcdCfYW+YvprqHP+/GI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791491301; c=relaxed/simple;
	bh=YYssrwDV9R6sIxuaMiNfMGQJtK1a//rny4D9udmTozw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=snjlq0W8jZUrp96ozX9lSSywIoKd+pwPSE3QX4OViEO7Ux9QZBqBQbBCFS7NP1nldbW2iykR+ThfR+5nLvcT49NOxCLNJ8Zdnx+HATKqz2wmVvO1AoG8mNNfmLFUHb/cuDa5JUKxNqgwYZhE8OSt6892CrcQb/o11aeRiDedUEk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=QS5M/YcL; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QS5M/YcL"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1791491299;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dnQdJ8ObnHEOrCfH3bjC4mmYFQflYMN0iOGR6GxyMos=;
	b=QS5M/YcLDuoVKxSMdXBPRpDs3KBx4VIVx/wZwACPfU9RZBRYnM9QSYJRen/2BcnUDuSzPb
	a7v5kP/LHv0IDpStslwfTogbl2olFA98AlSpPOZv18ErUbMfSnrqTiiYA9FTeb7ErDpWpu
	1WINWyzg6bzAtVvAcwFDWYb2/ooZ74c=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-633-tJ1P0Zn5Pd-6iDphu36Y5w-1; Thu,
 08 Oct 2026 16:28:15 -0400
X-MC-Unique: tJ1P0Zn5Pd-6iDphu36Y5w-1
X-Mimecast-MFC-AGG-ID: tJ1P0Zn5Pd-6iDphu36Y5w_1791491295
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B89FE180AAB5;
	Thu,  8 Oct 2026 20:28:14 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 502D71956041;
	Thu,  8 Oct 2026 20:28:14 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 698KSDq41976827
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 8 Oct 2026 16:28:13 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 698KSDSw1976826;
	Thu, 8 Oct 2026 16:28:13 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Mikulas Patocka <mpatocka@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
        Alasdair Kergon <agk@redhat.com>
Cc: dm-devel@lists.linux.dev
Subject: [PATCH 2/3] dm-mpath: standardize repeat_count handling in the HST path selector
Date: Thu,  8 Oct 2026 16:28:08 -0400
Message-ID: <20261008202809.1976567-3-bmarzins@redhat.com>
In-Reply-To: <20261008202809.1976567-1-bmarzins@redhat.com>
References: <20261008202809.1976567-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: tVJOGiybNwOcbBp71MZzXiD0kCROhWFiqEyqc9jhKBc_1791491295
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

The Historical Service Time path selector ignores the repeat_count
argument just like all the other path selectors. But all of the other
path_selectors explicitly print a warning message when the repeat_count
is set greater than 1. Also, all of the other selectors print 1 for the
repeat_count when printing the table. Standardize the HST path selector
to match.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 drivers/md/dm-ps-historical-service-time.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm-ps-historical-service-time.c b/drivers/md/dm-ps-historical-service-time.c
index e6324424d23a..e0103eefe28f 100644
--- a/drivers/md/dm-ps-historical-service-time.c
+++ b/drivers/md/dm-ps-historical-service-time.c
@@ -31,7 +31,7 @@
 
 #define DM_MSG_PREFIX	"multipath historical-service-time"
 #define HST_MIN_IO 1
-#define HST_VERSION "0.1.1"
+#define HST_VERSION "0.2.0"
 
 #define HST_FIXED_SHIFT 10  /* 10 bits of decimal precision */
 #define HST_FIXED_MAX (ULLONG_MAX >> HST_FIXED_SHIFT)
@@ -216,7 +216,7 @@ static int hst_status(struct path_selector *ps, struct dm_path *path,
 			       pi->outstanding, pi->stale_after);
 			break;
 		case STATUSTYPE_TABLE:
-			DMEMIT("0 ");
+			DMEMIT("%u ", pi->repeat_count);
 			break;
 		case STATUSTYPE_IMA:
 			*result = '\0';
@@ -251,6 +251,11 @@ static int hst_add_path(struct path_selector *ps, struct dm_path *path,
 		return -EINVAL;
 	}
 
+	if (repeat_count > 1) {
+		DMWARN_LIMIT("repeat_count > 1 is deprecated, using 1 instead");
+		repeat_count = 1;
+	}
+
 	/* allocate the path */
 	pi = kmalloc_obj(*pi);
 	if (!pi) {
-- 
2.53.0

