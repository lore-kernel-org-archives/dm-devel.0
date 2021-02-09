Return-Path: <SRS0=bAPj=HL=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87996C433E9
	for <dm-devel@archiver.kernel.org>; Tue,  9 Feb 2021 06:38:46 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 02CB164EB6
	for <dm-devel@archiver.kernel.org>; Tue,  9 Feb 2021 06:38:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 02CB164EB6
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=chinatelecom.cn
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-551--EjqW7X7MbOnvK3ylhFyww-1; Tue, 09 Feb 2021 01:38:40 -0500
X-MC-Unique: -EjqW7X7MbOnvK3ylhFyww-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6CE92106BAAB;
	Tue,  9 Feb 2021 06:38:35 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 3D7E910013D7;
	Tue,  9 Feb 2021 06:38:33 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 578E018095CC;
	Tue,  9 Feb 2021 06:38:31 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1196cTxS005326 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 9 Feb 2021 01:38:29 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 000852166B2A; Tue,  9 Feb 2021 06:38:29 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id EEE062166B27
	for <dm-devel@redhat.com>; Tue,  9 Feb 2021 06:38:26 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C5275801182
	for <dm-devel@redhat.com>; Tue,  9 Feb 2021 06:38:26 +0000 (UTC)
Received: from chinatelecom.cn (prt-mail.chinatelecom.cn [42.123.76.228]) by
	relay.mimecast.com with ESMTP id us-mta-464-rRRFaT8XPdegoxp8tXHUiw-1;
	Tue, 09 Feb 2021 01:38:21 -0500
X-MC-Unique: rRRFaT8XPdegoxp8tXHUiw-1
HMM_SOURCE_IP: 172.18.0.48:15547.568253812
HMM_ATTACHE_NUM: 0000
HMM_SOURCE_TYPE: SMTP
Received: from clientip-202.80.192.21?logid-c4f5b0b5894b455fabac83d7911d760c
	(unknown [172.18.0.48])
	by chinatelecom.cn (HERMES) with SMTP id 748A8280098;
	Tue,  9 Feb 2021 14:38:16 +0800 (CST)
X-189-SAVE-TO-SEND: wucy11@chinatelecom.cn
Received: from  ([172.18.0.48])
	by App0024 with ESMTP id c4f5b0b5894b455fabac83d7911d760c for
	zhangzijian@chinatelecom.cn; Tue Feb  9 14:38:20 2021
X-Transaction-ID: c4f5b0b5894b455fabac83d7911d760c
X-filter-score: filter<0>
X-Real-From: wucy11@chinatelecom.cn
X-Receive-IP: 172.18.0.48
X-MEDUSA-Status: 0
To: Benjamin Marzinski <bmarzins@redhat.com>
References: <4ca7da32-5777-9089-1e96-a5dbb46c585a@chinatelecom.cn>
	<4c7286abbdd79fc0c726fd119fdda3b7a140e056.camel@suse.com>
	<ffb39ebe-ab7e-f82a-f4cb-5b8353bfda2a@chinatelecom.cn>
	<bdeb04efcac09880451505ca2970c6d322c48da5.camel@suse.com>
	<13b96493-5e48-8c56-9e56-b5d42f4a3b07@chinatelecom.cn>
	<20210209045047.GD15006@octiron.msp.redhat.com>
From: Chongyun Wu <wucy11@chinatelecom.cn>
Message-ID: <a316f835-a0a5-0dbb-7ec1-139ccd62181b@chinatelecom.cn>
Date: Tue, 9 Feb 2021 14:38:11 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
	Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210209045047.GD15006@octiron.msp.redhat.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 1196cTxS005326
X-loop: dm-devel@redhat.com
Cc: yubin1@chinatelecom.cn, "dm-devel@redhat.com" <dm-devel@redhat.com>,
	Martin Wilck <mwilck@suse.com>, zhangzijian@chinatelecom.cn
Subject: Re: [dm-devel] [PATCH] multipathd: LUN protection by checking
 path's wwid change status
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"

VGhhbmsgeW91IHZlcnkgbXVjaCBCZW4gYW5kIHlvdXIgcGF0aHNldCBiYXNlZCBvbiBteSBwYXRj
aCBsb29rcyBnb29kLgoKT24gMjAyMS8yLzkgMTI6NTAsIEJlbmphbWluIE1hcnppbnNraSB3cm90
ZToKPiBJJ3ZlIGFjdHVhbGx5IG1hbmFnZWQgdG8gcmVwcm9kdWNlIHRoaXMgaXNzdWUgd2l0aCB0
aGUgbGF0ZXN0IGNvZGUuICBBbGwKPiBpdCB0YWtlcyBpcyB0d28gbWFjaGluZXMgaW4gdGhlIHNh
bWUgRkMgem9uZSwgd2l0aCBvbmUgb2YgdGhlbSBoYXZpbmcgYQo+IEZDIGRyaXZlciB0aGF0IHN1
cHBvcnRzIHRhcmdldCBtb2RlIGFuZCBMSU8uCj4gCj4gVG8gZG8gaXQ6Cj4gWW91IGNhbiBncmFi
IFRHVF9XV1BOIGFuZCBJTklUX1dXUE4gZnJvbQo+IC9zeXMvY2xhc3MvZmNfaG9zdC9ob3N0PG4+
L3BvcnRfbmFtZQo+IAo+IE9uIHRoZSB0YXJnZXQgbWFjaGluZSAoYXNzdW1pbmcgeW91J3JlIHVz
aW5nIHRoZSBxbDJ4eHggbW9kdWxlKQo+IGxvYWQgdGhlIEZDIGRyaXZlciBpbiB0YXJnZXQgbW9k
ZQo+ICMgbW9kcHJvYmUgcWxhMnh4eCBxbGluaV9tb2RlPWRpc2FibGVkCj4gCj4gc3RhcnQgdXAg
dGhlIExJTyB0YXJnZXQuc2VydmljZQo+ICMgc2VydmljZSB0YXJnZXQgc3RhcnQKPiAKPiBjb25m
aWd1cmUgdGhlIHNldHVwIGluIHRhcmdldGNsaQo+ICMgdGFyZ2V0Y2xpCj4gLz4gcWxhMnh4eC8g
Y3JlYXRlIDxUR1RfV1dQTj4KPiAvPiBiYWNrc3RvcmVzL2ZpbGVpbyBjcmVhdGUgZmlsZTEgPEZJ
TEVfMT4gMTAwTQo+IC8+IGJhY2tzdG9yZXMvZmlsZWlvIGNyZWF0ZSBmaWxlMiA8RklMRV8yPiAx
MDBNCj4gLz4gcWxhMnh4eC88VEdUX1dXUE4+L2x1bnMgY3JlYXRlIC9iYWNrc3RvcmVzL2ZpbGVp
by9maWxlMSAxCj4gLz4gcWxhMnh4eC88VEdUX1dXUE4+L2x1bnMgY3JlYXRlIC9iYWNrc3RvcmVz
L2ZpbGVpby9maWxlMiAyCj4gLz4gcWxhMnh4eC88VEdUX1dXUE4+L2FjbHMgY3JlYXRlIDxJTklU
X1dXUE4+Cj4gCj4gT24gdGhlIGhvc3QgbWFjaGluZToKPiBkaXNjb3ZlciB0aGUgTElPIGRldmlj
ZXMgb24gZWFjaCBGQyBob3N0Cj4gIyBlY2hvIDEgPiAvc3lzL2NsYXNzL2ZjX2hvc3QvaG9zdDxO
Pi9pc3N1ZV9saXAKPiAKPiBZb3Ugc2hvdWxkIGhhdmUgdHdvIG11bHRpcGF0aCBkZXZpY2VzIG5v
dwo+IAo+IE9uIHRoZSB0YXJnZXQgbWFjaGluZToKPiBzd2l0Y2ggdGhlIExVTnMKPiAvPiBxbGEy
eHh4LzxUR1RfV1dQTj4vYWNscy88SU5JVF9XV1BOPiBkZWxldGUgMQo+IC8+IHFsYTJ4eHgvPFRH
VF9XV1BOPi9hY2xzLzxJTklUX1dXUE4+IGRlbGV0ZSAyCj4gLz4gcWxhMnh4eC88VEdUX1dXUE4+
L2FjbHMvPElOSVRfV1dQTj4gY3JlYXRlIDIgL2JhY2tzdG9yZXMvZmlsZWlvL2ZpbGUxCj4gLz4g
cWxhMnh4eC88VEdUX1dXUE4+L2FjbHMvPElOSVRfV1dQTj4gY3JlYXRlIDEgL2JhY2tzdG9yZXMv
ZmlsZWlvL2ZpbGUyCj4gCj4gVGhpcyB3aWxsIG9mdGVuIGdlbmVyYXRlIGEgY2hhbmdlIGV2ZW50
LCBidXQgbm90IG9uIGV2ZXJ5IHBhdGgsCj4gbGVhdmluZyBzb21lIHBhdGhzIGFzIHBhcnQgb2Yg
dGhlIHdyb25nIG11bHRpcGF0aCBkZXZpY2UuCj4gCj4gSSdsbCBwb3N0IGEgcGF0Y2hzZXQgYmFz
ZWQgb24gQ2hvbmd5dW4ncyBwYXRjaCBzaG9ydGx5IHRvIGRlYWwgd2l0aAo+IHRoaXMuCj4gCj4g
LUJlbgo+IAo+IE9uIEZyaSwgSmFuIDA4LCAyMDIxIGF0IDExOjEzOjAxQU0gKzA4MDAsIENob25n
eXVuIFd1IHdyb3RlOgo+PiBUaGFua3MgTWFydGluLCBJIHdpbGwgdHJ5IHRvIHJlcHJvZHVjZSB0
aGlzIGlzc3VlIHdpdGggdGhlIGxhdGVzdCB2ZXJzaW9uCj4+IHdoZW4gdGhlIGVudmlyb21lbnRz
IHJlYWR5LCBpZiByZXByb2R1Y2UgaXQgYWdhaW4gSSB3aWxsIGxldCB5b3Uga25vdywKPj4gdGhh
bmtzIGFnYWlufgo+Pgo+PiBPbiAyMDIxLzEvNyAxOToyNywgTWFydGluIFdpbGNrIHdyb3RlOgo+
Pj4gT24gVGh1LCAyMDIxLTAxLTA3IGF0IDEwOjIzICswODAwLCBDaG9uZ3l1biBXdSB3cm90ZToK
Pj4+PiBIZWxsbyBNYXJ0aW4sCj4+Pj4gVGhhbmtzIGZvciB2aWV3IHRoaXMgcGF0Y2guCj4+Pj4K
Pj4+PiBPbiAyMDIxLzEvNyA1OjEwLCBNYXJ0aW4gV2lsY2sgd3JvdGU6Cj4+Pj4+IEhlbGxvIENo
b25neXVuLAo+Pj4+Pgo+Pj4+PiBPbiBNb24sIDIwMjAtMTItMjggYXQgMTE6MzQgKzA4MDAsIENo
b25neXVuIFd1IHdyb3RlOgo+Pj4+Pj4gIMKgwqBGcm9tIDM3Yzc0ODczYWNmYzE1ODdlNzlhNjUw
NGNhM2Q0MmI4ZmEwMGQ0OWUgTW9uIFNlcCAxNwo+Pj4+Pj4gMDA6MDA6MDAKPj4+Pj4+IDIwMDEK
Pj4+Pj4+Cj4+Pj4+PiBGcm9tOiBDaG9uZ3l1biBXdSA8d3VjeTExQGNoaW5hdGVsZWNvbS5jbj4K
Pj4+Pj4+IERhdGU6IE1vbiwgMjEgRGVjIDIwMjAgMDk6NTE6MjAgKzA4MDAKPj4+Pj4+IFN1Ympl
Y3Q6IFtQQVRDSF0gbXVsdGlwYXRoZDogTFVOIGRhdGEgcHJvdGVjdGlvbiBieSBjaGVja2luZwo+
Pj4+Pj4gcGF0aCdzCj4+Pj4+PiB3d2lkCj4+Pj4+PiAgwqDCoMKgY2hhbmdlIHN0YXR1cwo+Pj4+
Pj4KPj4+Pj4+IElzc3VlIGRlc2NyaXB0aW9uOgo+Pj4+Pj4gQSkgRGV2aWNlIHNkYSBhbmQgc2Ri
IGNvcnJlc3BlbmQgdG8gTFVOMSBhbmQgTFVOMiBpbiBzdG9yYWdlCj4+Pj4+PiBiYWNrZW5kCj4+
Pj4+PiBhbmQKPj4+Pj4+IHRoZSB1cHBlciBsYXllciBhcHBsaWNhdGlvbiB1c2VzIHRob3NlIHR3
byBkZXZpY2VzLgo+Pj4+Pj4gQikgRG9pbmcgaWxsZWdhbCBvcGVyYXRpb246IHVubWFwcGluZyBM
VU4xIGFuZCBMVU4yIGluIHN0b3JhZ2UKPj4+Pj4+IGJhY2tlbmQsCj4+Pj4+PiBhbmQgZXhwb3J0
IExVTjIgYW5kIExVTjEgdG8gaG9zdCB3aXRoIGV4Y2hhbmdlZCBhc3NpZ25tZW50Cj4+Pj4+PiBy
ZWxhdGlvbgo+Pj4+Pj4gYmV0d2VlbiBzZGEgYW5kIHNkYi4KPj4+Pj4+IEMpIFRoZSB1cHBlciBs
YXllciBhcHBsaWNhdGlvbiBydW4gZm9yIGEgd2hpbGUgYW5kIGZvdW5kIHRoYXQgdGhlCj4+Pj4+
PiBkYXRhCj4+Pj4+PiBpbiBib3RoIExVTjEgYW5kIExVTjIgaGFzIGJlZW4gY29ycnVwdGVkLgo+
Pj4+Pgo+Pj4+PiBDYW4geW91IHBsZWFzZSBiZSBleHBsaWNpdCBhYm91dCB3aGljaCBtdWx0aXBh
dGgtdG9vbHMgdmVyc2lvbiB5b3UKPj4+Pj4gaGF2ZQo+Pj4+PiB0ZXN0ZWQ/IEkgdGhvdWdodCB3
ZSBoYWQgdGhlIHd3aWQgY2hhbmdlIGlzc3VlcyBjb3ZlcmVkLiBCZW4gYW5kIEkKPj4+Pj4gaGF2
ZQo+Pj4+PiBiZWVuIHB1dHRpbmcgcXVpdGUgc29tZSBlZmZvcnQgaW50byB0aGlzIHJlY2VudGx5
LiBPZiBjb3Vyc2Ugd2UgY2FuCj4+Pj4+IGJlCj4+Pj4+IHdyb25nLCBidXQgSSdkIGxpa2UgdG8g
dW5kZXJzdGFuZCB0aGUgaXNzdWUgZnVsbHkuCj4+Pj4+Cj4+Pj4gVGhlIHRlc3QgdmVyc2lvbiBp
cyAwLjguMy4KPj4+Cj4+PiBBIHRlc3Qgd2l0aCAwLjguNSB3b3VsZCBiZSBpbiBuZWNlc3Nhcnks
IHRoZW4uIFRoZSBJTklUX1JFTU9WRUQgbG9naWMKPj4+IGhhcyBiZWVuIGFkZGVkIGFmdGVyIDAu
OC40Lgo+Pj4+Pgo+Pj4+PiBQbGVhc2UgY29uZmlybSB0aGF0IHlvdSd2ZSBiZWVuIHVzaW5nIHRo
ZSBsYXRlc3QgdmVyc2lvbiBmcm9tCj4+Pj4+IENocmlzdG9waGUncyByZXBvIChvciBiZXR0ZXIg
ZXZlbiwgZnJvbSBteSB1cHN0cmVhbS1xdWV1ZSksIGFuZAo+Pj4+PiBwcm92aWRlCj4+Pj4+IC12
MyBsb2dzIHNob3dpbmcgd2hhdCBnb2VzIHdyb25nLgo+Pj4+IFNvcnJ5IE1hcnRpbiwgSSBoYXZl
bid0IHNhdmUgdGhlIGxvZ3MgYW5kIHRoZSBlbnZpcm9tZW50IGlzCj4+Pj4gdW5hdmFpbGFibGUg
bm93Lgo+Pj4KPj4+IFdlbGwsIHBsZWFzZSByZXBvcnQgYmFjayBpZiB5b3UgY2FuIHJlcHJvZHVj
ZSB0aGUgaXNzdWUgd2l0aCBjdXJyZW50Cj4+PiB1cHN0cmVhbS4KPj4+Cj4+PiBSZWdhcmRzLAo+
Pj4gTWFydGluCj4+Pgo+Pj4KPj4KPj4gLS0gCj4+IEJlc3QgUmVnYXJkLAo+PiBDaG9uZ3l1biBX
dQo+IAoKLS0gCkJlc3QgUmVnYXJkLApDaG9uZ3l1biBXdQoKCi0tCmRtLWRldmVsIG1haWxpbmcg
bGlzdApkbS1kZXZlbEByZWRoYXQuY29tCmh0dHBzOi8vd3d3LnJlZGhhdC5jb20vbWFpbG1hbi9s
aXN0aW5mby9kbS1kZXZlbA==

