Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2B341C43334
	for <dm-devel@archiver.kernel.org>; Wed,  6 Jul 2022 14:59:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1657119574;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=ImVdtid9gmWQ+n98iq3P5WKWGFomIWaqYR4hWei1nnM=;
	b=OeVRv1fHdG3Z5B0yqkFsccHHax/AV7pXZReoseOk7AIgHmgCPnsFmVe1mBmd6bh2OApjvg
	Vwj+XHLxsHL3hWQ7UsJCMtuiRj+3n++uWVr8KmiuRQYP5k3lKXNM36dHWoH2MSRDatE4IZ
	fMTbjiUGEalXl5QlspySfUlJAvonkWs=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-632-ODGy2OekNraZCE_WoTDxew-1; Wed, 06 Jul 2022 10:59:25 -0400
X-MC-Unique: ODGy2OekNraZCE_WoTDxew-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 52F9B294EDF4;
	Wed,  6 Jul 2022 14:59:23 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 3D9E140315C;
	Wed,  6 Jul 2022 14:59:23 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id E42E6194704E;
	Wed,  6 Jul 2022 14:59:22 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 5177D1947042
 for <dm-devel@listman.corp.redhat.com>; Sat,  2 Jul 2022 19:42:11 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 41C901121315; Sat,  2 Jul 2022 19:42:11 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 3D5A81121314
 for <dm-devel@redhat.com>; Sat,  2 Jul 2022 19:42:11 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 21B3E3C025BC
 for <dm-devel@redhat.com>; Sat,  2 Jul 2022 19:42:11 +0000 (UTC)
Received: from smtp.smtpout.orange.fr (smtp03.smtpout.orange.fr
 [80.12.242.125]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 us-mta-403-b45dJdmVOrSGh46M4MyYkg-1; Sat, 02 Jul 2022 15:42:07 -0400
X-MC-Unique: b45dJdmVOrSGh46M4MyYkg-1
Received: from [192.168.1.18] ([90.11.190.129]) by smtp.orange.fr with ESMTPA
 id 7j0Fovq0J26JC7j0Fox7ym; Sat, 02 Jul 2022 21:42:06 +0200
X-ME-Helo: [192.168.1.18]
X-ME-Auth: YWZlNiIxYWMyZDliZWIzOTcwYTEyYzlhMmU3ZiQ1M2U2MzfzZDfyZTMxZTBkMTYyNDBjNDJlZmQ3ZQ==
X-ME-Date: Sat, 02 Jul 2022 21:42:06 +0200
X-ME-IP: 90.11.190.129
Message-ID: <62d3cfcd-a32e-59d1-c376-c95e8da1049f@wanadoo.fr>
Date: Sat, 2 Jul 2022 21:42:02 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Newsgroups: gmane.linux.kernel.janitors, gmane.linux.kernel.device-mapper.devel,
 gmane.linux.kernel
References: <cover.1656785856.git.christophe.jaillet@wanadoo.fr>
 <3f2ad7fb91948525f6c52e0d36ec223cd3049c88.1656785856.git.christophe.jaillet@wanadoo.fr>
 <YsCUW6vT7LlAv2UE@smile.fi.intel.com>
 <6063ee97-1bbe-2391-78cb-57572851a52c@wanadoo.fr>
 <YsCdSkzSbVz9gnci@smile.fi.intel.com>
From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
In-Reply-To: <YsCdSkzSbVz9gnci@smile.fi.intel.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-Mailman-Approved-At: Wed, 06 Jul 2022 14:51:05 +0000
Subject: Re: [dm-devel] [PATCH 1/4] s390/cio: Rename bitmap_size() as
 idset_bitmap_size()
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
Cc: linux-s390@vger.kernel.org, kernel-janitors@vger.kernel.org,
 ntfs3@lists.linux.dev, yury.norov@gmail.com, gor@linux.ibm.com,
 linux@rasmusvillemoes.dk, hca@linux.ibm.com, snitzer@kernel.org,
 oberpar@linux.ibm.com, linux-kernel@vger.kernel.org,
 almaz.alexandrovich@paragon-software.com, dm-devel@redhat.com,
 svens@linux.ibm.com, vneethv@linux.ibm.com, agordeev@linux.ibm.com,
 borntraeger@linux.ibm.com, agk@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"

TGUgMDIvMDcvMjAyMiDDoCAyMTozMiwgQW5keSBTaGV2Y2hlbmtvIGEgw6ljcml0wqA6Cj4gT24g
U2F0LCBKdWwgMDIsIDIwMjIgYXQgMDk6MjQ6MjRQTSArMDIwMCwgQ2hyaXN0b3BoZSBKQUlMTEVU
IHdyb3RlOgo+PiBMZSAwMi8wNy8yMDIyIMOgIDIwOjU0LCBBbmR5IFNoZXZjaGVua28gYSDDqWNy
aXTCoDoKPj4+IE9uIFNhdCwgSnVsIDAyLCAyMDIyIGF0IDA4OjI5OjA5UE0gKzAyMDAsIENocmlz
dG9waGUgSkFJTExFVCB3cm90ZToKPiAKPiAuLi4KPiAKPj4+PiAtCQltZW1zZXQoc2V0LT5iaXRt
YXAsIDAsIGJpdG1hcF9zaXplKG51bV9zc2lkLCBudW1faWQpKTsKPj4+PiArCQltZW1zZXQoc2V0
LT5iaXRtYXAsIDAsIGlkc2V0X2JpdG1hcF9zaXplKG51bV9zc2lkLCBudW1faWQpKTsKPj4+Cj4+
PiBXaHkgbm90IHRvIHVzZSBiaXRtYXBfemVybygpPwo+IAo+IC4uLgo+IAo+Pj4+IC0JbWVtc2V0
KHNldC0+Yml0bWFwLCAweGZmLCBiaXRtYXBfc2l6ZShzZXQtPm51bV9zc2lkLCBzZXQtPm51bV9p
ZCkpOwo+Pj4+ICsJbWVtc2V0KHNldC0+Yml0bWFwLCAweGZmLCBpZHNldF9iaXRtYXBfc2l6ZShz
ZXQtPm51bV9zc2lkLCBzZXQtPm51bV9pZCkpOwo+Pj4KPj4+IFdoeSBub3QgdG8gdXNlIGJpdG1h
cF9maWxsKCkgPwo+IAo+PiBGb3IgdGhpcyBpbml0aWFsIHN0ZXAsIEkgd2FudGVkIHRvIGtlZXAg
Y2hhbmdlcyBhcyBtaW5pbWFsIGFzIHBvc3NpYmxlIChpLmUKPj4ganVzdCBmdW5jdGlvbiByZW5h
bWluZykKPj4KPj4gSW4gZmFjdCwgSSBwbGFuIHRvIHNlbmQgYSBmb2xsb3ctdXAgcGF0Y2ggb24g
dGhpcyBmaWxlLgo+PiBUaGlzIHdvdWxkIHJlbW92ZSB0aGUgbmV3bHkgcmVuYW1lZCBpZHNldF9i
aXRtYXBfc2l6ZSgpIGZ1bmN0aW9uLCB1c2UgdGhlCj4+IGJpdG1hcCBBUEkgZGlyZWN0bHkgKGFz
IHlvdSBwb2ludGVkLW91dCkgd2l0aAo+PiAic2V0LT5udW1fc3NpZCAqIHNldC0+bnVtX2lkIiBh
cyBzaXplLgo+Pgo+PiBJdCBpcyBhbHJlYWR5IGRvbmUgdGhpcyB3YXkgaW4gaWRzZXRfaXNfZW1w
dHkoKSwgc28gaXQgd291bGQgYmUgbW9yZQo+PiBjb25zaXN0ZW50Lgo+Pgo+PiBJZiB0aGUgc2Vy
aWUgbmVlZHMgYSB2MiAob3IgaWYgcmVxdWlyZWQpLCBJIGNhbiBhZGQgYW4gYWRkaXRpb25hbCA1
dGggcGF0Y2gKPj4gZm9yIGl0LiBPdGhlcndpc2UgaXQgd2lsbCBzZW5kIHNlcGFyYXRseSBsYXRl
ci4KPiAKPiBJZiB5b3UgdXNlIGJpdG1hcCBBUElzIGFzIEkgc3VnZ2VzdGVkIGFib3ZlIGFzIHRo
ZSBmaXJzdCBwYXRjaCwgdGhlIHJlc3Qgd2lsbAo+IGhhdmUgbGVzcyB1bm5lZWRlZCBjaHVybiwg
bm8/Cj4gCj4gCgpNYWtlcyBzZW5zZS4KCkknbGwgd2FpdCBmb3Igc29tZSBvdGhlciBwb3RlbnRp
YWwgY29tbWVudHMgMSBkYXkgb3IgMiBhbmQgc2VuZCBhIHYyIAp3aXRoIHRoZSBzaW1wbGlmaWNh
dGlvbiB5b3UgcHJvcG9zZSBhcyBhbiBpbml0aWFsIHN0ZXAuCgpUaGFua3MgZm9yIHlvdXIgZmVl
ZC1iYWNrLgoKQ0oKCi0tCmRtLWRldmVsIG1haWxpbmcgbGlzdApkbS1kZXZlbEByZWRoYXQuY29t
Cmh0dHBzOi8vbGlzdG1hbi5yZWRoYXQuY29tL21haWxtYW4vbGlzdGluZm8vZG0tZGV2ZWwK

