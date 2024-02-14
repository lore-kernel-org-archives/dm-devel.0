Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2438810958
	for <dm-devel@lists.linux.dev>; Wed, 14 Feb 2024 04:57:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707886636; cv=none; b=p6PtNeEV4d0O8ZIhX+UNIaX5obOgnzPKsNbOmC2xjEsy0cP513maCbCX2H6uDkaOP7kj4zKca4ObQu3BT8F4nfRsA0UHkjfl3C2iuCSyk8YiPo8t1aOpVPBZuowjOeMWJ+B9VfI7GE2KiMKz7p9IPMsDUE/WO6ExOMXVZLUG2AA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707886636; c=relaxed/simple;
	bh=Wl6XWM8P3lW1NwPHbHNKAwpCL7wxBbOn1nhWpXruuYw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BzODLK8Lao4QwVDvb5nNZK/xOKKC3yfJvN13KV2tBUxRXMMXeB47BJph7gZnbt5b7k1ob5mixhyxnCMTwwNiimNgwsL9uNCeqkBWEOk7LSrdS1HWih9vBBroOyL0SdR9RWPE94dPpTn75Q8gaszt48DoAytIX0FD/EFrHSX3wyg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PMELEvPD; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PMELEvPD"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1707886634;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OevC/Iuddsz7FabDz2bWGBBdg+opq61klCH41zbELP0=;
	b=PMELEvPDT6I7RC1X79eZH88f4YhgOy6s/ew89KLRVYI2vJGTMH3ypnoyU0hC1h5QekLSVd
	OlHTBRnDl090GYw7i2+Ii5h+VvZ7cwsUjHFL2Lrfcui0/gASUSN+z/nXLAKabFJ3T1qoza
	0U366OpIoGm6EIWCjONadS0hF5gRU9c=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-66-jHibGZHcMF20UVBLKfZnzQ-1; Tue, 13 Feb 2024 23:57:12 -0500
X-MC-Unique: jHibGZHcMF20UVBLKfZnzQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5D7F3828CE2;
	Wed, 14 Feb 2024 04:57:12 +0000 (UTC)
Received: from vdo-builder-msakai.permabit.com (vdo-builder-msakai.permabit.lab.eng.bos.redhat.com [10.0.103.170])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 58AC02166B4F;
	Wed, 14 Feb 2024 04:57:12 +0000 (UTC)
Received: by vdo-builder-msakai.permabit.com (Postfix, from userid 1138)
	id 575B8576C0; Tue, 13 Feb 2024 23:57:12 -0500 (EST)
From: Matthew Sakai <msakai@redhat.com>
To: dm-devel@lists.linux.dev
Cc: Mike Snitzer <snitzer@kernel.org>,
	Matthew Sakai <msakai@redhat.com>
Subject: [PATCH 4/5] dm vdo chapter_index: fix a few small nits
Date: Tue, 13 Feb 2024 23:57:11 -0500
Message-ID: <70cbd54d6bdd58a734b9765a2f2ed8bd11e1ada3.1707886374.git.msakai@redhat.com>
In-Reply-To: <cover.1707886374.git.msakai@redhat.com>
References: <cover.1707886374.git.msakai@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.6
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

From: Mike Snitzer <snitzer@kernel.org>

Add missing braces and raise one function arg up a line to eliminate
line wrap.

Signed-off-by: Mike Snitzer <snitzer@kernel.org>
Signed-off-by: Susan LeGendre-McGhee <slegendr@redhat.com>
Signed-off-by: Matthew Sakai <msakai@redhat.com>
---
 drivers/md/dm-vdo/chapter-index.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/md/dm-vdo/chapter-index.c b/drivers/md/dm-vdo/chapter-index.c
index 7285a842e888..363991d56218 100644
--- a/drivers/md/dm-vdo/chapter-index.c
+++ b/drivers/md/dm-vdo/chapter-index.c
@@ -19,8 +19,7 @@ int uds_make_open_chapter_index(struct open_chapter_index **chapter_index,
 	size_t memory_size;
 	struct open_chapter_index *index;
 
-	result = uds_allocate(1, struct open_chapter_index, "open chapter index",
-			      &index);
+	result = uds_allocate(1, struct open_chapter_index, "open chapter index", &index);
 	if (result != UDS_SUCCESS)
 		return result;
 
@@ -197,9 +196,10 @@ int uds_pack_open_chapter_index_page(struct open_chapter_index *chapter_index,
 		} while (!entry.at_end);
 	}
 
-	if (removals > 0)
+	if (removals > 0) {
 		uds_log_warning("To avoid chapter index page overflow in chapter %llu, %u entries were removed from the chapter index",
 				(unsigned long long) chapter_number, removals);
+	}
 
 	return UDS_SUCCESS;
 }
@@ -249,13 +249,14 @@ int uds_validate_chapter_index_page(const struct delta_index_page *index_page,
 
 			/* Also make sure that the record page field contains a plausible value. */
 			if (uds_get_delta_entry_value(&entry) >=
-			    geometry->record_pages_per_chapter)
+			    geometry->record_pages_per_chapter) {
 				/*
 				 * Do not log this as an error. It happens in normal operation when
 				 * we are doing a rebuild but haven't written the entire volume
 				 * once.
 				 */
 				return UDS_CORRUPT_DATA;
+			}
 		}
 	}
 	return UDS_SUCCESS;
-- 
2.42.0

