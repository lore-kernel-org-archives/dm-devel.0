Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 67562EB64DC
	for <dm-devel@archiver.kernel.org>; Wed, 28 Jun 2023 00:07:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1687910860;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=QqrHut16+0+2I5NVC2cgk8oVuQx78WzqKw5Kra4jyv4=;
	b=J1fdOqMxRBalXy67Y0iMrmid5H9dh2AYEpAF9K5xKs4OwVSfXdI7W1HtCmyP25+GbdB8rt
	VtyVTpXTUncGesbMSJoo/TFpxK7ewcCjuD3uJ4wtIthhnjm16O/wRtCvnTEjQxUhhokkfx
	16FgPb6yYjVmKZuGsodtEVozYcwUx7M=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-669-tuJn4SxGMoKBbVKyk0rfCg-1; Tue, 27 Jun 2023 20:07:37 -0400
X-MC-Unique: tuJn4SxGMoKBbVKyk0rfCg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 49E583802148;
	Wed, 28 Jun 2023 00:07:33 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 3804415230A0;
	Wed, 28 Jun 2023 00:07:33 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 54EEE19465BC;
	Wed, 28 Jun 2023 00:07:31 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id D1A781946586
 for <dm-devel@listman.corp.redhat.com>; Tue, 27 Jun 2023 20:28:52 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id E97D840C206F; Tue, 27 Jun 2023 20:28:51 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id E0D1A40C2063
 for <dm-devel@redhat.com>; Tue, 27 Jun 2023 20:28:51 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0C5E11011630
 for <dm-devel@redhat.com>; Tue, 27 Jun 2023 20:28:51 +0000 (UTC)
Received: from mail-io1-f51.google.com (mail-io1-f51.google.com
 [209.85.166.51]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-215-aQo2I0z3MG6B7Aq_MLpvCg-1; Tue, 27 Jun 2023 16:28:49 -0400
X-MC-Unique: aQo2I0z3MG6B7Aq_MLpvCg-1
Received: by mail-io1-f51.google.com with SMTP id
 ca18e2360f4ac-78372b896d0so52178039f.2
 for <dm-devel@redhat.com>; Tue, 27 Jun 2023 13:28:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1687897728; x=1690489728;
 h=content-transfer-encoding:mime-version:message-id:date:subject:cc
 :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
 :reply-to;
 bh=PFLrb4WV2M4S89RJ5tGpysGkvtpZPYvXfwu8Q/oJAtk=;
 b=lpVRqn0EhenP6qGIKII8ifBOVsFtIdfY2JZCST+zxgXQqwDGHo5E+8CcS4ZTFC56g9
 Wc3U8GpfS3MNKFMyLQe8azwkiTTZx2CGtAGBYvXBR49PLpy+jeZKQuBAhTYtaEh5IYIK
 Q024jQOZX7Gs6V5Y4gkDmCnfpSmMS+6CpXXgYYRa3dtrvBfBujlZhvCeq9SK0unqmcyg
 um00s2nhea7QFc9pWSukESbWgJd9l665PIxnCn59SfoCidKo9zRTuML7jU89vL3ocCYK
 bGOo9E/5Rs8UShYHP4CRswmi4IAdx0CUo60DfRZ7us6DeGyb7Nn+8ED1/W1EUXHaEnst
 t46A==
X-Gm-Message-State: AC+VfDyRRa+chrSE2i5qf2Yc05Gm4i+XzYGKKfn6TA20DG6VVcjCOS0R
 5RMa/0i4dzl/MlfOBYpmsffs3/6TeDL9m1J7Dds=
X-Google-Smtp-Source: ACHHUZ4CnWXfi9m6352atFGPgRiUKQ3JmiGDS7T3mcdhVwx+G6CYu1eAyxSrRz6q3TcqDXotxz0Gcg==
X-Received: by 2002:a92:d08a:0:b0:345:8373:4ca8 with SMTP id
 h10-20020a92d08a000000b0034583734ca8mr10285835ilh.27.1687897728420; 
 Tue, 27 Jun 2023 13:28:48 -0700 (PDT)
Received: from localhost (30.23.70.34.bc.googleusercontent.com. [34.70.23.30])
 by smtp.gmail.com with UTF8SMTPSA id
 k11-20020a02c64b000000b0042ae80a56d6sm387463jan.73.2023.06.27.13.28.48
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Tue, 27 Jun 2023 13:28:48 -0700 (PDT)
From: Matthias Kaehlcke <mka@chromium.org>
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
 Kees Cook <keescook@chromium.org>
Date: Tue, 27 Jun 2023 20:28:01 +0000
Message-ID: <20230627202800.1.Id63f7f59536d20f1ab83e1abdc1fda1471c7d031@changeid>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Mailman-Approved-At: Wed, 28 Jun 2023 00:07:30 +0000
Subject: [dm-devel] [PATCH] dm: verity-loadpin: Add NULL pointer check for
 'bdev' parameter
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
Cc: dm-devel@redhat.com, Matthias Kaehlcke <mka@chromium.org>,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: chromium.org
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Add a NULL check for the 'bdev' parameter of
dm_verity_loadpin_is_bdev_trusted(). The function is called
by loadpin_check(), which passes the block device that
corresponds to the super block of the file system from which
a file is being loaded. Generally a super_block structure has
an associated block device, however that is not always the
case (e.g. tmpfs).

Cc: stable@vger.kernel.org # v6.0+
Fixes: b6c1c5745ccc ("dm: Add verity helpers for LoadPin")
Signed-off-by: Matthias Kaehlcke <mka@chromium.org>
---

 drivers/md/dm-verity-loadpin.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/md/dm-verity-loadpin.c b/drivers/md/dm-verity-loadpin.c
index 4f78cc55c251..0666699b6858 100644
--- a/drivers/md/dm-verity-loadpin.c
+++ b/drivers/md/dm-verity-loadpin.c
@@ -58,6 +58,9 @@ bool dm_verity_loadpin_is_bdev_trusted(struct block_device *bdev)
 	int srcu_idx;
 	bool trusted = false;
 
+	if (bdev == NULL)
+		return false;
+
 	if (list_empty(&dm_verity_loadpin_trusted_root_digests))
 		return false;
 
-- 
2.41.0.255.g8b1d071c50-goog

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

