Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E04BCC7EE22
	for <dm-devel@archiver.kernel.org>; Thu, 11 May 2023 18:56:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1683831370;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=rSANKejB10oAeR3NyPLfo4QYf9vmayyBXpUMveuQ84s=;
	b=eomoOl3xa2XLeVMWyzeiAX4apchKzWzcNPt8J4m5HMzXcL2vUFjTifMI9X+aTHU4x4E0E5
	xBQTCZvvzVakls7SYCvysht2RDQGJNz2lHKs5epdtD0+OwLX/ZUkyXEMGCLORmWtgCVXn6
	/iVInQ7M3BE70u0XvCKzU9hbeq+Sv2o=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-662-UB-7zD19NAiLuHVRrfE7Fg-1; Thu, 11 May 2023 14:56:07 -0400
X-MC-Unique: UB-7zD19NAiLuHVRrfE7Fg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7C479185A790;
	Thu, 11 May 2023 18:56:05 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 2467AC15BA0;
	Thu, 11 May 2023 18:56:05 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id E2FD419451E4;
	Thu, 11 May 2023 18:56:04 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 2EBEB19451E3
 for <dm-devel@listman.corp.redhat.com>; Thu, 11 May 2023 18:56:04 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id D0E2E14171BC; Thu, 11 May 2023 18:56:03 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id C9C6F14171C1
 for <dm-devel@redhat.com>; Thu, 11 May 2023 18:56:03 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-2.mimecast.com
 [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9874A280559A
 for <dm-devel@redhat.com>; Thu, 11 May 2023 18:56:03 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-211-ysOlTu-rMpqYmLmzjoF8SA-1; Thu,
 11 May 2023 14:56:01 -0400
X-MC-Unique: ysOlTu-rMpqYmLmzjoF8SA-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out2.suse.de (Postfix) with ESMTPS id 596C52004E
 for <dm-devel@redhat.com>; Thu, 11 May 2023 18:56:00 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id D95D0134B2
 for <dm-devel@redhat.com>; Thu, 11 May 2023 18:55:59 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap2.suse-dmz.suse.de with ESMTPSA id pd0LJz86XWQRUgAAMHmgww
 (envelope-from <hare@suse.de>)
 for <dm-devel@redhat.com>; Thu, 11 May 2023 18:55:59 +0000
Message-ID: <2aafd5fc-26b4-fa82-4149-a72adf6722b9@suse.de>
Date: Thu, 11 May 2023 20:55:57 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.1
To: dm-devel@redhat.com
References: <CAF1ivSZJjVq313Zg9nBF0S3DOun=-Vw8saZGPU5cGrB_woM-8g@mail.gmail.com>
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <CAF1ivSZJjVq313Zg9nBF0S3DOun=-Vw8saZGPU5cGrB_woM-8g@mail.gmail.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
Subject: Re: [dm-devel] Does dm-zoned support buffered write?
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
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: suse.de
Content-Language: en-US
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"

T24gNS8xMS8yMyAyMDo0MSwgTWluZyBMaW4gd3JvdGU6Cj4gSGkgbGlzdCwKPiAKPiBJIGhhdmUg
YW4gYXBwbGljYXRpb24gdGhhdCBuZWVkcyB0byB1c2UgYnVmZmVyZWRfaW8gdG8gYWNjZXNzIFNN
UiBkaXNrCj4gZm9yIGdvb2QgcGVyZm9ybWFuY2UuCj4gCj4gIEZyb20gIlpCRCBTdXBwb3J0IFJl
c3RyaWN0aW9ucyIgYXQgaHR0cHM6Ly96b25lZHN0b3JhZ2UuaW8vZG9jcy9saW51eC9vdmVydmll
dwo+ICIKPiBEaXJlY3QgSU8gV3JpdGVzIFRoZSBrZXJuZWwgcGFnZSBjYWNoZSBkb2VzIG5vdCBn
dWFyYW50ZWUgdGhhdCBjYWNoZWQKPiBkaXJ0eSBwYWdlcyB3aWxsIGJlIGZsdXNoZWQgdG8gYSBi
bG9jayBkZXZpY2UgaW4gc2VxdWVudGlhbCBzZWN0b3IKPiBvcmRlci4gVGhpcyBjYW4gbGVhZCB0
byB1bmFsaWduZWQgd3JpdGUgZXJyb3JzIGlmIGFuIGFwcGxpY2F0aW9uIHVzZXMKPiBidWZmZXJl
ZCB3cml0ZXMgdG8gd3JpdGUgdG8gdGhlIHNlcXVlbnRpYWwgd3JpdGUgcmVxdWlyZWQgem9uZXMg
b2YgYQo+IGRldmljZS4gVG8gYXZvaWQgdGhpcyBwaXRmYWxsLCBhcHBsaWNhdGlvbnMgdGhhdCBk
aXJlY3RseSB1c2UgYSB6b25lZAo+IGJsb2NrIGRldmljZSB3aXRob3V0IGEgZmlsZSBzeXN0ZW0g
c2hvdWxkIGFsd2F5cyB1c2UgZGlyZWN0IEkvTwo+IG9wZXJhdGlvbnMgdG8gd3JpdGUgdG8gdGhl
IHNlcXVlbnRpYWwgd3JpdGUgcmVxdWlyZWQgem9uZXMgb2YgYQo+IGhvc3QtbWFuYWdlZCBkaXNr
ICh0aGF0IGlzLCB0aGV5IHNob3VsZCBpc3N1ZSB3cml0ZSgpIHN5c3RlbSBjYWxscwo+IHdpdGgg
YSBibG9jayBkZXZpY2UgImZpbGUgb3BlbiIgdGhhdCB1c2VzIHRoZSBPX0RJUkVDVCBmbGFnKS4K
PiAiCj4gCj4gUmF3IHpiZCBkaXNrIG9ubHkgc3VwcG9ydHMgZGlyZWN0X2lvLgo+IAo+IERvZXMg
ZG0tem9uZWQgc3VwcG9ydCBidWZmZXJlZCBpbyAod2l0aG91dCBPX0RJUkVDVCk/Cj4gClllcy4g
QnV0IEkgX3RoaW5rXyB0aGUgYWJvdmUgcGFyYWdyYXBoIGlzIGV2ZXIgc28gc2xpZ2h0bHkgb3V0
ZGF0ZWQsIGFzIAp3ZSd2ZSBzcGVudCBxdWl0ZSBhIGxvdCBvZiB0aW1lIGZpeGluZyBzZXF1ZW50
aWFsIHdyaXRlcyAoY2YgYmxrLXpvbmVkIApldGMpLiBTbyB3aGlsZSBkbS16b25lZCBpcyB1c2lu
ZyBidWZmZXJldCB3cml0ZXMgdGhlcmUgd29uJ3QgYmUgYW55IApzZXF1ZW50aWFsIHdyaXRlIGlz
c3Vlcy4KCkF0IGxlYXN0LCBJIGhhdmUgbm90IHVuY292ZXJlZCBhbnkgb2YgdGhvc2UgZHVyaW5n
IHRlc3RpbmcuCgpDaGVlcnMsCgpIYW5uZXMKLS0gCkRyLiBIYW5uZXMgUmVpbmVja2UgICAgICAg
ICAgICAgICAgS2VybmVsIFN0b3JhZ2UgQXJjaGl0ZWN0CmhhcmVAc3VzZS5kZSAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICs0OSA5MTEgNzQwNTMgNjg4ClNVU0UgU29mdHdhcmUgU29sdXRp
b25zIEdtYkgsIE1heGZlbGRzdHIuIDUsIDkwNDA5IE7DvHJuYmVyZwpIUkIgMzY4MDkgKEFHIE7D
vHJuYmVyZyksIEdlc2Now6RmdHNmw7xocmVyOiBJdm8gVG90ZXYsIEFuZHJldwpNeWVycywgQW5k
cmV3IE1jRG9uYWxkLCBNYXJ0amUgQm91ZGllbiBNb2VybWFuCgotLQpkbS1kZXZlbCBtYWlsaW5n
IGxpc3QKZG0tZGV2ZWxAcmVkaGF0LmNvbQpodHRwczovL2xpc3RtYW4ucmVkaGF0LmNvbS9tYWls
bWFuL2xpc3RpbmZvL2RtLWRldmVsCg==

