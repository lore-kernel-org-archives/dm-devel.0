Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 34D86C433F5
	for <dm-devel@archiver.kernel.org>; Fri,  3 Dec 2021 16:00:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1638547252;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=P8e3uTVpiE//OJoX6TS3K5PAxs18uFUgpY9jqoVRqp0=;
	b=RPIpfU4pSkHzqT2ooWmnTE4RFEk1wWrZWHeStnbsQlmtGTFxNC5El1oF6gY6pAgDX31Qqg
	V/XieIZT9/G1Ss6cSXVvlM/Owm5VVy1ttA2LEfIMUT2oj2sNN+6ifQQqPh94W5HApiTuRI
	l5qNXMr4d1mvzabQxtgE1/gf3qiBYE4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-441-Yrz5D43sPiiLuA3Aol5Suw-1; Fri, 03 Dec 2021 11:00:47 -0500
X-MC-Unique: Yrz5D43sPiiLuA3Aol5Suw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5D44C2F47;
	Fri,  3 Dec 2021 16:00:42 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id DF8261972D;
	Fri,  3 Dec 2021 16:00:40 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 904B04BB7C;
	Fri,  3 Dec 2021 16:00:38 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com
	[10.5.11.23])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1B3G0brS004212 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 3 Dec 2021 11:00:37 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 845761972D; Fri,  3 Dec 2021 16:00:37 +0000 (UTC)
Received: from [10.40.193.91] (unknown [10.40.193.91])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 284B6196F1;
	Fri,  3 Dec 2021 16:00:02 +0000 (UTC)
Message-ID: <7ff5dfca-bebb-4647-212d-3dd3aec678b9@redhat.com>
Date: Fri, 3 Dec 2021 17:00:01 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
	Firefox/91.0 Thunderbird/91.3.0
To: Nikos Tsironis <ntsironis@arrikto.com>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>
References: <1127b165-f886-e3cf-061d-141fa7fb7d97@arrikto.com>
	<5ccbac2c-8eb8-3e57-3cb3-8f85038d4e01@redhat.com>
	<1e508a1a-0ba4-0ef2-c660-0c522907ced0@arrikto.com>
From: Zdenek Kabelac <zkabelac@redhat.com>
In-Reply-To: <1e508a1a-0ba4-0ef2-c660-0c522907ced0@arrikto.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-loop: dm-devel@redhat.com
Subject: Re: [dm-devel] Deadlock when swapping a table with a dm-era target
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

RG5lIDAzLiAxMi4gMjEgdiAxNTo0MiBOaWtvcyBUc2lyb25pcyBuYXBzYWwoYSk6Cj4gT24gMTIv
Mi8yMSA1OjQxIFBNLCBaZGVuZWsgS2FiZWxhYyB3cm90ZToKPj4gRG5lIDAxLiAxMi4gMjEgdiAx
ODowNyBOaWtvcyBUc2lyb25pcyBuYXBzYWwoYSk6Cj4+PiBIZWxsbywKPj4+Cj4+PiBVbmRlciBj
ZXJ0YWluIGNvbmRpdGlvbnMsIHN3YXBwaW5nIGEgdGFibGUsIHRoYXQgaW5jbHVkZXMgYSBkbS1l
cmEKPj4+IHRhcmdldCwgd2l0aCBhIG5ldyB0YWJsZSwgY2F1c2VzIGEgZGVhZGxvY2suCj4+Pgo+
Pj4gVGhpcyBoYXBwZW5zIHdoZW4gYSBzdGF0dXMgKFNUQVRVU1RZUEVfSU5GTykgb3IgbWVzc2Fn
ZSBJT0NUTCBpcyBibG9ja2VkCj4+PiBpbiB0aGUgc3VzcGVuZGVkIGRtLWVyYSB0YXJnZXQuCj4+
Pgo+Pj4gZG0tZXJhIGV4ZWN1dGVzIGFsbCBtZXRhZGF0YSBvcGVyYXRpb25zIGluIGEgd29ya2Vy
IHRocmVhZCwgd2hpY2ggc3RvcHMKPj4+IHByb2Nlc3NpbmcgcmVxdWVzdHMgd2hlbiB0aGUgdGFy
Z2V0IGlzIHN1c3BlbmRlZCwgYW5kIHJlc3VtZXMgYWdhaW4gd2hlbgo+Pj4gdGhlIHRhcmdldCBp
cyByZXN1bWVkLgo+Pj4KPj4+IFNvLCBydW5uaW5nICdkbXNldHVwIHN0YXR1cycgb3IgJ2Rtc2V0
dXAgbWVzc2FnZScgZm9yIGEgc3VzcGVuZGVkIGRtLWVyYQo+Pj4gZGV2aWNlIGJsb2NrcywgdW50
aWwgdGhlIGRldmljZSBpcyByZXN1bWVkLgo+Pj4KPiBIaSBaZGVuZWssCj4KPiBUaGFua3MgZm9y
IHRoZSBmZWVkYmFjay4gVGhlcmUgZG9lc24ndCBzZWVtIHRvIGJlIGFueSBkb2N1bWVudGF0aW9u
Cj4gbWVudGlvbmluZyB0aGF0IGxvYWRpbmcgdGhlIG5ldyB0YWJsZSBzaG91bGQgaGFwcGVuIGJl
Zm9yZSBzdXNwZW5kLCBzbwo+IHRoYW5rcyBhIGxvdCBmb3IgZXhwbGFpbmluZyBpdC4KPgo+IFVu
Zm9ydHVuYXRlbHksIHRoaXMgaXNuJ3Qgd2hhdCBjYXVzZXMgdGhlIGRlYWRsb2NrLiBUaGUgZm9s
bG93aW5nCj4gc2VxdWVuY2UsIHdoaWNoIGxvYWRzIHRoZSB0YWJsZSBiZWZvcmUgc3VzcGVuZCwg
YWxzbyByZXN1bHRzIGluIGEKPiBkZWFkbG9jazoKPgo+IDEuIENyZWF0ZSBkZXZpY2Ugd2l0aCBk
bS1lcmEgdGFyZ2V0Cj4KPiDCoMKgICMgZG1zZXR1cCBjcmVhdGUgZXJhZGV2IC0tdGFibGUgIjAg
MTA0ODU3NiBlcmEgL2Rldi9kYXRhdmcvZXJhbWV0YSAKPiAvZGV2L2RhdGF2Zy9lcmFkYXRhIDgx
OTIiCj4KPiAyLiBMb2FkIG5ldyB0YWJsZSB0byBkZXZpY2UsIGUuZy4sIHRvIHJlc2l6ZSB0aGUg
ZGV2aWNlCj4KPiDCoMKgICMgZG1zZXR1cCBsb2FkIGVyYWRldiAtLXRhYmxlICIwIDIwOTcxNTIg
ZXJhIC9kZXYvZGF0YXZnL2VyYW1ldGEgCj4gL2Rldi9kYXRhdmcvZXJhZGF0YSA4MTkyIgo+Cj4g
My4gU3VzcGVuZCB0aGUgZGV2aWNlCj4KPiDCoMKgICMgZG1zZXR1cCBzdXNwZW5kIGVyYWRldgo+
Cj4gNC4gUmV0cmlldmUgdGhlIHN0YXR1cyBvZiB0aGUgZGV2aWNlLiBUaGlzIGJsb2NrcyBmb3Ig
dGhlIHJlYXNvbnMgSQo+IMKgwqAgZXhwbGFpbmVkIGluIG15IHByZXZpb3VzIGVtYWlsLgo+Cj4g
wqDCoCAjIGRtc2V0dXAgc3RhdHVzIGVyYWRldgoKCkhpCgpRdWVyeWluZyAnc3RhdHVzJyB3aGls
ZSB0aGUgZGV2aWNlIGlzIHN1c3BlbmQgaXMgdGhlIG5leHQgaXNzdWUgeW91IG5lZWQgdG8gCmZp
eCBpbiB5b3VyIHdvcmtmbG93LgoKTm9ybWFsbHkgJ3N0YXR1cycgb3BlcmF0aW9uIG1heSBuZWVk
IHRvIGZsdXNoIHF1ZXVlZCBJTyBvcGVyYXRpb25zIHRvIGdldCAKYWNjdXJhdGUgZGF0YS4KClNv
IHlvdSBzaG91bGQgcXVlcnkgc3RhdGVzIGJlZm9yZSB5b3Ugc3RhcnQgdG8gbWVzcyB3aXRoIHRh
Ymxlcy4KCklmIHlvdSB3YW50IHRvIGdldCAnc3RhdHVzJyB3aXRob3V0IGZsdXNoaW5nIC0gdXNl
OsKgwqAgJ2Rtc2V0dXAgc3RhdHVzIC0tbm9mbHVzaCcuCgoKPiA1LiBSZXN1bWUgdGhlIGRldmlj
ZS4gVGhpcyBkZWFkbG9ja3MgZm9yIHRoZSByZWFzb25zIEkgZXhwbGFpbmVkIGluIG15Cj4gwqDC
oCBwcmV2aW91cyBlbWFpbC4KPgo+IMKgwqAgIyBkbXNldHVwIHJlc3VtZSBlcmFkZXYKPgo+IDYu
IFRoZSBkbWVzZyBsb2dzIGFyZSB0aGUgc2FtZSBhcyB0aGUgb25lcyBJIGluY2x1ZGVkIGluIG15
IHByZXZpb3VzCj4gwqDCoCBlbWFpbC4KPgo+IEkgaGF2ZSBleHBsYWluZWQgdGhlIHJlYXNvbnMg
Zm9yIHRoZSBkZWFkbG9jayBpbiBteSBwcmV2aW91cyBlbWFpbCwgYnV0Cj4gSSB3b3VsZCBiZSBt
b3JlIHRoYW4gaGFwcHkgdG8gZGlzY3VzcyB0aGVtIG1vcmUuCj4KClRoZXJlIGlzIG5vIGJ1ZyAt
IGlmIHlvdXIgb25seSBwcm9ibGVtIGlzICdzdHVjayfCoCBzdGF0dXMgd2hpbGUgeW91IGhhdmUg
CmRldmljZXMgaW4gc3VzcGVuZGVkIHN0YXRlLgoKWW91IHNob3VsZCBOT1QgYmUgZG9pbmcgYmFz
aWNhbGx5IGFueXRoaW5nIHdoaWxlIGJlaW5nIHN1c3BlbmQhIQoKaS5lLiBpbWFnaW5lIHlvdSBz
dXNwZW5kICdzd2FwJyBkZXZpY2UgYW5kIHdoaWxlIHlvdSBhcmUgaW4gc3VzcGVuZWQgc3RhdGUg
Cmtlcm5lbCBkZWNpZGVzIHRvIHN3YXAgbWVtb3J5IHBhZ2VzIC0gc28geW91IGdldCBpbnN0YW50
bHkgZnJvemVuIGhlcmUuCgpGb3IgdGhpcyByZWFzb24gbHZtMiB3aGlsZSBkb2luZ8KgICdzdXNw
ZW5kL3Jlc3VtZScgc2VxdWFuY2UgcHJlYWxsb2NhdGVzIGFsbCAKbWVtb3J5IGluIGZyb250IG9m
IHRoaXMgb3BlcmF0aW9uIC0gZG9lcyB2ZXJ5IG1pbmltYWwgc2V0IG9mIG9wZXJhdGlvbiBiZXR3
ZWVuIApzdXNwZW5kL3Jlc3VtZSB0byBtaW5pbWl6ZSBhbHNvIGxhdGVuY2llcyBhbmQgc28gb24u
CgpDbGVhcmx5IGlmIHlvdSBzdXNwZW5kIGp1c3Qgc29tZSAnc3VwcG9ydGl2ZSfCoCBkaXNrIG9m
IHlvdXJzIC0geW91IGxpa2VseSBhcmUgCm5vIGluIGRhbmdlciBvZiBibG9ja2luZyB5b3VyIHN3
YXAgLSBidXQgdGhlICdzdGF0dXMgLS1ub2ZsdXNoJyBsb2dpYyBzdGlsbCAKYXBwbGllcy4KCgpS
ZWdhcmRzCgpaZGVuZWsKCgotLQpkbS1kZXZlbCBtYWlsaW5nIGxpc3QKZG0tZGV2ZWxAcmVkaGF0
LmNvbQpodHRwczovL2xpc3RtYW4ucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRldmVs

