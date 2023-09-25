Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 603ECCE7A8B
	for <dm-devel@archiver.kernel.org>; Mon, 25 Sep 2023 01:18:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1695604715;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=4veV+Q8ua5h7uRSiSgFmbKM0o/5UisqmG6MykqL3i20=;
	b=OzR9VhtJaxWJaSx3X8153uQE9jSHIv+Lj3Ln92Vw4XrjxCJYVIISFeah7xRo8YJqtOOmSc
	UtOhtLzBw23orSZ/N9nvzWMz+ec1KiiBSgu651b5SblsmVuySPj5iAluwYJdstKhvLBKRz
	cZIBikMyjymeBtrEeGoanmmNe5Rpjl0=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-655-4EHjf8zGOqGhmX84T8JA9w-1; Sun, 24 Sep 2023 21:18:32 -0400
X-MC-Unique: 4EHjf8zGOqGhmX84T8JA9w-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4BDB429AA2D6;
	Mon, 25 Sep 2023 01:18:30 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 9AEA7492C37;
	Mon, 25 Sep 2023 01:18:26 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 43E631946597;
	Mon, 25 Sep 2023 01:18:26 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 7861A194658C
 for <dm-devel@listman.corp.redhat.com>; Mon, 25 Sep 2023 01:18:23 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id D549D2156A27; Mon, 25 Sep 2023 01:18:23 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id CD5A02156701
 for <dm-devel@redhat.com>; Mon, 25 Sep 2023 01:18:23 +0000 (UTC)
Received: from us-smtp-inbound-delivery-1.mimecast.com
 (us-smtp-inbound-delivery-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id ABADF85A5BF
 for <dm-devel@redhat.com>; Mon, 25 Sep 2023 01:18:23 +0000 (UTC)
Received: from dggsgout11.his.huawei.com (hwsga01-in.huaweimarine.com
 [45.249.212.51]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-507-iko3J6FmNtyEx6vc9VEOQw-1; Sun, 24 Sep 2023 21:18:19 -0400
X-MC-Unique: iko3J6FmNtyEx6vc9VEOQw-1
Received: from mail02.huawei.com (unknown [172.30.67.143])
 by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4Rv4kW1T89z4f3lff;
 Mon, 25 Sep 2023 09:18:11 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
 by APP4 (Coremail) with SMTP id gCh0CgB3BdXT3xBlhCZJBQ--.61915S3;
 Mon, 25 Sep 2023 09:18:13 +0800 (CST)
To: Xiao Ni <xni@redhat.com>, Yu Kuai <yukuai1@huaweicloud.com>
References: <20230828020021.2489641-1-yukuai1@huaweicloud.com>
 <20230828020021.2489641-2-yukuai1@huaweicloud.com>
 <CALTww28MiiWTOyLYHErAZWTzn8iGif5=adY7yohxmn1OxrpK=w@mail.gmail.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <4d8fc562-5e9a-3932-90d4-c7566696d965@huaweicloud.com>
Date: Mon, 25 Sep 2023 09:18:11 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <CALTww28MiiWTOyLYHErAZWTzn8iGif5=adY7yohxmn1OxrpK=w@mail.gmail.com>
X-CM-TRANSID: gCh0CgB3BdXT3xBlhCZJBQ--.61915S3
X-Coremail-Antispam: 1UD129KBjvJXoWxJF4fuFyUZF1fuF4rXF17GFg_yoW5Cry8p3
 yIgFW5Cr4UtasxA34jq3WkCFyrXw4aqrWqyrZrW3W7C3WxGrn3GF15Wry3Wr9YvF97CFs3
 Ga1UA3WUA348GFUanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
 9KBjDU0xBIdaVrnRJUUU9F14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
 rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
 1l84ACjcxK6xIIjxv20xvE14v26ryj6F1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26F4j
 6r4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
 Cq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0
 I7IYx2IY67AKxVWUXVWUAwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r
 4UM4x0Y48IcVAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628vn2kI
 c2xKxwCYjI0SjxkI62AI1cAE67vIY487MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4
 AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE
 17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMI
 IF0xvE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwCI42IY6xAIw20EY4v20xvaj40_Wr1j6rW3
 Jr1lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcS
 sGvfC2KfnxnUUI43ZEXa7VUbE_M3UUUUU==
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/
X-CFilter-Loop: Reflected
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
Subject: Re: [dm-devel] [PATCH -next v2 01/28] md: use READ_ONCE/WRITE_ONCE
 for 'suspend_lo' and 'suspend_hi'
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
Cc: yi.zhang@huawei.com, yangerkun@huawei.com, snitzer@kernel.org,
 linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, song@kernel.org,
 dm-devel@redhat.com, "yukuai \(C\)" <yukuai3@huawei.com>, agk@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: huaweicloud.com
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"

SGksCgrlnKggMjAyMy8wOS8xNCAxMDo1MywgWGlhbyBOaSDlhpnpgZM6Cj4gT24gTW9uLCBBdWcg
MjgsIDIwMjMgYXQgMTA6MDTigK9BTSBZdSBLdWFpIDx5dWt1YWkxQGh1YXdlaWNsb3VkLmNvbT4g
d3JvdGU6Cj4+Cj4+IEZyb206IFl1IEt1YWkgPHl1a3VhaTNAaHVhd2VpLmNvbT4KPj4KPj4gQmVj
YXVzZSByZWFkaW5nICdzdXNwZW5kX2xvJyBhbmQgJ3N1c3BlbmRfaGknIGZyb20gbWRfaGFuZGxl
X3JlcXVlc3QoKQo+PiBpcyBub3QgcHJvdGVjdGVkLCB1c2UgUkVBRF9PTkNFL1dSSVRFX09OQ0Ug
dG8gcHJldmVudCByZWFkaW5nIGFibm9ybWFsCj4+IHZhbHVlLgo+IAo+IEhpIEt1YWkKPiAKPiBJ
ZiB3ZSBkb24ndCB1c2UgUkVBRF9PTkNFL1dSSVRFX09OQ0UsIFdoYXQncyB0aGUgcmlzayBoZXJl
PyBDb3VsZCB5b3UKPiBleHBsYWluIGluIGRldGFpbCBvciBnaXZlIGFuIGV4YW1wbGU/CgpTb3Jy
eSBmb3IgdGhlIGxhdGUgcmVwbHkuCgpUaGF0IGRlcGVuZHMgb24gdGhlIGFyY2hpdGVjdHVyZSwg
YSBsb2FkL3N0b3JlIG1heSBub3QgYmUgYXRvbWljZSwKZm9yIGV4YW1wbGU6CgovLyBhc3N1bWUg
YSBpcyAxMAp0MSB3cml0ZSAwMQovLyB3cml0ZSBoYWxmIGZpcnN0CmEgPSAxMQoJCXQyIHJlYWQK
CQkvL3JlYWQKCQlhID0gMTEgLT4gcmVhZCBhYm5vcm1hbCB2YWx1ZS4KLy8gd3JpdGUgb3RoZXIg
aGFsZgphID0gMDEKClJFQURfT05DRS9XUklURV9PTkNFIGNhbiBndWFyYW50ZWUgdGhhdCBlaXRo
ZXIgb2xkIHZhbHVlIG9yIG5ldyB2YWx1ZSBpcwpyZWFkLgoKVGhhbmtzLApLdWFpCgo+IAo+IFJl
Z2FyZHMKPiBYaWFvCj4+Cj4+IFNpZ25lZC1vZmYtYnk6IFl1IEt1YWkgPHl1a3VhaTNAaHVhd2Vp
LmNvbT4KPj4gLS0tCj4+ICAgZHJpdmVycy9tZC9tZC5jIHwgMTYgKysrKysrKysrLS0tLS0tLQo+
PiAgIDEgZmlsZSBjaGFuZ2VkLCA5IGluc2VydGlvbnMoKyksIDcgZGVsZXRpb25zKC0pCj4+Cj4+
IGRpZmYgLS1naXQgYS9kcml2ZXJzL21kL21kLmMgYi9kcml2ZXJzL21kL21kLmMKPj4gaW5kZXgg
NDZiYWRkMTNhNjg3Li45ZDhkZmY5ZDkyM2MgMTAwNjQ0Cj4+IC0tLSBhL2RyaXZlcnMvbWQvbWQu
Ywo+PiArKysgYi9kcml2ZXJzL21kL21kLmMKPj4gQEAgLTM1OSwxMSArMzU5LDExIEBAIHN0YXRp
YyBib29sIGlzX3N1c3BlbmRlZChzdHJ1Y3QgbWRkZXYgKm1kZGV2LCBzdHJ1Y3QgYmlvICpiaW8p
Cj4+ICAgICAgICAgICAgICAgICAgcmV0dXJuIHRydWU7Cj4+ICAgICAgICAgIGlmIChiaW9fZGF0
YV9kaXIoYmlvKSAhPSBXUklURSkKPj4gICAgICAgICAgICAgICAgICByZXR1cm4gZmFsc2U7Cj4+
IC0gICAgICAgaWYgKG1kZGV2LT5zdXNwZW5kX2xvID49IG1kZGV2LT5zdXNwZW5kX2hpKQo+PiAr
ICAgICAgIGlmIChSRUFEX09OQ0UobWRkZXYtPnN1c3BlbmRfbG8pID49IFJFQURfT05DRShtZGRl
di0+c3VzcGVuZF9oaSkpCj4+ICAgICAgICAgICAgICAgICAgcmV0dXJuIGZhbHNlOwo+PiAtICAg
ICAgIGlmIChiaW8tPmJpX2l0ZXIuYmlfc2VjdG9yID49IG1kZGV2LT5zdXNwZW5kX2hpKQo+PiAr
ICAgICAgIGlmIChiaW8tPmJpX2l0ZXIuYmlfc2VjdG9yID49IFJFQURfT05DRShtZGRldi0+c3Vz
cGVuZF9oaSkpCj4+ICAgICAgICAgICAgICAgICAgcmV0dXJuIGZhbHNlOwo+PiAtICAgICAgIGlm
IChiaW9fZW5kX3NlY3RvcihiaW8pIDwgbWRkZXYtPnN1c3BlbmRfbG8pCj4+ICsgICAgICAgaWYg
KGJpb19lbmRfc2VjdG9yKGJpbykgPCBSRUFEX09OQ0UobWRkZXYtPnN1c3BlbmRfbG8pKQo+PiAg
ICAgICAgICAgICAgICAgIHJldHVybiBmYWxzZTsKPj4gICAgICAgICAgcmV0dXJuIHRydWU7Cj4+
ICAgfQo+PiBAQCAtNTE3MSw3ICs1MTcxLDggQEAgX19BVFRSKHN5bmNfbWF4LCBTX0lSVUdPfFNf
SVdVU1IsIG1heF9zeW5jX3Nob3csIG1heF9zeW5jX3N0b3JlKTsKPj4gICBzdGF0aWMgc3NpemVf
dAo+PiAgIHN1c3BlbmRfbG9fc2hvdyhzdHJ1Y3QgbWRkZXYgKm1kZGV2LCBjaGFyICpwYWdlKQo+
PiAgIHsKPj4gLSAgICAgICByZXR1cm4gc3ByaW50ZihwYWdlLCAiJWxsdVxuIiwgKHVuc2lnbmVk
IGxvbmcgbG9uZyltZGRldi0+c3VzcGVuZF9sbyk7Cj4+ICsgICAgICAgcmV0dXJuIHNwcmludGYo
cGFnZSwgIiVsbHVcbiIsCj4+ICsgICAgICAgICAgICAgICAgICAgICAgKHVuc2lnbmVkIGxvbmcg
bG9uZylSRUFEX09OQ0UobWRkZXYtPnN1c3BlbmRfbG8pKTsKPj4gICB9Cj4+Cj4+ICAgc3RhdGlj
IHNzaXplX3QKPj4gQEAgLTUxOTEsNyArNTE5Miw3IEBAIHN1c3BlbmRfbG9fc3RvcmUoc3RydWN0
IG1kZGV2ICptZGRldiwgY29uc3QgY2hhciAqYnVmLCBzaXplX3QgbGVuKQo+PiAgICAgICAgICAg
ICAgICAgIHJldHVybiBlcnI7Cj4+Cj4+ICAgICAgICAgIG1kZGV2X3N1c3BlbmQobWRkZXYpOwo+
PiAtICAgICAgIG1kZGV2LT5zdXNwZW5kX2xvID0gbmV3Owo+PiArICAgICAgIFdSSVRFX09OQ0Uo
bWRkZXYtPnN1c3BlbmRfbG8sIG5ldyk7Cj4+ICAgICAgICAgIG1kZGV2X3Jlc3VtZShtZGRldik7
Cj4+Cj4+ICAgICAgICAgIG1kZGV2X3VubG9jayhtZGRldik7Cj4+IEBAIC01MjAzLDcgKzUyMDQs
OCBAQCBfX0FUVFIoc3VzcGVuZF9sbywgU19JUlVHT3xTX0lXVVNSLCBzdXNwZW5kX2xvX3Nob3cs
IHN1c3BlbmRfbG9fc3RvcmUpOwo+PiAgIHN0YXRpYyBzc2l6ZV90Cj4+ICAgc3VzcGVuZF9oaV9z
aG93KHN0cnVjdCBtZGRldiAqbWRkZXYsIGNoYXIgKnBhZ2UpCj4+ICAgewo+PiAtICAgICAgIHJl
dHVybiBzcHJpbnRmKHBhZ2UsICIlbGx1XG4iLCAodW5zaWduZWQgbG9uZyBsb25nKW1kZGV2LT5z
dXNwZW5kX2hpKTsKPj4gKyAgICAgICByZXR1cm4gc3ByaW50ZihwYWdlLCAiJWxsdVxuIiwKPj4g
KyAgICAgICAgICAgICAgICAgICAgICAodW5zaWduZWQgbG9uZyBsb25nKVJFQURfT05DRShtZGRl
di0+c3VzcGVuZF9oaSkpOwo+PiAgIH0KPj4KPj4gICBzdGF0aWMgc3NpemVfdAo+PiBAQCAtNTIy
Myw3ICs1MjI1LDcgQEAgc3VzcGVuZF9oaV9zdG9yZShzdHJ1Y3QgbWRkZXYgKm1kZGV2LCBjb25z
dCBjaGFyICpidWYsIHNpemVfdCBsZW4pCj4+ICAgICAgICAgICAgICAgICAgcmV0dXJuIGVycjsK
Pj4KPj4gICAgICAgICAgbWRkZXZfc3VzcGVuZChtZGRldik7Cj4+IC0gICAgICAgbWRkZXYtPnN1
c3BlbmRfaGkgPSBuZXc7Cj4+ICsgICAgICAgV1JJVEVfT05DRShtZGRldi0+c3VzcGVuZF9oaSwg
bmV3KTsKPj4gICAgICAgICAgbWRkZXZfcmVzdW1lKG1kZGV2KTsKPj4KPj4gICAgICAgICAgbWRk
ZXZfdW5sb2NrKG1kZGV2KTsKPj4gLS0KPj4gMi4zOS4yCj4+Cj4gCj4gLgo+IAoKLS0KZG0tZGV2
ZWwgbWFpbGluZyBsaXN0CmRtLWRldmVsQHJlZGhhdC5jb20KaHR0cHM6Ly9saXN0bWFuLnJlZGhh
dC5jb20vbWFpbG1hbi9saXN0aW5mby9kbS1kZXZlbAo=

