Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6B44DC00140
	for <dm-devel@archiver.kernel.org>; Mon,  8 Aug 2022 03:31:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1659929514;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=fA7aMTkiySEN5e8k85lZvTfCLxpIE0xjmV1qxBcCHx8=;
	b=d7hcCYWaq9BO5Br4qCwnM0FuBJVUmwF5R3M4x1FSLoWF7KIlLVIDD8gQddaBfXwwD45N/+
	6oplQltFE2etoQ09wVUWF52FwAkrrXZ5i7KxQT1yKXc+cynJduivT40lPXRs8iQspzjkkT
	mcoIptzGB3SsySlv5Adnc2EQY4RFw6M=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-344-y4MlreWANl6Bs6v_rHag8w-1; Sun, 07 Aug 2022 23:31:50 -0400
X-MC-Unique: y4MlreWANl6Bs6v_rHag8w-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4A666803DB6;
	Mon,  8 Aug 2022 03:31:49 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id C831DC202C5;
	Mon,  8 Aug 2022 03:31:45 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id B16F01946A48;
	Mon,  8 Aug 2022 03:31:45 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 061201946A45
 for <dm-devel@listman.corp.redhat.com>; Mon,  8 Aug 2022 03:31:44 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id DCAD2400DFDD; Mon,  8 Aug 2022 03:31:43 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id D8D9B40CFD0A
 for <dm-devel@redhat.com>; Mon,  8 Aug 2022 03:31:43 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C1CFC1019C8D
 for <dm-devel@redhat.com>; Mon,  8 Aug 2022 03:31:43 +0000 (UTC)
Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com
 [45.249.212.51]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-482-Wu1Il7C4OFOuAiPhDA5ETQ-1; Sun, 07 Aug 2022 23:31:38 -0400
X-MC-Unique: Wu1Il7C4OFOuAiPhDA5ETQ-1
Received: from mail02.huawei.com (unknown [172.30.67.143])
 by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4M1MCj2j6PzlGFq;
 Mon,  8 Aug 2022 11:30:25 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
 by APP2 (Coremail) with SMTP id Syh0CgCnkb2Vg_BiCdhFAA--.42849S3;
 Mon, 08 Aug 2022 11:31:34 +0800 (CST)
To: Greg KH <gregkh@linuxfoundation.org>, Christoph Hellwig <hch@lst.de>
References: <20220729062356.1663513-1-yukuai1@huaweicloud.com>
 <20220729062356.1663513-2-yukuai1@huaweicloud.com>
 <Yue2rU2Y+xzvGU6x@kroah.com> <20220801180458.GA17425@lst.de>
 <Yuix/CcmdKsSD+za@kroah.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <b06f4667-d70e-54ee-6c6f-b68865ca61a4@huaweicloud.com>
Date: Mon, 8 Aug 2022 11:31:32 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <Yuix/CcmdKsSD+za@kroah.com>
X-CM-TRANSID: Syh0CgCnkb2Vg_BiCdhFAA--.42849S3
X-Coremail-Antispam: 1UD129KBjvJXoW7ur1fZFy7XrW5ZrWDXF47Jwb_yoW8CrWfpa
 12qa9Ykws5GF48ta4xZ3WIkFn3twsayry3G3s5JrZ5uws0krySqrWxKFWUZryDWFs8Gr1I
 9F4jk395uFn5tw7anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
 9KBjDU0xBIdaVrnRJUUU9Y14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
 rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
 1l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
 JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
 CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
 2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
 W8JwACjcxG0xvEwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lFIxGxcIEc7CjxVA2Y2ka
 0xkIwI1lc7I2V7IY0VAS07AlzVAYIcxG8wCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7x
 kEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E
 67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCw
 CI42IY6xIIjxv20xvEc7CjxVAFwI0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6rW3Jr0E
 3s1lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVWUJVW8JbIYCT
 nIWIevJa73UjIFyTuYvjfUoOJ5UUUUU
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/
X-CFilter-Loop: Reflected
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
Subject: Re: [dm-devel] [PATCH stable 5.10 1/3] block: look up holders by
 bdev
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
Cc: axboe@kernel.dk, snitzer@redhat.com, yi.zhang@huawei.com,
 stable@vger.kernel.org, linux-block@vger.kernel.org,
 Yu Kuai <yukuai1@huaweicloud.com>, dm-devel@redhat.com,
 "yukuai \(C\)" <yukuai3@huawei.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="gbk"; Format="flowed"

SGksIENocmlzdG9waAoK1NogMjAyMi8wOC8wMiAxMzoxMSwgR3JlZyBLSCDQtLXAOgo+IE9uIE1v
biwgQXVnIDAxLCAyMDIyIGF0IDA4OjA0OjU4UE0gKzAyMDAsIENocmlzdG9waCBIZWxsd2lnIHdy
b3RlOgo+PiBPbiBNb24sIEF1ZyAwMSwgMjAyMiBhdCAwMToxOTowOVBNICswMjAwLCBHcmVnIEtI
IHdyb3RlOgo+Pj4gVGhpcyBpcyB2ZXJ5IGRpZmZlcmVudCBmcm9tIHRoZSB1cHN0cmVhbSB2ZXJz
aW9uLCBhbmQgZm9yY2VzIHRoZSBjaGFuZ2UKPj4+IG9udG8gZXZlcnlvbmUsIG5vdCBqdXN0IHRo
b3NlIHdobyBoYWQgQ09ORklHX0JMT0NLX0hPTERFUl9ERVBSRUNBVEVECj4+PiBlbmFibGVkIGxp
a2Ugd2FzIGRvbmUgaW4gdGhlIG1haW4ga2VybmVsIHRyZWUuCj4+Pgo+Pj4gV2h5IGZvcmNlIHRo
aXMgb24gYWxsIGFuZCBub3QganVzdCB1c2UgdGhlIHNhbWUgb3B0aW9uPwo+Pgo+PiBJJ20gcmVh
bGx5IHdvcnJpZWQgYWJvdXQgYmFja3BvcnRzIHRoYXQgYXJlIHNpZ25pZmljYW50bHkgZGlmZmVy
ZW50Cj4+IGZyb20gdGhlIG9yaWdpbmFsIGNvbW1pdC4gIFRvIHRoZSBwb2ludCB3aGVyZSBpZiB0
aGV5IGFyZSBzbyBkaWZmZXJlbnQKPj4gYW5kIHdlIGRvbid0IGhhdmUgYSBncmF2ZSBzZWN1cml0
eSBvciBkYXRhIGludGVncml0eSBidWcgSSdtIHJlYWxseSBub3QKPj4gdmVyeSBtdWNoIGluIGZh
dm9yIG9mIGJhY2twb3J0aW5nIHRoZW0gYXQgYWxsLgo+PgoKSSBkbyB1bmRlcnN0YW5kIHRoYXQg
YmFja3BvcnRpbmcgdGhlc2UgcGF0Y2hlcyBpcyBub3QgZ29vZCwgdGhhbmtzIGZvcgp0YWtpbmcg
dGltZSBvbiB0aGlzIHBhdGNoc2V0LgoKSSBkZWNpZGVkIHRvIHB1c2ggZm9sbG93aW5nIHBhdGNo
IGluIG91ciB2ZXJzaW9uOgoKZGlmZiAtLWdpdCBhL2RyaXZlcnMvbWQvZG0uYyBiL2RyaXZlcnMv
bWQvZG0uYwppbmRleCA1ODhlOGI0M2VmYWIuLmMwNDdkNWZjYjMyNSAxMDA2NDQKLS0tIGEvZHJp
dmVycy9tZC9kbS5jCisrKyBiL2RyaXZlcnMvbWQvZG0uYwpAQCAtMjE0OSwxMiArMjE0OSwxNiBA
QCBpbnQgZG1fc2V0dXBfbWRfcXVldWUoc3RydWN0IG1hcHBlZF9kZXZpY2UgKm1kLCAKc3RydWN0
IGRtX3RhYmxlICp0KQoKICAgICAgICAgc3dpdGNoICh0eXBlKSB7CiAgICAgICAgIGNhc2UgRE1f
VFlQRV9SRVFVRVNUX0JBU0VEOgotICAgICAgICAgICAgICAgbWQtPmRpc2stPmZvcHMgPSAmZG1f
cnFfYmxrX2RvcHM7CiAgICAgICAgICAgICAgICAgciA9IGRtX21xX2luaXRfcmVxdWVzdF9xdWV1
ZShtZCwgdCk7CiAgICAgICAgICAgICAgICAgaWYgKHIpIHsKICAgICAgICAgICAgICAgICAgICAg
ICAgIERNRVJSKCJDYW5ub3QgaW5pdGlhbGl6ZSBxdWV1ZSBmb3IgCnJlcXVlc3QtYmFzZWQgZG0g
bWFwcGVkIGRldmljZSIpOwogICAgICAgICAgICAgICAgICAgICAgICAgcmV0dXJuIHI7CiAgICAg
ICAgICAgICAgICAgfQorICAgICAgICAgICAgICAgLyoKKyAgICAgICAgICAgICAgICAqIENoYW5n
ZSB0aGUgZm9wcyBhZnRlciBxdWV1ZSBpcyBpbml0aWFsaXplZCwgc28gdGhhdCAKYmlvIHdvbid0
CisgICAgICAgICAgICAgICAgKiBpc3N1ZWQgYnkgcnEtYmFzZWQgcGF0aCB1bnRpbCB0aGF0Lgor
ICAgICAgICAgICAgICAgICovCisgICAgICAgICAgICAgICBtZC0+ZGlzay0+Zm9wcyA9ICZkbV9y
cV9ibGtfZG9wczsKICAgICAgICAgICAgICAgICBicmVhazsKICAgICAgICAgY2FzZSBETV9UWVBF
X0JJT19CQVNFRDoKICAgICAgICAgY2FzZSBETV9UWVBFX0RBWF9CSU9fQkFTRUQ6CgoKVGhpcyB3
YXkgb25seSBtb2RpZnkgZG0sIGFuZCB0aGUgcHJvYmxlbSBjYW4gYmUgZml4ZWQuIElmIHlvdSBn
dXlzIHRoaW5rCnRoaXMgaXMgT0ssIEkgY2FuIHNlbmQgYSBwYXRjaCBmb3IgTFRTLiBPdGhlcndp
c2UsIGlmIHlvdSBndXlzIHN0aWxsCnRoaW5rIHRoZSBudWxsLXB0ci1kZWYgcHJvYmxlbSBpcyB1
bmNvbW1vbiBhbmQgZG9lc24ndCB3b3J0aCB0byBmaXgsCnBsZWFzZSBpZ25vcmUgdGhpcyBtYWls
LgoKVGhhbmtzLApLdWFpCj4gCj4gSSBhZ3JlZSwgSSdsbCBkcm9wIHRoaXMgZnJvbSBteSByZXZp
ZXcgcXVldWUgbm93LCB0aGFua3MuCj4gCj4gZ3JlZyBrLWgKPiAuCj4gCgotLQpkbS1kZXZlbCBt
YWlsaW5nIGxpc3QKZG0tZGV2ZWxAcmVkaGF0LmNvbQpodHRwczovL2xpc3RtYW4ucmVkaGF0LmNv
bS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRldmVsCg==

