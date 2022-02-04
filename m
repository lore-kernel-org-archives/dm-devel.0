Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2357DC433EF
	for <dm-devel@archiver.kernel.org>; Mon,  7 Feb 2022 09:34:16 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-673-mfbtN_ZHN3Ck-t_pb4ClYQ-1; Mon, 07 Feb 2022 04:34:11 -0500
X-MC-Unique: mfbtN_ZHN3Ck-t_pb4ClYQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8789384BA42;
	Mon,  7 Feb 2022 09:34:07 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 66E7773164;
	Mon,  7 Feb 2022 09:34:07 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 3AA851802E34;
	Mon,  7 Feb 2022 09:34:07 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 214JgC1j007267 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 4 Feb 2022 14:42:12 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 99A7D2166BA3; Fri,  4 Feb 2022 19:42:12 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 954B62166B1A
	for <dm-devel@redhat.com>; Fri,  4 Feb 2022 19:42:09 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6FCFB10AF7C4
	for <dm-devel@redhat.com>; Fri,  4 Feb 2022 19:42:09 +0000 (UTC)
Received: from mail-lf1-f44.google.com (mail-lf1-f44.google.com
	[209.85.167.44]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-638-NDA4JWlmNOylSLJAV1G-Gg-1; Fri, 04 Feb 2022 14:42:05 -0500
X-MC-Unique: NDA4JWlmNOylSLJAV1G-Gg-1
Received: by mail-lf1-f44.google.com with SMTP id o12so14549946lfg.12;
	Fri, 04 Feb 2022 11:42:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:mime-version:references:in-reply-to:from:date
	:message-id:subject:to:cc:content-transfer-encoding;
	bh=ow88Lu4aUs6K7UkGLeI5Z43Nbv5HpcgNARMLv9ghlkU=;
	b=uW/6lSXyd9OOES9uhStPTDBFZwpw5sb+0q7GnuZdV8g0zCBOU/vrKeQkczcx8owxRV
	3k613gFamWufgO+gjRxQFInFCZDYLGzBSrzfDJIz4lsZLSKVbPvdCGHeldg9cqsWXRMM
	TNdv0Sq5YpzpRqFSD0qZbpotSUHNYpCR5dZ3Qx6vG+2Cb83iTQp0RWoJGH7iX1e672tY
	9b9Jt63j4zIKVEoZoYEtxaVvZiHq96iyQGQkv3rf/RkYfbwVPDRu+qXDSKI62g76ZXVl
	2bs2mqxvxxGMVn5f64uksJZhZ7RrI7qsr5gRByrAvigHn9ohuxIUKxyxAmDenZsvbN8G
	fx7A==
X-Gm-Message-State: AOAM530UuScytpWMKm67LuRVM1zAZwuFIoQlgdySo9mZgn3S6nO19/XZ
	JXuHVRfKUv2LxcoZnn9JxhpxliIseLMAgpKguhVjk2H9lnGfAa7e
X-Google-Smtp-Source: ABdhPJyHIm2s/AwXxjYIOHGmKgAxztwbsh5UaTIz/wUfKedoZaCqO6GHsMXWPEigismScFC9Hc7Iu0UaLWeROhbCTFw=
X-Received: by 2002:ac2:4853:: with SMTP id 19mr346407lfy.563.1644003723415;
	Fri, 04 Feb 2022 11:42:03 -0800 (PST)
MIME-Version: 1.0
References: <f0e19ae4-b37a-e9a3-2be7-a5afb334a5c3@nvidia.com>
	<20220201102122.4okwj2gipjbvuyux@mpHalley-2>
	<alpine.LRH.2.02.2202011327350.22481@file01.intranet.prod.int.rdu2.redhat.com>
In-Reply-To: <alpine.LRH.2.02.2202011327350.22481@file01.intranet.prod.int.rdu2.redhat.com>
From: Nitesh Shetty <nitheshshetty@gmail.com>
Date: Sat, 5 Feb 2022 01:11:51 +0530
Message-ID: <CAOSviJ0HmT9iwdHdNtuZ8vHETCosRMpR33NcYGVWOV0ki3EYgw@mail.gmail.com>
To: Mikulas Patocka <mpatocka@redhat.com>
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 214JgC1j007267
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Mon, 07 Feb 2022 04:33:18 -0500
Cc: "djwong@kernel.org" <djwong@kernel.org>,
	"linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
	"clm@fb.com" <clm@fb.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>,
	"osandov@fb.com" <osandov@fb.com>,
	=?UTF-8?Q?Javier_Gonz=C3=A1lez?= <javier@javigon.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	"roland@purestorage.com" <roland@purestorage.com>,
	Nitesh Shetty <nj.shetty@samsung.com>,
	"zach.brown@ni.com" <zach.brown@ni.com>,
	Chaitanya Kulkarni <chaitanyak@nvidia.com>,
	"msnitzer@redhat.com >> msnitzer@redhat.com" <msnitzer@redhat.com>,
	"josef@toxicpanda.com" <josef@toxicpanda.com>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"dsterba@suse.com" <dsterba@suse.com>,
	"kbus @imap.gmail.com>> Keith Busch" <kbusch@kernel.org>,
	"Frederick.Knight@netapp.com" <Frederick.Knight@netapp.com>,
	Jens Axboe <axboe@kernel.dk>, "tytso@mit.edu" <tytso@mit.edu>,
	Kanchan Joshi <joshi.k@samsung.com>,
	"martin.petersen@oracle.com >> Martin K. Petersen"
	<martin.petersen@oracle.com>, arnav.dawn@samsung.com,
	"jack@suse.com" <jack@suse.com>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	"lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>
Subject: Re: [dm-devel] [RFC PATCH 0/3] NVMe copy offload patches
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

T24gV2VkLCBGZWIgMiwgMjAyMiBhdCAxMjoyMyBQTSBNaWt1bGFzIFBhdG9ja2EgPG1wYXRvY2th
QHJlZGhhdC5jb20+IHdyb3RlOgo+Cj4gSGkKPgo+IEhlcmUgSSdtIHN1Ym1pdHRpbmcgdGhlIGZp
cnN0IHZlcnNpb24gb2YgTlZNZSBjb3B5IG9mZmxvYWQgcGF0Y2hlcyBhcyBhCj4gcmVxdWVzdCBm
b3IgY29tbWVudC4gVGhleSB1c2UgdGhlIHRva2VuLWJhc2VkIGFwcHJvYWNoIGFzIHdlIGRpc2N1
c3NlZCBvbgo+IHRoZSBwaG9uZSBjYWxsLgo+Cj4gVGhlIGZpcnN0IHBhdGNoIGFkZHMgZ2VuZXJp
YyBjb3B5IG9mZmxvYWQgc3VwcG9ydCB0byB0aGUgYmxvY2sgbGF5ZXIgLSBpdAo+IGFkZHMgdHdv
IG5ldyBiaW8gdHlwZXMgKFJFUV9PUF9DT1BZX1JFQURfVE9LRU4gYW5kCj4gUkVRX09QX0NPUFlf
V1JJVEVfVE9LRU4pIGFuZCBhIG5ldyBpb2N0bCBCTEtDT1BZIGFuZCBhIGtlcm5lbCBmdW5jdGlv
bgo+IGJsa2Rldl9pc3N1ZV9jb3B5Lgo+Cj4gVGhlIHNlY29uZCBwYXRjaCBhZGRzIGNvcHkgb2Zm
bG9hZCBzdXBwb3J0IHRvIHRoZSBOVk1lIHN1YnN5c3RlbS4KPgo+IFRoZSB0aGlyZCBwYXRjaCBp
bXBsZW1lbnRzIGEgIm52bWUtZGVidWciIGRyaXZlciAtIGl0IGlzIHNpbWlsYXIgdG8KPiAic2Nz
aS1kZWJ1ZyIsIGl0IHNpbXVsYXRlcyBhIG52bWUgaG9zdCBjb250cm9sbGVyLCBpdCBrZWVwcyBk
YXRhIGluIG1lbW9yeQo+IGFuZCBpdCBzdXBwb3J0cyBjb3B5IG9mZmxvYWQgYWNjb3JkaW5nIHRv
IE5WTWUgQ29tbWFuZCBTZXQgU3BlY2lmaWNhdGlvbgo+IDEuMGEuICh0aGVyZSBhcmUgbm8gaGFy
ZHdhcmUgb3Igc29mdHdhcmUgaW1wbGVtZW50YXRpb25zIHN1cHBvcnRpbmcgY29weQo+IG9mZmxv
YWQgc28gZmFyLCBzbyBJIGltcGxlbWVudGVkIGl0IGluIG52bWUtZGVidWcpCj4KPiBUT0RPOgo+
ICogaW1wbGVtZW50IGNvcHkgb2ZmbG9hZCBpbiBkZXZpY2UgbWFwcGVyIGxpbmVhciB0YXJnZXQK
PiAqIGltcGxlbWVudCBjb3B5IG9mZmxvYWQgaW4gc29mdHdhcmUgTlZNZSB0YXJnZXQgZHJpdmVy
CgpXZSBoYWQgYSBzZXJpZXMgdGhhdCBhZGRzIHRoZXNlIHR3byBlbGVtZW50cwpodHRwczovL2dp
dGh1Yi5jb20vbml0ZXNoLXNoZXR0eS9saW51eF9jb3B5X29mZmxvYWQvdHJlZS9tYWluL3YxCgpP
dmVyYWxsIHNlcmllcyBzdXBwb3J0cyDigJMKMS4gICAgTXVsdGktc291cmNlL2Rlc3RpbmF0aW9u
IGludGVyZmFjZSh5ZXMsIGl0IGRvZXMgYWRkIGNvbXBsZXhpdHkKYnV0IEdDIHVzZS1jYXNlIG5l
ZWRzIGl0KQoyLiAgICBDb3B5LWVtdWxhdGlvbiBhdCBibG9jay1sYXllcgozLiAgICBEbS1saW5l
YXIgYW5kIGRtLWtjb3B5ZCBzdXBwb3J0IChmb3IgY2FzZXMgbm90IHJlcXVpcmluZyBzcGxpdCkK
NC4gICAgTnZtZXQgc3VwcG9ydCAoZm9yIGJsb2NrIGFuZCBmaWxlIGJhY2tlbmQpCgpUaGVzZSBw
YXRjaGVzIGRlZmluaXRlbHkgbmVlZCBtb3JlIGZlZWRiYWNrLiBJZiBsaW5rcyBhcmUgaGFyZCB0
byByZWFkLAp3ZSBjYW4gc2VuZCBhbm90aGVyIFJGQyBpbnN0ZWFkLiBCdXQgYmVmb3JlIHRoYXQg
aXQgd291bGQgYmUgZ3JlYXQgdG8gaGF2ZSB5b3VyCmlucHV0cyBvbiB0aGUgcGF0aCBmb3J3YXJk
LgpCdXQgYmVmb3JlIHRoYXQgaXQgd291bGQgYmUgZ3JlYXQgdG8gaGF2ZSB5b3VyIGlucHV0cyBv
biB0aGUgcGF0aCBmb3J3YXJkLgoKUFM6IFRoZSBwYXlsb2FkLXNjaGVtZSBpbiB5b3VyIHNlcmll
cyBpcyBwYXJ0aWN1bGFybHkgaW50ZXJlc3RpbmcgYW5kCnNpbXBsaWZ5aW5nIHBsdW1iaW5nLCBz
byB5b3UgbWlnaHQgbm90aWNlIHRoYXQgYWJvdmUgcGF0Y2hlcyBib3Jyb3cgdGhhdAoKPiAqIG1h
a2UgaXQgcG9zc2libGUgdG8gY29tcGxldGUgUkVRX09QX0NPUFlfV1JJVEVfVE9LRU4gYmlvcyBh
c3luY2hyb25vdXNseQpQYXRjaFswXSBzdXBwb3J0IGFzeW5jaHJvbm91cyBjb3B5IHdyaXRlLGlm
IG11bHRpIGRzdC9zcmMgcGF5bG9hZCBpcyBzZW50LgoKWzBdIGh0dHBzOi8vZ2l0aHViLmNvbS9u
aXRlc2gtc2hldHR5L2xpbnV4X2NvcHlfb2ZmbG9hZC9ibG9iL21haW4vdjEvMDAwMy1ibG9jay1B
ZGQtY29weS1vZmZsb2FkLXN1cHBvcnQtaW5mcmFzdHJ1Y3R1cmUucGF0Y2gKCi0tIE5pdGVzaAoK
Ci0tCmRtLWRldmVsIG1haWxpbmcgbGlzdApkbS1kZXZlbEByZWRoYXQuY29tCmh0dHBzOi8vbGlz
dG1hbi5yZWRoYXQuY29tL21haWxtYW4vbGlzdGluZm8vZG0tZGV2ZWw=

