Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B5942E7E635
	for <dm-devel@archiver.kernel.org>; Tue, 26 Sep 2023 14:12:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1695737535;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=o4K3OldTU/5G/+xDnmvOp/CJg2RRWWB9fkls6rbRE9U=;
	b=afZeRD7xLLjyZvPGTHsB+5dkQQkf8/9FLvy8zGCpQdI2F7Ukowu2wRbhvIgzaxsEUgN6TU
	NiswWTteUpjytGZMnmXxnZqWk3VjBLwZficBCpeJ6HoFrRAbPSMYOLj7Mc+wQg5E69pLus
	x8qhQYo2pidkRh9L7KMxeXwEoU6+FxU=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-508-Q7L0n3Y7Pvqgt0mrK81fIg-1; Tue, 26 Sep 2023 10:12:09 -0400
X-MC-Unique: Q7L0n3Y7Pvqgt0mrK81fIg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AA9D0858F19;
	Tue, 26 Sep 2023 14:12:03 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 5A4B151E3;
	Tue, 26 Sep 2023 14:12:01 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 21C6C19465A8;
	Tue, 26 Sep 2023 14:11:56 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id B6453194658C
 for <dm-devel@listman.corp.redhat.com>; Tue, 26 Sep 2023 13:21:14 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 91FFF28FD; Tue, 26 Sep 2023 13:21:14 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 8AF4051E3
 for <dm-devel@redhat.com>; Tue, 26 Sep 2023 13:21:14 +0000 (UTC)
Received: from us-smtp-inbound-delivery-1.mimecast.com
 (us-smtp-inbound-delivery-1.mimecast.com [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 66EA8382136B
 for <dm-devel@redhat.com>; Tue, 26 Sep 2023 13:21:14 +0000 (UTC)
Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com
 [45.249.212.56]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-185-OOqwKZNpMHOslBS1HmKyeQ-1; Tue, 26 Sep 2023 09:21:11 -0400
X-MC-Unique: OOqwKZNpMHOslBS1HmKyeQ-1
Received: from mail02.huawei.com (unknown [172.30.67.143])
 by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4Rw0k61tVxz4f3jsD
 for <dm-devel@redhat.com>; Tue, 26 Sep 2023 21:21:02 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
 by APP4 (Coremail) with SMTP id gCh0CgAnt9bB2hJlZK7GBQ--.35476S3;
 Tue, 26 Sep 2023 21:21:06 +0800 (CST)
To: Kirill Kirilenko <kirill@ultracoder.org>, Yu Kuai <yukuai1@huaweicloud.com>
References: <0e15b760-2d5f-f639-0fc7-eed67f8c385c@ultracoder.org>
 <ZQy5dClooWaZoS/N@redhat.com> <20230922030340.2eaa46bc@nvm>
 <6b7c6377-c4be-a1bc-d05d-37680175f84c@huaweicloud.com>
 <6a1165f7-c792-c054-b8f0-1ad4f7b8ae01@ultracoder.org>
 <d45ffbcd-cf55-f07c-c406-0cf762a4b4ec@huaweicloud.com>
 <a4d3f9b0-15d5-4a90-f2c1-cad633badbbf@ultracoder.org>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <3bc0af74-95cd-e175-830c-6030a768e64f@huaweicloud.com>
Date: Tue, 26 Sep 2023 21:21:05 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <a4d3f9b0-15d5-4a90-f2c1-cad633badbbf@ultracoder.org>
X-CM-TRANSID: gCh0CgAnt9bB2hJlZK7GBQ--.35476S3
X-Coremail-Antispam: 1UD129KBjvJXoWrZryxZrW7Cw4fJryftF1UJrb_yoW8Jr1fpF
 yDJa13Cw4qqF92v34DA3ZrWFWFvws8Ar13Gr1kWrWav3WqgFyfJr4Ik3yruryjqF48Ww1q
 qanrX34fuFZ7A3DanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
 9KBjDU0xBIdaVrnRJUUUkK14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
 rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
 1l84ACjcxK6xIIjxv20xvE14v26r4j6ryUM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26F4j
 6r4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
 Cq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0
 I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r
 4UM4x0Y48IcVAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwCYjI0SjxkI62AI1cAE67vI
 Y487MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI
 0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUAVWUtwCIc40Y
 0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxV
 WUJVW8JwCI42IY6xAIw20EY4v20xvaj40_Wr1j6rW3Jr1lIxAIcVC2z280aVAFwI0_Jr0_
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
Subject: Re: [dm-devel] fstrim on raid1 LV with writemostly PV leads to
 system freeze
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
Cc: linux-raid@vger.kernel.org, Song Liu <song@kernel.org>, dm-devel@redhat.com,
 Roman Mamedov <rm@romanrm.net>, "yukuai \(C\)" <yukuai3@huawei.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: huaweicloud.com
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"

SGksCgrlnKggMjAyMy8wOS8yNiAyMToxMiwgS2lyaWxsIEtpcmlsZW5rbyDlhpnpgZM6Cj4gT24g
MjYuMDkuMjAyMyAwNjoyOCArMDMwMCwgWXUgS3VhaSB3cm90ZToKPj4gSSBzdGlsbCBkb24ndCBx
dWl0ZSB1bmRlcnN0YW5kIHdoYXQgeW91IG1lYW4gJ2tlcm5lbCBmcmVlemUnLCB0aGlzIHBhdGNo
Cj4+IGluZGVlZCBmaXggYSBwcm9ibGVtIHRoYXQgZGlza2NhcmQgYmlvIGlzIHRyZWF0ZWQgYXMg
bm9ybWFsIHdyaXRlIGJpbwo+PiBhbmQgaXQncyBzcGxpdHRlZC4KPj4KPj4gQ2FuIHlvdSBleHBs
YWluIG1vcmUgYnkgaG93IGRvIHlvdSBqdWRnZSAna2VybmVsIGZyZWV6ZSc/IEluIHRoZQo+PiBt
ZWFudGltZSBkb3NlICdpb3N0YXQgLWRteCAxJyBzaG93cyB0aGF0IGRpc2sgaXMgaWRsZSBhbmQg
bm8gZGljYXJkIGlvCj4+IGlzIGhhbmRsZWQ/Cj4gCj4gSSBtZWFuLCBrZXlib2FyZCBhbmQgbW91
c2Ugc3RvcCB3b3JraW5nLCBzY3JlZW4gc3RvcHMgdXBkYXRpbmcsCj4gc291bmQgY2FyZCBzdGFy
dHMgcGxheWluZyBsYXN0IGF1ZGlvIGJ1ZmZlciBlbmRsZXNzbHkuIEF0IHRoZSBzYW1lIHRpbWUs
Cj4gdGhlIGRpc2sgYWN0aXZpdHkgaW5kaWNhdG9yIGdvZXMgb2ZmLgoKVGhpcyBtZWFucyBjcHUg
aXMgYnVzeSB3aXRoIHNvbWV0aGluZywgaW4gdGhpcyBjYXNlIHlvdSBtdXN0IHVzZSB0b3Agb3IK
cGVyZiB0byBmaWd1cmUgb3V0IHdoYXQgYWxsIHlvdXIgY3B1cyBhcmUgZG9pbmcsIHByb2JhYmx5
IGlzc3VlIGlvIGFuZApoYW5kbGUgaW8gaW50ZXJydXB0LgoKPiAKPiBJJ3ZlIGF0dGFjaGVkIHRo
ZSBsYXN0IG91dHB1dCBvZiAnaW9zdGF0IC1kbXggMScuIE15IFJBSUQxIExWIGlzICdkbS00JywK
PiB0aGUgdW5kZXJseWluZyBQVnMgYXJlICdudm1lMG4xJyBhbmQgJ3NkYScuIEJ1dCB0aGUgdXBk
YXRlIGludGVydmFsCj4gaXMgMSBzZWNvbmQsIG1heSBiZSBhdCB0aGUgbW9tZW50IG9mIGZyZWV6
aW5nIGFsbCBkaXNjYXJkcyBoYXZlIGFscmVhZHkKPiBiZWVuIGNvbXBsZXRlZC4KCmlvc3RhdCBz
aG93cyB0aGF0IGRpc2sgaXMgaGFuZGxpbmcgYWJvdXQgNjAwIHdyaXRlLCAxMjAwIGRpc2NhcmQg
YW5kIDkwMApmbHVzaCBlYWNoIHNlY29uZC4gSSdtIG5vdCBzdXJlIHdoYXQgJ2Rpc2sgYWN0aXZp
dHkgaW5kaWNhdG9yIGdvZXMgb2ZmJwptZWFucywgYnV0IHlvdXIgZGlzayBpcyByZWFsbHkgYnVz
eSB3aXRoIGhhbmRsaW5nIGFsbCB0aGVzZSBpby4KClRoYW5rcywKS3VhaQoKPiAKCi0tCmRtLWRl
dmVsIG1haWxpbmcgbGlzdApkbS1kZXZlbEByZWRoYXQuY29tCmh0dHBzOi8vbGlzdG1hbi5yZWRo
YXQuY29tL21haWxtYW4vbGlzdGluZm8vZG0tZGV2ZWwK

