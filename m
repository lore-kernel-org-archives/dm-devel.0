Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DCEF9C433EF
	for <dm-devel@archiver.kernel.org>; Fri, 29 Apr 2022 08:24:05 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-567-VhQl2YD4PkiDRCFna-UfzQ-1; Fri, 29 Apr 2022 04:23:55 -0400
X-MC-Unique: VhQl2YD4PkiDRCFna-UfzQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 53A96811E90;
	Fri, 29 Apr 2022 08:23:51 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 333AA40869E3;
	Fri, 29 Apr 2022 08:23:50 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id EC3371947075;
	Fri, 29 Apr 2022 08:23:48 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id AB0881947046
 for <dm-devel@listman.corp.redhat.com>; Thu, 28 Apr 2022 08:11:19 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 98A45565215; Thu, 28 Apr 2022 08:11:19 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 94E045651F9
 for <dm-devel@redhat.com>; Thu, 28 Apr 2022 08:11:19 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7BC8929AB3E1
 for <dm-devel@redhat.com>; Thu, 28 Apr 2022 08:11:19 +0000 (UTC)
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-645-aeXS-XOkM7qCHPvHT0MvVQ-1; Thu, 28 Apr 2022 04:11:15 -0400
X-MC-Unique: aeXS-XOkM7qCHPvHT0MvVQ-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out1.suse.de (Postfix) with ESMTPS id CC1FF210E1;
 Thu, 28 Apr 2022 08:11:13 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id ADC6E13AF8;
 Thu, 28 Apr 2022 08:11:13 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap2.suse-dmz.suse.de with ESMTPSA id wQ9gKSFMamKmJQAAMHmgww
 (envelope-from <mliska@suse.cz>); Thu, 28 Apr 2022 08:11:13 +0000
Message-ID: <b39b008f-4a49-93ed-7caf-6860c938261e@suse.cz>
Date: Thu, 28 Apr 2022 10:11:13 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
To: Martin Wilck <mwilck@suse.com>, dm-devel@redhat.com
References: <ecddb51d-7666-b18b-f295-58fc0397b4c7@suse.cz>
 <b002e110e01345eaee7ad46187fa2b1980faa275.camel@suse.com>
 <568d96f5-470d-8d46-cfb7-10411cde3e9f@suse.cz>
 <1764112fec427e26bcc1304c55896277d0c11117.camel@suse.com>
From: =?UTF-8?Q?Martin_Li=c5=a1ka?= <mliska@suse.cz>
In-Reply-To: <1764112fec427e26bcc1304c55896277d0c11117.camel@suse.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
X-Mailman-Approved-At: Fri, 29 Apr 2022 08:23:40 +0000
Subject: Re: [dm-devel] [PATCH][V2] Fix possibility to redefine
 -D_FORTIFY_SOURCE macro.
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
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

T24gNC8yOC8yMiAxMDowNywgTWFydGluIFdpbGNrIHdyb3RlOgo+IEhpIE1hcnRpbiBMLAo+IAo+
IE9uIFRodSwgMjAyMi0wNC0yOCBhdCAwODo1NCArMDIwMCwgTWFydGluIExpxaFrYSB3cm90ZToK
Pj4gT24gNC8xMi8yMiAyMjoyNCwgTWFydGluIFdpbGNrIHdyb3RlOgo+Pj4gT24gVHVlLCAyMDIy
LTA0LTEyIGF0IDEzOjE5ICswMjAwLCBNYXJ0aW4gTGnFoWthIHdyb3RlOgo+Pj4+IEFzIGV4cGxh
aW5lZCBoZXJlOgo+Pj4+IGh0dHBzOi8vZ2l0aHViLmNvbS9vcGVuc3ZjL211bHRpcGF0aC10b29s
cy9pc3N1ZXMvMjkKPj4+Pgo+Pj4+IHVzaW5nIC1XcCwtRF9GT1JUSUZZX1NPVVJDRSBjYW5ub3Qg
YmUgcmVkZWZpbmVkIHdpdGgKPj4+PiAtVV9GT1JUSUZZX1NPVVJDRSAtRF9GT1JUSUZZX1NPVVJD
RT0zLgo+Pj4+Cj4+Pj4gU2lnbmVkLW9mZi1ieTogTWFydGluIExpc2thIDxtbGlza2FAc3VzZS5j
ej4KPj4+Cj4+PiBSZXZpZXdlZC1ieTogTWFydGluIFdpbGNrIDxtd2lsY2tAc3VzZS5jb20+Cj4+
Pgo+Pj4KPj4KPj4gSGkuCj4+Cj4+IE1heSBJIHBsZWFzZSBwaW5nIHRoaXM/Cj4+Cj4gCj4gSSB0
b2xkIHlvdSB0aGlzIGlzIGluIHRoZSAicXVldWUiIGJyYW5jaCBpbiBvcGVuU1VTRS9tdWx0aXBh
dGgtdG9vbHMsCj4gd2hpY2ggbWVhbnMgaXQncyBnb2luZyB0byBiZSBtZXJnZWQgaW4gdGhlIG5l
eHQgb2ZmaWNpYWwgcmVsZWFzZS4gVGhlCj4gbWFpbiByZXBvc2l0b3J5IGF0IG9wZW5zdmMgWzJd
IGlzIG9ubHkgdXBkYXRlZCBpbiBiYXRjaGVzLCB3aGVuIGEgbmV3CgpIaS4KCk9oLCBzb3JyeSwg
SSBtdXN0IGhhdmUgZm9yZ2V0IGFib3V0IGl0IDspCgpBbnl3YXksIHRoZSB0aW1pbmcgaXMgZmlu
ZSB0byBtZSEKCkNoZWVycywKTWFydGluCgo+ICJyZWxlYXNlIiBpcyBtYWRlLiBXZSBoYXZlbid0
IGRlY2lkZWQgb24gdGhlIHRpbWluZyBmb3IgdGhlIG5leHQgYmF0Y2guCj4gVGhlcmUgaXNuJ3Qg
bXVjaCBibG9ja2luZyBpdCwgc28gaXQgc2hvdWxkIGJlIHBvc3NpYmxlIHRvIGRvIGl0Cj4gcmVs
YXRpdmVseSBzb29uLCBhcyB0aW1lIGFsbG93cy4gTWF5YmUgbmV4dCB3ZWVrIChubyBwcm9taXNl
cykuCj4gCj4gSW4gdGhlIG1lYW50aW1lLCB1c2UgbXkgInF1ZXVlIiBicmFuY2gsIHdoaWNoIHJl
cHJlc2VudHMgdGhlICJyb2xsaW5nCj4gcmVsZWFzZSIgb2YgbXVsdGlwYXRoIHRvb2xzIGFuZCB3
aWxsIG1vc3QgcHJvYmFibHkganVzdCBiZSBtZXJnZWQgaW50bwo+IHRoZSBtYWluIHJlcG8gYXMt
aXMsIG9yIHNpbXBseSBhcHBseSB5b3VyIHBhdGNoIGJlZm9yZSBidWlsZGluZy4KPiAKPiAKPiBb
MV0gaHR0cHM6Ly9naXRodWIuY29tL29wZW5TVVNFL211bHRpcGF0aC10b29scy90cmVlL3F1ZXVl
Cj4gWzJdIGh0dHBzOi8vZ2l0aHViLmNvbS9vcGVuc3ZjL211bHRpcGF0aC10b29scwo+IAo+IFJl
Z2FyZHMsCj4gTWFydGluCj4gCgotLQpkbS1kZXZlbCBtYWlsaW5nIGxpc3QKZG0tZGV2ZWxAcmVk
aGF0LmNvbQpodHRwczovL2xpc3RtYW4ucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRl
dmVsCg==

