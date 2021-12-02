Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1315BC433FE
	for <dm-devel@archiver.kernel.org>; Thu,  2 Dec 2021 15:41:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1638459697;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=WtvkEM3WlcN1RJw1aLTIYvC3b+0p1sYQ2KnfPIVqeNw=;
	b=Pr9XGxvht2gu0w0JN77cTRgaYtozpKoAm9Tc14PTQRCB5mIogAmfOLLUqe5RQO02rTpl5d
	/YBUytbyEZIk4N8O1PIyvIPqQk24jXrlG3SBR8ojQBMspCC1ZzRKbEcG44MftzP1NSr3Dx
	gxTw01O0sordWOGL2Z97KhQxR43Pktw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-502-ZkiQTI-cOPa12Yg_WiHOcw-1; Thu, 02 Dec 2021 10:41:35 -0500
X-MC-Unique: ZkiQTI-cOPa12Yg_WiHOcw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 56E011023F57;
	Thu,  2 Dec 2021 15:41:30 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 9B5C379448;
	Thu,  2 Dec 2021 15:41:28 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 0AAB01809C89;
	Thu,  2 Dec 2021 15:41:26 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com
	[10.5.11.13])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1B2FfOUo005019 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 2 Dec 2021 10:41:24 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id B3DCF4ABA2; Thu,  2 Dec 2021 15:41:24 +0000 (UTC)
Received: from [10.40.192.249] (unknown [10.40.192.249])
	by smtp.corp.redhat.com (Postfix) with ESMTP id D6DB0694C0;
	Thu,  2 Dec 2021 15:41:16 +0000 (UTC)
Message-ID: <5ccbac2c-8eb8-3e57-3cb3-8f85038d4e01@redhat.com>
Date: Thu, 2 Dec 2021 16:41:15 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
	Firefox/91.0 Thunderbird/91.3.0
To: Nikos Tsironis <ntsironis@arrikto.com>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>
References: <1127b165-f886-e3cf-061d-141fa7fb7d97@arrikto.com>
From: Zdenek Kabelac <zkabelac@redhat.com>
In-Reply-To: <1127b165-f886-e3cf-061d-141fa7fb7d97@arrikto.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"

RG5lIDAxLiAxMi4gMjEgdiAxODowNyBOaWtvcyBUc2lyb25pcyBuYXBzYWwoYSk6Cj4gSGVsbG8s
Cj4KPiBVbmRlciBjZXJ0YWluIGNvbmRpdGlvbnMsIHN3YXBwaW5nIGEgdGFibGUsIHRoYXQgaW5j
bHVkZXMgYSBkbS1lcmEKPiB0YXJnZXQsIHdpdGggYSBuZXcgdGFibGUsIGNhdXNlcyBhIGRlYWRs
b2NrLgo+Cj4gVGhpcyBoYXBwZW5zIHdoZW4gYSBzdGF0dXMgKFNUQVRVU1RZUEVfSU5GTykgb3Ig
bWVzc2FnZSBJT0NUTCBpcyBibG9ja2VkCj4gaW4gdGhlIHN1c3BlbmRlZCBkbS1lcmEgdGFyZ2V0
Lgo+Cj4gZG0tZXJhIGV4ZWN1dGVzIGFsbCBtZXRhZGF0YSBvcGVyYXRpb25zIGluIGEgd29ya2Vy
IHRocmVhZCwgd2hpY2ggc3RvcHMKPiBwcm9jZXNzaW5nIHJlcXVlc3RzIHdoZW4gdGhlIHRhcmdl
dCBpcyBzdXNwZW5kZWQsIGFuZCByZXN1bWVzIGFnYWluIHdoZW4KPiB0aGUgdGFyZ2V0IGlzIHJl
c3VtZWQuCj4KPiBTbywgcnVubmluZyAnZG1zZXR1cCBzdGF0dXMnIG9yICdkbXNldHVwIG1lc3Nh
Z2UnIGZvciBhIHN1c3BlbmRlZCBkbS1lcmEKPiBkZXZpY2UgYmxvY2tzLCB1bnRpbCB0aGUgZGV2
aWNlIGlzIHJlc3VtZWQuCj4KPiBUaGlzIHNlZW1zIHRvIGJlIGEgcHJvYmxlbSBvbiBpdHMgb3du
Lgo+Cj4gSWYgd2UgdGhlbiBsb2FkIGEgbmV3IHRhYmxlIHRvIHRoZSBkZXZpY2UsIHdoaWxlIHRo
ZSBhZm9yZW1lbnRpb25lZAo+IGRtc2V0dXAgY29tbWFuZCBpcyBibG9ja2VkIGluIGRtLWVyYSwg
YW5kIHJlc3VtZSB0aGUgZGV2aWNlLCB3ZQo+IGRlYWRsb2NrLgo+Cj4gVGhlIHByb2JsZW0gaXMg
dGhhdCB0aGUgJ2Rtc2V0dXAgc3RhdHVzJyBhbmQgJ2Rtc2V0dXAgbWVzc2FnZScgY29tbWFuZHMK
PiBob2xkIGEgcmVmZXJlbmNlIHRvIHRoZSBsaXZlIHRhYmxlLCBpLmUuLCB0aGV5IGhvbGQgYW4g
U1JDVSByZWFkIGxvY2sgb24KPiBtZC0+aW9fYmFycmllciwgd2hpbGUgdGhleSBhcmUgYmxvY2tl
ZC4KPgo+IFdoZW4gdGhlIGRldmljZSBpcyByZXN1bWVkLCB0aGUgb2xkIHRhYmxlIGlzIHJlcGxh
Y2VkIHdpdGggdGhlIG5ldyBvbmUKPiBieSBkbV9zd2FwX3RhYmxlKCksIHdoaWNoIGVuZHMgdXAg
Y2FsbGluZyBzeW5jaHJvbml6ZV9zcmN1KCkgb24KPiBtZC0+aW9fYmFycmllci4KPgo+IFNpbmNl
IHRoZSBibG9ja2VkIGRtc2V0dXAgY29tbWFuZCBpcyBob2xkaW5nIHRoZSBTUkNVIHJlYWQgbG9j
aywgYW5kIHRoZQo+IG9sZCB0YWJsZSBpcyBuZXZlciByZXN1bWVkLCAnZG1zZXR1cCByZXN1bWUn
IGJsb2NrcyB0b28sIGFuZCB3ZSBoYXZlIGEKPiBkZWFkbG9jay4KPgo+IFN0ZXBzIHRvIHJlcHJv
ZHVjZToKPgo+IDEuIENyZWF0ZSBkZXZpY2Ugd2l0aCBkbS1lcmEgdGFyZ2V0Cj4KPiDCoMKgICMg
ZG1zZXR1cCBjcmVhdGUgZXJhZGV2IC0tdGFibGUgIjAgMTA0ODU3NiBlcmEgL2Rldi9kYXRhdmcv
ZXJhbWV0YSAKPiAvZGV2L2RhdGF2Zy9lcmFkYXRhIDgxOTIiCj4KPiAyLiBTdXNwZW5kIHRoZSBk
ZXZpY2UKPgo+IMKgwqAgIyBkbXNldHVwIHN1c3BlbmQgZXJhZGV2Cj4KPiAzLiBMb2FkIG5ldyB0
YWJsZSB0byBkZXZpY2UsIGUuZy4sIHRvIHJlc2l6ZSB0aGUgZGV2aWNlCj4KPiDCoMKgICMgZG1z
ZXR1cCBsb2FkIGVyYWRldiAtLXRhYmxlICIwIDIwOTcxNTIgZXJhIC9kZXYvZGF0YXZnL2VyYW1l
dGEgCj4gL2Rldi9kYXRhdmcvZXJhZGF0YSA4MTkyIgo+CgpZb3VyIHNlcXVlbmNlIGlzIGZhdWx0
eSAtIHlvdSBtdXN0IGFsd2F5cyBwcmVsb2FkwqAgbmV3IHRhYmxlIGJlZm9yZSBzdXNwZW5kLgoK
U3VzcGVuZCZSZXN1bWUgc2hvdWxkIGJlIGFic29sdXRlbHkgbWluaW1hbCBpbiBpdHMgdGltaW5n
LgoKQWxzbyBub3RoaW5nIHNob3VsZCBiZSBhbGxvY2F0aW5nIG1lbW9yeSBpbiBzdXNwZW5kIHNv
IHRoYXQncyB3aHkgc3VzcGVuZCBoYXMgCnRvIGJlIHVzZWQgYWZ0ZXIgdGFibGUgbGluZSBpcyBm
dWxseSBsb2FkZWQuCgpSZWdhcmRzCgoKWmRlbmVrCgotLQpkbS1kZXZlbCBtYWlsaW5nIGxpc3QK
ZG0tZGV2ZWxAcmVkaGF0LmNvbQpodHRwczovL2xpc3RtYW4ucmVkaGF0LmNvbS9tYWlsbWFuL2xp
c3RpbmZvL2RtLWRldmVs

