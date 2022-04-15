Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A58E0C433F5
	for <dm-devel@archiver.kernel.org>; Fri, 15 Apr 2022 05:51:51 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-473-R8i5qm6iOuegGgQvopOLeQ-1; Fri, 15 Apr 2022 01:51:47 -0400
X-MC-Unique: R8i5qm6iOuegGgQvopOLeQ-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C21C6185A794;
	Fri, 15 Apr 2022 05:51:45 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id B1C44463EEC;
	Fri, 15 Apr 2022 05:51:45 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 6BD3E194034A;
	Fri, 15 Apr 2022 05:51:45 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 470A819451EC
 for <dm-devel@listman.corp.redhat.com>; Fri, 15 Apr 2022 05:51:44 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 19AE32049CB2; Fri, 15 Apr 2022 05:51:44 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 146992044723
 for <dm-devel@redhat.com>; Fri, 15 Apr 2022 05:51:38 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2A4B8185A7BA
 for <dm-devel@redhat.com>; Fri, 15 Apr 2022 05:51:38 +0000 (UTC)
Received: from bombadil.infradead.org (bombadil.infradead.org
 [198.137.202.133]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-492-rzHt-hTZO4-6GgEUlAl52g-1; Fri, 15 Apr 2022 01:51:36 -0400
X-MC-Unique: rzHt-hTZO4-6GgEUlAl52g-1
Received: from [2a02:1205:504b:4280:f5dd:42a4:896c:d877] (helo=localhost)
 by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
 id 1nfDxU-008Opj-8L; Fri, 15 Apr 2022 04:53:24 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Date: Fri, 15 Apr 2022 06:52:35 +0200
Message-Id: <20220415045258.199825-5-hch@lst.de>
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
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
Subject: [dm-devel] [PATCH 04/27] drbd: remove assign_p_sizes_qlim
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
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

Rm9sZCBlYWNoIGJyYW5jaCBpbnRvIGl0cyBvbmx5IGNhbGxlci4KClNpZ25lZC1vZmYtYnk6IENo
cmlzdG9waCBIZWxsd2lnIDxoY2hAbHN0LmRlPgpBY2tlZC1ieTogQ2hyaXN0b3BoIELDtmhtd2Fs
ZGVyIDxjaHJpc3RvcGguYm9laG13YWxkZXJAbGluYml0LmNvbT4KLS0tCiBkcml2ZXJzL2Jsb2Nr
L2RyYmQvZHJiZF9tYWluLmMgfCA0NyArKysrKysrKysrKysrKystLS0tLS0tLS0tLS0tLS0tLS0t
CiAxIGZpbGUgY2hhbmdlZCwgMjAgaW5zZXJ0aW9ucygrKSwgMjcgZGVsZXRpb25zKC0pCgpkaWZm
IC0tZ2l0IGEvZHJpdmVycy9ibG9jay9kcmJkL2RyYmRfbWFpbi5jIGIvZHJpdmVycy9ibG9jay9k
cmJkL2RyYmRfbWFpbi5jCmluZGV4IDRiMGIyNWNjOTE2ZWUuLjM2NzcxNTIwNWM4NjAgMTAwNjQ0
Ci0tLSBhL2RyaXZlcnMvYmxvY2svZHJiZC9kcmJkX21haW4uYworKysgYi9kcml2ZXJzL2Jsb2Nr
L2RyYmQvZHJiZF9tYWluLmMKQEAgLTkwMywzMSArOTAzLDYgQEAgdm9pZCBkcmJkX2dlbl9hbmRf
c2VuZF9zeW5jX3V1aWQoc3RydWN0IGRyYmRfcGVlcl9kZXZpY2UgKnBlZXJfZGV2aWNlKQogCX0K
IH0KIAotLyogY29tbXVuaWNhdGVkIGlmIChhZ3JlZWRfZmVhdHVyZXMgJiBEUkJEX0ZGX1dTQU1F
KSAqLwotc3RhdGljIHZvaWQKLWFzc2lnbl9wX3NpemVzX3FsaW0oc3RydWN0IGRyYmRfZGV2aWNl
ICpkZXZpY2UsIHN0cnVjdCBwX3NpemVzICpwLAotCQkJCQlzdHJ1Y3QgcmVxdWVzdF9xdWV1ZSAq
cSkKLXsKLQlpZiAocSkgewotCQlwLT5xbGltLT5waHlzaWNhbF9ibG9ja19zaXplID0gY3B1X3Rv
X2JlMzIocXVldWVfcGh5c2ljYWxfYmxvY2tfc2l6ZShxKSk7Ci0JCXAtPnFsaW0tPmxvZ2ljYWxf
YmxvY2tfc2l6ZSA9IGNwdV90b19iZTMyKHF1ZXVlX2xvZ2ljYWxfYmxvY2tfc2l6ZShxKSk7Ci0J
CXAtPnFsaW0tPmFsaWdubWVudF9vZmZzZXQgPSBjcHVfdG9fYmUzMihxdWV1ZV9hbGlnbm1lbnRf
b2Zmc2V0KHEpKTsKLQkJcC0+cWxpbS0+aW9fbWluID0gY3B1X3RvX2JlMzIocXVldWVfaW9fbWlu
KHEpKTsKLQkJcC0+cWxpbS0+aW9fb3B0ID0gY3B1X3RvX2JlMzIocXVldWVfaW9fb3B0KHEpKTsK
LQkJcC0+cWxpbS0+ZGlzY2FyZF9lbmFibGVkID0gYmxrX3F1ZXVlX2Rpc2NhcmQocSk7Ci0JCXAt
PnFsaW0tPndyaXRlX3NhbWVfY2FwYWJsZSA9IDA7Ci0JfSBlbHNlIHsKLQkJcSA9IGRldmljZS0+
cnFfcXVldWU7Ci0JCXAtPnFsaW0tPnBoeXNpY2FsX2Jsb2NrX3NpemUgPSBjcHVfdG9fYmUzMihx
dWV1ZV9waHlzaWNhbF9ibG9ja19zaXplKHEpKTsKLQkJcC0+cWxpbS0+bG9naWNhbF9ibG9ja19z
aXplID0gY3B1X3RvX2JlMzIocXVldWVfbG9naWNhbF9ibG9ja19zaXplKHEpKTsKLQkJcC0+cWxp
bS0+YWxpZ25tZW50X29mZnNldCA9IDA7Ci0JCXAtPnFsaW0tPmlvX21pbiA9IGNwdV90b19iZTMy
KHF1ZXVlX2lvX21pbihxKSk7Ci0JCXAtPnFsaW0tPmlvX29wdCA9IGNwdV90b19iZTMyKHF1ZXVl
X2lvX29wdChxKSk7Ci0JCXAtPnFsaW0tPmRpc2NhcmRfZW5hYmxlZCA9IDA7Ci0JCXAtPnFsaW0t
PndyaXRlX3NhbWVfY2FwYWJsZSA9IDA7Ci0JfQotfQotCiBpbnQgZHJiZF9zZW5kX3NpemVzKHN0
cnVjdCBkcmJkX3BlZXJfZGV2aWNlICpwZWVyX2RldmljZSwgaW50IHRyaWdnZXJfcmVwbHksIGVu
dW0gZGRzX2ZsYWdzIGZsYWdzKQogewogCXN0cnVjdCBkcmJkX2RldmljZSAqZGV2aWNlID0gcGVl
cl9kZXZpY2UtPmRldmljZTsKQEAgLTk1NywxNCArOTMyLDMyIEBAIGludCBkcmJkX3NlbmRfc2l6
ZXMoc3RydWN0IGRyYmRfcGVlcl9kZXZpY2UgKnBlZXJfZGV2aWNlLCBpbnQgdHJpZ2dlcl9yZXBs
eSwgZW51CiAJCXFfb3JkZXJfdHlwZSA9IGRyYmRfcXVldWVfb3JkZXJfdHlwZShkZXZpY2UpOwog
CQltYXhfYmlvX3NpemUgPSBxdWV1ZV9tYXhfaHdfc2VjdG9ycyhxKSA8PCA5OwogCQltYXhfYmlv
X3NpemUgPSBtaW4obWF4X2Jpb19zaXplLCBEUkJEX01BWF9CSU9fU0laRSk7Ci0JCWFzc2lnbl9w
X3NpemVzX3FsaW0oZGV2aWNlLCBwLCBxKTsKKwkJcC0+cWxpbS0+cGh5c2ljYWxfYmxvY2tfc2l6
ZSA9CisJCQljcHVfdG9fYmUzMihxdWV1ZV9waHlzaWNhbF9ibG9ja19zaXplKHEpKTsKKwkJcC0+
cWxpbS0+bG9naWNhbF9ibG9ja19zaXplID0KKwkJCWNwdV90b19iZTMyKHF1ZXVlX2xvZ2ljYWxf
YmxvY2tfc2l6ZShxKSk7CisJCXAtPnFsaW0tPmFsaWdubWVudF9vZmZzZXQgPQorCQkJY3B1X3Rv
X2JlMzIocXVldWVfYWxpZ25tZW50X29mZnNldChxKSk7CisJCXAtPnFsaW0tPmlvX21pbiA9IGNw
dV90b19iZTMyKHF1ZXVlX2lvX21pbihxKSk7CisJCXAtPnFsaW0tPmlvX29wdCA9IGNwdV90b19i
ZTMyKHF1ZXVlX2lvX29wdChxKSk7CisJCXAtPnFsaW0tPmRpc2NhcmRfZW5hYmxlZCA9IGJsa19x
dWV1ZV9kaXNjYXJkKHEpOwogCQlwdXRfbGRldihkZXZpY2UpOwogCX0gZWxzZSB7CisJCXN0cnVj
dCByZXF1ZXN0X3F1ZXVlICpxID0gZGV2aWNlLT5ycV9xdWV1ZTsKKworCQlwLT5xbGltLT5waHlz
aWNhbF9ibG9ja19zaXplID0KKwkJCWNwdV90b19iZTMyKHF1ZXVlX3BoeXNpY2FsX2Jsb2NrX3Np
emUocSkpOworCQlwLT5xbGltLT5sb2dpY2FsX2Jsb2NrX3NpemUgPQorCQkJY3B1X3RvX2JlMzIo
cXVldWVfbG9naWNhbF9ibG9ja19zaXplKHEpKTsKKwkJcC0+cWxpbS0+YWxpZ25tZW50X29mZnNl
dCA9IDA7CisJCXAtPnFsaW0tPmlvX21pbiA9IGNwdV90b19iZTMyKHF1ZXVlX2lvX21pbihxKSk7
CisJCXAtPnFsaW0tPmlvX29wdCA9IGNwdV90b19iZTMyKHF1ZXVlX2lvX29wdChxKSk7CisJCXAt
PnFsaW0tPmRpc2NhcmRfZW5hYmxlZCA9IDA7CisKIAkJZF9zaXplID0gMDsKIAkJdV9zaXplID0g
MDsKIAkJcV9vcmRlcl90eXBlID0gUVVFVUVfT1JERVJFRF9OT05FOwogCQltYXhfYmlvX3NpemUg
PSBEUkJEX01BWF9CSU9fU0laRTsgLyogLi4uIG11bHRpcGxlIEJJT3MgcGVyIHBlZXJfcmVxdWVz
dCAqLwotCQlhc3NpZ25fcF9zaXplc19xbGltKGRldmljZSwgcCwgTlVMTCk7CiAJfQogCiAJaWYg
KHBlZXJfZGV2aWNlLT5jb25uZWN0aW9uLT5hZ3JlZWRfcHJvX3ZlcnNpb24gPD0gOTQpCi0tIAoy
LjMwLjIKCi0tCmRtLWRldmVsIG1haWxpbmcgbGlzdApkbS1kZXZlbEByZWRoYXQuY29tCmh0dHBz
Oi8vbGlzdG1hbi5yZWRoYXQuY29tL21haWxtYW4vbGlzdGluZm8vZG0tZGV2ZWwK

