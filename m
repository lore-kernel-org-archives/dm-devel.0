Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CD45BE7F124
	for <dm-devel@archiver.kernel.org>; Tue, 26 Sep 2023 20:31:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1695760309;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=eJ9GQyd1uO3/WDyMFJnMvEBrUqVB9avbA+u8e94eww0=;
	b=fT8v+fGWYyzM5rFC+MDyHPS8mBUlGjLsyRl0Z8Zfow4RGs9+zzRRX3L1ygBza7oa/XOpYj
	X8RLQsmQ739EoMEqRAmgq5q4r1yH/Zf/wr0sDl0N3RDOVJ02Z7DQINVfuNWiDcIw4b3aNJ
	fLw2OIqCG6zYzy3eD7C9Ho9zmPZSMDw=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-553-rUvmDHwHNUqK8AFPQs8sng-1; Tue, 26 Sep 2023 16:31:46 -0400
X-MC-Unique: rUvmDHwHNUqK8AFPQs8sng-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5B1B93816D91;
	Tue, 26 Sep 2023 20:31:44 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 5EB46492C37;
	Tue, 26 Sep 2023 20:31:42 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 0F7D71946594;
	Tue, 26 Sep 2023 20:31:37 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 5F9B7194658D
 for <dm-devel@listman.corp.redhat.com>; Tue, 26 Sep 2023 20:27:55 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 50DD340C6E76; Tue, 26 Sep 2023 20:27:55 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 499BB40C6EA8
 for <dm-devel@redhat.com>; Tue, 26 Sep 2023 20:27:55 +0000 (UTC)
Received: from us-smtp-inbound-delivery-1.mimecast.com (us-smtp-1.mimecast.com
 [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 21A8F8007A4
 for <dm-devel@redhat.com>; Tue, 26 Sep 2023 20:27:55 +0000 (UTC)
Received: from mail.ultracoder.org (188.227.94.15.ptspb.net [188.227.94.15])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-616-7VnMhtu8OCqaqMUeFkl_NA-1; Tue,
 26 Sep 2023 16:27:52 -0400
X-MC-Unique: 7VnMhtu8OCqaqMUeFkl_NA-1
Message-ID: <7c0bc9ff-767c-c1a7-49ab-37312a0fe803@ultracoder.org>
Date: Tue, 26 Sep 2023 23:27:50 +0300
MIME-Version: 1.0
To: Yu Kuai <yukuai1@huaweicloud.com>
References: <0e15b760-2d5f-f639-0fc7-eed67f8c385c@ultracoder.org>
 <ZQy5dClooWaZoS/N@redhat.com> <20230922030340.2eaa46bc@nvm>
 <6b7c6377-c4be-a1bc-d05d-37680175f84c@huaweicloud.com>
 <6a1165f7-c792-c054-b8f0-1ad4f7b8ae01@ultracoder.org>
 <d45ffbcd-cf55-f07c-c406-0cf762a4b4ec@huaweicloud.com>
 <a4d3f9b0-15d5-4a90-f2c1-cad633badbbf@ultracoder.org>
 <3bc0af74-95cd-e175-830c-6030a768e64f@huaweicloud.com>
From: Kirill Kirilenko <kirill@ultracoder.org>
In-Reply-To: <3bc0af74-95cd-e175-830c-6030a768e64f@huaweicloud.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
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
 "yukuai \(C\)" <yukuai3@huawei.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: ultracoder.org
Content-Language: ru-RU, en-US
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

T24gMjYuMDkuMjAyMyAxNjoyMSArMDMwMCwgWXUgS3VhaSB3cm90ZToKPiBUaGlzIG1lYW5zIGNw
dSBpcyBidXN5IHdpdGggc29tZXRoaW5nLCBpbiB0aGlzIGNhc2UgeW91IG11c3QgdXNlIHRvcCBv
cgo+IHBlcmYgdG8gZmlndXJlIG91dCB3aGF0IGFsbCB5b3VyIGNwdXMgYXJlIGRvaW5nLCBwcm9i
YWJseSBpc3N1ZSBpbyBhbmQKPiBoYW5kbGUgaW8gaW50ZXJydXB0LgoKT0ssIGhlcmUgaXMgdGhl
IGxhc3Qgb3V0cHV0IG9mICdwZXJmIHRvcCAtZCAxJyBiZWZvcmUgc3lzdGVtIGZyb3plOgoKNC4w
MCXCoCBba2VybmVsXcKgIGxlZHRyaWdfZGlza19hY3Rpdml0eQozLjg2JcKgIFtrZXJuZWxdwqAg
bGVkX3RyaWdnZXJfYmxpbmtfb25lc2hvdAoxLjkzJcKgIFtrZXJuZWxdwqAgcmVhZF90c2MKMS42
OCXCoCBwZXJmwqDCoMKgwqDCoCBoaXN0X2VudHJ5X19zb3J0CjEuNjIlwqAgW2tlcm5lbF3CoCBt
ZW51X3NlbGVjdAoxLjU3JcKgIFtrZXJuZWxdwqAgcHNpX2dyb3VwX2NoYW5nZQoxLjE5JcKgIFtr
ZXJuZWxdwqAgbmF0aXZlX3NjaGVkX2Nsb2NrCjAuOTYlwqAgW2tlcm5lbF3CoCBzY3NpX2NvbXBs
ZXRlCjAuOTQlwqAgW2tlcm5lbF3CoCBfX3Jhd19zcGluX2xvY2tfaXJxc2F2ZQowLjgwJcKgIHBl
cmbCoMKgwqDCoMKgIHBlcmZfaHBwX19pc19keW5hbWljX2VudHJ5Ci4uLgoKQW5kIGhlcmUgaXMg
dGhlIGxhc3Qgb3V0cHV0IG9mICd0b3AnOgoKbG9hZCBhdmVyYWdlOiAxLjQ4LCAwLjkwLCAwLjM4
CiVDcHUocyk6IDAuMSB1cywgMC4xIHN5LCAwLjAgbmksIDkzLjUgaWQsIDYuMyB3YSwgMC4wIGhp
LCAwLjEgc2ksIDAuMCBzdApNaUIgTWVtOsKgIDMyMDA1LjMgdG90YWwsIDI5MTM4LjMgZnJlZSwg
MTMyNy4wIHVzZWQswqDCoCAxNTQwLjAgYnVmZi9jYWNoZQpNaUIgU3dhcDogMTYzODIuMCB0b3Rh
bCwgMTYzODIuMCBmcmVlLMKgwqDCoCAwLjAgdXNlZC7CoCAzMDI0NC41IGF2YWlsIE1lbQpTICVD
UFUgQ09NTUFORApTIDAuN8KgIFttZFhfcmFpZDFdClMgMC43wqAgY2lubmFtb24gLS1yZXBsYWNl
CkkgMC4zwqAgW2t3b3JrZXIvdTY0OjItZXZlbnRzX3VuYm91bmRdCkkgMC4zwqAgW2t3b3JrZXIv
dTY0OjYtZXZlbnRzX2ZyZWV6YWJsZV9wb3dlcl9dClMgMC4zwqAgW2dmeF9sb3ddClMgMC4zwqAg
L3Vzci9iaW4vY29udGFpbmVyZApTIDAuM8KgIC91c3IvbGliL3hvcmcvWG9yZyAtY29yZSA6MCAu
Li4KUyAwLjPCoCAvdXNyL2xpYmV4ZWMvZ25vbWUtdGVybWluYWwtc2VydmVyClIgMC4zwqAgdG9w
CkQgMC4zwqAgZnN0cmltIC9ob21lCi4uLgoKSSB0aGluaywgdGhlcmUgYXJlIG9ubHkgdHdvIHBv
c3NpYmlsaXRpZXM6IGVpdGhlciBDUFUgaXMgbm90IHRoYXQgYnVzeSwKb3IgaXQgZ2V0cyBidXN5
IHZlcnkgcXVpY2tseSwgc28gd2UgY2FuIG5vdCBzZWUgaXQgbGlrZSB0aGF0LiBJIGhhdmUgbm8K
ZXhwZXJpZW5jZSBpbiBrZXJuZWwgZGVidWdnaW5nLiBNYXliZSBzb21lb25lIGtub3dzLCBob3cg
SSBjYW4gZ2V0Cm1vcmUgYWNjdXJhdGUgZGF0YSB3aGVuIHN5c3RlbSBmcmVlemVzPwoKT24gMjYu
MDkuMjAyMyAxNjoyMSArMDMwMCwgWXUgS3VhaSB3cm90ZToKPiBJJ20gbm90IHN1cmUgd2hhdCAn
ZGlzayBhY3Rpdml0eSBpbmRpY2F0b3IgZ29lcyBvZmYnIG1lYW5zCgpJdCBtZWFucywgdGhlIExF
RCBvbiBteSBjb21wdXRlciBjYXNlLCBpbmRpY2F0aW5nIGRpc2sgYWN0aXZpdHksIGdvZXMgb2Zm
LgpBY2NvcmRpbmcgdG8gJ3BlcmYnIG91dHB1dCwgTEVEIGNvbnRyb2wgaXMgdGhlIGxhcmdlc3Qg
Y29udHJpYnV0b3IgdG8KQ1BVIGxvYWQuIDopCgotLQpkbS1kZXZlbCBtYWlsaW5nIGxpc3QKZG0t
ZGV2ZWxAcmVkaGF0LmNvbQpodHRwczovL2xpc3RtYW4ucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3Rp
bmZvL2RtLWRldmVsCg==

