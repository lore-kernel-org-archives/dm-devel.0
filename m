Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6EC985274
	for <dm-devel@lists.linux.dev>; Tue, 23 Apr 2024 22:25:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713911143; cv=none; b=k3dpZoVdJi2KOkE+FgMJ52lk2A92xyxrfKAuEO6yGmMt1jFKjHo7zNGdHqLHltR46nMLg+reciQ8Pl7lNcLFQy/IOMlymj6fuxQFCcmtbvpuov1Ao1Aj92neniVb1aE6oFkNEHGGqh0lfCA40JmxHtktOXyqqTUoTD2M/bdl6Sw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713911143; c=relaxed/simple;
	bh=LEM2P3Gy9sbOH7sGBR9RBtqUuGJTDU9t61PXaKYyyr8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mvn7aB4TfigCpgDqX+xCdT/2epFuYcyniTKMuILFAmZdpGz9SMjmJXih9YKpAak1IpyIJxWLgU34QzJjJKd0HW/Obc5a3kzAnakYTROa8o4h6xOeve4H0bDb9/0kKbZ756qNAOdtCZKq6xruyCYnyz0Tafe+NICcJlh49/BOREU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hkx1FGJM; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hkx1FGJM"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1713911140;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zRZp4aK3yfGPQkDESZ+o/oP//YySG6vMO3/JGJQ81QM=;
	b=hkx1FGJMFNGYRU1iFopqQetJVW6SDqQBS2haXU3SI5AkSZCkWF5Uz6SorDuvcVyugW9HEO
	34ssOXR9xc/I5zydQHAXMO9So7iEq6hl4VLtSLUW/p0SXFaUNQPsAmQaMpeW95JZbziMRa
	3KRnaccQalUHkhU5kX4VR5qlaZtkpJw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-621-_OTTlhkqNZGkzKQVhKJ4Dg-1; Tue, 23 Apr 2024 18:25:37 -0400
X-MC-Unique: _OTTlhkqNZGkzKQVhKJ4Dg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 102D2811001;
	Tue, 23 Apr 2024 22:25:37 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 035FA49102;
	Tue, 23 Apr 2024 22:25:36 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.1/8.17.1) with ESMTPS id 43NMPabS2096502
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 23 Apr 2024 18:25:36 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.1/8.17.1/Submit) id 43NMPagj2096501;
	Tue, 23 Apr 2024 18:25:36 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH 1/3] libmultipath: export partmap_in_use and do_deferred
Date: Tue, 23 Apr 2024 18:25:34 -0400
Message-ID: <20240423222536.2096486-2-bmarzins@redhat.com>
In-Reply-To: <20240423222536.2096486-1-bmarzins@redhat.com>
References: <20240423222536.2096486-1-bmarzins@redhat.com>
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

A future commit will make use of these functions

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/devmapper.c          | 4 +---
 libmultipath/devmapper.h          | 3 +++
 libmultipath/libmultipath.version | 1 +
 3 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
index 4ce7e82f..24d03e83 100644
--- a/libmultipath/devmapper.c
+++ b/libmultipath/devmapper.c
@@ -386,8 +386,6 @@ libmp_dm_task_create(int task)
 	return dm_task_create(task);
 }
 
-#define do_deferred(x) ((x) == DEFERRED_REMOVE_ON || (x) == DEFERRED_REMOVE_IN_PROGRESS)
-
 static int
 dm_simplecmd (int task, const char *name, int no_flush, int need_sync,
 	      uint16_t udev_flags, int deferred_remove __DR_UNUSED__) {
@@ -1043,7 +1041,7 @@ has_partmap(const char *name __attribute__((unused)),
 	return 1;
 }
 
-static int
+int
 partmap_in_use(const char *name, void *data)
 {
 	int part_count, *ret_count = (int *)data;
diff --git a/libmultipath/devmapper.h b/libmultipath/devmapper.h
index a7d66604..2987a1b5 100644
--- a/libmultipath/devmapper.h
+++ b/libmultipath/devmapper.h
@@ -57,6 +57,9 @@ enum {
 	DM_FLUSH_BUSY,
 };
 
+#define do_deferred(x) ((x) == DEFERRED_REMOVE_ON || (x) == DEFERRED_REMOVE_IN_PROGRESS)
+
+int partmap_in_use(const char *name, void *data);
 int _dm_flush_map (const char *, int, int, int, int);
 int dm_flush_map_nopaths(const char * mapname, int deferred_remove);
 #define dm_flush_map(mapname) _dm_flush_map(mapname, 1, 0, 0, 0)
diff --git a/libmultipath/libmultipath.version b/libmultipath/libmultipath.version
index 724786d5..e070f296 100644
--- a/libmultipath/libmultipath.version
+++ b/libmultipath/libmultipath.version
@@ -141,6 +141,7 @@ global:
 	need_io_err_check;
 	orphan_path;
 	parse_prkey_flags;
+	partmap_in_use;
 	pathcount;
 	path_discovery;
 	path_get_tpgs;
-- 
2.43.0

