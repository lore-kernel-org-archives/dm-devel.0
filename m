Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5B6F5C83003
	for <dm-devel@archiver.kernel.org>; Wed,  7 Jun 2023 02:15:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686104125;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=HlcNvizODv/oHK7YzeS7qY7rZWRpnt7m8t+TBQg2Dqc=;
	b=XG9JkAbvZuOT7KnbtwUw9Lb9rM8aB+m0LqFEbrpPXGD2iGxhRQkpm//TKPyPTP1Me8ZlZh
	/JRq1Uj43aat0bP1YbDij1Sx5XRF2EWLYIoZVbqNoLRuuCMLlxQIQIGF2EhVW4A1JcpJPW
	RKZ8dViDPDMFCWmJ5I/TZ6c7gr2tCRA=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-119-8cyr3q8KP4abx1sH60k07A-1; Tue, 06 Jun 2023 22:15:21 -0400
X-MC-Unique: 8cyr3q8KP4abx1sH60k07A-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 447C33C01B80;
	Wed,  7 Jun 2023 02:15:20 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id E79BB140EBB8;
	Wed,  7 Jun 2023 02:15:19 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id C4B9E19465BD;
	Wed,  7 Jun 2023 02:15:19 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id D5B2819465BA
 for <dm-devel@listman.corp.redhat.com>; Wed,  7 Jun 2023 02:15:18 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id B4569140E956; Wed,  7 Jun 2023 02:15:18 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id AC855140E954
 for <dm-devel@redhat.com>; Wed,  7 Jun 2023 02:15:18 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8B0F2380392E
 for <dm-devel@redhat.com>; Wed,  7 Jun 2023 02:15:18 +0000 (UTC)
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com
 [209.85.214.182]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-15-xZhnPq89Pmqu4FrFFsImFw-1; Tue, 06 Jun 2023 22:15:17 -0400
X-MC-Unique: xZhnPq89Pmqu4FrFFsImFw-1
Received: by mail-pl1-f182.google.com with SMTP id
 d9443c01a7336-1b24b34b59fso5059835ad.3
 for <dm-devel@redhat.com>; Tue, 06 Jun 2023 19:15:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1686104116; x=1688696116;
 h=in-reply-to:content-transfer-encoding:content-disposition
 :mime-version:references:message-id:subject:cc:to:from:date
 :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=oQUlCOcqt0tuXvcUCaoZv+EjOka/kZ7fKStDDBCleig=;
 b=Szb71cUnJts66TUF/idMPCQD1eg51O/NTThfPL9GW5w03x9e/Y0fBphSfG4zNgg01e
 cRo8/mvVzIsLgT2KjMei+nIcI731g6lAYOWxxC8VD2QyN2rqTqmiNlNRTv5hRrGxjKgA
 2sryTe98BKPi5AeSRV6004qwY1nViwGFqV1txcB0MCkuyiHg8C2XCweAV6zZiQR2zb+f
 SjsTFIqKjmuU7HlOYAEXlgbukwfcARtBcSR8rvm5+qE9SPF4gpCiuk6/BF/s9P4teWU5
 7GEwIA7g00BvMG2dBC0nJy94PA9Uh8IIHS7XDcG1J3KU/v68TEJC/DNsOX1uEiBsoR+1
 wBrg==
X-Gm-Message-State: AC+VfDzj5qKniZj/mILcKemJjRctEP0W+cc+sEbszlpf8nu+nLMBjf+C
 FuTR9E7MRgW1AL3MKgYa0PMXkg==
X-Google-Smtp-Source: ACHHUZ6vvabNin59tYSUj++K9GAS9dwnlbxvpk5BtcC6SjhWGVfnYwarfgRhemu10fEWP5UF/cCASw==
X-Received: by 2002:a17:902:db0f:b0:1b0:4bc7:31ee with SMTP id
 m15-20020a170902db0f00b001b04bc731eemr3975802plx.32.1686104116012; 
 Tue, 06 Jun 2023 19:15:16 -0700 (PDT)
Received: from dread.disaster.area (pa49-179-79-151.pa.nsw.optusnet.com.au.
 [49.179.79.151]) by smtp.gmail.com with ESMTPSA id
 p21-20020a170902ead500b00199203a4fa3sm9173051pld.203.2023.06.06.19.15.15
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 06 Jun 2023 19:15:15 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
 (envelope-from <david@fromorbit.com>) id 1q6ihc-008ieJ-1f;
 Wed, 07 Jun 2023 12:15:12 +1000
Date: Wed, 7 Jun 2023 12:15:12 +1000
From: Dave Chinner <david@fromorbit.com>
To: Sarthak Kukreti <sarthakkukreti@chromium.org>
Message-ID: <ZH/oMK7BoBo8a3Hu@dread.disaster.area>
References: <CAJ0trDbspRaDKzTzTjFdPHdB9n0Q9unfu1cEk8giTWoNu3jP8g@mail.gmail.com>
 <ZHFEfngPyUOqlthr@dread.disaster.area>
 <CAJ0trDZJQwvAzngZLBJ1hB0XkQ1HRHQOdNQNTw9nK-U5i-0bLA@mail.gmail.com>
 <ZHYB/6l5Wi+xwkbQ@redhat.com>
 <CAJ0trDaUOevfiEpXasOESrLHTCcr=oz28ywJU+s+YOiuh7iWow@mail.gmail.com>
 <ZHYWAGmKhwwmTjW/@redhat.com>
 <CAG9=OMMnDfN++-bJP3jLmUD6O=Q_ApV5Dr392_5GqsPAi_dDkg@mail.gmail.com>
 <ZHqOvq3ORETQB31m@dread.disaster.area>
 <ZHti/MLnX5xGw9b7@redhat.com>
 <CAG9=OMNv80fOyVixEY01XESnOFzYyfj9j8etHMq_Ap52z4UWNQ@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAG9=OMNv80fOyVixEY01XESnOFzYyfj9j8etHMq_Ap52z4UWNQ@mail.gmail.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
Subject: Re: [dm-devel] [PATCH v7 0/5] Introduce provisioning primitives
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
Cc: Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@infradead.org>,
 Joe Thornber <thornber@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>,
 "Darrick J. Wong" <djwong@kernel.org>, Jason Wang <jasowang@redhat.com>,
 Bart Van Assche <bvanassche@google.com>, Mike Snitzer <snitzer@kernel.org>,
 linux-kernel@vger.kernel.org, Joe Thornber <ejt@redhat.com>,
 linux-block@vger.kernel.org, dm-devel@redhat.com,
 Andreas Dilger <adilger.kernel@dilger.ca>,
 Stefan Hajnoczi <stefanha@redhat.com>, linux-fsdevel@vger.kernel.org,
 Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org,
 Brian Foster <bfoster@redhat.com>, Alasdair Kergon <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: fromorbit.com
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

T24gTW9uLCBKdW4gMDUsIDIwMjMgYXQgMDI6MTQ6NDRQTSAtMDcwMCwgU2FydGhhayBLdWtyZXRp
IHdyb3RlOgo+IE9uIFNhdCwgSnVuIDMsIDIwMjMgYXQgODo1N+KAr0FNIE1pa2UgU25pdHplciA8
c25pdHplckBrZXJuZWwub3JnPiB3cm90ZToKPiA+IE9uIEZyaSwgSnVuIDAyIDIwMjMgYXQgIDg6
NTJQIC0wNDAwLAo+ID4gRGF2ZSBDaGlubmVyIDxkYXZpZEBmcm9tb3JiaXQuY29tPiB3cm90ZToK
PiA+ID4gT24gRnJpLCBKdW4gMDIsIDIwMjMgYXQgMTE6NDQ6MjdBTSAtMDcwMCwgU2FydGhhayBL
dWtyZXRpIHdyb3RlOgo+ID4gPiA+ID4gVGhlIG9ubHkgd2F5IHRvIGRpc3RpbnF1aXNoIHRoZSBj
YWxsZXIgKGJldHdlZW4gb24tYmVoYWxmIG9mIHVzZXIgZGF0YQo+ID4gPiA+ID4gdnMgWEZTIG1l
dGFkYXRhKSB3b3VsZCBiZSBSRVFfTUVUQT8KPiA+ID4gPiA+Cj4gPiA+ID4gPiBTbyBzaG91bGQg
ZG0tdGhpbnAgaGF2ZSBhIFJFUV9NRVRBLWJhc2VkIGRpc3RpbmN0aW9uPyBPciBqdXN0IHRyZWF0
Cj4gPiA+ID4gPiBhbGwgUkVRX09QX1BST1ZJU0lPTiB0aGUgc2FtZT8KPiA+ID4gPiA+Cj4gPiA+
ID4gSSdtIGluIGZhdm9yIG9mIGEgUkVRX01FVEEtYmFzZWQgZGlzdGluY3Rpb24uCj4gPiA+Cj4g
PiA+IFdoeT8gV2hhdCAqcmVxdWlyZW1lbnQqIGlzIGRyaXZpbmcgdGhlIG5lZWQgZm9yIHRoaXMg
ZGlzdGluY3Rpb24/Cj4gPgo+ID4gVGhpbmsgSSBhbnN3ZXJlZCB0aGF0IGFib3ZlLCBYRlMgZGVs
YWxsb2MgYWNjb3VudGluZyBwYXJpdHkgb24gdGhpbnAuCj4gPgo+IEkgYWN0dWFsbHkgaGFkIGEg
ZmV3IGRpZmZlcmVudCB1c2UtY2FzZXMgaW4gbWluZCAoYXBhcnQgZnJvbSB0aGUgdXNlcgo+IGRh
dGEgcHJvdmlzaW9uaW5nICdmZWFyJyB0aGF0IHlvdSBwb2ludGVkIG91dCk6IGluIGVzc2VuY2Us
IHRoZXJlIGFyZQo+IGNhc2VzIHdoZXJlIHVzZXJzcGFjZSB3b3VsZCBiZW5lZml0IGZyb20gaGF2
aW5nIG1vcmUgY29udHJvbCBvdmVyIGhvdwo+IG11Y2ggc3BhY2UgYSBzbmFwc2hvdCB0YWtlczoK
PiAKPiAxKSBJbiB0aGUgb3JpZ2luYWwgUkZDIHBhdGNoc2V0IFsxXSwgSSBhbGx1ZGVkIHRvIHRo
aXMgYmVpbmcgYQo+IG1lY2hhbmlzbSBmb3IgcHJlLWFsbG9jYXRpbmcgc3BhY2UgZm9yIHByZXNl
cnZpbmcgc3BhY2UgZm9yIHRoaW4KPiBsb2dpY2FsIHZvbHVtZXMuIFRoZSB1c2UtY2FzZSBJJ2Qg
bGlrZSB0byBleHBsb3JlIGlzIGRlbHRhIHVwZGF0YWJsZQo+IHJlYWQtb25seSBmaWxlc3lzdGVt
cyBzaW1pbGFyIHRvIHN5c3RlbWQgc3lzdGVtIGV4dGVuc2lvbnMgWzJdOiBJbgo+IGVzc2VuY2U6
Cj4gYSkgUHJlc2VydmUgc3BhY2UgZm9yIGEgJ2Jhc2UnIHRoaW4gbG9naWNhbCB2b2x1bWUgdGhh
dCB3aWxsIGNvbnRhaW4gYQo+IHJlYWQtb25seSBmaWxlc3lzdGVtIG9uIG92ZXItdGhlLWFpciBp
bnN0YWxsYXRpb246IGZvciBmaWxlc3lzdGVtcwo+IGxpa2Ugc3F1YXNoZnMgYW5kIGVyb2ZzLCBw
cmV0dHkgbXVjaCB0aGUgZW50aXJlIGltYWdlIGlzIGEgY29tcHJlc3NlZAo+IGZpbGUgdGhhdCBJ
J2QgbGlrZSB0byByZXNlcnZlIHNwYWNlIGZvciBiZWZvcmUgaW5zdGFsbGF0aW9uLgo+IGIpIEJl
Zm9yZSB1cGRhdGUsIGNyZWF0ZSBhIHRoaW4gc25hcHNob3QgYW5kIHByZXNlcnZlIGVub3VnaCBz
cGFjZSB0bwo+IGVuc3VyZSB0aGF0IGEgZGVsdGEgdXBkYXRlIHdpbGwgc3VjY2VlZCAoZWcuIGJs
b2NrIGxldmVsIGRpZmYgb2YgdGhlCj4gYmFzZSBpbWFnZSkuIFRoZW4sIHRoZSB1cGRhdGUgaXMg
Z3VhcmFudGVlZCB0byBoYXZlIGRpc2sgc3BhY2UgdG8KPiBzdWNjZWVkIChzaW1pbGFyIHRvIHRo
ZSBBLUIgdXBkYXRlIGd1YXJhbnRlZXMgb24gQ2hyb21lT1MpLiBPbgo+IHN1Y2Nlc3MsIHdlIG1l
cmdlIHRoZSBzbmFwc2hvdCBhbmQgcmVzZXJ2ZSBhbiB1cGRhdGUgc25hcHNob3QgZm9yIHRoZQo+
IG5leHQgcG9zc2libGUgdXBkYXRlLiBPbiBmYWlsdXJlLCB3ZSBkcm9wIHRoZSBzbmFwc2hvdC4K
ClNvdW5kcyB2ZXJ5IHNpbWlsYXIgdG8gdGhlIGZ1bmN0aW9uYWxpdHkgYmxrc25hcCBpcyBzdXBw
b3NlZCB0bwpwcm92aWRlLi4uLgoKaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvbGludXgtZnNkZXZl
bC8yMDIzMDQwNDE0MDgzNS4yNTE2Ni0xLXNlcmdlaS5zaHRlcGFAdmVlYW0uY29tLwoKCj4gMikg
VGhlIG90aGVyIGlkZWEgSSB3YW50ZWQgdG8gZXhwbG9yZSB3YXMgcm9sbGJhY2sgcHJvdGVjdGlv
biBmb3IKPiBzdGF0ZWZ1bCBmaWxlc3lzdGVtIGZlYXR1cmVzOiBpbiBlc3NlbmNlLCBpZiBhbiB1
cGRhdGUgZnJvbSBrZXJuZWwgNC54Cj4gdG8gNS55IGZhaWxlZCB2ZXJ5IHF1aWNrbHkgKGR1ZSB0
byB1bnJlbGF0ZWQgcmVhc29ucykgYW5kIHdlIGVuYWJsZWQKPiBzb21lIHN0YXRlZnVsIGZpbGVz
eXN0ZW0gZmVhdHVyZXMgdGhhdCBhcmUgb25seSBzdXBwb3J0ZWQgb24gNS55LCB3ZSdkCj4gYmUg
YWJsZSB0byByb2xsYmFjayB0byA0LnggaWYgd2UgdXNlZCBzaG9ydC1saXZlZCBzbmFwc2hvdHMg
KGluIHRoZQo+IENocm9taXVtT1Mgd29ybGQsIHRoZSBsaWZldGltZSBvZiB0aGVzZSBzbmFwc2hv
dHMgd291bGQgYmUgPCAxMHMgcGVyCj4gYm9vdCkuCgpOb3Qgc3VyZSB0aGF0IGJsa3NuYXAgaGFz
IGEgInJvbGwgb3JpZ2luIGJhY2sgdG8gcmVhZC1vbmx5IHNuYXBzaG90IgpmZWF0dXJlIHlldCwg
YnV0IHRoYXQncyB3aGF0IHlvdSdkIG5lZWQgZm9yIHRoaXMuIGkuZS4gb24gc3VjY2VzcywKZHJv
cCB0aGUgc25hcHNob3QuIE9uIGZhaWx1cmUsICJyb2xsIG9yaWdpbiBiYWNrIHRvIHNuYXBzaG90
IGFuZApyZWJvb3QiLgoKQ2hlZXJzLAoKRGF2ZS4KLS0gCkRhdmUgQ2hpbm5lcgpkYXZpZEBmcm9t
b3JiaXQuY29tCgotLQpkbS1kZXZlbCBtYWlsaW5nIGxpc3QKZG0tZGV2ZWxAcmVkaGF0LmNvbQpo
dHRwczovL2xpc3RtYW4ucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRldmVsCg==

