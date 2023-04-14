Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8AEADC77B73
	for <dm-devel@archiver.kernel.org>; Fri, 14 Apr 2023 18:15:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1681496102;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=H9604o3tho3VpSktFR8ojzuyrIpXysJ73eb6Zglc0S4=;
	b=Eiht8KomQmltw8ZdgHjc2qr5u8f11fxnCSq9p7MrfyTU2gsS3PcGtrAEGz8JxjOQ7KTPet
	TGmVVZAyxt4WJbTo1aQzgfl06VHmA2B90BpRkmx9edatx7EM4Vnj3+ANq82e+OdbytHcwD
	kZtX9dpbtex6axM3eQVzuuB089GJaEo=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-501-cZ6O5ztCPd-0y9YJFnbCDw-1; Fri, 14 Apr 2023 14:14:59 -0400
X-MC-Unique: cZ6O5ztCPd-0y9YJFnbCDw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6F7B8185A792;
	Fri, 14 Apr 2023 18:14:57 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 6A86F1121320;
	Fri, 14 Apr 2023 18:14:55 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id AB23D194658C;
	Fri, 14 Apr 2023 18:14:53 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 7527E1946589
 for <dm-devel@listman.corp.redhat.com>; Fri, 14 Apr 2023 18:14:52 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 1E90840C6E71; Fri, 14 Apr 2023 18:14:52 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 1785340C6E70
 for <dm-devel@redhat.com>; Fri, 14 Apr 2023 18:14:52 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id F031F101A531
 for <dm-devel@redhat.com>; Fri, 14 Apr 2023 18:14:51 +0000 (UTC)
Received: from mail-qv1-f48.google.com (mail-qv1-f48.google.com
 [209.85.219.48]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-608-uN5N8VKkP6ioEdL7O1AWdQ-1; Fri, 14 Apr 2023 14:14:50 -0400
X-MC-Unique: uN5N8VKkP6ioEdL7O1AWdQ-1
Received: by mail-qv1-f48.google.com with SMTP id e9so14113399qvv.2
 for <dm-devel@redhat.com>; Fri, 14 Apr 2023 11:14:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1681496090; x=1684088090;
 h=in-reply-to:content-transfer-encoding:content-disposition
 :mime-version:references:message-id:subject:cc:to:from:date
 :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=7nJQ/Y9J49ZegPKB8YDx6kUTeaR5VGKNsyTpo7amzJY=;
 b=EIpZ3Als0QS2ZxifiKysUQqG9Y2MrKIn7MlLWA3FG0hgSOUhRWeOKFD+rKZef90oLB
 cafNHV7vM9QtSZzuyyv3A7SpXf0bVI1esRWGZDpXPTygu+WGJZfaK5W8ENjMca0AO4k9
 /Lxlsk1kGjA2xlx6sTxZWEsLauicA8azrQCVHDPgD5H1LhsJQkWy3V4H1LOudhe8CADA
 5dX5N/nhssgNBcuy9FykYMECHPl4KE1lWVlC+liuTZXnnuvbWAGwDlPbF9bNA6R+34Xb
 tfu5I9y+GAZ3f/ILkYVCRjcXZSsf+Wg8oYNk4Dmv0ESIuIhmNmWUd8POi99kbb84YS0e
 e8SA==
X-Gm-Message-State: AAQBX9c1f3M5pXzp6dca/ohBrNZU+vp7ZK0y43r/3EAY84bHhsoE7FJW
 6algcncUsH1WBZ6OgpM60YcVvqY=
X-Google-Smtp-Source: AKy350aBWPFHkYsTqcbjhT+BLekXSdnuSITWMCofPdO8r8eSxwXlme3SBrswbw26osXgHeiptCRusA==
X-Received: by 2002:ad4:5baf:0:b0:5ef:50ea:2914 with SMTP id
 15-20020ad45baf000000b005ef50ea2914mr4886152qvq.22.1681496090079; 
 Fri, 14 Apr 2023 11:14:50 -0700 (PDT)
Received: from localhost (pool-68-160-166-30.bstnma.fios.verizon.net.
 [68.160.166.30]) by smtp.gmail.com with ESMTPSA id
 fb9-20020ad44f09000000b005e9a1409458sm1277586qvb.71.2023.04.14.11.14.49
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 14 Apr 2023 11:14:49 -0700 (PDT)
Date: Fri, 14 Apr 2023 14:14:48 -0400
From: Mike Snitzer <snitzer@kernel.org>
To: Sarthak Kukreti <sarthakkukreti@chromium.org>,
 Joe Thornber <thornber@redhat.com>
Message-ID: <ZDmYGO7zPqu5y0HW@redhat.com>
References: <20221229071647.437095-1-sarthakkukreti@chromium.org>
 <20230414000219.92640-1-sarthakkukreti@chromium.org>
 <20230414000219.92640-3-sarthakkukreti@chromium.org>
 <CAJ0trDbyqoKEDN4kzcdn+vWhx+hk6pTM4ndf-E02f3uT9YZ3Uw@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAJ0trDbyqoKEDN4kzcdn+vWhx+hk6pTM4ndf-E02f3uT9YZ3Uw@mail.gmail.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
Subject: Re: [dm-devel] [PATCH v3 2/3] dm: Add support for block provisioning
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
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
 Theodore Ts'o <tytso@mit.edu>, "Michael S. Tsirkin" <mst@redhat.com>,
 sarthakkukreti@google.com, "Darrick J. Wong" <djwong@kernel.org>,
 Jason Wang <jasowang@redhat.com>, Bart Van Assche <bvanassche@google.com>,
 linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
 dm-devel@redhat.com, Andreas Dilger <adilger.kernel@dilger.ca>,
 Daniil Lunev <dlunev@google.com>, Stefan Hajnoczi <stefanha@redhat.com>,
 linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
 Brian Foster <bfoster@redhat.com>, Alasdair Kergon <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

T24gRnJpLCBBcHIgMTQgMjAyMyBhdCAgOTozMlAgLTA0MDAsCkpvZSBUaG9ybmJlciA8dGhvcm5i
ZXJAcmVkaGF0LmNvbT4gd3JvdGU6Cgo+IE9uIEZyaSwgQXByIDE0LCAyMDIzIGF0IDc6NTLigK9B
TSBTYXJ0aGFrIEt1a3JldGkgPHNhcnRoYWtrdWtyZXRpQGNocm9taXVtLm9yZz4KPiB3cm90ZToK
PiAKPiA+IEFkZCBzdXBwb3J0IHRvIGRtIGRldmljZXMgZm9yIFJFUV9PUF9QUk9WSVNJT04uIFRo
ZSBkZWZhdWx0IG1vZGUKPiA+IGlzIHRvIHBhc3N0aHJvdWdoIHRoZSByZXF1ZXN0IHRvIHRoZSB1
bmRlcmx5aW5nIGRldmljZSwgaWYgaXQKPiA+IHN1cHBvcnRzIGl0LiBkbS10aGlucG9vbCB1c2Vz
IHRoZSBwcm92aXNpb24gcmVxdWVzdCB0byBwcm92aXNpb24KPiA+IGJsb2NrcyBmb3IgYSBkbS10
aGluIGRldmljZS4gZG0tdGhpbnBvb2wgY3VycmVudGx5IGRvZXMgbm90Cj4gPiBwYXNzIHRocm91
Z2ggUkVRX09QX1BST1ZJU0lPTiB0byB1bmRlcmx5aW5nIGRldmljZXMuCj4gPgo+ID4gRm9yIHNo
YXJlZCBibG9ja3MsIHByb3Zpc2lvbiByZXF1ZXN0cyB3aWxsIGJyZWFrIHNoYXJpbmcgYW5kIGNv
cHkgdGhlCj4gPiBjb250ZW50cyBvZiB0aGUgZW50aXJlIGJsb2NrLgo+ID4KPiAKPiBJIHNlZSB0
d28gaXNzdWUgd2l0aCB0aGlzIHBhdGNoOgo+IAo+IGkpIFlvdSB1c2UgZ2V0X2Jpb19ibG9ja19y
YW5nZSgpIHRvIHNlZSB3aGljaCBibG9ja3MgdGhlIHByb3Zpc2lvbiBiaW8KPiBjb3ZlcnMuICBC
dXQgdGhpcyBmdW5jdGlvbiBvbmx5IHJldHVybnMKPiBjb21wbGV0ZSBibG9ja3MgdGhhdCBhcmUg
Y292ZXJlZCAoaXQgd2FzIGRlc2lnbmVkIGZvciBkaXNjYXJkKS4gIFVubGlrZQo+IGRpc2NhcmQs
IHByb3Zpc2lvbiBpcyBub3QgYSBoaW50IHNvIHRob3NlCj4gcGFydGlhbCBibG9ja3Mgd2lsbCBu
ZWVkIHRvIGJlIHByb3Zpc2lvbmVkIHRvby4KPiAKPiBpaSkgWW91IGFyZSBzZXR0aW5nIG9mZiBt
dWx0aXBsZSBkbV90aGluX25ld19tYXBwaW5nIG9wZXJhdGlvbnMgaW4gZmxpZ2h0Cj4gYXQgb25j
ZS4gIEVhY2ggb2YgdGhlc2UgcmVjZWl2ZXMKPiB0aGUgc2FtZSB2aXJ0X2NlbGwgYW5kIGZyZWVz
IGl0ICB3aGVuIGl0IGNvbXBsZXRlcy4gIFNvIEkgdGhpbmsgd2UgaGF2ZQo+IG11bHRpcGxlIGZy
ZWVzIG9jY3VyaW5nPyAgSW4gYWRkaXRpb24geW91IGFsc28KPiByZWxlYXNlIHRoZSBjZWxsIHlv
dXJzZWxmIGluIHByb2Nlc3NfcHJvdmlzaW9uX2NlbGwoKS4gIEZpeGluZyB0aGlzIGlzIG5vdAo+
IHRyaXZpYWwsIHlvdSdsbCBuZWVkIHRvIHJlZmVyZW5jZSBjb3VudCB0aGUgY2VsbHMsCj4gYW5k
IGFnZ3JlZ2F0ZSB0aGUgbWFwcGluZyBvcGVyYXRpb24gcmVzdWx0cy4KPiAKPiBJIHRoaW5rIGl0
IHdvdWxkIGJlIGZhciBlYXNpZXIgdG8gcmVzdHJpY3QgdGhlIHNpemUgb2YgdGhlIHByb3Zpc2lv
biBiaW8gdG8KPiBiZSBubyBiaWdnZXIgdGhhbiBvbmUgdGhpbnAgYmxvY2sgKGFzIHdlIGRvIGZv
ciBub3JtYWwgaW8pLiAgVGhpcyB3YXkgZG0KPiBjb3JlIGNhbiBzcGxpdCB0aGUgYmlvcywgY2hh
aW4gdGhlIGNoaWxkIGJpb3MgcmF0aGVyIHRoYW4gaGF2aW5nIHRvCj4gcmVmZXJlbmNlIGNvdW50
IG1hcHBpbmcgb3BzLCBhbmQgYWdncmVnYXRlIHRoZSByZXN1bHRzLgoKSSBoYXBwZW5lZCB0byBi
ZSBsb29raW5nIGF0IGltcGxlbWVudGluZyBXUklURV9aRVJPRVMgc3VwcG9ydCBmb3IgRE0KdGhp
bnAgeWVzdGVyZGF5IGFuZCByZWFjaGVkIHRoZSBzYW1lIGNvbmNsdXNzaW9uIHJlbGF0aXZlIHRv
IGl0IChib3RoCm9mIEpvZSdzIHBvaW50cyBhYm92ZSwgZm9yIG1lICJpaSkiIHdhczogdGhlIGRt
LWJpby1wcmlzb24tdjEgcmFuZ2UKbG9ja2luZyB3ZSBkbyBmb3IgZGlzY2FyZHMgbmVlZHMgd29y
ayBmb3Igb3RoZXIgdHlwZXMgb2YgSU8pLgoKV2UgY2FuIHdvcmsgdG8gbWFrZSBSRVFfT1BfUFJP
VklTSU9OIHNwYW5uaW5nIG11bHRpcGxlIHRoaW5wIGJsb2Nrcwpwb3NzaWJsZSBhcyBmb2xsb3ct
b24gb3B0aW1pemF0aW9uOyBidXQgaW4gdGhlIG5lYXItdGVybSBETSB0aGlucApuZWVkcyBSRVFf
T1BfUFJPVklTSU9OIHRvIGJlIHNwbGl0IG9uIGEgdGhpbnAgYmxvY2sgYm91bmRhcnkuCgpUaGlz
IHNwbGl0dGluZyBjYW4gYmUgYXNzaXN0ZWQgYnkgYmxvY2sgY29yZSBpbiB0ZXJtcyBvZiBhIG5l
dwoncHJvdmlzaW9uX2dyYW51bGFyaXR5JyAod2hpY2ggZm9yIHRoaW5wLCBpdCdkIGJlIHNldCB0
byB0aGUgdGhpbnAKYmxvY2tzaXplKS4gIEJ1dCBJIGRvbid0IGtub3cgdGhhdCB3ZSBuZWVkIHRv
IGdvIHRoYXQgZmFyIChJJ20KdGhpbmtpbmcgaXRzIGZpbmUgdG8gaGF2ZSBETSBkbyB0aGUgc3Bs
aXR0aW5nIGl0IG5lZWRzIGFuZCBvbmx5CmVsZXZhdGUgcmVsYXRlZCBjb2RlIHRvIGJsb2NrIGNv
cmUgaWYvd2hlbiBuZWVkZWQgaW4gdGhlIGZ1dHVyZSkuCgpETSBjb3JlIGNhbiB0YWtlIG9uIGNv
bmRpdGlvbmFsbHkgaW1wb3NpbmcgaXRzIG1heF9pb19sZW4oKSB0byBoYW5kbGUKc3BsaXR0aW5n
IFJFUV9PUF9QUk9WSVNJT04gYXMgbmVlZGVkIG9uIGEgcGVyLXRhcmdldCBiYXNpcy4gVGhpcyBE
TQpjb3JlIGNvbW1pdCBJJ3ZlIHN0YWdlZCBmb3IgNi40IG1ha2VzIHRoaXMgcXVpdGUgYSBzaW1w
bGUgY2hhbmdlOgpodHRwczovL2dpdC5rZXJuZWwub3JnL3B1Yi9zY20vbGludXgva2VybmVsL2dp
dC9kZXZpY2UtbWFwcGVyL2xpbnV4LWRtLmdpdC9jb21taXQvP2g9ZG0tNi40JmlkPTEzZjZmYWNm
M2ZhZWVkMzRjYTM4MWFlZjRjOWIxNTNjN2FlZDM5NzIKClNvIHBsZWFzZSByZWJhc2Ugb24gbGlu
dXgtZG0uZ2l0J3MgZG0tNi40IGJyYW5jaCwgYW5kIGZvcgpSRVFfT1BfUFJPVklTSU9OIGRtLmM6
X19wcm9jZXNzX2Fibm9ybWFsX2lvKCkgeW91J2QgYWRkIHRoaXM6CgoJY2FzZSBSRVFfT1BfUFJP
VklTSU9OOgogICAgICAgICAgICAgICAgbnVtX2Jpb3MgPSB0aS0+bnVtX3Byb3Zpc2lvbl9iaW9z
OwogICAgICAgICAgICAgICAgaWYgKHRpLT5tYXhfcHJvdmlzaW9uX2dyYW51bGFyaXR5KQogICAg
ICAgICAgICAgICAgICAgICAgICBtYXhfZ3JhbnVsYXJpdHkgPSBsaW1pdHMtPm1heF9wcm92aXNp
b25fc2VjdG9yczsKICAgICAgICAgICAgICAgIGJyZWFrOwoKSSdsbCByZXBseSBhZ2FpbiBsYXRl
ciB0b2RheSAodG8gcGF0Y2ggMidzIGFjdHVhbCBjb2RlIGNoYW5nZXMpLApiZWNhdXNlIEkgY2F1
Z2h0IGF0IGxlYXN0IG9uZSBvdGhlciB0aGluZyB3b3J0aCBtZW50aW9uaW5nLgoKVGhhbmtzLApN
aWtlCgotLQpkbS1kZXZlbCBtYWlsaW5nIGxpc3QKZG0tZGV2ZWxAcmVkaGF0LmNvbQpodHRwczov
L2xpc3RtYW4ucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRldmVsCg==

