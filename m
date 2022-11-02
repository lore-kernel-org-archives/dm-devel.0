Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C0AB7C43217
	for <dm-devel@archiver.kernel.org>; Thu,  3 Nov 2022 07:57:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1667462242;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=OW18/+WqoJsrehIA8rZctXxGPFP6Zc4aZnfeFL+usJo=;
	b=RMqbnovJvvtnD1KgB6E96QB3ruy0Bq6i9oe0c1BK4mi7jZQf0azKW0jBjHByZyBIpm8wKy
	Mjnj3B13n5WZIlNkazEipNuTRM7/VdvMecbEfomuPXMO4gL0cH8aalUpnt6doO08pwafgz
	PeeFc4FsHpnCde3Ui6238FLMBn1+j7Y=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-214-GElmSc7cP3Crm2EdOvNVXg-1; Thu, 03 Nov 2022 03:57:19 -0400
X-MC-Unique: GElmSc7cP3Crm2EdOvNVXg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 07646101A54E;
	Thu,  3 Nov 2022 07:57:18 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id E45CDC4C9D6;
	Thu,  3 Nov 2022 07:57:17 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id B840E1946A7A;
	Thu,  3 Nov 2022 07:57:17 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id EC16E1946597
 for <dm-devel@listman.corp.redhat.com>; Wed,  2 Nov 2022 12:17:53 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id C898949BB67; Wed,  2 Nov 2022 12:17:48 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id C129849BB60
 for <dm-devel@redhat.com>; Wed,  2 Nov 2022 12:17:48 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9DFB92A2AD71
 for <dm-devel@redhat.com>; Wed,  2 Nov 2022 12:17:48 +0000 (UTC)
Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com
 [45.249.212.56]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-303-E4mu4jTwNDmdfdoxcKIkAQ-1; Wed, 02 Nov 2022 08:17:43 -0400
X-MC-Unique: E4mu4jTwNDmdfdoxcKIkAQ-1
Received: from mail02.huawei.com (unknown [172.30.67.169])
 by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4N2QnQ4Xkvz6Plcx;
 Wed,  2 Nov 2022 20:15:06 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
 by APP1 (Coremail) with SMTP id cCh0CgCXcXrhX2Jj3Fa+BA--.40938S3;
 Wed, 02 Nov 2022 20:17:39 +0800 (CST)
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
 Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>
References: <20221102064854.GA8950@lst.de>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <1dc5c1d0-72b6-5455-0b05-5c755ad69045@huaweicloud.com>
Date: Wed, 2 Nov 2022 20:17:37 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20221102064854.GA8950@lst.de>
X-CM-TRANSID: cCh0CgCXcXrhX2Jj3Fa+BA--.40938S3
X-Coremail-Antispam: 1UD129KBjvJXoWxJrW7Gr1xXw1fJr48AFWkJFb_yoW8uFWrpa
 9YgFyrKry8JF47ua1qqw1UXrWY9w10gF18JasIvr1IvrW3Jrs29F1fAryUWF1Igrs2vrs0
 qF1UZayYvF1vkFJanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
 9KBjDU0xBIdaVrnRJUUUkC14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
 rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
 1l84ACjcxK6xIIjxv20xvE14v26F1j6w1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26F4j
 6r4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
 Cq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0
 I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r
 4UM4x0Y48IcVAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwCYjI0SjxkI62AI1cAE67vI
 Y487MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI
 0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y
 0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxV
 WUJVW8JwCI42IY6xAIw20EY4v20xvaj40_WFyUJVCq3wCI42IY6I8E87Iv67AKxVWUJVW8
 JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjfUoOJ5UU
 UUU
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/
X-CFilter-Loop: Reflected
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Mailman-Approved-At: Thu, 03 Nov 2022 07:57:16 +0000
Subject: Re: [dm-devel] [PATCH 8/7] block: don't claim devices that are not
 live in bd_link_disk_holder
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
Cc: linux-block@vger.kernel.org, Yu Kuai <yukuai1@huaweicloud.com>,
 dm-devel@redhat.com, "yukuai \(C\)" <yukuai3@huawei.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"

SGksCgrlnKggMjAyMi8xMS8wMiAxNDo0OCwgQ2hyaXN0b3BoIEhlbGx3aWcg5YaZ6YGTOgo+IEZv
ciBnZW5kaXNrIHRoYXQgYXJlIG5vdCBsaXZlIG9yIHRoZWlyIHBhcnRpdGlvbnMsIHRoZSBiZF9o
b2xkZXJfZGlyCj4gcG9pbnRlciBpcyBub3QgdmFsaWQgYW5kIHRoZSBrb2JqZWN0IG1pZ2h0IG5v
dCBoYXZlIGJlZW4gYWxsb2NhdGVkCj4geWV0IG9yIGZyZWVkIGFscmVhZHkuICBDaGVjayB0aGF0
IHRoZSBkaXNrIGlzIGxpdmUgYmVmb3JlIGNyZWF0aW5nIHRoZQo+IGxpbmthZ2UgYW5kIGVycm9y
IG91dCBvdGhlcndpc2UuCj4gCj4gU2lnbmVkLW9mZi1ieTogQ2hyaXN0b3BoIEhlbGx3aWcgPGhj
aEBsc3QuZGU+Cj4gLS0tCj4gICBibG9jay9ob2xkZXIuYyB8IDUgKysrKysKPiAgIDEgZmlsZSBj
aGFuZ2VkLCA1IGluc2VydGlvbnMoKykKPiAKPiBkaWZmIC0tZ2l0IGEvYmxvY2svaG9sZGVyLmMg
Yi9ibG9jay9ob2xkZXIuYwo+IGluZGV4IGE4YzM1NWI5ZDA4MDYuLmE4ODA2YmJlZDIxMTIgMTAw
NjQ0Cj4gLS0tIGEvYmxvY2svaG9sZGVyLmMKPiArKysgYi9ibG9jay9ob2xkZXIuYwo+IEBAIC02
Niw2ICs2NiwxMSBAQCBpbnQgYmRfbGlua19kaXNrX2hvbGRlcihzdHJ1Y3QgYmxvY2tfZGV2aWNl
ICpiZGV2LCBzdHJ1Y3QgZ2VuZGlzayAqZGlzaykKPiAgIAkJcmV0dXJuIC1FSU5WQUw7Cj4gICAK
PiAgIAltdXRleF9sb2NrKCZkaXNrLT5vcGVuX211dGV4KTsKPiArCS8qIGJkX2hvbGRlcl9kaXIg
aXMgb25seSB2YWxpZCBmb3IgbGl2ZSBkaXNrcyAqLwo+ICsJaWYgKCFkaXNrX2xpdmUoYmRldi0+
YmRfZGlzaykpIHsKPiArCQlyZXQgPSAtRUlOVkFMOwo+ICsJCWdvdG8gb3V0X3VubG9jazsKPiAr
CX0KCkkgdGhpbmsgdGhpcyBpcyBzdGlsbCBub3Qgc2FmZSDwn6SUCgpIb3cgYWJvdXQgdGhpczoK
CmRpZmYgLS1naXQgYS9ibG9jay9ob2xkZXIuYyBiL2Jsb2NrL2hvbGRlci5jCmluZGV4IDUyODNi
YzgwNGNjMS4uMzVmZGZiYTU1OGI4IDEwMDY0NAotLS0gYS9ibG9jay9ob2xkZXIuYworKysgYi9i
bG9jay9ob2xkZXIuYwpAQCAtODUsNiArODUsMjAgQEAgaW50IGJkX2xpbmtfZGlza19ob2xkZXIo
c3RydWN0IGJsb2NrX2RldmljZSAqYmRldiwgCnN0cnVjdCBnZW5kaXNrICpkaXNrKQogICAgICAg
ICAgICAgICAgIGdvdG8gb3V0X3VubG9jazsKICAgICAgICAgfQoKKyAgICAgICAvKgorICAgICAg
ICAqIGRlbF9nZW5kaXNrIGRyb3BzIHRoZSBpbml0aWFsIHJlZmVyZW5jZSB0byBiZF9ob2xkZXJf
ZGlyLCBzbyAKd2UgbmVlZAorICAgICAgICAqIHRvIGtlZXAgb3VyIG93biBoZXJlIHRvIGFsbG93
IGZvciBjbGVhbnVwIHBhc3QgdGhhdCBwb2ludC4KKyAgICAgICAgKi8KKyAgICAgICBtdXRleF9s
b2NrKCZiZGV2LT5iZF9kaXNrLT5vcGVuX211dGV4KTsKKyAgICAgICBpZiAoIWRpc2tfbGl2ZShi
ZGV2LT5iZF9kaXNrKSkgeworICAgICAgICAgICAgICAgcmV0ID0gLUVOT0RFVjsKKyAgICAgICAg
ICAgICAgIG11dGV4X3VubG9jaygmYmRldi0+YmRfZGlzay0+b3Blbl9tdXRleCk7CisgICAgICAg
ICAgICAgICBnb3RvIG91dF91bmxvY2s7CisgICAgICAgfQorCisgICAgICAga29iamVjdF9nZXQo
YmRldi0+YmRfaG9sZGVyX2Rpcik7CisgICAgICAgbXV0ZXhfdW5sb2NrKCZiZGV2LT5iZF9kaXNr
LT5vcGVuX211dGV4KTsKKwogICAgICAgICBob2xkZXIgPSBremFsbG9jKHNpemVvZigqaG9sZGVy
KSwgR0ZQX0tFUk5FTCk7CiAgICAgICAgIGlmICghaG9sZGVyKSB7CiAgICAgICAgICAgICAgICAg
cmV0ID0gLUVOT01FTTsKQEAgLTEwMywxMSArMTE3LDYgQEAgaW50IGJkX2xpbmtfZGlza19ob2xk
ZXIoc3RydWN0IGJsb2NrX2RldmljZSAqYmRldiwgCnN0cnVjdCBnZW5kaXNrICpkaXNrKQogICAg
ICAgICB9CgogICAgICAgICBsaXN0X2FkZCgmaG9sZGVyLT5saXN0LCAmZGlzay0+c2xhdmVfYmRl
dnMpOwotICAgICAgIC8qCi0gICAgICAgICogZGVsX2dlbmRpc2sgZHJvcHMgdGhlIGluaXRpYWwg
cmVmZXJlbmNlIHRvIGJkX2hvbGRlcl9kaXIsIHNvIAp3ZSBuZWVkCi0gICAgICAgICogdG8ga2Vl
cCBvdXIgb3duIGhlcmUgdG8gYWxsb3cgZm9yIGNsZWFudXAgcGFzdCB0aGF0IHBvaW50LgotICAg
ICAgICAqLwotICAgICAgIGtvYmplY3RfZ2V0KGJkZXYtPmJkX2hvbGRlcl9kaXIpOwoKYmRldi0+
YmRfZGlzay0+b3Blbl9tdXRleCBzaG91bGQgYmUgaG9sZCwgYm90aCBkaXNfbGl2ZSgpIGFuZApr
b2JqZWN0X2dldCgpIHNob3VsZCBiZSBwcm90ZWN0ZWQuCgpUaGFuc2ssCkt1YWkKPiAgIAo+ICAg
CVdBUk5fT05fT05DRSghYmRldi0+YmRfaG9sZGVyKTsKPiAgIAo+IAoKLS0KZG0tZGV2ZWwgbWFp
bGluZyBsaXN0CmRtLWRldmVsQHJlZGhhdC5jb20KaHR0cHM6Ly9saXN0bWFuLnJlZGhhdC5jb20v
bWFpbG1hbi9saXN0aW5mby9kbS1kZXZlbAo=

