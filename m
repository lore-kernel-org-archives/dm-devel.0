Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 464FCC433F5
	for <dm-devel@archiver.kernel.org>; Mon,  4 Apr 2022 06:48:44 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-421-CqDHYxIvOUmvSHuGdmAehA-1; Mon, 04 Apr 2022 02:48:40 -0400
X-MC-Unique: CqDHYxIvOUmvSHuGdmAehA-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 92EAB1C05EAB;
	Mon,  4 Apr 2022 06:48:38 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 831DA5159AE;
	Mon,  4 Apr 2022 06:48:38 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 951E1193F6DC;
	Mon,  4 Apr 2022 06:48:36 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id B7DD919451F3
 for <dm-devel@listman.corp.redhat.com>; Thu, 31 Mar 2022 22:03:24 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 1E4EC400DB1C; Thu, 31 Mar 2022 22:03:24 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 19E9340CF8F7
 for <dm-devel@redhat.com>; Thu, 31 Mar 2022 22:03:24 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CFF86185A7BA
 for <dm-devel@redhat.com>; Thu, 31 Mar 2022 22:03:23 +0000 (UTC)
Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com
 [209.85.208.51]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-54-__g_5dZUMDaD57K2fc04PA-1; Thu, 31 Mar 2022 18:03:21 -0400
X-MC-Unique: __g_5dZUMDaD57K2fc04PA-1
Received: by mail-ed1-f51.google.com with SMTP id b24so843787edu.10;
 Thu, 31 Mar 2022 15:03:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=g06L8lJBLjLYpTtLuAhJfyTVoQvqpjZZgd66GLledb8=;
 b=xtgWAPw9omlgYMTVhDt8DjWrtPLPD2b4+QGxtlA5fqGhV836xODQqPKJUmjWnK2XqS
 V48A6FtYSN3NqtbE7bOysjkAqWhodFLXmYLGARSjMAort5zapKnh7McLth9uw84bnoIe
 dElOtJl2lTLXEkgx6931OTS9/f7evhl/mWhNhFZ4IEufvDMTZjw8Nx8GOHPD05xFIyb+
 yudR8HjNGHR3qo17DeLanBOhJBY/Yl2c4WNKcmTyJxkhy66IbotrNjb4SI323S+aiQ/R
 5dDA3JWFKpgYca8A3Vc4bG/LqCy67rY0EZvwG2GzHXlm9vS8D8i/5yg0NT+Tsgi+HbPV
 tIKQ==
X-Gm-Message-State: AOAM530156d9WvxyZkhswq0oy5J+VCuzpvi+t9ZdoKFfuiMc1RZD0VKf
 JRfVy85twXz2ZZqx6nom1XgPkRy1ewcjUQ==
X-Google-Smtp-Source: ABdhPJwCH+OkQyo2XKVNWbEL35S6WpC2JL9Zv8VMjXcUGl4e9aJJrg5dIUbzSnOjO+lbBJjllHNdBQ==
X-Received: by 2002:a05:6402:1742:b0:419:2707:747a with SMTP id
 v2-20020a056402174200b004192707747amr18500745edx.238.1648764200063; 
 Thu, 31 Mar 2022 15:03:20 -0700 (PDT)
Received: from localhost.localdomain (i130160.upc-i.chello.nl.
 [62.195.130.160]) by smtp.googlemail.com with ESMTPSA id
 sb15-20020a1709076d8f00b006dfe4cda58fsm247312ejc.95.2022.03.31.15.03.19
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 31 Mar 2022 15:03:19 -0700 (PDT)
From: Jakob Koschel <jakobkoschel@gmail.com>
To: Alasdair Kergon <agk@redhat.com>
Date: Fri,  1 Apr 2022 00:02:36 +0200
Message-Id: <20220331220236.884887-2-jakobkoschel@gmail.com>
In-Reply-To: <20220331220236.884887-1-jakobkoschel@gmail.com>
References: <20220331220236.884887-1-jakobkoschel@gmail.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-Mailman-Approved-At: Mon, 04 Apr 2022 06:48:34 +0000
Subject: [dm-devel] [PATCH 2/2] dm: replace usage of found with dedicated
 list iterator variable
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
Cc: Mike Snitzer <snitzer@redhat.com>, Cristiano Giuffrida <c.giuffrida@vu.nl>,
 "Bos, H.J." <h.j.bos@vu.nl>, linux-kernel@vger.kernel.org, dm-devel@redhat.com,
 Jakob Koschel <jakobkoschel@gmail.com>,
 Brian Johannesmeyer <bjohannesmeyer@gmail.com>,
 Mike Rapoport <rppt@kernel.org>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

To move the list iterator variable into the list_for_each_entry_*()
macro in the future it should be avoided to use the list iterator
variable after the loop body.

To *never* use the list iterator variable after the loop it was
concluded to use a separate iterator variable instead of a
found boolean [1].

This removes the need to use a found variable and simply checking if
the variable was set, can determine if the break/goto was hit.

Link: https://lore.kernel.org/all/CAHk-=wgRr_D8CB-D9Kg-c=EHreAsk5SqXPwr9Y7k9sA6cWXJ6w@mail.gmail.com/ [1]
Signed-off-by: Jakob Koschel <jakobkoschel@gmail.com>
---
 drivers/md/dm-table.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index 03541cfc2317..9cf87954c05a 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -424,17 +424,16 @@ static int dm_set_device_limits(struct dm_target *ti, struct dm_dev *dev,
  */
 void dm_put_device(struct dm_target *ti, struct dm_dev *d)
 {
-	int found = 0;
 	struct list_head *devices = &ti->table->devices;
-	struct dm_dev_internal *dd;
+	struct dm_dev_internal *dd = NULL, *iter;
 
-	list_for_each_entry(dd, devices, list) {
-		if (dd->dm_dev == d) {
-			found = 1;
+	list_for_each_entry(iter, devices, list) {
+		if (iter->dm_dev == d) {
+			dd = iter;
 			break;
 		}
 	}
-	if (!found) {
+	if (!dd) {
 		DMWARN("%s: device %s not in table devices list",
 		       dm_device_name(ti->table->md), d->name);
 		return;
-- 
2.25.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

