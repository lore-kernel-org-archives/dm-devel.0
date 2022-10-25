Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A447AFA3740
	for <dm-devel@archiver.kernel.org>; Wed, 26 Oct 2022 07:03:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1666767785;
	h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 references:references:list-id:list-help:list-unsubscribe:
	 list-subscribe:list-post; bh=T/NOQK+gXt9F7HOHTygG/d8O+o1K8EuTchC/DFeBP20=;
	b=CYKZmAp9oBxIuRRwc5FirZvVLK7YkfzUaa4k7ZyBX9kArnw6++Rvtj0wMxW9ero2y0SDwF
	FnKwcmWzpPQSPEPpDZgiJVz6pUoF1PRXKEheBvG2CfVpo10L2Ieoqkdo6vyQBbGCn/dCHw
	POqR67c1EKKlDR4yN/GKsh6y977UlSM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-275-WdrMLDAPMvGkFZIqyu6Azw-1; Wed, 26 Oct 2022 03:03:00 -0400
X-MC-Unique: WdrMLDAPMvGkFZIqyu6Azw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6228D811E81;
	Wed, 26 Oct 2022 07:02:56 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id D261C2166B3A;
	Wed, 26 Oct 2022 07:02:53 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 3BEC01947054;
	Wed, 26 Oct 2022 07:02:42 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 914C91946597
 for <dm-devel@listman.corp.redhat.com>; Tue, 25 Oct 2022 11:52:33 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 5C8D440C6E13; Tue, 25 Oct 2022 11:52:33 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 54BC840C6EC6
 for <dm-devel@redhat.com>; Tue, 25 Oct 2022 11:52:33 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0624A2999B5A
 for <dm-devel@redhat.com>; Tue, 25 Oct 2022 11:52:33 +0000 (UTC)
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-364-1ZX6CM-WNPOTRDNKg69Hew-1; Tue, 25 Oct 2022 07:52:31 -0400
X-MC-Unique: 1ZX6CM-WNPOTRDNKg69Hew-1
Received: from epcas2p4.samsung.com (unknown [182.195.41.56])
 by mailout3.samsung.com (KnoxPortal) with ESMTP id
 20221025114547epoutp038ac6fd1dab3303ada2c79e4cb11b1599~hTVEb82pT0288802888epoutp03_
 for <dm-devel@redhat.com>; Tue, 25 Oct 2022 11:45:47 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com
 20221025114547epoutp038ac6fd1dab3303ada2c79e4cb11b1599~hTVEb82pT0288802888epoutp03_
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
 epcas2p2.samsung.com (KnoxPortal) with ESMTP id
 20221025114547epcas2p2e501c1bcd8f1f296b8a6562d1be55194~hTVDvNNs52435924359epcas2p24;
 Tue, 25 Oct 2022 11:45:47 +0000 (GMT)
Received: from epsmges2p3.samsung.com (unknown [182.195.36.68]) by
 epsnrtp3.localdomain (Postfix) with ESMTP id 4MxVWG5gr4z4x9Q3; Tue, 25 Oct
 2022 11:45:46 +0000 (GMT)
X-AuditID: b6c32a47-ac5b870000002127-60-6357cc6abbd7
Received: from epcas2p3.samsung.com ( [182.195.41.55]) by
 epsmges2p3.samsung.com (Symantec Messaging Gateway) with SMTP id
 42.DF.08487.A6CC7536; Tue, 25 Oct 2022 20:45:46 +0900 (KST)
Mime-Version: 1.0
From: Yonggil Song <yonggil.song@samsung.com>
To: "agk@redhat.com" <agk@redhat.com>, "snitzer@kernel.org"
 <snitzer@kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
X-Priority: 3
X-Content-Kind-Code: NORMAL
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <20221025114545epcms2p6f0a8fe05ae674709ebc6ea2f348abe3c@epcms2p6>
Date: Tue, 25 Oct 2022 20:45:45 +0900
X-CMS-MailID: 20221025114545epcms2p6f0a8fe05ae674709ebc6ea2f348abe3c
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrBKsWRmVeSWpSXmKPExsWy7bCmuW7WmfBkg0czBS3WnzrGbLH33WxW
 i8u75rBZnLglbTH1/BEmB1aPTas62Tze77vK5tG3ZRWjx+dNcgEsUdk2GamJKalFCql5yfkp
 mXnptkrewfHO8aZmBoa6hpYW5koKeYm5qbZKLj4Bum6ZOUBrlRTKEnNKgUIBicXFSvp2NkX5
 pSWpChn5xSW2SqkFKTkF5gV6xYm5xaV56Xp5qSVWhgYGRqZAhQnZGc2bAgrusVf86ixoYNzM
 1sXIySEhYCJx5eUi9i5GLg4hgR2MErM+f2LpYuTg4BUQlPi7QxikRlhAT2Le25nMILaQgJLE
 tQO9LBBxfYnNi5exg9hsAroSfzcsB5sjInCAUWJ6/3pmiAW8EjPan7JA2NIS25dvZYSwNSR+
 LOuFqhGVuLn6LTuM/f7YfKgaEYnWe2ehagQlHvzcDRWXlFh06DwThJ0v8XfFdahnaiS2NrRB
 xfUlrnVsBNvLK+ArMevHE7BeFgFViT/7N0Pd4yKxqeE42HxmAXmJ7W/nMIP8ziygKbF+lz6I
 KSGgLHHkFgtEBZ9Ex+G/7DBf7Zj3BGqTmsTmTZtZIWwZiQuP26Cu9JBY8uAUEyTYAiUWP37L
 OoFRfhYicGch2TsLYe8CRuZVjGKpBcW56anFRgXG8NhMzs/dxAhOclruOxhnvP2gd4iRiYPx
 EKMEB7OSCC/Lk+BkId6UxMqq1KL8+KLSnNTiQ4ymQB9PZJYSTc4Hptm8knhDE0sDEzMzQ3Mj
 UwNzJXHerhlayUIC6YklqdmpqQWpRTB9TBycUg1M7mKeUqU7d/78fmrrwZWCf/t47jscOrmP
 tVzp9Lt7PjKn7y3S/Cyhs2GG/Qojpl1fghi3X2AS5Gw/OWOVyhfjvMB3mxk6lFNkjvn4rZN+
 8a/yfWd0TNX9/Q82Hr/4qbdNK/Dopg+zNQLWLcxXeLlm2kzVxdNXTr+lIJ65+Ov31OnpOx++
 C+5anak4c22ele0txTuy+nkXV19cyqt34s/J6C+8bvVtS0tfGOQ/XLvuitnXTJ9M/Q2MTlrf
 /7Ok9xxcwNK4WvPVAa2esjv1053yjbh1FzE63m+wqTz2ML+rvbvg/sXdN1aqZv4Unb7Qc8la
 Z+FjaQU9b4zEMp3XMOQxOB3eqRYnbSAbt+77x4KubCWW4oxEQy3mouJEAAl5CFj7AwAA
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20221025114424epcms2p4e271ada9e2ce7a4992e908fc3a30167f
References: <CGME20221025114424epcms2p4e271ada9e2ce7a4992e908fc3a30167f@epcms2p6>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mailman-Approved-At: Wed, 26 Oct 2022 07:02:40 +0000
Subject: [dm-devel] [PATCH] dm table: fix typo in comment
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
Reply-To: yonggil.song@samsung.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Mimecast-Spam-Score: 1
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

integity -> integrity
in comment for dm_table_get_integrity_disk

Signed-off-by: Yonggil Song <yonggil.song@samsung.com>
---
 drivers/md/dm-table.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index d8034ff0cb24..be0a9024923d 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -1151,7 +1151,7 @@ static struct gendisk * dm_table_get_integrity_disk(struct dm_table *t)
  * underlying devices have an integrity profile.  But all devices may
  * not have matching profiles (checking all devices isn't reliable
  * during table load because this table may use other DM device(s) which
- * must be resumed before they will have an initialized integity
+ * must be resumed before they will have an initialized integrity
  * profile).  Consequently, stacked DM devices force a 2 stage integrity
  * profile validation: First pass during table load, final pass during
  * resume.
-- 
2.34.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

