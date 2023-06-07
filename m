Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C5486C7EE25
	for <dm-devel@archiver.kernel.org>; Wed,  7 Jun 2023 23:28:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686180508;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=EdS5C5plPlDyEW1qoWTe4ThO7XkS3UPhQKlt5Q+DC1c=;
	b=aYHbcnESZyls6dTWEPpmcLQJWEUun8I2CVe+NRcVKjcmz2JlvPpjjpIkWrQN15t55XZMzr
	lufknRxjZLW64aDI9r1iHAZZ8mBw2Im8y71+rRiD9VX2IPEA8eEQ3HGinf/dwmRjUZkoDM
	sphaBNviJ7z9Hq1XzhKBy06NYQMmUPc=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-241-WpPbeDz3PzmdE_zs7PJZww-1; Wed, 07 Jun 2023 19:28:27 -0400
X-MC-Unique: WpPbeDz3PzmdE_zs7PJZww-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9E12B1C04188;
	Wed,  7 Jun 2023 23:28:25 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 084F09E8D;
	Wed,  7 Jun 2023 23:28:24 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id B4E1719452C4;
	Wed,  7 Jun 2023 23:27:59 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 78F1219465BA
 for <dm-devel@listman.corp.redhat.com>; Wed,  7 Jun 2023 23:27:30 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 607002166B26; Wed,  7 Jun 2023 23:27:30 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 577682166B25
 for <dm-devel@redhat.com>; Wed,  7 Jun 2023 23:27:30 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 37DA328237C1
 for <dm-devel@redhat.com>; Wed,  7 Jun 2023 23:27:30 +0000 (UTC)
Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com
 [209.85.160.169]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-31-aE3dR64LNUSRTHkbiLvWzA-1; Wed, 07 Jun 2023 19:27:26 -0400
X-MC-Unique: aE3dR64LNUSRTHkbiLvWzA-1
Received: by mail-qt1-f169.google.com with SMTP id
 d75a77b69052e-3f9c2e3914aso7166101cf.3
 for <dm-devel@redhat.com>; Wed, 07 Jun 2023 16:27:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1686180446; x=1688772446;
 h=in-reply-to:content-transfer-encoding:content-disposition
 :mime-version:references:message-id:subject:cc:to:from:date
 :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=voj5Mda8Zfoqf83eL6TpEP6bEfS34qzT4ho4GEckRy8=;
 b=Fqwhdegsp2JX6zsf4A4qBLL2i9rJYauCw0zfkN7KgSrfBgCQe0+pULvutMVFv8SmKN
 e1LZMzuF6GEAfSERp9DVWTIfgzL7HnDTW6k0kVXhD7M/y4n1q2POQaEKhilnXTxnSrrx
 COfNfDb2cXRbpBbChSsaXfe1SQ/Y8mkLlsbWcpFmnjKcxLl2sw2nQSGZ4lpbykdeWDrX
 NU+CsABSUV16RPH0bQVr8vQdfhH8r1zJjbJg3nA/Pt+qNOu8dC+1A/WhOMLiCBh0INBB
 E5frc5R31J1I4T4UvT6cGBzb1rmQMsiOkY7OJYbpyqN7uYoX/p0G0djYVovtLFTztO1j
 2NXg==
X-Gm-Message-State: AC+VfDzNiZ1QjdVqf6dlWZjYzHRddBeobB213rps/lgFDPR4lyjQ0Kev
 Xi4VGUmfWOH/VChVP5Lr148gEW4=
X-Google-Smtp-Source: ACHHUZ6bssYu3BmODSfk7D3JoJ9AovgnvY3uNrvFLLvCnNUVf2dqD8Ue69PPoyqRe4HMmDod3/Cmnw==
X-Received: by 2002:ac8:5c16:0:b0:3d8:2352:a661 with SMTP id
 i22-20020ac85c16000000b003d82352a661mr6003241qti.3.1686180446161; 
 Wed, 07 Jun 2023 16:27:26 -0700 (PDT)
Received: from localhost (pool-68-160-166-30.bstnma.fios.verizon.net.
 [68.160.166.30]) by smtp.gmail.com with ESMTPSA id
 i9-20020ac84f49000000b003f018e18c35sm286121qtw.27.2023.06.07.16.27.25
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 07 Jun 2023 16:27:25 -0700 (PDT)
Date: Wed, 7 Jun 2023 19:27:24 -0400
From: Mike Snitzer <snitzer@kernel.org>
To: Sarthak Kukreti <sarthakkukreti@chromium.org>
Message-ID: <ZIESXNF5anyvJEjm@redhat.com>
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
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
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
 Joe Thornber <thornber@redhat.com>, dm-devel@redhat.com,
 "Michael S. Tsirkin" <mst@redhat.com>, "Darrick J. Wong" <djwong@kernel.org>,
 Jason Wang <jasowang@redhat.com>, Bart Van Assche <bvanassche@google.com>,
 Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org,
 Christoph Hellwig <hch@infradead.org>, Joe Thornber <ejt@redhat.com>,
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

T24gTW9uLCBKdW4gMDUgMjAyMyBhdCAgNToxNFAgLTA0MDAsClNhcnRoYWsgS3VrcmV0aSA8c2Fy
dGhha2t1a3JldGlAY2hyb21pdW0ub3JnPiB3cm90ZToKCj4gT24gU2F0LCBKdW4gMywgMjAyMyBh
dCA4OjU34oCvQU0gTWlrZSBTbml0emVyIDxzbml0emVyQGtlcm5lbC5vcmc+IHdyb3RlOgo+ID4K
PiA+IFdlIGFsbCBqdXN0IG5lZWQgdG8gZm9jdXMgb24geW91ciBwcm9wb3NhbCBhbmQgSm9lJ3Mg
ZG0tdGhpbgo+ID4gcmVzZXJ2YXRpb24gZGVzaWduLi4uCj4gPgo+ID4gW1NhcnRoYWs6IEZZSSwg
dGhpcyBpbXBsaWVzIHRoYXQgaXQgZG9lc24ndCByZWFsbHkgbWFrZSBzZW5zZSB0byBhZGQKPiA+
IGRtLXRoaW5wIHN1cHBvcnQgYmVmb3JlIEpvZSdzIGRlc2lnbiBpcyBpbXBsZW1lbnRlZC4gIE90
aGVyd2lzZSB3ZSdsbAo+ID4gaGF2ZSAyIGRpZmZlcmVudCByZXNwb25zZXMgdG8gUkVRX09QX1BS
T1ZJU0lPTi4gIFRoZSBvbmUgdGhhdCBpcwo+ID4gY2FwdHVyZWQgaW4geW91ciBwYXRjaHNldCBp
c24ndCBhZGVxdWF0ZSB0byBwcm9wZXJseSBoYW5kbGUgZW5zdXJpbmcKPiA+IHVwcGVyIGxheWVy
IChsaWtlIFhGUykgY2FuIGRlcGVuZCBvbiB0aGUgc3BhY2UgYmVpbmcgYXZhaWxhYmxlIGFjcm9z
cwo+ID4gc25hcHNob3QgYm91bmRhcmllcy5dCj4gPgo+IEFjay4gV291bGQgaXQgYmUgcHJlbWF0
dXJlIGZvciB0aGUgcmVzdCBvZiB0aGUgc2VyaWVzIHRvIGdvIHRocm91Z2gKPiAoUkVRX09QX1BS
T1ZJU0lPTiArIHN1cHBvcnQgZm9yIGxvb3AgYW5kIG5vbi1kbS10aGlucCBkZXZpY2UtbWFwcGVy
Cj4gdGFyZ2V0cyk/IEknZCBsaWtlIHRvIHN0YXJ0IHVzaW5nIHRoaXMgYXMgYSByZWZlcmVuY2Ug
dG8gc3VnZ2VzdAo+IGFkZGl0aW9ucyB0byB0aGUgdmlydGlvLXNwZWMgZm9yIHZpcnRpby1ibGsg
c3VwcG9ydCBhbmQgc3RhcnQgbG9va2luZwo+IGF0IHdoYXQgYW4gZXh0NCBpbXBsZW1lbnRhdGlv
biB3b3VsZCBsb29rIGxpa2UuCgpQbGVhc2UgZHJvcCB0aGUgZG0tdGhpbi5jIGFuZCBkbS1zbmFw
LmMgY2hhbmdlcy4gIGRtLXNuYXAuYyB3b3VsZCBuZWVkCm1vcmUgd29yayB0byBwcm92aWRlIHRo
ZSB0eXBlIG9mIGd1YXJhbnRlZSBYRlMgcmVxdWlyZXMgYWNyb3NzCnNuYXBzaG90IGJvdW5kYXJp
ZXMuIEknbSBpbmNsaW5lZCB0byBfbm90XyBhZGQgZG0tc25hcC5jIHN1cHBvcnQKYmVjYXVzZSBp
dCBpcyBiZXN0IHRvIGp1c3QgdXNlIGRtLXRoaW4uCgpBbmQgRllJIGV2ZW4geW91ciBkbS10aGlu
IHBhdGNoIHdpbGwgYmUgdGhlIHN0YXJ0aW5nIHBvaW50IGZvciB0aGUKZG0tdGhpbiBzdXBwb3J0
ICh3ZSdsbCBrZWVwIGF0dHJpYnV0aW9uIHRvIHlvdSBmb3IgYWxsIHRoZSBjb2RlIGluIGEKc2Vw
YXJhdGUgcGF0Y2gpLgoKPiBGYWlyIHBvaW50cywgSSBjZXJ0YWlubHkgZG9uJ3Qgd2FudCB0byBk
ZXJhaWwgdGhpcyBjb252ZXJzYXRpb247IEknZAo+IGJlIGhhcHB5IHRvIHNlZSB0aGlzIHdvcmsg
bWVyZ2VkIHNvb25lciByYXRoZXIgdGhhbiBsYXRlci4KCk9uY2UgdGhvc2UgZG0gdGFyZ2V0IGNo
YW5nZXMgYXJlIGRyb3BwZWQgSSB0aGluayB0aGUgcmVzdCBvZiB0aGUKc2VyaWVzIGlzIGZpbmUg
dG8gZ28gdXBzdHJlYW0gbm93LiAgRmVlbCBmcmVlIHRvIHBvc3QgYSB2OC4KCj4gRm9yIHBvc3Rl
cml0eSwgSSdsbCBkaXN0aWxsIHdoYXQgSSBzYWlkIGFib3ZlIGludG8gdGhlIGZvbGxvd2luZzog
SSdkIGxpa2UKPiBhIGNhcGFiaWxpdHkgZm9yIHVzZXJzcGFjZSB0byBjcmVhdGUgdGhpbiBzbmFw
c2hvdHMgdGhhdCBpZ25vcmUgdGhlCj4gdGhpbiB2b2x1bWUncyBwcm92aXNpb25lZCBhcmVhcy4g
SU9XLCBhbiBvcHQtaW4gZmxhZyB3aGljaCBtYWtlcwo+IHNuYXBzaG90cyBmYWxsYmFjayB0byB3
aGF0IHRoZXkgZG8gdG9kYXkgdG8gcHJvdmlkZSBmbGV4aWJpbGl0eSB0bwo+IHVzZXJzcGFjZSB0
byBkZWNpZGUgdGhlIHNwYWNlIHJlcXVpcmVtZW50cyBmb3IgdGhlIGFib3ZlIG1lbnRpb25lZAo+
IHNjZW5hcmlvcywgYW5kIGF0IHRoZSBzYW1lIHRpbWUsIG5vdCBhZGRpbmcgc2VwYXJhdGUgY29y
bmVyIGNhc2UKPiBoYW5kbGluZyBmb3IgZmlsZXN5c3RlbXMuIEJ1dCB0byByZWl0ZXJhdGUsIG15
IGludGVudCBpc24ndCB0byBwaWxlCj4gdGhpcyBvbnRvIHRoZSB3b3JrIHlvdSwgTWlrZSBhbmQg
Sm9lIGhhdmUgcGxhbm5lZDsganVzdCBzb21lIGluc2lnaHQKPiBpbnRvIHdoeSBJJ20gaW4gZmF2
b3Igb2YgaWRlYXMgdGhhdCByZWR1Y2UgdGhlIHNuYXBzaG90IHNpemUuCgpJIHRoaW5rIGl0J2Qg
YmUgdXNlZnVsIHRvIGlnbm9yZSBhIHRoaW4gZGV2aWNlJ3MgcmVzZXJ2YXRpb24gZm9yCnJlYWQt
b25seSBzbmFwc2hvdHMuICBBZGRpbmcgdGhlIGFiaWxpdHkgdG8gY3JlYXRlIHJlYWQtb25seSB0
aGluCnNuYXBzaG90cyBjb3VsZCBtYWtlIHNlbnNlIChsYXRlciBhY3RpdmF0aW9ucyBkb24ndCBu
ZWNlc3NhcmlseSBuZWVkCnRvIGltcG9zZSByZWFkLW9ubHksIGRvaW5nIHNvIHdvdWxkIHJlcXVp
cmUgc29tZSBhZGRpdGlvbmFsIHdvcmspLgoKTWlrZQoKLS0KZG0tZGV2ZWwgbWFpbGluZyBsaXN0
CmRtLWRldmVsQHJlZGhhdC5jb20KaHR0cHM6Ly9saXN0bWFuLnJlZGhhdC5jb20vbWFpbG1hbi9s
aXN0aW5mby9kbS1kZXZlbAo=

