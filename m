Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 84027C7EE25
	for <dm-devel@archiver.kernel.org>; Fri,  9 Jun 2023 21:54:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686347692;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=Ytg9dFWvG5tnaPDHEYlSjO2Yn3o1MI+7sQfRnuHFzlY=;
	b=Uk+c2Cmv6aI9QKYNARRRRyg04MSVTBJc4DMAqUie2pNHrNg9StoGPN0XhIAlBUTu9CbYKW
	YnfL9darGV2NSkG3hmDhHg5u+FUGlU6r4PIb+pRmRo0I8gum3HwUTNFe7zCQ4slceHo9C5
	l5Z5DUXE55kkGPh9Uq6CbPPzoogNEe0=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-450-mIgn3Cn5Mp2Tl1epS5xwQA-1; Fri, 09 Jun 2023 17:54:49 -0400
X-MC-Unique: mIgn3Cn5Mp2Tl1epS5xwQA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6618C2A59556;
	Fri,  9 Jun 2023 21:54:47 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 2F15C1121315;
	Fri,  9 Jun 2023 21:54:45 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id D547019451C1;
	Fri,  9 Jun 2023 21:54:44 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id DF9E6194658C
 for <dm-devel@listman.corp.redhat.com>; Fri,  9 Jun 2023 21:54:43 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 9FC3110EB0; Fri,  9 Jun 2023 21:54:43 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 9842A10724
 for <dm-devel@redhat.com>; Fri,  9 Jun 2023 21:54:43 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 783098007D9
 for <dm-devel@redhat.com>; Fri,  9 Jun 2023 21:54:43 +0000 (UTC)
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com
 [209.85.210.176]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-282-1GH_MZaxMpGWMkvc3_Tqlw-1; Fri, 09 Jun 2023 17:54:41 -0400
X-MC-Unique: 1GH_MZaxMpGWMkvc3_Tqlw-1
Received: by mail-pf1-f176.google.com with SMTP id
 d2e1a72fcca58-653f9c7b3e4so1846716b3a.2
 for <dm-devel@redhat.com>; Fri, 09 Jun 2023 14:54:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1686347680; x=1688939680;
 h=in-reply-to:content-transfer-encoding:content-disposition
 :mime-version:references:message-id:subject:cc:to:from:date
 :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=XPZ0YqKq/WukCdmDJhCk3d2gnOJ/ZDLhdj7edRPgO8w=;
 b=SLcNLX1mkKzIZAO7AAqjbbGgKNWCLWlsWnoee1ShpnDMa1Dy8hghA4gNhUxsoF4poe
 sjLbpnTP0GcCFkPcGJmwbLhW7SFg0TVikc5ObiH1du7NnZcHJHRd4GSc8qMWFJFoXzVC
 4h19koYRhyeNxDoHk0XdkvoLZk6/wM/cJBd0c0rYrOGy90OFN48Olp0z3trHLdh7ImeS
 G03x5X25rmIrjZH/zlxnFXZ8GrHofKztmybKIoU2ruDpQm/X6Obsg+9BtiogE865EuhD
 nXbN4NzJoho9a/h5qHGhuSt7NvQx8gctwsr4jQWK8tdGFoFzg/+C+8wXSe5wb+cscitZ
 IkKA==
X-Gm-Message-State: AC+VfDxat2YEbV3USiHDwWymzhzRRjH38JDDzgYmhOf3bivlaGfUxxOx
 TquonnwxqfWmtWVbDkZzF/La8A==
X-Google-Smtp-Source: ACHHUZ7+SuqJnp9//p1l5K264TTrLPu0q5rjuOaTTocEpZo7EWHXy5jYhcLfVXBXsWNsGfhXyK1I1w==
X-Received: by 2002:a05:6a20:c183:b0:10c:7c72:bdf9 with SMTP id
 bg3-20020a056a20c18300b0010c7c72bdf9mr1976311pzb.29.1686347680562; 
 Fri, 09 Jun 2023 14:54:40 -0700 (PDT)
Received: from dread.disaster.area (pa49-179-79-151.pa.nsw.optusnet.com.au.
 [49.179.79.151]) by smtp.gmail.com with ESMTPSA id
 u5-20020aa78385000000b0064d4d11b8bfsm3064066pfm.59.2023.06.09.14.54.39
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 09 Jun 2023 14:54:40 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
 (envelope-from <david@fromorbit.com>) id 1q7k44-009qQ3-0w;
 Sat, 10 Jun 2023 07:54:36 +1000
Date: Sat, 10 Jun 2023 07:54:36 +1000
From: Dave Chinner <david@fromorbit.com>
To: Mike Snitzer <snitzer@redhat.com>
Message-ID: <ZIOfnPFucQMpQAJ/@dread.disaster.area>
References: <CAJ0trDZJQwvAzngZLBJ1hB0XkQ1HRHQOdNQNTw9nK-U5i-0bLA@mail.gmail.com>
 <ZHYB/6l5Wi+xwkbQ@redhat.com>
 <CAJ0trDaUOevfiEpXasOESrLHTCcr=oz28ywJU+s+YOiuh7iWow@mail.gmail.com>
 <ZHYWAGmKhwwmTjW/@redhat.com>
 <CAG9=OMMnDfN++-bJP3jLmUD6O=Q_ApV5Dr392_5GqsPAi_dDkg@mail.gmail.com>
 <ZHqOvq3ORETQB31m@dread.disaster.area>
 <ZHti/MLnX5xGw9b7@redhat.com>
 <CAG9=OMNv80fOyVixEY01XESnOFzYyfj9j8etHMq_Ap52z4UWNQ@mail.gmail.com>
 <ZIESXNF5anyvJEjm@redhat.com> <ZIOMLfMjugGf4C2T@redhat.com>
MIME-Version: 1.0
In-Reply-To: <ZIOMLfMjugGf4C2T@redhat.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
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
 Joe Thornber <thornber@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>,
 dm-devel@redhat.com, "Michael S. Tsirkin" <mst@redhat.com>,
 "Darrick J. Wong" <djwong@kernel.org>, Jason Wang <jasowang@redhat.com>,
 Bart Van Assche <bvanassche@google.com>, linux-kernel@vger.kernel.org,
 Christoph Hellwig <hch@infradead.org>, Joe Thornber <ejt@redhat.com>,
 Andreas Dilger <adilger.kernel@dilger.ca>,
 Sarthak Kukreti <sarthakkukreti@chromium.org>, linux-fsdevel@vger.kernel.org,
 Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org,
 Brian Foster <bfoster@redhat.com>, Alasdair Kergon <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: fromorbit.com
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

T24gRnJpLCBKdW4gMDksIDIwMjMgYXQgMDQ6MzE6NDFQTSAtMDQwMCwgTWlrZSBTbml0emVyIHdy
b3RlOgo+IE9uIFdlZCwgSnVuIDA3IDIwMjMgYXQgIDc6MjdQIC0wNDAwLAo+IE1pa2UgU25pdHpl
ciA8c25pdHplckBrZXJuZWwub3JnPiB3cm90ZToKPiAKPiA+IE9uIE1vbiwgSnVuIDA1IDIwMjMg
YXQgIDU6MTRQIC0wNDAwLAo+ID4gU2FydGhhayBLdWtyZXRpIDxzYXJ0aGFra3VrcmV0aUBjaHJv
bWl1bS5vcmc+IHdyb3RlOgo+ID4gCj4gPiA+IE9uIFNhdCwgSnVuIDMsIDIwMjMgYXQgODo1N+KA
r0FNIE1pa2UgU25pdHplciA8c25pdHplckBrZXJuZWwub3JnPiB3cm90ZToKPiA+ID4gPgo+ID4g
PiA+IFdlIGFsbCBqdXN0IG5lZWQgdG8gZm9jdXMgb24geW91ciBwcm9wb3NhbCBhbmQgSm9lJ3Mg
ZG0tdGhpbgo+ID4gPiA+IHJlc2VydmF0aW9uIGRlc2lnbi4uLgo+ID4gPiA+Cj4gPiA+ID4gW1Nh
cnRoYWs6IEZZSSwgdGhpcyBpbXBsaWVzIHRoYXQgaXQgZG9lc24ndCByZWFsbHkgbWFrZSBzZW5z
ZSB0byBhZGQKPiA+ID4gPiBkbS10aGlucCBzdXBwb3J0IGJlZm9yZSBKb2UncyBkZXNpZ24gaXMg
aW1wbGVtZW50ZWQuICBPdGhlcndpc2Ugd2UnbGwKPiA+ID4gPiBoYXZlIDIgZGlmZmVyZW50IHJl
c3BvbnNlcyB0byBSRVFfT1BfUFJPVklTSU9OLiAgVGhlIG9uZSB0aGF0IGlzCj4gPiA+ID4gY2Fw
dHVyZWQgaW4geW91ciBwYXRjaHNldCBpc24ndCBhZGVxdWF0ZSB0byBwcm9wZXJseSBoYW5kbGUg
ZW5zdXJpbmcKPiA+ID4gPiB1cHBlciBsYXllciAobGlrZSBYRlMpIGNhbiBkZXBlbmQgb24gdGhl
IHNwYWNlIGJlaW5nIGF2YWlsYWJsZSBhY3Jvc3MKPiA+ID4gPiBzbmFwc2hvdCBib3VuZGFyaWVz
Ll0KPiA+ID4gPgo+ID4gPiBBY2suIFdvdWxkIGl0IGJlIHByZW1hdHVyZSBmb3IgdGhlIHJlc3Qg
b2YgdGhlIHNlcmllcyB0byBnbyB0aHJvdWdoCj4gPiA+IChSRVFfT1BfUFJPVklTSU9OICsgc3Vw
cG9ydCBmb3IgbG9vcCBhbmQgbm9uLWRtLXRoaW5wIGRldmljZS1tYXBwZXIKPiA+ID4gdGFyZ2V0
cyk/IEknZCBsaWtlIHRvIHN0YXJ0IHVzaW5nIHRoaXMgYXMgYSByZWZlcmVuY2UgdG8gc3VnZ2Vz
dAo+ID4gPiBhZGRpdGlvbnMgdG8gdGhlIHZpcnRpby1zcGVjIGZvciB2aXJ0aW8tYmxrIHN1cHBv
cnQgYW5kIHN0YXJ0IGxvb2tpbmcKPiA+ID4gYXQgd2hhdCBhbiBleHQ0IGltcGxlbWVudGF0aW9u
IHdvdWxkIGxvb2sgbGlrZS4KPiA+IAo+ID4gUGxlYXNlIGRyb3AgdGhlIGRtLXRoaW4uYyBhbmQg
ZG0tc25hcC5jIGNoYW5nZXMuICBkbS1zbmFwLmMgd291bGQgbmVlZAo+ID4gbW9yZSB3b3JrIHRv
IHByb3ZpZGUgdGhlIHR5cGUgb2YgZ3VhcmFudGVlIFhGUyByZXF1aXJlcyBhY3Jvc3MKPiA+IHNu
YXBzaG90IGJvdW5kYXJpZXMuIEknbSBpbmNsaW5lZCB0byBfbm90XyBhZGQgZG0tc25hcC5jIHN1
cHBvcnQKPiA+IGJlY2F1c2UgaXQgaXMgYmVzdCB0byBqdXN0IHVzZSBkbS10aGluLgo+ID4gCj4g
PiBBbmQgRllJIGV2ZW4geW91ciBkbS10aGluIHBhdGNoIHdpbGwgYmUgdGhlIHN0YXJ0aW5nIHBv
aW50IGZvciB0aGUKPiA+IGRtLXRoaW4gc3VwcG9ydCAod2UnbGwga2VlcCBhdHRyaWJ1dGlvbiB0
byB5b3UgZm9yIGFsbCB0aGUgY29kZSBpbiBhCj4gPiBzZXBhcmF0ZSBwYXRjaCkuCj4gPiAKPiA+
ID4gRmFpciBwb2ludHMsIEkgY2VydGFpbmx5IGRvbid0IHdhbnQgdG8gZGVyYWlsIHRoaXMgY29u
dmVyc2F0aW9uOyBJJ2QKPiA+ID4gYmUgaGFwcHkgdG8gc2VlIHRoaXMgd29yayBtZXJnZWQgc29v
bmVyIHJhdGhlciB0aGFuIGxhdGVyLgo+ID4gCj4gPiBPbmNlIHRob3NlIGRtIHRhcmdldCBjaGFu
Z2VzIGFyZSBkcm9wcGVkIEkgdGhpbmsgdGhlIHJlc3Qgb2YgdGhlCj4gPiBzZXJpZXMgaXMgZmlu
ZSB0byBnbyB1cHN0cmVhbSBub3cuICBGZWVsIGZyZWUgdG8gcG9zdCBhIHY4Lgo+IAo+IEZZSSwg
SSd2ZSBtYWRlIG15IGxhdGVzdCBjb2RlIGF2YWlsYWJsZSBpbiB0aGlzCj4gJ2RtLTYuNS1wcm92
aXNpb24tc3VwcG9ydCcgYnJhbmNoIChiYXNlZCBvbiAnZG0tNi41Jyk6Cj4gaHR0cHM6Ly9naXQu
a2VybmVsLm9yZy9wdWIvc2NtL2xpbnV4L2tlcm5lbC9naXQvZGV2aWNlLW1hcHBlci9saW51eC1k
bS5naXQvbG9nLz9oPWRtLTYuNS1wcm92aXNpb24tc3VwcG9ydAo+IAo+IEl0J3Mgd2hhdCB2OCBz
aG91bGQgYmUgcGx1cyB0aGUgMiBkbS10aGluIHBhdGNoZXMgKHRoYXQgSSBkb24ndCB0aGluawo+
IHNob3VsZCBnbyB1cHN0cmVhbSB5ZXQsIGJ1dCBhcmUgdGhlb3JldGljYWxseSB1c2VmdWwgZm9y
IERhdmUgYW5kCj4gSm9lKS4KPiAKPiBUaGUgImRtIHRoaW46IGNvbXBsZXRlIGludGVyZmFjZSBm
b3IgUkVRX09QX1BST1ZJU0lPTiBzdXBwb3J0IiBjb21taXQKPiBlc3RhYmxpc2hlcyBhbGwgdGhl
IGRtLXRoaW4gaW50ZXJmYWNlIEkgdGhpbmsgaXMgbmVlZGVkLiAgVGhlIEZJWE1FIGluCj4gcHJv
Y2Vzc19wcm92aXNpb25fYmlvKCkgKGFuZCB0aGUgcGF0Y2ggaGVhZGVyKSBjYXV0aW9ucyBhZ2Fp
bnN0IHVwcGVyCj4gbGF5ZXJzIGxpa2UgWEZTIHVzaW5nIHRoaXMgZG0tdGhpbnAgc3VwcG9ydCBx
dWl0ZSB5ZXQuCj4gCj4gT3RoZXJ3aXNlIHdlJ2xsIGhhdmUgdGhlIGlzc3VlIHdoZXJlIGRtLXRo
aW5wJ3MgUkVRX09QX1BST1ZJU0lPTgo+IHN1cHBvcnQgaW5pdGlhbGx5IGRvZXNuJ3QgcHJvdmlk
ZSB0aGUgZ3VhcmFudGVlIHRoYXQgWEZTIG5lZWRzIGFjcm9zcwo+IHNuYXBzaG90cyAod2hpY2gg
aXM6IHNuYXBzaG90cyBpbmhlcml0IGFsbCBwcmV2aW91cyBSRVFfT1BfUFJPVklTSU9OKS4KCkp1
c3QgdGFnIGl0IHdpdGggRVhQRVJJTUVOVEFMIG9uIHJlY3BldGlvbiBvZiB0aGUgZmlyc3QKUkVR
X09QX1BST1ZJU0lPTiBmb3IgdGhlIGRldmljZSAoaS5lLiBkdW1wIGEgbG9nIHdhcm5pbmcpLCBs
aWtlIEknbGwKZW5kIHVwIGRvaW5nIHdpdGggWEZTIHdoZW4gaXQgZGV0ZWN0cyBwcm92aXNpb25p
bmcgc3VwcG9ydCBhdCBtb3VudAp0aW1lLgoKV2UgZG8gdGhpcyBhbGwgdGhlIHRpbWUgdG8gYWxs
b3cgbWVyZ2luZyBuZXcgZmVhdHVyZXMgYmVmb3JlIHRoZXkKYXJlIGZ1bGx5IHByb2R1Y3Rpb24g
cmVhZHkgLSBFWFBFUklNRU5UQUwgbWVhbnMgeW91IGNhbiBleHBlY3QgaXQgdG8KbW9zdGx5IHdv
cmssIGV4Y2VwdCB3aGVuIGl0IGRvZXNuJ3QsIGFuZCB5b3Uga25vdyB0aGF0IHdoZW4gaXQKYnJl
YWtzIHlvdSBnZXQgdG8gcmVwb3J0IHRoZSBidWcsIGhlbHAgdHJpYWdlIGl0IGFuZCBhcyBhIGJv
bnVzIHlvdQpnZXQgdG8ga2VlcCB0aGUgYnJva2VuIGJpdHMhCgokIGdpdCBncmVwIEVYUEVSSU1F
TlRBTCBmcy94ZnMKZnMveGZzL0tjb25maWc6ICAgVGhpcyBmZWF0dXJlIGlzIGNvbnNpZGVyZWQg
RVhQRVJJTUVOVEFMLiAgVXNlIHdpdGggY2F1dGlvbiEKZnMveGZzL0tjb25maWc6ICAgVGhpcyBm
ZWF0dXJlIGlzIGNvbnNpZGVyZWQgRVhQRVJJTUVOVEFMLiAgVXNlIHdpdGggY2F1dGlvbiEKZnMv
eGZzL3NjcnViL3NjcnViLmM6ICJFWFBFUklNRU5UQUwgb25saW5lIHNjcnViIGZlYXR1cmUgaW4g
dXNlLiBVc2UgYXQgeW91ciBvd24gcmlzayEiKTsKZnMveGZzL3hmc19mc29wcy5jOiAgICAgIkVY
UEVSSU1FTlRBTCBvbmxpbmUgc2hyaW5rIGZlYXR1cmUgaW4gdXNlLiBVc2UgYXQgeW91ciBvd24g
cmlzayEiKTsKZnMveGZzL3hmc19zdXBlci5jOiAgICAgeGZzX3dhcm4obXAsICJEQVggZW5hYmxl
ZC4gV2FybmluZzogRVhQRVJJTUVOVEFMLCB1c2UgYXQgeW91ciBvd24gcmlzayIpOwpmcy94ZnMv
eGZzX3N1cGVyLmM6ICAgICAiRVhQRVJJTUVOVEFMIExhcmdlIGV4dGVudCBjb3VudHMgZmVhdHVy
ZSBpbiB1c2UuIFVzZSBhdCB5b3VyIG93biByaXNrISIpOwpmcy94ZnMveGZzX3hhdHRyLmM6ICJF
WFBFUklNRU5UQUwgbG9nZ2VkIGV4dGVuZGVkIGF0dHJpYnV0ZXMgZmVhdHVyZSBpbiB1c2UuIFVz
ZSBhdCB5b3VyIG93biByaXNrISIpOwokCgpJT1dzLCBJJ2xsIGJlIGFkZGluZyBhOgoKIkVYUEVS
SU1FTlRBTCBibG9jayBkZXZpY2UgcHJvdmlzaW9uaW5nIGluIHVzZS4gVXNlIGF0IHlvdXIgb3du
IHJpc2shIgoKd2FybmluZyB0byBYRlMsIGFuZCBpdCB3b24ndCBnZXQgcmVtb3ZlZCB1bnRpbCBi
b3RoIHRoZSBYRlMgYW5kCmRtLXRoaW5wIHN1cHBvcnQgaXMgc29saWQgYW5kIHByb2R1Y3Rpb24g
cmVhZHkuLi4uCgpDaGVlcnMsCgpEYXZlLgotLSAKRGF2ZSBDaGlubmVyCmRhdmlkQGZyb21vcmJp
dC5jb20KCi0tCmRtLWRldmVsIG1haWxpbmcgbGlzdApkbS1kZXZlbEByZWRoYXQuY29tCmh0dHBz
Oi8vbGlzdG1hbi5yZWRoYXQuY29tL21haWxtYW4vbGlzdGluZm8vZG0tZGV2ZWwK

