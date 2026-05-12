Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B4B43911C5
	for <dm-devel@lists.linux.dev>; Tue, 12 May 2026 13:36:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778592977; cv=none; b=N+oDSyHeqG6LmlA00vcMdrgHZ8YSPST75Hx/pY7d95pZQzIl6X9fm4KCtHmQCUGCt+P+cizRF1szAhqO3+jGlMBUyCIKDZ6rZEtpTZPquZZpxzbkEH5HZ0CRMX36fQKu4PaBZzvqQF4+XK8/DSujvB+3AmTgrobXwojKeLesYLM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778592977; c=relaxed/simple;
	bh=FJlJi7V34LfsT9zPjGD0tK5+bk/sX5VkgYq3uG4wQB4=;
	h=Date:From:To:cc:Subject:Message-ID:MIME-Version:Content-Type; b=TrmcBplCP+mD1SZGlgTd7xyxbrJuRlnTzWl/ipSRS/Fnwg96TmR8QmJZftU1foLFOIUOBZnjv7Wm3GIgPQ3GufivFLLgO/1T4nbjGvCYISciquUSfTne9R6CIaoVeDVlpkzasoqlb8nW2J44uhG9TAJNeMkF5wBuuY7O0St3NwM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Kl1imHbh; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Kl1imHbh"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1778592974;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=PxMgnVKlIoMxMUxYU5gOuHGrcy7Buunzp7idUYJMPm4=;
	b=Kl1imHbhWIfwrBEj32zNjbRLsz40OfWnu3qzRn6gOgL8zNzNpPoCF7I0maKk0rmvvpwef3
	KuvV+jUnyc+1H92MygLQtQzuwm6EP+NvlzxdTlYTaJq++HGzABdGOBb31Njc88tyCrVXI5
	Aeu5xl4U/eBvDb/FV8+Uwhsg/Miyb60=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-670-bQgcQYFuM7SG3TORw2_S9Q-1; Tue,
 12 May 2026 09:36:08 -0400
X-MC-Unique: bQgcQYFuM7SG3TORw2_S9Q-1
X-Mimecast-MFC-AGG-ID: bQgcQYFuM7SG3TORw2_S9Q_1778592968
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C08EB1800618;
	Tue, 12 May 2026 13:36:07 +0000 (UTC)
Received: from [10.44.34.151] (unknown [10.44.34.151])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id AAAE81955D84;
	Tue, 12 May 2026 13:36:05 +0000 (UTC)
Date: Tue, 12 May 2026 15:36:01 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, 
    Benjamin Marzinski <bmarzins@redhat.com>, 
    Bruce Johnston <bjohnsto@redhat.com>, Matthew Sakai <msakai@redhat.com>
cc: dm-devel@lists.linux.dev
Subject: [RFC PATCH] dm: add deviceless messages
Message-ID: <3bdbd9fa-52ce-ab52-569f-29d4a30c6780@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: ynX0KyOvAe1AO0KBFkGc9PIcjld6oDnGqmsAsHZPy08_1778592968
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII

The VDO code needs to perform some calculations before creating a device. 
The calculations should be performed in the kernel, so that the same logic 
is not duplicated in the kernel and in the userspace.

However, currently it is not possible to call a device mapper target 
when no device exists.

This commit solves the problem by adding "deviceless" messages. If the 
message starts with '%', the name is a name of a target, not a name of a 
device. The message will be directed to the target by calling the 
"deviceless_message" method. The target can perform the requested 
calculations in this method and return the result back to userspace.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-ioctl.c         |   57 +++++++++++++++++++++++++++++++++---------
 include/linux/device-mapper.h |    4 ++
 2 files changed, 49 insertions(+), 12 deletions(-)

Index: linux-2.6/drivers/md/dm-ioctl.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-ioctl.c	2026-05-06 22:15:36.000000000 +0200
+++ linux-2.6/drivers/md/dm-ioctl.c	2026-05-11 12:53:37.000000000 +0200
@@ -1743,6 +1743,33 @@ static int table_status(struct file *fil
 	return 0;
 }
 
+static int message_for_module(const char *target_name, unsigned int argc, char **argv,
+			      char *result, unsigned int maxlen)
+{
+	struct target_type *tt;
+	int r;
+
+	if (**argv != '%')
+		return 2;
+
+	tt = dm_get_target_type(target_name);
+	if (!tt) {
+		DMERR("unknown target name %s", target_name);
+		return -EINVAL;
+	}
+
+	if (!tt->deviceless_message) {
+		DMERR("target %s doesn't support deviceless messages", target_name);
+		r = -EINVAL;
+	} else {
+		r = tt->deviceless_message(argc, argv, result, maxlen);
+	}
+
+	dm_put_target_type(tt);
+
+	return r;
+}
+
 /*
  * Process device-mapper dependent messages.  Messages prefixed with '@'
  * are processed by the DM core.  All others are delivered to the target.
@@ -1788,10 +1815,6 @@ static int target_message(struct file *f
 	char *result = get_result_buffer(param, param_size, &maxlen);
 	int srcu_idx;
 
-	md = find_device(param);
-	if (!md)
-		return -ENXIO;
-
 	if (tmsg < (struct dm_target_msg *) param->data ||
 	    invalid_str(tmsg->message, (void *) param + param_size)) {
 		DMERR("Invalid target message parameters.");
@@ -1811,9 +1834,19 @@ static int target_message(struct file *f
 		goto out_argv;
 	}
 
-	r = message_for_md(md, argc, argv, result, maxlen);
+	r = message_for_module(param->name, argc, argv, result, maxlen);
 	if (r <= 1)
+		goto out_deviceless;
+
+	md = find_device(param);
+	if (!md) {
+		r = -ENXIO;
 		goto out_argv;
+	}
+
+	r = message_for_md(md, argc, argv, result, maxlen);
+	if (r <= 1)
+		goto out_md;
 
 	table = dm_get_live_table(md, &srcu_idx);
 	if (!table) {
@@ -1838,14 +1871,13 @@ static int target_message(struct file *f
 		r = -EINVAL;
 	}
 
- out_table:
+out_table:
 	dm_put_live_table(md, srcu_idx);
- out_argv:
-	kfree(argv);
- out:
+out_md:
 	if (r >= 0)
 		__dev_status(md, param);
-
+	dm_put(md);
+out_deviceless:
 	if (r == 1) {
 		param->flags |= DM_DATA_OUT_FLAG;
 		if (dm_message_test_buffer_overflow(result, maxlen))
@@ -1854,8 +1886,9 @@ static int target_message(struct file *f
 			param->data_size = param->data_start + strlen(result) + 1;
 		r = 0;
 	}
-
-	dm_put(md);
+out_argv:
+	kfree(argv);
+out:
 	return r;
 }
 
Index: linux-2.6/include/linux/device-mapper.h
===================================================================
--- linux-2.6.orig/include/linux/device-mapper.h	2026-04-27 19:06:34.000000000 +0200
+++ linux-2.6/include/linux/device-mapper.h	2026-05-11 12:45:45.000000000 +0200
@@ -93,6 +93,9 @@ typedef void (*dm_status_fn) (struct dm_
 typedef int (*dm_message_fn) (struct dm_target *ti, unsigned int argc, char **argv,
 			      char *result, unsigned int maxlen);
 
+typedef int (*dm_deviceless_message_fn) (unsigned int argc, char **argv,
+			      char *result, unsigned int maxlen);
+
 /*
  * Called with *forward == true. If it remains true, the ioctl should be
  * forwarded to bdev. If it is reset to false, the target already fully handled
@@ -214,6 +217,7 @@ struct target_type {
 	dm_resume_fn resume;
 	dm_status_fn status;
 	dm_message_fn message;
+	dm_deviceless_message_fn deviceless_message;
 	dm_prepare_ioctl_fn prepare_ioctl;
 	dm_report_zones_fn report_zones;
 	dm_busy_fn busy;

