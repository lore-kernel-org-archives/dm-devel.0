Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86CC178B63
	for <dm-devel@lists.linux.dev>; Tue, 30 Jan 2024 18:45:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706640345; cv=none; b=dAGKaIELSQ9ZHrABMLMWoQgjNBMpH/3BK9XQlddSOS1n6ZWY5VmEi5KQEAVmC+8be3qOfR/zRa+R5pUycL6hFtxEL8uSMLkgiratEagDVHsRxY5viHTQ1L7EhWjgrB9t7nreV3uQrA1WC6mneGv3Tf0bhgTsJD7OXlXoo583XT4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706640345; c=relaxed/simple;
	bh=Jm4SSw+tWeLjuvr1O8Ixjkw0Cg10NGX4v53EkcllZz8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QdWxwLn2FayEIMAysBG7Ik/yoguQ/3AKgpPNYI2Z2Kph1i3BRmMH5ZUrwF5d8Bayipu5HEDH/Oy6agNhAmhVuM6v93CvLMb1SQnSE2xkE/o7HYQgm+ygipdlTDStIWmv075BYcsBSeHYrfuokAhO8iyjqXhGiEemQmdcGhwuoNY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=VdxFP9xj; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VdxFP9xj"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1706640342;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ZrOcEsCloMNeFWR3uVj4vEOWo6r+Jj3VGAmmqUfRwpM=;
	b=VdxFP9xjdE9UDCmP2wMvO5vP5nwyfqkWqiX8bp4ujM0h13JZ/6i8cwQLgC4q9583nIIhaG
	jy9YoxjYNGGx7A5r4zpHnA2OPpbXeF+EgY4wcphv7kODoSQPzGHPDJXfhLvxTCFnpa9Y35
	1UuL4xY43AX6fdqFcZ1F9+LB7KqvV8g=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-7-rnKO7GS7PniczPp_sT1nDQ-1; Tue,
 30 Jan 2024 13:45:40 -0500
X-MC-Unique: rnKO7GS7PniczPp_sT1nDQ-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C61B53C025B6;
	Tue, 30 Jan 2024 18:45:39 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id C040F492BE4;
	Tue, 30 Jan 2024 18:45:39 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.1/8.17.1) with ESMTPS id 40UIjdDc256960
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 30 Jan 2024 13:45:39 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.1/8.17.1/Submit) id 40UIjdkT256959;
	Tue, 30 Jan 2024 13:45:39 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH 2/2] multipath-tools tests: add void parameter to functions
Date: Tue, 30 Jan 2024 13:45:38 -0500
Message-ID: <20240130184538.256941-3-bmarzins@redhat.com>
In-Reply-To: <20240130184538.256941-1-bmarzins@redhat.com>
References: <20240130184538.256941-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.10
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This allows the tests to be compiled with -Werror=strict-prototypes

Reported-by: Tomasz Kłoczko (github.com/opensvc/multipath-tools/issues/80)
Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 tests/alias.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tests/alias.c b/tests/alias.c
index 93e4b395..c2ae915d 100644
--- a/tests/alias.c
+++ b/tests/alias.c
@@ -1763,7 +1763,7 @@ static void gufa_check_locking(void **state) {
 	assert_int_equal(lock_errors, 0);
 }
 
-static int test_get_user_friendly_alias()
+static int test_get_user_friendly_alias(void)
 {
 	const struct CMUnitTest tests[] = {
 		cmocka_unit_test_teardown(gufa_empty_new_rw, teardown_bindings),
@@ -1981,7 +1981,7 @@ static void order_06(void **state)
 	order_test(ARRAY_SIZE(ra), ra, true);
 }
 
-static int test_bindings_order()
+static int test_bindings_order(void)
 {
 	const struct CMUnitTest tests[] = {
 		cmocka_unit_test_teardown(order_01, teardown_bindings),
-- 
2.43.0

