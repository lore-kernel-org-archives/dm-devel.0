Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6AC8CECD643
	for <dm-devel@archiver.kernel.org>; Fri, 18 Aug 2023 00:00:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1692316815;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=qFrrvTaBGC3xNYDyE+4HeRTKuQ7A2lljxiAMQJ3qO4s=;
	b=DBzAq8aBSNxKndq0cECIqV5KgPyE9y2wC2slxmQvgnhVAL0PE3s3rCPONwB6tgVFtif2lG
	es9Q/CizAsofPs13OPreS5Xf1ZfTlLh68llw0N6K3Hnkoh+Ir8ZTDn/NCVyfqDcGER8FsB
	pkZhQM/Powv84i/qRjaz7vn/dLqNEl0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-335-nMAkY7sXN3G7h0MjTkcwyg-1; Thu, 17 Aug 2023 20:00:11 -0400
X-MC-Unique: nMAkY7sXN3G7h0MjTkcwyg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EA559800270;
	Fri, 18 Aug 2023 00:00:09 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id D92BD40C207C;
	Fri, 18 Aug 2023 00:00:05 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 8B5D71946588;
	Fri, 18 Aug 2023 00:00:05 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 44FEF1946587
 for <dm-devel@listman.corp.redhat.com>; Fri, 18 Aug 2023 00:00:04 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 1C4AE1121318; Fri, 18 Aug 2023 00:00:04 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 1437C1121314
 for <dm-devel@redhat.com>; Fri, 18 Aug 2023 00:00:04 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EBD411C06EE0
 for <dm-devel@redhat.com>; Fri, 18 Aug 2023 00:00:03 +0000 (UTC)
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com
 [209.85.214.173]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-464-UIEVtwXtPXWuP_cN6NXEHw-1; Thu, 17 Aug 2023 19:59:59 -0400
X-MC-Unique: UIEVtwXtPXWuP_cN6NXEHw-1
Received: by mail-pl1-f173.google.com with SMTP id
 d9443c01a7336-1bbc87ded50so2971935ad.1
 for <dm-devel@redhat.com>; Thu, 17 Aug 2023 16:59:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1692316799; x=1692921599;
 h=content-transfer-encoding:mime-version:message-id:date:subject:cc
 :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
 :reply-to;
 bh=FlZwTjULNXL0MSeceST2nTPY5dYfoFRLbfS9U1Zv9es=;
 b=GTCUXPT3nn0hhlJYmSCkcdlCHfB6bsT/WotmpwZVtkN8wWujqV+Qr2/bRQ2R3k6cic
 mDkqcCAeltzg98BUYegLNpVabZFKfByGMlG2tri7VJjm0nE5a/qBD6EkOHATvEizznv2
 uRyurTgLQpC1Jq7PyU4yanSDBMIkAyk9/phQ+Kzmfm5swPud33A6yrofawjplIFe8XBS
 jQUeyH5p7Ikdr+SFnsdrOsIFvhJyEXSa9xYSJuXO22ILv0aqAtaEDbcys7uTWnVuwR5t
 tsFZ4nBdtYG/t1FLOZa8RcLyPenKcAjfEj0rACM2NmzY8UfWOBMwuLa6QP6Sg6d6Zqik
 uhcw==
X-Gm-Message-State: AOJu0Yygt3cWpArcG7QgkuiY1GMLkBsn6INaRnuO95DRyd4nd0j1FNX0
 WU5bVw7rM6JbZ0BYjEPbib24nA==
X-Google-Smtp-Source: AGHT+IEZN0eiMgoFeTiDuL98J12BoFQXzUyH1iR9WfEu30+aZRIx+2aMlLrOvoBZVZz8HJbKs8MMbw==
X-Received: by 2002:a17:903:247:b0:1bb:1523:b2d7 with SMTP id
 j7-20020a170903024700b001bb1523b2d7mr1064631plh.14.1692316798858; 
 Thu, 17 Aug 2023 16:59:58 -0700 (PDT)
Received: from www.outflux.net (198-0-35-241-static.hfc.comcastbusiness.net.
 [198.0.35.241]) by smtp.gmail.com with ESMTPSA id
 b10-20020a170902bd4a00b001bba669a7eesm348680plx.52.2023.08.17.16.59.58
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 17 Aug 2023 16:59:58 -0700 (PDT)
From: Kees Cook <keescook@chromium.org>
To: linux-hardening@vger.kernel.org
Date: Thu, 17 Aug 2023 16:59:56 -0700
Message-Id: <20230817235955.never.762-kees@kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2198; i=keescook@chromium.org; 
 h=from:subject:message-id;
 bh=TlZvULm9TYJxvzYvyHtGp79eQ9cs52J2eowJQXxaQlQ=; 
 b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBk3rR8Jpb6jYCE1H2Z7r1VdMRPlT4IoaSG9P+6O
 TraiYv2JDeJAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCZN60fAAKCRCJcvTf3G3A
 JjIHD/44aHrnkkewA1A9a8OG6hGVMYANzESYfUGAA9dl8IaTcUf5hz6awlrlkNt19soLhhGXaxf
 6zZZK3951OIkAIYfKrjp48XoTFOKI47ha4xWcryisDbf/lBUlQ6K2ALIFp2ZBobJko9KmWFRxEu
 r6rBph5S6FqVIJVZPG2xFFxsd4lYyuD2jXO/1O8xnS6ismHiTUMbYOUcRgg9nwR+iZmHYFYMDNa
 S2MZ/a7mqLSK3+rg8Ffsq0D8hTy0DP/fSQLLiZ73LWFe2Un8IvI78NYawzPNoBV6prHXxLdJphU
 DSjmWKtlrOmsJO7mEk9ipaIDkC0bnBkXv9TzXjvtwSpy0RrHgPmIr9VEou5TwHceriaF/OwIrc3
 aSGyVXXILMWSq7cvXiAiPkJFxpQgVmYN1aHl2rb4O2hlQ34EphuiDLTOJriwowTTCcd81btCfpg
 ue37gNf40o92kdqIkxIeg2BWmyuWCKVsCeH67+FgE3jIOFn8eqq31yhYwA1qy7+ZJz+UDJkWKrx
 r42QK0aS3ebKJ6Kt0oal+a0ZsPp6bhhU2ticTpo0kKWKmpsZZg5v9leTKD1TOciwblKRJCERaYC
 2YuuoTR0bS+GC/8nQOg9/q76Mny1hU02LM69MiCaJwH1oNPqJGyCm95eW1Sm3G/ONjIa1Cks+BO
 UK26fPZ LQjP69ig==
X-Developer-Key: i=keescook@chromium.org; a=openpgp;
 fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
Subject: [dm-devel] [PATCH] LoadPin: Annotate struct
 dm_verity_loadpin_trusted_root_digest with __counted_by
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
Cc: linux-security-module@vger.kernel.org, Kees Cook <keescook@chromium.org>,
 Nick Desaulniers <ndesaulniers@google.com>, llvm@lists.linux.dev,
 Mike Snitzer <snitzer@kernel.org>, James Morris <jmorris@namei.org>,
 linux-kernel@vger.kernel.org, Nathan Chancellor <nathan@kernel.org>,
 dm-devel@redhat.com, Tom Rix <trix@redhat.com>,
 "Serge E. Hallyn" <serge@hallyn.com>, Alasdair Kergon <agk@redhat.com>,
 Paul Moore <paul@paul-moore.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: chromium.org
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Prepare for the coming implementation by GCC and Clang of the __counted_by
attribute. Flexible array members annotated with __counted_by can have
their accesses bounds-checked at run-time checking via CONFIG_UBSAN_BOUNDS
(for array indexing) and CONFIG_FORTIFY_SOURCE (for strcpy/memcpy-family
functions).

As found with Coccinelle[1], add __counted_by for struct dm_verity_loadpin_trusted_root_digest.
Additionally, since the element count member must be set before accessing
the annotated flexible array member, move its initialization earlier.

[1] https://github.com/kees/kernel-tools/blob/trunk/coccinelle/examples/counted_by.cocci

Cc: Alasdair Kergon <agk@redhat.com>
Cc: Mike Snitzer <snitzer@kernel.org>
Cc: dm-devel@redhat.com
Cc: Paul Moore <paul@paul-moore.com>
Cc: James Morris <jmorris@namei.org>
Cc: "Serge E. Hallyn" <serge@hallyn.com>
Cc: linux-security-module@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 include/linux/dm-verity-loadpin.h | 2 +-
 security/loadpin/loadpin.c        | 3 +--
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/include/linux/dm-verity-loadpin.h b/include/linux/dm-verity-loadpin.h
index 552b817ab102..3ac6dbaeaa37 100644
--- a/include/linux/dm-verity-loadpin.h
+++ b/include/linux/dm-verity-loadpin.h
@@ -12,7 +12,7 @@ extern struct list_head dm_verity_loadpin_trusted_root_digests;
 struct dm_verity_loadpin_trusted_root_digest {
 	struct list_head node;
 	unsigned int len;
-	u8 data[];
+	u8 data[] __counted_by(len);
 };
 
 #if IS_ENABLED(CONFIG_SECURITY_LOADPIN_VERITY)
diff --git a/security/loadpin/loadpin.c b/security/loadpin/loadpin.c
index ebae964f7cc9..a9d40456a064 100644
--- a/security/loadpin/loadpin.c
+++ b/security/loadpin/loadpin.c
@@ -336,6 +336,7 @@ static int read_trusted_verity_root_digests(unsigned int fd)
 			rc = -ENOMEM;
 			goto err;
 		}
+		trd->len = len;
 
 		if (hex2bin(trd->data, d, len)) {
 			kfree(trd);
@@ -343,8 +344,6 @@ static int read_trusted_verity_root_digests(unsigned int fd)
 			goto err;
 		}
 
-		trd->len = len;
-
 		list_add_tail(&trd->node, &dm_verity_loadpin_trusted_root_digests);
 	}
 
-- 
2.34.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

