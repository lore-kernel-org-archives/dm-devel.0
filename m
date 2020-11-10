Return-Path: <SRS0=xkgx=EQ=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F258C388F7
	for <dm-devel@archiver.kernel.org>; Tue, 10 Nov 2020 07:55:40 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id CDFCA2080A
	for <dm-devel@archiver.kernel.org>; Tue, 10 Nov 2020 07:55:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CDFCA2080A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-444-cHm_lEZfNZyJ4pqgnY35Dw-1; Tue, 10 Nov 2020 02:55:37 -0500
X-MC-Unique: cHm_lEZfNZyJ4pqgnY35Dw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 92CDF1882FB3;
	Tue, 10 Nov 2020 07:55:32 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 707FA272A9;
	Tue, 10 Nov 2020 07:55:32 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 4450E5810D;
	Tue, 10 Nov 2020 07:55:32 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0AA1hOFO021111 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 9 Nov 2020 20:43:25 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id D19522157F5E; Tue, 10 Nov 2020 01:43:24 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id CC7622157F5D
	for <dm-devel@redhat.com>; Tue, 10 Nov 2020 01:43:22 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6F2618007D9
	for <dm-devel@redhat.com>; Tue, 10 Nov 2020 01:43:22 +0000 (UTC)
Received: from out30-132.freemail.mail.aliyun.com
	(out30-132.freemail.mail.aliyun.com [115.124.30.132]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-270-DyimMYR4OwW_HY0ivRJzpg-1;
	Mon, 09 Nov 2020 20:43:17 -0500
X-MC-Unique: DyimMYR4OwW_HY0ivRJzpg-1
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R141e4; CH=green; DM=||false|;
	DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=e01e04400;
	MF=jefflexu@linux.alibaba.com; NM=1; PH=DS; RN=8; SR=0;
	TI=SMTPD_---0UEq6B8P_1604972592
Received: from admindeMacBook-Pro-2.local(mailfrom:jefflexu@linux.alibaba.com
	fp:SMTPD_---0UEq6B8P_1604972592) by smtp.aliyun-inc.com(127.0.0.1);
	Tue, 10 Nov 2020 09:43:12 +0800
To: Mike Snitzer <snitzer@redhat.com>
References: <20201021203906.GA10896@redhat.com>
	<da936cfa-93a8-d6ec-bd88-c0fad6c67c8b@linux.alibaba.com>
	<20201026185334.GA8463@redhat.com>
	<33c32cd1-5116-9a42-7fe2-b2a383f1c7a0@linux.alibaba.com>
	<20201102152822.GA20466@redhat.com>
	<f165f38a-91d1-79aa-829d-a9cc69a5eee6@linux.alibaba.com>
	<20201104150847.GB32761@redhat.com>
	<2c5dab21-8125-fcdf-078e-00a158c57f43@linux.alibaba.com>
	<20201106174526.GA13292@redhat.com>
	<23c73ad7-23e3-3172-8f0e-3c15e0fa5a87@linux.alibaba.com>
	<20201109181528.GA8599@redhat.com>
From: JeffleXu <jefflexu@linux.alibaba.com>
Message-ID: <0b133186-024b-76e2-ef29-6bd6fa865a1c@linux.alibaba.com>
Date: Tue, 10 Nov 2020 09:43:12 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
	Gecko/20100101 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <20201109181528.GA8599@redhat.com>
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
X-Mailman-Approved-At: Tue, 10 Nov 2020 02:55:04 -0500
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"

Ck9uIDExLzEwLzIwIDI6MTUgQU0sIE1pa2UgU25pdHplciB3cm90ZToKPiBPbiBTYXQsIE5vdiAw
NyAyMDIwIGF0ICA4OjA5cG0gLTA1MDAsCj4gSmVmZmxlWHUgPGplZmZsZXh1QGxpbnV4LmFsaWJh
YmEuY29tPiB3cm90ZToKPgo+PiBPbiAxMS83LzIwIDE6NDUgQU0sIE1pa2UgU25pdHplciB3cm90
ZToKPj4+IE9uIFRodSwgTm92IDA1IDIwMjAgYXQgIDk6NTFwbSAtMDUwMCwKPj4+IEplZmZsZVh1
IDxqZWZmbGV4dUBsaW51eC5hbGliYWJhLmNvbT4gd3JvdGU6Cj4+Pgo+Pj4+IGJsay1tcS5jOiBi
bGtfbXFfc3VibWl0X2Jpbwo+Pj4+Cj4+Pj4gIMKgwqDCoCBpZiAoYmlvLT5vcmlnKQo+Pj4+Cj4+
Pj4gIMKgwqDCoCDCoMKgwqAgaW5pdCBibGtfcG9sbF9kYXRhIGFuZCBpbnNlcnQgaXQgaW50byBi
aW8tPm9yaWcncyBAY29va2llcyBsaXN0Cj4+Pj4KPj4+PiBgYGAKPj4+IElmIHlvdSBmZWVsIHRo
YXQgaXMgZG9hYmxlOiBjZXJ0YWlubHkgZ2l2ZSBpdCBhIHNob3QuCj4+IE1ha2Ugc2Vuc2UuCj4+
Cj4+PiBCdXQgaXQgaXMgbm90IGNsZWFyIHRvIG1lIGhvdyB5b3UgaW50ZW5kIHRvIHRyYW5zbGF0
ZSBmcm9tIGNvb2tpZSBwYXNzZWQKPj4+IGluIHRvIC0+YmxrX3BvbGwgaG9vayAocmV0dXJuZWQg
ZnJvbSBzdWJtaXRfYmlvKSB0byB0aGUgc2F2ZWQgb2ZmCj4+PiBiaW8tPm9yaWcuCj4+Pgo+Pj4g
V2hhdCBpcyB5b3VyIGNvb2tpZSBzdHJhdGVneSBpbiB0aGlzIG5vbi1yZWN1cnNpdmUgaW1wbGVt
ZW50YXRpb24/ICBXaGF0Cj4+PiB3aWxsIHlvdSBiZSByZXR1cm5pbmc/ICBXaGVyZSB3aWxsIHlv
dSBiZSBzdG9yaW5nIGl0Pwo+PiBBY3R1YWxseSBJIHRoaW5rIGl0J3MgYSBjb21tb24gaXNzdWUg
dG8gZGVzaWduIHRoZSBjb29raWUgcmV0dXJuZWQKPj4gYnkgc3VibWl0X2JpbygpIHdoZW5ldmVy
IGl0J3MgaW1wbGVtZW50ZWQgaW4gYSByZWN1cnNpdmUgb3IKPj4gbm9uLXJlY3Vyc2l2ZSB3YXku
IEFmdGVyIGFsbCB5b3UgbmVlZCB0byB0cmFuc2xhdGUgdGhlIHJldHVybmVkIGNvb2tpZQo+PiB0
byB0aGUgb3JpZ2luYWwgYmlvIGV2ZW4gaWYgaXQncyBpbXBsZW1lbnRlZCBpbiBhIHJlY3Vyc2l2
ZSB3YXkgYXMgeW91Cj4+IGRlc2NyaWJlZC4KPiBZZXMuCj4KPj4gT3IgaG93IGNvdWxkIHlvdSB3
YWxrIHRocm91Z2ggdGhlIGJpbyBncmFwaCB3aGVuIHRoZSByZXR1cm5lZCBjb29raWUKPj4gaXMg
b25seSAndW5zaWduZWQgaW50JyB0eXBlPwo+IFlvdSBjb3VsZCBzdG9yZSBhIHBvaW50ZXIgKHRv
IG9yaWcgYmlvLCBvciBwZXItYmlvLWRhdGEgc3RvcmVkIGluIHNwbGl0Cj4gY2xvbmUsIG9yIHdo
YXRldmVyIG1ha2VzIHNlbnNlIGZvciBob3cgeW91J3JlIGFzc29jaWF0aW5nIHBvbGwgZGF0YSB3
aXRoCj4gc3BsaXQgYmlvcykgaW4gJ3Vuc2lnbmVkIGludCcgdHlwZSBidXQgdGhhdCdzIHZlcnkg
Y2x1bXN5IC0tIGFzIEkKPiBkaXNjb3ZlcmVkIHdoZW4gdHJ5aW5nIHRvIGRvIHRoYXQgOykKCkZp
bmUsIHRoYXQncyBhbHNvIHdoYXQgSSB0aG91Z2h0LgoKCj4KPj4gSG93IGFib3V0IHRoaXM6Cj4+
Cj4+Cj4+IGBgYAo+Pgo+PiB0eXBlZGVmIHVpbnRwdHJfdCBibGtfcWNfdDsKPj4KPj4gYGBgCj4+
Cj4+Cj4+IG9yIHNvbWV0aGluZyBsaWtlIHVuaW9uCj4+Cj4+IGBgYAo+Pgo+PiB0eXBlZGVmIHVu
aW9uIHsKPj4KPj4gIMKgwqDCoCB1bnNpZ25lZCBpbnQgY29va2llOwo+Pgo+PiAgwqDCoMKgIHN0
cnVjdCBiaW8gKm9yaWc7IC8vIHRoZSBvcmlnaW5hbCBiaW8gb2Ygc3VibWl0X2JpbygpCj4+Cj4+
IH0gYmxrX3FjX3Q7Cj4+Cj4+IGBgYAo+PiBXaGVuIHNlcnZpbmcgZm9yIGJsay1tcSwgdGhlIGlu
dGVnZXIgcGFydCBvZiBibGtfcWNfdCBpcyB1c2VkIGFuZCBpdAo+PiBzdG9yZXMgdGhlIHZhbGlk
IGNvb2tpZSwgd2hpbGUgaXQgc3RvcmVzIGEgcG9pbnRlciB0byB0aGUgb3JpZ2luYWwgYmlvCj4+
IHdoZW4gc2VydmluZyBiaW8tYmFzZWQgZGV2aWNlLgo+IFVuaW9uIGxvb2tzIGlkZWFsLCBidXQg
bWF5YmUgbWFrZSBpdCBhIHZvaWQgKj8gIEluaXRpYWwgaW1wbGVtZW50YXRpb24KPiBtYXkgc3Rv
cmUgYmlvIHBvaW50ZXIgYnV0IGl0IF9jb3VsZF8gZXZvbHZlIHRvIGJlICdzdHJ1Y3QgYmxrX3Bv
bGxfZGF0YQo+IConIG9yIHdoYXRldmVyLiAgQnV0IG5vdCBhIGJpZyBkZWFsIGVpdGhlciB3YXku
CgpPZiBjb3Vyc2UgeW91IGNvdWxkIGRlZmluZSBibGtfcWNfdCBhcyBhIHBvaW50ZXIgdHlwZSAo
ZS5nLiB2b2lkICopLCBvciAKaW50ZWdlciB0eXBlIChlLmcuIHVuc2lnbmVkIGludCksCgpidXQg
eW91IHdpbGwgZ2V0IGEgZ2NjIHdhcm5pbmcgaW4gZWFjaCBjYXNlLiBGb3IgZXhhbXBsZSwgaWYg
aXQncyAKZGVmaW5lZCBhcyAidm9pZCAqIiwgdGhlbiBnY2Mgd2lsbCB3YXJuCgoncmV0dXJuIG1h
a2VzIHBvaW50ZXIgZnJvbSBpbnRlZ2VyIHdpdGhvdXQgYSBjYXN0JyBpbiByZXF1ZXN0X3RvX3Fj
X3QoKSAKYXMgY29va2llIHJldHVybmVkIGJ5IG1xCgpkZXZpY2UgaXMgYWN0dWFsbHkgaW50ZWdl
ciB0eXBlLiBWaWNlIHZlcnNhLiBTbyB3ZSBuZWVkIGEgdHlwZSBjYXN0IGluIApyZXF1ZXN0X3Rv
X3FjX3QoKS4KCgpUaGUgdW5pb24gaXMgYWxzbyBub3QgcGVyZmVjdCB0aG91Z2gsIGFzIHdlIGFs
c28gbmVlZCB0eXBlIGNhc3QuCgoKU28gYm90aCB0aGVzZSB0d28gZGVzaWducyBhcmUgcXVpdGUg
ZXF1YWwgdG8gbWUsIHRob3VnaCAndm9pZCAqJyBtYXkgYmUgCm1vcmUgY29uY2lzZSB0aG91Z2gu
CgpCdXQgb25lIGFubm95aW5nIGlzc3VlIGlzIHRoYXQgdGhlIHJlcXVlc3RfdG9fcWNfdCgpIGFu
ZCBibGtfcG9sbCgpIApzaG91bGQgYmUgcmV2aXNlZCBzb21laG93CgppZiBpdCdzIGRlZmluZWQg
YXMgYSB1bmlvbiBvciAndm9pZCAqJy4gRm9yIGV4YW1wbGUgaWYgaXQncyBkZWZpbmVkIGFzIAon
dm9pZCAqJywgdGhlbiBpbiByZXF1ZXN0X3RvX3FjX3QoKQoKaW50ZWdlciBuZWVkIHRvIGJlIGNh
c3QgdG8gcG9pbnRlciBhbmQgaW4gYmxrX3BvbGwoKSBwb2ludGVyIG5lZWQgdG8gYmUgCmNhc3Qg
dG8gaW50ZWdlci4KCgpUaGUgYmVuZWZpdCBvZiB1aW50cHRyX3QgaXMgdGhhdCwgaXQncyBzdGls
bCBpbnRlZ2VyIHR5cGUgd2hpY2ggbWVhbnMgCnRoZSBvcmlnaW5hbCByZXF1ZXN0X3RvX3FjX3Qo
KS8KCmJsa19wb2xsKCkgcm91dGluZSBmb3IgYmxrLW1xIGNhbiByZXRhaW4gdW5jaGFuZ2VkLCB3
aGlsZSB0aGUgc2l6ZSBvZiAKdGhlIGRhdGEgdHlwZSBjYW4gYmUgbGFyZ2UKCmVub3VnaCB0byBj
b250YWluIGEgcG9pbnRlciB0eXBlLiBTbyB3ZSBvbmx5IG5lZWTCoCB0eXBlIGNhc3QgaW4gCmJp
by1iYXNlZCByb3V0aW5lLCB3aGlsZSBrZWVwaW5nCgp0aGUgcmVxdWVzdC1iYXNlZCByb3V0aW5l
IHVuY2hhbmdlZC4KCgpBbmQgeWVzIGl0J3MgYSB0cml2aWFsIGlzc3VlIHRob3VnaC4KCgo+PiBC
eSB0aGUgd2F5LCB3b3VsZCB5b3UgbWluZCBzaGFyaW5nIHlvdXIgcGxhbiBhbmQgcHJvZ3Jlc3Mg
b24gdGhpcwo+PiB3b3JrLCBJIG1lYW4sIHN1cHBvcnRpbmcgaW9wb2xsIGZvciBkbSBkZXZpY2Uu
IFRvIGJlIGhvbmVzdCwgSSBkb24ndAo+PiB3YW50IHRvIHJlLWludmVudCB0aGUgd2hlZWwgYXMg
eW91IGhhdmUgc3RhcnRlZCBvbiB0aGlzIHdvcmssIGJ1dCBJIGRvCj4+IHdhbnQgdG8gcGFydGlj
aXBhdGUgaW4gc29tZWhvdy4gUGxlYXNlIGxldCBtZSBrbm93IGlmIHRoZXJlJ3Mgc29tZXRoaW5n
Cj4+IEkgY291bGQgZG8gaGVyZS4KPiBJIHRob3VnaHQgSSBzYWlkIGFzIG11Y2ggYmVmb3JlIGJ1
dDogSSByZWFsbHkgZG9uJ3QgaGF2ZSBhbnl0aGluZwo+IG1lYW5pbmdmdWwgdG8gc2hhcmUuICBN
eSBlYXJseSBleHBsb3JhdGlvbiB3YXMgbW9yZSByb3VnaCBwc2V1ZG8gY29kZQo+IHRoYXQgc2Vy
dmVkIHRvIHRyeSB0byBnZXQgbXkgYXJtcyBhcm91bmQgdGhlIHNjb3BlIG9mIHRoZSBkZXNpZ24K
PiBwcm9ibGVtLgo+Cj4gUGxlYXNlIGZlZWwgZnJlZSB0byBvd24gYWxsIGFzcGVjdHMgb2YgdGhp
cyB3b3JrLgo+Cj4gSSB3aWxsIGdsYWRseSBoZWxwIGFuYWx5emUvdGVzdC9yZWZpbmUgeW91ciBh
cHByb2FjaCBvbmNlIHlvdSByZWFjaCB0aGUKPiBwb2ludCBvZiBzaGFyaW5nIFJGQyBwYXRjaGVz
LgoKR290IGl0LiBUaGFua3MgZm9yIHRoYXQuIFJlYWxseS4gSSB3aWxsIGNvbnRpbnVlIHdvcmtp
bmcgb24gdGhpcy4KCgotLSAKVGhhbmtzLApKZWZmbGUKCi0tCmRtLWRldmVsIG1haWxpbmcgbGlz
dApkbS1kZXZlbEByZWRoYXQuY29tCmh0dHBzOi8vd3d3LnJlZGhhdC5jb20vbWFpbG1hbi9saXN0
aW5mby9kbS1kZXZlbA==

