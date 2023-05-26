Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7FB85C7EE23
	for <dm-devel@archiver.kernel.org>; Fri, 26 May 2023 15:54:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685116473;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=DtDrTxcEeV1ZJtelB3n5reDipClm0uQkDA20hXplfXo=;
	b=CmMW1dYmq6k+Sw5hHNmp4vTfmSB68Pre3Ed56i3qR2+423gxgvhxSfJR1ZLY8FaUlajwsv
	jzTxKzatOj4fm4CudtxDY8EL+2PiNGdaz2yu9cO9viwEXuy8WsB3UycMiWFvPICZIa2Y1Y
	7x/Cyg6cKFHfru6ynkq+XA8ByFD2LWM=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-381-YliKBk2fONqK8aEL2LTzSA-1; Fri, 26 May 2023 11:54:30 -0400
X-MC-Unique: YliKBk2fONqK8aEL2LTzSA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 91E7E280D582;
	Fri, 26 May 2023 15:54:27 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 46BD740CFD45;
	Fri, 26 May 2023 15:54:27 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id EC11019465A4;
	Fri, 26 May 2023 15:54:26 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id DD22519465A0
 for <dm-devel@listman.corp.redhat.com>; Fri, 26 May 2023 15:54:13 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id C84DF40102D; Fri, 26 May 2023 15:54:13 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id C0402492B00
 for <dm-devel@redhat.com>; Fri, 26 May 2023 15:54:13 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A42C4811E78
 for <dm-devel@redhat.com>; Fri, 26 May 2023 15:54:13 +0000 (UTC)
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-480-j_7fQio_Pvy1YqcEQgZ1GA-1; Fri, 26 May 2023 11:54:12 -0400
X-MC-Unique: j_7fQio_Pvy1YqcEQgZ1GA-1
Received: by mail-qv1-f70.google.com with SMTP id
 6a1803df08f44-6239bc2f646so7319846d6.2
 for <dm-devel@redhat.com>; Fri, 26 May 2023 08:54:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1685116451; x=1687708451;
 h=in-reply-to:content-transfer-encoding:content-disposition
 :mime-version:references:message-id:subject:cc:to:from:date
 :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=yvxKbFohSEsTJ6py9Z2WVJoxOwakRTNCjSwfmDukp7I=;
 b=AQeNTwVuzJSpB2s4ll32sSt68feEjsILGfzBwqCkhXUKE7dDxVBDjTWWHuWjkRZT2C
 kP+mRbHoV58OYWrYbHrbbFk2vyhtoVXIK0LdfRfEu069iRUPfBhm8LXKTTNP3VleW7+9
 VB7aWnwZ00e4pXzST+/Wxn8+cOOniRseM00LaCJP3DXX1opOWHroShePBn4cZ7MATBCr
 HISwjPEN4cBtOoA4UJ0djs79qLELJfTmMSvSRfIBUdTki8+6BtbfOHIZq0PP3k+SsspC
 Aw0+1W6INHgmTNmtvumthsH8RZbX0K6A/eoLDrGG3FGq7HDceeqsjkHTqgXyCH0sB+G7
 4f7A==
X-Gm-Message-State: AC+VfDy0BHysSGTofyNrJayy0Kx0vm+5Oy336ARHuXwlS4hxb324ozRu
 fanYX43u78ErHpjYF/O4UkDec8VVRWLmACqm8riwKfQQgqnTe+p1bd0yIaTKQ0GNhylwrSG6mbu
 mHLiXbU9JgMJT8/MramyaegyZ0Q==
X-Received: by 2002:a05:6214:20e2:b0:621:6217:f528 with SMTP id
 2-20020a05621420e200b006216217f528mr2129209qvk.30.1685116451611; 
 Fri, 26 May 2023 08:54:11 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ7crxinp6L7mS4raZXU4iJU8lF1hK2z1fz8ghdfLF7RtzHOAE7Y1Kt0NJxyPfYsUfrY8tCFQg==
X-Received: by 2002:a05:6214:20e2:b0:621:6217:f528 with SMTP id
 2-20020a05621420e200b006216217f528mr2129188qvk.30.1685116451285; 
 Fri, 26 May 2023 08:54:11 -0700 (PDT)
Received: from bfoster (c-24-61-119-116.hsd1.ma.comcast.net. [24.61.119.116])
 by smtp.gmail.com with ESMTPSA id
 m6-20020a0ce8c6000000b006260bff22d7sm310600qvo.27.2023.05.26.08.54.09
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 26 May 2023 08:54:10 -0700 (PDT)
Date: Fri, 26 May 2023 11:56:41 -0400
From: Brian Foster <bfoster@redhat.com>
To: Sarthak Kukreti <sarthakkukreti@chromium.org>
Message-ID: <ZHDWuac/IvLKgPbK@bfoster>
References: <ZGu0LaQfREvOQO4h@redhat.com> <ZGzIJlCE2pcqQRFJ@bfoster>
 <ZGzbGg35SqMrWfpr@redhat.com>
 <ZG1dAtHmbQ53aOhA@dread.disaster.area>
 <ZG5taYoXDRymo/e9@redhat.com>
 <ZG9JD+4Zu36lnm4F@dread.disaster.area>
 <ZG+GKwFC7M3FfAO5@redhat.com>
 <CAG9=OMNhCNFhTcktxSMYbc5WXkSZ-vVVPtb4ak6B3Z2-kEVX0Q@mail.gmail.com>
 <ZHANCbnHuhnwCrGz@dread.disaster.area>
 <CAG9=OMPxHOzYcy8TQRnvNfNvPvvU=A1pceyL72JfyQwJSKNjQQ@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAG9=OMPxHOzYcy8TQRnvNfNvPvvU=A1pceyL72JfyQwJSKNjQQ@mail.gmail.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
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
 Theodore Ts'o <tytso@mit.edu>, dm-devel@redhat.com,
 "Michael S. Tsirkin" <mst@redhat.com>, Dave Chinner <david@fromorbit.com>,
 Jason Wang <jasowang@redhat.com>, Bart Van Assche <bvanassche@google.com>,
 Mike Snitzer <snitzer@kernel.org>, linux-kernel@vger.kernel.org,
 linux-block@vger.kernel.org, Joe Thornber <ejt@redhat.com>,
 Andreas Dilger <adilger.kernel@dilger.ca>,
 Stefan Hajnoczi <stefanha@redhat.com>, "Darrick J. Wong" <djwong@kernel.org>,
 linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
 Alasdair Kergon <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

T24gVGh1LCBNYXkgMjUsIDIwMjMgYXQgMDc6MzU6MTRQTSAtMDcwMCwgU2FydGhhayBLdWtyZXRp
IHdyb3RlOgo+IE9uIFRodSwgTWF5IDI1LCAyMDIzIGF0IDY6MzbigK9QTSBEYXZlIENoaW5uZXIg
PGRhdmlkQGZyb21vcmJpdC5jb20+IHdyb3RlOgo+ID4KPiA+IE9uIFRodSwgTWF5IDI1LCAyMDIz
IGF0IDAzOjQ3OjIxUE0gLTA3MDAsIFNhcnRoYWsgS3VrcmV0aSB3cm90ZToKPiA+ID4gT24gVGh1
LCBNYXkgMjUsIDIwMjMgYXQgOTowMOKAr0FNIE1pa2UgU25pdHplciA8c25pdHplckBrZXJuZWwu
b3JnPiB3cm90ZToKPiA+ID4gPiBPbiBUaHUsIE1heSAyNSAyMDIzIGF0ICA3OjM5UCAtMDQwMCwK
PiA+ID4gPiBEYXZlIENoaW5uZXIgPGRhdmlkQGZyb21vcmJpdC5jb20+IHdyb3RlOgo+ID4gPiA+
ID4gT24gV2VkLCBNYXkgMjQsIDIwMjMgYXQgMDQ6MDI6NDlQTSAtMDQwMCwgTWlrZSBTbml0emVy
IHdyb3RlOgo+ID4gPiA+ID4gPiBPbiBUdWUsIE1heSAyMyAyMDIzIGF0ICA4OjQwUCAtMDQwMCwK
PiA+ID4gPiA+ID4gRGF2ZSBDaGlubmVyIDxkYXZpZEBmcm9tb3JiaXQuY29tPiB3cm90ZToKPiA+
ID4gPiA+ID4gPiBJdCdzIHdvcnRoIG5vdGluZyB0aGF0IFhGUyBhbHJlYWR5IGhhcyBhIGNvYXJz
ZS1ncmFpbmVkCj4gPiA+ID4gPiA+ID4gaW1wbGVtZW50YXRpb24gb2YgcHJlZmVycmVkIHJlZ2lv
bnMgZm9yIG1ldGFkYXRhIHN0b3JhZ2UuIEl0IHdpbGwKPiA+ID4gPiA+ID4gPiBjdXJyZW50bHkg
bm90IHVzZSB0aG9zZSBtZXRhZGF0YS1wcmVmZXJyZWQgcmVnaW9ucyBmb3IgdXNlciBkYXRhCj4g
PiA+ID4gPiA+ID4gdW5sZXNzIGFsbCB0aGUgcmVtYWluaW5nIHVzZXIgZGF0YSBzcGFjZSBpcyBm
dWxsLiAgSGVuY2UgSSdtIHByZXR0eQo+ID4gPiA+ID4gPiA+IHN1cmUgdGhhdCBhIHByZS1wcm92
aXNpb25pbmcgZW5oYW5jbWVudCBsaWtlIHRoaXMgY2FuIGJlIGRvbmUKPiA+ID4gPiA+ID4gPiBl
bnRpcmVseSBpbi1tZW1vcnkgd2l0aG91dCByZXF1aXJpbmcgYW55IG5ldyBvbi1kaXNrIHN0YXRl
IHRvIGJlCj4gPiA+ID4gPiA+ID4gYWRkZWQuCj4gPiA+ID4gPiA+ID4KPiA+ID4gPiA+ID4gPiBT
dXJlLCBpZiB3ZSBjcmFzaCBhbmQgcmVtb3VudCwgdGhlbiB3ZSBtaWdodCBjaG9zZSBhIGRpZmZl
cmVudCBMQkEKPiA+ID4gPiA+ID4gPiByZWdpb24gZm9yIHByZS1wcm92aXNpb25pbmcuIEJ1dCB0
aGF0J3Mgbm90IHJlYWxseSBhIGh1Z2UgZGVhbCBhcyB3ZQo+ID4gPiA+ID4gPiA+IGNvdWxkIGFs
c28gcnVuIGFuIGludGVybmFsIGJhY2tncm91bmQgcG9zdC1tb3VudCBmc3RyaW0gb3BlcmF0aW9u
IHRvCj4gPiA+ID4gPiA+ID4gcmVtb3ZlIGFueSB1bnVzZWQgcHJlLXByb3Zpc2lvbmluZyB0aGF0
IHdhcyBsZWZ0IG92ZXIgZnJvbSB3aGVuIHRoZQo+ID4gPiA+ID4gPiA+IHN5c3RlbSB3ZW50IGRv
d24uCj4gPiA+ID4gPiA+Cj4gPiA+ID4gPiA+IFRoaXMgd291bGQgYmUgdGhlIEZJVFJJTSB3aXRo
IGV4dGVuc2lvbiB5b3UgbWVudGlvbiBiZWxvdz8gV2hpY2ggaXMgYQo+ID4gPiA+ID4gPiBmaWxl
c3lzdGVtIGludGVyZmFjZSBkZXRhaWw/Cj4gPiA+ID4gPgo+ID4gPiA+ID4gTm8uIFdlIG1pZ2h0
IHJldXNlIHNvbWUgb2YgdGhlIGludGVybmFsIGluZnJhc3RydWN0dXJlIHdlIHVzZSB0bwo+ID4g
PiA+ID4gaW1wbGVtZW50IEZJVFJJTSwgYnV0IHRoYXQncyBhYm91dCBpdC4gSXQncyBqdXN0IHNv
bWV0aGluZyBraW5kYQo+ID4gPiA+ID4gbGlrZSBGSVRSSU0gYnV0IHdpdGggZGlmZmVyZW50IGNv
bnN0cmFpbnRzIGRldGVybWluZWQgYnkgdGhlCj4gPiA+ID4gPiBmaWxlc3lzdGVtIHJhdGhlciB0
aGFuIHRoZSB1c2VyLi4uCj4gPiA+ID4gPgo+ID4gPiA+ID4gQXMgaXQgaXMsIEknbSBub3Qgc3Vy
ZSB3ZSdkIGV2ZW4gbmVlZCBpdCAtIGEgcHJlaW9kaWMgdXNlcnNwYWNlCj4gPiA+ID4gPiBGSVRS
SU0gd291bGQgYWNoZWl2ZSB0aGUgc2FtZSByZXN1bHQsIHNvIGxlYWtlZCBwcm92aXNpb25lZCBz
cGFjZXMKPiA+ID4gPiA+IHdvdWxkIGdldCBjbGVhbmVkIHVwIGV2ZW50dWFsbHkgd2l0aG91dCB0
aGUgZmlsZXN5c3RlbSBoYXZpbmcgdG8gZG8KPiA+ID4gPiA+IGFueXRoaW5nIHNwZWNpZmljLi4u
Cj4gPiA+ID4gPgo+ID4gPiA+ID4gPiBTbyBkbS10aGlucCB3b3VsZCBfbm90XyBuZWVkIHRvIGhh
dmUgbmV3Cj4gPiA+ID4gPiA+IHN0YXRlIHRoYXQgdHJhY2tzICJwcm92aXNpb25lZCBidXQgdW51
c2VkIiBibG9jaz8KPiA+ID4gPiA+Cj4gPiA+ID4gPiBObyBpZGVhIC0gdGhhdCdzIHlvdXIgZG9t
YWluLiA6KQo+ID4gPiA+ID4KPiA+ID4gPiA+IGRtLXNuYXBzaG90LCBmb3IgY2VydGFpbiwgd2ls
bCBuZWVkIHRvIHRyYWNrIHByb3Zpc2lvbmVkIHJlZ2lvbnMKPiA+ID4gPiA+IGJlY2F1c2UgaXQg
aGFzIHRvIGd1YXJhbnRlZSB0aGF0IG92ZXJ3cml0ZXMgdG8gcHJvdmlzaW9uZWQgc3BhY2UgaW4K
PiA+ID4gPiA+IHRoZSBvcmlnaW4gZGV2aWNlIHdpbGwgYWx3YXlzIHN1Y2NlZWQuIEhlbmNlIGl0
IG5lZWRzIHRvIGtub3cgaG93Cj4gPiA+ID4gPiBtdWNoIHNwYWNlIGJyZWFraW5nIHNoYXJpbmcg
aW4gcHJvdmlzaW9uZWQgcmVnaW9ucyBhZnRlciBhIHNuYXBzaG90Cj4gPiA+ID4gPiBoYXMgYmVl
biB0YWtlbiB3aXRoIGJlIHJlcXVpcmVkLi4uCj4gPiA+ID4KPiA+ID4gPiBkbS10aGlucCBvZmZl
cnMgaXRzIG93biBtdWNoIG1vcmUgc2NhbGFibGUgc25hcHNob3Qgc3VwcG9ydCAoZG9lc24ndAo+
ID4gPiA+IHVzZSBvbGQgZG0tc25hcHNob3QgTi13YXkgY29weW91dCB0YXJnZXQpLgo+ID4gPiA+
Cj4gPiA+ID4gZG0tc25hcHNob3QgaXNuJ3QgZ29pbmcgdG8gYmUgbW9kaWZpZWQgdG8gc3VwcG9y
dCB0aGlzIGxldmVsIG9mCj4gPiA+ID4gaGFyZGVuaW5nIChkbS1zbmFwc2hvdCBpcyBiYXNpY2Fs
bHkgaW4gIm1haW50ZW5hbmNlIG9ubHkiIG5vdykuCj4gPgo+ID4gQWgsIG9mIGNvdXJzZS4gU29y
cnkgZm9yIHRoZSBjb25mdXNpb24sIEkgd2FzIGtpbmRhIHVzaW5nCj4gPiBkbS1zbmFwc2hvdCBh
cyBzaG9ydGhhbmQgZm9yICJkbS10aGlucCArIHNuYXBzaG90cyIuCj4gPgo+ID4gPiA+IEJ1dCBJ
IHVuZGVyc3RhbmQgeW91ciBtZWFuaW5nOiB3aGF0IHlvdSBzYWlkIGlzIDEwMCUgYXBwbGljYWJs
ZSB0bwo+ID4gPiA+IGRtLXRoaW5wJ3Mgc25hcHNob3QgaW1wbGVtZW50YXRpb24gYW5kIG5lZWRz
IHRvIGJlIGFjY291bnRlZCBmb3IgaW4KPiA+ID4gPiB0aGlucCdzIG1ldGFkYXRhIChpbmhlcmVu
dCAncHJvdmlzaW9uZWQnIGZsYWcpLgo+ID4KPiA+ICpub2QqCj4gPgo+ID4gPiBBIGJpdCBvcnRo
b2dvbmFsOiB3b3VsZCBkbS10aGlucCBuZWVkIHRvIGRpZmZlcmVudGlhdGUgYmV0d2Vlbgo+ID4g
PiB1c2VyLXRyaWdnZXJlZCBwcm92aXNpb24gcmVxdWVzdHMgKGVnLiBmcm9tIGZhbGxvY2F0ZSgp
KSB2cwo+ID4gPiBmcy10cmlnZ2VyZWQgcmVxdWVzdHM/Cj4gPgo+ID4gV2h5PyAgSG93IGlzIHRo
ZSBndWFyYW50ZWUgdGhlIGJsb2NrIGRldmljZSBoYXMgdG8gcHJvdmlkZSB0bwo+ID4gcHJvdmlz
aW9uZWQgYXJlYXMgZGlmZmVyZW50IGZvciB1c2VyIHZzIGZpbGVzeXN0ZW0gaW50ZXJuYWwKPiA+
IHByb3Zpc2lvbmVkIHNwYWNlPwo+ID4KPiBBZnRlciB0aGlua2luZyB0aGlzIHRocm91Z2gsIEkg
c3RhbmQgY29ycmVjdGVkLiBJIHdhcyBwcmltYXJpbHkKPiBjb25jZXJuZWQgd2l0aCBob3cgdGhp
cyB3b3VsZCBiYWxsb29uIHRoaW4gc25hcHNob3Qgc2l6ZXMgaWYgdXNlcnMKPiBwb3RlbnRpYWxs
eSBwcm92aXNpb24gYSBsYXJnZSBjaHVuayBvZiB0aGUgZmlsZXN5c3RlbSBidXQgdGhhdCdzCj4g
cHV0dGluZyB0aGUgY2FydCB3YXkgYmVmb3JlIHRoZSBob3JzZS4KPiAKCkkgdGhpbmsgdGhhdCdz
IGEgbGVnaXRpbWF0ZSBjb25jZXJuLiBBdCBzb21lIHBvaW50IHRvIHByb3ZpZGUgZnVsbAotRU5P
U1BDIHByb3RlY3Rpb24gdGhlIGZpbGVzeXN0ZW0gbmVlZHMgdG8gcHJvdmlzaW9uIHNwYWNlIGJl
Zm9yZSBpdAp3cml0ZXMgdG8gaXQsIHdoZXRoZXIgaXQgYmUgZGF0YSBvciBtZXRhZGF0YSwgcmln
aHQ/IEF0IHdoYXQgcG9pbnQgZG9lcwp0aGF0IHR1cm4gaW50byBhIGNhc2Ugd2hlcmUgcHJldHR5
IG11Y2ggZXZlcnl0aGluZyB0aGUgZnMgd3JvdGUgaXMKcHJvdmlzaW9uZWQsIGFuZCB0aGVyZWZv
cmUgYSBzbmFwc2hvdCBpcyBqdXN0IGEgZnVsbCBjb3B5IG9wZXJhdGlvbj8KClRoYXQgbWlnaHQg
YmUgT2sgSSBndWVzcywgYnV0IGlmIHRoYXQncyBhbiBldmVudHVhbGl0eSB0aGVuIHdoYXQncyB0
aGUKbmVlZCB0byB0cmFjayBwcm92aXNpb24gc3RhdGUgYXQgZG0tdGhpbiBibG9jayBsZXZlbD8g
VXNpbmcgc29tZSBraW5kIG9mCmZsYWcgeW91IG1lbnRpb24gYmVsb3cgY291bGQgYmUgYSBnb29k
IHdheSB0byBxdWFsaWZ5IHdoaWNoIGJsb2NrcyB5b3UnZAp3YW50IHRvIGNvcHkgdnMuIHdoaWNo
IHRvIHNoYXJlIG9uIHNuYXBzaG90IGFuZCBwZXJoYXBzIG1pdGlnYXRlIHRoYXQKcHJvYmxlbS4K
Cj4gQmVzdAo+IFNhcnRoYWsKPiAKPiA+ID4gSSB3b3VsZCBsZWFuIHRvd2FyZHMgdXNlciBwcm92
aXNpb25lZCBhcmVhcyBub3QKPiA+ID4gZ2V0dGluZyBkZWR1cCdkIG9uIHNuYXBzaG90IGNyZWF0
aW9uLAo+ID4KPiA+IDx0d2l0Y2g+Cj4gPgo+ID4gU25hcHNob3R0aW5nIGlzIGEgY2xvbmUgb3Bl
cmF0aW9uLCBub3QgYSBkZWR1cGUgb3BlcmF0aW9uLgo+ID4KPiA+IFllcywgdGhlIGVuZCByZXN1
bHQgb2YgYm90aCBpcyB0aGF0IHlvdSBoYXZlIGEgYmxvY2sgc2hhcmVkIGJldHdlZW4KPiA+IG11
bHRpcGxlIGluZGV4ZXMgdGhhdCBuZWVkcyBDT1cgb24gdGhlIG5leHQgb3ZlcndyaXRlLCBidXQg
dGhlIHR3bwo+ID4gb3BlcmF0aW9ucyB0aGF0IGdldCB0byB0aGF0IHBvaW50IGFyZSB2ZXJ5IGRp
ZmZlcmVudC4uLgo+ID4KPiA+IDwvcGVkYW50aWMgbW9kZSBkaXNlZ2FnZWQ+Cj4gPgo+ID4gPiBi
dXQgdGhhdCB3b3VsZCBlbnRhaWwgdHJhY2tpbmcKPiA+ID4gdGhlIHN0YXRlIG9mIHRoZSBvcmln
aW5hbCByZXF1ZXN0IGFuZCBwb3NzaWJseSBhIHByb3Zpc2lvbiByZXF1ZXN0Cj4gPiA+IGZsYWcg
KFJFUV9QUk9WSVNJT05fREVEVVBfT05fU05BUFNIT1QpIG9yIGFuIGludmVyc2UgZmxhZwo+ID4g
PiAoUkVRX1BST1ZJU0lPTl9OT0RFRFVQKS4gUG9zc2libHkgdG9vIGNvbnZvbHV0ZWQuLi4KPiA+
Cj4gPiBMZXQncyBub3QgdHJ5IHRvIGFkZCBldmVyeW9uZSdzIGZhdm91cml0ZSBwb255IHRvIHRo
aXMgaW50ZXJmYWNlCj4gPiBiZWZvcmUgd2UndmUgZXZlbiBnb3QgaXQgb2ZmIHRoZSBncm91bmQu
Cj4gPgo+ID4gSXQncyB0aGUgc2ltcGxlIHByZWNpc2lvbiBvZiB0aGUgQVBJLCB0aGUgbGFjayBv
ZiBjcm9zcy1sYXllcgo+ID4gY29tbXVuaWNhdGlvbiByZXF1aXJlbWVudHMgYW5kIHRoZSBhYmls
aXR5IHRvIGltcGxlbWVudCBhbmQgb3B0aW1pc2UKPiA+IHRoZSBpbmRlcGVuZGVudCBsYXllcnMg
aW5kZXBlbmRlbnRseSB0aGF0IG1ha2VzIHRoaXMgYSB2ZXJ5Cj4gPiBhcHBlYWxpbmcgc29sdXRp
b24uCj4gPgo+ID4gV2UgbmVlZCB0byBzdGFydCB3aXRoIGdldHRpbmcgdGhlIHNpbXBsZSBzdHVm
ZiB3b3JraW5nIGFuZCBwcm92ZSB0aGUKPiA+IGNvbmNlcHQuIFRoZW4gb25jZSB3ZSBjYW4gb2Jz
ZXJ2ZSB0aGUgYmVoYXZpb3VyIG9mIGEgd29ya2luZyBzeXN0ZW0KPiA+IHdlIGNhbiBzdGFydCB3
b3JraW5nIG9uIG9wdGltaXNpbmcgaW5kaXZpZHVhbCBsYXllcnMgZm9yIGVmZmljaWVuY3kKPiA+
IGFuZCBwZXJmb3JtYW5jZS4uLi4KPiA+CgpJIHRoaW5rIHRvIHByb3ZlIHRoZSBjb25jZXB0IG1h
eSBub3QgbmVjZXNzYXJpbHkgcmVxdWlyZSBjaGFuZ2VzIHRvCmRtLXRoaW4gYXQgYWxsLiBJZiB5
b3Ugd2FudCB0byBndWFyYW50ZWUgcHJlZXhpc3RpbmcgbWV0YWRhdGEgYmxvY2sKd3JpdGVhYmls
aXR5LCBqdXN0IHNjYW4gdGhyb3VnaCBhbmQgcHJvdmlzaW9uIGFsbCBtZXRhZGF0YSBibG9ja3Mg
YXQKbW91bnQgdGltZS4gSGl0IHRoZSBsb2csIEFHIGJ1ZnMsIElJUkMgWEZTIGFscmVhZHkgaGFz
IGJ0cmVlIHdhbGtpbmcKY29kZSB0aGF0IGNhbiBiZSB1c2VkIGZvciBidHJlZXMgYW5kIGFzc29j
aWF0ZWQgbWV0YWRhdGEsIGV0Yy4gTWF5YmUKb25saW5lIHNjcnViIGhhcyBzb21ldGhpbmcgZXZl
biBiZXR0ZXIgdG8gaG9vayBpbnRvIHRlbXBvcmFyaWx5IGZvciB0aGlzCnNvcnQgb2YgdGhpbmc/
CgpNb3VudCBwZXJmb3JtYW5jZSB3b3VsZCBvYnZpb3VzbHkgYmUgYmFkLCBidXQgdGhhdCBkb2Vz
bid0IG1hdHRlciBmb3IKdGhlIHB1cnBvc2VzIG9mIGEgcHJvdG90eXBlLiBUaGUgZ29hbCBzaG91
bGQgcmVhbGx5IGJlIHRoYXQgb25jZQptb3VudGVkLCB5b3UgaGF2ZSBlc3RhYmxpc2hlZCBleHBl
Y3RlZCB3cml0ZWFiaWxpdHkgaW52YXJpYW50cyBhbmQgaGF2ZQp0aGUgYWJpbGl0eSB0byB0ZXN0
IGZvciByZWxpYWJsZSBwcmV2ZW50aW9uIG9mIC1FTk9TUEMgZXJyb3JzIGZyb20KZG0tdGhpbiBm
cm9tIHRoYXQgcG9pbnQgZm9yd2FyZC4gSWYgdGhhdCB1bHRpbWF0ZWx5IHdvcmtzLCB0aGVuIHJl
ZmluZQp0aGUgaWRlYWwgaW1wbGVtZW50YXRpb24gZnJvbSB0aGVyZSBhbmQgYXNrIGRtIHRvIGRv
IHdoYXRldmVyCndyaXRlYWJpbGl0eSB0cmFja2luZyBhbmQgd2hhdG5vdC4KCkZXSVcsIHRoYXQg
bWF5IGFsc28gaGVscCBkZWFsIHdpdGggdGhpbmdzIGxpa2UgdGhlIGZhY3QgdGhhdCB4ZnNfcmVw
YWlyCmNhbiBiYXNpY2FsbHkgcmVsb2NhdGUgdGhlIGVudGlyZSBzZXQgb2YgZmlsZXN5c3RlbSBt
ZXRhZGF0YSB0bwpjb21wbGV0ZWx5IGRpZmZlcmVudCByYW5nZXMgb2YgZnJlZSBzcGFjZSwgY29t
cGxldGVseSBicmVha2luZyBhbnkKd3JpdGVhYmlsaXR5IGd1YXJhbnRlZXMgdHJhY2tlZCBieSBw
cmV2aW91cyBwcm92aXNpb25zIG9mIHRob3NlIHJhbmdlcy4KCkJyaWFuCgo+ID4gQ2hlZXJzLAo+
ID4KPiA+IERhdmUuCj4gPiAtLQo+ID4gRGF2ZSBDaGlubmVyCj4gPiBkYXZpZEBmcm9tb3JiaXQu
Y29tCj4gCgotLQpkbS1kZXZlbCBtYWlsaW5nIGxpc3QKZG0tZGV2ZWxAcmVkaGF0LmNvbQpodHRw
czovL2xpc3RtYW4ucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRldmVsCg==

