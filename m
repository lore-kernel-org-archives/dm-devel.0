Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D3FD0C433EF
	for <dm-devel@archiver.kernel.org>; Thu,  6 Jan 2022 10:09:10 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-114-D0Ip1UuhNMeAJkLI7n0TQQ-1; Thu, 06 Jan 2022 05:09:06 -0500
X-MC-Unique: D0Ip1UuhNMeAJkLI7n0TQQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 56CD71F2DC;
	Thu,  6 Jan 2022 10:09:01 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 4FF937D4A3;
	Thu,  6 Jan 2022 10:09:00 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id A18BD4BB7C;
	Thu,  6 Jan 2022 10:08:56 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 206A8rK9008136 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 6 Jan 2022 05:08:53 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 9022C1121334; Thu,  6 Jan 2022 10:08:53 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 8BFC51120AA9
	for <dm-devel@redhat.com>; Thu,  6 Jan 2022 10:08:50 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 979B338035C8
	for <dm-devel@redhat.com>; Thu,  6 Jan 2022 10:08:50 +0000 (UTC)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
	by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-329-vz39L6aBO72leRvlP569sw-1; Thu, 06 Jan 2022 05:08:47 -0500
X-MC-Unique: vz39L6aBO72leRvlP569sw-1
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.source.kernel.org (Postfix) with ESMTPS id DCB79B81FEA;
	Thu,  6 Jan 2022 10:02:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1286AC36AEB;
	Thu,  6 Jan 2022 10:02:33 +0000 (UTC)
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Date: Thu,  6 Jan 2022 11:02:31 +0100
Message-Id: <20220106100231.3278554-1-gregkh@linuxfoundation.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1278; h=from:subject;
	bh=nWpfhqeUNsMenldA6XtXHKDmNMj1tVKZw2i27a1ToaI=;
	b=owGbwMvMwCRo6H6F97bub03G02pJDInX9pm721h9/vCaT99umfH194E8JRMqlPsmNe9dEpbBLOT0
	c92XjlgWBkEmBlkxRZYv23iO7q84pOhlaHsaZg4rE8gQBi5OAZjIijsM8wxmFtpOe3xvzRfV9SFVt3
	qn/Ymc84dhnn7Ql+mXDDKfzqsvV9WWX37drbJpJwA=
X-Developer-Key: i=gregkh@linuxfoundation.org; a=openpgp;
	fpr=F4B60CC5BF78C2214A313DCB3147D40DDB2DFB29
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 206A8rK9008136
X-loop: dm-devel@redhat.com
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, dm-devel@redhat.com,
	Mike Snitzer <snitzer@redhat.com>, Alasdair Kergon <agk@redhat.com>
Subject: [dm-devel] [PATCH] dm sysfs: use default_groups in kobj_type
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

There are currently 2 ways to create a set of sysfs files for a
kobj_type, through the default_attrs field, and the default_groups
field.  Move the dm sysfs code to use default_groups field which has
been the preferred way since aa30f47cf666 ("kobject: Add support for
default attribute groups to kobj_type") so that we can soon get rid of
the obsolete default_attrs field.

Cc: Alasdair Kergon <agk@redhat.com>
Cc: Mike Snitzer <snitzer@redhat.com>
Cc: dm-devel@redhat.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-sysfs.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/md/dm-sysfs.c b/drivers/md/dm-sysfs.c
index a05fcd50e1b9..e28c92478536 100644
--- a/drivers/md/dm-sysfs.c
+++ b/drivers/md/dm-sysfs.c
@@ -112,6 +112,7 @@ static struct attribute *dm_attrs[] = {
 	&dm_attr_rq_based_seq_io_merge_deadline.attr,
 	NULL,
 };
+ATTRIBUTE_GROUPS(dm);
 
 static const struct sysfs_ops dm_sysfs_ops = {
 	.show	= dm_attr_show,
@@ -120,7 +121,7 @@ static const struct sysfs_ops dm_sysfs_ops = {
 
 static struct kobj_type dm_ktype = {
 	.sysfs_ops	= &dm_sysfs_ops,
-	.default_attrs	= dm_attrs,
+	.default_groups	= dm_groups,
 	.release	= dm_kobject_release,
 };
 
-- 
2.34.1


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

