Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BE580C7EE24
	for <dm-devel@archiver.kernel.org>; Tue,  6 Jun 2023 12:22:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686054152;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=iKsnB8o8qL68CpK30NDDKNp5O/Vufo3X3soZRcTi0UY=;
	b=KCXwMiA62qSxWVe7eP8cOlISssJyb+1Sdxo48ddhENrWOmdB7DJrSeE6NkkSFaHsrwtQkI
	ipANT06Hd5pTnd8RXEKyQrLTdtQjuO3nCHRYSW+d8TzhXLHtqqeD45eii6LljterCpFvkP
	XlyUIbaWmNvr9N32c4CoZjTTxM5tvyE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-662-0XtnPg-JMmScIG1eFV3BNA-1; Tue, 06 Jun 2023 08:22:29 -0400
X-MC-Unique: 0XtnPg-JMmScIG1eFV3BNA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8028D811E85;
	Tue,  6 Jun 2023 12:22:27 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 4B6CA1121314;
	Tue,  6 Jun 2023 12:22:24 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 2692119465B3;
	Tue,  6 Jun 2023 12:22:24 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id DC8BE1946595
 for <dm-devel@listman.corp.redhat.com>; Tue,  6 Jun 2023 12:22:22 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id C60C940336D; Tue,  6 Jun 2023 12:22:22 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id BEC2E400F5F
 for <dm-devel@redhat.com>; Tue,  6 Jun 2023 12:22:22 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-2.mimecast.com
 [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A3D4D385556C
 for <dm-devel@redhat.com>; Tue,  6 Jun 2023 12:22:22 +0000 (UTC)
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com
 [45.249.212.189]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-277-k25F4U69OTOnouJ6Yr-2MA-1; Tue, 06 Jun 2023 08:22:20 -0400
X-MC-Unique: k25F4U69OTOnouJ6Yr-2MA-1
Received: from dggpemm500011.china.huawei.com (unknown [172.30.72.54])
 by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4Qb8h12yhdz1c0Lj;
 Tue,  6 Jun 2023 20:20:33 +0800 (CST)
Received: from huawei.com (10.175.127.227) by dggpemm500011.china.huawei.com
 (7.185.36.110) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23; Tue, 6 Jun
 2023 20:22:14 +0800
From: Li Lingfeng <lilingfeng3@huawei.com>
To: <dm-devel@redhat.com>
Date: Tue, 6 Jun 2023 20:20:24 +0800
Message-ID: <20230606122024.1965040-1-lilingfeng3@huawei.com>
MIME-Version: 1.0
X-Originating-IP: [10.175.127.227]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpemm500011.china.huawei.com (7.185.36.110)
X-CFilter-Loop: Reflected
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
Subject: [dm-devel] [PATCH] dm thin: check fail_io before using data_sm
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
Cc: yi.zhang@huawei.com, snitzer@kernel.org, linux-kernel@vger.kernel.org,
 houtao1@huawei.com, yukuai3@huawei.com, lilingfeng3@huawei.com, agk@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: huawei.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

V2Ugc2hvdWxkIGNoZWNrIHBtZC0+ZmFpbF9pbyBiZWZvcmUgdXNpbmcgcG1kLT5kYXRhX3NtIHNp
bmNlIHBtZC0+ZGF0YV9zbQptYXkgYmUgZGVzdHJveWVkIGJ5IG90aGVyIHByb2Nlc3Nlcy4KCiAg
ICAgICBQMShrd29ya2VyKSAgICAgICAgICAgICAgICAgICAgICAgICAgICAgUDIobWVzc2FnZSkK
ZG9fd29ya2VyCiBwcm9jZXNzX3ByZXBhcmVkCiAgcHJvY2Vzc19wcmVwYXJlZF9kaXNjYXJkX3Bh
c3Nkb3duX3B0MgogICBkbV9wb29sX2RlY19kYXRhX3JhbmdlCiAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgIHBvb2xfbWVzc2FnZQogICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgY29tbWl0CiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgZG1f
cG9vbF9jb21taXRfbWV0YWRhdGEKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgIOKGkwogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAvLyBjb21taXQg
ZmFpbGVkCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgbWV0YWRhdGFfb3Bl
cmF0aW9uX2ZhaWxlZAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBhYm9y
dF90cmFuc2FjdGlvbgogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgZG1f
cG9vbF9hYm9ydF9tZXRhZGF0YQogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgIGRtX2Jsb2NrX21hbmFnZXJfY3JlYXRlCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICDihpMKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgLy8gY3JlYXRlIGZhaWxlZAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgIF9fZGVzdHJveV9wZXJzaXN0ZW50X2RhdGFfb2JqZWN0cwogICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICBkbV9zbV9kZXN0cm95KHBtZC0+ZGF0YV9zbSkKICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICDihpMKICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgIC8vIGZyZWUgZGF0YV9zbQogICAgZG1fc21fZGVj
X2Jsb2NrcwogICAgICDihpMKICAgICAvLyB0cnkgdG8gYWNjZXNzIHBtZC0+ZGF0YV9zbSAtLT4g
VUFGCgpBcyBzaG93biBhYm92ZSwgaWYgZG1fcG9vbF9jb21taXRfbWV0YWRhdGEoKSBhbmQgZG1f
YmxvY2tfbWFuYWdlcl9jcmVhdGUoKQpmYWlsIGluIHBvb2xfbWVzc2FnZSBwcm9jZXNzLCBrd29y
a2VyIG1heSB0cmlnZ2VyIFVBRi4KClNpZ25lZC1vZmYtYnk6IExpIExpbmdmZW5nIDxsaWxpbmdm
ZW5nM0BodWF3ZWkuY29tPgotLS0KIGRyaXZlcnMvbWQvZG0tdGhpbi1tZXRhZGF0YS5jIHwgMjAg
KysrKysrKysrKysrLS0tLS0tLS0KIDEgZmlsZSBjaGFuZ2VkLCAxMiBpbnNlcnRpb25zKCspLCA4
IGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2RyaXZlcnMvbWQvZG0tdGhpbi1tZXRhZGF0YS5j
IGIvZHJpdmVycy9tZC9kbS10aGluLW1ldGFkYXRhLmMKaW5kZXggOWY1Y2I1MmM1NzYzLi5iOTQ2
MWZhYTlmMGQgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvbWQvZG0tdGhpbi1tZXRhZGF0YS5jCisrKyBi
L2RyaXZlcnMvbWQvZG0tdGhpbi1tZXRhZGF0YS5jCkBAIC0xNzU2LDEzICsxNzU2LDE1IEBAIGlu
dCBkbV90aGluX3JlbW92ZV9yYW5nZShzdHJ1Y3QgZG1fdGhpbl9kZXZpY2UgKnRkLAogCiBpbnQg
ZG1fcG9vbF9ibG9ja19pc19zaGFyZWQoc3RydWN0IGRtX3Bvb2xfbWV0YWRhdGEgKnBtZCwgZG1f
YmxvY2tfdCBiLCBib29sICpyZXN1bHQpCiB7Ci0JaW50IHI7CisJaW50IHIgPSAtRUlOVkFMOwog
CXVpbnQzMl90IHJlZl9jb3VudDsKIAogCWRvd25fcmVhZCgmcG1kLT5yb290X2xvY2spOwotCXIg
PSBkbV9zbV9nZXRfY291bnQocG1kLT5kYXRhX3NtLCBiLCAmcmVmX2NvdW50KTsKLQlpZiAoIXIp
Ci0JCSpyZXN1bHQgPSAocmVmX2NvdW50ID4gMSk7CisJaWYgKCFwbWQtPmZhaWxfaW8pIHsKKwkJ
ciA9IGRtX3NtX2dldF9jb3VudChwbWQtPmRhdGFfc20sIGIsICZyZWZfY291bnQpOworCQlpZiAo
IXIpCisJCQkqcmVzdWx0ID0gKHJlZl9jb3VudCA+IDEpOworCX0KIAl1cF9yZWFkKCZwbWQtPnJv
b3RfbG9jayk7CiAKIAlyZXR1cm4gcjsKQEAgLTE3NzAsMTAgKzE3NzIsMTEgQEAgaW50IGRtX3Bv
b2xfYmxvY2tfaXNfc2hhcmVkKHN0cnVjdCBkbV9wb29sX21ldGFkYXRhICpwbWQsIGRtX2Jsb2Nr
X3QgYiwgYm9vbCAqcmUKIAogaW50IGRtX3Bvb2xfaW5jX2RhdGFfcmFuZ2Uoc3RydWN0IGRtX3Bv
b2xfbWV0YWRhdGEgKnBtZCwgZG1fYmxvY2tfdCBiLCBkbV9ibG9ja190IGUpCiB7Ci0JaW50IHIg
PSAwOworCWludCByID0gLUVJTlZBTDsKIAogCXBtZF93cml0ZV9sb2NrKHBtZCk7Ci0JciA9IGRt
X3NtX2luY19ibG9ja3MocG1kLT5kYXRhX3NtLCBiLCBlKTsKKwlpZiAoIXBtZC0+ZmFpbF9pbykK
KwkJciA9IGRtX3NtX2luY19ibG9ja3MocG1kLT5kYXRhX3NtLCBiLCBlKTsKIAlwbWRfd3JpdGVf
dW5sb2NrKHBtZCk7CiAKIAlyZXR1cm4gcjsKQEAgLTE3ODEsMTAgKzE3ODQsMTEgQEAgaW50IGRt
X3Bvb2xfaW5jX2RhdGFfcmFuZ2Uoc3RydWN0IGRtX3Bvb2xfbWV0YWRhdGEgKnBtZCwgZG1fYmxv
Y2tfdCBiLCBkbV9ibG9ja18KIAogaW50IGRtX3Bvb2xfZGVjX2RhdGFfcmFuZ2Uoc3RydWN0IGRt
X3Bvb2xfbWV0YWRhdGEgKnBtZCwgZG1fYmxvY2tfdCBiLCBkbV9ibG9ja190IGUpCiB7Ci0JaW50
IHIgPSAwOworCWludCByID0gLUVJTlZBTDsKIAogCXBtZF93cml0ZV9sb2NrKHBtZCk7Ci0JciA9
IGRtX3NtX2RlY19ibG9ja3MocG1kLT5kYXRhX3NtLCBiLCBlKTsKKwlpZiAoIXBtZC0+ZmFpbF9p
bykKKwkJciA9IGRtX3NtX2RlY19ibG9ja3MocG1kLT5kYXRhX3NtLCBiLCBlKTsKIAlwbWRfd3Jp
dGVfdW5sb2NrKHBtZCk7CiAKIAlyZXR1cm4gcjsKLS0gCjIuMzEuMQoKLS0KZG0tZGV2ZWwgbWFp
bGluZyBsaXN0CmRtLWRldmVsQHJlZGhhdC5jb20KaHR0cHM6Ly9saXN0bWFuLnJlZGhhdC5jb20v
bWFpbG1hbi9saXN0aW5mby9kbS1kZXZlbAo=

