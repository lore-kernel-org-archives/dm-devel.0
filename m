Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4153EC7EE25
	for <dm-devel@archiver.kernel.org>; Fri,  9 Jun 2023 20:31:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686342713;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=setzq+TMmUVyJCVMoF9NTRHdCSiRGOO1tryKeo2LFZs=;
	b=NXkWCDWpCD8djkrwDIWuZ4ZWyBiN/n53amcVizjX95mXbpgWA6HtviBuEr3TzxohbnV8A1
	0k9Wop+8IBm+v8BzdOzl/LHS1L0ioNGaYjgQCsUqH0SqCqVTvtJj+ZdsiLZQq1nd+J77j9
	wZqn/8reSXefFTe454EKoMG8oVAlUq0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-593-MZRDzZ4ENiiy6GAoRljbTw-1; Fri, 09 Jun 2023 16:31:50 -0400
X-MC-Unique: MZRDzZ4ENiiy6GAoRljbTw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 96179185A791;
	Fri,  9 Jun 2023 20:31:48 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 43B111121314;
	Fri,  9 Jun 2023 20:31:48 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 0761919451C1;
	Fri,  9 Jun 2023 20:31:48 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id EADD4194658C
 for <dm-devel@listman.corp.redhat.com>; Fri,  9 Jun 2023 20:31:46 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id D5F9B10C13; Fri,  9 Jun 2023 20:31:46 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id CE8BF10724
 for <dm-devel@redhat.com>; Fri,  9 Jun 2023 20:31:46 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B07843802AD8
 for <dm-devel@redhat.com>; Fri,  9 Jun 2023 20:31:46 +0000 (UTC)
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-376-YSdcgu19PyOGBwTobMaiKw-1; Fri, 09 Jun 2023 16:31:43 -0400
X-MC-Unique: YSdcgu19PyOGBwTobMaiKw-1
Received: by mail-qv1-f71.google.com with SMTP id
 6a1803df08f44-62619240316so23896006d6.3
 for <dm-devel@redhat.com>; Fri, 09 Jun 2023 13:31:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1686342703; x=1688934703;
 h=in-reply-to:content-transfer-encoding:content-disposition
 :mime-version:references:message-id:subject:cc:to:from:date
 :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=kqBodWvsMAtzK0roMuBBNkvevtML0piZ6ybEx/MweaE=;
 b=l5tGDJSSSVN7sl1A55iFtutSwajLBozWr6VB6VWEskIpXXDqq4uc1NSkzJD1Sr6BUc
 Li/ic6ZnV0r7Ch252lBjDUr/3LwoqyMB+tM0LUCW2WHamZkR4a59FmxMjcpUMIKa0Nqr
 jrVqUkWhPve+dWJAj50+69CbpnjI4lLUn2lu5bKRlurDie6s1wZxvyGHWyVT78nofD/9
 hRB9ZkaS4H+3W+wBJbtGg8G685qIro/WWSgKzz8NFaiSWS45VF1k3L3bPkpg2BmsXXLO
 z/L30+OYdk2OCcVBSTBS/DBQjWI7Stz66g8d2mOSYmRkcogVeG4dBi0WESJj+qSbq5Uj
 svTg==
X-Gm-Message-State: AC+VfDy+N6cbsXDJtxW1o6DO6rDvuYG9QI4SBj1E0eqI2jIbpBHEhhb+
 1Nc7s1AUjHkHh0tCXQrgj6ENvaW2CaVgyTolUh0iCUtutbmT6j9BRFA20VSN08dcWO623nEFaPX
 kx3H+GnJc8QoIWQ==
X-Received: by 2002:a05:6214:124a:b0:626:3a5a:f8dc with SMTP id
 r10-20020a056214124a00b006263a5af8dcmr3512866qvv.57.1686342703123; 
 Fri, 09 Jun 2023 13:31:43 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ78w0WDf0o6qhufepqm2d8bEB8MBtf2WH2t9YiWbkCms2QdUrQ0M7FAIP95SCC+cHOEnZuU1A==
X-Received: by 2002:a05:6214:124a:b0:626:3a5a:f8dc with SMTP id
 r10-20020a056214124a00b006263a5af8dcmr3512845qvv.57.1686342702858; 
 Fri, 09 Jun 2023 13:31:42 -0700 (PDT)
Received: from localhost (pool-68-160-166-30.bstnma.fios.verizon.net.
 [68.160.166.30]) by smtp.gmail.com with ESMTPSA id
 m24-20020ae9e718000000b007578622c861sm1250201qka.108.2023.06.09.13.31.42
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 09 Jun 2023 13:31:42 -0700 (PDT)
Date: Fri, 9 Jun 2023 16:31:41 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: Sarthak Kukreti <sarthakkukreti@chromium.org>
Message-ID: <ZIOMLfMjugGf4C2T@redhat.com>
References: <ZHFEfngPyUOqlthr@dread.disaster.area>
 <CAJ0trDZJQwvAzngZLBJ1hB0XkQ1HRHQOdNQNTw9nK-U5i-0bLA@mail.gmail.com>
 <ZHYB/6l5Wi+xwkbQ@redhat.com>
 <CAJ0trDaUOevfiEpXasOESrLHTCcr=oz28ywJU+s+YOiuh7iWow@mail.gmail.com>
 <ZHYWAGmKhwwmTjW/@redhat.com>
 <CAG9=OMMnDfN++-bJP3jLmUD6O=Q_ApV5Dr392_5GqsPAi_dDkg@mail.gmail.com>
 <ZHqOvq3ORETQB31m@dread.disaster.area>
 <ZHti/MLnX5xGw9b7@redhat.com>
 <CAG9=OMNv80fOyVixEY01XESnOFzYyfj9j8etHMq_Ap52z4UWNQ@mail.gmail.com>
 <ZIESXNF5anyvJEjm@redhat.com>
MIME-Version: 1.0
In-Reply-To: <ZIESXNF5anyvJEjm@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

T24gV2VkLCBKdW4gMDcgMjAyMyBhdCAgNzoyN1AgLTA0MDAsCk1pa2UgU25pdHplciA8c25pdHpl
ckBrZXJuZWwub3JnPiB3cm90ZToKCj4gT24gTW9uLCBKdW4gMDUgMjAyMyBhdCAgNToxNFAgLTA0
MDAsCj4gU2FydGhhayBLdWtyZXRpIDxzYXJ0aGFra3VrcmV0aUBjaHJvbWl1bS5vcmc+IHdyb3Rl
Ogo+IAo+ID4gT24gU2F0LCBKdW4gMywgMjAyMyBhdCA4OjU34oCvQU0gTWlrZSBTbml0emVyIDxz
bml0emVyQGtlcm5lbC5vcmc+IHdyb3RlOgo+ID4gPgo+ID4gPiBXZSBhbGwganVzdCBuZWVkIHRv
IGZvY3VzIG9uIHlvdXIgcHJvcG9zYWwgYW5kIEpvZSdzIGRtLXRoaW4KPiA+ID4gcmVzZXJ2YXRp
b24gZGVzaWduLi4uCj4gPiA+Cj4gPiA+IFtTYXJ0aGFrOiBGWUksIHRoaXMgaW1wbGllcyB0aGF0
IGl0IGRvZXNuJ3QgcmVhbGx5IG1ha2Ugc2Vuc2UgdG8gYWRkCj4gPiA+IGRtLXRoaW5wIHN1cHBv
cnQgYmVmb3JlIEpvZSdzIGRlc2lnbiBpcyBpbXBsZW1lbnRlZC4gIE90aGVyd2lzZSB3ZSdsbAo+
ID4gPiBoYXZlIDIgZGlmZmVyZW50IHJlc3BvbnNlcyB0byBSRVFfT1BfUFJPVklTSU9OLiAgVGhl
IG9uZSB0aGF0IGlzCj4gPiA+IGNhcHR1cmVkIGluIHlvdXIgcGF0Y2hzZXQgaXNuJ3QgYWRlcXVh
dGUgdG8gcHJvcGVybHkgaGFuZGxlIGVuc3VyaW5nCj4gPiA+IHVwcGVyIGxheWVyIChsaWtlIFhG
UykgY2FuIGRlcGVuZCBvbiB0aGUgc3BhY2UgYmVpbmcgYXZhaWxhYmxlIGFjcm9zcwo+ID4gPiBz
bmFwc2hvdCBib3VuZGFyaWVzLl0KPiA+ID4KPiA+IEFjay4gV291bGQgaXQgYmUgcHJlbWF0dXJl
IGZvciB0aGUgcmVzdCBvZiB0aGUgc2VyaWVzIHRvIGdvIHRocm91Z2gKPiA+IChSRVFfT1BfUFJP
VklTSU9OICsgc3VwcG9ydCBmb3IgbG9vcCBhbmQgbm9uLWRtLXRoaW5wIGRldmljZS1tYXBwZXIK
PiA+IHRhcmdldHMpPyBJJ2QgbGlrZSB0byBzdGFydCB1c2luZyB0aGlzIGFzIGEgcmVmZXJlbmNl
IHRvIHN1Z2dlc3QKPiA+IGFkZGl0aW9ucyB0byB0aGUgdmlydGlvLXNwZWMgZm9yIHZpcnRpby1i
bGsgc3VwcG9ydCBhbmQgc3RhcnQgbG9va2luZwo+ID4gYXQgd2hhdCBhbiBleHQ0IGltcGxlbWVu
dGF0aW9uIHdvdWxkIGxvb2sgbGlrZS4KPiAKPiBQbGVhc2UgZHJvcCB0aGUgZG0tdGhpbi5jIGFu
ZCBkbS1zbmFwLmMgY2hhbmdlcy4gIGRtLXNuYXAuYyB3b3VsZCBuZWVkCj4gbW9yZSB3b3JrIHRv
IHByb3ZpZGUgdGhlIHR5cGUgb2YgZ3VhcmFudGVlIFhGUyByZXF1aXJlcyBhY3Jvc3MKPiBzbmFw
c2hvdCBib3VuZGFyaWVzLiBJJ20gaW5jbGluZWQgdG8gX25vdF8gYWRkIGRtLXNuYXAuYyBzdXBw
b3J0Cj4gYmVjYXVzZSBpdCBpcyBiZXN0IHRvIGp1c3QgdXNlIGRtLXRoaW4uCj4gCj4gQW5kIEZZ
SSBldmVuIHlvdXIgZG0tdGhpbiBwYXRjaCB3aWxsIGJlIHRoZSBzdGFydGluZyBwb2ludCBmb3Ig
dGhlCj4gZG0tdGhpbiBzdXBwb3J0ICh3ZSdsbCBrZWVwIGF0dHJpYnV0aW9uIHRvIHlvdSBmb3Ig
YWxsIHRoZSBjb2RlIGluIGEKPiBzZXBhcmF0ZSBwYXRjaCkuCj4gCj4gPiBGYWlyIHBvaW50cywg
SSBjZXJ0YWlubHkgZG9uJ3Qgd2FudCB0byBkZXJhaWwgdGhpcyBjb252ZXJzYXRpb247IEknZAo+
ID4gYmUgaGFwcHkgdG8gc2VlIHRoaXMgd29yayBtZXJnZWQgc29vbmVyIHJhdGhlciB0aGFuIGxh
dGVyLgo+IAo+IE9uY2UgdGhvc2UgZG0gdGFyZ2V0IGNoYW5nZXMgYXJlIGRyb3BwZWQgSSB0aGlu
ayB0aGUgcmVzdCBvZiB0aGUKPiBzZXJpZXMgaXMgZmluZSB0byBnbyB1cHN0cmVhbSBub3cuICBG
ZWVsIGZyZWUgdG8gcG9zdCBhIHY4LgoKRllJLCBJJ3ZlIG1hZGUgbXkgbGF0ZXN0IGNvZGUgYXZh
aWxhYmxlIGluIHRoaXMKJ2RtLTYuNS1wcm92aXNpb24tc3VwcG9ydCcgYnJhbmNoIChiYXNlZCBv
biAnZG0tNi41Jyk6Cmh0dHBzOi8vZ2l0Lmtlcm5lbC5vcmcvcHViL3NjbS9saW51eC9rZXJuZWwv
Z2l0L2RldmljZS1tYXBwZXIvbGludXgtZG0uZ2l0L2xvZy8/aD1kbS02LjUtcHJvdmlzaW9uLXN1
cHBvcnQKCkl0J3Mgd2hhdCB2OCBzaG91bGQgYmUgcGx1cyB0aGUgMiBkbS10aGluIHBhdGNoZXMg
KHRoYXQgSSBkb24ndCB0aGluawpzaG91bGQgZ28gdXBzdHJlYW0geWV0LCBidXQgYXJlIHRoZW9y
ZXRpY2FsbHkgdXNlZnVsIGZvciBEYXZlIGFuZApKb2UpLgoKVGhlICJkbSB0aGluOiBjb21wbGV0
ZSBpbnRlcmZhY2UgZm9yIFJFUV9PUF9QUk9WSVNJT04gc3VwcG9ydCIgY29tbWl0CmVzdGFibGlz
aGVzIGFsbCB0aGUgZG0tdGhpbiBpbnRlcmZhY2UgSSB0aGluayBpcyBuZWVkZWQuICBUaGUgRklY
TUUgaW4KcHJvY2Vzc19wcm92aXNpb25fYmlvKCkgKGFuZCB0aGUgcGF0Y2ggaGVhZGVyKSBjYXV0
aW9ucyBhZ2FpbnN0IHVwcGVyCmxheWVycyBsaWtlIFhGUyB1c2luZyB0aGlzIGRtLXRoaW5wIHN1
cHBvcnQgcXVpdGUgeWV0LgoKT3RoZXJ3aXNlIHdlJ2xsIGhhdmUgdGhlIGlzc3VlIHdoZXJlIGRt
LXRoaW5wJ3MgUkVRX09QX1BST1ZJU0lPTgpzdXBwb3J0IGluaXRpYWxseSBkb2Vzbid0IHByb3Zp
ZGUgdGhlIGd1YXJhbnRlZSB0aGF0IFhGUyBuZWVkcyBhY3Jvc3MKc25hcHNob3RzICh3aGljaCBp
czogc25hcHNob3RzIGluaGVyaXQgYWxsIHByZXZpb3VzIFJFUV9PUF9QUk9WSVNJT04pLgoKTWlr
ZQoKLS0KZG0tZGV2ZWwgbWFpbGluZyBsaXN0CmRtLWRldmVsQHJlZGhhdC5jb20KaHR0cHM6Ly9s
aXN0bWFuLnJlZGhhdC5jb20vbWFpbG1hbi9saXN0aW5mby9kbS1kZXZlbAo=

