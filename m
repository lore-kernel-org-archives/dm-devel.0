Return-Path: <SRS0=DU+z=EK=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51E0BC2D0A3
	for <dm-devel@archiver.kernel.org>; Wed,  4 Nov 2020 07:35:10 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id A7D622080D
	for <dm-devel@archiver.kernel.org>; Wed,  4 Nov 2020 07:35:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A7D622080D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-189-UTG7jp_SMRy6ep4luvwiLQ-1; Wed, 04 Nov 2020 02:35:06 -0500
X-MC-Unique: UTG7jp_SMRy6ep4luvwiLQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 922FC1009E31;
	Wed,  4 Nov 2020 07:35:01 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 709195C1D0;
	Wed,  4 Nov 2020 07:35:01 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 3477E181A07B;
	Wed,  4 Nov 2020 07:35:01 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0A46m0eI016589 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 4 Nov 2020 01:48:00 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 2E2192166BA4; Wed,  4 Nov 2020 06:48:00 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 28C8F2166BA3
	for <dm-devel@redhat.com>; Wed,  4 Nov 2020 06:47:56 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2FF318007DF
	for <dm-devel@redhat.com>; Wed,  4 Nov 2020 06:47:56 +0000 (UTC)
Received: from out30-133.freemail.mail.aliyun.com
	(out30-133.freemail.mail.aliyun.com [115.124.30.133]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-462-byGggCX5PaixaFHQE6Nmrw-1;
	Wed, 04 Nov 2020 01:47:50 -0500
X-MC-Unique: byGggCX5PaixaFHQE6Nmrw-1
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R241e4; CH=green; DM=||false|;
	DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=e01e04357;
	MF=jefflexu@linux.alibaba.com; NM=1; PH=DS; RN=8; SR=0;
	TI=SMTPD_---0UEATY5e_1604472464
Received: from admindeMacBook-Pro-2.local(mailfrom:jefflexu@linux.alibaba.com
	fp:SMTPD_---0UEATY5e_1604472464) by smtp.aliyun-inc.com(127.0.0.1);
	Wed, 04 Nov 2020 14:47:44 +0800
To: Mike Snitzer <snitzer@redhat.com>
References: <20201020065420.124885-1-jefflexu@linux.alibaba.com>
	<20201021203906.GA10896@redhat.com>
	<da936cfa-93a8-d6ec-bd88-c0fad6c67c8b@linux.alibaba.com>
	<20201026185334.GA8463@redhat.com>
	<33c32cd1-5116-9a42-7fe2-b2a383f1c7a0@linux.alibaba.com>
	<20201102152822.GA20466@redhat.com>
From: JeffleXu <jefflexu@linux.alibaba.com>
Message-ID: <f165f38a-91d1-79aa-829d-a9cc69a5eee6@linux.alibaba.com>
Date: Wed, 4 Nov 2020 14:47:44 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
	Gecko/20100101 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <20201102152822.GA20466@redhat.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Wed, 04 Nov 2020 02:34:40 -0500
Cc: axboe@kernel.dk, xiaoguang.wang@linux.alibaba.com,
	linux-block@vger.kernel.org, joseph.qi@linux.alibaba.com,
	dm-devel@redhat.com, haoxu@linux.alibaba.com, io-uring@vger.kernel.org
Subject: Re: [dm-devel] [RFC 0/3] Add support of iopoll for dm device
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"

Ck9uIDExLzIvMjAgMTE6MjggUE0sIE1pa2UgU25pdHplciB3cm90ZToKPiBPbiBTdW4sIE5vdiAw
MSAyMDIwIGF0IDEwOjE0cG0gLTA1MDAsCj4gSmVmZmxlWHUgPGplZmZsZXh1QGxpbnV4LmFsaWJh
YmEuY29tPiB3cm90ZToKPgo+PiBPbiAxMC8yNy8yMCAyOjUzIEFNLCBNaWtlIFNuaXR6ZXIgd3Jv
dGU6Cj4+PiBXaGF0IHlvdSBkZXRhaWxlZCB0aGVyZSBpc24ndCBwcm9wZXJseSBtb2RlbGluZyB3
aGF0IGl0IG5lZWRzIHRvLgo+Pj4gQSBnaXZlbiBkbV90YXJnZXRfaW8gY291bGQgcmVzdWx0IGlu
IHF1aXRlIGEgZmV3IGJpb3MgKGUuZy4gZm9yCj4+PiBkbS1zdHJpcGVkIHdlIGNsb25lIGVhY2gg
YmlvIGZvciBlYWNoIG9mIE4gc3RyaXBlcykuICBTbyB0aGUgZmFuLW91dCwKPj4+IGVzcGVjaWFs
bHkgaWYgdGhlbiBzdGFja2VkIG9uIE4gbGF5ZXJzIG9mIHN0YWNrZWQgZGV2aWNlcywgdG8gYWxs
IHRoZQo+Pj4gdmFyaW91cyBoY3R4IGF0IHRoZSBsb3dlc3QgbGF5ZXJzIGlzIGxpa2UgaGVyZGlu
ZyBjYXRzLgo+Pj4KPj4+IEJ1dCB0aGUgcmVjdXJzaW9uIGluIGJsb2NrIGNvcmUncyBzdWJtaXRf
YmlvIHBhdGggbWFrZXMgdGhhdCBjaGFsbGVuZ2luZwo+Pj4gdG8gc2F5IHRoZSBsZWFzdC4gIFNv
IG11Y2ggc28gdGhhdCBhbnkgc29sdXRpb24gcmVsYXRlZCB0byBlbmFibGluZwo+Pj4gcHJvcGVy
IGJpby1iYXNlZCBJTyBwb2xsaW5nIGlzIGdvaW5nIHRvIG5lZWQgYSBwcmV0dHkgc2lnbmlmaWNh
bnQKPj4+IGludmVzdG1lbnQgaW4gZml4aW5nIGJsb2NrIGNvcmUgKHN0b3JpbmcgX19zdWJtaXRf
YmlvKCkncyBjb29raWUgZHVyaW5nCj4+PiByZWN1cnNpb24sIHBvc3NpYmx5IHN0b3JpbmcgdG8g
ZHJpdmVyIHByb3ZpZGVkIG1lbW9yeSBsb2NhdGlvbiwKPj4+IGUuZy4gRE0gaW5pdGlhbGl6ZWQg
YmlvLT5zdWJtaXRfY29va2llIHBvaW50ZXIgdG8gYSBibGtfcWNfdCB3aXRoaW4gYSBETQo+Pj4g
Y2xvbmUgYmlvJ3MgcGVyLWJpby1kYXRhKS4KPj4+Cj4+PiBTTyBfX3N1Ym1pdF9iaW9fbm9hY2N0
IHdvdWxkIGJlY29tZToKPj4+Cj4+PiAgICAgcmV0cCA9ICZyZXQ7Cj4+PiAgICAgaWYgKGJpby0+
c3VibWl0X2Nvb2tpZSkKPj4+ICAgICAgICAgICAgcmV0cCA9IGJpby0+c3VibWl0X2Nvb2tpZTsK
Pj4+ICAgICAqcmV0cCA9IF9fc3VibWl0X2JpbyhiaW8pOwo+PiBTb3JyeSBmb3IgdGhlIGxhdGUg
cmVwbHkuIEV4YWN0bHkgSSBtaXNzZWQgdGhpcyBwb2ludCBiZWZvcmUuIElGIHlvdQo+PiBoYXZl
IG5vdCBzdGFydGVkIHdvcmtpbmcgb24gdGhpcywgSSdkIGxpa2UgdG8gdHJ5IHRvIGltcGxlbWVu
dCB0aGlzIGFzCj4+IGFuIFJGQy4KPiBJIGRpZCBzdGFydCBvbiB0aGlzIGxpbmUgb2YgZGV2ZWxv
cG1lbnQgYnV0IGl0IG5lZWRzIHF1aXRlIGEgYml0IG1vcmUKPiB3b3JrLiAgRXZlbiB0aGUgcHNl
dWRvIGNvZGUgSSBwcm92aWRlZCBhYm92ZSBpc24ndCB1c2VmdWwgaW4gdGhlIGNvbnRleHQKPiBv
ZiBETSBjbG9uZSBiaW9zIHRoYXQgaGF2ZSB0aGVpciBvd24gcGVyLWJpby1kYXRhIHRvIGFzc2lz
dCB3aXRoIHRoaXMKPiBpbXBsZW1lbnRhdGlvbi4gIEJlY2F1c2UgdGhlIF9fc3VibWl0X2Jpb19u
b2FjY3QoKSByZWN1cnNpdmUgY2FsbAo+IGRyaXZlcnMvbWQvZG0uYzpfX3NwbGl0X2FuZF9wcm9j
ZXNzX2JpbygpIG1ha2VzIGlzIHN1cHBseWluZyB0aGUKPiBvcmlnaW5hbCBiaW8gKG1vZGlmaWVk
IHRvIG9ubHkgcG9pbnQgdG8gcmVtYWluaW5nIHdvcmspLgoKWWVzIEkgbm90aWNlZCB0aGlzIHJl
Y2VudGx5LiBTaW5jZSB0aGUgZGVwdGgtZmlyc3Qgc3BsaXR0aW5nIGludHJvZHVjZWQgCmluIGNv
bW1pdCAxOGEyNWRhODQzNTQKCigiZG06IGVuc3VyZSBiaW8gc3VibWlzc2lvbiBmb2xsb3dzIGEg
ZGVwdGgtZmlyc3QgdHJlZSB3YWxrIiksIG9uZSBiaW8gCnRvIGRtIGRldmljZSBjYW4gYmUKCnNw
bGl0IGludG8gbXVsdGlwbGUgYmlvcyB0byB0aGlzIGRtIGRldmljZS4KCmBgYAoKb25lIGJpbyB0
byBkbSBkZXZpY2UgKGRtMCkgPSBvbmUgZG1faW8gKHRvIG52bWUwKSArIG9uZSBiaW8gdG8gdGhp
cyBzYW1lIApkbSBkZXZpY2UgKGRtMCkKCmBgYAoKCkluIHRoaXMgY2FzZSB3ZSBuZWVkIGEgbWVj
aGFuaXNtIHRvIHRyYWNrIGFsbCBzcGxpdCBzdWItYmlvcyBvZiB0aGUgdmVyeSAKYmVnaW5uaW5n
IG9yaWdpbmFsIGJpby4KCkknbSBkb3VidGVkIGlmIHRoaXMgc2hvdWxkIGJlIGltcGxlbWVudGVk
IGluIGJsb2NrIGxheWVyIGxpa2U6CgpgYGAKCnN0cnVjdCBiaW8gewoKIMKgwqDCoCAuLi4KCiDC
oMKgwqAgc3RydWN0IGxpc3RfaGVhZMKgIGNvb2tpZXM7Cgp9OwoKYGBgCgpBZnRlciBhbGwgaXQn
cyBvbmx5IHVzZWQgYnkgYmlvLWJhc2VkIHF1ZXVlLCBvciBtb3JlIHNwZWNpZmljYWxseSBvbmx5
IApkbSBkZXZpY2UgY3VycmVudGx5LgoKCkFub3RoZXIgZGVzaWduIEkgY2FuIGNvbWUgdXAgd2l0
aCBpcyB0byBtYWludGFpbiBhIGdsb2JhbCBkYXRhIHN0cnVjdHVyZSAKZm9yIHRoZSB2ZXJ5IGJl
Z2lubmluZwoKb3JpZ2luYWwgYmlvLiBDdXJyZW50bHkgdGhlIGJsb2NraW5nIHBvaW50IGlzIHRo
YXQgbm93IG9uZSBvcmlnaW5hbCBiaW8gCnRvIHRoZSBkbSBkZXZpY2UgKEBiaW8gb2YKCmRtX3N1
Ym1pdCgpKSBjYW4gY29ycmVzcG9uZCB0byBtdWx0aXBsZSBkbV9pbyBhbmQgdGh1cyB3ZSBoYXZl
IG5vd2hlcmUgCnRvIHBsYWNlIHRoZQoKQGNvb2tpZXMgbGlzdC4KCgpOb3cgd2UgaGF2ZSB0byBt
YWludGFpbiBvbmUgZGF0YSBzdHJ1Y3R1cmUgZm9yIGV2ZXJ5IG9yaWdpbmFsIGJpbywgCnNvbWV0
aGluZyBsaWtlCgpgYGAKCnN0cnVjdCBkbV9wb2xsX2luc3RhbmNlIHsKCiDCoMKgwqAgLi4uCgog
wqDCoMKgIHN0cnVjdCBsaXN0X2hlYWQgY29va2llczsKCn07CgpgYGAKCgpXZSBjYW4gdHJhbnNm
ZXIgdGhpcyBkbV9wb2xsX2luc3RhbmNlIGJldHdlZW4gc3BsaXQgYmlvcyBieSAKYmlvLT5iaV9w
cml2YXRlLCBsaWtlCgpgYGAKCmRtX3N1Ym1pdF9iaW8oLi4uKSB7CgogwqDCoMKgIHN0cnVjdCBk
bV9wb2xsX2luc3RhbmNlICppbnM7CgogwqDCoMKgIGlmIChiaW8tPmJpX3ByaXZhdGUpCgogwqDC
oMKgIMKgwqDCoCBpbnMgPSBiaW8tPmJpX3ByaXZhdGU7CgogwqDCoMKgIGVsc2UgewoKIMKgwqDC
oCDCoMKgwqAgaW5zID0gYWxsb2NfcG9sbF9pbnN0YW5jZSgpOwoKIMKgwqDCoCDCoMKgwqAgYmlv
LT5iaV9wcml2YXRlID0gaW5zOwoKIMKgwqDCoCB9CgogwqDCoMKgIC4uLgoKfQoKYGBgCgoKCi0t
IApKZWZmbGUKVGhhbmtzCgotLQpkbS1kZXZlbCBtYWlsaW5nIGxpc3QKZG0tZGV2ZWxAcmVkaGF0
LmNvbQpodHRwczovL3d3dy5yZWRoYXQuY29tL21haWxtYW4vbGlzdGluZm8vZG0tZGV2ZWw=

