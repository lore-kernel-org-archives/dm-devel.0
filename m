Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D54E30BF4E
	for <dm-devel@lists.linux.dev>; Wed, 13 May 2026 16:16:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778688980; cv=none; b=iMxSDxiRt+cgqwX5XL7S1waNBDf+Hs/NFOMTdlvzVck9i5y+AaRlyrqJkndXd+EDvqDopbk1xD70KP2p+yO7KOq7zVqtNxc8yB0jkAAX/yyqwUoT2EyGfCXzwmJ51L9T2JJb4lRtvpdANJ/VmB7ppVv0CBh8X0tLTHGIUhbDfmk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778688980; c=relaxed/simple;
	bh=O5uQFvyuPh+J//I7wbZ2bgolET86EVbX6+Z3rxxMA0M=;
	h=Date:From:To:cc:Subject:Message-ID:MIME-Version:Content-Type; b=tzNhEJ5Th+WQbRVKxIxbIodRq5l5SJdi3qpWvdF6bWxzKUMFY/GuPXfSzGDMwlgfAmzcZbnaBBd9dy7WXDrivR7TYtGSkrdr6VBZs2tjPrXC4BaLNjLWbBENVGbTYFEYz9ZRHov/aqEaLpvggD/7tza3s7I4C/uvIt/29+u9+VI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dVIzNPVj; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dVIzNPVj"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1778688978;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=i/9IsIIIK6y68+nwMYTeYz2eYBbA/VaEw51iBnqmiNQ=;
	b=dVIzNPVjiJp5BnMK3ShR0f2c5T+C0r7JDx3NQHU2LbiGyWO+hE7ijh7tDxHLPXFlANEUfO
	TJ2Io5fjziRgs1D1vcMw7s8pvegbes1UmHeflrtOssWJm2zpa2T0e+NGP4XRNRPSSHJabW
	B+hWULNvlshkLvOXDSJ6ZeonkIb4lUA=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-686-ihRYw5lgMu-Tr1vp41zthg-1; Wed,
 13 May 2026 12:16:15 -0400
X-MC-Unique: ihRYw5lgMu-Tr1vp41zthg-1
X-Mimecast-MFC-AGG-ID: ihRYw5lgMu-Tr1vp41zthg_1778688974
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 385CE180058C;
	Wed, 13 May 2026 16:16:14 +0000 (UTC)
Received: from [10.44.34.151] (unknown [10.44.34.151])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0350819560A2;
	Wed, 13 May 2026 16:16:11 +0000 (UTC)
Date: Wed, 13 May 2026 18:16:07 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, 
    Benjamin Marzinski <bmarzins@redhat.com>, 
    Bruce Johnston <bjohnsto@redhat.com>, Matthew Sakai <msakai@redhat.com>, 
    Milan Broz <gmazyland@gmail.com>, Zdenek Kabelac <zkabelac@redhat.com>
cc: dm-devel@lists.linux.dev
Subject: [RFC PATCH v2] dm: add deviceless messages
Message-ID: <290dd28a-e750-cbe9-f1a6-67bcf4b6fbb6@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: P-B9UnCiiq1iJ_JmIegSkGyEZ4nsUbvebL4_wgNZefg_1778688974
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII

Hi

Here I'm releasing the second version of the deviceless messages patch. I 
discussed it with Alasdair and we concluded to change the format of the 
message. If the device is "." (note that this name is rejected by the 
kernel, so no device with this name could exist), the message is 
considered deviceless.

You could send the deviceless message to the linear target with:
dmsetup message . 0 linear Hello

Mikulas


From: Mikulas Patocka <mpatocka@redhat.com>

The VDO code needs to perform some calculations before creating a device.
The calculations should be performed in the kernel, so that the same logic
is not duplicated in the kernel and in the userspace.

However, currently it is not possible to call a device mapper target
when no device exists.

This commit solves the problem by adding "deviceless" messages. If the 
message is directed to a device ".", the sector number is ignored and the 
first argument is the name of the target the message should be delivered 
to. The other arguments are passed to the target's deviceless_message 
method. The target can perform the requested calculations in this method 
and return the result back to userspace.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-ioctl.c         |   60 +++++++++++++++++++++++++++++++++---------
 include/linux/device-mapper.h |    4 ++
 2 files changed, 52 insertions(+), 12 deletions(-)

Index: linux-2.6/drivers/md/dm-ioctl.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-ioctl.c	2026-05-12 15:40:22.000000000 +0200
+++ linux-2.6/drivers/md/dm-ioctl.c	2026-05-13 14:52:23.000000000 +0200
@@ -1743,6 +1743,30 @@ static int table_status(struct file *fil
 	return 0;
 }
 
+static int message_for_module(const char *target_name, unsigned int argc, char **argv,
+			      char *result, unsigned int maxlen)
+{
+	struct target_type *tt;
+	int r;
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
@@ -1788,10 +1812,6 @@ static int target_message(struct file *f
 	char *result = get_result_buffer(param, param_size, &maxlen);
 	int srcu_idx;
 
-	md = find_device(param);
-	if (!md)
-		return -ENXIO;
-
 	if (tmsg < (struct dm_target_msg *) param->data ||
 	    invalid_str(tmsg->message, (void *) param + param_size)) {
 		DMERR("Invalid target message parameters.");
@@ -1811,9 +1831,25 @@ static int target_message(struct file *f
 		goto out_argv;
 	}
 
+	if (!strcmp(param->name, ".")) {
+		if (argc == 1) {
+			DMERR("Empty message received.");
+			r = -EINVAL;
+			goto out_argv;
+		}
+		r = message_for_module(argv[0], argc - 1, argv + 1, result, maxlen);
+		goto out_deviceless;
+	}
+
+	md = find_device(param);
+	if (!md) {
+		r = -ENXIO;
+		goto out_argv;
+	}
+
 	r = message_for_md(md, argc, argv, result, maxlen);
 	if (r <= 1)
-		goto out_argv;
+		goto out_md;
 
 	table = dm_get_live_table(md, &srcu_idx);
 	if (!table) {
@@ -1838,14 +1874,13 @@ static int target_message(struct file *f
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
@@ -1854,8 +1889,9 @@ static int target_message(struct file *f
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
--- linux-2.6.orig/include/linux/device-mapper.h	2026-05-12 15:40:22.000000000 +0200
+++ linux-2.6/include/linux/device-mapper.h	2026-05-12 15:40:22.000000000 +0200
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

