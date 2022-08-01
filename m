Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F1131C00144
	for <dm-devel@archiver.kernel.org>; Mon,  1 Aug 2022 13:39:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1659361189;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=7u1ptIVCm5RfnMaqCplwdMSOVWhEuoHBS2gnVxmEQqA=;
	b=hIsCunv32S/Tf7zrc7X/BdYT3i6vVHmx0RTokZl0aa8rLtC9xp7DKATM9FXhe/+2e6tGa+
	Y8hMEF8Apq7y5U2XQVT+4iaF7bhT/MqVGSkEm5kcJYq+xM85pObiMcBDvr0iJg1BSKgp1u
	zPqHqbHmXY9MyFsd8SK27NmQNQRAvz4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-103-evt_32vHOSydvMDBUOPiJA-1; Mon, 01 Aug 2022 09:39:47 -0400
X-MC-Unique: evt_32vHOSydvMDBUOPiJA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CF7DD185A794;
	Mon,  1 Aug 2022 13:39:45 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 6A4F34010D27;
	Mon,  1 Aug 2022 13:39:44 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 46CA51946A41;
	Mon,  1 Aug 2022 13:39:44 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 119791946A40
 for <dm-devel@listman.corp.redhat.com>; Mon,  1 Aug 2022 13:39:43 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id E695EC15D62; Mon,  1 Aug 2022 13:39:42 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id E27B8C04482
 for <dm-devel@redhat.com>; Mon,  1 Aug 2022 13:39:42 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C79943C11728
 for <dm-devel@redhat.com>; Mon,  1 Aug 2022 13:39:42 +0000 (UTC)
Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com
 [45.249.212.51]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-135-TWThYYAOPUu3SjX531wKHQ-1; Mon, 01 Aug 2022 09:39:38 -0400
X-MC-Unique: TWThYYAOPUu3SjX531wKHQ-1
Received: from mail02.huawei.com (unknown [172.30.67.153])
 by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4LxK2J55XZzKK6W;
 Mon,  1 Aug 2022 21:38:16 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
 by APP3 (Coremail) with SMTP id _Ch0CgAHhzCS1+di95dMAA--.46231S3;
 Mon, 01 Aug 2022 21:39:32 +0800 (CST)
To: Greg KH <gregkh@linuxfoundation.org>, Yu Kuai <yukuai1@huaweicloud.com>
References: <20220729062356.1663513-1-yukuai1@huaweicloud.com>
 <20220729062356.1663513-2-yukuai1@huaweicloud.com>
 <Yue2rU2Y+xzvGU6x@kroah.com>
 <93acbb5c-5dae-cdf1-5ed2-2c7f5fba6dc7@huaweicloud.com>
 <YufSdhzXq/Fmozdw@kroah.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <b10dc9e7-5219-289d-c25d-da7e9464d3ef@huaweicloud.com>
Date: Mon, 1 Aug 2022 21:39:30 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <YufSdhzXq/Fmozdw@kroah.com>
X-CM-TRANSID: _Ch0CgAHhzCS1+di95dMAA--.46231S3
X-Coremail-Antispam: 1UD129KBjvJXoWxKF13uFWUKr1xWr1kJFW3Awb_yoWxtr1UpF
 98JFZ5GFW8Xr47Wr4Iqw1YyrZ3tw4UKF1xWry7K3WSgrZrtFs2yF1UtryUuF92krZ7Kr42
 qF1UWrZI9Fy0k3DanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
 9KBjDU0xBIdaVrnRJUUU9Y14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
 rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
 1l84ACjcxK6xIIjxv20xvE14v26F1j6w1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26F4j
 6r4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
 Cq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0
 I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r
 4UM4x0Y48IcVAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628vn2kI
 c2xKxwCYjI0SjxkI62AI1cAE67vIY487MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4
 AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE
 17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMI
 IF0xvE2Ix0cI8IcVCY1x0267AKxVWUJVW8JwCI42IY6xAIw20EY4v20xvaj40_WFyUJVCq
 3wCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCT
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
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
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
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"

SGksIEdyZWcKCuWcqCAyMDIyLzA4LzAxIDIxOjE3LCBHcmVnIEtIIOWGmemBkzoKPiBPbiBNb24s
IEF1ZyAwMSwgMjAyMiBhdCAwODoyNToyN1BNICswODAwLCBZdSBLdWFpIHdyb3RlOgo+PiBIaSwg
R3JlZwo+Pgo+PiDlnKggMjAyMi8wOC8wMSAxOToxOSwgR3JlZyBLSCDlhpnpgZM6Cj4+PiBPbiBG
cmksIEp1bCAyOSwgMjAyMiBhdCAwMjoyMzo1NFBNICswODAwLCBZdSBLdWFpIHdyb3RlOgo+Pj4+
IEZyb206IENocmlzdG9waCBIZWxsd2lnIDxoY2hAbHN0LmRlPgo+Pj4+Cj4+Pj4gY29tbWl0IDBk
YmNmZTI0N2YyMmE2ZDczMzAyZGZhNjkxYzQ4YjNjMTRkMzFjNGMgdXBzdHJlYW0uCj4+Pj4KPj4+
PiBJbnZlcnQgdGhleSB3YXkgdGhlIGhvbGRlciByZWxhdGlvbnMgYXJlIHRyYWNrZWQuICBUaGlz
IHZlcnkKPj4+PiBzbGlnaHRseSByZWR1Y2VzIHRoZSBtZW1vcnkgb3ZlcmhlYWQgZm9yIHBhcnRp
dGlvbmVkIGRldmljZXMuCj4+Pj4KPj4+PiBTaWduZWQtb2ZmLWJ5OiBDaHJpc3RvcGggSGVsbHdp
ZyA8aGNoQGxzdC5kZT4KPj4+PiBTaWduZWQtb2ZmLWJ5OiBZdSBLdWFpIDx5dWt1YWkzQGh1YXdl
aS5jb20+Cj4+Pj4gLS0tCj4+Pj4gICAgYmxvY2svZ2VuaGQuYyAgICAgICAgICAgICB8ICAzICsr
Kwo+Pj4+ICAgIGZzL2Jsb2NrX2Rldi5jICAgICAgICAgICAgfCAzMSArKysrKysrKysrKysrKysr
KysrLS0tLS0tLS0tLS0tCj4+Pj4gICAgaW5jbHVkZS9saW51eC9ibGtfdHlwZXMuaCB8ICAzIC0t
LQo+Pj4+ICAgIGluY2x1ZGUvbGludXgvZ2VuaGQuaCAgICAgfCAgNCArKystCj4+Pj4gICAgNCBm
aWxlcyBjaGFuZ2VkLCAyNSBpbnNlcnRpb25zKCspLCAxNiBkZWxldGlvbnMoLSkKPj4+Pgo+Pj4+
IGRpZmYgLS1naXQgYS9ibG9jay9nZW5oZC5jIGIvYmxvY2svZ2VuaGQuYwo+Pj4+IGluZGV4IDc5
NmJhZjc2MTIwMi4uMmIxMWEyNzM1Mjg1IDEwMDY0NAo+Pj4+IC0tLSBhL2Jsb2NrL2dlbmhkLmMK
Pj4+PiArKysgYi9ibG9jay9nZW5oZC5jCj4+Pj4gQEAgLTE3NjAsNiArMTc2MCw5IEBAIHN0cnVj
dCBnZW5kaXNrICpfX2FsbG9jX2Rpc2tfbm9kZShpbnQgbWlub3JzLCBpbnQgbm9kZV9pZCkKPj4+
PiAgICAJZGlza190b19kZXYoZGlzayktPmNsYXNzID0gJmJsb2NrX2NsYXNzOwo+Pj4+ICAgIAlk
aXNrX3RvX2RldihkaXNrKS0+dHlwZSA9ICZkaXNrX3R5cGU7Cj4+Pj4gICAgCWRldmljZV9pbml0
aWFsaXplKGRpc2tfdG9fZGV2KGRpc2spKTsKPj4+PiArI2lmZGVmIENPTkZJR19TWVNGUwo+Pj4+
ICsJSU5JVF9MSVNUX0hFQUQoJmRpc2stPnNsYXZlX2JkZXZzKTsKPj4+PiArI2VuZGlmCj4+Pj4g
ICAgCXJldHVybiBkaXNrOwo+Pj4+ICAgIG91dF9mcmVlX3BhcnQwOgo+Pj4+IGRpZmYgLS1naXQg
YS9mcy9ibG9ja19kZXYuYyBiL2ZzL2Jsb2NrX2Rldi5jCj4+Pj4gaW5kZXggMjlmMDIwYzRiMmQw
Li5hMjAyYzc2ZmNmN2YgMTAwNjQ0Cj4+Pj4gLS0tIGEvZnMvYmxvY2tfZGV2LmMKPj4+PiArKysg
Yi9mcy9ibG9ja19kZXYuYwo+Pj4+IEBAIC04MjMsOSArODIzLDYgQEAgc3RhdGljIHZvaWQgaW5p
dF9vbmNlKHZvaWQgKmZvbykKPj4+PiAgICAJbWVtc2V0KGJkZXYsIDAsIHNpemVvZigqYmRldikp
Owo+Pj4+ICAgIAltdXRleF9pbml0KCZiZGV2LT5iZF9tdXRleCk7Cj4+Pj4gLSNpZmRlZiBDT05G
SUdfU1lTRlMKPj4+PiAtCUlOSVRfTElTVF9IRUFEKCZiZGV2LT5iZF9ob2xkZXJfZGlza3MpOwo+
Pj4+IC0jZW5kaWYKPj4+PiAgICAJYmRldi0+YmRfYmRpID0gJm5vb3BfYmFja2luZ19kZXZfaW5m
bzsKPj4+PiAgICAJaW5vZGVfaW5pdF9vbmNlKCZlaS0+dmZzX2lub2RlKTsKPj4+PiAgICAJLyog
SW5pdGlhbGl6ZSBtdXRleCBmb3IgZnJlZXplLiAqLwo+Pj4+IEBAIC0xMTg4LDcgKzExODUsNyBA
QCBFWFBPUlRfU1lNQk9MKGJkX2Fib3J0X2NsYWltaW5nKTsKPj4+PiAgICAjaWZkZWYgQ09ORklH
X1NZU0ZTCj4+Pj4gICAgc3RydWN0IGJkX2hvbGRlcl9kaXNrIHsKPj4+PiAgICAJc3RydWN0IGxp
c3RfaGVhZAlsaXN0Owo+Pj4+IC0Jc3RydWN0IGdlbmRpc2sJCSpkaXNrOwo+Pj4+ICsJc3RydWN0
IGJsb2NrX2RldmljZQkqYmRldjsKPj4+PiAgICAJaW50CQkJcmVmY250Owo+Pj4+ICAgIH07Cj4+
Pj4gQEAgLTExOTcsOCArMTE5NCw4IEBAIHN0YXRpYyBzdHJ1Y3QgYmRfaG9sZGVyX2Rpc2sgKmJk
X2ZpbmRfaG9sZGVyX2Rpc2soc3RydWN0IGJsb2NrX2RldmljZSAqYmRldiwKPj4+PiAgICB7Cj4+
Pj4gICAgCXN0cnVjdCBiZF9ob2xkZXJfZGlzayAqaG9sZGVyOwo+Pj4+IC0JbGlzdF9mb3JfZWFj
aF9lbnRyeShob2xkZXIsICZiZGV2LT5iZF9ob2xkZXJfZGlza3MsIGxpc3QpCj4+Pj4gLQkJaWYg
KGhvbGRlci0+ZGlzayA9PSBkaXNrKQo+Pj4+ICsJbGlzdF9mb3JfZWFjaF9lbnRyeShob2xkZXIs
ICZkaXNrLT5zbGF2ZV9iZGV2cywgbGlzdCkKPj4+PiArCQlpZiAoaG9sZGVyLT5iZGV2ID09IGJk
ZXYpCj4+Pj4gICAgCQkJcmV0dXJuIGhvbGRlcjsKPj4+PiAgICAJcmV0dXJuIE5VTEw7Cj4+Pj4g
ICAgfQo+Pj4+IEBAIC0xMjQ0LDkgKzEyNDEsMTMgQEAgc3RhdGljIHZvaWQgZGVsX3N5bWxpbmso
c3RydWN0IGtvYmplY3QgKmZyb20sIHN0cnVjdCBrb2JqZWN0ICp0bykKPj4+PiAgICBpbnQgYmRf
bGlua19kaXNrX2hvbGRlcihzdHJ1Y3QgYmxvY2tfZGV2aWNlICpiZGV2LCBzdHJ1Y3QgZ2VuZGlz
ayAqZGlzaykKPj4+PiAgICB7Cj4+Pj4gICAgCXN0cnVjdCBiZF9ob2xkZXJfZGlzayAqaG9sZGVy
Owo+Pj4+ICsJc3RydWN0IGJsb2NrX2RldmljZSAqYmRldl9ob2xkZXIgPSBiZGdldF9kaXNrKGRp
c2ssIDApOwo+Pj4+ICAgIAlpbnQgcmV0ID0gMDsKPj4+PiAtCW11dGV4X2xvY2soJmJkZXYtPmJk
X211dGV4KTsKPj4+PiArCWlmIChXQVJOX09OX09OQ0UoIWJkZXZfaG9sZGVyKSkKPj4+PiArCQly
ZXR1cm4gLUVOT0VOVDsKPj4+PiArCj4+Pj4gKwltdXRleF9sb2NrKCZiZGV2X2hvbGRlci0+YmRf
bXV0ZXgpOwo+Pj4+ICAgIAlXQVJOX09OX09OQ0UoIWJkZXYtPmJkX2hvbGRlcik7Cj4+Pj4gQEAg
LTEyNjcsNyArMTI2OCw3IEBAIGludCBiZF9saW5rX2Rpc2tfaG9sZGVyKHN0cnVjdCBibG9ja19k
ZXZpY2UgKmJkZXYsIHN0cnVjdCBnZW5kaXNrICpkaXNrKQo+Pj4+ICAgIAl9Cj4+Pj4gICAgCUlO
SVRfTElTVF9IRUFEKCZob2xkZXItPmxpc3QpOwo+Pj4+IC0JaG9sZGVyLT5kaXNrID0gZGlzazsK
Pj4+PiArCWhvbGRlci0+YmRldiA9IGJkZXY7Cj4+Pj4gICAgCWhvbGRlci0+cmVmY250ID0gMTsK
Pj4+PiAgICAJcmV0ID0gYWRkX3N5bWxpbmsoZGlzay0+c2xhdmVfZGlyLCAmcGFydF90b19kZXYo
YmRldi0+YmRfcGFydCktPmtvYmopOwo+Pj4+IEBAIC0xMjgzLDcgKzEyODQsNyBAQCBpbnQgYmRf
bGlua19kaXNrX2hvbGRlcihzdHJ1Y3QgYmxvY2tfZGV2aWNlICpiZGV2LCBzdHJ1Y3QgZ2VuZGlz
ayAqZGlzaykKPj4+PiAgICAJICovCj4+Pj4gICAgCWtvYmplY3RfZ2V0KGJkZXYtPmJkX3BhcnQt
PmhvbGRlcl9kaXIpOwo+Pj4+IC0JbGlzdF9hZGQoJmhvbGRlci0+bGlzdCwgJmJkZXYtPmJkX2hv
bGRlcl9kaXNrcyk7Cj4+Pj4gKwlsaXN0X2FkZCgmaG9sZGVyLT5saXN0LCAmZGlzay0+c2xhdmVf
YmRldnMpOwo+Pj4+ICAgIAlnb3RvIG91dF91bmxvY2s7Cj4+Pj4gICAgb3V0X2RlbDoKPj4+PiBA
QCAtMTI5MSw3ICsxMjkyLDggQEAgaW50IGJkX2xpbmtfZGlza19ob2xkZXIoc3RydWN0IGJsb2Nr
X2RldmljZSAqYmRldiwgc3RydWN0IGdlbmRpc2sgKmRpc2spCj4+Pj4gICAgb3V0X2ZyZWU6Cj4+
Pj4gICAgCWtmcmVlKGhvbGRlcik7Cj4+Pj4gICAgb3V0X3VubG9jazoKPj4+PiAtCW11dGV4X3Vu
bG9jaygmYmRldi0+YmRfbXV0ZXgpOwo+Pj4+ICsJbXV0ZXhfdW5sb2NrKCZiZGV2X2hvbGRlci0+
YmRfbXV0ZXgpOwo+Pj4+ICsJYmRwdXQoYmRldl9ob2xkZXIpOwo+Pj4+ICAgIAlyZXR1cm4gcmV0
Owo+Pj4+ICAgIH0KPj4+PiAgICBFWFBPUlRfU1lNQk9MX0dQTChiZF9saW5rX2Rpc2tfaG9sZGVy
KTsKPj4+PiBAQCAtMTMwOSw4ICsxMzExLDEyIEBAIEVYUE9SVF9TWU1CT0xfR1BMKGJkX2xpbmtf
ZGlza19ob2xkZXIpOwo+Pj4+ICAgIHZvaWQgYmRfdW5saW5rX2Rpc2tfaG9sZGVyKHN0cnVjdCBi
bG9ja19kZXZpY2UgKmJkZXYsIHN0cnVjdCBnZW5kaXNrICpkaXNrKQo+Pj4+ICAgIHsKPj4+PiAg
ICAJc3RydWN0IGJkX2hvbGRlcl9kaXNrICpob2xkZXI7Cj4+Pj4gKwlzdHJ1Y3QgYmxvY2tfZGV2
aWNlICpiZGV2X2hvbGRlciA9IGJkZ2V0X2Rpc2soZGlzaywgMCk7Cj4+Pj4gLQltdXRleF9sb2Nr
KCZiZGV2LT5iZF9tdXRleCk7Cj4+Pj4gKwlpZiAoV0FSTl9PTl9PTkNFKCFiZGV2X2hvbGRlcikp
Cj4+Pj4gKwkJcmV0dXJuOwo+Pj4+ICsKPj4+PiArCW11dGV4X2xvY2soJmJkZXZfaG9sZGVyLT5i
ZF9tdXRleCk7Cj4+Pj4gICAgCWhvbGRlciA9IGJkX2ZpbmRfaG9sZGVyX2Rpc2soYmRldiwgZGlz
ayk7Cj4+Pj4gQEAgLTEzMjMsNyArMTMyOSw4IEBAIHZvaWQgYmRfdW5saW5rX2Rpc2tfaG9sZGVy
KHN0cnVjdCBibG9ja19kZXZpY2UgKmJkZXYsIHN0cnVjdCBnZW5kaXNrICpkaXNrKQo+Pj4+ICAg
IAkJa2ZyZWUoaG9sZGVyKTsKPj4+PiAgICAJfQo+Pj4+IC0JbXV0ZXhfdW5sb2NrKCZiZGV2LT5i
ZF9tdXRleCk7Cj4+Pj4gKwltdXRleF91bmxvY2soJmJkZXZfaG9sZGVyLT5iZF9tdXRleCk7Cj4+
Pj4gKwliZHB1dChiZGV2X2hvbGRlcik7Cj4+Pj4gICAgfQo+Pj4+ICAgIEVYUE9SVF9TWU1CT0xf
R1BMKGJkX3VubGlua19kaXNrX2hvbGRlcik7Cj4+Pj4gICAgI2VuZGlmCj4+Pj4gZGlmZiAtLWdp
dCBhL2luY2x1ZGUvbGludXgvYmxrX3R5cGVzLmggYi9pbmNsdWRlL2xpbnV4L2Jsa190eXBlcy5o
Cj4+Pj4gaW5kZXggZDliNjliYmRlNWNjLi4xYjg0ZWNiMzRjMTggMTAwNjQ0Cj4+Pj4gLS0tIGEv
aW5jbHVkZS9saW51eC9ibGtfdHlwZXMuaAo+Pj4+ICsrKyBiL2luY2x1ZGUvbGludXgvYmxrX3R5
cGVzLmgKPj4+PiBAQCAtMjksOSArMjksNiBAQCBzdHJ1Y3QgYmxvY2tfZGV2aWNlIHsKPj4+PiAg
ICAJdm9pZCAqCQkJYmRfaG9sZGVyOwo+Pj4+ICAgIAlpbnQJCQliZF9ob2xkZXJzOwo+Pj4+ICAg
IAlib29sCQkJYmRfd3JpdGVfaG9sZGVyOwo+Pj4+IC0jaWZkZWYgQ09ORklHX1NZU0ZTCj4+Pj4g
LQlzdHJ1Y3QgbGlzdF9oZWFkCWJkX2hvbGRlcl9kaXNrczsKPj4+PiAtI2VuZGlmCj4+Pj4gICAg
CXN0cnVjdCBibG9ja19kZXZpY2UgKgliZF9jb250YWluczsKPj4+PiAgICAJdTgJCQliZF9wYXJ0
bm87Cj4+Pj4gICAgCXN0cnVjdCBoZF9zdHJ1Y3QgKgliZF9wYXJ0Owo+Pj4+IGRpZmYgLS1naXQg
YS9pbmNsdWRlL2xpbnV4L2dlbmhkLmggYi9pbmNsdWRlL2xpbnV4L2dlbmhkLmgKPj4+PiBpbmRl
eCAwM2RhM2Y2MDNkMzAuLjNlNTA0OWE1MjdlNiAxMDA2NDQKPj4+PiAtLS0gYS9pbmNsdWRlL2xp
bnV4L2dlbmhkLmgKPj4+PiArKysgYi9pbmNsdWRlL2xpbnV4L2dlbmhkLmgKPj4+PiBAQCAtMTk1
LDcgKzE5NSw5IEBAIHN0cnVjdCBnZW5kaXNrIHsKPj4+PiAgICAjZGVmaW5lIEdEX05FRURfUEFS
VF9TQ0FOCQkwCj4+Pj4gICAgCXN0cnVjdCByd19zZW1hcGhvcmUgbG9va3VwX3NlbTsKPj4+PiAg
ICAJc3RydWN0IGtvYmplY3QgKnNsYXZlX2RpcjsKPj4+PiAtCj4+Pj4gKyNpZmRlZiBDT05GSUdf
U1lTRlMKPj4+PiArCXN0cnVjdCBsaXN0X2hlYWQJc2xhdmVfYmRldnM7Cj4+Pj4gKyNlbmRpZgo+
Pj4KPj4+IFRoaXMgaXMgdmVyeSBkaWZmZXJlbnQgZnJvbSB0aGUgdXBzdHJlYW0gdmVyc2lvbiwg
YW5kIGZvcmNlcyB0aGUgY2hhbmdlCj4+PiBvbnRvIGV2ZXJ5b25lLCBub3QganVzdCB0aG9zZSB3
aG8gaGFkIENPTkZJR19CTE9DS19IT0xERVJfREVQUkVDQVRFRAo+Pj4gZW5hYmxlZCBsaWtlIHdh
cyBkb25lIGluIHRoZSBtYWluIGtlcm5lbCB0cmVlLgo+Pj4KPj4+IFdoeSBmb3JjZSB0aGlzIG9u
IGFsbCBhbmQgbm90IGp1c3QgdXNlIHRoZSBzYW1lIG9wdGlvbj8KPj4+Cj4+PiBJIHdvdWxkIG5l
ZWQgYSBzdHJvbmcgQUNLIGZyb20gdGhlIG9yaWdpbmFsIGRldmVsb3BlcnMgYW5kIG1haW50YWlu
ZXJzCj4+PiBvZiB0aGVzZSBzdWJzeXN0ZW1zIGJlZm9yZSBiZWluZyBhYmxlIHRvIHRha2UgdGhl
c2UgaW50byB0aGUgNS4xMCB0cmVlLgo+Pgo+PiBZZXMsIEkgYWdyZWUgdGhhdCBDaHJpc3RvcGgg
bXVzdCB0YWtlIGEgbG9vayBmaXJzdC4KPj4+Cj4+PiBXaGF0IHByZXZlbnRzIHlvdSBmcm9tIGp1
c3QgdXNpbmcgNS4xNSBmb3IgdGhvc2Ugc3lzdGVtcyB0aGF0IHJ1biBpbnRvCj4+PiB0aGVzZSBp
c3N1ZXM/Cj4+Cj4+IFRoZSBudWxsIHBvaW50ZXIgcHJvYmxlbSBpcyByZXBvcnRlZCBieSBvdXIg
cHJvZHVjdChyZWxhdGVkIHRvIGRtLQo+PiBtcGF0aCksIGFuZCB0aGV5IGhhZCBiZWVuIHVzaW5n
IDUuMTAgZm9yIGEgbG9uZyB0aW1lLiBBbmQgc3dpdGNoaW5nCj4+IGtlcm5lbCBmb3IgY29tbWVy
Y2lhbCB3aWxsIHJlcXVpcmUgbG90cyBvZiB3b3JrLCBpdCdzIG5vdCBhbiBvcHRpb24KPj4gZm9y
IG5vdy4KPiAKPiBJdCBzaG91bGQgYmUgdGhlIHNhbWUgdmFsaWRhdGlvbiBhbmQgdmVyaWZpY2F0
aW9uIGFuZCB0ZXN0aW5nIHBhdGggZm9yCj4gNS4xNS55IGFzIGZvciBhbiBpbnRydXNpdmUga2Vy
bmVsIGNoYW5nZSBhcyB0aGlzIG9uZSwgcmlnaHQ/ICBXaGF0IG1ha2VzCj4gaXQgYW55IGRpZmZl
cmVudCB0byBwcmV2ZW50IDUuMTUgZnJvbSBiZWluZyB1c2VkPwoKTm8sIHRoZXkgYXJlIG5vdCB0
aGUgc2FtZSwgaWYgd2UgdHJ5IHRvIHVzZSA1LjE1LnksIHdlIGhhdmUgdG8gdGVzdCBhbGwKb3Ro
ZXIgc3R1ZmYgdGhhdCBvdXIgcHJvZHVjdCBpcyB1c2VkIGN1cnJlbnRseShleHQ0LCBibG9jaywg
c2NzaSBhbmQKbG90cyBvZiBvdGhlciBtb2R1bGVzKS4gV2l0aCB0aGlzIHBhdGNoLCB3ZSBvbmx5
IG5lZWQgdG8gbWFrZSBzdXJlCmRtIHdvcmtzIGZpbmUuCgpUaGFua3MsCkt1YWkKCi0tCmRtLWRl
dmVsIG1haWxpbmcgbGlzdApkbS1kZXZlbEByZWRoYXQuY29tCmh0dHBzOi8vbGlzdG1hbi5yZWRo
YXQuY29tL21haWxtYW4vbGlzdGluZm8vZG0tZGV2ZWwK

