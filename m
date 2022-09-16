Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 33002C6FA90
	for <dm-devel@archiver.kernel.org>; Mon, 19 Sep 2022 05:31:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1663565470;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=LasHNJ3WkY+piFx1QcffzVJWd20xdkJiiWwU12/ADaQ=;
	b=Ykga6+tuNiE7HXdW6XbR/0PXUX+MtvRDUOXipnT95x7UDFOGSzfZ7EG3YjjaF5J5kqEH2S
	73fo3OE0FCR2qrLQY/YaXf/sgSmDsm5LapYQ/oxcV1dS/Rz8jtmgpA4I92Fa8b6nH6xHb3
	Q64hvMM33nAO7gctXDQxsQrupQmE728=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-392-gtL9WyNRNIKKKz_cue9YNQ-1; Mon, 19 Sep 2022 01:31:06 -0400
X-MC-Unique: gtL9WyNRNIKKKz_cue9YNQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 56F0D29AB44A;
	Mon, 19 Sep 2022 05:31:04 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id DAF8AC15BA4;
	Mon, 19 Sep 2022 05:30:59 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 9E7C91946594;
	Mon, 19 Sep 2022 05:30:59 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 24D9F1946586
 for <dm-devel@listman.corp.redhat.com>; Fri, 16 Sep 2022 18:48:49 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 12A6B40C2065; Fri, 16 Sep 2022 18:48:49 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 091F440C2064
 for <dm-devel@redhat.com>; Fri, 16 Sep 2022 18:48:49 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E2302101A5BB
 for <dm-devel@redhat.com>; Fri, 16 Sep 2022 18:48:48 +0000 (UTC)
Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com
 [209.85.218.49]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-516-rH4RcqmxNSqTzw1turk9fQ-1; Fri, 16 Sep 2022 14:48:47 -0400
X-MC-Unique: rH4RcqmxNSqTzw1turk9fQ-1
Received: by mail-ej1-f49.google.com with SMTP id r18so51462841eja.11
 for <dm-devel@redhat.com>; Fri, 16 Sep 2022 11:48:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=content-transfer-encoding:cc:to:subject:message-id:date:from
 :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
 :subject:date;
 bh=SdKZkQSOOeZ73NFTfXwaDLPs0+FX9IJxa8fOyAWvQWo=;
 b=hduStBn5M9hg0i9Lw84RpldWF8bBCmDNGEgCjJI93v3INGyoQvkORmrk7LAuanwHYS
 s63xtrbql3+4xvwvDkbLwLRuB8yVLL6S2SwHmBqnQ+r6YNwNNsWBPUDC+CNqUNKwmof/
 5+16YtQUkFFap8raauIqbbYnf4AZwO3OdaZO7eEaiGLRcIlp5ZM6URw901AUXMN2n9HQ
 m7I/ly4FW0BIYravRRHif5/oGkYhybVttszVlrUzREg5CFieJ1eRyM1Putt2/YFBzDGM
 pHfXs/E1mpglKRpHaiHk8HuaMDQl1FAqZJhJk4rIrFZK987/HRTj1qLZ4yaCEW67HK1P
 46bQ==
X-Gm-Message-State: ACrzQf2pQ+SiUZwzMkKgcO3sOVXsRwlXBl55eOBP4kgYPh2hVbSZ2F9c
 o6ieoaPcrR9jKni8ZcD/csKm5GwdIpr6cyOYs9chIE/klM8=
X-Google-Smtp-Source: AMsMyM4H50Nh3fB15dbYJDOgQVr7DWdwSoN47hKf8GNOPyV4RnAetL9SU78eAuiLXsBmxUNOb3xdb298jwC8+0N02/8=
X-Received: by 2002:a17:907:628a:b0:72f:678d:6047 with SMTP id
 nd10-20020a170907628a00b0072f678d6047mr4442324ejc.456.1663354126400; Fri, 16
 Sep 2022 11:48:46 -0700 (PDT)
MIME-Version: 1.0
References: <20220915164826.1396245-1-sarthakkukreti@google.com>
 <YyQTM5PRT2o/GDwy@fedora>
In-Reply-To: <YyQTM5PRT2o/GDwy@fedora>
From: Sarthak Kukreti <sarthakkukreti@chromium.org>
Date: Fri, 16 Sep 2022 11:48:34 -0700
Message-ID: <CAG9=OMPHZqdDhX=M+ovdg5fa3x4-Q_1r5SWPa8pMTQw0mr5fPg@mail.gmail.com>
To: Stefan Hajnoczi <stefanha@redhat.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Mailman-Approved-At: Mon, 19 Sep 2022 05:30:58 +0000
Subject: Re: [dm-devel] [PATCH RFC 0/8] Introduce provisioning primitives
 for thinly provisioned storage
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
Cc: Jens Axboe <axboe@kernel.dk>, Gwendal Grignou <gwendal@google.com>,
 Theodore Ts'o <tytso@mit.edu>, "Michael S . Tsirkin" <mst@redhat.com>,
 Jason Wang <jasowang@redhat.com>, Bart Van Assche <bvanassche@google.com>,
 Mike Snitzer <snitzer@kernel.org>, linux-kernel@vger.kernel.org,
 virtualization@lists.linux-foundation.org, linux-block@vger.kernel.org,
 dm-devel@redhat.com, Andreas Dilger <adilger.kernel@dilger.ca>,
 Daniil Lunev <dlunev@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
 linux-ext4@vger.kernel.org, Evan Green <evgreen@google.com>,
 Alasdair Kergon <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

T24gVGh1LCBTZXAgMTUsIDIwMjIgYXQgMTE6MTAgUE0gU3RlZmFuIEhham5vY3ppIDxzdGVmYW5o
YUByZWRoYXQuY29tPiB3cm90ZToKPgo+IE9uIFRodSwgU2VwIDE1LCAyMDIyIGF0IDA5OjQ4OjE4
QU0gLTA3MDAsIFNhcnRoYWsgS3VrcmV0aSB3cm90ZToKPiA+IEZyb206IFNhcnRoYWsgS3VrcmV0
aSA8c2FydGhha2t1a3JldGlAY2hyb21pdW0ub3JnPgo+ID4KPiA+IEhpLAo+ID4KPiA+IFRoaXMg
cGF0Y2ggc2VyaWVzIGlzIGFuIFJGQyBvZiBhIG1lY2hhbmlzbSB0byBwYXNzIHRocm91Z2ggcHJv
dmlzaW9uIHJlcXVlc3RzIG9uIHN0YWNrZWQgdGhpbmx5IHByb3Zpc2lvbmVkIHN0b3JhZ2UgZGV2
aWNlcy9maWxlc3lzdGVtcy4KPiA+Cj4gPiBUaGUgbGludXgga2VybmVsIHByb3ZpZGVzIHNldmVy
YWwgbWVjaGFuaXNtcyB0byBzZXQgdXAgdGhpbmx5IHByb3Zpc2lvbmVkIGJsb2NrIHN0b3JhZ2Ug
YWJzdHJhY3Rpb25zIChlZy4gZG0tdGhpbiwgbG9vcCBkZXZpY2VzIG92ZXIgc3BhcnNlIGZpbGVz
KSwgZWl0aGVyIGRpcmVjdGx5IGFzIGJsb2NrIGRldmljZXMgb3IgYmFja2luZyBzdG9yYWdlIGZv
ciBmaWxlc3lzdGVtcy4gQ3VycmVudGx5LCBzaG9ydCBvZiB3cml0aW5nIGRhdGEgdG8gZWl0aGVy
IHRoZSBkZXZpY2Ugb3IgZmlsZXN5c3RlbSwgdGhlcmUgaXMgbm8gd2F5IGZvciB1c2VycyB0byBw
cmUtYWxsb2NhdGUgc3BhY2UgZm9yIHVzZSBpbiBzdWNoIHN0b3JhZ2Ugc2V0dXBzLiBDb25zaWRl
ciB0aGUgZm9sbG93aW5nIHVzZS1jYXNlczoKPiA+Cj4gPiAxKSBTdXNwZW5kLXRvLWRpc2sgYW5k
IHJlc3VtZSBmcm9tIGEgZG0tdGhpbiBkZXZpY2U6IEluIG9yZGVyIHRvIGVuc3VyZSB0aGF0IHRo
ZSB1bmRlcmx5aW5nIHRoaW5wb29sIG1ldGFkYXRhIGlzIG5vdCBtb2RpZmllZCBkdXJpbmcgdGhl
IHN1c3BlbmQgbWVjaGFuaXNtLCB0aGUgZG0tdGhpbiBkZXZpY2UgbmVlZHMgdG8gYmUgZnVsbHkg
cHJvdmlzaW9uZWQuCj4gPiAyKSBJZiBhIGZpbGVzeXN0ZW0gdXNlcyBhIGxvb3AgZGV2aWNlIG92
ZXIgYSBzcGFyc2UgZmlsZSwgZmFsbG9jYXRlKCkgb24gdGhlIGZpbGVzeXN0ZW0gd2lsbCBhbGxv
Y2F0ZSBibG9ja3MgZm9yIGZpbGVzIGJ1dCB0aGUgdW5kZXJseWluZyBzcGFyc2UgZmlsZSB3aWxs
IHJlbWFpbiBpbnRhY3QuCj4gPiAzKSBBbm90aGVyIGV4YW1wbGUgaXMgdmlydHVhbCBtYWNoaW5l
IHVzaW5nIGEgc3BhcnNlIGZpbGUvZG0tdGhpbiBhcyBhIHN0b3JhZ2UgZGV2aWNlOyBieSBkZWZh
dWx0LCBhbGxvY2F0aW9ucyB3aXRoaW4gdGhlIFZNIGJvdW5kYXJpZXMgd2lsbCBub3QgYWZmZWN0
IHRoZSBob3N0Lgo+ID4gNCkgU2V2ZXJhbCBzdG9yYWdlIHN0YW5kYXJkcyBzdXBwb3J0IG1lY2hh
bmlzbXMgZm9yIHRoaW4gcHJvdmlzaW9uaW5nIG9uIHJlYWwgaGFyZHdhcmUgZGV2aWNlcy4gRm9y
IGV4YW1wbGU6Cj4gPiAgIGEuIFRoZSBOVk1lIHNwZWMgMS4wYiBzZWN0aW9uIDIuMS4xIGxvb3Nl
bHkgdGFsa3MgYWJvdXQgdGhpbiBwcm92aXNpb25pbmc6ICJXaGVuIHRoZSBUSElOUCBiaXQgaW4g
dGhlIE5TRkVBVCBmaWVsZCBvZiB0aGUgSWRlbnRpZnkgTmFtZXNwYWNlIGRhdGEgc3RydWN0dXJl
IGlzIHNldCB0byDigJgx4oCZLCB0aGUgY29udHJvbGxlciAuLi4gc2hhbGwgdHJhY2sgdGhlIG51
bWJlciBvZiBhbGxvY2F0ZWQgYmxvY2tzIGluIHRoZSBOYW1lc3BhY2UgVXRpbGl6YXRpb24gZmll
bGQiCj4gPiAgIGIuIFRoZSBTQ1NpIEJsb2NrIENvbW1hbmRzIHJlZmVyZW5jZSAtIDQgc2VjdGlv
biByZWZlcmVuY2VzICJUaGluIHByb3Zpc2lvbmVkIGxvZ2ljYWwgdW5pdHMiLAo+ID4gICBjLiBV
RlMgMy4wIHNwZWMgc2VjdGlvbiAxMy4zLjMgcmVmZXJlbmNlcyAiVGhpbiBwcm92aXNpb25pbmci
Lgo+Cj4gV2hlbiBSRVFfT1BfUFJPVklTSU9OIGlzIHNlbnQgb24gYW4gYWxyZWFkeS1hbGxvY2F0
ZWQgcmFuZ2Ugb2YgYmxvY2tzLAo+IGFyZSB0aG9zZSBibG9ja3MgemVyb2VkPyBOVk1lIFdyaXRl
IFplcm9lcyB3aXRoIERlYWxsb2NhdGU9MCB3b3JrcyB0aGlzCj4gd2F5LCBmb3IgZXhhbXBsZS4g
VGhhdCBiZWhhdmlvciBpcyBjb3VudGVyaW50dWl0aXZlIHNpbmNlIHRoZSBvcGVyYXRpb24KPiBu
YW1lIHN1Z2dlc3RzIGl0IGp1c3QgYWZmZWN0cyB0aGUgbG9naWNhbCBibG9jaydzIHByb3Zpc2lv
bmluZyBzdGF0ZSwKPiBub3QgdGhlIGNvbnRlbnRzIG9mIHRoZSBibG9ja3MuCj4KTm8sIHRoZSBi
bG9ja3MgYXJlIG5vdCB6ZXJvZWQuIFRoZSBjdXJyZW50IGltcGxlbWVudGF0aW9uIChpbiB0aGUg
ZG0KcGF0Y2gpIGlzIHRvIGluZGVlZCBsb29rIGF0IHRoZSBwcm92aXNpb25lZCBzdGF0ZSBvZiB0
aGUgbG9naWNhbCBibG9jawphbmQgcHJvdmlzaW9uIGlmIGl0IGlzIHVubWFwcGVkLiBpZiB0aGUg
YmxvY2sgaXMgYWxyZWFkeSBhbGxvY2F0ZWQsClJFUV9PUF9QUk9WSVNJT04gc2hvdWxkIGhhdmUg
bm8gZWZmZWN0IG9uIHRoZSBjb250ZW50cyBvZiB0aGUgYmxvY2suClNpbWlsYXJseSwgaW4gdGhl
IGZpbGUgc2VtYW50aWNzLCBzZW5kaW5nIGFuIEZBTExPQ19GTF9QUk9WSVNJT04KcmVxdWVzdHMg
Zm9yIGV4dGVudHMgYWxyZWFkeSBtYXBwZWQgc2hvdWxkIG5vdCBhZmZlY3QgdGhlIGNvbnRlbnRz
IGluCnRoZSBleHRlbnRzLgoKPiA+IEluIGFsbCBvZiB0aGUgYWJvdmUgc2l0dWF0aW9ucywgY3Vy
cmVudGx5IHRoZSBvbmx5IHdheSBmb3IgcHJlLWFsbG9jYXRpbmcgc3BhY2UgaXMgdG8gaXNzdWUg
d3JpdGVzIChvciB1c2UgV1JJVEVfWkVST0VTL1dSSVRFX1NBTUUpLiBIb3dldmVyLCB0aGF0IGRv
ZXMgbm90IHNjYWxlIHdlbGwgd2l0aCBsYXJnZXIgcHJlLWFsbG9jYXRpb24gc2l6ZXMuCj4KPiBX
aGF0IGV4YWN0bHkgaXMgdGhlIGlzc3VlIHdpdGggV1JJVEVfWkVST0VTIHNjYWxhYmlsaXR5PyBB
cmUgeW91Cj4gcmVmZXJyaW5nIHRvIGNhc2VzIHdoZXJlIHRoZSBkZXZpY2UgZG9lc24ndCBzdXBw
b3J0IGFuIGVmZmljaWVudAo+IFdSSVRFX1pFUk9FUyBjb21tYW5kIGFuZCBhY3R1YWxseSB3cml0
ZXMgYmxvY2tzIGZpbGxlZCB3aXRoIHplcm9lcwo+IGluc3RlYWQgb2YgdXBkYXRpbmcgaW50ZXJu
YWwgYWxsb2NhdGlvbiBtZXRhZGF0YSBjaGVhcGx5Pwo+Clllcy4gT24gQ2hyb21pdW1PUywgd2Ug
cmVndWxhcmx5IGRlYWwgd2l0aCBzdG9yYWdlIGRldmljZXMgdGhhdCBkb24ndApzdXBwb3J0IFdS
SVRFX1pFUk9FUyBvciB0aGF0IG5lZWQgdG8gaGF2ZSBpdCBkaXNhYmxlZCwgdmlhIGEgcXVpcmss
CmR1ZSB0byBhIGJ1ZyBpbiB0aGUgdmVuZG9yJ3MgaW1wbGVtZW50YXRpb24uIFVzaW5nIFdSSVRF
X1pFUk9FUyBmb3IKYWxsb2NhdGlvbiBtYWtlcyB0aGUgYWxsb2NhdGlvbiBwYXRoIHF1aXRlIHNs
b3cgZm9yIHN1Y2ggZGV2aWNlcyAobm90CnRvIG1lbnRpb24gdGhlIGVmZmVjdCBvbiBzdG9yYWdl
IGxpZmV0aW1lKSwgc28gaGF2aW5nIGEgc2VwYXJhdGUKcHJvdmlzaW9uaW5nIGNvbnN0cnVjdCBp
cyB2ZXJ5IGFwcGVhbGluZy4gRXZlbiBmb3IgZGV2aWNlcyB0aGF0IGRvCnN1cHBvcnQgYW4gZWZm
aWNpZW50IFdSSVRFX1pFUk9FUyBpbXBsZW1lbnRhdGlvbiBidXQgZG9uJ3Qgc3VwcG9ydApsb2dp
Y2FsIHByb3Zpc2lvbmluZyBwZXItc2UsIEkgc3VwcG9zZSB0aGF0IHRoZSBhbGxvY2F0aW9uIHBh
dGggbWlnaHQKYmUgYSBiaXQgZmFzdGVyICh0aGUgZGV2aWNlIGRyaXZlcidzIHJlcXVlc3QgcXVl
dWUgd291bGQgcmVwb3J0CidtYXhfcHJvdmlzaW9uX3NlY3RvcnMnPTAgYW5kIHRoZSByZXF1ZXN0
IHdvdWxkIGJlIHNob3J0IGNpcmN1aXRlZAp0aGVyZSkgYWx0aG91Z2ggSSBoYXZlbid0IGJlbmNo
bWFya2VkIHRoZSBkaWZmZXJlbmNlLgoKU2FydGhhawoKPiBTdGVmYW4KCi0tCmRtLWRldmVsIG1h
aWxpbmcgbGlzdApkbS1kZXZlbEByZWRoYXQuY29tCmh0dHBzOi8vbGlzdG1hbi5yZWRoYXQuY29t
L21haWxtYW4vbGlzdGluZm8vZG0tZGV2ZWwK

