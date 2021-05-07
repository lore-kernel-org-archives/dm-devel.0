Return-Path: <SRS0=qllc=KC=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5ACDEC433B4
	for <dm-devel@archiver.kernel.org>; Fri,  7 May 2021 18:42:46 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id E174B61460
	for <dm-devel@archiver.kernel.org>; Fri,  7 May 2021 18:42:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E174B61460
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=tls.msk.ru
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-173-p2JTiZIuPsGIK5sxmVlENw-1; Fri, 07 May 2021 14:42:39 -0400
X-MC-Unique: p2JTiZIuPsGIK5sxmVlENw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 01716107ACCD;
	Fri,  7 May 2021 18:42:33 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 8904919D61;
	Fri,  7 May 2021 18:42:30 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 8A6BA55351;
	Fri,  7 May 2021 18:42:27 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 147IgPUV014651 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 7 May 2021 14:42:25 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 2F33C170434; Fri,  7 May 2021 18:42:25 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 2A55C1711B5
	for <dm-devel@redhat.com>; Fri,  7 May 2021 18:42:22 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id F2113101A54C
	for <dm-devel@redhat.com>; Fri,  7 May 2021 18:42:21 +0000 (UTC)
Received: from isrv.corpit.ru (isrv.corpit.ru [86.62.121.231]) (Using TLS)
	by relay.mimecast.com with ESMTP id us-mta-250-ss_O1cU-NMeQTa6-FYLDNw-1;
	Fri, 07 May 2021 14:42:19 -0400
X-MC-Unique: ss_O1cU-NMeQTa6-FYLDNw-1
Received: from tsrv.corpit.ru (tsrv.tls.msk.ru [192.168.177.2])
	by isrv.corpit.ru (Postfix) with ESMTP id 8EA9D40010;
	Fri,  7 May 2021 21:42:16 +0300 (MSK)
Received: from [192.168.177.130] (mjt.wg.tls.msk.ru [192.168.177.130])
	by tsrv.corpit.ru (Postfix) with ESMTP id E005570;
	Fri,  7 May 2021 21:42:16 +0300 (MSK)
To: Mike Snitzer <snitzer@redhat.com>
References: <7104c94c-7408-0d58-ddd9-384102e820bc@msgid.tls.msk.ru>
	<6a71df25-d1fb-db02-ff55-384ba0828647@redhat.com>
	<84eaa68f-3ea3-8313-2953-46375dce9f86@msgid.tls.msk.ru>
	<YJVauS60BjSFkW9/@redhat.com>
From: Michael Tokarev <mjt@tls.msk.ru>
Message-ID: <aa2aa932-6a80-08be-9501-60d136fb5ea9@msgid.tls.msk.ru>
Date: Fri, 7 May 2021 21:42:16 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
	Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <YJVauS60BjSFkW9/@redhat.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 147IgPUV014651
X-loop: dm-devel@redhat.com
Cc: dm-devel@redhat.com, Zdenek Kabelac <zkabelac@redhat.com>
Subject: Re: [dm-devel] can we fix some dm snapshot crashes please? :)
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
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"

MDcuMDUuMjAyMSAxODoyMCwgTWlrZSBTbml0emVyIHdyb3RlOgo+IE9uIEZyaSwgTWF5IDA3IDIw
MjEgYXQgMTA6MTBQIC0wNDAwLAo+IE1pY2hhZWwgVG9rYXJldiA8bWp0QHRscy5tc2sucnU+IHdy
b3RlOgo+IAo+PiAwNy4wNS4yMDIxIDE1OjMxLCBaZGVuZWsgS2FiZWxhYyB3cm90ZToKPj4+IERu
ZSAwNy4gMDUuIDIxIHYgMTI6MzEgTWljaGFlbCBUb2thcmV2IG5hcHNhbChhKToKPj4gLi4uCj4+
Pj4gIMKgwqBzej0kKGJsb2NrZGV2IC0tZ2V0c2l6ZSAvZGV2L2xvb3AwKQo+Pj4+ICDCoMKgZG1z
ZXR1cCBjcmVhdGUgYmFzZSAtLXRhYmxlICIwICRzeiBzbmFwc2hvdC1vcmlnaW4gL2Rldi9sb29w
MCIKPj4+PiAgwqDCoCMgYW5kIG5vdyB0aGUgY3Jhc2gKPj4+PiAgwqDCoG1rZnMuZXh0NCAvZGV2
L21hcHBlci9iYXNlCj4+Cj4+PiBZZXMgcmVwcm9kdWNpYmxlIC0gY2FuIHlvdSBwbGVhc2Ugb3Bl
biBCWiByZXBvcnQgaGVyZToKPj4+Cj4+PiBodHRwczovL2J1Z3ppbGxhLnJlZGhhdC5jb20vZW50
ZXJfYnVnLmNnaT9wcm9kdWN0PUxWTSUyMGFuZCUyMGRldmljZS1tYXBwZXIKPj4KPj4gT2ssIHdp
bGwgZG8sIHRoYW5rcyEKPiAKPiBUaGFua3MuICBCdXQgd2hlbiB5b3UgZG8sIHBsZWFzZSB0b25l
IGRvd24gdGhlIGxhbWVudGluZyBvZiBob3cgc2xvdwo+IHNuYXBzaG90IGNyYXNoZXMgaGF2ZSBi
ZWVuIGZpeGVkIC0tIG9yIGRvbid0LiAgQnV0IHRoYXQgbGluZSBvZgo+IHJoZXRvcmljIHNob3dz
IHlvdSdyZSBmdWxsIG9mIGl0LgoKVGhhdCdzIGEgam9rZSByZWFsbHkgLSBub3RlIHRoZSBzbWls
ZSBhdCB0aGUgZW5kIG9mIG15IHN0YXRlbWVudC4KCkhvd2V2ZXIgdGhpcyBpcyB0cnVlLCAtIHRo
aXMgcGFydGljdWxhciBjcmFzaCBoYXMgYmVlbiBoZXJlIGZvciBhIGxvbmcgdGltZSwKc29tZW9u
ZSBlbHNlIGFza2VkIGFib3V0IGl0IGVhcmxpZXIgdG9vLCBhbmQgSSBhc2tlZCBhYm91dCBpdCBo
ZXJlIDEuNSB5ZWFycwphZ28gd2hlbiB0cnlpbmcgc25hcHNob3RzIHRoZSBwcmV2aW91cyB0aW1l
IChhY3R1YWxseSB3aGVuIGp1c3QgdHJ5aW5nIHRvCl91bmRlcnN0YW5kXyBob3cgdG8gZG8gaXQg
cHJvcGVybHkpLgoKTm90IHJlYWxseSwgLSBpdCBpcyBqdXN0IGEgam9rZSwgYW5kIEkga25vdyBm
dWxsIHdlbGwgaG93IGl0IGFsbCBpcyBkb25lLgoKLi4KPiBZZXMsIGl0IGlzIGRhbmdlcm91cyB0
byBzdGFiIGluIHRoZSBkYXJrIGxpa2UgeW91IGNsZWFybHkgYXJlIGRvaW5nLgoKSSdkIExPVkUg
dG8ga25vdyBob3cgdG8gZG8gaXQgcHJvcGVybHkuIFVuZm9ydHVuYXRlbHkgSSBmb3VuZCBubwpp
bmZvcm1hdGlvbiBhYm91dCBpdC4gVGhlcmUncyBvbmUgdXNhZ2Ugc2NlbmFyaW8gb3V0bGluZWQg
aW4gYSBmZXcKcGxhY2VzIHdoaWNoIHRhbGtzIGFib3V0IHRoZSB0b3BpYywgYWxsIGFyZSBkb2lu
ZyBpdCBzaW1pbGFyIHRvIGhvdwpMVk0gaXMgZG9pbmcgaXQuIEJ1dCB0aGUgdGhpbmcgaXMgdGhh
dCB0aGVyZSBhcmUgYWN0dWFsbHkgbnVtZXJvdXMKdXNhZ2Ugc2NlbmFyaW9zIGZvciB0aGUgZmVh
dHVyZSwgaXQgZGVmaW5pdGVseSBjYW4gYmUgdXNlZCBudW1lcm91cwp3YXlzLCAtIHRoZSBmZXcg
bWVudGlvbnMgb2YgZG0gc25hcHNob3RzIG9mZmVycyBvbmUgcGFydGljdWxhciBzY2VuYXJpbwpi
dXQgZG9lcyBub3Qgc2hvdyBldmVuIHRoZSBiYXNpYyBydWxlcy4gVGhlcmUncyBhbiBlbWFpbCAo
b24gdGhpcyBsaXN0CklJUkMpIGZyb20gYWJvdXQgYSBkZWNhZGUgYWdvIHdoaWNoIGRlZmluZXMg
YSBzaW1pbGFyIHNjZW5hcmlvIGFuZCB3aGljaCAtCmFwcGFyZW50bHkgLSBpcyB0aGUgb25seSBh
Y3R1YWwgc291cmNlIG9mIGluZm9ybWF0aW9uIGFib3V0IHRoZSB3aG9sZQp0aGluZywgYW5kIGl0
IGFnYWluIGRvZXMgbm90IGRlc2NyaWJlIHRoZSBnYW1lIF9ydWxlc18gOikKCldoYXQgeW91IHNl
ZSBhcyAiSSdtIGZ1bGwgb2YgaXQiIGlzIGEgbGF1Z2ggYWN0dWFsbHkgLSB0aGVyZSdzIG5ldGhl
cgphIGRlZmluZWQgcnVsZXMgKGZvciB3aGljaCBtYW55IHVzZXJzIGFza2VkIGluIHZhcmlvdXMg
cGxhY2VzKSwgYW5kCnRoZXJlIGFyZSBjcmFzaGVzLCBhbmQgZWFjaCB0aW1lIG9uZSBwb2ludHMg
dG8gYSBjcmFzaCBzb21lb25lIHBvaW50cwp0byAieW91J3JlIHVzaW5nIGEgd3JvbmcgcnVsZXMi
LiBXaGljaCB0dXJucyBpbnRvIGEgZGVhZCBjaXJjbGUuLi4gOikKCk15IGFjdHVhbCBpbnRlbnRp
b24gaXMgdHdvLWZvbGQ6IC0gYmVzaWRlcyB0cnlpbmcgdG8gbWFrZSB0aGUgdGhpbmcKbGVzcyBk
YW5nZXJvdXMsIEknZCAqbG92ZSogdG8gbWFrZSBzb21lIG1vcmUgY2xlYXIgZG9jcywgZGVzY3Jp
YmluZwpub3Qgb25seSBvbmUgcGFydGljdWxhciBzY2VuYXJpbyBidXQgdGhlIGFjdHVhbCBydWxl
cywgc28gdG8gc2F5LgoKVGhlcmUncyBhIHNpZ25pZmljYW50IGdhcCBiZXR3ZWVuIGRldmVsb3Bl
cnMgdW5kZXJzdGFuZGluZyBob3cgdGhpcwpsYXllciBhbmQgdGhpcyBwYXJ0aWN1bGFyIGZlYXR1
cmUgb2YgdGhpcyBsYXllciB3b3JrcywgYW5kIHRoZSByZXN0Cm9mIHRoZSB3b3JsZC4gU29tZWhv
dyB0aGlzIGdhcCBzZWVtcyB0byBiZSBhIGJpdCBtb3JlIHNpZ25pZmljYW50CnRoYW4gaXQgaXMg
Zm9yIG1hbnkgb3RoZXIgYXJlYXMgKEknbSBhIChwb3NpdGl2ZSEgOikgKSBzeXNhZG1pbiBhbmQK
c3lzdGVtIGRldmVsb3BlciBmb3IgMjArIHllYXJzIGFuZCBrbm93IGhvdyB0aGluZ3MgYXJlIHdv
cmtpbmcpLgoKSnVzdCB0byBnaXZlIGFuIGV4YW1wbGU6IEkgZm9yIG9uZSB3YXMgcHV6emxlZCBi
eSBkbXNldHVwIHJlbG9hZCAtCndoeSBpdCBpcyBub3QgYWN0dWFsbHkgcmVwbGFjaW5nIHRoZSB0
YWJsZSAqYW5kKiByZXR1cm5pbmcgc3VjY2Vzcz8/Ckkgc3RhcnRlZCBkaWdnaW5nIGludG8ga2Vy
bmVsIHNvdXJjZXMgYW5kIGRvaW5nIHNvbWUgZXhwZXJpbWVudHMsCmFuZCBqdXN0IGJ5IGEgY2hh
bmNlIGRpc2NvdmVyZWQgdGhhdCB0aGUgdGFibGUgKndpbGwqIGJlIHJlcGxhY2VkCmJ5IHRoZSBu
ZXh0ICJkbXNldHVwIHJlc3VtZSIsIC0gZXZlbiBmb3IgYSBub24tc3VzcGVuZGVkIGRldmljZSEK
VGhpcyBtaWdodCBiZSBhbiBvYnZpb3VzIGFzIGFuIGFpciB0aGluZyBmb3IgcGVvcGxlIHdobyBr
bm93IHNvbWUKaW50ZXJuYWxzLCBidXQgaXQgaXMgbm9uLW9idmlvdXMgZXZlbiBmb3Igc29tZSB1
c2VycyBkb2luZyB0aGluZ3MKaW4gdGhpcyBhcmVhIGZvciB5ZWFycy4gSSBhc2tlZCBzZXZlcmFs
IGZyaWVuZHMgb2YgbWluZSB3aG8gd29ya2VkCndpdGggZG1zZXR1cCBhbmQgZGVmaW5pdGVseSBr
bm93cyBpdCAtIG5vLCB0aGV5IG5ldmVyICp0cmllZCogdG8KcmVsb2FkIGEgdGFibGUgd2l0aG91
dCBleHBsaWNpdCBzdXNwZW5kLXJlc3VtZSwgc28gdGhlIG9wZXJhdGlvbgppcyBhbHdheXMgMy1m
b2xkIGluc3RlYWQgb2Ygc2luZ2xlLiAgV2hpbGUgdGhlIGRvY3MgbWVudGlvbnMgaXQKc29tZWhv
dywgb25lIHNob3VsZCBoYXZlIHRoZSBxdWVzdGlvbiBvciBhIGd1ZXNzIHRvIG5vdGljZSBvciB0
bwpmaW5kIHRoaXMgaW4gdGhlIGRvY3MuIEFsc28gdGhlIGRvY3MgbWVudGlvbnMsIGxpa2UsICJz
aG91bGQgYmUKYmUgc3VzcGVuZGVkIG9yIGVsc2Ugc29tZXRoaW5nIGNhbiBnbyB3cm9uZyBpZiB0
aGUgZGV2aWNlIGlzIGluCmFjdGl2ZSB1c2UiIC0gbm90ZSB0aGUgImlmIi4gU28gSSBhc3N1bWVk
IHRoYXQgbm90aGluZyBjYW4gZ28Kd3JvbmcgaWYgdGhlIGRldmljZSBpcyBub3QgaW4gdXNlLiBB
bmQgZmluYWxseSwgbWF5YmUgdGhpcyBpcwpqdXN0IGEgc29tZXdoYXQtdW5lYXNpbHkgZGVzaWdu
ZWQgc29mdHdhcmUgd2hlbiBpdCByZXF1aXJlcyB0aGUKc2FtZSAzIG9wZXJhdGlvbnMgZm9yIGEg
c2luZ2xlIG9wZXJhdGlvbj8KCkJhY2sgdG8gdGhpcyBzbmFwc2hvdC1vcmlnaW4gdGhpbmcsIHRv
IGl0cyAqdXNhZ2UqLiBUaGUgdXN1YWwKZXhhbXBsZSBnaXZlbiBpbiBhIGZldyBwbGFjZXMgc2F5
czoKCiAgMS4gY3JlYXRlIGEgbGluZWFyIDE6MSBtYXBwaW5nIG9mIHRoZSBiYXNlIHZvbHVtZQog
IDIuIG1vdW50IGl0CiAgMy4gY3JlYXRlIGEgY29weSBvZiB0aGUgbWFwcGluZyBmcm9tIHN0ZXAg
MQogIDQuIHN1c3BlbmQgdGhlIG1hcHBpbmcgZnJvbSBzdGVwIDEKICA1LiBjcmVhdGUgc25hcHNo
b3QgZGV2aWNlIG9mIHRoZSBkZXZpY2UgZnJvbSBzdGVwIDMKICA2LiAqcmVwbGFjZSogdGhlIG9y
aWdpbmFsIG1hcHBpbmcgZnJvbSBzdGVwIDEgd2l0aCBzbmFwc2hvdC1vcmlnaW4KICAgICBkZXZp
Y2UgYmFzZWQgb24gdGhlIG1hcHBpbmcgZnJvbSBzdGVwIDMKICA3LiByZXN1bWUgdGhlIHNuYXBz
aG90LW9yaWdpbiBkZXZpY2UKICA4LiB0aGUgcmVzdWx0IGlzIHRoYXQgdGhlIGZpbGVzeXN0ZW0g
bW91bnRlZCBpbiBzdGVwIDIKICAgICBpcyBub3cgYmFzZWQgb24gdGhlIHNuYXBzaG90LW9yaWdp
biBpbnN0ZWFkIG9mIHRoZSBsaW5lYXIgbWFwcGluZy4KCihJIGNhbiBoYXZlIHNvbWV0aGluZyBi
YWNrd2FyZHMgb3Igc2xpZ2h0bHkgd3JvbmcgYnV0IHRoZSBjb25jZXB0CnNob3VsZCBiZSB0aGUg
c2FtZSkuCgpUaGlzIGdpdmVzIHRvbnMgb2YgcXVlc3Rpb25zLiBUaGUgZmlyc3QgcXVlc3Rpb24g
aXMgd2h5IHdlIG5lZWQKdG8gKnJlcGxhY2UqIHRoZSB0YWJsZSBhbmQgd2h5IHdlIG5lZWQgdG8g
bW91bnQgaXQgYmVmb3JlIHJlcGxhY2luZz8KV2h5IGNhbid0IHdlIG1vdW50IChpZiBpdCBuZWVk
cyB0byBiZSBtb3VudGVkKSBzbmFwc2hvdC1vcmlnaW4gZGV2aWNlCihpZiB0aGF0J3MgdGhlIHRo
aW5nIHdoaWNoIGdldHMgbW91bnRlZCBpbiB0aGUgZW5kKSBpbnN0ZWFkIG9mIHVzaW5nCnNuYXBz
aG90LW9yaWdpbiBkaXJlY3RseT8KCi4uLmhtbS4gQWZ0ZXIgcmUtcmVhZGluZyB0aGUgZG9jcyBp
biB0aGUgZ2VudG9vIHdpa2ksIEkgdGhpbmsgSSBzZWUKdGhlIGlzc3VlIGluIG15IChtaXMpdW5k
ZXJzdGFuZGluZywgZXZlbiBpZiBpdCBpcyBub3QgZXhwbGljaXRseSBjbGVhci4KSXQgKm1pZ2h0
KiBiZSB0aGUgc25hcHNob3Qtb3JpZ2luIGlzIG5vdCBhIHNlcGFyYXRlIGRldmljZSB3aGljaCBp
cyB1c2VmdWwKYnkgaXRzIG93biwgYnV0IGlzIGEgInNpZGUtZGV2aWNlIiwgYSAibWFya2VyIiB0
byBkZXRlY3Qgd3JpdGVzIHRvIHRoZQpiYXNlL29yaWdpbiBkZXZpY2UgZm9yIG9uZSBvciBtb3Jl
IHNuYXBzaG90cz8/IEFuZCB0aGUgbW91bnQgc2hvdWxkIGJlCmRvbmUgb2YgdGhlIG9yaWdpbmFs
IGxpbmVhciBtYXBwaW5nIGNyZWF0ZWQgaW4gc3RlcCAxPwoKSWYgdGhhdCdzIHRoZSBjYXNlLCBw
bGVhc2UgY291bnQgbWUgdHdpY2UuLiBiZWNhdXNlIDEuNSB5ZWFycyBhZ28Kd2hlbiBJIHRyaWVk
IHRoaXMgZm9yIHRoZSBmaXJzdCB0aW1lLCBJIG1hZGUgdGhlIHNhbWUgZXhhY3QgbWlzdGFrZS4K
QmVjYXVzZSBpdCBpcyBzdGlsbCB1bmNsZWFyIHRvIG1lIGhvdyBpdCBpcyBhY3R1YWxseSB1c2Vk
Li4uCgpJJ2xsIHRyeSBpdCBhIGJpdCBsYXRlci4uLgoKTWF5YmUgbXkgY29uZnVzaW9uIGlzIG5v
dCBzdWZmaWNpZW50IHRvIHJlZmluZSB0aGUgZG9jcywgSSBkdW5uby4uCkJ1dCB0aGlzIGlzIGFu
IGV4YW1wbGUgb2YgYW4gYXR0ZW1wdGVkIHVzYWdlIGFmdGVyIGFjdHVhbGx5ICp0cnlpbmcqCnRv
IHVuZGVyc3RhbmQgaG93IGl0IHdvcmtzLi4uIHR3aWNlIDopCgpUaGFua3MhCgovbWp0CgoKLS0K
ZG0tZGV2ZWwgbWFpbGluZyBsaXN0CmRtLWRldmVsQHJlZGhhdC5jb20KaHR0cHM6Ly9saXN0bWFu
LnJlZGhhdC5jb20vbWFpbG1hbi9saXN0aW5mby9kbS1kZXZlbA==

