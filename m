Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.133.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793890584;
	b=CYYCHfUoJL+KXT8FB3oI52FFLM07XvUPXQxWZteohj3zw0mudmNObfDA0PWLt/Uua7kR
	 o4xmn59TwtRMfsT6s/lHQqyyNAoaLUBCB3xD1dKCXm3TYYXeuMSyEAOKJKnO6yS803TM7
	 GWDn6SCtEA7nTka0NO2jgzKnyPKAnnACArWVRdUBPCTuv7Kkz9vmowk+fcuClEr4/dN+F
	 DhZhrzFK3kdXkGCXByu3D017qGsroDbCsU/KllhtFXQUyJSR38TEXv6RfJSYPfXmpC1Wp
	 4tmGgmUgBRJFFIAwKUzttcorHTOvUF9l3lw44lfiebISCq1k/I0/jTz+8Vs2To91pmQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793890584;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:Received:Date:From:To:cc:Subject:
	 In-Reply-To:Message-ID:References:MIME-Version:X-Scanned-By:
	 X-Mimecast-MFC-PROC-ID:X-Mimecast-Originator:Content-Type;
	bh=4bDMURwR4/SSIEXVeA3LG2zR14gTTur39HxrnuGcJtw=;
	b=WFI427ZenrAbYzRoegrpRwZspaJvWMsKaDDsZXVRb0/3haZnm3l7nXww8niOBsBgvu3K
	 hqaKPHBS40p+Q6qRp1oFTRvicHpMfR9TyDB6HcCiJ8v/wE4sxx6514CWdP21RvTu9Vdv2
	 c6hWcRjUaRy5jVlgDcotjTfQq6Bx3D8h6ekxDZhFrj/w7YB/fRMNbPtR2VGmhNptB3HYY
	 F8ncGCejPQAdUKCXbB22TlEnJ9o9wLMgvTYUpVJ+PRjki7KbSnaYxJFCLZS5ZamsvXmx5
	 weLX0ADXzcsjshyMURajgHyNOikcatjjppLHFgBANg1S37Rhdyyo+oU3zN05mQ9zrYg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=QEzgYFSN;
	arc=none smtp.remote-ip=170.10.133.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C51DA606A326
	for <dm-devel@lists.linux.dev>; Thu,  5 Nov 2026 14:56:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C51DA606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=QEzgYFSN
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1793890582;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=4bDMURwR4/SSIEXVeA3LG2zR14gTTur39HxrnuGcJtw=;
	b=QEzgYFSNhqxHF8b9fpycQLBGl6s5rp+PnkiYz0KPlWXkLr8CMSHCkXaHAeh5ccHuoYKYES
	/ltO2YpiWdEFCf8AA2FHhYqcvok8/mX+msRoAkYAIr/VU5I5+F/F4X8wuSTVKKpUVKviDx
	R9n2lK1+1jGww5F34Ks2VSq4ky/HoAQ=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-374-wY38ywd9OEu1BFmjVE8mCA-1; Thu,
 05 Nov 2026 09:56:18 -0500
X-MC-Unique: wY38ywd9OEu1BFmjVE8mCA-1
X-Mimecast-MFC-AGG-ID: wY38ywd9OEu1BFmjVE8mCA_1793890577
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 2886A1955E95;
	Thu,  5 Nov 2026 14:56:16 +0000 (UTC)
Received: from mpatocka-thinkpadx1carbongen12.rmtcz.csb (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 30E601800284;
	Thu,  5 Nov 2026 14:56:13 +0000 (UTC)
Date: Thu, 5 Nov 2026 15:56:11 +0100 (CET)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Wentao Liang <vulab@iscas.ac.cn>
cc: agk@redhat.com, snitzer@kernel.org, bmarzins@redhat.com, 
    dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: [PATCH] dm-sysfs: fix misbehavior if kobject_init_and_add fails
In-Reply-To: <20261103082329.1159472-1-vulab@iscas.ac.cn>
Message-ID: <32ebd466-6d90-dbe3-a77e-53dbb827e887@redhat.com>
References: <20261103082329.1159472-1-vulab@iscas.ac.cn>
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-MFC-PROC-ID: 3sc0YMDjjuCNBi12I8tiukhyPN7sr_ayUEFoc9zIgm8_1793890577
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII

Hi

The bug is real, but the patch is wrong. As Sashiko noted, 
kobject_init_and_add would see an uninitialized kboject if it were called 
the second time.

I created this patch for this bug.

Mikulas


dm-sysfs: fix misbehavior if kobject_init_and_add fails

If kobject_init_and_add, we must call kobject_put (see the comment at
kobject_init_and_add).

Before calling kobject_init_and_add, we must zero the kobject (see
https://lwn.net/Articles/52085/). If the first call to dm_sysfs_init
failed, it may be called again, and that second call would see an
uninitialized kobject.

Cc: stable@vger.kernel.org
Fixes: 784aae735d9b ("dm: add name and uuid to sysfs")
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-sysfs.c |   17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

Index: linux-2.6/drivers/md/dm-sysfs.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-sysfs.c
+++ linux-2.6/drivers/md/dm-sysfs.c
@@ -128,9 +128,20 @@ static const struct kobj_type dm_ktype =
  */
 int dm_sysfs_init(struct mapped_device *md)
 {
-	return kobject_init_and_add(dm_kobject(md), &dm_ktype,
-				    &disk_to_dev(dm_disk(md))->kobj,
-				    "%s", "dm");
+	struct kobject *kobj = dm_kobject(md);
+	int r;
+
+	/* The kobject must be zeroed before calling kobject_init */
+	memset(kobj, 0, sizeof(struct kobject));
+	r = kobject_init_and_add(kobj, &dm_ktype,
+				 &disk_to_dev(dm_disk(md))->kobj,
+				 "%s", "dm");
+	if (unlikely(r)) {
+		/* Weird semantics - we must call kobject_put on failure */
+		dm_sysfs_exit(md);
+		return r;
+	}
+	return 0;
 }
 
 /*


On Tue, 3 Nov 2026, Wentao Liang wrote:

> dm_sysfs_init() uses kobject_init_and_add(), which requires a matching
> put even when adding the object fails. dm_setup_md_queue() currently
> unwinds the disk and holder links without releasing this object. Since
> md->type is still DM_TYPE_NONE, cleanup_mapped_device() also skips the
> sysfs cleanup, leaving the initialized kobject behind.
> 
> Call dm_sysfs_exit() before unwinding a failed sysfs initialization. This
> both puts the kobject and waits for its release callback, including when
> CONFIG_DEBUG_KOBJECT_RELEASE delays that callback, before the mapped
> device can be freed or its queue setup retried.
> 
> Fixes: 784aae735d9b ("dm: add name and uuid to sysfs")
> Cc: stable@vger.kernel.org
> Assisted-by: DeepSeek-V4.1-Flash and OpenAI Codex
> Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
> ---
>  drivers/md/dm.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/md/dm.c b/drivers/md/dm.c
> index 1881d86111fb..08b87fd6f955 100644
> --- a/drivers/md/dm.c
> +++ b/drivers/md/dm.c
> @@ -2647,8 +2647,10 @@ int dm_setup_md_queue(struct mapped_device *md, struct dm_table *t)
>  	mutex_unlock(&md->table_devices_lock);
>  
>  	r = dm_sysfs_init(md);
> -	if (r)
> +	if (r) {
> +		dm_sysfs_exit(md);
>  		goto lock_out_undo_holders;
> +	}
>  
>  	md->type = type;
>  
> -- 
> 2.34.1
> 

