Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8C534C63797
	for <dm-devel@archiver.kernel.org>; Mon,  6 Feb 2023 07:38:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1675669122;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=qMEjuSXESbeD/bGpQH6U6jjapwxjRqujD6YV2GhkocY=;
	b=NQzr8Ydpd6BXAoeUfaqlmNKVRelX1bPuIAtlGSURSbe9BOCl6eJDHeepz+xhprXP9jTL5+
	aUQxM3+urofSo7PmWiy9nmdmu6+Ok+zbgPSD4Xqq+JMqePjjtoRw+yEZLEMaMP2mB182pi
	315EdOwudDBVY6D0IBaRZ0iWb9cBvP4=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-553-O2mWtltKMluB6G0d_iUU9A-1; Mon, 06 Feb 2023 02:38:39 -0500
X-MC-Unique: O2mWtltKMluB6G0d_iUU9A-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2C6CC1C05AEE;
	Mon,  6 Feb 2023 07:38:36 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 892A2C15BA0;
	Mon,  6 Feb 2023 07:38:34 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 6818519465B8;
	Mon,  6 Feb 2023 07:38:33 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 3AF901946586
 for <dm-devel@listman.corp.redhat.com>; Thu,  2 Feb 2023 17:08:40 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 1D3DD112132D; Thu,  2 Feb 2023 17:08:40 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 16108112132C
 for <dm-devel@redhat.com>; Thu,  2 Feb 2023 17:08:40 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E4A2C29AA2E5
 for <dm-devel@redhat.com>; Thu,  2 Feb 2023 17:08:39 +0000 (UTC)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-505-QGkzjedSNHWev6rwFd7y1g-1; Thu, 02 Feb 2023 12:08:38 -0500
X-MC-Unique: QGkzjedSNHWev6rwFd7y1g-1
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id 3271BB82753;
 Thu,  2 Feb 2023 17:00:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E265C433EF;
 Thu,  2 Feb 2023 17:00:12 +0000 (UTC)
From: Nathan Chancellor <nathan@kernel.org>
Date: Thu, 02 Feb 2023 09:58:18 -0700
MIME-Version: 1.0
Message-Id: <20230202-dm-parenthesis-warning-v1-1-ebdee213eeb9@kernel.org>
X-B4-Tracking: v=1; b=H4sIAKnr22MC/x2NywqDUAxEf0WybsBXC/ZXShe5Gr1ZGCWRtiD+e
 6ObgcPMYXZwNmGHZ7GD8UdcFg2obgX0mXRilCEY6rJuyggcZlzJWLfMLo5fMhWd8FE13dime2w
 ShJzIGZOR9vnUZ/KN7SxW41F+1+PrfRx/R+eoXoEAAAA=
To: agk@redhat.com, snitzer@kernel.org
X-Developer-Signature: v=1; a=openpgp-sha256; l=2222; i=nathan@kernel.org;
 h=from:subject:message-id; bh=KhsHJGMkk85ln+sCx+d+Nxt6KslFX/d/TmJqhuW9H0g=;
 b=owGbwMvMwCEmm602sfCA1DTG02pJDMm338jMyt3ak5ZoWjp1c+GeSq9vPRens7H8jzrROD1P9
 uQ77t3cHaUsDGIcDLJiiizVj1WPGxrOOct449QkmDmsTCBDGLg4BWAiBQkM/8y6D75Usbo+qfwp
 271TURstM0onidn9TX6x/ef1UG3GkzGMDKc7vxoLrJXUeSF7yEvw4PyG5Ct+Ex7svLB+5YOr1zn
 KvDkA
X-Developer-Key: i=nathan@kernel.org; a=openpgp;
 fpr=2437CB76E544CB6AB3D9DFD399739260CB6CB716
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Mailman-Approved-At: Mon, 06 Feb 2023 07:38:31 +0000
Subject: [dm-devel] [PATCH] dm flakey: Fix clang -Wparentheses-equality in
 flakey_map()
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
Cc: trix@redhat.com, llvm@lists.linux.dev, ndesaulniers@google.com,
 linux-kernel@vger.kernel.org, patches@lists.linux.dev,
 Nathan Chancellor <nathan@kernel.org>, dm-devel@redhat.com,
 mpatocka@redhat.com, sweettea-kernel@dorminy.me
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Clang warns:

  ../drivers/md/dm-flakey.c:369:28: error: equality comparison with extraneous parentheses [-Werror,-Wparentheses-equality]
                          if ((fc->corrupt_bio_rw == WRITE)) {
                               ~~~~~~~~~~~~~~~~~~~^~~~~~~~
  ../drivers/md/dm-flakey.c:369:28: note: remove extraneous parentheses around the comparison to silence this warning
                          if ((fc->corrupt_bio_rw == WRITE)) {
                              ~                   ^       ~
  ../drivers/md/dm-flakey.c:369:28: note: use '=' to turn this equality comparison into an assignment
                          if ((fc->corrupt_bio_rw == WRITE)) {
                                                  ^~
                                                  =
  1 error generated.

GCC only warns when one set of parentheses are used for assignment
expressions, whereas clang additionally warns when two sets of
parentheses are used for equality comparisons. Remove the extra set of
parentheses to silence the warning as it suggests, as this is obviously
supposed to be an equality comparison.

Fixes: 0e766389cedc ("dm flakey: fix logic when corrupting a bio")
Link: https://github.com/ClangBuiltLinux/linux/issues/1798
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
I do not mind this change being squashed with the offending commit, as I
noticed it was Cc'd for stable, which would minimize the chance for
breakage.
---
 drivers/md/dm-flakey.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/dm-flakey.c b/drivers/md/dm-flakey.c
index 08f9aa476d97..335684a1aeaa 100644
--- a/drivers/md/dm-flakey.c
+++ b/drivers/md/dm-flakey.c
@@ -366,7 +366,7 @@ static int flakey_map(struct dm_target *ti, struct bio *bio)
 		 * Corrupt matching writes.
 		 */
 		if (fc->corrupt_bio_byte) {
-			if ((fc->corrupt_bio_rw == WRITE)) {
+			if (fc->corrupt_bio_rw == WRITE) {
 				if (all_corrupt_bio_flags_match(bio, fc))
 					corrupt_bio_data(bio, fc);
 			}

---
base-commit: 6f30cc248507ee96c22ff4c3cbc86099ff12b7a9
change-id: 20230202-dm-parenthesis-warning-6139f4b5020b

Best regards,
-- 
Nathan Chancellor <nathan@kernel.org>

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

