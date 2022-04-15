Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CC337C433F5
	for <dm-devel@archiver.kernel.org>; Fri, 15 Apr 2022 06:02:09 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-583-9gabZZrKOg-ZnPTF4rQQsw-1; Fri, 15 Apr 2022 02:02:05 -0400
X-MC-Unique: 9gabZZrKOg-ZnPTF4rQQsw-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id F0E37296A62C;
	Fri, 15 Apr 2022 06:02:03 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id DCCFA58045C;
	Fri, 15 Apr 2022 06:02:02 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 32D04194034A;
	Fri, 15 Apr 2022 06:02:01 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id DA40519451EC
 for <dm-devel@listman.corp.redhat.com>; Fri, 15 Apr 2022 06:01:59 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id CAE10C44CD9; Fri, 15 Apr 2022 06:01:59 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id C7141C28109
 for <dm-devel@redhat.com>; Fri, 15 Apr 2022 06:01:59 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id ACE9538041D1
 for <dm-devel@redhat.com>; Fri, 15 Apr 2022 06:01:59 +0000 (UTC)
Received: from bombadil.infradead.org (bombadil.infradead.org
 [198.137.202.133]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-355-l53IQzEyMSaeONXLi12jBQ-1; Fri, 15 Apr 2022 02:01:56 -0400
X-MC-Unique: l53IQzEyMSaeONXLi12jBQ-1
Received: from [2a02:1205:504b:4280:f5dd:42a4:896c:d877] (helo=localhost)
 by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
 id 1nfDxW-008OrQ-LX; Fri, 15 Apr 2022 04:53:27 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Date: Fri, 15 Apr 2022 06:52:36 +0200
Message-Id: <20220415045258.199825-6-hch@lst.de>
In-Reply-To: <20220415045258.199825-1-hch@lst.de>
References: <20220415045258.199825-1-hch@lst.de>
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
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
Subject: [dm-devel] [PATCH 05/27] drbd: use bdev based limit helpers in
 drbd_send_sizes
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
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

VXNlIHRoZSBiZGV2IGJhc2VkIGxpbWl0cyBoZWxwZXJzIHdoZXJlIHRoZXkgZXhpc3QuCgpTaWdu
ZWQtb2ZmLWJ5OiBDaHJpc3RvcGggSGVsbHdpZyA8aGNoQGxzdC5kZT4KQWNrZWQtYnk6IENocmlz
dG9waCBCw7ZobXdhbGRlciA8Y2hyaXN0b3BoLmJvZWhtd2FsZGVyQGxpbmJpdC5jb20+Ci0tLQog
ZHJpdmVycy9ibG9jay9kcmJkL2RyYmRfbWFpbi5jIHwgMTIgKysrKysrKy0tLS0tCiAxIGZpbGUg
Y2hhbmdlZCwgNyBpbnNlcnRpb25zKCspLCA1IGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2Ry
aXZlcnMvYmxvY2svZHJiZC9kcmJkX21haW4uYyBiL2RyaXZlcnMvYmxvY2svZHJiZC9kcmJkX21h
aW4uYwppbmRleCAzNjc3MTUyMDVjODYwLi5jMzliMDRiZGEyNjFmIDEwMDY0NAotLS0gYS9kcml2
ZXJzL2Jsb2NrL2RyYmQvZHJiZF9tYWluLmMKKysrIGIvZHJpdmVycy9ibG9jay9kcmJkL2RyYmRf
bWFpbi5jCkBAIC05MjQsNyArOTI0LDkgQEAgaW50IGRyYmRfc2VuZF9zaXplcyhzdHJ1Y3QgZHJi
ZF9wZWVyX2RldmljZSAqcGVlcl9kZXZpY2UsIGludCB0cmlnZ2VyX3JlcGx5LCBlbnUKIAogCW1l
bXNldChwLCAwLCBwYWNrZXRfc2l6ZSk7CiAJaWYgKGdldF9sZGV2X2lmX3N0YXRlKGRldmljZSwg
RF9ORUdPVElBVElORykpIHsKLQkJc3RydWN0IHJlcXVlc3RfcXVldWUgKnEgPSBiZGV2X2dldF9x
dWV1ZShkZXZpY2UtPmxkZXYtPmJhY2tpbmdfYmRldik7CisJCXN0cnVjdCBibG9ja19kZXZpY2Ug
KmJkZXYgPSBkZXZpY2UtPmxkZXYtPmJhY2tpbmdfYmRldjsKKwkJc3RydWN0IHJlcXVlc3RfcXVl
dWUgKnEgPSBiZGV2X2dldF9xdWV1ZShiZGV2KTsKKwogCQlkX3NpemUgPSBkcmJkX2dldF9tYXhf
Y2FwYWNpdHkoZGV2aWNlLT5sZGV2KTsKIAkJcmN1X3JlYWRfbG9jaygpOwogCQl1X3NpemUgPSBy
Y3VfZGVyZWZlcmVuY2UoZGV2aWNlLT5sZGV2LT5kaXNrX2NvbmYpLT5kaXNrX3NpemU7CkBAIC05
MzMsMTMgKzkzNSwxMyBAQCBpbnQgZHJiZF9zZW5kX3NpemVzKHN0cnVjdCBkcmJkX3BlZXJfZGV2
aWNlICpwZWVyX2RldmljZSwgaW50IHRyaWdnZXJfcmVwbHksIGVudQogCQltYXhfYmlvX3NpemUg
PSBxdWV1ZV9tYXhfaHdfc2VjdG9ycyhxKSA8PCA5OwogCQltYXhfYmlvX3NpemUgPSBtaW4obWF4
X2Jpb19zaXplLCBEUkJEX01BWF9CSU9fU0laRSk7CiAJCXAtPnFsaW0tPnBoeXNpY2FsX2Jsb2Nr
X3NpemUgPQotCQkJY3B1X3RvX2JlMzIocXVldWVfcGh5c2ljYWxfYmxvY2tfc2l6ZShxKSk7CisJ
CQljcHVfdG9fYmUzMihiZGV2X3BoeXNpY2FsX2Jsb2NrX3NpemUoYmRldikpOwogCQlwLT5xbGlt
LT5sb2dpY2FsX2Jsb2NrX3NpemUgPQotCQkJY3B1X3RvX2JlMzIocXVldWVfbG9naWNhbF9ibG9j
a19zaXplKHEpKTsKKwkJCWNwdV90b19iZTMyKGJkZXZfbG9naWNhbF9ibG9ja19zaXplKGJkZXYp
KTsKIAkJcC0+cWxpbS0+YWxpZ25tZW50X29mZnNldCA9CiAJCQljcHVfdG9fYmUzMihxdWV1ZV9h
bGlnbm1lbnRfb2Zmc2V0KHEpKTsKLQkJcC0+cWxpbS0+aW9fbWluID0gY3B1X3RvX2JlMzIocXVl
dWVfaW9fbWluKHEpKTsKLQkJcC0+cWxpbS0+aW9fb3B0ID0gY3B1X3RvX2JlMzIocXVldWVfaW9f
b3B0KHEpKTsKKwkJcC0+cWxpbS0+aW9fbWluID0gY3B1X3RvX2JlMzIoYmRldl9pb19taW4oYmRl
dikpOworCQlwLT5xbGltLT5pb19vcHQgPSBjcHVfdG9fYmUzMihiZGV2X2lvX29wdChiZGV2KSk7
CiAJCXAtPnFsaW0tPmRpc2NhcmRfZW5hYmxlZCA9IGJsa19xdWV1ZV9kaXNjYXJkKHEpOwogCQlw
dXRfbGRldihkZXZpY2UpOwogCX0gZWxzZSB7Ci0tIAoyLjMwLjIKCi0tCmRtLWRldmVsIG1haWxp
bmcgbGlzdApkbS1kZXZlbEByZWRoYXQuY29tCmh0dHBzOi8vbGlzdG1hbi5yZWRoYXQuY29tL21h
aWxtYW4vbGlzdGluZm8vZG0tZGV2ZWwK

