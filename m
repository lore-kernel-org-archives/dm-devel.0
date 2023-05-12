Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 04414C7EE23
	for <dm-devel@archiver.kernel.org>; Fri, 12 May 2023 14:34:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1683902084;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=/quVNzlDRVI7bztx83eGW0nwodJ/0MupVRp/RbDR9UE=;
	b=QT8J7jZuKgXrvoKigwAmHHlJNcWfJDEdjgx7YUzH6kzHza0QbkVeLLlXcYocZ6A2gsftlR
	btaY0j+eqEZ1Du0Xhp9WbH9/YO6qw0750Z3ix6g5CF0ZUkM4UcWN8fktc0jY5d5PBMCcoT
	Wc1Iuz/p+nuje8kT1rqsWeIXgWVj6CI=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-41-riY3cazvM02YWIt71opl1Q-1; Fri, 12 May 2023 10:34:40 -0400
X-MC-Unique: riY3cazvM02YWIt71opl1Q-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B25031C060EE;
	Fri, 12 May 2023 14:34:38 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id C9EE835443;
	Fri, 12 May 2023 14:34:36 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 9522119451E4;
	Fri, 12 May 2023 14:34:36 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 1987219451E3
 for <dm-devel@listman.corp.redhat.com>; Fri, 12 May 2023 14:34:36 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id F06002026D25; Fri, 12 May 2023 14:34:35 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id E8E322026D16
 for <dm-devel@redhat.com>; Fri, 12 May 2023 14:34:35 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CDD3B85C064
 for <dm-devel@redhat.com>; Fri, 12 May 2023 14:34:35 +0000 (UTC)
Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com
 [209.85.160.181]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-361-CkB_rBmrO1uNujsJKuvFig-1; Fri, 12 May 2023 10:34:34 -0400
X-MC-Unique: CkB_rBmrO1uNujsJKuvFig-1
Received: by mail-qt1-f181.google.com with SMTP id
 d75a77b69052e-3f38b7ca98aso57244621cf.1
 for <dm-devel@redhat.com>; Fri, 12 May 2023 07:34:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1683902073; x=1686494073;
 h=in-reply-to:content-transfer-encoding:content-disposition
 :mime-version:references:message-id:subject:cc:to:from:date
 :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=3NI8PblGX09aXcegfRrsRbp5Rk8EB7aSb1Q3zVJjhig=;
 b=coETRGtmtqXUCAek2TH+5xIUe+xOmrHjQd/9x26CiQN8dEZ6R1SLMQavW+bdPOKLJv
 ShMDex1Ln1BpcyvU/nfAOki/HnhTjbhXI+elarhQObaQT19Ztq+oSxTWJclo1jeBdn02
 CK2ooNW5Soetw7Y/xKvVuL3s9IAkZD68FfGjBSNU9l0wKom0jW81jgAZVxxEpbJgMnEo
 nGA6rKy+refFpTl/FWT6z2DhDByQO9kgO8BW9xbCOANdajDGOfvEYZBPFuOUjhrWRlxQ
 DdZt1CEA1VNViN6CB9yWlqNqcIKCQ2OEnXPpt0fU7gcIDJxT8LKZlJPpjI+p3k1RCGVO
 /sVg==
X-Gm-Message-State: AC+VfDxyYwdSQnzpX4dO2hSh52Jtn8k3JLwUhj+proHGpTKf905bzMGp
 Mpigc+VhkxTGHQgsvLVqMj4ShaKxXBksPgnfFgSJ
X-Google-Smtp-Source: ACHHUZ4M++aZz9x/idwKRxoZtFqzxE+KBfxysydbhwDNajJOH3TAbWPaBDcqWbbuEGec9dZSQIGwHA==
X-Received: by 2002:ac8:5787:0:b0:3f3:91bd:a46d with SMTP id
 v7-20020ac85787000000b003f391bda46dmr24764787qta.8.1683902073426; 
 Fri, 12 May 2023 07:34:33 -0700 (PDT)
Received: from localhost (pool-68-160-166-30.bstnma.fios.verizon.net.
 [68.160.166.30]) by smtp.gmail.com with ESMTPSA id
 f8-20020ae9ea08000000b0074d3233487dsm5387535qkg.114.2023.05.12.07.34.32
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 12 May 2023 07:34:32 -0700 (PDT)
Date: Fri, 12 May 2023 10:34:31 -0400
From: Mike Snitzer <snitzer@kernel.org>
To: Sarthak Kukreti <sarthakkukreti@chromium.org>,
 Jens Axboe <axboe@kernel.dk>, Brian Foster <bfoster@redhat.com>,
 "Darrick J. Wong" <djwong@kernel.org>
Message-ID: <ZF5Od6GY4rsq82qM@redhat.com>
References: <20230420004850.297045-1-sarthakkukreti@chromium.org>
 <20230506062909.74601-1-sarthakkukreti@chromium.org>
 <20230506062909.74601-5-sarthakkukreti@chromium.org>
 <ZFp7ykxGFUbPG1ON@redhat.com>
 <CAG9=OMOMrFcy6UdL8-3wZGwOr1nqLm1bpvL+G1g2dvBhJWU2Kw@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAG9=OMOMrFcy6UdL8-3wZGwOr1nqLm1bpvL+G1g2dvBhJWU2Kw@mail.gmail.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
Subject: Re: [dm-devel] [PATCH v6 4/5] dm-thin: Add REQ_OP_PROVISION support
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
Cc: linux-block@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>,
 "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>,
 Bart Van Assche <bvanassche@google.com>, linux-kernel@vger.kernel.org,
 Christoph Hellwig <hch@infradead.org>, dm-devel@redhat.com,
 Andreas Dilger <adilger.kernel@dilger.ca>,
 Stefan Hajnoczi <stefanha@redhat.com>, linux-fsdevel@vger.kernel.org,
 linux-ext4@vger.kernel.org, Alasdair Kergon <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

T24gVGh1LCBNYXkgMTEgMjAyMyBhdCAgNDowM1AgLTA0MDAsClNhcnRoYWsgS3VrcmV0aSA8c2Fy
dGhha2t1a3JldGlAY2hyb21pdW0ub3JnPiB3cm90ZToKCj4gT24gVHVlLCBNYXkgOSwgMjAyMyBh
dCA5OjU44oCvQU0gTWlrZSBTbml0emVyIDxzbml0emVyQGtlcm5lbC5vcmc+IHdyb3RlOgo+ID4K
PiA+IE9uIFNhdCwgTWF5IDA2IDIwMjMgYXQgIDI6MjlQIC0wNDAwLAo+ID4gU2FydGhhayBLdWty
ZXRpIDxzYXJ0aGFra3VrcmV0aUBjaHJvbWl1bS5vcmc+IHdyb3RlOgo+ID4KPiA+ID4gZG0tdGhp
bnBvb2wgdXNlcyB0aGUgcHJvdmlzaW9uIHJlcXVlc3QgdG8gcHJvdmlzaW9uCj4gPiA+IGJsb2Nr
cyBmb3IgYSBkbS10aGluIGRldmljZS4gZG0tdGhpbnBvb2wgY3VycmVudGx5IGRvZXMgbm90Cj4g
PiA+IHBhc3MgdGhyb3VnaCBSRVFfT1BfUFJPVklTSU9OIHRvIHVuZGVybHlpbmcgZGV2aWNlcy4K
PiA+ID4KPiA+ID4gRm9yIHNoYXJlZCBibG9ja3MsIHByb3Zpc2lvbiByZXF1ZXN0cyB3aWxsIGJy
ZWFrIHNoYXJpbmcgYW5kIGNvcHkgdGhlCj4gPiA+IGNvbnRlbnRzIG9mIHRoZSBlbnRpcmUgYmxv
Y2suIEFkZGl0aW9uYWxseSwgaWYgJ3NraXBfYmxvY2tfemVyb2luZycKPiA+ID4gaXMgbm90IHNl
dCwgZG0tdGhpbiB3aWxsIG9wdCB0byB6ZXJvIG91dCB0aGUgZW50aXJlIHJhbmdlIGFzIGEgcGFy
dAo+ID4gPiBvZiBwcm92aXNpb25pbmcuCj4gPiA+Cj4gPiA+IFNpZ25lZC1vZmYtYnk6IFNhcnRo
YWsgS3VrcmV0aSA8c2FydGhha2t1a3JldGlAY2hyb21pdW0ub3JnPgo+ID4gPiAtLS0KPiA+ID4g
IGRyaXZlcnMvbWQvZG0tdGhpbi5jIHwgNzAgKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKystLS0KPiA+ID4gIDEgZmlsZSBjaGFuZ2VkLCA2NiBpbnNlcnRpb25zKCspLCA0
IGRlbGV0aW9ucygtKQo+ID4gPgo+ID4gPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9tZC9kbS10aGlu
LmMgYi9kcml2ZXJzL21kL2RtLXRoaW4uYwo+ID4gPiBpbmRleCAyYjEzYzk0OWJkNzIuLjNmOTRm
NTNhYzk1NiAxMDA2NDQKPiA+ID4gLS0tIGEvZHJpdmVycy9tZC9kbS10aGluLmMKPiA+ID4gKysr
IGIvZHJpdmVycy9tZC9kbS10aGluLmMKPiA+ID4gQEAgLTQyODgsNiArNDM0Nyw5IEBAIHN0YXRp
YyBpbnQgdGhpbl9jdHIoc3RydWN0IGRtX3RhcmdldCAqdGksIHVuc2lnbmVkIGludCBhcmdjLCBj
aGFyICoqYXJndikKPiA+ID4gICAgICAgICAgICAgICB0aS0+bWF4X2Rpc2NhcmRfZ3JhbnVsYXJp
dHkgPSB0cnVlOwo+ID4gPiAgICAgICB9Cj4gPiA+Cj4gPiA+ICsgICAgIHRpLT5udW1fcHJvdmlz
aW9uX2Jpb3MgPSAxOwo+ID4gPiArICAgICB0aS0+cHJvdmlzaW9uX3N1cHBvcnRlZCA9IHRydWU7
Cj4gPiA+ICsKPiA+Cj4gPiBXZSBuZWVkIHRoaXMgaW4gdGhpbl9jdHI6IHRpLT5tYXhfcHJvdmlz
aW9uX2dyYW51bGFyaXR5ID0gdHJ1ZTsKPiA+Cj4gPiBNb3JlIG5lZWRlZCBpbiB0aGUgdGhpbiB0
YXJnZXQgdGhhbiB0aGluLXBvb2w7IG90aGVyd2lzZSBwcm92aXNpb24gYmlvCj4gPiBpc3N1ZWQg
dG8gdGhpbiBkZXZpY2VzIHdvbid0IGJlIHNwbGl0IGFwcHJvcHJpYXRlbHkuICBCdXQgSSBkbyB0
aGluawo+ID4gaXRzIGZpbmUgdG8gc2V0IGluIGJvdGggdGhpbl9jdHIgYW5kIHBvb2xfY3RyLgo+
ID4KPiA+IE90aGVyd2lzZSwgbG9va3MgZ29vZC4KPiA+Cj4gVGhhbmtzISBJJ2xsIGFkZCBpdCB0
byB0aGUgbmV4dCBpdGVyYXRpb24gKGluIGFkZGl0aW9uIHRvIGFueSBvdGhlcgo+IGZlZWRiYWNr
IHRoYXQncyBhZGRlZCB0byB2NikuCgpPSy4gSSdsbCBiZWdpbiBiYXNpbmcgZG0tdGhpbnAncyBX
UklURV9aRVJPRVMgc3VwcG9ydCBvbnRvcCBvZiB0aGlzCnNlcmllcy4KIAo+IEdpdmVuIHRoYXQg
dGhpcyBzZXJpZXMgY292ZXJzIG11bHRpcGxlIHN1YnN5c3RlbXMsIHdvdWxkIHRoZXJlIGJlIGEK
PiBwcmVmZXJyZWQgd2F5IG9mIHF1ZXVlaW5nIHRoaXMgZm9yIG1lcmdlPwoKSSB0aGluayBpdCdk
IGJlIE9LIGZvciBKZW5zIHRvIHBpY2sgdGhpcyBzZXJpZXMgdXAgYW5kIEknbGwgcmViYXNlCm15
IGNvcnJlc3BvbmRpbmcgRE0gdHJlZSBvbmNlIGhlIGRvZXMuCgpJbiBhZGRpdGlvbiB0byBKZW5z
OyBCcmlhbiwgRGFycmljayBhbmQvb3Igb3RoZXJzOiBhbnkgY2hhbmNlIHlvdQpjb3VsZCByZXZp
ZXcgdGhlIGJsb2NrIGNvcmUgY2hhbmdlcyBpbiB0aGlzIHNlcmllcyB0byBlbnN1cmUgeW91J3Jl
CmNvb2wgd2l0aCB0aGVtPwoKV291bGQgYmUgbmljZSB0byBnZXQgU2FydGhhayByZXZpZXcgZmVl
ZGJhY2sgc28gdGhhdCBob3BlZnVsbHkgaGlzIHY3CmNhbiBiZSB0aGUgZmluYWwgcmV2aXNpb24u
CgpUaGFua3MsCk1pa2UKCi0tCmRtLWRldmVsIG1haWxpbmcgbGlzdApkbS1kZXZlbEByZWRoYXQu
Y29tCmh0dHBzOi8vbGlzdG1hbi5yZWRoYXQuY29tL21haWxtYW4vbGlzdGluZm8vZG0tZGV2ZWwK

