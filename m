Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 00E58EB64D7
	for <dm-devel@archiver.kernel.org>; Mon, 26 Jun 2023 12:19:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1687781966;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=Ah+f49ibhxHBhH3QvwLYRBnrnUK/1NyWny6IQYa+oy8=;
	b=hmeUOVMzCDTmI/3lyXSfhjgwkFE0IRwMOsotcQwxzPa/MMnvmioUEf6kTYNSndP7BY8MKa
	4IWhL7T53Ej6AqqAROksO3v2dj7YXNRHiwJDxObVpEXVjR/5FzlKBxKZPuJwA0Go7x5avf
	Gu8jToNRqcfmVYNSeJZGy0gmh75DzkM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-460-yFPAzPBzMda9-M2gSvLmMw-1; Mon, 26 Jun 2023 08:19:25 -0400
X-MC-Unique: yFPAzPBzMda9-M2gSvLmMw-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 36DCB80027F;
	Mon, 26 Jun 2023 12:19:23 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 2EE62492B01;
	Mon, 26 Jun 2023 12:19:19 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id DB6691946588;
	Mon, 26 Jun 2023 12:19:13 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 219891946587
 for <dm-devel@listman.corp.redhat.com>; Mon, 26 Jun 2023 12:19:12 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 11DA02014F94; Mon, 26 Jun 2023 12:19:12 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 0B1BA2017DE2
 for <dm-devel@redhat.com>; Mon, 26 Jun 2023 12:19:12 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DF451282CCAB
 for <dm-devel@redhat.com>; Mon, 26 Jun 2023 12:19:11 +0000 (UTC)
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com
 [45.249.212.187]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-595-rlv6LjCBNaKmN-Cew7OY8g-1; Mon, 26 Jun 2023 08:19:09 -0400
X-MC-Unique: rlv6LjCBNaKmN-Cew7OY8g-1
Received: from dggpemm500011.china.huawei.com (unknown [172.30.72.53])
 by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4QqRdx6QH2zlVwY;
 Mon, 26 Jun 2023 20:16:21 +0800 (CST)
Received: from [10.174.179.155] (10.174.179.155) by
 dggpemm500011.china.huawei.com (7.185.36.110) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Mon, 26 Jun 2023 20:19:03 +0800
Message-ID: <faeb60a9-8bde-d31d-acf5-a2bcda6cad72@huawei.com>
Date: Mon, 26 Jun 2023 20:19:03 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:104.0) Gecko/20100101
 Thunderbird/104.0
To: <thornber@redhat.com>, <dm-devel@redhat.com>, <agk@redhat.com>,
 <snitzer@kernel.org>, Joe Thornber <ejt@redhat.com>
From: Li Lingfeng <lilingfeng3@huawei.com>
X-Originating-IP: [10.174.179.155]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggpemm500011.china.huawei.com (7.185.36.110)
X-CFilter-Loop: Reflected
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
Subject: [dm-devel] [Question] Can DATA_DEV_BLOCK_SIZE_MIN_SECTORS be set to
 a smaller value
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
Cc: "yukuai \(C\)" <yukuai3@huawei.com>, yangerkun <yangerkun@huawei.com>,
 "zhangyi \(F\)" <yi.zhang@huawei.com>, linux-kernel@vger.kernel.org,
 Hou Tao <houtao1@huawei.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: huawei.com
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"

SGVsbG86CgpSZWNlbnRseSwgSSBmb3VuZCB0aGF0IHRoZSB1c2VkIHNwYWNlIG9mIHRoZSB0aGlu
LXBvb2wgd2lsbCBrZWVwIHJpc2luZyAKaWYgSSB1c2UgZG0tdGhpbiBhcyBmb2xsb3c6CgovLyBj
cmVhdGUgZG0tdGhpbgpkbXNldHVwIGNyZWF0ZSBsaW5lYXJfMSAtLXRhYmxlICIwIDIwOTcxNTIg
bGluZWFyIC9kZXYvc2RjIDAiCmRtc2V0dXAgY3JlYXRlIGxpbmVhcl8yIC0tdGFibGUgIjAgMTY3
NzcyMTbCoCBsaW5lYXIgL2Rldi9zZGMgMjA5NzE1MyIKZGQgaWY9L2Rldi96ZXJvIG9mPS9kZXYv
bWFwcGVyL2xpbmVhcl8xIGJzPTQwOTYgY291bnQ9MQpkbXNldHVwIGNyZWF0ZSBwb29sIC0tdGFi
bGUgIjAgMTY3NzcyMTYgdGhpbi1wb29sIC9kZXYvbWFwcGVyL2xpbmVhcl8xIAovZGV2L21hcHBl
ci9saW5lYXJfMiAxMjggMCAxIHNraXBfYmxvY2tfemVyb2luZyIKZG1zZXR1cCBtZXNzYWdlIC9k
ZXYvbWFwcGVyL3Bvb2wgMCAiY3JlYXRlX3RoaW4gMCIKZG1zZXR1cCBjcmVhdGUgdGhpbiAtLXRh
YmxlICIwIDE0NjgwMDY0IHRoaW4gL2Rldi9tYXBwZXIvcG9vbCAwIgoKLy8gbWtmcyBhbmQgbW91
bnQgd2l0aCBkaXNjYXJkCm1rZnMuZXh0NCAvZGV2L21hcHBlci90aGluCm1vdW50IC9kZXYvbWFw
cGVyL3RoaW4gL21udC90ZXN0IC1vIGRpc2NhcmQKY2QgL21udC90ZXN0CgovLyBjcmVhdGUgYSBm
aWxlKDE3S0IpCmRkIGlmPS9kZXYvcmFuZG9tIG9mPXRlc3RmaWxlIGJzPTFrIGNvdW50PTE3IG9m
bGFnPWRpcmVjdApzeW5jCgovLyB0cnVuY2F0ZSB0aGUgZmlsZSBhbmQgd3JpdGUgaXQgZm9yIG1h
bnkgdGltZXMKZGQgaWY9L2Rldi9yYW5kb20gb2Y9dGVzdGZpbGUgYnM9MWsgY291bnQ9MTcgb2Zs
YWc9ZGlyZWN0CnN5bmMKLi4uCgpFeHQ0IHdpbGwgaXNzdWUgZGlzY2FyZCBJTyB0byBkbS10aGlu
IHdoZW4gdHJ1bmNhdGluZyBmaWxlLiBIb3dldmVyLCAKREFUQV9ERVZfQkxPQ0tfU0laRV9NSU5f
U0VDVE9SUyBpcyBzZXQgYXMgNjRLQiB3aGljaCBtZWFucyB0aGUgZGlzY2FyZCAKY292ZXJzIGxl
c3MgdGhhbiBhIGJsb2NrIHdoZW4gSSB0cnVuY2F0aW5nIGEgMTdLQiBmaWxlLiBBcyB0aGUgcmVz
dWx0IG9mIAppdCwgZGlzY2FyZCBiaW8gd2lsbCBlbmQgaW4gcHJvY2Vzc19kaXNjYXJkX2Jpbygp
LCBhbmQgbW9yZSBhbmQgbW9yZSAKYmxvY2tzIHdpbGwgbGVhay4KCkknbSBjdXJpb3VzIGFib3V0
IHRoZSByZWFzb24gYmVoaW5kIHNldHRpbmcgCkRBVEFfREVWX0JMT0NLX1NJWkVfTUlOX1NFQ1RP
UlMgdG8gNjRLQi4gSXMgdGhlcmUgYW55IHNwZWNpZmljIApjb25zaWRlcmF0aW9uIGZvciB0aGlz
PyBXb3VsZCBpdCBiZSBwb3NzaWJsZSB0byBzZXQgdGhpcyBtaW5pbXVtIGxpbWl0IAp0byBhIHNt
YWxsZXIgdmFsdWUsIHN1Y2ggYXMgNEtCPwoKLS0KZG0tZGV2ZWwgbWFpbGluZyBsaXN0CmRtLWRl
dmVsQHJlZGhhdC5jb20KaHR0cHM6Ly9saXN0bWFuLnJlZGhhdC5jb20vbWFpbG1hbi9saXN0aW5m
by9kbS1kZXZlbAo=

