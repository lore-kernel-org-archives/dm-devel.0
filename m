Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9FBAFC4708E
	for <dm-devel@archiver.kernel.org>; Wed,  7 Dec 2022 13:37:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1670420240;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=01qUKFGL4FMFurzoJNY0qojmnf01vdgGQnpm4fIakP8=;
	b=epLPsYV075wtg0ZMmcdLN051MoZNgOlyksqXwJajLKRW9R667bs7jhLRsIwq92DJ82/l3M
	+gmbmxTR5KohPB8YNy6bfcrvE+t3n9dfrBSGuKmXo96xqG3RTwkYgXCba5e2QHge4RDoQo
	aHhXcyX5VboVNcPprb/acNYVx97CLlU=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-663-Q75F1Z27NhGiKt0UyW1usw-1; Wed, 07 Dec 2022 08:37:19 -0500
X-MC-Unique: Q75F1Z27NhGiKt0UyW1usw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1436A1C05AE9;
	Wed,  7 Dec 2022 13:37:17 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 033931121314;
	Wed,  7 Dec 2022 13:37:17 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id AA1E01946A41;
	Wed,  7 Dec 2022 13:37:16 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 394E71946588
 for <dm-devel@listman.corp.redhat.com>; Mon,  5 Dec 2022 20:29:11 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id EB267112132D; Mon,  5 Dec 2022 20:29:10 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id E439B1121315
 for <dm-devel@redhat.com>; Mon,  5 Dec 2022 20:29:10 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C331038173C1
 for <dm-devel@redhat.com>; Mon,  5 Dec 2022 20:29:10 +0000 (UTC)
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-284-ynGUJ0IWM4OaXn1mu1ssdg-1; Mon, 05 Dec 2022 15:29:09 -0500
X-MC-Unique: ynGUJ0IWM4OaXn1mu1ssdg-1
Received: by mail-wm1-f71.google.com with SMTP id
 o5-20020a05600c510500b003cfca1a327fso7363601wms.8
 for <dm-devel@redhat.com>; Mon, 05 Dec 2022 12:29:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=in-reply-to:content-transfer-encoding:content-disposition
 :mime-version:references:message-id:subject:cc:to:from:date
 :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=i4H5uezEbMG5ZldNo/c3W56d4899NhGUYDjXb8nhkk4=;
 b=x7YQ/hFjg90oVhjiVH+OlFPm/ZCAJ+8Er6e5jyUp7LoNdYxu3hFhIX+MARfi37tZwl
 xXs0tuM3AucQby2nxtQ1S+w6EMpzMQAuvY8boCoJhAkAkDT50Z3SaQoQiSuVrPtkhyaH
 sEoGr4EqMaYbqTor0HcoJie3VCUU0z+zORC6CWk9HxldG4WYXpVv60bNbyYUrMfm6RLC
 0zy0ynMc9TW32WgKsGQkabz7yzuo0zgDFhBNnkRt9H5oA/671Rmy0OZhb6TNDx53bxPC
 DYoy6vIPCW2B4FsF5HhbwDAMJD+KeTSIgd6ywDoJ2g8WonFh+5Gc9RblMEbx/+SoTwj+
 /GpQ==
X-Gm-Message-State: ANoB5pkv1OfpaDgmpINm4gnPtaTdMXt3Dgu+bG5x++tsjOcSeX5IxJ2o
 ixD8vSdsPMPFyg8nJMy6LJFNeGzRAYGIs0aJkntQ4eFAJDlR1mB23dRw2vcSB+pTgVc04+NsSXI
 mJYixpHhx/HR5z9w=
X-Received: by 2002:a5d:610d:0:b0:242:4fd1:1f5c with SMTP id
 v13-20020a5d610d000000b002424fd11f5cmr7301053wrt.376.1670272146268; 
 Mon, 05 Dec 2022 12:29:06 -0800 (PST)
X-Google-Smtp-Source: AA0mqf78f2gBMfTc6pHwRJ9zUly9GcCuFO5gZSklgpcj2WDCa2T0RWsRGceUYvYzIHBgrSw3qKds3g==
X-Received: by 2002:a5d:610d:0:b0:242:4fd1:1f5c with SMTP id
 v13-20020a5d610d000000b002424fd11f5cmr7301041wrt.376.1670272146115; 
 Mon, 05 Dec 2022 12:29:06 -0800 (PST)
Received: from redhat.com ([2.55.160.224]) by smtp.gmail.com with ESMTPSA id
 b18-20020a05600010d200b002423a5d7cb1sm12096271wrx.113.2022.12.05.12.29.04
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 05 Dec 2022 12:29:05 -0800 (PST)
Date: Mon, 5 Dec 2022 15:29:02 -0500
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Jens Axboe <axboe@kernel.dk>
Message-ID: <20221205152708-mutt-send-email-mst@kernel.org>
References: <20221205162035.2261037-1-alvaro.karsz@solid-run.com>
 <fe2800f1-aaae-33e8-aaf0-83fd034162d5@kernel.dk>
 <CAJs=3_AKOMWBpvKqvX6_c=zN1cwEM7x9dzGr7na=i-5_16rdEg@mail.gmail.com>
 <23c98c7c-3ed0-0d26-24c0-ed8a63266dcc@kernel.dk>
MIME-Version: 1.0
In-Reply-To: <23c98c7c-3ed0-0d26-24c0-ed8a63266dcc@kernel.dk>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Mailman-Approved-At: Wed, 07 Dec 2022 13:37:16 +0000
Subject: Re: [dm-devel] [PATCH v3] virtio_blk: add VIRTIO_BLK_F_LIFETIME
 feature support
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
Cc: linux-scsi@vger.kernel.org, Alvaro Karsz <alvaro.karsz@solid-run.com>,
 Jason Wang <jasowang@redhat.com>, linux-nvme@lists.infradead.org,
 virtualization@lists.linux-foundation.org, linux-block@vger.kernel.org,
 dm-devel@redhat.com, Stefan Hajnoczi <stefanha@redhat.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Enrico Granata <egranata@google.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

T24gTW9uLCBEZWMgMDUsIDIwMjIgYXQgMTE6NTM6NTFBTSAtMDcwMCwgSmVucyBBeGJvZSB3cm90
ZToKPiBPbiAxMi81LzIyIDExOjM24oCvQU0sIEFsdmFybyBLYXJzeiB3cm90ZToKPiA+IEhpLAo+
ID4gCj4gPj4gSXMgdGhpcyBiYXNlZCBvbiBzb21lIHNwZWM/IEJlY2F1c2UgaXQgbG9va3MgcHJl
dHR5IG9kZCB0byBtZS4gVGhlcmUKPiA+PiBjYW4gYmUgYSBwcmV0dHkgd2lkZSByYW5nZSBvZiB0
d28vdGhyZWUvZXRjIGxldmVsIGNlbGxzIHdpdGggd2lsZGx5Cj4gPj4gZGlmZmVyZW50IHJhbmdl
cyBvZiBkdXJhYmlsaXR5LiBBbmQgdGhlcmUncyByZWFsbHkgbm90IGEgbG90IG9mIHNsYwo+ID4+
IGZvciBnZW5lcmljIGRldmljZXMgdGhlc2UgZGF5cywgaWYgYW55Lgo+ID4gCj4gPiBZZXMsIHRo
aXMgaXMgYmFzZWQgb24gdGhlIHZpcnRpbyBzcGVjCj4gPiBodHRwczovL2RvY3Mub2FzaXMtb3Bl
bi5vcmcvdmlydGlvL3ZpcnRpby92MS4yL2NzZDAxL3ZpcnRpby12MS4yLWNzZDAxLmh0bWwKPiA+
IHNlY3Rpb24gIDUuMi42Cj4gCj4gQW5kIHdoZXJlIGRpZCB0aGlzIGNvbWUgZnJvbT8KCgpIZXJl
J3MgdGhlIGNvbW1pdCBsb2cgZnJvbSB0aGUgc3BlYzoKCUluIG1hbnkgZW1iZWRkZWQgc3lzdGVt
cywgdmlydGlvLWJsayBpbXBsZW1lbnRhdGlvbnMgYXJlCgliYWNrZWQgYnkgZU1NQyBvciBVRlMg
c3RvcmFnZSBkZXZpY2VzLCB3aGljaCBhcmUgc3ViamVjdCB0bwoJcHJlZGljdGFibGUgYW5kIG1l
YXN1cmFibGUgd2VhciBvdmVyIHRpbWUgZHVlIHRvIHJlcGVhdGVkIHdyaXRlCgljeWNsZXMuCgoJ
Rm9yIHN1Y2ggc3lzdGVtcywgaXQgY2FuIGJlIGltcG9ydGFudCB0byBiZSBhYmxlIHRvIHRyYWNr
CglhY2N1cmF0ZWx5IHRoZSBhbW91bnQgb2Ygd2VhciBpbXBvc2VkIG9uIHRoZSBzdG9yYWdlIG92
ZXIKCXRpbWUgYW5kIHN1cmZhY2UgaXQgdG8gYXBwbGljYXRpb25zLiBJbiBhIG5hdGl2ZSBkZXBs
b3ltZW50cwoJdGhpcyBpcyBnZW5lcmFsbHkgaGFuZGxlZCBieSB0aGUgcGh5c2ljYWwgYmxvY2sg
ZGV2aWNlIGRyaXZlcgoJYnV0IG5vIHN1Y2ggcHJvdmlzaW9uIGlzIG1hZGUgaW4gdmlydGlvLWJs
ayB0byBleHBvc2UgdGhlc2UKCW1ldHJpY3MgZm9yIGRldmljZXMgd2hlcmUgaXQgbWFrZXMgc2Vu
c2UgdG8gZG8gc28uCgoJVGhpcyBwYXRjaCBhZGRzIHN1cHBvcnQgdG8gdmlydGlvLWJsayBmb3Ig
bGlmZXRpbWUgYW5kIHdlYXIKCW1ldHJpY3MgdG8gYmUgZXhwb3NlZCB0byB0aGUgZ3Vlc3Qgd2hl
biBhIGRlcGxveW1lbnQgb2YKCXZpcnRpby1ibGsgaXMgZG9uZSBvdmVyIGNvbXBhdGlibGUgZU1N
QyBvciBVRlMgc3RvcmFnZS4KCglTaWduZWQtb2ZmLWJ5OiBFbnJpY28gR3JhbmF0YSA8ZWdyYW5h
dGFAZ29vZ2xlLmNvbT4KCkNjIEVucmljbyBHcmFuYXRhIGFzIHdlbGwuCgoKPiAtLSAKPiBKZW5z
IEF4Ym9lCj4gCgotLQpkbS1kZXZlbCBtYWlsaW5nIGxpc3QKZG0tZGV2ZWxAcmVkaGF0LmNvbQpo
dHRwczovL2xpc3RtYW4ucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRldmVsCg==

