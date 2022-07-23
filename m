Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B190AC433EF
	for <dm-devel@archiver.kernel.org>; Sat, 23 Jul 2022 13:12:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1658581940;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=yjnYDp30XCWoolRHXYDLIcLmpw9152vnlbZ8pn2brKk=;
	b=FqY/U2eIcvfnfMKrW2dTqSqBlDUPDjzp3Aj8H2/eqjfHfZTOZQqkxS7AcSfOl3Z4VnK7Un
	uBcPlSZvCyqDDJ6rEU5mMwY+tleM3jtMRvfz+pVrgiNAr1y9YN7r7KjMiTQ0afCnKY1+Cs
	1aRqE8ugkEmTdLDU0zYQ6HniU9Guj6k=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-648-WSPx1QLyN7OjUKhxS8R4Hw-1; Sat, 23 Jul 2022 09:12:17 -0400
X-MC-Unique: WSPx1QLyN7OjUKhxS8R4Hw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A99F0101A586;
	Sat, 23 Jul 2022 13:12:15 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 4D2462026D64;
	Sat, 23 Jul 2022 13:12:13 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 1749D1945D81;
	Sat, 23 Jul 2022 13:12:13 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 2905D1945D80
 for <dm-devel@listman.corp.redhat.com>; Sat, 23 Jul 2022 13:12:12 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 07DDB400E894; Sat, 23 Jul 2022 13:12:12 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 041AE40CFD0A
 for <dm-devel@redhat.com>; Sat, 23 Jul 2022 13:12:12 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DF750101A54E
 for <dm-devel@redhat.com>; Sat, 23 Jul 2022 13:12:11 +0000 (UTC)
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com
 [209.85.128.54]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-191-BYaUMsKXMHCc95sVucUhIg-1; Sat, 23 Jul 2022 09:12:08 -0400
X-MC-Unique: BYaUMsKXMHCc95sVucUhIg-1
Received: by mail-wm1-f54.google.com with SMTP id
 i205-20020a1c3bd6000000b003a2fa488efdso909439wma.4; 
 Sat, 23 Jul 2022 06:12:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
 :content-transfer-encoding;
 bh=DlsUyX12ay67qGK/k6ZeQMJaMpBklE16/HVLdVqpaRw=;
 b=xhHFX1swrU6chs+W6wijbOTapMebIsJsYrpHT7h8l6S4PPVVmeQIZz3qeXCq6KhR+d
 +9opXYxmQR3CqKDeCyrTN/wFzANGCN9+LjalmkPiWUIpugjyANZy1bRGkb2wDUH1aA/D
 /svB8sZB11VX1JxafgU706ZxA1FM0oBh7US+P7KA61q31IJqneBheNHl00tPGcV37oet
 Y4fw2Au8cngPR42FZ9+QUKTuO9ql4GnxF3x5Bu6M1bqS2+Jbai7CSCRw0hhVdoeP80AA
 Vh1i+3aweHX9jkNa4OFJQRR32tqp94cvg9JgUjC6m5fGEGjGGs3hrm4hRAFulqtc87jH
 Xjfg==
X-Gm-Message-State: AJIora83kZCWNhAuQ5XtefcZMcuwzAqBE0nMT5hfJeF7DswsxhAfWGPu
 PIJfjuzAZLbzpLIpFlE4Fw==
X-Google-Smtp-Source: AGRyM1uDw6CG9QDBNMIFqtk3TgDFLQ1rsMF3PcE/nYKRFtFyitHUWql4Z+dfBLzXAB8qYxub0iFhKg==
X-Received: by 2002:a05:600c:591:b0:3a3:205f:e2ca with SMTP id
 o17-20020a05600c059100b003a3205fe2camr2849036wmd.147.1658581926341; 
 Sat, 23 Jul 2022 06:12:06 -0700 (PDT)
Received: from localhost (51.red-81-44-172.dynamicip.rima-tde.net.
 [81.44.172.51]) by smtp.gmail.com with ESMTPSA id
 r5-20020a1c2b05000000b003a03be171b1sm8233693wmr.43.2022.07.23.06.12.05
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Sat, 23 Jul 2022 06:12:05 -0700 (PDT)
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
To: 
Date: Sat, 23 Jul 2022 15:12:04 +0200
Message-Id: <20220723131204.75409-1-xose.vazquez@gmail.com>
MIME-Version: 1.0
X-Patchwork-Bot: notify
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
Subject: [dm-devel] [PATCH v2] multipath-tools: add basic info on how to use
 multipath-tools with NVMe devices
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
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
 Xose Vazquez Perez <xose.vazquez@gmail.com>, Martin Wilck <mwilck@suse.com>,
 DM-DEVEL ML <dm-devel@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Cc: Martin Wilck <mwilck@suse.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: DM-DEVEL ML <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 README.md | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/README.md b/README.md
index 2322082c..b05b1332 100644
--- a/README.md
+++ b/README.md
@@ -174,3 +174,19 @@ To enable ALUA, the following options should be changed:
 
 - Huawei OceanStor:
    "Host Access Mode" should be changed to "Asymmetric".
+
+
+NVMe
+====
+To use Device Mapper/multipath-tools with NVMe devices,
+if the Native NVMe Multipath subsystem is enabled
+( "Y" in `/sys/module/nvme_core/parameters/multipath` ),
+it has to be disabled:
+
+`echo "options nvme_core multipath=N" > /etc/modprobe.d/01-nvme_core-mp.conf`,
+regenerate the initramfs (`dracut -f` or `update-initramfs`) and reboot.
+
+Check that it is disabled(N) with:
+`cat /sys/module/nvme_core/parameters/multipath`
+or
+`systool -m nvme_core -A multipath`
-- 
2.37.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

