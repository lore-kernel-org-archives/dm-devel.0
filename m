Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0B0BBC433F5
	for <dm-devel@archiver.kernel.org>; Mon,  2 May 2022 23:20:59 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-119-9IYsQvbzNJmBI0lKnLAIVg-1; Mon, 02 May 2022 19:20:57 -0400
X-MC-Unique: 9IYsQvbzNJmBI0lKnLAIVg-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D00943801490;
	Mon,  2 May 2022 23:20:53 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 43C6F554EE8;
	Mon,  2 May 2022 23:20:52 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 068031947049;
	Mon,  2 May 2022 23:20:52 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 26C561947042
 for <dm-devel@listman.corp.redhat.com>; Mon,  2 May 2022 23:20:50 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 152A5111E3FF; Mon,  2 May 2022 23:20:50 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 0FCF2111E3FA
 for <dm-devel@redhat.com>; Mon,  2 May 2022 23:20:43 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 32D62833962
 for <dm-devel@redhat.com>; Mon,  2 May 2022 23:20:43 +0000 (UTC)
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au
 [211.29.132.246]) by relay.mimecast.com with ESMTP id
 us-mta-357-rCtUOt5GOUq6SUe-Jfbmfg-1; Mon, 02 May 2022 19:20:40 -0400
X-MC-Unique: rCtUOt5GOUq6SUe-Jfbmfg-1
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au
 [49.181.2.147])
 by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 71A01534701;
 Tue,  3 May 2022 09:20:38 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
 (envelope-from <david@fromorbit.com>)
 id 1nlfLH-007IoG-TM; Tue, 03 May 2022 09:20:35 +1000
Date: Tue, 3 May 2022 09:20:35 +1000
From: Dave Chinner <david@fromorbit.com>
To: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Message-ID: <20220502232035.GE1360180@dread.disaster.area>
References: <CGME20220426101804epcas5p4a0a325d3ce89e868e4924bbdeeba6d15@epcas5p4.samsung.com>
 <20220426101241.30100-1-nj.shetty@samsung.com>
 <6a85e8c8-d9d1-f192-f10d-09052703c99a@opensource.wdc.com>
 <20220427124951.GA9558@test-zns>
 <20220502040951.GC1360180@dread.disaster.area>
 <46e95412-9a79-51f8-3d52-caed4875d41f@opensource.wdc.com>
MIME-Version: 1.0
In-Reply-To: <46e95412-9a79-51f8-3d52-caed4875d41f@opensource.wdc.com>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=e9dl9Yl/ c=1 sm=1 tr=0 ts=62706747
 a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
 a=IkcTkHD0fZMA:10 a=oZkIemNP1mAA:10 a=7-415B0cAAAA:8
 a=kuBEN3JhnRn9nEiEWMwA:9 a=QEXdDO2ut3YA:10 a=biEYGPWJfzWAr4FL6Ov7:22
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
Subject: Re: [dm-devel] [PATCH v4 00/10] Add Copy offload support
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
Cc: linux-scsi@vger.kernel.org, nitheshshetty@gmail.com,
 linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
 linux-block@vger.kernel.org, dm-devel@redhat.com,
 linux-fsdevel@vger.kernel.org, Nitesh Shetty <nj.shetty@samsung.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

T24gTW9uLCBNYXkgMDIsIDIwMjIgYXQgMDk6NTQ6NTVQTSArMDkwMCwgRGFtaWVuIExlIE1vYWwg
d3JvdGU6Cj4gT24gMjAyMi8wNS8wMiAxMzowOSwgRGF2ZSBDaGlubmVyIHdyb3RlOgo+ID4gT24g
V2VkLCBBcHIgMjcsIDIwMjIgYXQgMDY6MTk6NTFQTSArMDUzMCwgTml0ZXNoIFNoZXR0eSB3cm90
ZToKPiA+PiBPIFdlZCwgQXByIDI3LCAyMDIyIGF0IDExOjE5OjQ4QU0gKzA5MDAsIERhbWllbiBM
ZSBNb2FsIHdyb3RlOgo+ID4+PiBPbiA0LzI2LzIyIDE5OjEyLCBOaXRlc2ggU2hldHR5IHdyb3Rl
Ogo+ID4+Pj4gVGhlIHBhdGNoIHNlcmllcyBjb3ZlcnMgdGhlIHBvaW50cyBkaXNjdXNzZWQgaW4g
Tm92ZW1iZXIgMjAyMSB2aXJ0dWFsIGNhbGwKPiA+Pj4+IFtMU0YvTU0vQkZQIFRPUElDXSBTdG9y
YWdlOiBDb3B5IE9mZmxvYWRbMF0uCj4gPj4+PiBXZSBoYXZlIGNvdmVyZWQgdGhlIEluaXRpYWwg
YWdyZWVkIHJlcXVpcmVtZW50cyBpbiB0aGlzIHBhdGNoc2V0Lgo+ID4+Pj4gUGF0Y2hzZXQgYm9y
cm93cyBNaWt1bGFzJ3MgdG9rZW4gYmFzZWQgYXBwcm9hY2ggZm9yIDIgYmRldgo+ID4+Pj4gaW1w
bGVtZW50YXRpb24uCj4gPj4+Pgo+ID4+Pj4gT3ZlcmFsbCBzZXJpZXMgc3VwcG9ydHMg4oCTCj4g
Pj4+Pgo+ID4+Pj4gMS4gRHJpdmVyCj4gPj4+PiAtIE5WTWUgQ29weSBjb21tYW5kIChzaW5nbGUg
TlMpLCBpbmNsdWRpbmcgc3VwcG9ydCBpbiBudm1lLXRhcmdldCAoZm9yCj4gPj4+PiAgICAgYmxv
Y2sgYW5kIGZpbGUgYmFja2VuZCkKPiA+Pj4KPiA+Pj4gSXQgd291bGQgYWxzbyBiZSBuaWNlIHRv
IGhhdmUgY29weSBvZmZsb2FkIGVtdWxhdGlvbiBpbiBudWxsX2JsayBmb3IgdGVzdGluZy4KPiA+
Pj4KPiA+Pgo+ID4+IFdlIGNhbiBwbGFuIHRoaXMgaW4gbmV4dCBwaGFzZSBvZiBjb3B5IHN1cHBv
cnQsIG9uY2UgdGhpcyBzZXJpZXMgc2V0dGxlcyBkb3duLgo+ID4gCj4gPiBXaHkgbm90IGp1c3Qg
aG9vayB0aGUgbG9vcGJhY2sgZHJpdmVyIHVwIHRvIGNvcHlfZmlsZV9yYW5nZSgpIHNvCj4gPiB0
aGF0IHRoZSBiYWNrZW5kIGZpbGVzeXN0ZW0gY2FuIGp1c3QgcmVmbGluayBjb3B5IHRoZSByYW5n
ZXMgYmVpbmcKPiA+IHBhc3NlZD8gVGhhdCB3b3VsZCBlbmFibGUgdGVzdGluZyBvbiBidHJmcywg
WEZTIGFuZCBORlN2NC4yIGhvc3RlZAo+ID4gaW1hZ2UgZmlsZXMgd2l0aG91dCBuZWVkaW5nIGFu
eSBzcGVjaWFsIGJsb2NrIGRldmljZSBzZXR1cCBhdCBhbGwuLi4KPiAKPiBUaGF0IGlzIGEgdmVy
eSBnb29kIGlkZWEgISBCdXQgdGhhdCB3aWxsIGNvdmVyIG9ubHkgdGhlIG5vbi16b25lZCBjYXNl
LiBGb3IgY29weQo+IG9mZmxvYWQgb24gem9uZWQgZGV2aWNlcywgYWRkaW5nIHN1cHBvcnQgaW4g
bnVsbF9ibGsgaXMgcHJvYmFibHkgdGhlIHNpbXBsZXN0Cj4gdGhpbmcgdG8gZG8uCgpTdXJlLCBi
dXQgdGhhdCdzIGEgem9uZSBkZXZpY2UgaW1wbGVtZW50YXRpb24gaXNzdWUsIG5vdCBhICJob3cg
ZG8KYXBwbGljYXRpb25zIHVzZSB0aGlzIG9mZmxvYWQiIGlzc3VlLgoKaS5lLiB6b25lZnMgc3Vw
cG9ydCBpcyBub3QgbmVjZXNzYXJ5IHRvIHRlc3QgdGhlIGJpby9ibG9jayBsYXllcgppbnRlcmZh
Y2VzIGF0IGFsbC4gQWxsIHdlIG5lZWQgaXMgYSBibG9jayBkZXZpY2UgdGhhdCBjYW4gZGVjb2Rl
IHRoZQpiaW8tZW5jb2RlZCBvZmZsb2FkIHBhY2tldCBhbmQgZXhlY3V0ZSBpdCB0byBkbyBmdWxs
IGJsb2NrIGxheWVyCnRlc3RpbmcuIFdlIGNhbiBidWlsZCBkbSBkZXZpY2VzIG9uIHRvcCBvZiBs
b29wIGRldmljZXMsIGV0Yywgc28gd2UKY2FuIHRlc3QgdGhhdCB0aGUgb2ZsbG9hZCBzdXBwb3J0
IGlzIHBsdW1iZWQsIHNsaWNlZCwgZGljZWQsIGFuZApyZWd1cmdpdGF0ZWQgY29ycmVjdGx5IHRo
YXQgd2F5LiBXZSBkb24ndCBuZWVkIGFjdHVhbCBsb3cgbGV2ZWwKZGV2aWNlIGRyaXZlcnMgdG8g
dGVzdCB0aGlzLgoKQW5kLCB1bmxpa2UgdGhlIG51bGxibGsgZGV2aWNlLCB1c2luZyB0aGUgbG9v
cGJhY2sgZGV2aWNlIHcvCmNvcHlfZmlsZV9yYW5nZSgpIHdpbGwgYWxzbyBhbGxvdyBkYXRhIGlu
dGVncml0eSB0ZXN0aW5nIGlmIGEKZ2VuZXJpYyBjb3B5X2ZpbGVfcmFuZ2UoKSBvZmZsb2FkIGlt
cGxlbWVudGF0aW9uIGlzIGFkZGVkLiBUaGF0IGlzLAp3ZSB0ZXN0IGEgbm9uLXJlZmxpbmsgY2Fw
YWJsZSBmaWxlc3lzdGVtIG9uIHRoZSBsb29wIGRldmljZSB3aXRoIHRoZQppbWFnZSBmaWxlIGhv
c3RlZCBvbiBhIHJlZmxpbmstY2FwYWJsZSBmaWxlc3lzdGVtLiBUaGUgdXBwZXIKZmlsZXN5c3Rl
bSBjb3B5IHRoZW4gZ2V0cyBvZmZsb2FkZWQgdG8gcmVmbGlua3MgaW4gdGhlIGxvd2VyCmZpbGVz
eXN0ZW0uIFdlIGFscmVhZHkgaGF2ZSBjb3B5X2ZpbGVfcmFuZ2UoKSBzdXBwb3J0IGluIGZzeCwg
c28gYWxsCnRoZSBkYXRhIGludGVncml0eSBmc3ggdGVzdHMgaW4gZnN0ZXN0cyB3aWxsIGV4ZXJj
aXNlIHRoaXMgb2ZmbG9hZApwYXRoIGFuZCBmaW5kIGFsbCB0aGUgZGF0YSBjb3JydXB0aW9ucyB0
aGUgaW5pdGlhbCBibG9jayBsYXllciBidWdzCmV4cG9zZS4uLgoKRnVydGhlciwgZnNzdHJlc3Mg
YWxzbyBoYXMgY29weV9maWxlX3JhbmdlKCkgc3VwcG9ydCwgYW5kIHNvIGFsbCB0aGUKZnN0ZXN0
cyB0aGF0IGdlbmVyYXRlIHN0cmVzcyB0ZXN0cyBvciB1c2UgZnN0cmVzcyBhcyBsb2FkIGZvcgpm
YWlsdXJlIHRlc3Rpbmcgd2lsbCBhbHNvIGV4ZXJjaXNlIGl0LgoKSW5kZWVkLCB0aGlzIHRoZW4g
Z2l2ZXMgdXMgZmluZS1ncmFpbmVkIGVycm9yIGluamVjdGlvbiBjYXBhYmlsaXR5CndpdGhpbiBm
c3Rlc3RzIHZpYSBkZXZpY2VzIGxpa2UgZG0tZmxha2V5LiBXaGF0IGhhcHBlbnMgd2hlbgpkbS1m
bGFrZXkga2lsbHMgdGhlIGRldmljZSBJTyBtaWQtb2ZmbG9hZD8gRG9lcyBldmVyeXRoaW5nIHJl
Y292ZXIKY29ycmVjdGx5PyBEbyB3ZSBlbmQgdXAgd2l0aCBkYXRhIGNvcnJ1cHRpb24/IEFyZSBw
YXJ0aWFsIG9mZmxvYWQKY29tcGxldGlvbnMgd2hlbiBlcnJvcnMgb2NjdXIgc2lnbmFsbGVkIGNv
cnJlY3RseT8gSXMgdGhlcmUgLWFueS0KdGVzdCBjb3ZlcmFnZSAob3IgZXZlbiBjYXBhYmlsaXR5
IGZvciB0ZXN0aW5nKSBvZiB1c2VyIGRyaXZlbiBjb3B5Cm9mZmxvYWQgZmFpbHVyZSBzaXR1YXRp
b25zIGxpa2UgdGhpcyBpbiBhbnkgb2YgdGhlIG90aGVyIHRlc3QKc3VpdGVzPwoKSSBtZWFuLCBv
bmNlIHRoZSBsb29wIGRldmljZSBoYXMgY2ZyIG9mZmxvYWQsIHdlIGNhbiB1c2UgZG0tZmxha2V5
CnRvIGtpbGwgSU8gaW4gdGhlIGltYWdlIGZpbGUgb3IgZXZlbiBkbyBhIGZvcmNlIHNodXRkb3du
IG9mIHRoZQppbWFnZSBob3N0IGZpbGVzeXN0ZW0uIEhlbmNlIHdlIGNhbiBhY3R1YWxseSB0cmFz
aCB0aGUgY29weSBvZmZsb2FkCm9wZXJhdGlvbiBpbiBtaWQtZmxpZ2h0LCBub3QganVzdCBlcnJv
ciBpdCBvdXQgb24gZnVsbCBjb21wbGV0aW9uLgpUaGlzIGlzIHRyaXZpYWwgdG8gZG8gd2l0aCB0
aGUgZnN0ZXN0cyBpbmZyYXN0cnVjdHVyZSAtIGl0IGp1c3QKcmVsaWVzIG9uIGhhdmluZyBnZW5l
cmljIGNvcHlfZmlsZV9yYW5nZSgpIGJsb2NrIG9mZmxvYWQgc3VwcG9ydCBhbmQKYSBsb29wYmFj
ayBkZXZpY2Ugb2ZmbG9hZCBvZiBoYXJkd2FyZSBjb3B5IGJpb3MgYmFjayB0bwpjb3B5X2ZpbGVf
cmFuZ2UoKS4uLi4KClRoaXMgaXMgd2hhdCBJIG1lYW4gYWJvdXQgY29weSBvZmZsb2FkIGJlaW5n
IGRlc2lnbmVkIHRoZSB3cm9uZyB3YXkuCldlIGhhdmUgdGhlIGhpZ2ggbGV2ZWwgaG9va3MgbmVl
ZGVkIHRvIGltcGxlbWVudCBpdCByaWdodCB0aG91Z2ggdGhlCmZpbGVzeXN0ZW1zIGFuZCBibG9j
ayBsYXllciB3aXRob3V0IGFueSBzcGVjaWZpYyBoYXJkd2FyZSBzdXBwb3J0LAphbmQgd2UgY2Fu
IHRlc3QgdGhlIHdob2xlIHN0YWNrIHdpdGhvdXQgbmVlZGluZyBzcGVjaWZpYyBoYXJkd2FyZQpz
dXBwb3J0LiBXZSBhbHJlYWR5IGhhdmUgZmlsZXN5c3RlbSBsZXZlbCBjb3B5IG9mZmxvYWQgYWNj
ZWxlcmF0aW9uLApzbyB0aGUgbGFzdCB0aGluZyB3ZSB3YW50IHRvIHNlZSBpcyBhIGJsb2NrIGxh
eWVyIG9mZmxvYWQKaW1wbGVtZW50YXRpb24gdGhhdCBpcyBpbmNvbXBhdGlibGUgd2l0aCB0aGUg
c2VtYW50aWNzIHdlJ3ZlIGFscmVhZHkKZXhwb3NlZCB0byB1c2Vyc3BhY2UgZm9yIGNvcHkgb2Zm
bG9hZHMuCgpBcyBJIHNhaWQ6Cgo+ID4gaS5lLiBJIHRoaW5rIHlvdSdyZSBkb2luZyB0aGlzIGNv
bXBlbHRlbHkgYmFja3dhcmRzIGJ5IHRyeWluZyB0bwo+ID4gdGFyZ2V0IG5vbi1leGlzdGVudCBo
YXJkd2FyZSBmaXJzdC4uLi4KClJhdGhlciB0aGFuIHRpZSB0aGUgYmxvY2sgbGF5ZXIgb2ZmbG9h
ZCBmdW5jdGlvbi9pbXBsZW1lbnRhdGlvbiB0bwp0aGUgc3BlY2lmaWMgcXVpcmtzIG9mIGEgc3Bl
Y2lmaWMgdGFyZ2V0IGhhcmR3YXJlLCB3ZSBzaG91bGQgYmUKYWRkaW5nIGdlbmVyaWMgc3VwcG9y
dCBpbiB0aGUgYmxvY2sgbGF5ZXIgZm9yIHRoZSBjb3B5IG9mZmxvYWQKc2VtYW50aWNzIHdlJ3Zl
IGFscmVhZHkgZXhwb3NlZCB0byB1c2Vyc3BhY2UuIFdlIGFscmVhZHkgaGF2ZSB0ZXN0CmNvdmVy
YWdlIGFuZCBpbmZyYXN0cnVjdHVyZSBmb3IgdGhpcyBpbnRlcmZhY2UgYW5kIGlzIGFscmVhZHkg
aW4gdXNlCmJ5IGFwcGxpY2F0aW9ucy4KClRyYW5zcGFyZW50IGhhcmR3YXJlIGFjY2VsZXJhdGlv
biBvZiBkYXRhIGNvcGllcyB3aGVuIHRoZSBoYXJkd2FyZQpzdXBwb3J0cyBpdCBpcyBleGFjdGx5
IHdoZXJlIGNvcHkgb2ZmbG9hZHMgYXJlIHVzZWZ1bCAtIGltcGxlbWVudGluZwpzdXBwb3J0IGJh
c2VkIGFyb3VuZCBoYXJkd2FyZSBtYWRlIG9mIHVub2J0YWluaXVtIGFuZCB0aGVuIGFkZGluZwpo
aWdoIGxldmVsIHVzZXIgZmFjaW5nIEFQSSBzdXBwb3J0IGFzIGFuIGFmdGVydGhvdWdodCBpcyBw
dXR0aW5nIHRoZQpjYXJ0IGJlZm9yZSB0aGUgaG9yc2UuIFdlIG5lZWQgdG8gbWFrZSBzdXJlIHRo
ZSBoaWdoIGxldmVsCmZ1bmN0aW9uYWxpdHkgaXMgcm9idXN0IGFuZCBoYW5kbGVzIGVycm9ycyBj
b3JyZWN0bHkgYmVmb3JlIHdlIGV2ZW4Kd29ycnkgYWJvdXQgd2hhdCBxdWlya3MgdGhlIGhhcmR3
YXJlIG1pZ2h0IGJyaW5nIHRvIHRoZSB0YWJsZS4KCkJ1aWxkIGEgcmVmZXJlbmNlIG1vZGVsIGZp
cnN0IHdpdGggdGhlIGxvb3AgZGV2aWNlIGFuZApjb3B5LWZpbGUtcmFuZ2UsIHRlc3QgaXQsIHZh
bGlkYXRlIGl0LCBtYWtlIHN1cmUgaXQgYWxsIHdvcmtzLiBUaGVuCmhvb2sgdXAgdGhlIGhhcmR3
YXJlLCBhbmQgZml4IGFsbCB0aGUgaGFyZHdhcmUgYnVncyB0aGF0IGFyZSBleHBvc2VkCmJlZm9y
ZSB0aGUgaGFyZHdhcmUgaXMgcmVsZWFzZWQgdG8gdGhlIGdlbmVyYWwgcHVibGljLi4uLgoKV2h5
IGhhdmVuJ3Qgd2UgbGVhcm50IHRoaXMgbGVzc29uIHlldCBmcm9tIGFsbCB0aGUgcHJvYmxlbXMg
d2UndmUKaGFkIHdpdGgsIHNheSwgYnJva2VuIGRpc2NhcmQvdHJpbSwgemVyb2luZywgZXJhc2Us
IGV0YyBpbiBoYXJkd2FyZQppbXBsZW1lbnRhdGlvbnMsIGluY29tcGF0aWJsZSBoYXJkd2FyZSBw
cm90b2NvbCBpbXBsZW1lbnRhdGlvbnMgb2YKZXF1aXZhbGVudCBmdW5jdGlvbmFsaXR5LCBldGM/
IGkuZS4gV2UgaGF2ZW4ndCBkZWZpbmVkIHRoZSBPUwpyZXF1aXJlZCBiZWhhdmlvdXIgdGhhdCBo
YXJkd2FyZSBtdXN0IHN1cHBvcnQgYW5kIGluc3RlYWQganVzdCB0cmllZAp0byBtYWtlIHdoYXRl
dmVyIGhhcyBjb21lIGZyb20gdGhlIGhhcmR3YXJlIHZlbmRvcidzCiJzdGFuZGFyaXNhdGlvbiIg
cHJvY2VzcyB3b3JrIG9rPwoKSW4gdGhpcyBjYXNlLCB3ZSBhbHJlYWR5IGhhdmUgYSBmdW5jdGlv
bmluZyBtb2RlbCwgc3lzY2FsbHMgYW5kIHVzZXIKYXBwbGljYXRpb25zIG1ha2luZyB1c2Ugb2Yg
Y29weSBvZmZsb2FkcyBhdCB0aGUgT1MgbGV2ZWwuIE5vdyB3ZQpuZWVkIHRvIGltcGxlbWVudCB0
aG9zZSBleGFjdCBzZW1hbnRpY3MgYXQgdGhlIGJsb2NrIGxheWVyIHRvIGJ1aWxkCmEgdmFsaWRh
dGVkIHJlZmVyZW5jZSBtb2RlbCBmb3IgdGhlIGJsb2NrIGxheWVyIG9mZmxvYWQgYmVoYXZpb3Vy
CnRoYXQgaGFyZHdhcmUgbXVzdCBjb21wbHkgd2l0aC4gVGhlbiBoYXJkd2FyZSBvZmZsb2FkcyBp
biBhY3R1YWwKaGFyZHdhcmUgY2FuIGJlIGNvbXBhcmVkIGFuZCB2YWxpZGF0ZWQgYWdhaW5zdCB0
aGUgcmVmZXJlbmNlIG1vZGVsCmJlaGF2aW91ciwgYW5kIGFueSBoYXJkd2FyZSB0aGF0IGRvZXNu
J3QgbWF0Y2ggY2FuIGJlCnF1aXJrZWQvYmxhY2tsaXN0ZWQgdW50aWwgdGhlIG1hbnVmYWN0dXJl
ciBmaXhlcyB0aGVpciBmaXJtd2FyZS4uLgoKQ2hlZXJzLAoKRGF2ZS4KLS0gCkRhdmUgQ2hpbm5l
cgpkYXZpZEBmcm9tb3JiaXQuY29tCgotLQpkbS1kZXZlbCBtYWlsaW5nIGxpc3QKZG0tZGV2ZWxA
cmVkaGF0LmNvbQpodHRwczovL2xpc3RtYW4ucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2Rt
LWRldmVsCg==

