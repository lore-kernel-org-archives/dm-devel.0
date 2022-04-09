Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 84FF8C433EF
	for <dm-devel@archiver.kernel.org>; Sat,  9 Apr 2022 05:28:58 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-643-hzMr2OCQOCGiN8PN90bmQA-1; Sat, 09 Apr 2022 01:28:54 -0400
X-MC-Unique: hzMr2OCQOCGiN8PN90bmQA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8F3F2101A52C;
	Sat,  9 Apr 2022 05:28:52 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 40E29200D8D1;
	Sat,  9 Apr 2022 05:28:52 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id F12B81940349;
	Sat,  9 Apr 2022 05:28:51 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 0A9DE1940349
 for <dm-devel@listman.corp.redhat.com>; Sat,  9 Apr 2022 05:28:49 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id DEC301402642; Sat,  9 Apr 2022 05:28:49 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id DAC801415131
 for <dm-devel@redhat.com>; Sat,  9 Apr 2022 05:28:49 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C15A580005D
 for <dm-devel@redhat.com>; Sat,  9 Apr 2022 05:28:49 +0000 (UTC)
Received: from bombadil.infradead.org (bombadil.infradead.org
 [198.137.202.133]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-124-8YOqMu1vOb25mFwt4S8Omw-1; Sat, 09 Apr 2022 01:28:48 -0400
X-MC-Unique: 8YOqMu1vOb25mFwt4S8Omw-1
Received: from 213-147-167-116.nat.highway.webapn.at ([213.147.167.116]
 helo=localhost)
 by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
 id 1nd33z-0020bF-0B; Sat, 09 Apr 2022 04:51:07 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Date: Sat,  9 Apr 2022 06:50:22 +0200
Message-Id: <20220409045043.23593-7-hch@lst.de>
In-Reply-To: <20220409045043.23593-1-hch@lst.de>
References: <20220409045043.23593-1-hch@lst.de>
MIME-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by
 bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
Subject: [dm-devel] [PATCH 06/27] drbd: use bdev_alignment_offset instead of
 queue_alignment_offset
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
Cc: jfs-discussion@lists.sourceforge.net, linux-nvme@lists.infradead.org,
 virtualization@lists.linux-foundation.org, linux-mm@kvack.org,
 dm-devel@redhat.com, target-devel@vger.kernel.org,
 linux-mtd@lists.infradead.org, drbd-dev@lists.linbit.com,
 linux-s390@vger.kernel.org, linux-nilfs@vger.kernel.org,
 linux-scsi@vger.kernel.org, cluster-devel@redhat.com,
 xen-devel@lists.xenproject.org, linux-ext4@vger.kernel.org,
 linux-um@lists.infradead.org, nbd@other.debian.org,
 linux-block@vger.kernel.org, linux-bcache@vger.kernel.org,
 ceph-devel@vger.kernel.org, linux-raid@vger.kernel.org,
 linux-mmc@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
 linux-xfs@vger.kernel.org,
 =?UTF-8?q?Christoph=20B=C3=B6hmwalder?= <christoph.boehmwalder@linbit.com>,
 ocfs2-devel@oss.oracle.com, linux-fsdevel@vger.kernel.org,
 ntfs3@lists.linux.dev, linux-btrfs@vger.kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

VGhlIGJkZXYgdmVyc2lvbiBkb2VzIHRoZSByaWdodCB0aGluZyBmb3IgcGFydGl0aW9ucywgc28g
dXNlIHRoYXQuCgpGaXhlczogOTEwNGQzMWE3NTlmICgiZHJiZDogaW50cm9kdWNlIFdSSVRFX1NB
TUUgc3VwcG9ydCIpClNpZ25lZC1vZmYtYnk6IENocmlzdG9waCBIZWxsd2lnIDxoY2hAbHN0LmRl
PgpBY2tlZC1ieTogQ2hyaXN0b3BoIELDtmhtd2FsZGVyIDxjaHJpc3RvcGguYm9laG13YWxkZXJA
bGluYml0LmNvbT4KLS0tCiBkcml2ZXJzL2Jsb2NrL2RyYmQvZHJiZF9tYWluLmMgfCAyICstCiAx
IGZpbGUgY2hhbmdlZCwgMSBpbnNlcnRpb24oKyksIDEgZGVsZXRpb24oLSkKCmRpZmYgLS1naXQg
YS9kcml2ZXJzL2Jsb2NrL2RyYmQvZHJiZF9tYWluLmMgYi9kcml2ZXJzL2Jsb2NrL2RyYmQvZHJi
ZF9tYWluLmMKaW5kZXggYWEyYzIxYWViNzQ3Yy4uZWFlNjI5YzRmNmVhZiAxMDA2NDQKLS0tIGEv
ZHJpdmVycy9ibG9jay9kcmJkL2RyYmRfbWFpbi5jCisrKyBiL2RyaXZlcnMvYmxvY2svZHJiZC9k
cmJkX21haW4uYwpAQCAtOTM5LDcgKzkzOSw3IEBAIGludCBkcmJkX3NlbmRfc2l6ZXMoc3RydWN0
IGRyYmRfcGVlcl9kZXZpY2UgKnBlZXJfZGV2aWNlLCBpbnQgdHJpZ2dlcl9yZXBseSwgZW51CiAJ
CXAtPnFsaW0tPmxvZ2ljYWxfYmxvY2tfc2l6ZSA9CiAJCQljcHVfdG9fYmUzMihiZGV2X2xvZ2lj
YWxfYmxvY2tfc2l6ZShiZGV2KSk7CiAJCXAtPnFsaW0tPmFsaWdubWVudF9vZmZzZXQgPQotCQkJ
Y3B1X3RvX2JlMzIocXVldWVfYWxpZ25tZW50X29mZnNldChxKSk7CisJCQljcHVfdG9fYmUzMihi
ZGV2X2FsaWdubWVudF9vZmZzZXQoYmRldikpOwogCQlwLT5xbGltLT5pb19taW4gPSBjcHVfdG9f
YmUzMihiZGV2X2lvX21pbihiZGV2KSk7CiAJCXAtPnFsaW0tPmlvX29wdCA9IGNwdV90b19iZTMy
KGJkZXZfaW9fb3B0KGJkZXYpKTsKIAkJcC0+cWxpbS0+ZGlzY2FyZF9lbmFibGVkID0gYmxrX3F1
ZXVlX2Rpc2NhcmQocSk7Ci0tIAoyLjMwLjIKCi0tCmRtLWRldmVsIG1haWxpbmcgbGlzdApkbS1k
ZXZlbEByZWRoYXQuY29tCmh0dHBzOi8vbGlzdG1hbi5yZWRoYXQuY29tL21haWxtYW4vbGlzdGlu
Zm8vZG0tZGV2ZWwK

