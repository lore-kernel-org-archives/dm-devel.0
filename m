Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E226EC04ABA
	for <dm-devel@archiver.kernel.org>; Wed, 20 Sep 2023 17:23:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1695230618;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=Mts7x+mvAWqaSqXJrz7rm6GfLReA8jIQUigpjN+TQpw=;
	b=FtE8LfH8T9CO9m0jISOFrIYA26GijiWDmQY4PlPZ3HAGEcqG+kx20zVFp1tZNja+DNyOi2
	xo/vpZLX9xeJyS8zW1yi8jcxzJiCzFeOP4F+cQ5z6YOhRzYYUKwI8DltwuQ/+UXSLHv+QY
	YO7mm+yY1OqxNRVenxcRoZRsnYohOkY=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-648-2bKIaANONoSQarbZrsCXeQ-1; Wed, 20 Sep 2023 13:23:35 -0400
X-MC-Unique: 2bKIaANONoSQarbZrsCXeQ-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5011F293248A;
	Wed, 20 Sep 2023 17:23:33 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id E8CF3492B16;
	Wed, 20 Sep 2023 17:23:26 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id AA4D11946594;
	Wed, 20 Sep 2023 17:23:11 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 2898D194658D
 for <dm-devel@listman.corp.redhat.com>; Wed, 20 Sep 2023 10:59:06 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id E9D68140273D; Wed, 20 Sep 2023 10:59:05 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id E2805140273C
 for <dm-devel@redhat.com>; Wed, 20 Sep 2023 10:59:05 +0000 (UTC)
Received: from us-smtp-inbound-delivery-1.mimecast.com
 (us-smtp-inbound-delivery-1.mimecast.com [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9CB65381258E
 for <dm-devel@redhat.com>; Wed, 20 Sep 2023 10:59:05 +0000 (UTC)
Received: from mail.ispras.ru (mail.ispras.ru [83.149.199.84]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-173-vcifPI-rN-OssfXWshE7UQ-1; Wed, 20 Sep 2023 06:59:03 -0400
X-MC-Unique: vcifPI-rN-OssfXWshE7UQ-1
Received: from localhost.ispras.ru (unknown [10.10.165.14])
 by mail.ispras.ru (Postfix) with ESMTPSA id 8B4CD40F1DF9;
 Wed, 20 Sep 2023 10:52:05 +0000 (UTC)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.ispras.ru 8B4CD40F1DF9
From: Fedor Pchelkin <pchelkin@ispras.ru>
To: Mike Snitzer <snitzer@kernel.org>
Date: Wed, 20 Sep 2023 13:51:16 +0300
Message-ID: <20230920105119.21276-1-pchelkin@ispras.ru>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Mailman-Approved-At: Wed, 20 Sep 2023 17:22:20 +0000
Subject: [dm-devel] [PATCH] dm-zoned: free dmz->ddev array in
 dmz_put_zoned_device
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
Cc: lvc-project@linuxtesting.org, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org, Fedor Pchelkin <pchelkin@ispras.ru>,
 dm-devel@redhat.com, Alasdair Kergon <agk@redhat.com>,
 Alexey Khoroshilov <khoroshilov@ispras.ru>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: ispras.ru
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Commit 4dba12881f88 ("dm zoned: support arbitrary number of devices")
made the pointers to additional zoned devices to be stored in a
dynamically allocated dmz->ddev array. However, this array is not freed.

Free it when cleaning up zoned device information inside
dmz_put_zoned_device(). Assigning NULL to dmz->ddev elements doesn't make
sense there as they are not supposed to be reused later and the whole dmz
target structure is being cleaned anyway.

Found by Linux Verification Center (linuxtesting.org).

Fixes: 4dba12881f88 ("dm zoned: support arbitrary number of devices")
Cc: stable@vger.kernel.org
Signed-off-by: Fedor Pchelkin <pchelkin@ispras.ru>
---
 drivers/md/dm-zoned-target.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/md/dm-zoned-target.c b/drivers/md/dm-zoned-target.c
index ad8e670a2f9b..e25cd9db6275 100644
--- a/drivers/md/dm-zoned-target.c
+++ b/drivers/md/dm-zoned-target.c
@@ -753,12 +753,10 @@ static void dmz_put_zoned_device(struct dm_target *ti)
 	struct dmz_target *dmz = ti->private;
 	int i;
 
-	for (i = 0; i < dmz->nr_ddevs; i++) {
-		if (dmz->ddev[i]) {
+	for (i = 0; i < dmz->nr_ddevs; i++)
+		if (dmz->ddev[i])
 			dm_put_device(ti, dmz->ddev[i]);
-			dmz->ddev[i] = NULL;
-		}
-	}
+	kfree(dmz->ddev);
 }
 
 static int dmz_fixup_devices(struct dm_target *ti)
-- 
2.42.0

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

