Return-Path: <SRS0=Ydjc=IG=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D85A2C433DB
	for <dm-devel@archiver.kernel.org>; Mon,  8 Mar 2021 03:55:41 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id DD70965147
	for <dm-devel@archiver.kernel.org>; Mon,  8 Mar 2021 03:55:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DD70965147
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-2-AKP_saP1P7el6_1qDSAKlA-1; Sun, 07 Mar 2021 22:55:37 -0500
X-MC-Unique: AKP_saP1P7el6_1qDSAKlA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C54B080432E;
	Mon,  8 Mar 2021 03:55:31 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id ED67A196E3;
	Mon,  8 Mar 2021 03:55:29 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 61EAF1809C86;
	Mon,  8 Mar 2021 03:55:24 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1283tMXV005357 for <dm-devel@listman.util.phx.redhat.com>;
	Sun, 7 Mar 2021 22:55:23 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id B86E143680; Mon,  8 Mar 2021 03:55:22 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B27C743675
	for <dm-devel@redhat.com>; Mon,  8 Mar 2021 03:55:20 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 89E3C800B30
	for <dm-devel@redhat.com>; Mon,  8 Mar 2021 03:55:20 +0000 (UTC)
Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com
	[209.85.210.181]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-436-TGSfNWZXOQuxFHZPAKyiMw-1; Sun, 07 Mar 2021 22:55:18 -0500
X-MC-Unique: TGSfNWZXOQuxFHZPAKyiMw-1
Received: by mail-pf1-f181.google.com with SMTP id t29so6184023pfg.11
	for <dm-devel@redhat.com>; Sun, 07 Mar 2021 19:55:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:subject:to:cc:references:from:message-id:date
	:user-agent:mime-version:in-reply-to:content-language
	:content-transfer-encoding;
	bh=VvRbjq0mrkefdd7O/F3HULQqRDNy+fW1K5pYetgWW0g=;
	b=SwSTXftxlUWauL0sNtiO6hTqzQfDOZLcN8W9o7WCtMmPAK1XQMF1g2fbWl1Ggc8//a
	24DWec0SWWLAkNIfUz9kqkLxyJckJnidJmNkrjsc/s3vtX3U7bP2QC094QvypEYbj8lj
	q42FK6BrohNnvKY3nmzB4PF0umb2AFG5Un4UagTTmbFzqE5wg+hVB7fyluYMuAA2WNFD
	80JzrnDr2/PiAQN8kmIjUtJtwys4uVpr58luOPMhy5G6z1o6G2kzu1ieidC+joCylBfj
	HTMtMsjqSofp01iL5VX3vrQhqyVfkRlapB2QY96/mTg8AavX8KozoMU+AdB/nxGNXn4i
	BlBA==
X-Gm-Message-State: AOAM530eB98T7/ERo8OZYL/pr/MQRqWNFbFcxKBRVyuriuXh0FX7pybd
	J2fu7nMwNkDd1nFxtAf/PII+0Q==
X-Google-Smtp-Source: ABdhPJzJIXCz62D8J+cVfkO4/8FhMxNYso7SgK4dKCjzP4vTw9PW0t0PR3sRftYXwfotEngqe86yZA==
X-Received: by 2002:a63:534f:: with SMTP id t15mr19641380pgl.126.1615175716895;
	Sun, 07 Mar 2021 19:55:16 -0800 (PST)
Received: from [192.168.1.134] ([66.219.217.173])
	by smtp.gmail.com with ESMTPSA id
	p25sm5159674pfe.100.2021.03.07.19.55.15
	(version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
	Sun, 07 Mar 2021 19:55:16 -0800 (PST)
To: JeffleXu <jefflexu@linux.alibaba.com>,
	Heinz Mauelshagen <heinzm@redhat.com>,
	Mikulas Patocka <mpatocka@redhat.com>
References: <20210302190555.201228400@debian-a64.vm>
	<33fa121a-88a8-5c27-0a43-a7efc9b5b3e3@linux.alibaba.com>
	<alpine.LRH.2.02.2103030505460.29593@file01.intranet.prod.int.rdu2.redhat.com>
	<157a750d-3d58-ae2e-07f1-b677c1b471c7@linux.alibaba.com>
	<bd447632-f174-e6f2-ddf8-d5385da13f6b@redhat.com>
	<fc9707dc-0a21-90d3-ed4f-e201406c50eb@redhat.com>
	<06d17f27-c043-f69c-eeef-f6df714c1764@linux.alibaba.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <000ca63a-46a7-3c93-9b6b-e04bebc971cc@kernel.dk>
Date: Sun, 7 Mar 2021 20:55:13 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
	Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <06d17f27-c043-f69c-eeef-f6df714c1764@linux.alibaba.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-loop: dm-devel@redhat.com
Cc: Mike Snitzer <msnitzer@redhat.com>, caspar@linux.alibaba.com, hch@lst.de,
	linux-block@vger.kernel.org, joseph.qi@linux.alibaba.com,
	dm-devel@redhat.com, io-uring@vger.kernel.org
Subject: Re: [dm-devel] [PATCH 4/4] dm: support I/O polling
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

T24gMy83LzIxIDg6NTQgUE0sIEplZmZsZVh1IHdyb3RlOgo+IAo+IAo+IE9uIDMvNi8yMSAxOjU2
IEFNLCBIZWlueiBNYXVlbHNoYWdlbiB3cm90ZToKPj4KPj4gT24gMy81LzIxIDY6NDYgUE0sIEhl
aW56IE1hdWVsc2hhZ2VuIHdyb3RlOgo+Pj4gT24gMy81LzIxIDEwOjUyIEFNLCBKZWZmbGVYdSB3
cm90ZToKPj4+Pgo+Pj4+IE9uIDMvMy8yMSA2OjA5IFBNLCBNaWt1bGFzIFBhdG9ja2Egd3JvdGU6
Cj4+Pj4+Cj4+Pj4+IE9uIFdlZCwgMyBNYXIgMjAyMSwgSmVmZmxlWHUgd3JvdGU6Cj4+Pj4+Cj4+
Pj4+Pgo+Pj4+Pj4gT24gMy8zLzIxIDM6MDUgQU0sIE1pa3VsYXMgUGF0b2NrYSB3cm90ZToKPj4+
Pj4+Cj4+Pj4+Pj4gU3VwcG9ydCBJL08gcG9sbGluZyBpZiBzdWJtaXRfYmlvX25vYWNjdF9tcV9k
aXJlY3QgcmV0dXJuZWQgbm9uLWVtcHR5Cj4+Pj4+Pj4gY29va2llLgo+Pj4+Pj4+Cj4+Pj4+Pj4g
U2lnbmVkLW9mZi1ieTogTWlrdWxhcyBQYXRvY2thIDxtcGF0b2NrYUByZWRoYXQuY29tPgo+Pj4+
Pj4+Cj4+Pj4+Pj4gLS0tCj4+Pj4+Pj4gwqAgZHJpdmVycy9tZC9kbS5jIHzCoMKgwqAgNSArKysr
Kwo+Pj4+Pj4+IMKgIDEgZmlsZSBjaGFuZ2VkLCA1IGluc2VydGlvbnMoKykKPj4+Pj4+Pgo+Pj4+
Pj4+IEluZGV4OiBsaW51eC0yLjYvZHJpdmVycy9tZC9kbS5jCj4+Pj4+Pj4gPT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PQo+
Pj4+Pj4+IC0tLSBsaW51eC0yLjYub3JpZy9kcml2ZXJzL21kL2RtLmPCoMKgwqAgMjAyMS0wMy0w
Mgo+Pj4+Pj4+IDE5OjI2OjM0LjAwMDAwMDAwMCArMDEwMAo+Pj4+Pj4+ICsrKyBsaW51eC0yLjYv
ZHJpdmVycy9tZC9kbS5jwqDCoMKgIDIwMjEtMDMtMDIgMTk6MjY6MzQuMDAwMDAwMDAwICswMTAw
Cj4+Pj4+Pj4gQEAgLTE2ODIsNiArMTY4MiwxMSBAQCBzdGF0aWMgdm9pZCBfX3NwbGl0X2FuZF9w
cm9jZXNzX2JpbyhzdHJ1Cj4+Pj4+Pj4gwqDCoMKgwqDCoMKgwqDCoMKgIH0KPj4+Pj4+PiDCoMKg
wqDCoMKgIH0KPj4+Pj4+PiDCoCArwqDCoMKgIGlmIChjaS5wb2xsX2Nvb2tpZSAhPSBCTEtfUUNf
VF9OT05FKSB7Cj4+Pj4+Pj4gK8KgwqDCoMKgwqDCoMKgIHdoaWxlIChhdG9taWNfcmVhZCgmY2ku
aW8tPmlvX2NvdW50KSA+IDEgJiYKPj4+Pj4+PiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oCBibGtfcG9sbChjaS5wb2xsX3F1ZXVlLCBjaS5wb2xsX2Nvb2tpZSwgdHJ1ZSkpIDsKPj4+Pj4+
PiArwqDCoMKgIH0KPj4+Pj4+PiArCj4+Pj4+Pj4gwqDCoMKgwqDCoCAvKiBkcm9wIHRoZSBleHRy
YSByZWZlcmVuY2UgY291bnQgKi8KPj4+Pj4+PiDCoMKgwqDCoMKgIGRlY19wZW5kaW5nKGNpLmlv
LCBlcnJub190b19ibGtfc3RhdHVzKGVycm9yKSk7Cj4+Pj4+Pj4gwqAgfQo+Pj4+Pj4gSXQgc2Vl
bXMgdGhhdCB0aGUgZ2VuZXJhbCBpZGVhIG9mIHlvdXIgZGVzaWduIGlzIHRvCj4+Pj4+PiAxKSBz
dWJtaXQgKm9uZSogc3BsaXQgYmlvCj4+Pj4+PiAyKSBibGtfcG9sbCgpLCB3YWl0aW5nIHRoZSBw
cmV2aW91c2x5IHN1Ym1pdHRlZCBzcGxpdCBiaW8gY29tcGxldHMKPj4+Pj4gTm8sIEkgc3VibWl0
IGFsbCB0aGUgYmlvcyBhbmQgcG9sbCBmb3IgdGhlIGxhc3Qgb25lLgo+Pj4+Pgo+Pj4+Pj4gYW5k
IHRoZW4gc3VibWl0IG5leHQgc3BsaXQgYmlvLCByZXBlYXRpbmcgdGhlIGFib3ZlIHByb2Nlc3Mu
IEknbQo+Pj4+Pj4gYWZyYWlkCj4+Pj4+PiB0aGUgcGVyZm9ybWFuY2UgbWF5IGJlIGFuIGlzc3Vl
IGhlcmUsIHNpbmNlIHRoZSBiYXRjaCBldmVyeSB0aW1lCj4+Pj4+PiBibGtfcG9sbCgpIHJlYXBz
IG1heSBkZWNyZWFzZS4KPj4+Pj4gQ291bGQgeW91IGJlbmNobWFyayBpdD8KPj4+PiBJIG9ubHkg
dGVzdGVkIGRtLWxpbmVhci4KPj4+Pgo+Pj4+IFRoZSBjb25maWd1cmF0aW9uIChkbSB0YWJsZSkg
b2YgZG0tbGluZWFyIGlzOgo+Pj4+IDAgMTA0ODU3NiBsaW5lYXIgL2Rldi9udm1lMG4xIDAKPj4+
PiAxMDQ4NTc2IDEwNDg1NzYgbGluZWFyIC9kZXYvbnZtZTJuMSAwCj4+Pj4gMjA5NzE1MiAxMDQ4
NTc2IGxpbmVhciAvZGV2L252bWU1bjEgMAo+Pj4+Cj4+Pj4KPj4+PiBmaW8gc2NyaXB0IHVzZWQg
aXM6Cj4+Pj4gYGBgCj4+Pj4gJGNhdCBmaW8uY29uZgo+Pj4+IFtnbG9iYWxdCj4+Pj4gbmFtZT1p
b3VyaW5nLXNxcG9sbC1pb3BvbGwtMQo+Pj4+IGlvZW5naW5lPWlvX3VyaW5nCj4+Pj4gaW9kZXB0
aD0xMjgKPj4+PiBudW1qb2JzPTEKPj4+PiB0aHJlYWQKPj4+PiBydz1yYW5kcmVhZAo+Pj4+IGRp
cmVjdD0xCj4+Pj4gcmVnaXN0ZXJmaWxlcz0xCj4+Pj4gaGlwcmk9MQo+Pj4+IHJ1bnRpbWU9MTAK
Pj4+PiB0aW1lX2Jhc2VkCj4+Pj4gZ3JvdXBfcmVwb3J0aW5nCj4+Pj4gcmFuZHJlcGVhdD0wCj4+
Pj4gZmlsZW5hbWU9L2Rldi9tYXBwZXIvdGVzdGRldgo+Pj4+IGJzPTRrCj4+Pj4KPj4+PiBbam9i
LTFdCj4+Pj4gY3B1c19hbGxvd2VkPTE0Cj4+Pj4gYGBgCj4+Pj4KPj4+PiBJT1BTIChJUlEgbW9k
ZSkgfCBJT1BTIChpb3BvbGwgbW9kZSAoaGlwcmk9MSkpCj4+Pj4gLS0tLS0tLS0tLS0tLS0tIHwg
LS0tLS0tLS0tLS0tLS0tLS0tLS0KPj4+PiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIDIxM2sgfMKg
wqDCoMKgwqDCoMKgwqDCoMKgIDE5awo+Pj4+Cj4+Pj4gQXQgbGVhc3QsIGl0IGRvZXNuJ3Qgd29y
ayB3ZWxsIHdpdGggaW9fdXJpbmcgaW50ZXJmYWNlLgo+Pj4+Cj4+Pj4KPj4+Cj4+Pgo+Pj4gSmVm
ZmxlLAo+Pj4KPj4+IEkgcmFuIHlvdXIgYWJvdmUgZmlvIHRlc3Qgb24gYSBsaW5lYXIgTFYgc3Bs
aXQgYWNyb3NzIDMgTlZNZXMgdG8KPj4+IHNlY29uZCB5b3VyIHNwbGl0IG1hcHBpbmcKPj4+IChz
eXN0ZW06IDMyIGNvcmUgSW50ZWwsIDI1NkdpQiBSQU0pIGNvbXBhcmluZyBpbyBlbmdpbmVzIHN5
bmMsIGxpYmFpbwo+Pj4gYW5kIGlvX3VyaW5nLAo+Pj4gdGhlIGxhdHRlciB3LyBhbmQgdy9vIGhp
cHJpIChzeW5jK2xpYmFpbyBvYnZpb3VzbHkgdy9vIHJlZ2lzdGVyZmlsZXMKPj4+IGFuZCBoaXBy
aSkgd2hpY2ggcmVzdWx0ZWQgb2s6Cj4+Pgo+Pj4KPj4+Cj4+PiBzeW5jwqAgfMKgIGxpYmFpb8Kg
IHzCoCBJUlEgbW9kZSAoaGlwcmk9MCkgfCBpb3BvbGwgKGhpcHJpPTEpCj4+PiAtLS0tLS18LS0t
LS0tLS0tLXwtLS0tLS0tLS0tLS0tLS0tLS0tLS18LS0tLS0tLS0tLS0tLS0tLS0gNTYuM0sgfMKg
wqDCoAo+Pj4gMjkwS8KgIHzCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgMzI5SyB8wqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgIDM1MUsgSSBjYW4ndCBzZWNvbmQgeW91cgo+Pj4gZHJhc3Rp
YyBoaXByaT0xIGRyb3AgaGVyZS4uLgo+Pgo+Pgo+PiBTb3JyeSwgZW1haWwgbWVzcy4KPj4KPj4K
Pj4gc3luYyDCoCB8wqAgbGliYWlvwqAgfMKgIElSUSBtb2RlIChoaXByaT0wKSB8IGlvcG9sbCAo
aGlwcmk9MSkKPj4gLS0tLS0tLXwtLS0tLS0tLS0tfC0tLS0tLS0tLS0tLS0tLS0tLS0tLXwtLS0t
LS0tLS0tLS0tLS0tLQo+PiA1Ni4zS8KgIHzCoMKgwqAgMjkwS8KgIHzCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqAgMzI5SyB8wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIDM1MUsKPj4KPj4K
Pj4KPj4gSSBjYW4ndCBzZWNvbmQgeW91ciBkcmFzdGljIGhpcHJpPTEgZHJvcCBoZXJlLi4uCj4+
Cj4gCj4gSHVtbW0sIHRoYXQncyBpbmRlZWQgc29tZXdoYXQgc3RyYW5nZS4uLgo+IAo+IE15IHRl
c3QgZW52aXJvbm1lbnQ6Cj4gLSBDUFU6IDEyOCBjb3JlcywgdGhvdWdoIG9ubHkgb25lIENQVSBj
b3JlIGlzIHVzZWQgc2luY2UKPiAnY3B1c19hbGxvd2VkPTE0JyBpbiBmaW8gY29uZmlndXJhdGlv
bgo+IC0gbWVtb3J5OiA5ODNHIG1lbW9yeSBmcmVlCj4gLSBOVk1lOiBIdWF3YWkgRVMzNTEwUCAo
SFdFNTJQNDM0VDBMMDA1TiksIHdpdGggJ252bWUucG9sbF9xdWV1ZXM9MycKPiAKPiBNYXliZSB5
b3UgZGlkbid0IHNwZWNpZnkgJ252bWUucG9sbF9xdWV1ZXM9WFhYJz8gSW4gdGhpcyBjYXNlLCBJ
TyBzdGlsbAo+IGdvZXMgaW50byBJUlEgbW9kZSwgZXZlbiB5b3UgaGF2ZSBzcGVjaWZpZWQgJ2hp
cHJpPTEnPwoKVGhhdCB3b3VsZCBiZSBteSBndWVzcyB0b28sIGFuZCB0aGUgcGF0Y2hlcyBhbHNv
IGhhdmUgYSB2ZXJ5IHN1c3BpY2lvdXMKY2xlYXIgb2YgSElQUkkgd2hpY2ggc2hvdWxkbid0IGJl
IHRoZXJlICh3aGljaCB3b3VsZCBsZXQgdGhhdCBmbHkgdGhyb3VnaCkuCgotLSAKSmVucyBBeGJv
ZQoKLS0KZG0tZGV2ZWwgbWFpbGluZyBsaXN0CmRtLWRldmVsQHJlZGhhdC5jb20KaHR0cHM6Ly9s
aXN0bWFuLnJlZGhhdC5jb20vbWFpbG1hbi9saXN0aW5mby9kbS1kZXZlbA==

