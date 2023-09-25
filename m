Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 65090CD54BF
	for <dm-devel@archiver.kernel.org>; Mon, 25 Sep 2023 18:36:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1695666971;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=5hydBUz03Ve40+RFZJF7mo3xMeGULo0KeVGoSH/JXbk=;
	b=ixVa896Q+2QPDvgjC1LxaHoCdyR/SYDJoQsGjziJBJE1TpVhBN0tobOuaacRz4y6/ZIMoy
	s2amWWcBx99aUjgam6xznJ4cOLJ6Kqf1oUgbIdY1PCOv9v3jBx85ROrxngD+fXqUNPnH5U
	Pe4GvuKPYLTS6qQ/UeXIii4zHjzZQjU=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-691-9vLoyRYKPfCZ6GHaXo19Ng-1; Mon, 25 Sep 2023 14:36:09 -0400
X-MC-Unique: 9vLoyRYKPfCZ6GHaXo19Ng-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5D8AE101B047;
	Mon, 25 Sep 2023 18:36:07 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 46C9DC154CA;
	Mon, 25 Sep 2023 18:36:07 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id CA9FA19465A3;
	Mon, 25 Sep 2023 18:36:05 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 7E74B194658C
 for <dm-devel@listman.corp.redhat.com>; Mon, 25 Sep 2023 06:54:55 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 66A19711293; Mon, 25 Sep 2023 06:54:55 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 5EA1F711291
 for <dm-devel@redhat.com>; Mon, 25 Sep 2023 06:54:55 +0000 (UTC)
Received: from us-smtp-inbound-delivery-1.mimecast.com (us-smtp-1.mimecast.com
 [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3B3CD101A550
 for <dm-devel@redhat.com>; Mon, 25 Sep 2023 06:54:55 +0000 (UTC)
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com
 [209.85.219.202]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-183-ovfdhROQOjSEzdq3BNK90g-1; Mon, 25 Sep 2023 02:54:53 -0400
X-MC-Unique: ovfdhROQOjSEzdq3BNK90g-1
Received: by mail-yb1-f202.google.com with SMTP id
 3f1490d57ef6-d852a6749bcso8296006276.0
 for <dm-devel@redhat.com>; Sun, 24 Sep 2023 23:54:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20230601; t=1695624892; x=1696229692;
 h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
 :from:to:cc:subject:date:message-id:reply-to;
 bh=4qgvAyWUZmvKSaJjAnRidu6a0XvqHy58yVMteTj637s=;
 b=E2/mmuyQSmHvz2f/IBciWlkzmAKvalQX43UOMxQgM5rwHZptIYlJbRNkjxYKM9rwpd
 QugFDpeCmrdC54QIpQxSDy4rfxbMhglmvonp6KWpro1BE97TVJNrZgou3W4NSd6YVOND
 LLSsyknklQbKKmv/MDkf1xyqKkm3pebt0jnkkcrkYvMu8UexvUDSo0svoAWouMWC7c01
 QTTDiE3IHErxFRQrIDP6gn8cptjUOF6IRtR0N1fnMU4I99Ma/p85y5i5nlsWIJM9YNxX
 z+qDEvVoCZ8nDvugkbf8G47CkgIjH5RuYl9Mw1Uo4yrafFk4aKsDVF0Z+Dyta59f73iZ
 FbGw==
X-Gm-Message-State: AOJu0Yy9X47MRCEoTH4jiIFmlRCbqThINcvIGUy13WKq6b93Uq3vLlii
 89LuoaXva6mNsSmoc4vU8TLSR3wMjJuqzPW+xA==
X-Google-Smtp-Source: AGHT+IHh3Z2bhRl8t+p0wMHkCiMSmYA+8DreMQdFY+BpQD4KVns1eJVE9TT9Fv/XfJ0JWH6G9aD58bYeO2ylB6HfLQ==
X-Received: from jstitt-linux1.c.googlers.com
 ([fda3:e722:ac3:cc00:2b:ff92:c0a8:23b5])
 (user=justinstitt job=sendgmr) by 2002:a25:abac:0:b0:d81:fc08:29ea with SMTP
 id v41-20020a25abac000000b00d81fc0829eamr50788ybi.2.1695624892658; Sun, 24
 Sep 2023 23:54:52 -0700 (PDT)
Date: Mon, 25 Sep 2023 06:54:51 +0000
Mime-Version: 1.0
X-B4-Tracking: v=1; b=H4sIALouEWUC/x3MQQqEMAwAwK9Izgbaiqj7lcWDpFEDWiUR2UX8u
 8XjXOYCYxU2+BQXKJ9isqUMXxZA85AmRonZEFyoXBdqtEMT7X+MKier4RoxrigbHQsS8lCTd9w
 0XeshH7vyKL/3//b3/QDRb0d9bwAAAA==
X-Developer-Key: i=justinstitt@google.com; a=ed25519;
 pk=tC3hNkJQTpNX/gLKxTNQKDmiQl6QjBNCGKJINqAdJsE=
X-Developer-Signature: v=1; a=ed25519-sha256; t=1695624891; l=2033;
 i=justinstitt@google.com; s=20230717; h=from:subject:message-id;
 bh=Xzkm/GfG5TixyIwt6w7TZiwEMeENCaF2BkA9N23/JYw=;
 b=Pll71UQQ271YXI/KDgT1SxB3YKLk0+/ZGgantJ+FeHwnT8xz+5ogZmc5HFnm704SlWm1akCpq
 lljdGZ0RX37DLGe4jPvoXlZJ0ncg6zPG3SltsZPVIXUsB9kS4PDBH/N
Message-ID: <20230925-strncpy-drivers-md-dm-ioctl-c-v1-1-f0bfa093ef14@google.com>
From: Justin Stitt <justinstitt@google.com>
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
 dm-devel@redhat.com
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Mailman-Approved-At: Mon, 25 Sep 2023 18:36:03 +0000
Subject: [dm-devel] [PATCH] dm ioctl: replace deprecated strncpy with
 strscpy_pad
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
Cc: Justin Stitt <justinstitt@google.com>, linux-kernel@vger.kernel.org,
 linux-hardening@vger.kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: google.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

`strncpy` is deprecated for use on NUL-terminated destination strings
[1] and as such we should prefer more robust and less ambiguous string
interfaces.

We expect `spec->target_type` to be NUL-terminated based on its use with
a format string after `dm_table_add_target()` is called
| 	r = dm_table_add_target(table, spec->target_type,
| 				(sector_t) spec->sector_start,
| 				(sector_t) spec->length,
| 				target_params);
... wherein `spec->target_type` is passed as parameter `type` and later
printed with DMERR:
|       DMERR("%s: %s: unknown target type", dm_device_name(t->md), type);

It appears that `spec` is not zero-allocated and thus NUL-padding may be
required in this ioctl context.

Considering the above, a suitable replacement is `strscpy_pad` due to
the fact that it guarantees NUL-termination whilst maintaining the
NUL-padding behavior that strncpy provides.

Link: https://www.kernel.org/doc/html/latest/process/deprecated.html#strncpy-on-nul-terminated-strings [1]
Link: https://github.com/KSPP/linux/issues/90
Cc: linux-hardening@vger.kernel.org
Signed-off-by: Justin Stitt <justinstitt@google.com>
---
Note: build-tested only.
---
 drivers/md/dm-ioctl.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm-ioctl.c b/drivers/md/dm-ioctl.c
index 21ebb6c39394..e65058e0ed06 100644
--- a/drivers/md/dm-ioctl.c
+++ b/drivers/md/dm-ioctl.c
@@ -1295,8 +1295,8 @@ static void retrieve_status(struct dm_table *table,
 		spec->status = 0;
 		spec->sector_start = ti->begin;
 		spec->length = ti->len;
-		strncpy(spec->target_type, ti->type->name,
-			sizeof(spec->target_type) - 1);
+		strscpy_pad(spec->target_type, ti->type->name,
+			sizeof(spec->target_type));
 
 		outptr += sizeof(struct dm_target_spec);
 		remaining = len - (outptr - outbuf);

---
base-commit: 6465e260f48790807eef06b583b38ca9789b6072
change-id: 20230925-strncpy-drivers-md-dm-ioctl-c-ea5c10e77981

Best regards,
--
Justin Stitt <justinstitt@google.com>

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

