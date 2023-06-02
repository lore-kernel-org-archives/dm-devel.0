Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 022FCC7EE2C
	for <dm-devel@archiver.kernel.org>; Fri,  2 Jun 2023 21:51:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685742661;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=JwexpzA+Z03moQnqu2Mn4d8R+iHUo0nJKJnUCa9mbss=;
	b=J/A1EFwCLPW8wl9LevIfEE/L13fiJs3H/lZrfGDo3SyB3EiCI9JIMEeeUj6IgXsdz4iPTY
	C04J6s298M5HDv7GPmbZvT+cAOGh52Ldm0Ef5M/gwCfGYFk7GafaU1mK/pDz3aaTwHQuip
	VIHbazY9xmDP4DYpkaOtGuPVRH0UdlY=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-96-2VVvin7DMdaaAP5PpNg_CQ-1; Fri, 02 Jun 2023 17:50:58 -0400
X-MC-Unique: 2VVvin7DMdaaAP5PpNg_CQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 48D493C02B74;
	Fri,  2 Jun 2023 21:50:56 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 5BC099E63;
	Fri,  2 Jun 2023 21:50:55 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 2A8771946595;
	Fri,  2 Jun 2023 21:50:55 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 0B26F194658C
 for <dm-devel@listman.corp.redhat.com>; Fri,  2 Jun 2023 21:50:53 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id CBA3DC154D9; Fri,  2 Jun 2023 21:50:53 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id C342AC154D7
 for <dm-devel@redhat.com>; Fri,  2 Jun 2023 21:50:53 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-1.mimecast.com
 [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A73F43C025BA
 for <dm-devel@redhat.com>; Fri,  2 Jun 2023 21:50:53 +0000 (UTC)
Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com
 [209.85.160.175]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-15-VnGPXxc7O6ut5rH_ZtBXVQ-1; Fri, 02 Jun 2023 17:50:52 -0400
X-MC-Unique: VnGPXxc7O6ut5rH_ZtBXVQ-1
Received: by mail-qt1-f175.google.com with SMTP id
 d75a77b69052e-3f8177f9a7bso23818821cf.2
 for <dm-devel@redhat.com>; Fri, 02 Jun 2023 14:50:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1685742652; x=1688334652;
 h=in-reply-to:content-transfer-encoding:content-disposition
 :mime-version:references:message-id:subject:cc:to:from:date
 :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=UTRky113EniM0nT/xznU7UrijnGVH8CEk6F86K/tnEo=;
 b=Z5zBevlBvIVCwUqg7texHmPYRkUg4DIXHJnHK8YFEdur3SjsqSiTZxYwoKOWGfjDnP
 s3mLpMTih8Lve/iL8/8ZGhGsRy2OkodCmiwLS93a0Y+OFEoTbZ20ZJs67Ni1fBB8CYXQ
 7egzhCq9N/xWMVl87q1oSLLPO0YLgcDvOzplVlNumV2kMsxTMSDCKMjq2KCvJAw5RetZ
 d5zOxVuZXu/drU5ls46dyesgmUXmhZnNDclhkjLKJvVvu9gHXlO5IWnCKfvTMkL/emmH
 CguTCSNl5ghryQb9/k2rDTVzejGc9QZWNkYa4MvCzr2xbeyMblUIQIchSseekpU0l9YE
 iswQ==
X-Gm-Message-State: AC+VfDzGYzT7DZ/nvmq2WWOiJXtZRJLtMyuE7ipCa7vzrO+0V+4U9l2Z
 v1UdnM0zEEr2Z3M09OiaP4Han7M=
X-Google-Smtp-Source: ACHHUZ7EYtrupkurG9n+8SFwQbMMRsCnns2grd76F2kWxvjetuxx5d1DqIPs4GPppwGqt5TFKDjmsg==
X-Received: by 2002:ac8:5e11:0:b0:3f6:b017:6289 with SMTP id
 h17-20020ac85e11000000b003f6b0176289mr16977166qtx.10.1685742651495; 
 Fri, 02 Jun 2023 14:50:51 -0700 (PDT)
Received: from localhost (pool-68-160-166-30.bstnma.fios.verizon.net.
 [68.160.166.30]) by smtp.gmail.com with ESMTPSA id
 i2-20020ac813c2000000b003f6f83de87esm1236527qtj.92.2023.06.02.14.50.50
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 02 Jun 2023 14:50:50 -0700 (PDT)
Date: Fri, 2 Jun 2023 17:50:49 -0400
From: Mike Snitzer <snitzer@kernel.org>
To: Sarthak Kukreti <sarthakkukreti@chromium.org>
Message-ID: <ZHpkOTMDdoxLD/j1@redhat.com>
References: <ZG1dAtHmbQ53aOhA@dread.disaster.area> <ZG+KoxDMeyogq4J0@bfoster>
 <ZHB954zGG1ag0E/t@dread.disaster.area>
 <CAJ0trDbspRaDKzTzTjFdPHdB9n0Q9unfu1cEk8giTWoNu3jP8g@mail.gmail.com>
 <ZHFEfngPyUOqlthr@dread.disaster.area>
 <CAJ0trDZJQwvAzngZLBJ1hB0XkQ1HRHQOdNQNTw9nK-U5i-0bLA@mail.gmail.com>
 <ZHYB/6l5Wi+xwkbQ@redhat.com>
 <CAJ0trDaUOevfiEpXasOESrLHTCcr=oz28ywJU+s+YOiuh7iWow@mail.gmail.com>
 <ZHYWAGmKhwwmTjW/@redhat.com>
 <CAG9=OMMnDfN++-bJP3jLmUD6O=Q_ApV5Dr392_5GqsPAi_dDkg@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAG9=OMMnDfN++-bJP3jLmUD6O=Q_ApV5Dr392_5GqsPAi_dDkg@mail.gmail.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
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
 Bart Van Assche <bvanassche@google.com>, Dave Chinner <david@fromorbit.com>,
 linux-kernel@vger.kernel.org, Joe Thornber <ejt@redhat.com>,
 linux-block@vger.kernel.org, dm-devel@redhat.com,
 Andreas Dilger <adilger.kernel@dilger.ca>,
 Stefan Hajnoczi <stefanha@redhat.com>, linux-fsdevel@vger.kernel.org,
 Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org,
 Brian Foster <bfoster@redhat.com>, Alasdair Kergon <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

T24gRnJpLCBKdW4gMDIgMjAyMyBhdCAgMjo0NFAgLTA0MDAsClNhcnRoYWsgS3VrcmV0aSA8c2Fy
dGhha2t1a3JldGlAY2hyb21pdW0ub3JnPiB3cm90ZToKCj4gT24gVHVlLCBNYXkgMzAsIDIwMjMg
YXQgODoyOOKAr0FNIE1pa2UgU25pdHplciA8c25pdHplckBrZXJuZWwub3JnPiB3cm90ZToKPiA+
Cj4gPiBPbiBUdWUsIE1heSAzMCAyMDIzIGF0IDEwOjU1UCAtMDQwMCwKPiA+IEpvZSBUaG9ybmJl
ciA8dGhvcm5iZXJAcmVkaGF0LmNvbT4gd3JvdGU6Cj4gPgo+ID4gPiBPbiBUdWUsIE1heSAzMCwg
MjAyMyBhdCAzOjAy4oCvUE0gTWlrZSBTbml0emVyIDxzbml0emVyQGtlcm5lbC5vcmc+IHdyb3Rl
Ogo+ID4gPgo+ID4gPiA+Cj4gPiA+ID4gQWxzbyBKb2UsIGZvciB5b3UgcHJvcG9zZWQgZG0tdGhp
bnAgZGVzaWduIHdoZXJlIHlvdSBkaXN0aW5xdWlzaAo+ID4gPiA+IGJldHdlZW4gInByb3Zpc2lv
biIgYW5kICJyZXNlcnZlIjogV291bGQgaXQgbWFrZSBzZW5zZSBmb3IgUkVRX01FVEEKPiA+ID4g
PiAoZS5nLiBhbGwgWEZTIG1ldGFkYXRhKSB3aXRoIFJFUV9QUk9WSVNJT04gdG8gYmUgdHJlYXRl
ZCBhcyBhbgo+ID4gPiA+IExCQS1zcGVjaWZpYyBoYXJkIHJlcXVlc3Q/ICBXaGVyZWFzIFJFUV9Q
Uk9WSVNJT04gb24gaXRzIG93biBwcm92aWRlcwo+ID4gPiA+IG1vcmUgZnJlZWRvbSB0byBqdXN0
IHJlc2VydmUgdGhlIGxlbmd0aCBvZiBibG9ja3M/IChlLmcuIGZvciBYRlMKPiA+ID4gPiBkZWxh
bGxvYyB3aGVyZSBMQkEgcmFuZ2UgaXMgdW5rbm93biwgYnV0IGRtLXRoaW5wIGNhbiBiZSBhc2tl
ZCB0bwo+ID4gPiA+IHJlc2VydmUgc3BhY2UgdG8gYWNjb21vZGF0ZSBpdCkuCj4gPiA+ID4KPiA+
ID4KPiA+ID4gTXkgcHJvcG9zYWwgb25seSBpbnZvbHZlcyAncmVzZXJ2ZScuICBQcm92aXNpb25p
bmcgd2lsbCBiZSBkb25lIGFzIHBhcnQgb2YKPiA+ID4gdGhlIHVzdWFsIGlvIHBhdGguCj4gPgo+
ID4gT0ssIEkgdGhpbmsgd2UnZCBkbyB3ZWxsIHRvIHBpbiBkb3duIHRoZSB0b3AtbGV2ZWwgYmxv
Y2sgaW50ZXJmYWNlcyBpbgo+ID4gcXVlc3Rpb24uIEJlY2F1c2UgdGhpcyBwYXRjaHNldCdzIGJs
b2NrIGludGVyZmFjZSBwYXRjaCAoMi81KSBoZWFkZXIKPiA+IHNheXM6Cj4gPgo+ID4gIlRoaXMg
cGF0Y2ggYWxzbyBhZGRzIHRoZSBjYXBhYmlsaXR5IHRvIGNhbGwgZmFsbG9jYXRlKCkgaW4gbW9k
ZSAwCj4gPiBvbiBibG9jayBkZXZpY2VzLCB3aGljaCB3aWxsIHNlbmQgUkVRX09QX1BST1ZJU0lP
TiB0byB0aGUgYmxvY2sKPiA+IGRldmljZSBmb3IgdGhlIHNwZWNpZmllZCByYW5nZSwiCj4gPgo+
ID4gU28gaXQgd2lyZXMgdXAgYmxrZGV2X2ZhbGxvY2F0ZSgpIHRvIGNhbGwgYmxrZGV2X2lzc3Vl
X3Byb3Zpc2lvbigpLiBBCj4gPiB1c2VyIG9mIFhGUyBjb3VsZCB0aGVuIHVzZSBmYWxsb2NhdGUo
KSBmb3IgdXNlciBkYXRhIC0tIHdoaWNoIHdvdWxkCj4gPiBjYXVzZSB0aGlucCdzIHJlc2VydmUg
dG8gX25vdF8gYmUgdXNlZCBmb3IgY3JpdGljYWwgbWV0YWRhdGEuCj4gPgo+ID4gVGhlIG9ubHkg
d2F5IHRvIGRpc3RpbnF1aXNoIHRoZSBjYWxsZXIgKGJldHdlZW4gb24tYmVoYWxmIG9mIHVzZXIg
ZGF0YQo+ID4gdnMgWEZTIG1ldGFkYXRhKSB3b3VsZCBiZSBSRVFfTUVUQT8KPiA+Cj4gPiBTbyBz
aG91bGQgZG0tdGhpbnAgaGF2ZSBhIFJFUV9NRVRBLWJhc2VkIGRpc3RpbmN0aW9uPyBPciBqdXN0
IHRyZWF0Cj4gPiBhbGwgUkVRX09QX1BST1ZJU0lPTiB0aGUgc2FtZT8KPiA+Cj4gSSdtIGluIGZh
dm9yIG9mIGEgUkVRX01FVEEtYmFzZWQgZGlzdGluY3Rpb24uIERvZXMgdGhhdCBpbXBseSB0aGF0
Cj4gUkVRX01FVEEgYWxzbyBuZWVkcyB0byBiZSBwYXNzZWQgdGhyb3VnaCB0aGUgYmxvY2svZmls
ZXN5c3RlbSBzdGFjawo+IChlZy4gUkVRX09QX1BST1ZJT04gKyBSRVFfTUVUQSBvbiBhIGxvb3Ag
ZGV2aWNlIHRyYW5zbGF0ZXMgdG8gYQo+IGZhbGxvY2F0ZSg8aW5zZXJ0IG1ldGEgZmxhZyBuYW1l
PikgdG8gdGhlIHVuZGVybHlpbmcgZmlsZSk/CgpVbmNsZWFyLCBJIHdhcyB0aGlua2luZyB5b3Vy
IFJFUV9VTlNIQVJFICh0aWVkIHRvIGZhbGxvY2F0ZSkgbWlnaHQgYmUKYSBtZWFucyB0byB0cmFu
c2xhdGUgUkVRX09QX1BST1ZJU0lPTiArIFJFUV9NRVRBIHRvIGZhbGxvY2F0ZSBhbmQgaGF2ZQpp
dCBwZXJmb3JtIHRoZSBMQkEtc3BlY2lmaWMgcHJvdmlzaW9uaW5nIG9mIEpvZSdzIGRlc2lnbiAo
cmVmZXJlbmNlZApiZWxvdykuCgo+IDxiaWtlc2hlZD4KPiBJIHRoaW5rIHRoYXQgbWlnaHQgaGF2
ZSBhcHBsaWNhdGlvbnMgYmV5b25kIGp1c3QgcHJvdmlzaW9uaW5nOgo+IGN1cnJlbnRseSwgZm9y
IHN0YWNrZWQgZmlsZXN5c3RlbXMgKGVnIGZpbGVzeXN0ZW1zIHJlc2lkaW5nIGluIGEgZmlsZQo+
IG9uIHRvcCBvZiBhbm90aGVyIGZpbGVzeXN0ZW0pLCBldmVuIGlmIHRoZSB1cHBlciBmaWxlc3lz
dGVtIGlzc3Vlcwo+IHJlYWQvd3JpdGUgcmVxdWVzdHMgd2l0aCBSRVFfTUVUQSB8IFJFUV9QUklP
LCB0aGVzZSBmbGFncyBhcmUgbG9zdCBpbgo+IHRyYW5zbGF0aW9uIGF0IHRoZSBsb29wIGRldmlj
ZSBsYXllci4gIEEgZmxhZyBsaWtlIHRoZSBhYm92ZSB3b3VsZAo+IGFsbG93IHRoZSBwcmlvcml0
aXphdGlvbiBvZiBzdGFja2VkIGZpbGVzeXN0ZW0gbWV0YWRhdGEgcmVxdWVzdHMuCj4gPC9iaWtl
c2hlZD4KClllcywgaXQgY291bGQgcHJvdmUgdXNlZnVsLgoKPiBCcmluZ2luZyB0aGUgZGlzY3Vz
c2lvbiBiYWNrIHRvIHRoaXMgc2VyaWVzIGZvciBhIGJpdCwgSSdtIHN0aWxsCj4gd2FpdGluZyBv
biBmZWVkYmFjayBmcm9tIHRoZSBCbG9jayBtYWludGFpbmVycyBiZWZvcmUgc2VuZGluZyBvdXQg
djgKPiAod2hpY2ggYXQgdGhlIG1vbWVudCwgb25seSBoYXZlIGEKPiBzL0VYUE9SVF9TWU1CT0wv
RVhQT1JUX1NZTUJPTF9HUEwvZykuIEkgYmVsaWV2ZSBmcm9tIHRoZSBjb252ZXJzYXRpb24KPiBt
b3N0IG9mIHRoZSBhYm92ZSBpcyBmb2xsb3cgdXAgd29yaywgYnV0IHBsZWFzZSBsZXQgbWUga25v
dyBpZiB5b3UnZAo+IHByZWZlciBJIGFkZCBzb21lIG9mIHRoaXMgdG8gdGhlIGN1cnJlbnQgc2Vy
aWVzIQoKSSBuZWVkIGEgYml0IG1vcmUgdGltZSB0byB3b3JrIHRocm91Z2ggdmFyaW91cyBhc3Bl
Y3RzIG9mIHRoZSBicm9hZGVyCnJlcXVpcmVtZW50cyBhbmQgdGhlIHJlc3VsdGluZyBpbnRlcmZh
Y2VzIHRoYXQgZmFsbCBvdXQuCgpKb2UncyBkZXNpZ24gaXMgcHJldHR5IGNvbXBlbGxpbmcgYmVj
YXVzZSBpdCB3aWxsIHByb3Blcmx5IGhhbmRsZQpzbmFwc2hvdCB0aGluIGRldmljZXM6Cmh0dHBz
Oi8vbGlzdG1hbi5yZWRoYXQuY29tL2FyY2hpdmVzL2RtLWRldmVsLzIwMjMtTWF5LzA1NDM1MS5o
dG1sCgpIZXJlIGlzIG15IGxhdGVzdCBzdGF0dXM6Ci0gRm9jdXNlZCBvbiBwcm90b3R5cGUgZm9y
IHRoaW5wIGJsb2NrIHJlc2VydmF0aW9uIChYRlMgbWV0YWRhdGEsIFhGUwogIGRlbGFsbG9jLCBm
YWxsb2NhdGUpCi0gRGVjaWRlZCB0aGUgImR5bmFtaWMiIChub24tTEJBIHNwZWNpZmljKSByZXNl
cnZhdGlvbiBzdHVmZiAob2xkCiAgcHJvdG90eXBlIGNvZGUpIGlzIGJlc3QgbGVmdCBpbmRlcGVu
ZGVudCBmcm9tIEpvZSdzIGRlc2lnbi4gIFNPIDIKICBjbGFzc2VzIG9mIHRoaW5wIHJlc2VydmF0
aW9uLgogIC0gRm9yd2FyZC1wb3J0ZWQgdGhlIG9sZCBwcm90b3R5cGUgY29kZSB0aGF0IEJyaWFu
IEZvc3RlciwgSm9lCiAgICBUaG9ybmJlciBhbmQgSSB3b3JrZWQgb24geWVhcnMgYWdvLiAgSXQg
bmVlZHMgbW9yZSBjYXJlZnVsIHJldmlldwogICAgKGFuZCB2ZXJ5IGxpa2VseSB3aWxsIG5lZWQg
Zml4ZXMgZnJvbSBCcmlhbiBhbmQgbXlzZWxmKS4gIFRoZSBYRlMKICAgIGNoYW5nZXMgYXJlIHBy
ZXR0eSBpbnRydXNpdmUgYW5kIGxpa2VseSB1cCBmb3Igc2VyaW91cyBkZWJhdGUgKGFzCiAgICB0
byB3aGV0aGVyIHdlIGV2ZW4gY2FyZSB0byBoYW5kbGUgcmVzZXJ2YXRpb25zIGZvciB1c2VyIGRh
dGEpLgotIFJFUV9PUF9QUk9WSVNJT04gYmlv4oCZcyB3aXRoIFJFUV9NRVRBIHdpbGwgdXNlIEpv
ZeKAmXMgZGVzaWduLAogIG90aGVyd2lzZSBkYXRhIChYRlMgZGF0YSBhbmQgZmFsbG9jYXRlKSB3
aWxsIHVzZSDigJxkeW5hbWlj4oCdCiAgcmVzZXJ2YXRpb24uCiAgLSAiZHluYW1pYyIgbmFtZSBp
cyBkdWUgdG8gdGhlIHJlc2VydmF0aW9uIGJlaW5nIGdlbmVyaWMgKG5vbi1MQkE6CiAgICBub3Qg
aW4gdGVybXMgb2YgYW4gTEJBIHJhbmdlKS4gQWxzbywgaW4tY29yZSBvbmx5OyBzbyB0aGUgYXNz
b2NpYXRlZAogICAg4oCcZHluYW1pY19yZXNlcnZlX2NvdW504oCdIGFjY291bnRpbmcgaXMgcmVz
ZXQgdG8gMCBldmVyeSBhY3RpdmF0aW9uLiAKICAtIEZhbGxvY2F0ZSBtYXkgcmVxdWlyZSBzdHJv
bmdlciBndWFyYW50ZWVzIGluIHRoZSBlbmQgKGluIHdoaWNoCiAgICBjYXNlIHdl4oCZbGwgYWRk
IGEgUkVRX1VOU0hBUkUgZmxhZyB0aGF0IGlzIHNlbGVjdGFibGUgZnJvbSB0aGUKICAgIGZhbGxv
Y2F0ZSBpbnRlcmZhY2UpIAotIFdpbGwgdHJ5IHRvIHNoYXJlIGNvbW1vbiBjb2RlLCBidXQganVz
dCBzb3J0aW5nIG91dCBoaWdobGV2ZWwKICBpbnRlcmZhY2Uocykgc3RpbGwuLi4KCkknbGwgdHJ5
IHRvIGdldCBhIGdpdCB0cmVlIHRvZ2V0aGVyIGVhcmx5IG5leHQgd2Vlay4gIEl0IHdpbGwgYmUg
dGhlCmZvcndhcmQgcG9ydGVkICJkeW5hbWljIiBwcm90b3R5cGUgY29kZSBhbmQgeW91ciBsYXRl
c3QgdjcgY29kZSB3aXRoCnNvbWUgYWRkaXRpb25hbCB3b3JrIHRvIGJyYW5jaCBhY2NvcmRpbmds
eSBmb3IgZWFjaCBjbGFzcyBvZiB0aGlucApyZXNlcnZhdGlvbi4gIEFuZCBJJ2xsIHVzZSB5b3Vy
IHY3IGNvZGUgYXMgYSBjcnVkZSBzdHViIGZvciBKb2UncwphcHByb2FjaCAoYnJhbmNoIHRha2Vu
IGlmIFJFUV9NRVRBIHNldCkuCgpMYXN0bHksIGhlcmUgYXJlIHNvbWUgYWRkaXRpb25hbCBUT0RP
cyBJJ3ZlIG5vdGVkIGluIGNvZGUgZWFybGllciBpbgpteSByZXZpZXcgcHJvY2VzczoKCmRpZmYg
LS1naXQgYS9kcml2ZXJzL21kL2RtLXRoaW4uYyBiL2RyaXZlcnMvbWQvZG0tdGhpbi5jCmluZGV4
IDBkOTMwMTgwMjYwOS4uNDNhNjcwMmY5ZWZlIDEwMDY0NAotLS0gYS9kcml2ZXJzL21kL2RtLXRo
aW4uYworKysgYi9kcml2ZXJzL21kL2RtLXRoaW4uYwpAQCAtMTk2NCw2ICsxOTY0LDI2IEBAIHN0
YXRpYyB2b2lkIHByb2Nlc3NfcHJvdmlzaW9uX2JpbyhzdHJ1Y3QgdGhpbl9jICp0Yywgc3RydWN0
IGJpbyAqYmlvKQogCXN0cnVjdCBkbV9jZWxsX2tleSBrZXk7CiAJc3RydWN0IGRtX3RoaW5fbG9v
a3VwX3Jlc3VsdCBsb29rdXBfcmVzdWx0OwogCisJLyoKKwkgKiBGSVhNRToKKwkgKiBKb2UncyBl
bGVnYW50IHJlc2VydmF0aW9uIGRlc2lnbiBpcyBkZXRhaWxlZCBoZXJlOgorCSAqIGh0dHBzOi8v
bGlzdG1hbi5yZWRoYXQuY29tL2FyY2hpdmVzL2RtLWRldmVsLzIwMjMtTWF5LzA1NDM1MS5odG1s
CisJICogLSB0aGlzIGRlc2lnbiwgd2l0aCBhc3NvY2lhdGVkIHRoaW5wIG1ldGFkYXRhIHVwZGF0
ZXMsCisJICogICBpcyBob3cgcHJvdmlzaW9uIGJpb3Mgc2hvdWxkIGJlIGhhbmRsZWQuCisJICoK
KwkgKiBGSVhNRTogYWRkIHRoaW4tcG9vbCBmbGFnICJpZ25vcmVfcHJvdmlzaW9uIgorCSAqCisJ
ICogRklYTUU6IG5lZWRzIHByb3Zpc2lvbl9wYXNzZG93biBzdXBwb3J0CisJICogICAgICAgIChu
ZWVkcyB0aGlucCBmbGFnICJub19wcm92aXNpb25fcGFzc2Rvd24iKQorCSAqLworCisJLyoKKwkg
KiBGSVhNRTogcmVxdWlyZSBSRVFfTUVUQSAob3IgUkVRX1VOU0hBUkU/KSB0byBhbGxvdyBkZWVw
ZXIKKwkgKiAgICAgICAgcHJvdmlzaW9uaW5nIGNvZGUgdGhhdCBmb2xsb3dzPyAoc28gdGhhdCB0
aGlucAorCSAqICAgICAgICBibG9jayBfaXNfIGZ1bGx5IHByb3Zpc2lvbmVkIHVwb24gcmV0dXJu
KQorCSAqICAgICAgICAob3IganVzdCByZW1vdmUgYWxsIGJlbG93IGNvZGUgZW50aXJlbHk/KQor
CSAqLworCiAJLyoKIAkgKiBJZiBjZWxsIGlzIGFscmVhZHkgb2NjdXBpZWQsIHRoZW4gdGhlIGJs
b2NrIGlzIGFscmVhZHkKIAkgKiBiZWluZyBwcm92aXNpb25lZCBzbyB3ZSBoYXZlIG5vdGhpbmcg
ZnVydGhlciB0byBkbyBoZXJlLgoKLS0KZG0tZGV2ZWwgbWFpbGluZyBsaXN0CmRtLWRldmVsQHJl
ZGhhdC5jb20KaHR0cHM6Ly9saXN0bWFuLnJlZGhhdC5jb20vbWFpbG1hbi9saXN0aW5mby9kbS1k
ZXZlbAo=

