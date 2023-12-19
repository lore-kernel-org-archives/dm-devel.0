Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2F32405D3
	for <dm-devel@lists.linux.dev>; Tue, 19 Dec 2023 23:52:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="eUCdkkd6"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1703029940;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=GqhA9X76eFuF3/V/YOIbhI/HghnWuG9YwQtvXYPFAzw=;
	b=eUCdkkd6wpLYDoX6hNsaACqHlpksg2Z+9YDvJbGFpBQdjE2+85VXVGO7gTXk712RU6HSHi
	svqV1zYMA/sGTvgjy6izuPcYzbo/wldWT/gVLgoe9jVQ85iHN9hFQy35c7z96G5BOGjfGI
	R4q1JoLVicWC569EPuiZDly3INIYB4I=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-619-2XTFsoEKNOqPI2KUuSi5rw-1; Tue, 19 Dec 2023 18:52:19 -0500
X-MC-Unique: 2XTFsoEKNOqPI2KUuSi5rw-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3113B803915;
	Tue, 19 Dec 2023 23:52:19 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.12])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 289E3492BE6;
	Tue, 19 Dec 2023 23:52:19 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.1/8.17.1) with ESMTPS id 3BJNqIuA788082
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 19 Dec 2023 18:52:19 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.1/8.17.1/Submit) id 3BJNqISH788081;
	Tue, 19 Dec 2023 18:52:18 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH] multipath-tools tests: fix dmevents test after update_multipath change
Date: Tue, 19 Dec 2023 18:52:18 -0500
Message-ID: <20231219235218.788073-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.10
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

The commit ("multipathd: don't modify the multipath device on show
commands") changed the paramters for update_multipath(). Update the
test to match.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 tests/dmevents.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/tests/dmevents.c b/tests/dmevents.c
index 68c4ad46..f08e6499 100644
--- a/tests/dmevents.c
+++ b/tests/dmevents.c
@@ -332,13 +332,12 @@ void __wrap_remove_map_by_alias(const char *alias, struct vectors * vecs)
 /* pretend update the pretend dm devices. If fail is set, it
  * simulates having the dm device removed. Otherwise it just sets
  * update_nr to record when the update happened */
-int __wrap_update_multipath(struct vectors *vecs, char *mapname, int reset)
+int __wrap_update_multipath(struct vectors *vecs, char *mapname)
 {
 	int fail;
 
 	check_expected(mapname);
 	assert_ptr_equal(vecs, waiter->vecs);
-	assert_int_equal(reset, 1);
 	fail = mock_type(int);
 	if (fail) {
 		assert_int_equal(remove_dm_device_event(mapname), 0);
-- 
2.41.0

