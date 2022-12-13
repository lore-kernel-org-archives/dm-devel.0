Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4FCE0C4167B
	for <dm-devel@archiver.kernel.org>; Tue, 13 Dec 2022 23:36:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1670974587;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=lQY86D8JUQ+j1+4AhqBuBfOpCyGuyZlMJQRaTQil3H0=;
	b=Bn0UgOe1Y6aWzV5KDzJQDZTkyYb7oaXJ0XeFJk4dSNlNoDGbH4T5Z06Upj8rO+Hx+T2X8L
	0bcBU6L3i3lL8uTK0Gl0Yajj11ZxjKK8kFxW8uEUoEIi8vdqzaZGCebfB69wItpUkLV8ZT
	IG+EyfLWwRYBL/TXRzLzQ5h0C9UWpKI=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-570-NWb33Z9GM9GA5Ef7AQX8_g-1; Tue, 13 Dec 2022 18:36:24 -0500
X-MC-Unique: NWb33Z9GM9GA5Ef7AQX8_g-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 79D0D3814956;
	Tue, 13 Dec 2022 23:36:22 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 69B3714171B6;
	Tue, 13 Dec 2022 23:36:22 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id C1E1C1946A48;
	Tue, 13 Dec 2022 23:36:19 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 8F1501946A45
 for <dm-devel@listman.corp.redhat.com>; Tue, 13 Dec 2022 23:36:10 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 6896C4085721; Tue, 13 Dec 2022 23:36:10 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 47A584085720;
 Tue, 13 Dec 2022 23:36:10 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
 by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 2BDNa8Zi008043;
 Tue, 13 Dec 2022 17:36:09 -0600
Received: (from bmarzins@localhost)
 by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 2BDNa89a008042;
 Tue, 13 Dec 2022 17:36:08 -0600
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Date: Tue, 13 Dec 2022 17:36:04 -0600
Message-Id: <1670974567-8005-1-git-send-email-bmarzins@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
Subject: [dm-devel] [PATCH 0/3] multipath config fixes
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
Cc: device-mapper development <dm-devel@redhat.com>,
 Martin Wilck <Martin.Wilck@suse.com>
MIME-Version: 1.0
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

The first two patches are a cleanup and a fix for a memory leak in the
config code. The third patch improves multipath's validation of the
strings it passes directly into the table, features, path_selector, and
hardware_handler.  These three strings all have argument counts, and
getting them wrong causes the kernel to parse the table incorrectly.
When this happens the table load fails, but the error messages from the
kernel are often completely unhelpful.  A bad argument count will cause
the rest of the table to be parsed incorrectly, and the kernel might not
hit an unworkable token till later in the parsing.  Multipath now makes
sure that the count matches the actual number of arguments that it is
passing.

Benjamin Marzinski (3):
  libmpathutil: simplify set_value
  libmultipath: don't leak memory on invalid strings
  libmutipath: validate the argument count of config strings

 libmpathutil/parser.c |  64 ++++++++----------------
 libmultipath/dict.c   | 112 ++++++++++++++++++++++++++++++++++++++----
 2 files changed, 124 insertions(+), 52 deletions(-)

-- 
2.17.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

