Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 06605C77B75
	for <dm-devel@archiver.kernel.org>; Thu,  4 May 2023 03:18:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1683170321;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=HkRdrYLBUAUg9CBTzZqtFTmOgwYzUrJPDX34OepVYuA=;
	b=ftHFV/ADdBODz6pY4XJiEzWpRD503lcMyepnbaZjYBdMUmQR2iVU2uC2LGcNQtDGrLMWKA
	TLKypJCabvY79sb+2bnekEXUpbXrX1ho5/SCL+vktJ4UYcxFTy8ZvAhjWSglfSHdqxmd/h
	/csFnO3oJ6VE9ad1o1sQzWm8IVVZv/8=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-262-sp1Xw1RWOYmaDWFU1THdJg-1; Wed, 03 May 2023 23:18:38 -0400
X-MC-Unique: sp1Xw1RWOYmaDWFU1THdJg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DAE5D29AA3B9;
	Thu,  4 May 2023 03:18:36 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id C364C40BC798;
	Thu,  4 May 2023 03:18:32 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 8466319465BC;
	Thu,  4 May 2023 03:18:32 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 94C4719465BB
 for <dm-devel@listman.corp.redhat.com>; Thu,  4 May 2023 03:18:31 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 295062166B29; Thu,  4 May 2023 03:18:31 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 2130E2166B26
 for <dm-devel@redhat.com>; Thu,  4 May 2023 03:18:31 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0114D3C0CEE2
 for <dm-devel@redhat.com>; Thu,  4 May 2023 03:18:31 +0000 (UTC)
Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com
 [45.249.212.56]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-161-BDnHFyssOiiVTEUqPPHvjw-1; Wed, 03 May 2023 23:18:29 -0400
X-MC-Unique: BDnHFyssOiiVTEUqPPHvjw-1
Received: from mail02.huawei.com (unknown [172.30.67.153])
 by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4QBfCf4Mzcz4f3l7J
 for <dm-devel@redhat.com>; Thu,  4 May 2023 11:18:22 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
 by APP4 (Coremail) with SMTP id gCh0CgBnHbH+I1NkNardIg--.56157S3;
 Thu, 04 May 2023 11:18:24 +0800 (CST)
To: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
 Yu Kuai <yukuai1@huaweicloud.com>
References: <20230427024126.1417646-1-yukuai1@huaweicloud.com>
 <2lsxdy3n7vfwtmyubfc7kh7yd6mxrht6nlnhmvwzrsellij3kc@5hctf5lvmr6e>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <7cbad327-d0aa-cbd9-0dc9-c30cd19a8df2@huaweicloud.com>
Date: Thu, 4 May 2023 11:18:22 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <2lsxdy3n7vfwtmyubfc7kh7yd6mxrht6nlnhmvwzrsellij3kc@5hctf5lvmr6e>
X-CM-TRANSID: gCh0CgBnHbH+I1NkNardIg--.56157S3
X-Coremail-Antispam: 1UD129KBjvJXoW7WrykWr4UWr15Jw4kZw18Xwb_yoW8JFWUp3
 98tFnIyrZ5Ca47K3Wxuw40va4rJF43Crn8Ar17Wr18A3s8X3WrXasIkF13Za4rZFZ8XFn3
 Za4Fqr93uw4jv3JanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
 9KBjDU0xBIdaVrnRJUUUkK14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
 rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
 1l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
 JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
 CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
 2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
 W8JwACjcxG0xvEwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lc7I2V7IY0VAS07AlzVAY
 IcxG8wCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14
 v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_JF0_Jw1lIxkG
 c2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI
 0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6rW3Jr0E3s1lIxAIcVC2z280aVAFwI0_Jr0_
 Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7VUbXdbU
 UUUUU==
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
Subject: Re: [dm-devel] [PATCH blktests v2] tests/dm: add a regression test
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
Cc: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
 "yukuai \(C\)" <yukuai3@huawei.com>,
 "dm-devel@redhat.com" <dm-devel@redhat.com>,
 "snitzer@kernel.org" <snitzer@kernel.org>,
 "shinichiro@fastmail.com" <shinichiro@fastmail.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: huaweicloud.com
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="gbk"; Format="flowed"

SGksCgrU2iAyMDIzLzA1LzAxIDEyOjM0LCBTaGluaWNoaXJvIEthd2FzYWtpINC0tcA6Cj4gWXUs
IHRoYW5rcyBmb3IgdGhlIHBhdGNoLiBJIGhhdmUgdGhyZWUgbWlub3IgY29tbWVudHMgYmVsb3cu
IE90aGVyIHRoYW4gdGhhdCwKPiB0aGUgcGF0Y2ggbG9va3MgZ29vZCB0byBtZS4gSWYgeW91IGRv
IG5vdCBtaW5kLCBJIGNhbiBkbyB0aGVzZSBlZGl0cy4gUGxlYXNlIGxldAo+IG1lIGtub3cgeW91
ciB0aG91Z2h0cy4KCkknbSBnb29kIHdpdGggeW91ciBjb21tZW50cy4KClRoYW5rcywKS3VhaQo+
IAo+IDEpIExldCdzIGRlc2NyaWJlIGEgYml0IG1vcmUgaW4gdGhlIGNvbW1pdCB0aXRsZSwgbGlr
ZSwKPiAgICAgInRlc3RzL2RtOiBhZGQgZG0gdGVzdCBncm91cCBhbmQgYSB0ZXN0IGZvciBzZWxm
LW1hcCIKPiAyKSBGcm9tIGhpc3RvcmljYWwgcmVhc29uLCB3ZSBhZGQgZXhlY3V0YWJsZSBtb2Rl
IHRvIHRoZSB0ZXN0IHNjcmlwdCBmaWxlcy4KPiAgICAgTGV0J3MgYWRkIHRoZSBmaWxlIG1vZGUg
NzU1IHRvIHRoZSB0ZXN0cy9kbS8wMDEgZmlsZS4KPiAzKSBQbGVhc2UgcnVuICJtYWtlIGNoZWNr
IiB0byBmaW5kIHNjcmlwdCBpc3N1ZXMuIFdpdGggdGhlIGNvbW1hbmQsIHNoZWxsY2hlY2sKPiAg
ICAgcmVwb3J0cyBhIHdhcm5pbmc6Cj4gCj4gICAgIHRlc3RzL2RtLzAwMToyMzo3OiBub3RlOiBD
aGVjayBleGl0IGNvZGUgZGlyZWN0bHkgd2l0aCBlLmcuICdpZiBteWNtZDsnLCBub3QgaW5kaXJl
Y3RseQo+ICAgICB3aXRoICQ/LiBbU0MyMTgxXQo+IAo+IEEgaHVuayBiZWxvdyB3aWxsIGF2b2lk
IHRoZSB3YXJuaW5nLgo+IAo+IGRpZmYgLS1naXQgYS90ZXN0cy9kbS8wMDEgYi90ZXN0cy9kbS8w
MDEKPiBpbmRleCAwOTczMWQ4Li5mNjlmMzBmIDEwMDY0NAo+IC0tLSBhL3Rlc3RzL2RtLzAwMQo+
ICsrKyBiL3Rlc3RzL2RtLzAwMQo+IEBAIC0xOSw4ICsxOSw4IEBAIHRlc3RfZGV2aWNlKCkgewo+
ICAgCj4gICAJZG1zZXR1cCBjcmVhdGUgdGVzdCAtLXRhYmxlICIwIDgxOTIgbGluZWFyICR7VEVT
VF9ERVZ9IDAiCj4gICAJZG1zZXR1cCBzdXNwZW5kIHRlc3QKPiAtCWRtc2V0dXAgcmVsb2FkIHRl
c3QgLS10YWJsZSAiMCA4MTkyIGxpbmVhciAvZGV2L21hcHBlci90ZXN0IDAiICY+IC9kZXYvbnVs
bAo+IC0JaWYgWyAkPyAtZXEgMCBdOyB0aGVuCj4gKwlpZiBkbXNldHVwIHJlbG9hZCB0ZXN0IC0t
dGFibGUgIjAgODE5MiBsaW5lYXIgL2Rldi9tYXBwZXIvdGVzdCAwIiBcCj4gKwkgICAmPiAvZGV2
L251bGw7IHRoZW4KPiAgIAkJZWNobyAicmVsb2FkIGEgZG0gd2l0aCBtYXBzIHRvIGl0c2VsZiBz
dWNjZWVkLiIKPiAgIAlmaQo+ICAgCWRtc2V0dXAgcmVtb3ZlIHRlc3QKPiAKPiAuCj4gCgotLQpk
bS1kZXZlbCBtYWlsaW5nIGxpc3QKZG0tZGV2ZWxAcmVkaGF0LmNvbQpodHRwczovL2xpc3RtYW4u
cmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRldmVsCg==

