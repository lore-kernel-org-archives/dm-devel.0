Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E688EEB64DB
	for <dm-devel@archiver.kernel.org>; Thu, 15 Jun 2023 07:22:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686813749;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=Ts90/JD7I2vKCtZ6wJvNmk9wfcsTyZE1c1u47VDslq0=;
	b=D4e+b/CiadOgTIQ1bNL6r9wjFbTykGKVrU13sr9igVv5/x2QvA/A8zjiGj8vY7gaaHspV1
	DnYqj9IOeqoPJR9dVkzHAgeHMFiJt0kHmlTap+GyAot9m7S8iDgBiogJ3F0DFPAgtTtAdD
	W+59oxElhgai92yDe+5B4qBWPUS3TYc=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-622-2tE2X8zsOKyn8JtOWZRktA-1; Thu, 15 Jun 2023 03:22:25 -0400
X-MC-Unique: 2tE2X8zsOKyn8JtOWZRktA-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E494885828B;
	Thu, 15 Jun 2023 07:22:22 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id A422648FB04;
	Thu, 15 Jun 2023 07:22:20 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 7157D1946587;
	Thu, 15 Jun 2023 07:22:20 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 027EB194658C
 for <dm-devel@listman.corp.redhat.com>; Wed, 14 Jun 2023 07:58:57 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id D83522026D6A; Wed, 14 Jun 2023 07:58:57 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id D07632026D49
 for <dm-devel@redhat.com>; Wed, 14 Jun 2023 07:58:57 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B57678582B6
 for <dm-devel@redhat.com>; Wed, 14 Jun 2023 07:58:57 +0000 (UTC)
Received: from mail.208.org (183.242.55.162 [183.242.55.162]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-570-KCa45lrONbuIBOe6ylzs6w-1; Wed,
 14 Jun 2023 03:58:55 -0400
X-MC-Unique: KCa45lrONbuIBOe6ylzs6w-1
Received: from mail.208.org (email.208.org [127.0.0.1])
 by mail.208.org (Postfix) with ESMTP id 4QgyVN4FRKzBQJZT
 for <dm-devel@redhat.com>; Wed, 14 Jun 2023 15:58:52 +0800 (CST)
X-Virus-Scanned: amavisd-new at mail.208.org
Received: from mail.208.org ([127.0.0.1])
 by mail.208.org (mail.208.org [127.0.0.1]) (amavisd-new, port 10026)
 with ESMTP id R3_YibLTpg4I for <dm-devel@redhat.com>;
 Wed, 14 Jun 2023 15:58:52 +0800 (CST)
Received: from localhost (email.208.org [127.0.0.1])
 by mail.208.org (Postfix) with ESMTPSA id 4QgyVN2VvMzBQJYp;
 Wed, 14 Jun 2023 15:58:52 +0800 (CST)
MIME-Version: 1.0
Date: Wed, 14 Jun 2023 15:58:52 +0800
From: baomingtong001@208suo.com
To: agk@redhat.com, snitzer@kernel.org, dm-devel@redhat.com
In-Reply-To: <20230614075528.11930-1-luojianhong@cdjrlc.com>
References: <20230614075528.11930-1-luojianhong@cdjrlc.com>
User-Agent: Roundcube Webmail
Message-ID: <d63fefa76e501dc05353a7d682d83541@208suo.com>
X-Sender: baomingtong001@208suo.com
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mailman-Approved-At: Thu, 15 Jun 2023 07:22:20 +0000
Subject: [dm-devel] [PATCH] dm log: remove unneeded variable
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
Cc: linux-kernel@vger.kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: 208suo.com
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

fix the following coccicheck warning:

drivers/md/dm-snap-transient.c:94:14-16: Unneeded variable: "sz". Return 
"0".
drivers/md/dm-ps-historical-service-time.c:240:14-16: Unneeded variable: 
"sz". Return "0".

Signed-off-by: Mingtong Bao <baomingtong001@208suo.com>
---
  drivers/md/dm-log.c | 6 ++----
  1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/md/dm-log.c b/drivers/md/dm-log.c
index f9f84236dfcd..38bcdd5ddb21 100644
--- a/drivers/md/dm-log.c
+++ b/drivers/md/dm-log.c
@@ -793,7 +793,6 @@ static region_t core_get_sync_count(struct 
dm_dirty_log *log)
  static int core_status(struct dm_dirty_log *log, status_type_t status,
                 char *result, unsigned int maxlen)
  {
-    int sz = 0;
      struct log_c *lc = log->context;

      switch (status) {
@@ -812,13 +811,12 @@ static int core_status(struct dm_dirty_log *log, 
status_type_t status,
          break;
      }

-    return sz;
+    return 0;
  }

  static int disk_status(struct dm_dirty_log *log, status_type_t status,
                 char *result, unsigned int maxlen)
  {
-    int sz = 0;
      struct log_c *lc = log->context;

      switch (status) {
@@ -841,7 +839,7 @@ static int disk_status(struct dm_dirty_log *log, 
status_type_t status,
          break;
      }

-    return sz;
+    return 0;
  }

  static struct dm_dirty_log_type _core_type = {

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

