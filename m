Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5525DC4332F
	for <dm-devel@archiver.kernel.org>; Fri, 21 Oct 2022 06:25:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1666333505;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=igHz5SAzNKmhTVyExi8cY4ZycHiprP14wU88icOBsls=;
	b=UKmpM5HdQqHO1EEpBLztBdNFmlizuLJ8EqoO6RWfPKRTvIDG4nBG5+BanVf2bN+EIWdQcF
	oxQwmkvBNKYFSjVb51cvHmj0nPjzFwtzWTdUOabzZO0BtLqVByz8fM4TZzSDnAdBwG4yzC
	diUtg2Temyd2Flsz7bEtVIoQe3jB6hA=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-52-bkPpChr3OYWmzPgHTqCHbg-1; Fri, 21 Oct 2022 02:25:01 -0400
X-MC-Unique: bkPpChr3OYWmzPgHTqCHbg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 51D993C0E212;
	Fri, 21 Oct 2022 06:25:00 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 3338040E80E4;
	Fri, 21 Oct 2022 06:25:00 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 293291946597;
	Fri, 21 Oct 2022 06:25:00 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id BB6AF1946587
 for <dm-devel@listman.corp.redhat.com>; Fri, 21 Oct 2022 03:28:36 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 7104A4A9279; Fri, 21 Oct 2022 03:28:36 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 68C7B4A9257
 for <dm-devel@redhat.com>; Fri, 21 Oct 2022 03:28:36 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6A8AE803D4A
 for <dm-devel@redhat.com>; Fri, 21 Oct 2022 03:28:30 +0000 (UTC)
Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com
 [45.249.212.51]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-401-ZB1Ych1XMrW7YzVt5TfBPw-1; Thu, 20 Oct 2022 23:28:18 -0400
X-MC-Unique: ZB1Ych1XMrW7YzVt5TfBPw-1
Received: from mail02.huawei.com (unknown [172.30.67.153])
 by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4MtqFh592RzKFK6;
 Fri, 21 Oct 2022 11:09:44 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
 by APP4 (Coremail) with SMTP id gCh0CgCX0DAHDlJj11m4AA--.38184S3;
 Fri, 21 Oct 2022 11:12:08 +0800 (CST)
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
 Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>
References: <20221020164605.1764830-1-hch@lst.de>
 <20221020164605.1764830-2-hch@lst.de>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <cc7d4e79-a14d-1183-09a2-337052321e3e@huaweicloud.com>
Date: Fri, 21 Oct 2022 11:12:06 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20221020164605.1764830-2-hch@lst.de>
X-CM-TRANSID: gCh0CgCX0DAHDlJj11m4AA--.38184S3
X-Coremail-Antispam: 1UD129KBjvJXoW7Zr47Zr4rKFyfGr1rXrWfGrg_yoW8Ar1UpF
 Z8uFsxW3yvkr4qga17Ja17XFyUGa98Wa4fXFySqryIqrnxXr1jvwsrtrWxWF17ur4kKw4q
 vF15XasxAF4vkFJanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
 9KBjDU0xBIdaVrnRJUUUkG14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
 rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
 1l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26F4U
 JVW0owA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
 Cq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0
 I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r
 4UM4x0Y48IcVAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwCYjI0SjxkI62AI1cAE67vI
 Y487MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI
 0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y
 0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxV
 WUJVW8JwCI42IY6xAIw20EY4v20xvaj40_WFyUJVCq3wCI42IY6I8E87Iv67AKxVWUJVW8
 JwCI42IY6I8E87Iv6xkF7I0E14v26r1j6r4UYxBIdaVFxhVjvjDU0xZFpf9x0JUdHUDUUU
 UU=
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
X-Mailman-Approved-At: Fri, 21 Oct 2022 06:24:56 +0000
Subject: Re: [dm-devel] [PATCH 1/6] block: clear the holder releated fields
 when deleting the kobjects
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="gbk"; Format="flowed"

SGksIENocmlzdG9waAoK1NogMjAyMi8xMC8yMSAwOjQ2LCBDaHJpc3RvcGggSGVsbHdpZyDQtLXA
Ogo+IFplcm8gb3V0IHRoZSBwb2ludGVycyB0byB0aGUgaG9sZGVyIHJlbGF0ZWQga29iamVjdHMg
c28gdGhhdCB0aGUgaG9sZGVyCj4gY29kZSBkb2Vzbid0IGluY29ycmVjdGx5IHdoZW4gY2FsbGVk
IGJ5IGRtIGZvciB0aGUgZGVsYXllZCBob2xkZXIKPiByZWdpc3RyYXRpb24uCj4gCj4gRml4ZXM6
IDg5Zjg3MWFmMWIyNiAoImRtOiBkZWxheSByZWdpc3RlcmluZyB0aGUgZ2VuZGlzayIpCj4gUmVw
b3J0ZWQtYnk6IFl1IEt1YWkgPHl1a3VhaTFAaHVhd2VpY2xvdWQuY29tPgo+IFNpZ25lZC1vZmYt
Ynk6IENocmlzdG9waCBIZWxsd2lnIDxoY2hAbHN0LmRlPgo+IC0tLQo+ICAgYmxvY2svZ2VuaGQu
YyB8IDQgKysrKwo+ICAgMSBmaWxlIGNoYW5nZWQsIDQgaW5zZXJ0aW9ucygrKQo+IAo+IGRpZmYg
LS1naXQgYS9ibG9jay9nZW5oZC5jIGIvYmxvY2svZ2VuaGQuYwo+IGluZGV4IDE3YjMzYzYyNDIz
ZGYuLmNkOTBkZjZjNzc1YzIgMTAwNjQ0Cj4gLS0tIGEvYmxvY2svZ2VuaGQuYwo+ICsrKyBiL2Js
b2NrL2dlbmhkLmMKPiBAQCAtNTI4LDggKzUyOCwxMCBAQCBpbnQgX19tdXN0X2NoZWNrIGRldmlj
ZV9hZGRfZGlzayhzdHJ1Y3QgZGV2aWNlICpwYXJlbnQsIHN0cnVjdCBnZW5kaXNrICpkaXNrLAo+
ICAgCWJsa191bnJlZ2lzdGVyX3F1ZXVlKGRpc2spOwo+ICAgb3V0X3B1dF9zbGF2ZV9kaXI6Cj4g
ICAJa29iamVjdF9wdXQoZGlzay0+c2xhdmVfZGlyKTsKPiArCWRpc2stPnNsYXZlX2RpciA9IE5V
TEw7Cj4gICBvdXRfcHV0X2hvbGRlcl9kaXI6Cj4gICAJa29iamVjdF9wdXQoZGlzay0+cGFydDAt
PmJkX2hvbGRlcl9kaXIpOwo+ICsJZGlzay0+cGFydDAtPmJkX2hvbGRlcl9kaXIgPSBOVUxMOwo+
ICAgb3V0X2RlbF9pbnRlZ3JpdHk6Cj4gICAJYmxrX2ludGVncml0eV9kZWwoZGlzayk7Cj4gICBv
dXRfZGVsX2Jsb2NrX2xpbms6Cj4gQEAgLTYyMyw3ICs2MjUsOSBAQCB2b2lkIGRlbF9nZW5kaXNr
KHN0cnVjdCBnZW5kaXNrICpkaXNrKQo+ICAgCWJsa191bnJlZ2lzdGVyX3F1ZXVlKGRpc2spOwo+
ICAgCj4gICAJa29iamVjdF9wdXQoZGlzay0+cGFydDAtPmJkX2hvbGRlcl9kaXIpOwo+ICsJZGlz
ay0+cGFydDAtPmJkX2hvbGRlcl9kaXIgPSBOVUxMOwoKSSBkb24ndCB0aGluayB0aGlzIGlzIGVu
b3VnaC4gVGhlcmUgaXMgc3RpbGwgbm8gZ3VhcmFudGVlIHRoYXQKYmRfbGlua19kaXNrX2hvbGRl
cigpIHdvbid0IGFjY2VzcyBmcmVlZCBiZF9ob2xkZXJfZGlyLiBJdCdzIHN0aWxsCnBvc3NpYmxl
IHRoYXQgYmRfbGlua19kaXNrX2hvbGVyKCkgcmVhZCBiZF9ob2xkZXJfZGlyIGZpcnN0LCBhbmQg
dGhlbgpkZWxfZ2VuZGlzaygpIGZyZWUgYW5kIHJlc2V0IGl0LgoKQnkgdGhlIHdheSwgSSBzdGls
bCB0aGluayB0aGF0IHRoZSBwcm9ibGVtIGZvciB0aGUgYmRfaG9sZGVyX2RpciB1YWYgaXMKbm90
IGp1c3QgcmVsYXRlZCB0byBkbS4KClRoYW5rcywKS3VhaQoKPiAgIAlrb2JqZWN0X3B1dChkaXNr
LT5zbGF2ZV9kaXIpOwo+ICsJZGlzay0+c2xhdmVfZGlyID0gTlVMTDsKPiAgIAo+ICAgCXBhcnRf
c3RhdF9zZXRfYWxsKGRpc2stPnBhcnQwLCAwKTsKPiAgIAlkaXNrLT5wYXJ0MC0+YmRfc3RhbXAg
PSAwOwo+IAoKLS0KZG0tZGV2ZWwgbWFpbGluZyBsaXN0CmRtLWRldmVsQHJlZGhhdC5jb20KaHR0
cHM6Ly9saXN0bWFuLnJlZGhhdC5jb20vbWFpbG1hbi9saXN0aW5mby9kbS1kZXZlbAo=

