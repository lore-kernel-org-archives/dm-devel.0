Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DCF2FC00144
	for <dm-devel@archiver.kernel.org>; Mon,  1 Aug 2022 12:25:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1659356752;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=N8PyXpa0Zjm0602xP98om8d3V5T+cMGkcHJpoGRFYc0=;
	b=dbI79S5T5conPOn0T6ZvwrdATt+Xw4TR36MjtfNF8FgzKc1lCUHddnS8KD3IJljaebeo0i
	Ps6R5VA7A3y8CnJZ+kpRDRXjTAKl9gsSFYh6fFReUYzBx4EfOhwsybpOtb7359fDJyjapv
	ZSkbGqGAICmKpDAlFlnae9V9yzYSDcg=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-661-Ze6v0Jq9NB2ZLY86xgqHAA-1; Mon, 01 Aug 2022 08:25:49 -0400
X-MC-Unique: Ze6v0Jq9NB2ZLY86xgqHAA-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C305B3810D25;
	Mon,  1 Aug 2022 12:25:47 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 2AF7A403166;
	Mon,  1 Aug 2022 12:25:46 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id E32F91946A41;
	Mon,  1 Aug 2022 12:25:45 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id EAE321946A40
 for <dm-devel@listman.corp.redhat.com>; Mon,  1 Aug 2022 12:25:44 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id C83DC401E5C; Mon,  1 Aug 2022 12:25:44 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id C4434492C3B
 for <dm-devel@redhat.com>; Mon,  1 Aug 2022 12:25:44 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id ACE1185A586
 for <dm-devel@redhat.com>; Mon,  1 Aug 2022 12:25:44 +0000 (UTC)
Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com
 [45.249.212.51]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-606-FVxzD_gRM2GKwi92yHt0ag-1; Mon, 01 Aug 2022 08:25:32 -0400
X-MC-Unique: FVxzD_gRM2GKwi92yHt0ag-1
Received: from mail02.huawei.com (unknown [172.30.67.153])
 by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4LxHP43x95zlCF0;
 Mon,  1 Aug 2022 20:24:24 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
 by APP3 (Coremail) with SMTP id _Ch0CgD3djA3xudiJIdKAA--.40632S3;
 Mon, 01 Aug 2022 20:25:28 +0800 (CST)
To: Greg KH <gregkh@linuxfoundation.org>, Yu Kuai <yukuai1@huaweicloud.com>
References: <20220729062356.1663513-1-yukuai1@huaweicloud.com>
 <20220729062356.1663513-2-yukuai1@huaweicloud.com>
 <Yue2rU2Y+xzvGU6x@kroah.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <93acbb5c-5dae-cdf1-5ed2-2c7f5fba6dc7@huaweicloud.com>
Date: Mon, 1 Aug 2022 20:25:27 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <Yue2rU2Y+xzvGU6x@kroah.com>
X-CM-TRANSID: _Ch0CgD3djA3xudiJIdKAA--.40632S3
X-Coremail-Antispam: 1UD129KBjvJXoW3Xw15Gw45uFWDCr4fKryrtFb_yoWxJFW5pF
 98JFZ5GFW8JrW7Wr4Iqa13ZFZIqw48K3WxGFyakF1fKrZrtrs2vF1Utr1UuF92krZ7Kr42
 qF17WFZIkF1093DanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
 9KBjDU0xBIdaVrnRJUUU9F14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
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
 3s1lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcS
 sGvfC2KfnxnUUI43ZEXa7VUbXdbUUUUUU==
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/
X-CFilter-Loop: Reflected
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
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
 stable@vger.kernel.org, linux-block@vger.kernel.org, dm-devel@redhat.com,
 "yukuai \(C\)" <yukuai3@huawei.com>, hch@lst.de
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="gbk"; Format="flowed"

SGksIEdyZWcKCtTaIDIwMjIvMDgvMDEgMTk6MTksIEdyZWcgS0gg0LS1wDoKPiBPbiBGcmksIEp1
bCAyOSwgMjAyMiBhdCAwMjoyMzo1NFBNICswODAwLCBZdSBLdWFpIHdyb3RlOgo+PiBGcm9tOiBD
aHJpc3RvcGggSGVsbHdpZyA8aGNoQGxzdC5kZT4KPj4KPj4gY29tbWl0IDBkYmNmZTI0N2YyMmE2
ZDczMzAyZGZhNjkxYzQ4YjNjMTRkMzFjNGMgdXBzdHJlYW0uCj4+Cj4+IEludmVydCB0aGV5IHdh
eSB0aGUgaG9sZGVyIHJlbGF0aW9ucyBhcmUgdHJhY2tlZC4gIFRoaXMgdmVyeQo+PiBzbGlnaHRs
eSByZWR1Y2VzIHRoZSBtZW1vcnkgb3ZlcmhlYWQgZm9yIHBhcnRpdGlvbmVkIGRldmljZXMuCj4+
Cj4+IFNpZ25lZC1vZmYtYnk6IENocmlzdG9waCBIZWxsd2lnIDxoY2hAbHN0LmRlPgo+PiBTaWdu
ZWQtb2ZmLWJ5OiBZdSBLdWFpIDx5dWt1YWkzQGh1YXdlaS5jb20+Cj4+IC0tLQo+PiAgIGJsb2Nr
L2dlbmhkLmMgICAgICAgICAgICAgfCAgMyArKysKPj4gICBmcy9ibG9ja19kZXYuYyAgICAgICAg
ICAgIHwgMzEgKysrKysrKysrKysrKysrKysrKy0tLS0tLS0tLS0tLQo+PiAgIGluY2x1ZGUvbGlu
dXgvYmxrX3R5cGVzLmggfCAgMyAtLS0KPj4gICBpbmNsdWRlL2xpbnV4L2dlbmhkLmggICAgIHwg
IDQgKysrLQo+PiAgIDQgZmlsZXMgY2hhbmdlZCwgMjUgaW5zZXJ0aW9ucygrKSwgMTYgZGVsZXRp
b25zKC0pCj4+Cj4+IGRpZmYgLS1naXQgYS9ibG9jay9nZW5oZC5jIGIvYmxvY2svZ2VuaGQuYwo+
PiBpbmRleCA3OTZiYWY3NjEyMDIuLjJiMTFhMjczNTI4NSAxMDA2NDQKPj4gLS0tIGEvYmxvY2sv
Z2VuaGQuYwo+PiArKysgYi9ibG9jay9nZW5oZC5jCj4+IEBAIC0xNzYwLDYgKzE3NjAsOSBAQCBz
dHJ1Y3QgZ2VuZGlzayAqX19hbGxvY19kaXNrX25vZGUoaW50IG1pbm9ycywgaW50IG5vZGVfaWQp
Cj4+ICAgCWRpc2tfdG9fZGV2KGRpc2spLT5jbGFzcyA9ICZibG9ja19jbGFzczsKPj4gICAJZGlz
a190b19kZXYoZGlzayktPnR5cGUgPSAmZGlza190eXBlOwo+PiAgIAlkZXZpY2VfaW5pdGlhbGl6
ZShkaXNrX3RvX2RldihkaXNrKSk7Cj4+ICsjaWZkZWYgQ09ORklHX1NZU0ZTCj4+ICsJSU5JVF9M
SVNUX0hFQUQoJmRpc2stPnNsYXZlX2JkZXZzKTsKPj4gKyNlbmRpZgo+PiAgIAlyZXR1cm4gZGlz
azsKPj4gICAKPj4gICBvdXRfZnJlZV9wYXJ0MDoKPj4gZGlmZiAtLWdpdCBhL2ZzL2Jsb2NrX2Rl
di5jIGIvZnMvYmxvY2tfZGV2LmMKPj4gaW5kZXggMjlmMDIwYzRiMmQwLi5hMjAyYzc2ZmNmN2Yg
MTAwNjQ0Cj4+IC0tLSBhL2ZzL2Jsb2NrX2Rldi5jCj4+ICsrKyBiL2ZzL2Jsb2NrX2Rldi5jCj4+
IEBAIC04MjMsOSArODIzLDYgQEAgc3RhdGljIHZvaWQgaW5pdF9vbmNlKHZvaWQgKmZvbykKPj4g
ICAKPj4gICAJbWVtc2V0KGJkZXYsIDAsIHNpemVvZigqYmRldikpOwo+PiAgIAltdXRleF9pbml0
KCZiZGV2LT5iZF9tdXRleCk7Cj4+IC0jaWZkZWYgQ09ORklHX1NZU0ZTCj4+IC0JSU5JVF9MSVNU
X0hFQUQoJmJkZXYtPmJkX2hvbGRlcl9kaXNrcyk7Cj4+IC0jZW5kaWYKPj4gICAJYmRldi0+YmRf
YmRpID0gJm5vb3BfYmFja2luZ19kZXZfaW5mbzsKPj4gICAJaW5vZGVfaW5pdF9vbmNlKCZlaS0+
dmZzX2lub2RlKTsKPj4gICAJLyogSW5pdGlhbGl6ZSBtdXRleCBmb3IgZnJlZXplLiAqLwo+PiBA
QCAtMTE4OCw3ICsxMTg1LDcgQEAgRVhQT1JUX1NZTUJPTChiZF9hYm9ydF9jbGFpbWluZyk7Cj4+
ICAgI2lmZGVmIENPTkZJR19TWVNGUwo+PiAgIHN0cnVjdCBiZF9ob2xkZXJfZGlzayB7Cj4+ICAg
CXN0cnVjdCBsaXN0X2hlYWQJbGlzdDsKPj4gLQlzdHJ1Y3QgZ2VuZGlzawkJKmRpc2s7Cj4+ICsJ
c3RydWN0IGJsb2NrX2RldmljZQkqYmRldjsKPj4gICAJaW50CQkJcmVmY250Owo+PiAgIH07Cj4+
ICAgCj4+IEBAIC0xMTk3LDggKzExOTQsOCBAQCBzdGF0aWMgc3RydWN0IGJkX2hvbGRlcl9kaXNr
ICpiZF9maW5kX2hvbGRlcl9kaXNrKHN0cnVjdCBibG9ja19kZXZpY2UgKmJkZXYsCj4+ICAgewo+
PiAgIAlzdHJ1Y3QgYmRfaG9sZGVyX2Rpc2sgKmhvbGRlcjsKPj4gICAKPj4gLQlsaXN0X2Zvcl9l
YWNoX2VudHJ5KGhvbGRlciwgJmJkZXYtPmJkX2hvbGRlcl9kaXNrcywgbGlzdCkKPj4gLQkJaWYg
KGhvbGRlci0+ZGlzayA9PSBkaXNrKQo+PiArCWxpc3RfZm9yX2VhY2hfZW50cnkoaG9sZGVyLCAm
ZGlzay0+c2xhdmVfYmRldnMsIGxpc3QpCj4+ICsJCWlmIChob2xkZXItPmJkZXYgPT0gYmRldikK
Pj4gICAJCQlyZXR1cm4gaG9sZGVyOwo+PiAgIAlyZXR1cm4gTlVMTDsKPj4gICB9Cj4+IEBAIC0x
MjQ0LDkgKzEyNDEsMTMgQEAgc3RhdGljIHZvaWQgZGVsX3N5bWxpbmsoc3RydWN0IGtvYmplY3Qg
KmZyb20sIHN0cnVjdCBrb2JqZWN0ICp0bykKPj4gICBpbnQgYmRfbGlua19kaXNrX2hvbGRlcihz
dHJ1Y3QgYmxvY2tfZGV2aWNlICpiZGV2LCBzdHJ1Y3QgZ2VuZGlzayAqZGlzaykKPj4gICB7Cj4+
ICAgCXN0cnVjdCBiZF9ob2xkZXJfZGlzayAqaG9sZGVyOwo+PiArCXN0cnVjdCBibG9ja19kZXZp
Y2UgKmJkZXZfaG9sZGVyID0gYmRnZXRfZGlzayhkaXNrLCAwKTsKPj4gICAJaW50IHJldCA9IDA7
Cj4+ICAgCj4+IC0JbXV0ZXhfbG9jaygmYmRldi0+YmRfbXV0ZXgpOwo+PiArCWlmIChXQVJOX09O
X09OQ0UoIWJkZXZfaG9sZGVyKSkKPj4gKwkJcmV0dXJuIC1FTk9FTlQ7Cj4+ICsKPj4gKwltdXRl
eF9sb2NrKCZiZGV2X2hvbGRlci0+YmRfbXV0ZXgpOwo+PiAgIAo+PiAgIAlXQVJOX09OX09OQ0Uo
IWJkZXYtPmJkX2hvbGRlcik7Cj4+ICAgCj4+IEBAIC0xMjY3LDcgKzEyNjgsNyBAQCBpbnQgYmRf
bGlua19kaXNrX2hvbGRlcihzdHJ1Y3QgYmxvY2tfZGV2aWNlICpiZGV2LCBzdHJ1Y3QgZ2VuZGlz
ayAqZGlzaykKPj4gICAJfQo+PiAgIAo+PiAgIAlJTklUX0xJU1RfSEVBRCgmaG9sZGVyLT5saXN0
KTsKPj4gLQlob2xkZXItPmRpc2sgPSBkaXNrOwo+PiArCWhvbGRlci0+YmRldiA9IGJkZXY7Cj4+
ICAgCWhvbGRlci0+cmVmY250ID0gMTsKPj4gICAKPj4gICAJcmV0ID0gYWRkX3N5bWxpbmsoZGlz
ay0+c2xhdmVfZGlyLCAmcGFydF90b19kZXYoYmRldi0+YmRfcGFydCktPmtvYmopOwo+PiBAQCAt
MTI4Myw3ICsxMjg0LDcgQEAgaW50IGJkX2xpbmtfZGlza19ob2xkZXIoc3RydWN0IGJsb2NrX2Rl
dmljZSAqYmRldiwgc3RydWN0IGdlbmRpc2sgKmRpc2spCj4+ICAgCSAqLwo+PiAgIAlrb2JqZWN0
X2dldChiZGV2LT5iZF9wYXJ0LT5ob2xkZXJfZGlyKTsKPj4gICAKPj4gLQlsaXN0X2FkZCgmaG9s
ZGVyLT5saXN0LCAmYmRldi0+YmRfaG9sZGVyX2Rpc2tzKTsKPj4gKwlsaXN0X2FkZCgmaG9sZGVy
LT5saXN0LCAmZGlzay0+c2xhdmVfYmRldnMpOwo+PiAgIAlnb3RvIG91dF91bmxvY2s7Cj4+ICAg
Cj4+ICAgb3V0X2RlbDoKPj4gQEAgLTEyOTEsNyArMTI5Miw4IEBAIGludCBiZF9saW5rX2Rpc2tf
aG9sZGVyKHN0cnVjdCBibG9ja19kZXZpY2UgKmJkZXYsIHN0cnVjdCBnZW5kaXNrICpkaXNrKQo+
PiAgIG91dF9mcmVlOgo+PiAgIAlrZnJlZShob2xkZXIpOwo+PiAgIG91dF91bmxvY2s6Cj4+IC0J
bXV0ZXhfdW5sb2NrKCZiZGV2LT5iZF9tdXRleCk7Cj4+ICsJbXV0ZXhfdW5sb2NrKCZiZGV2X2hv
bGRlci0+YmRfbXV0ZXgpOwo+PiArCWJkcHV0KGJkZXZfaG9sZGVyKTsKPj4gICAJcmV0dXJuIHJl
dDsKPj4gICB9Cj4+ICAgRVhQT1JUX1NZTUJPTF9HUEwoYmRfbGlua19kaXNrX2hvbGRlcik7Cj4+
IEBAIC0xMzA5LDggKzEzMTEsMTIgQEAgRVhQT1JUX1NZTUJPTF9HUEwoYmRfbGlua19kaXNrX2hv
bGRlcik7Cj4+ICAgdm9pZCBiZF91bmxpbmtfZGlza19ob2xkZXIoc3RydWN0IGJsb2NrX2Rldmlj
ZSAqYmRldiwgc3RydWN0IGdlbmRpc2sgKmRpc2spCj4+ICAgewo+PiAgIAlzdHJ1Y3QgYmRfaG9s
ZGVyX2Rpc2sgKmhvbGRlcjsKPj4gKwlzdHJ1Y3QgYmxvY2tfZGV2aWNlICpiZGV2X2hvbGRlciA9
IGJkZ2V0X2Rpc2soZGlzaywgMCk7Cj4+ICAgCj4+IC0JbXV0ZXhfbG9jaygmYmRldi0+YmRfbXV0
ZXgpOwo+PiArCWlmIChXQVJOX09OX09OQ0UoIWJkZXZfaG9sZGVyKSkKPj4gKwkJcmV0dXJuOwo+
PiArCj4+ICsJbXV0ZXhfbG9jaygmYmRldl9ob2xkZXItPmJkX211dGV4KTsKPj4gICAKPj4gICAJ
aG9sZGVyID0gYmRfZmluZF9ob2xkZXJfZGlzayhiZGV2LCBkaXNrKTsKPj4gICAKPj4gQEAgLTEz
MjMsNyArMTMyOSw4IEBAIHZvaWQgYmRfdW5saW5rX2Rpc2tfaG9sZGVyKHN0cnVjdCBibG9ja19k
ZXZpY2UgKmJkZXYsIHN0cnVjdCBnZW5kaXNrICpkaXNrKQo+PiAgIAkJa2ZyZWUoaG9sZGVyKTsK
Pj4gICAJfQo+PiAgIAo+PiAtCW11dGV4X3VubG9jaygmYmRldi0+YmRfbXV0ZXgpOwo+PiArCW11
dGV4X3VubG9jaygmYmRldl9ob2xkZXItPmJkX211dGV4KTsKPj4gKwliZHB1dChiZGV2X2hvbGRl
cik7Cj4+ICAgfQo+PiAgIEVYUE9SVF9TWU1CT0xfR1BMKGJkX3VubGlua19kaXNrX2hvbGRlcik7
Cj4+ICAgI2VuZGlmCj4+IGRpZmYgLS1naXQgYS9pbmNsdWRlL2xpbnV4L2Jsa190eXBlcy5oIGIv
aW5jbHVkZS9saW51eC9ibGtfdHlwZXMuaAo+PiBpbmRleCBkOWI2OWJiZGU1Y2MuLjFiODRlY2Iz
NGMxOCAxMDA2NDQKPj4gLS0tIGEvaW5jbHVkZS9saW51eC9ibGtfdHlwZXMuaAo+PiArKysgYi9p
bmNsdWRlL2xpbnV4L2Jsa190eXBlcy5oCj4+IEBAIC0yOSw5ICsyOSw2IEBAIHN0cnVjdCBibG9j
a19kZXZpY2Ugewo+PiAgIAl2b2lkICoJCQliZF9ob2xkZXI7Cj4+ICAgCWludAkJCWJkX2hvbGRl
cnM7Cj4+ICAgCWJvb2wJCQliZF93cml0ZV9ob2xkZXI7Cj4+IC0jaWZkZWYgQ09ORklHX1NZU0ZT
Cj4+IC0Jc3RydWN0IGxpc3RfaGVhZAliZF9ob2xkZXJfZGlza3M7Cj4+IC0jZW5kaWYKPj4gICAJ
c3RydWN0IGJsb2NrX2RldmljZSAqCWJkX2NvbnRhaW5zOwo+PiAgIAl1OAkJCWJkX3BhcnRubzsK
Pj4gICAJc3RydWN0IGhkX3N0cnVjdCAqCWJkX3BhcnQ7Cj4+IGRpZmYgLS1naXQgYS9pbmNsdWRl
L2xpbnV4L2dlbmhkLmggYi9pbmNsdWRlL2xpbnV4L2dlbmhkLmgKPj4gaW5kZXggMDNkYTNmNjAz
ZDMwLi4zZTUwNDlhNTI3ZTYgMTAwNjQ0Cj4+IC0tLSBhL2luY2x1ZGUvbGludXgvZ2VuaGQuaAo+
PiArKysgYi9pbmNsdWRlL2xpbnV4L2dlbmhkLmgKPj4gQEAgLTE5NSw3ICsxOTUsOSBAQCBzdHJ1
Y3QgZ2VuZGlzayB7Cj4+ICAgI2RlZmluZSBHRF9ORUVEX1BBUlRfU0NBTgkJMAo+PiAgIAlzdHJ1
Y3Qgcndfc2VtYXBob3JlIGxvb2t1cF9zZW07Cj4+ICAgCXN0cnVjdCBrb2JqZWN0ICpzbGF2ZV9k
aXI7Cj4+IC0KPj4gKyNpZmRlZiBDT05GSUdfU1lTRlMKPj4gKwlzdHJ1Y3QgbGlzdF9oZWFkCXNs
YXZlX2JkZXZzOwo+PiArI2VuZGlmCj4gCj4gVGhpcyBpcyB2ZXJ5IGRpZmZlcmVudCBmcm9tIHRo
ZSB1cHN0cmVhbSB2ZXJzaW9uLCBhbmQgZm9yY2VzIHRoZSBjaGFuZ2UKPiBvbnRvIGV2ZXJ5b25l
LCBub3QganVzdCB0aG9zZSB3aG8gaGFkIENPTkZJR19CTE9DS19IT0xERVJfREVQUkVDQVRFRAo+
IGVuYWJsZWQgbGlrZSB3YXMgZG9uZSBpbiB0aGUgbWFpbiBrZXJuZWwgdHJlZS4KPiAKPiBXaHkg
Zm9yY2UgdGhpcyBvbiBhbGwgYW5kIG5vdCBqdXN0IHVzZSB0aGUgc2FtZSBvcHRpb24/Cj4gCj4g
SSB3b3VsZCBuZWVkIGEgc3Ryb25nIEFDSyBmcm9tIHRoZSBvcmlnaW5hbCBkZXZlbG9wZXJzIGFu
ZCBtYWludGFpbmVycwo+IG9mIHRoZXNlIHN1YnN5c3RlbXMgYmVmb3JlIGJlaW5nIGFibGUgdG8g
dGFrZSB0aGVzZSBpbnRvIHRoZSA1LjEwIHRyZWUuCgpZZXMsIEkgYWdyZWUgdGhhdCBDaHJpc3Rv
cGggbXVzdCB0YWtlIGEgbG9vayBmaXJzdC4KPiAKPiBXaGF0IHByZXZlbnRzIHlvdSBmcm9tIGp1
c3QgdXNpbmcgNS4xNSBmb3IgdGhvc2Ugc3lzdGVtcyB0aGF0IHJ1biBpbnRvCj4gdGhlc2UgaXNz
dWVzPwoKVGhlIG51bGwgcG9pbnRlciBwcm9ibGVtIGlzIHJlcG9ydGVkIGJ5IG91ciBwcm9kdWN0
KHJlbGF0ZWQgdG8gZG0tCm1wYXRoKSwgYW5kIHRoZXkgaGFkIGJlZW4gdXNpbmcgNS4xMCBmb3Ig
YSBsb25nIHRpbWUuIEFuZCBzd2l0Y2hpbmcKa2VybmVsIGZvciBjb21tZXJjaWFsIHdpbGwgcmVx
dWlyZSBsb3RzIG9mIHdvcmssIGl0J3Mgbm90IGFuIG9wdGlvbgpmb3Igbm93LgoKVGhhbmtzLApL
dWFpCgotLQpkbS1kZXZlbCBtYWlsaW5nIGxpc3QKZG0tZGV2ZWxAcmVkaGF0LmNvbQpodHRwczov
L2xpc3RtYW4ucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRldmVsCg==

