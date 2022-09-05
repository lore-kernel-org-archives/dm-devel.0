Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 40202ECAAD3
	for <dm-devel@archiver.kernel.org>; Mon,  5 Sep 2022 20:22:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1662409343;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=Y/A9NaE1ASNVmtHorHZHUJcQqto9GHlMianJ1EZsahA=;
	b=Cybhpt45gRR10X6PcPNzEr7mlxDASu7NffNdza4u6gQjIj/m8iZiSuaaJF0RywNhDCKOxW
	IjhOVEUnJhepX56z9kCe7SpiaanxTpSGaLgeWjl70IpF1wdmwDxBZiXDJytQgLzMp6RRMt
	kk/Aeexk8ruOwzdusFvdHhROf1IxgUM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-19-R2NyhyWtNLSlRahKrO9SRg-1; Mon, 05 Sep 2022 16:22:20 -0400
X-MC-Unique: R2NyhyWtNLSlRahKrO9SRg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1E60D85A585;
	Mon,  5 Sep 2022 20:22:18 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 8060B2026D4C;
	Mon,  5 Sep 2022 20:22:15 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 33F941946A48;
	Mon,  5 Sep 2022 20:22:15 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 1AAA81946A47
 for <dm-devel@listman.corp.redhat.com>; Mon,  5 Sep 2022 20:22:14 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id F0E522026D64; Mon,  5 Sep 2022 20:22:13 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com
 (file01.intranet.prod.int.rdu2.redhat.com [10.11.5.7])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id E815B2026D4C;
 Mon,  5 Sep 2022 20:22:13 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (localhost [127.0.0.1])
 by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4) with ESMTP id
 285KMD76029777; Mon, 5 Sep 2022 16:22:13 -0400
Received: from localhost (mpatocka@localhost)
 by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4/Submit) with ESMTP
 id 285KMDR6029773; Mon, 5 Sep 2022 16:22:13 -0400
X-Authentication-Warning: file01.intranet.prod.int.rdu2.redhat.com: mpatocka
 owned process doing -bs
Date: Mon, 5 Sep 2022 16:22:13 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>,
 Mike Snitzer <msnitzer@redhat.com>
In-Reply-To: <44941d34-385e-b874-2a96-d90550e08cd0@dorminy.me>
Message-ID: <alpine.LRH.2.02.2209051611150.27525@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.2209051121410.8614@file01.intranet.prod.int.rdu2.redhat.com>
 <44941d34-385e-b874-2a96-d90550e08cd0@dorminy.me>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
Subject: [dm-devel] [PATCH 2/2 v2] dm: make it possible to allocate error
 strings
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/dm-devel/>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=subscribe>
Cc: dm-devel@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit



On Mon, 5 Sep 2022, Sweet Tea Dorminy wrote:

> 
> 
> On 9/5/22 11:22, Mikulas Patocka wrote:
> > Previously, ti->error and ti_error strings were pointing to statically
> > allocated memory (the .rodata section) and it was not possible to add
> > parameters to the error strings.
> > 
> > This patch makes possible to allocate error strings dynamically using the
> > "kasprintf" function, so we can add arbitrary parameters to the strings.
> 
> I am so excited by this change.
> 
> > 
> > We need to free the error string only if is allocated with kasprintf. So,
> > we introduce a function "dm_free_error" that tests if the string points to
> > the module area (and doesn't free the string if it does), then it calls
> > kfree_const. kfree_const detects if the string points to the kernel
> > .rodata section and frees the string if it is not in .rodata.
>
> As I understand this change, if some new user used vmalloc to allocate a error
> string, DM would leak the memory. So I think the struct dm_target error member
> deserves documentation that it can be either constant or allocated via
> kmalloc, but not vmalloc.

Yes - I added documentation to this second version of the patch.

> All of these dynamic messages seem to add the target type. Might it be worth
> adding a helper macro to set a dynamic ti->error, like DMEMIT etc, which added
> a prefix of "target type %s:": and enforced that kasprintf(GFP_NOIO, ...) is
> used?

So, send a patch that adds it.

> Thanks!
> 
> Sweet Tea
>
>
> > --- linux-dm.orig/include/linux/device-mapper.h	2022-09-05
> > 14:31:51.000000000 +0200
> > +++ linux-dm/include/linux/device-mapper.h	2022-09-05 14:31:51.000000000
> > +0200
> > @@ -679,4 +679,10 @@ static inline unsigned long to_bytes(sec
> >   	return (n << SECTOR_SHIFT);
> >   }
> >   +static void dm_free_error(char *ti_error)

This should be "static inline". I forgot to refresh the patch.

> > +{
> > +	if (!is_vmalloc_or_module_addr(ti_error))
> > +		kfree_const(ti_error);
> > +}
> > +
> >   #endif	/* _LINUX_DEVICE_MAPPER_H */
> > --


From: Mikulas Patocka <mpatocka@redhat.com>

Previously, ti->error and ti_error strings were pointing to statically
allocated memory (the .rodata section) and it was not possible to add
parameters to the error strings.

This patch makes possible to allocate error strings dynamically using the
"kasprintf" function, so we can add arbitrary parameters to the strings.

We need to free the error string only if is allocated with kasprintf. So,
we introduce a function "dm_free_error" that tests if the string points to
the module area (and doesn't free the string if it does), then it calls
kfree_const. kfree_const detects if the string points to the kernel
.rodata section and frees the string if it is not in .rodata.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-ioctl.c         |    8 +++++++-
 drivers/md/dm-table.c         |   16 ++++++++++------
 include/linux/device-mapper.h |   13 ++++++++++++-
 3 files changed, 29 insertions(+), 8 deletions(-)

Index: linux-dm/drivers/md/dm-ioctl.c
===================================================================
--- linux-dm.orig/drivers/md/dm-ioctl.c	2022-09-05 14:31:51.000000000 +0200
+++ linux-dm/drivers/md/dm-ioctl.c	2022-09-05 14:31:51.000000000 +0200
@@ -1465,7 +1465,8 @@ static int table_load(struct file *filp,
 		DMERR("can't replace immutable target type %s",
 		      immutable_target_type->name);
 		r = -EINVAL;
-		ti_error = "can't replace immutable target";
+		ti_error = kasprintf(GFP_NOIO, "can't replace immutable target type %s",
+			immutable_target_type->name);
 		goto err_unlock_md_type;
 	}
 
@@ -1521,11 +1522,16 @@ err_destroy_table:
 err:
 	dm_put(md);
 err0:
+	if (!ti_error)
+		ti_error = "can't allocate error string";
 	if (param->flags & DM_RETURN_ERROR_FLAG) {
 		param->flags &= ~DM_RETURN_ERROR_FLAG;
 		strlcpy(param->name, ti_error, sizeof param->name);
 		param->error = r;
+		dm_free_error(ti_error);
 		return 0;
+	} else {
+		dm_free_error(ti_error);
 	}
 	return r;
 }
Index: linux-dm/drivers/md/dm-table.c
===================================================================
--- linux-dm.orig/drivers/md/dm-table.c	2022-09-05 14:31:51.000000000 +0200
+++ linux-dm/drivers/md/dm-table.c	2022-09-05 14:31:51.000000000 +0200
@@ -656,32 +656,32 @@ int dm_table_add_target(struct dm_table
 
 	ti->type = dm_get_target_type(type);
 	if (!ti->type) {
-		ti->error = "unknown target type";
+		ti->error = kasprintf(GFP_NOIO, "unknown target type %s", type);
 		r = -EINVAL;
 		goto bad0;
 	}
 
 	if (dm_target_needs_singleton(ti->type)) {
 		if (t->num_targets) {
-			ti->error = "singleton target type must appear alone in table";
+			ti->error = kasprintf(GFP_NOIO, "singleton target type %s must appear alone in table", type);
 			goto bad1;
 		}
 		t->singleton = true;
 	}
 
 	if (dm_target_always_writeable(ti->type) && !(t->mode & FMODE_WRITE)) {
-		ti->error = "target type may not be included in a read-only table";
+		ti->error = kasprintf(GFP_NOIO, "target type %s may not be included in a read-only table", type);
 		goto bad1;
 	}
 
 	if (t->immutable_target_type) {
 		if (t->immutable_target_type != ti->type) {
-			ti->error = "immutable target type cannot be mixed with other target types";
+			ti->error = kasprintf(GFP_NOIO, "immutable target type %s cannot be mixed with other target types", type);
 			goto bad1;
 		}
 	} else if (dm_target_is_immutable(ti->type)) {
 		if (t->num_targets) {
-			ti->error = "immutable target type cannot be mixed with other target types";
+			ti->error = kasprintf(GFP_NOIO, "immutable target type %s cannot be mixed with other target types", type);
 			goto bad1;
 		}
 		t->immutable_target_type = ti->type;
@@ -705,7 +705,7 @@ int dm_table_add_target(struct dm_table
 
 	r = dm_split_args(&argc, &argv, params);
 	if (r) {
-		ti->error = "couldn't split parameters";
+		ti->error = kasprintf(GFP_NOIO, "couldn't split parameters for target %s", type);
 		goto bad1;
 	}
 
@@ -728,9 +728,13 @@ int dm_table_add_target(struct dm_table
 bad1:
 	dm_put_target_type(ti->type);
 bad0:
+	if (!ti->error)
+		ti->error = "can't allocate error string";
 	DMERR("%s: %s: %s (%pe)", dm_device_name(t->md), type, ti->error, ERR_PTR(r));
 	if (ti_error)
 		*ti_error = ti->error;
+	else
+		dm_free_error(ti->error);
 	return r;
 }
 
Index: linux-dm/include/linux/device-mapper.h
===================================================================
--- linux-dm.orig/include/linux/device-mapper.h	2022-09-05 14:31:51.000000000 +0200
+++ linux-dm/include/linux/device-mapper.h	2022-09-05 22:10:00.000000000 +0200
@@ -342,7 +342,12 @@ struct dm_target {
 	/* target specific data */
 	void *private;
 
-	/* Used to provide an error string from the ctr */
+	/*
+	 * Used to provide an error string from the ctr. It may pointe to a
+	 * statically allocated string in the kernel's or module's .rodata
+	 * section, or to a dynamically allocated string using kmalloc (for
+	 * example, using kasprintf). It must not point to vmallocated memory.
+	 */
 	char *error;
 
 	/*
@@ -679,4 +684,10 @@ static inline unsigned long to_bytes(sec
 	return (n << SECTOR_SHIFT);
 }
 
+static inline void dm_free_error(char *ti_error)
+{
+	if (!is_vmalloc_or_module_addr(ti_error))
+		kfree_const(ti_error);
+}
+
 #endif	/* _LINUX_DEVICE_MAPPER_H */
--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

