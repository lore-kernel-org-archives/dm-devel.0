Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D8CF3911CD
	for <dm-devel@lists.linux.dev>; Tue, 12 May 2026 13:39:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778593187; cv=none; b=fjaJCc13jW/be9H4MEVlKSJ7gvUIpdcU2Z6UjhD5sFTdPrN9pUlTf+jtix/Kmam2MlqqempEjvcC+Z6QwRAX7cb03hshDuIC0TSseXxvXEa6ssMd8l4CbGENJlPJZm05GRM7v98WeJikRJRKotBs36X7gysQUGdCUp8J4wYEKhA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778593187; c=relaxed/simple;
	bh=TpMJdqaXxN8hv/mZ1uwhxBBQ14xqBuQDHf08jOtJkME=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=iEt7BTY1HYloRggTbkstaAEfOJ8rr+F0hfLc5TTqhihjieM7LbONlHXtGYaHuH355NXklnuPzcLD3O+MnUdXvUS+4Rvv0ORMq2ORuVp6sON7XdT4fPwqrRtHLWYSxrbQZ/6DaCp0PF9TpErkU6cI+rqtzpmuhcEqGm89Mq6EbwY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=XfjeBHL5; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XfjeBHL5"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1778593183;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=0zp4Qqan6Z62FuqnHBtnTR/jGKZ6YPGqXEHWdKy09JQ=;
	b=XfjeBHL5VfehhPUAk2eSKr9Gh38L6nwcLeLIxPfb2HlmXIXQ/Tq2mAw1feXaFj6kvoVIju
	DTTXcreMKUbznK53mKCp+303+0nqnWkUJ4FWNikfwbhv2bLd+cE8RZyqipR4AcDyIXMzSV
	aVvWLaK6lje5A0SESTOkJA8+9dzaSfw=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-68-2b6dJredNx6kZmZEWYdChw-1; Tue,
 12 May 2026 09:39:39 -0400
X-MC-Unique: 2b6dJredNx6kZmZEWYdChw-1
X-Mimecast-MFC-AGG-ID: 2b6dJredNx6kZmZEWYdChw_1778593178
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5C10818002E0;
	Tue, 12 May 2026 13:39:38 +0000 (UTC)
Received: from [10.44.34.151] (unknown [10.44.34.151])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7896130001BB;
	Tue, 12 May 2026 13:39:36 +0000 (UTC)
Date: Tue, 12 May 2026 15:39:31 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, 
    Benjamin Marzinski <bmarzins@redhat.com>, 
    Bruce Johnston <bjohnsto@redhat.com>, Matthew Sakai <msakai@redhat.com>
cc: dm-devel@lists.linux.dev
Subject: Re: [RFC PATCH] dm: add deviceless messages
In-Reply-To: <3bdbd9fa-52ce-ab52-569f-29d4a30c6780@redhat.com>
Message-ID: <ba49d68e-ece2-f56c-6b25-e47e87ef739f@redhat.com>
References: <3bdbd9fa-52ce-ab52-569f-29d4a30c6780@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: zz45AAGHGl1ZSq7JzkFwcBorsU_Y1zUSncepvqCUctQ_1778593178
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII



On Tue, 12 May 2026, Mikulas Patocka wrote:

> The VDO code needs to perform some calculations before creating a device. 
> The calculations should be performed in the kernel, so that the same logic 
> is not duplicated in the kernel and in the userspace.
> 
> However, currently it is not possible to call a device mapper target 
> when no device exists.
> 
> This commit solves the problem by adding "deviceless" messages. If the 
> message starts with '%', the name is a name of a target, not a name of a 
> device. The message will be directed to the target by calling the 
> "deviceless_message" method. The target can perform the requested 
> calculations in this method and return the result back to userspace.
> 
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

This is example code how to use deviceless messages. You can call it with 
"dmsetup message linear 0 %Hello"

Mikulas

---
 drivers/md/dm-linear.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

Index: linux-2.6/drivers/md/dm-linear.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-linear.c	2026-05-11 13:00:08.000000000 +0200
+++ linux-2.6/drivers/md/dm-linear.c	2026-05-11 13:00:14.000000000 +0200
@@ -199,6 +199,15 @@ static size_t linear_dax_recovery_write(
 #define linear_dax_recovery_write NULL
 #endif
 
+static int linear_deviceless_message(unsigned int argc, char **argv, char *result, unsigned int maxlen)
+{
+	if (argc == 1 && !strcasecmp(argv[0], "%Hello")) {
+		snprintf(result, maxlen, "World!");
+		return 1;
+	}
+	return -EINVAL;
+}
+
 static struct target_type linear_target = {
 	.name   = "linear",
 	.version = {1, 5, 0},
@@ -211,6 +220,7 @@ static struct target_type linear_target
 	.dtr    = linear_dtr,
 	.map    = linear_map,
 	.status = linear_status,
+	.deviceless_message = linear_deviceless_message,
 	.prepare_ioctl = linear_prepare_ioctl,
 	.iterate_devices = linear_iterate_devices,
 	.direct_access = linear_dax_direct_access,

