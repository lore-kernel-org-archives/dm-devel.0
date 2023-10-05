Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 931FDE936F8
	for <dm-devel@archiver.kernel.org>; Thu,  5 Oct 2023 02:59:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1696474749;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=1rvymqw+j7Y1ml3isj6JmHwi63uU6Oj1uMIh9/rIMG8=;
	b=c1TSeGnnB/ZVawPLuQ3AEBiHlQ1cqP72SPBqKWtogvIt5qUC5FYpatrBQzdKAOkaU87MQu
	tN4D9kjjaO6La034YWBcIrzFIXL6AwD1fAXf4hbj1EIf7MnXh0nVr4mvlfHD9jOBN5Vsi7
	PRr6t9VC6VdSeyX4gXGlvIbzKX7fr6Q=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-549-3NBQLddZOceAGdNMR9cUfA-1; Wed, 04 Oct 2023 22:59:06 -0400
X-MC-Unique: 3NBQLddZOceAGdNMR9cUfA-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9B53A85A5A8;
	Thu,  5 Oct 2023 02:59:04 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 2ED5947AD4A;
	Thu,  5 Oct 2023 02:59:04 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id DAB7D1946597;
	Thu,  5 Oct 2023 02:59:03 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 1C22E194658F
 for <dm-devel@listman.corp.redhat.com>; Thu,  5 Oct 2023 02:59:03 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 09FC547AD4A; Thu,  5 Oct 2023 02:59:03 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 02C90400F0F
 for <dm-devel@redhat.com>; Thu,  5 Oct 2023 02:59:02 +0000 (UTC)
Received: from us-smtp-inbound-delivery-1.mimecast.com
 (us-smtp-inbound-delivery-1.mimecast.com [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D6E5B811E7B
 for <dm-devel@redhat.com>; Thu,  5 Oct 2023 02:59:02 +0000 (UTC)
Received: from dggsgout12.his.huawei.com (hwsga02-in.huaweimarine.com
 [45.249.212.56]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-41-sqYep_lPOBu-oJdOB0yJug-1; Wed, 04 Oct 2023 22:58:58 -0400
X-MC-Unique: sqYep_lPOBu-oJdOB0yJug-1
Received: from mail02.huawei.com (unknown [172.30.67.143])
 by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4S1GTz6G97z4f3jHr;
 Thu,  5 Oct 2023 10:58:47 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
 by APP4 (Coremail) with SMTP id gCh0CgDHXd1sJh5l1yKkCA--.2987S3;
 Thu, 05 Oct 2023 10:58:52 +0800 (CST)
To: Song Liu <song@kernel.org>, Yu Kuai <yukuai1@huaweicloud.com>
References: <20230928061543.1845742-1-yukuai1@huaweicloud.com>
 <20230928061543.1845742-4-yukuai1@huaweicloud.com>
 <CAPhsuW4tQ9A+ddpxGhfza3WSdkL+FXmS-4NLUUN7MNk0TOY0WA@mail.gmail.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <0ae441ba-68db-b823-b48c-76e953d22067@huaweicloud.com>
Date: Thu, 5 Oct 2023 10:58:52 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <CAPhsuW4tQ9A+ddpxGhfza3WSdkL+FXmS-4NLUUN7MNk0TOY0WA@mail.gmail.com>
X-CM-TRANSID: gCh0CgDHXd1sJh5l1yKkCA--.2987S3
X-Coremail-Antispam: 1UD129KBjvJXoW7tFyxtrW5urWkZFW3XF47urg_yoW8Zr48p3
 yxKFZxtryUJF9xAw1aq34kua4rXw48KrW0krZrX3W5W3W3Gr1fur1agrs8Wry0kr1Syr1D
 tF1Fqa48Cr18JFUanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
 9KBjDU0xBIdaVrnRJUUU9F14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
 rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
 1l84ACjcxK6xIIjxv20xvE14v26ryj6F1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26F4j
 6r4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
 Cq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0
 I7IYx2IY67AKxVWUGVWUXwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r
 4UM4x0Y48IcVAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628vn2kI
 c2xKxwCYjI0SjxkI62AI1cAE67vIY487MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4
 AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE
 17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMI
 IF0xvE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwCI42IY6xAIw20EY4v20xvaj40_Wr1j6rW3
 Jr1lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcS
 sGvfC2KfnxnUUI43ZEXa7VU1a9aPUUUUU==
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
Subject: Re: [dm-devel] [PATCH -next v3 03/25] md: add new helpers to
 suspend/resume array
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
 dm-devel@redhat.com, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
 xni@redhat.com, "yukuai \(C\)" <yukuai3@huawei.com>, agk@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: huaweicloud.com
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"

SGksCgrlnKggMjAyMy8wOS8yOSAyOjQ1LCBTb25nIExpdSDlhpnpgZM6Cj4gT24gV2VkLCBTZXAg
MjcsIDIwMjMgYXQgMTE6MjLigK9QTSBZdSBLdWFpIDx5dWt1YWkxQGh1YXdlaWNsb3VkLmNvbT4g
d3JvdGU6Cj4+Cj4+IEZyb206IFl1IEt1YWkgPHl1a3VhaTNAaHVhd2VpLmNvbT4KPj4KPj4gQWR2
YW50YWdlcyBmb3IgbmV3IGFwaXM6Cj4+ICAgLSByZWNvbmZpZ19tdXRleCBpcyBub3QgcmVxdWly
ZWQ7Cj4+ICAgLSB0aGUgd2VpcmQgbG9naWNhbCB0aGF0IHN1c3BlbmQgYXJyYXkgaG9sZCAncmVj
b25maWdfbXV0ZXgnIGZvcgo+PiAgICAgbWRkZXZfY2hlY2tfcmVjb3ZlcnkoKSB0byB1cGRhdGUg
c3VwZXJibG9jayBpcyBub3QgbmVlZGVkOwo+PiAgIC0gdGhlIHNwZWNhaWwgaGFuZGxpbmcsICdw
ZXJzLT5wcmVwYXJlX3N1c3BlbmQnLCBmb3IgcmFpZDQ1NiBpcyBub3QKPj4gICAgIG5lZWRlZDsK
Pj4gICAtIEl0J3Mgc2FmZSB0byBiZSBjYWxsZWQgYXQgYW55IHRpbWUgb25jZSBtZGRldiBpcyBh
bGxvY2F0ZWQsIGFuZCBpdCdzCj4+ICAgICBkZXNpZ25lZCB0byBiZSB1c2VkIGZyb20gc2xvdyBw
YXRoIHdoZXJlIGFycmF5IGNvbmZpZ3VyYXRpb24gaXMgY2hhbmdlZDsKPj4gICAtIHRoZSBuZXcg
aGVscGVycyBpcyBkZXNpZ25lZCB0byBiZSBjYWxsZWQgYmVmb3JlIG1kZGV2X2xvY2soKSwgaGVu
Y2UKPj4gICAgIGl0IHN1cHBvcnQgdG8gYmUgaW50ZXJydXB0ZWQgYnkgdXNlciBhcyB3ZWxsLgo+
Pgo+PiBTaWduZWQtb2ZmLWJ5OiBZdSBLdWFpIDx5dWt1YWkzQGh1YXdlaS5jb20+Cj4+IC0tLQo+
PiAgIGRyaXZlcnMvbWQvbWQuYyB8IDEwMiArKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKy0KPj4gICBkcml2ZXJzL21kL21kLmggfCAgIDMgKysKPj4gICAyIGZp
bGVzIGNoYW5nZWQsIDEwMyBpbnNlcnRpb25zKCspLCAyIGRlbGV0aW9ucygtKQo+Pgo+PiBkaWZm
IC0tZ2l0IGEvZHJpdmVycy9tZC9tZC5jIGIvZHJpdmVycy9tZC9tZC5jCj4+IGluZGV4IGU0NjBi
MzgwMTQzZC4uYTA3NWQwM2QwM2QzIDEwMDY0NAo+PiAtLS0gYS9kcml2ZXJzL21kL21kLmMKPj4g
KysrIGIvZHJpdmVycy9tZC9tZC5jCj4+IEBAIC00NDMsMTIgKzQ0MywyMiBAQCB2b2lkIG1kZGV2
X3N1c3BlbmQoc3RydWN0IG1kZGV2ICptZGRldikKPj4gICAgICAgICAgICAgICAgICAgICAgICAg
IGxvY2tkZXBfaXNfaGVsZCgmbWRkZXYtPnJlY29uZmlnX211dGV4KSk7Cj4+Cj4+ICAgICAgICAg
IFdBUk5fT05fT05DRSh0aHJlYWQgJiYgY3VycmVudCA9PSB0aHJlYWQtPnRzayk7Cj4+IC0gICAg
ICAgaWYgKG1kZGV2LT5zdXNwZW5kZWQrKykKPj4gKwo+PiArICAgICAgIC8qIGNhbid0IGNvbmN1
cnJlbnQgd2l0aCBfX21kZGV2X3N1c3BlbmQoKSBhbmQgX19tZGRldl9yZXN1bWUoKSAqLwo+PiAr
ICAgICAgIG11dGV4X2xvY2soJm1kZGV2LT5zdXNwZW5kX211dGV4KTsKPj4gKyAgICAgICBpZiAo
bWRkZXYtPnN1c3BlbmRlZCsrKSB7Cj4+ICsgICAgICAgICAgICAgICBtdXRleF91bmxvY2soJm1k
ZGV2LT5zdXNwZW5kX211dGV4KTsKPj4gICAgICAgICAgICAgICAgICByZXR1cm47Cj4gCj4gQ2Fu
IHdlIG1ha2UgbWRkZXYtPnN1c3BlbmRlZCBhdG9taWNfdCwgYW5kIHVzZSBhdG9taWNfaW5jX3Jl
dHVybigpCj4gaGVyZT8KCidzdXNwZW5kX211dGV4JyBpcyBuZWVkZWQsIGJlY2F1c2UgY29uY3Vy
cmVudCBjYWxsZXIgb2YKbWRkZXZfc3VzcGVuZCgpIHNob3VuZCBiZSBvcmRlcmVkLCB0aGV5IG5l
ZWQgdG8gd2FpdCBmb3IgdGhlIGZpcnN0Cm1kZGV2X3N1c3BlbmQoKSB0byBiZSBkb25lLgoKVXBk
YXRpbmcgc3VzcGVuZGVkIGlzIHByb3RlY3RlZCBieSAnc3VzcGVuZF9tdXRleCcgaW4gdGhlIG5l
dyBhcGksIHNvIEkKdGhpbmsgaXQncyBub3QgbmVjZXNzYXJ5IHRvIHVzZSBhdG9taWMsIFdSSVRF
L1JFQURfT05DRSgpIHNob3VsZCBiZQplbm91Z2guCgpUaGFua3MsCkt1YWkKCj4gCj4gVGhhbmtz
LAo+IFNvbmcKPiAKPiBbLi4uXQo+IC4KPiAKCi0tCmRtLWRldmVsIG1haWxpbmcgbGlzdApkbS1k
ZXZlbEByZWRoYXQuY29tCmh0dHBzOi8vbGlzdG1hbi5yZWRoYXQuY29tL21haWxtYW4vbGlzdGlu
Zm8vZG0tZGV2ZWwK

