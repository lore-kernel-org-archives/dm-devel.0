Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6B868C4321E
	for <dm-devel@archiver.kernel.org>; Wed,  2 Nov 2022 00:45:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1667349925;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=19t1LGR5BSY6Uz+hMt4TV18sBd+uanqA5i5b3iTvZUA=;
	b=NuERAlHBiOPp4aINUlYte3YFC0EZtqcwcbBsEExJh0TxIqqPijmKLo+/AwmmY+I3WPplKi
	42WxcLEU0BSWJ10UA7p5nmIRrW6qWixoBUbFGawYyrJVHj/q1n8wKpKjqISL6MgJfg9LqV
	MlLWc30Sjb5yS5AXr+fMcMtJqS7zjJQ=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-672-akO66GsHPoyMqiKY6HiZYw-1; Tue, 01 Nov 2022 20:45:22 -0400
X-MC-Unique: akO66GsHPoyMqiKY6HiZYw-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 66C033811F2A;
	Wed,  2 Nov 2022 00:45:20 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 4FFAF492B18;
	Wed,  2 Nov 2022 00:45:16 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 1ABAD1946A42;
	Wed,  2 Nov 2022 00:45:16 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 7160419465B3
 for <dm-devel@listman.corp.redhat.com>; Wed,  2 Nov 2022 00:45:15 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 3B9E02024CBB; Wed,  2 Nov 2022 00:45:15 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 32E072028DC1
 for <dm-devel@redhat.com>; Wed,  2 Nov 2022 00:45:15 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DDB8485A5A6
 for <dm-devel@redhat.com>; Wed,  2 Nov 2022 00:45:14 +0000 (UTC)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-426-49VhTqjpOrOR-3XFWMG37w-1; Tue, 01 Nov 2022 20:45:10 -0400
X-MC-Unique: 49VhTqjpOrOR-3XFWMG37w-1
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id 3109CB8203A;
 Wed,  2 Nov 2022 00:45:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3F6DC433C1;
 Wed,  2 Nov 2022 00:45:07 +0000 (UTC)
Date: Tue, 1 Nov 2022 17:45:07 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Shiyang Ruan <ruansy.fnst@fujitsu.com>
Message-ID: <Y2G9k9/XJVQ7yiWN@magnolia>
References: <6a83a56e-addc-f3c4-2357-9589a49bf582@fujitsu.com>
 <Y1NRNtToQTjs0Dbd@magnolia>
 <20221023220018.GX3600936@dread.disaster.area>
 <OSBPR01MB2920CA997DDE891C06776279F42E9@OSBPR01MB2920.jpnprd01.prod.outlook.com>
 <20221024053109.GY3600936@dread.disaster.area>
 <dd00529c-d3ef-40e3-9dea-834c5203e3df@fujitsu.com>
 <Y1gjQ4wNZr3ve2+K@magnolia> <Y1rzZN0wgLcie47z@magnolia>
 <635b325d25889_6be129446@dwillia2-xfh.jf.intel.com.notmuch>
 <7a3aac47-1492-a3cc-c53a-53c908f4f857@fujitsu.com>
MIME-Version: 1.0
In-Reply-To: <7a3aac47-1492-a3cc-c53a-53c908f4f857@fujitsu.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
Subject: Re: [dm-devel] [PATCH] xfs: fail dax mount if reflink is enabled on
 a partition
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
Cc: "hch@infradead.org" <hch@infradead.org>, Theodore Ts'o <tytso@mit.edu>,
 "toshi.kani@hpe.com" <toshi.kani@hpe.com>,
 "dm-devel@redhat.com" <dm-devel@redhat.com>,
 "nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>,
 Brian Foster <bfoster@redhat.com>,
 "yangx.jy@fujitsu.com" <yangx.jy@fujitsu.com>,
 Dave Chinner <david@fromorbit.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "Yasunori Gotou \(Fujitsu\)" <y-goto@fujitsu.com>,
 Jeff Moyer <jmoyer@redhat.com>, "zwisler@kernel.org" <zwisler@kernel.org>,
 "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
 Dan Williams <dan.j.williams@intel.com>,
 "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

T24gU3VuLCBPY3QgMzAsIDIwMjIgYXQgMDU6MzE6NDNQTSArMDgwMCwgU2hpeWFuZyBSdWFuIHdy
b3RlOgo+IAo+IAo+IOWcqCAyMDIyLzEwLzI4IDk6MzcsIERhbiBXaWxsaWFtcyDlhpnpgZM6Cj4g
PiBEYXJyaWNrIEouIFdvbmcgd3JvdGU6Cj4gPiA+IFthZGQgdHl0c28gdG8gY2Mgc2luY2UgaGUg
YXNrZWQgYWJvdXQgIkhvdyBkbyB5b3UgYWN0dWFsbHkgL2dldC8gZnNkYXgKPiA+ID4gbW9kZSB0
aGVzZSBkYXlzPyIgdGhpcyBtb3JuaW5nXQo+ID4gPiAKPiA+ID4gT24gVHVlLCBPY3QgMjUsIDIw
MjIgYXQgMTA6NTY6MTlBTSAtMDcwMCwgRGFycmljayBKLiBXb25nIHdyb3RlOgo+ID4gPiA+IE9u
IFR1ZSwgT2N0IDI1LCAyMDIyIGF0IDAyOjI2OjUwUE0gKzAwMDAsIHJ1YW5zeS5mbnN0QGZ1aml0
c3UuY29tIHdyb3RlOgo+IAo+IC4uLnNraXAuLi4KPiAKPiA+ID4gPiAKPiA+ID4gPiBOb3BlLiAg
U2luY2UgdGhlIGFubm91bmNlbWVudCBvZiBwbWVtIGFzIGEgcHJvZHVjdCwgSSBoYXZlIGhhZCAx
NQo+ID4gPiA+IG1pbnV0ZXMgb2YgYWNjZXMgdG8gb25lIHByZXByb2R1Y3Rpb24gcHJvdG90eXBl
IHNlcnZlciB3aXRoIGFjdHVhbAo+ID4gPiA+IG9wdGFuZSBESU1NcyBpbiB0aGVtLgo+ID4gPiA+
IAo+ID4gPiA+IEkgaGF2ZSAvbmV2ZXIvIGhhZCBhY2Nlc3MgdG8gcmVhbCBoYXJkd2FyZSB0byB0
ZXN0IGFueSBvZiB0aGlzLCBzbyBpdCdzCj4gPiA+ID4gYWxsIGNvbmZpZ3VyZWQgdmlhIGxpYnZp
cnQgdG8gc2ltdWxhdGUgcG1lbSBpbiBxZW11Ogo+ID4gPiA+IGh0dHBzOi8vbG9yZS5rZXJuZWwu
b3JnL2xpbnV4LXhmcy9ZelhzYXZPV01TdXdUQkVDQG1hZ25vbGlhLwo+ID4gPiA+IAo+ID4gPiA+
IC9ydW4vbXRyZGlzay9bZ2hdLm1lbSBhcmUgYm90aCByZWd1bGFyIGZpbGVzIG9uIGEgdG1wZnMg
ZmlsZXN5c3RlbToKPiA+ID4gPiAKPiA+ID4gPiAkIGdyZXAgbXRyZGlzayAvcHJvYy9tb3VudHMK
PiA+ID4gPiBub25lIC9ydW4vbXRyZGlzayB0bXBmcyBydyxyZWxhdGltZSxzaXplPTgyODk0ODQ4
ayxpbm9kZTY0IDAgMAo+ID4gPiA+IAo+ID4gPiA+ICQgbHMgLWxhIC9ydW4vbXRyZGlzay9bZ2hd
Lm1lbQo+ID4gPiA+IC1ydy1yLS1yLS0gMSBsaWJ2aXJ0LXFlbXUga3ZtIDEwNzM5NTE1MzkyIE9j
dCAyNCAxODowOSAvcnVuL210cmRpc2svZy5tZW0KPiA+ID4gPiAtcnctci0tci0tIDEgbGlidmly
dC1xZW11IGt2bSAxMDczOTUxNTM5MiBPY3QgMjQgMTk6MjggL3J1bi9tdHJkaXNrL2gubWVtCj4g
PiA+IAo+ID4gPiBBbHNvIGZvcmdvdCB0byBtZW50aW9uIHRoYXQgdGhlIFZNIHdpdGggdGhlIGZh
a2UgcG1lbSBhdHRhY2hlZCBoYXMgYQo+ID4gPiBzY3JpcHQgdG8gZG86Cj4gPiA+IAo+ID4gPiBu
ZGN0bCBjcmVhdGUtbmFtZXNwYWNlIC0tbW9kZSBmc2RheCAtLW1hcCBkZXYgLWUgbmFtZXNwYWNl
MC4wIC1mCj4gPiA+IG5kY3RsIGNyZWF0ZS1uYW1lc3BhY2UgLS1tb2RlIGZzZGF4IC0tbWFwIGRl
diAtZSBuYW1lc3BhY2UxLjAgLWYKPiA+ID4gCj4gPiA+IEV2ZXJ5IHRpbWUgdGhlIHBtZW0gZGV2
aWNlIGdldHMgcmVjcmVhdGVkLCBiZWNhdXNlIGFwcGFyZW50bHkgdGhhdCdzIHRoZQo+ID4gPiBv
bmx5IHdheSB0byBnZXQgU19EQVggbW9kZSBub3dhZGF5cz8KPiA+IAo+ID4gSWYgeW91IGhhdmUg
bm90aWNlZCBhIGNoYW5nZSBoZXJlIGl0IGlzIGR1ZSB0byBWTSBjb25maWd1cmF0aW9uIG5vdAo+
ID4gYW55dGhpbmcgaW4gdGhlIGRyaXZlci4KPiA+IAo+ID4gSWYgeW91IGFyZSBpbnRlcmVzdGVk
IHRoZXJlIGFyZSB0d28gd2F5cyB0byBnZXQgcG1lbSBkZWNsYXJlZCB0aGUgbGVnYWN5Cj4gPiB3
YXkgdGhhdCBwcmVkYXRlcyBhbnkgb2YgdGhlIERBWCB3b3JrLCB0aGUga2VybmVsIGNhbGxzIGl0
IEU4MjBfUFJBTSwKPiA+IGFuZCB0aGUgbW9kZXJuIHdheSBieSBwbGF0Zm9ybSBmaXJtd2FyZSB0
YWJsZXMgbGlrZSBBQ1BJIE5GSVQuIFRoZQo+ID4gYXNzdW1wdGlvbiB3aXRoIEU4MjBfUFJBTSBp
cyB0aGF0IGl0IGlzIGRlYWxpbmcgd2l0aCBiYXR0ZXJ5IGJhY2tlZAo+ID4gTlZESU1NcyBvZiBz
bWFsbCBjYXBhY2l0eS4gSW4gdGhhdCBjYXNlIHRoZSAvZGV2L3BtZW0gZGV2aWNlIGNhbiBzdXBw
b3J0Cj4gPiBEQVggb3BlcmF0aW9uIGJ5IGRlZmF1bHQgYmVjYXVzZSB0aGUgbmVjZXNzYXJ5IG1l
bW9yeSBmb3IgdGhlICdzdHJ1Y3QKPiA+IHBhZ2UnIGFycmF5IGZvciB0aGF0IG1lbW9yeSBpcyBs
aWtlbHkgc21hbGwuCj4gPiAKPiA+IFBsYXRmb3JtIGZpcm13YXJlIGRlZmluZWQgUE1FTSBjYW4g
YmUgdGVyYWJ5dGVzLiBTbyB0aGUgZHJpdmVyIGRvZXMgbm90Cj4gPiBlbmFibGUgREFYIGJ5IGRl
ZmF1bHQgYmVjYXVzZSB0aGUgdXNlciBuZWVkcyB0byBtYWtlIHBvbGljeSBjaG9pY2UgYWJvdXQK
PiA+IGJ1cm5pbmcgZ2lnYWJ5dGVzIG9mIERSQU0gZm9yIHRoYXQgbWV0YWRhdGEsIG9yIHBsYWNp
bmcgaXQgaW4gUE1FTSB3aGljaAo+ID4gaXMgYWJ1bmRhbnQsIGJ1dCBzbG93ZXIuIFNvIHdoYXQg
SSBzdXNwZWN0IG1pZ2h0IGJlIGhhcHBlbmluZyBpcyB5b3VyCj4gPiBjb25maWd1cmF0aW9uIGNo
YW5nZWQgZnJvbSBzb21ldGhpbmcgdGhhdCBhdXRvLWFsbG9jYXRlZCB0aGUgJ3N0cnVjdAo+ID4g
cGFnZScgYXJyYXksIHRvIHNvbWV0aGluZyB0aGF0IG5lZWRlZCB0aG9zZSBjb21tYW5kcyB5b3Ug
bGlzdCBhYm92ZSB0bwo+ID4gZXhwbGljaXRseSBvcHQtaW4gdG8gcmVzZXJ2aW5nIHNvbWUgUE1F
TSBjYXBhY2l0eSBmb3IgdGhlIHBhZ2UgbWV0YWRhdGEuCj4gCj4gSSBhbSB1c2luZyB0aGUgc2Ft
ZSBzaW11bGF0aW9uIGVudmlyb25tZW50IGFzIERhcnJpY2sncyBhbmQgRGF2ZSdzIGFuZCBoYXZl
Cj4gdGVzdGVkIG1hbnkgdGltZXMsIGJ1dCBzdGlsbCBjYW5ub3QgcmVwcm9kdWNlIHRoZSBmYWls
ZWQgY2FzZXMgdGhleQo+IG1lbnRpb25lZCAoZGF4K25vbl9yZWZsaW5rIG1vZGUsIGN1cnJlbnRs
eSBmb2N1aW5nKSB1bnRpbCBub3cuIE9ubHkgYSBmZXcKPiBjYXNlcyByYW5kb21seSBmYWlsZWQg
YmVjYXVzZSBvZiAidGFyZ2V0IGlzIGJ1c3kiLiBCdXQgSUlSQywgdGhvc2UgZmFpbGVkCj4gY2Fz
ZXMgeW91IG1lbnRpb25lZCB3ZXJlIGZhaWxlZCB3aXRoIGRtZXNnIHdhcm5pbmcgYXJvdW5kIHRo
ZSBmdW5jdGlvbgo+ICJkYXhfYXNzb2NpYXRlX2VudHJ5KCkiIG9yICJkYXhfZGlzYXNzb2NpYXRl
X2VudHJ5KCkiLiBTaW5jZSBJIGNhbm5vdAo+IHJlcHJvZHVjZSB0aGUgZmFpbHVyZSwgaXQgaGFy
ZCBmb3IgbWUgdG8gY29udGludWUgc292bGluZyB0aGUgcHJvYmxlbS4KCkZXSVcgdGhpbmdzIGhh
dmUgY2FsbWVkIGRvd24gYXMgb2YgNi4xLXJjMyAtLSBpZiBJIGRpc2FibGUgcmVmbGluaywKZnN0
ZXN0cyBydW5zIHdpdGhvdXQgY29tcGxhaW50LiAgTm93IGl0IG9ubHkgc2VlbXMgdG8gYmUgYWZm
ZWN0aW5nCnJlZmxpbms9MSBmaWxlc3lzdGVtcy4KCj4gQW5kIGhvdyBpcyB5b3VyIHJlY2VudCB0
ZXN0PyAgU3RpbGwgZmFpbGVkIHdpdGggdGhvc2UgZG1lc2cgd2FybmluZ3M/IElmIHNvLAo+IGNv
dWxkIHlvdSB6aXAgdGhlIHRlc3QgcmVzdWx0IGFuZCBzZW5kIGl0IHRvIG1lPwoKaHR0cHM6Ly9k
andvbmcub3JnL2RvY3Mva2VybmVsL2RheGJhZC56aXAKCi0tRAoKPiAKPiAKPiAtLQo+IFRoYW5r
cywKPiBSdWFuCgotLQpkbS1kZXZlbCBtYWlsaW5nIGxpc3QKZG0tZGV2ZWxAcmVkaGF0LmNvbQpo
dHRwczovL2xpc3RtYW4ucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRldmVsCg==

