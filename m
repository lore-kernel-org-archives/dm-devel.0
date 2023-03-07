Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C2C7CC678D5
	for <dm-devel@archiver.kernel.org>; Tue,  7 Mar 2023 10:31:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1678185112;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=RIgNGbVWhhW7mx/AYQeI9lG+fOUeDtZDKuD7QPl63DQ=;
	b=SUUqqG6/0Uq2hvBlChp+fvn7DH6m2K1Umg6ugJbwwMBUil3Shsyehr0t/u7RwHJvJDd3xz
	nIfpXp8yZEZnLdfHioLxCCW/AFnPIokwtv2dxt0Bq0fnyiejfoGn5Y1QeCq3XP9mYxy2H1
	7LomOGPWaWfq48zalvFPrz3m2O5xAes=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-128-E8deu2D6PQenHFoc979JVQ-1; Tue, 07 Mar 2023 05:31:49 -0500
X-MC-Unique: E8deu2D6PQenHFoc979JVQ-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 786E018ABF88;
	Tue,  7 Mar 2023 10:31:47 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 06993492C14;
	Tue,  7 Mar 2023 10:31:47 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id E259C19465A3;
	Tue,  7 Mar 2023 10:31:46 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id B93841946594
 for <dm-devel@listman.corp.redhat.com>; Tue,  7 Mar 2023 10:31:45 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 979E7C15BAE; Tue,  7 Mar 2023 10:31:40 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 8D81EC15BA0
 for <dm-devel@redhat.com>; Tue,  7 Mar 2023 10:31:40 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6E967877CA1
 for <dm-devel@redhat.com>; Tue,  7 Mar 2023 10:31:40 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-160-poEju11pOZeNm3VAhQQwkw-1; Tue,
 07 Mar 2023 05:31:36 -0500
X-MC-Unique: poEju11pOZeNm3VAhQQwkw-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out2.suse.de (Postfix) with ESMTPS id 9EE831FE17;
 Tue,  7 Mar 2023 10:31:35 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 7B8E11341F;
 Tue,  7 Mar 2023 10:31:35 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap2.suse-dmz.suse.de with ESMTPSA id avSxHIcSB2SDZAAAMHmgww
 (envelope-from <mwilck@suse.com>); Tue, 07 Mar 2023 10:31:35 +0000
Message-ID: <eab31c43c11e5acfc750ee1d5e21df4e92641c31.camel@suse.com>
From: Martin Wilck <mwilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>
Date: Tue, 07 Mar 2023 11:31:34 +0100
In-Reply-To: <20230306190413.GL17327@octiron.msp.redhat.com>
References: <CAHZQxyJH1etLR5gHuWk4c6-ieioqA4GrJ173B60bnTppke58dw@mail.gmail.com>
 <4bc4be79c2d00cc959932ec935179a46be4b2fbc.camel@suse.com>
 <5A7BD289-0205-42FF-84CD-7C218511A280@purestorage.com>
 <fb99dac64dd41a6a44b3c7ce065608b45ff467c4.camel@suse.com>
 <C9BF0F84-BA7F-432C-A9A7-DC77DFE856CA@purestorage.com>
 <82cf76fe2b1949337064127eac3ca17c1082d0a7.camel@suse.com>
 <20230306190413.GL17327@octiron.msp.redhat.com>
User-Agent: Evolution 3.46.4
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
Subject: Re: [dm-devel] [PATCH] [PATCH] libmultipath: return 'ghost' state
 when port is in transition
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
Cc: dm-devel@redhat.com, Brian Bunker <brian@purestorage.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

T24gTW9uLCAyMDIzLTAzLTA2IGF0IDEzOjA0IC0wNjAwLCBCZW5qYW1pbiBNYXJ6aW5za2kgd3Jv
dGU6Cj4gT24gTW9uLCBNYXIgMDYsIDIwMjMgYXQgMTI6NDY6NTBQTSArMDEwMCwgTWFydGluIFdp
bGNrIHdyb3RlOgo+ID4gSGkgQnJpYW4sCj4gPiAKPiA+IE9uIFNhdCwgMjAyMy0wMy0wNCBhdCAx
Mjo0OSAtMDgwMCwgQnJpYW4gQnVua2VyIHdyb3RlOgo+ID4gPiA+IAo+ID4gPiBUaGUgY2hlY2tp
bmcgZm9yIHN0YW5kYnkgaXMgMTQgeWVhcnMgb2xkLCBhbmQgc2F5cyB0aGF0IFRVUgo+ID4gPiBy
ZXR1cm5zCj4gPiA+IGEgdW5pdCBhdHRlbnRpb24gd2hlbiB0aGUgcGF0aCBpcyBpbiBzdGFuZGJ5
LiBJIGFtIG5vdCBzdXJlIHdoeQo+ID4gPiB0aGF0Cj4gPiA+IHdvdWxkbuKAmXQgYmUgaGFuZGxl
ZCBieSB0aGlzIGNvZGUgYWJvdmU6IEkgd291bGQgdGhpbmsgdGhlcmUKPiA+ID4gc2hvdWxkIGJl
Cj4gPiA+IGp1c3Qgb25lIHVuaXQgYXR0ZW50aW9uIGZvciBlYWNoIElfVF9MIHdoZW4gYW4gQUxV
QSBzdGF0ZSBjaGFuZ2UKPiA+ID4gaGFwcGVucy5Ob3Qgc3VyZSBob3cgaXQgZXhjZWVkcyB0aGUg
cmV0cnkgY291bnQuCj4gPiA+IAo+ID4gPiBpZiAoa2V5ID09IDB4Nikgewo+ID4gPiDCoMKgwqAg
LyogVW5pdCBBdHRlbnRpb24sIHJldHJ5ICovCj4gPiA+IMKgwqDCoCBpZiAo4oCUcmV0cnlfdHVy
KQo+ID4gPiDCoMKgwqDCoMKgwqDCoCBnb3RvIHJldHJ5Owo+ID4gPiB9Cj4gPiA+IAo+ID4gPiBG
cm9tIG15IHBlcnNwZWN0aXZlIGZhaWxpbmcgYSBwYXRoIGZvciBBTFVBIHN0YXRlIHN0YW5kYnkg
aXMKPiA+ID4gcmVhc29uYWJsZQo+ID4gPiBzaW5jZSBpdCBpcyBub3QgYW4gYWN0aXZlIHN0YXRl
Lgo+ID4gCj4gPiBJIHRoaW5rIHRoZSBoaXN0b3JpYyByYXRpb25hbGUgZm9yIHVzaW5nIEdIT1NU
IGlzIHRoYXQgc29tZSBzdG9yYWdlCj4gPiBhcnJheXMsIGluIHBhcnRpY3VsYXIgYWN0aXZlLXBh
c3NpdmUgY29uZmlndXJhdGlvbnMsIG1heSBrZWVwCj4gPiBjZXJ0YWluCj4gPiBwb3J0IGdyb3Vw
cyBpbiBTVEFOREJZIHN0YXRlLiBJZiBTVEFOREJZIHdhcyBjbGFzc2lmaWVkIGFzIEZBSUxFRCwK
PiA+ICJtdWx0aXBhdGggLWxsIiB3b3VsZCBzaG93IGFsbCBwYXRocyBvZiBzdWNoIHBvcnQgZ3Jv
dXBzIGFzIEZBSUxFRCwKPiA+IHdoaWNoIHdvdWxkIGNvbmZ1c2UgdXNlcnMuCj4gPiAKPiA+IFRo
YXQncyB3aGF0IEkgbWVhbnQgYmVmb3JlLCBtdWx0aXBhdGgncyBHSE9TVCBjYW4gbWVhbiBtdWx0
aXBsZQo+ID4gdGhpbmdzCj4gPiBkZXBlbmRpbmcgb24gdGhlIGFjdHVhbCBoYXJkd2FyZSBpbiB1
c2UsIGV4cGxpY2l0L2ltcGxpY2l0IEFMVUEsCj4gPiBldGMuCj4gPiBHaXZlbiB0aGF0IHRvZGF5
IGJhc2ljYWxseSBldmVyeSBoYXJkd2FyZSBzdXBwb3J0cyBBTFVBLCB3ZSBjb3VsZAo+ID4gcHJv
YmFibHkgZG8gYmV0dGVyLiBCdXQgY2hhbmdpbmcgdGhlIHNlbWFudGljcyBpbiB0aGUgY3VycmVu
dAo+ID4gc2l0dWF0aW9uCj4gPiBpcyByaXNreSBhbmQgZXJyb3IgcHJvbmUuCj4gCj4gSSBhbSBz
eW1wYXRoZXRpYyB0byBNYXJ0aW4ncyB2aWV3IHRoYXQgR0hPU1QgaXMgYW4gYW1iaWd1b3VzIHN0
YXRlLAo+IGFuZAo+IGl0J3Mgbm90IGF0IGFsbCBjbGVhciB0aGF0IGluIG1lYW5zICJ0ZW1wb3Jh
cmlseSBiZXR3ZWVuIHN0YXRlcyIuIEluCj4gZmFjdCwgaXQgdXN1c2FsbHkgZG9lc24ndC7CoCBP
biB0aGUgb3RoZXIgaGFuZCwgaWYgd2UgY2FuIGJlIHByZXR0eQo+IGNlcnRhaW4gdGhhdCBkZXZp
Y2VzIHdvbid0IGtlZXAgcGF0aHMgaW4gdGhlIFRSQU5TSVRJT05JTkcgc3RhdGUgZm9yCj4gYW4K
PiBleHRlbmRlZCB0aW1lLCBidXQgd2UgY2FuJ3QgYmUgY2VydGFpbiB3aGF0IHRoZSBlbmQgc3Rh
dGUgd2lsbCBiZSwgSQo+IGRvCj4gc2VlIHRoZSByYXRpb25hbGUgZm9yIG5vdCBmYWlsaW5nIHRo
ZW0gcHJlZW10aXZlbHkuIAoKVGhpcyBpcyBhbiBpbXBvcnRhbnQgcG9pbnQsIGZvciB3aGljaCBJ
IGRvbid0IHNlZSBhIGdlbmVyYWwgc29sdXRpb24uClVuZm9ydHVuYXRlbHksIGlmIGEgZGV2aWNl
IGlzIFRSQU5TSVRJT05JTkcsIHRoZSBTQ1NJIHNwZWMgb2ZmZXJzIG5vCm1lYW5zIGZvciB1cyB0
byBkZXRlcm1pbmUgd2hhdCBzdGF0ZSBpdCdzIHRyYW5zaXRpb25pbmcgdG8sIG5vdCBldmVuCndo
ZXRoZXIgdGhlIHRyYW5zaXRpb24gaXMgInVwIiBvciAiZG93biIgaW4gdGhlIHN0YXRlIGhpZXJh
cmNoeS4gV2UgY2FuCm9ubHkgZ3Vlc3MgZnJvbSB0aGUgcHJldmlvdXMgc3RhdGUsIGJ1dCBpdCB3
aWxsIG5ldmVyIGJlIG1vcmUgdGhhbiBqdXN0CnRoYXQsIGEgZ3Vlc3MuCgo+IEkgd29uZGVyIGlm
IFBBVEhfUEVORElORyBtYWtlcyBtb3JlIHNlbnNlLsKgIFdlIHdvdWxkIHJldGFpbiB0aGUKPiBl
eGlzdGluZwo+IHN0YXRlIHVudGlsIHRoZSBwYXRoIGxlZnQgdGhlIFRSQU5TSVRJT05JTkcgc3Rh
dGUuwqAgVGhlIHF1ZXN0aW9uIGlzLAo+IGFyZQo+IHlvdSB0cnlpbmcgdG8gbWFrZSBwYXRocyB0
aGF0IGFyZSB0cmFuc2l0aW9uaW5nIG91dCBvZiBhIGZhaWxlZCBzdGF0ZQo+IGNvbWUgYmFjayBz
b29uZXIsIG9yIGFyZSB5b3UgdHJ5aW5nIHRvIGtlZXAgcGF0aHMgdGhhdCB3ZXJlIGluIGEKPiBh
Y3RpdmUKPiBzdGF0ZSBmcm9tIGJlaW5nIHByZXZlbXRpdmVseSBmYWlsZWQuwqAgVXNpbmcgUEFU
SF9QRU5ESU5HIHdvbid0IGZpeAo+IHRoZQo+IGZpcnN0IGNhc2UsIG9ubHkgdGhlIHNlY29uZC4K
CkEgdmVyeSBpbnRlcmVzdGluZyBzdWdnZXN0aW9uLiBJIGxpa2UgaXQuCgpJIHRoaW5rIHRoYXQg
aXQgbWFrZXMgbGl0dGxlIHNlbnNlIHRvIHRyeSBhbmQgbWFrZSBzdWNoIHBhdGhzICJjb21lCmJh
Y2sgc29vbmVyIi4gVFJBTlNJVElPTklORyBkZXZpY2VzIGFyZW4ndCB1c2FibGUsIGFuZCBhbnkg
YXR0ZW1wdCB0bwp0cnkgdG8gdXNlIHRoZW0gd2lsbCBjYXVzZSBhbiBJTyBlcnJvciBhbmQgc3dp
dGNoIHRvIEZBSUxFRCBzdGF0ZQppbW1lZGlhdGVseSBieSB0aGUga2VybmVsIGRyaXZlci4gUEFU
SF9QRU5ESU5HIHdvdWxkIGNhdXNlIGRldmljZXMgdGhhdAphcmUgImNvbWluZyB1cCIgdG8gYmUg
Y2hlY2tlZCBmcmVxdWVudGx5LCBhbmQgdGh1cyBtYWtlIHRoZW0gYXZhaWxhYmxlCndpdGhpbiBv
bmUgY2hlY2tlciBpbnRlcnZhbCBvZiB0aGVtIGJlY29taW5nIGFjdHVhbGx5IEFDVElWRSwgd2hp
Y2ggaXMKYWJvdXQgdGhlIGJlc3Qgd2UgY2FuIGRvIGluIHRoZSAidHJhbnNpdGlvbmluZyB1cCIg
Y2FzZS4KCldoZW4gdGhlIHBhdGggaXMgZ29pbmcgImRvd24iIGZyb20gUEFUSF9VUCBzdGF0ZSwg
UEFUSF9QRU5ESU5HIHdvdWxkCmltcGx5IHRoYXQgdGhlIGtlcm5lbCBETV9TVEFURSB3b3VsZCBy
ZW1haW4gYXMtaXMgKHByb2JhYmx5ICJhY3RpdmUiKS4KSWYgSS9PIGlzIGhhcHBlbmluZywgdGhl
IGRldmljZSB3b3VsZCBzb29uZXIgb3IgbGF0ZXIgYmUgdXNlZCBieSB0aGUKa2VybmVsLCBhbmQg
dGhlIEkvTyB3b3VsZCBtb3N0IHByb2JhYmx5IGZhaWwsIHNldHRpbmcgdGhlIHBhdGggdG8KRkFJ
TEVELiBXaXRoIFBBVEhfR0hPU1QsIHRoZSBwYXRoIHdvdWxkIGdldCBhIGxvd2VyIHByaW9yaXR5
IGFuZCB0aHVzCnRoZSBsaWtlbHlob29kIG9mIGl0IGJlaW5nIHVzZWQgd291bGQgYmUgZGVjcmVh
c2VkLCBhdCBsZWFzdCB3aXRoCmdyb3VwX2J5X3ByaW8gKGFsdGhvdWdoIHRoaXMgd291bGQgbWVh
biB0aGF0IHRoaXMgcGF0aCB3b3VsZCBiZSBncm91cGVkCnRvZ2V0aGVyIHdpdGggU1RBTkRCWSBw
YXRocywgc2VlIGJlbG93KS4KCkFnYWluLCBJIHRoaW5rIHRoZSBiZWhhdmlvciB3aXRoIFBBVEhf
UEVORElORyB3b3VsZCBiZSB0aGUgYmVzdCB3ZSBjYW4KZ2V0LiBXaGV0aGVyIG9yIG5vdCB0aGUg
a2VybmVsIGZhaWxzIHRoZSBkZXZpY2UgaW4gdGhlIG1lYW50aW1lLAptdWx0aXBhdGhkIHdpbGwg
aXNzdWUgVFVSIGZyZXF1ZW50bHksIGFuZCBldmVudHVhbGx5IHNlZSB0aGUgZGV2aWNlCmFycml2
aW5nIGluIGEgbmV3IHN0YXRlLCB3aGljaCB3aWxsIHByb2JhYmx5IGJlIFNUQU5EQlkgb3IgVU5B
VkFJTEFCTEUuCgo+IAo+IFBBVEhfUEVORElORyBtYWtlcyBzdXJlIHRoYXQgaWYgSU8gdG8gdGhl
IHBhdGggZG9lcyBzdGFydCBmYWlsaW5nLAo+IHRoZQo+IGNoZWNrZXIgd29uJ3Qga2VlcCBzZXR0
aW5nIHRoZSBwYXRoIGJhY2sgdG8gYW4gYWN0aXZlIHN0YXRlIGFnYWluLsKgCj4gSXQKPiBhbHNv
IGF2b2lkcyB0aGUgYW5vdGhlciBHSE9TVCBpc3N1ZSwgd2hlcmUgdGhlIHBhdGggd291bGQgZW5k
IHVwCj4gYmVpbmcKPiBncm91cGVkIHdpdGggYW55IGFjdHVhbGx5IHBhc3NpdmUgcGF0aHMsIHdo
aWNoIGlzbid0IHdoYXQgd2UncmUKPiBsb29raW5nCj4gZm9yLgoKR29vZCBwb2ludCEgVGhpcyBj
YXVzZXMgcG9pbnRsZXNzIHJlLWdyb3VwaW5nIG9mIHBhdGhzIGZvciBncm91cC1ieS0KcHJpbyBm
b3IgZXZlcnkgQUxVQSB0cmFuc2l0aW9uLiBPVE9ILCB3ZSBzZWUgc3VjaCByZWdyb3VwaW5nIGFu
eXdheSwgaW4KcGFydGljdWxhciBpZiB0aGUgcGF0aHMgZG9uJ3QgdHJhbnNpdGlvbiBzaW11bHRh
bmVvdXNseSAob3Igd2UgZG9uJ3QKZGV0ZWN0IHRoZSB0cmFuc2l0aW9uIHNpbXVsdGFuZW91c2x5
KS4gVGhlIG9ubHkgd2F5IHRvIGF2b2lkIHRoaXMgd291bGQKYmUgYSBwYXRoIGdyb3VwaW5nIGFs
Z29yaXRobSB0aGF0IGRpcmVjdGx5IHVzZXMgUlRQRyByZXBvcnRlZCBwYXRoCmdyb3VwcyByYXRo
ZXIgdGhhbiBncm91cGluZyBieSBwcmlvLiBXZSBkb24ndCBoYXZlIHN1Y2ggYW4gYWxnb3JpdGht
CmN1cnJlbnRseS4KCj4gVGhlIG9uZSBwcm9ibGVtIEkgY2FuIHRoaW5rIG9mIG9mZiB0aGUgdG9w
IG9mIG15IGhlYWQgd291bGQgYmUgdGhhdAo+IGlmCj4gdGhlIGRldmljZSB3YXMgaGVsZCBpbiB0
aGUgVFJBTlNJU1RJT05JTkcgc3RhdGUgZm9yIGEgbG9uZyB0aW1lLAo+IG11bHRpcGF0aGQgd291
bGQga2VlcCBjaGVja2luZyBpdCBjb25zdGFudGx5LCBzaW5jZSBQQVRIX1BFTkRJTkcgaXMKPiBy
ZWFsbHkgbWVhbnQgZm9yIGNhc2VzIHdoZXJlIHRoZSBjaGVja2VyIGhhc24ndCBjb21wbGV0ZWQg
eWV0LCBhbmQgd2UKPiBqdXN0IHdhbnQgdG8ga2VlcCBsb29raW5nIGZvciB0aGUgcmVzdWx0LiBJ
IHN1cHBvc2UgaXQgd291bGQgYmUKPiBwb3NzaWJsZQo+IHRvIGFkZCBhbm90aGVyIHN0YXRlIHRo
YXQgd29ya2VkIGp1c3QgbGlrZSBwZW5kaW5nIChhbmQgY291bGQgZXZlbgo+IGdldAo+IGNvbnZl
cnRlZCB0byBQQVRIX1BFTkRJTkcgaWYgdGhlcmUgd2FzIG5vIG90aGVyIHN0YXRlIHRvIGJlIGNv
bnZlcnRlZAo+IHRvKSBidXQgZGlkbid0IGNhdXNlIHVzIHRvIHJldGlnZ2VyIHRoZSBjaGVja2Vy
IHNvIHF1aWNrbHkuwqAgQnV0IGlmCj4gZGV2aWNlcyByZWFsbHkgd2lsbCBvbmx5IGJlIGluIFRS
QU5TSVRJT05JTkcgZm9yIGEgc2hvcnQgdGltZSwgaXQKPiBtaWdodAo+IG5vdCBldmVuIGJlIGFu
IGlzc3VlIHdlIGhhdmUgdG8gd29ycnkgYWJvdXQuCgpUaGUgZGVmYXVsdCB0cmFuc2l0aW9uaW5n
IHRpbWVvdXQgaXMgNjBzLCBhbmQgaW4gbXkgZXhwZXJpZW5jZSwgZXZlbiBpZgp0aGUgaGFyZHdh
cmUgb3ZlcnJpZGVzIGl0LCBpdCdzIHJhcmVseSBtb3JlIHRoYW4gYSBmZXcgbWludXRlcy4gQWZ0
ZXIKdGhhdCwgdGhlIGtlcm5lbCB3aWxsIHNldCB0aGUgc3RhdGUgdG8gU1RBTkRCWS4KClVubGVz
cyB3ZSdyZSBib3RoIG92ZXJsb29raW5nIHNvbWV0aGluZywgSSBhZ3JlZSB3aXRoIHlvdSB0aGF0
ClBBVEhfUEVORElORyBpcyB0aGUgcmlnaHQgdGhpbmcgdG8gZG8gZm9yIFRSQU5TSVRJT05JTkcu
IFdoZW4gYSBkZXZpY2UKaXMgaW4gdHJhbnNpdGlvbiBiZXR3ZWVuIHN0YXRlcywgd2UgX3dhbnRf
IHRvIGNoZWNrIGl0IG9mdGVuIHRvIG1ha2UKc3VyZSB3ZSBub3RpY2Ugd2hlbiB0aGUgdGFyZ2V0
IHN0YXRlIGlzIHJlYWNoZWQuCgpXZSBtdXN0IHRoZW4gYmUgY2FyZWZ1bCBub3QgdG8gb3Zlcmxv
YWQgUEFUSF9QRU5ESU5HIHdpdGggdG9vIG1hbnkKZGlmZmVyZW50IG1lYW5pbmdzLiBCdXQgSSBk
b24ndCBzZWUgdGhpcyBhcyBhIGJpZyBpc3N1ZSBjdXJyZW50bHkuCgpSZWdhcmRzCk1hcnRpbgoK
PiBUaG91Z2h0cz8KPiAKPiAtQmVuCj4gCj4gPiAKPiA+IFJlZ2FyZHMKPiA+IE1hcnRpbgo+IAoK
LS0KZG0tZGV2ZWwgbWFpbGluZyBsaXN0CmRtLWRldmVsQHJlZGhhdC5jb20KaHR0cHM6Ly9saXN0
bWFuLnJlZGhhdC5jb20vbWFpbG1hbi9saXN0aW5mby9kbS1kZXZlbAo=

