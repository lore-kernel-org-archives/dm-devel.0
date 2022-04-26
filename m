Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 48F5EC433EF
	for <dm-devel@archiver.kernel.org>; Tue, 26 Apr 2022 12:09:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1650974967;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=iSLJisXQfM1z2aYZGYoHK9noXAy2HT6PbRdG4R8lKWY=;
	b=PB9X+WwDKAESWP/Aj2Y+rl/UurXWqpO6Phd1QPcRJCNO9beWAC1Nh2bUQAy3NEqMDclfvM
	laYF+NuqRTIAW2nBnt4+U39E1cX3RQFqWh0JVjcnTXOwJgx/VkT6WRHjkFP18xZxYhvDtO
	cxVk84N/rVqTI9M3F/EED2Xs73zJcFU=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-587-4yng9XvWPvuxeQLGzS4FqA-1; Tue, 26 Apr 2022 08:09:25 -0400
X-MC-Unique: 4yng9XvWPvuxeQLGzS4FqA-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5932F2999B49;
	Tue, 26 Apr 2022 12:08:39 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id F27DD469A69;
	Tue, 26 Apr 2022 12:08:20 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id C0D961940355;
	Tue, 26 Apr 2022 12:08:17 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id C52201940355
 for <dm-devel@listman.corp.redhat.com>; Tue, 26 Apr 2022 12:08:16 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 1B97B2024CDB; Tue, 26 Apr 2022 12:08:16 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com
 (file01.intranet.prod.int.rdu2.redhat.com [10.11.5.7])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 741342024CB7;
 Tue, 26 Apr 2022 12:08:02 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (localhost [127.0.0.1])
 by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4) with ESMTP id
 23QC7wg9003342; Tue, 26 Apr 2022 08:07:58 -0400
Received: from localhost (mpatocka@localhost)
 by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4/Submit) with ESMTP
 id 23QC7nbX003337; Tue, 26 Apr 2022 08:07:52 -0400
X-Authentication-Warning: file01.intranet.prod.int.rdu2.redhat.com: mpatocka
 owned process doing -bs
Date: Tue, 26 Apr 2022 08:07:44 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To: Andy Shevchenko <andy.shevchenko@gmail.com>
In-Reply-To: <CAHp75VdHnvv6FH1BKcs8WgGF3nJpj77TsrmsQGBSpsAQU_S-bw@mail.gmail.com>
Message-ID: <alpine.LRH.2.02.2204260759540.2737@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.2204241643030.17244@file01.intranet.prod.int.rdu2.redhat.com>
 <CAHp75VdHnvv6FH1BKcs8WgGF3nJpj77TsrmsQGBSpsAQU_S-bw@mail.gmail.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
Subject: [dm-devel] [PATCH v2] hex2bin: fix access beyond string end
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
Cc: Andy Shevchenko <andy@kernel.org>, Mike Snitzer <msnitzer@redhat.com>,
 Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
 Mimi Zohar <zohar@linux.ibm.com>,
 device-mapper development <dm-devel@redhat.com>,
 Linus Torvalds <torvalds@linux-foundation.org>,
 Milan Broz <gmazyland@gmail.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit



On Tue, 26 Apr 2022, Andy Shevchenko wrote:

> On Sun, Apr 24, 2022 at 10:48 PM Mikulas Patocka <mpatocka@redhat.com> wrote:
> >
> > If we pass too short string to "hex2bin" (and the string size without the
> > terminating NUL character is even), "hex2bin" reads one byte after the
> > terminating NUL character. This patch fixes it.
> >
> > Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> > Cc: stable@vger.kernel.org
> 
> You need to provide a Fixes tag.

OK. Here I resend it with the "Fixes" tag.

> And on top of that it would be nice to understand if we need to
> support half-bytes, but in any case it's not a scope of the patch
> right now.

Do you think that there are any users who need this?

> -- 
> With Best Regards,
> Andy Shevchenko

Mikulas



From: Mikulas Patocka <mpatocka@redhat.com>

If we pass too short string to "hex2bin" (and the string size without the
terminating NUL character is even), "hex2bin" reads one byte after the
terminating NUL character. This patch fixes it.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Fixes: b78049831ffe ("lib: add error checking to hex2bin")
Cc: stable@vger.kernel.org

---
 lib/hexdump.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

Index: linux-2.6/lib/hexdump.c
===================================================================
--- linux-2.6.orig/lib/hexdump.c	2022-04-24 18:51:16.000000000 +0200
+++ linux-2.6/lib/hexdump.c	2022-04-24 18:51:16.000000000 +0200
@@ -45,10 +45,13 @@ EXPORT_SYMBOL(hex_to_bin);
 int hex2bin(u8 *dst, const char *src, size_t count)
 {
 	while (count--) {
-		int hi = hex_to_bin(*src++);
-		int lo = hex_to_bin(*src++);
+		int hi, lo;
 
-		if ((hi < 0) || (lo < 0))
+		hi = hex_to_bin(*src++);
+		if (hi < 0)
+			return -EINVAL;
+		lo = hex_to_bin(*src++);
+		if (lo < 0)
 			return -EINVAL;
 
 		*dst++ = (hi << 4) | lo;
--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

