Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 567B1CD98CB
	for <dm-devel@archiver.kernel.org>; Tue, 10 Oct 2023 22:43:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1696977811;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=nceeqDgsUKw2FNhYk/KOn7w69KCNa2hLnibwK8gEsEk=;
	b=LeaF11Ch+M03u1s5Xs3K8dYJSCXRNCgH5V7MUkr0hRxpVtn5A7N/d5uO2CcrdhhcwEGs+j
	axc+QFFMQTwlL4syAJZn3d84svGQBDoth0DJwDW/xCLyBOS4JTXANdeZNE+fsAbsjHgFuV
	uoiAn8Rhq9Ib7RfIYruJeddqCwDWUak=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-650-YWwZmwVhPn-HTlUDiVbZiw-1; Tue, 10 Oct 2023 18:43:28 -0400
X-MC-Unique: YWwZmwVhPn-HTlUDiVbZiw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id F0AC985A5BF;
	Tue, 10 Oct 2023 22:43:25 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id DC576200A7CB;
	Tue, 10 Oct 2023 22:43:25 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 96CD519465B8;
	Tue, 10 Oct 2023 22:43:25 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 2E3191946597
 for <dm-devel@listman.corp.redhat.com>; Tue, 10 Oct 2023 22:43:25 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 1DC0CC0F789; Tue, 10 Oct 2023 22:43:25 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 16100C0F788
 for <dm-devel@redhat.com>; Tue, 10 Oct 2023 22:43:25 +0000 (UTC)
Received: from us-smtp-inbound-delivery-1.mimecast.com
 (us-smtp-delivery-1.mimecast.com [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EAEBE28EC10A
 for <dm-devel@redhat.com>; Tue, 10 Oct 2023 22:43:24 +0000 (UTC)
Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com
 [209.85.218.49]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-489-qVoL28gCOo6KgxxRwbEB0A-1; Tue, 10 Oct 2023 18:43:23 -0400
X-MC-Unique: qVoL28gCOo6KgxxRwbEB0A-1
Received: by mail-ej1-f49.google.com with SMTP id
 a640c23a62f3a-99c3c8adb27so1050315866b.1
 for <dm-devel@redhat.com>; Tue, 10 Oct 2023 15:43:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20230601; t=1696977802; x=1697582602;
 h=content-transfer-encoding:cc:to:subject:message-id:date:from
 :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=626B9wgJ8h02KW46+tnnnyuQPSu/ZwIJyUI7faTL3rc=;
 b=p1v6tGg385DtOZtOpMY6RJPlQBkwVUB/4EUFcA38JDeXulG9QpwGgqFu4PXIGuS/qy
 VVRh2aJLDc84vI2OJsjVXiACaZVZyj0De7FsIXZ8YriOfQeG7OMm3NE2CSyYjQ10mySD
 iau1jUkfvF2BWe+Qct9PlCCnGuJUZ5revwjScO1AM3gpNF9cmdwI276UavH2Ux9a2g32
 MnO6ysXzLJP4tYpiLmBBA2F2/lnlHqL9WBoG7GLarChDhDIQ6Yb/0fGwo+qEv9Z1sCDj
 tAZ72BD9XvuEw8z7vq7Juax8YNCMZe6gSZf4QlXvdLGrcTKuGhKU/jY85ZU70ukb2IEm
 pW/g==
X-Gm-Message-State: AOJu0Yx4i95frUn5DvBo47CHnQCUw5UA3HpY8MdFsZBMheeetuyiXUhU
 FwoV7ftmElpWeh+fD6lxPC+XwGpa+1dhZyYQKMptdw==
X-Google-Smtp-Source: AGHT+IH70mmZj2zKOy8nY6IG+ffXvimPYzar2rp3E5IPY2l9DVvHPtfuYBDsCXWHKWCzN+3Xn0WYAEez4zqxgNr6W3Q=
X-Received: by 2002:a17:907:780d:b0:9b6:4df9:e5b5 with SMTP id
 la13-20020a170907780d00b009b64df9e5b5mr17511207ejc.61.1696977802200; Tue, 10
 Oct 2023 15:43:22 -0700 (PDT)
MIME-Version: 1.0
References: <20231007012817.3052558-1-sarthakkukreti@chromium.org>
 <20231007012817.3052558-4-sarthakkukreti@chromium.org>
 <ZSM9UDMFNs0050pr@dread.disaster.area>
In-Reply-To: <ZSM9UDMFNs0050pr@dread.disaster.area>
From: Sarthak Kukreti <sarthakkukreti@chromium.org>
Date: Tue, 10 Oct 2023 15:43:10 -0700
Message-ID: <CAG9=OMNPK2s4vsun4B=xQ9nt3qR_fevNP1zSkYq9YG5QPPTsfQ@mail.gmail.com>
To: Dave Chinner <david@fromorbit.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
Subject: Re: [dm-devel] [PATCH v8 3/5] loop: Add support for provision
 requests
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
 Theodore Ts'o <tytso@mit.edu>, "Darrick J. Wong" <djwong@kernel.org>,
 Brian Foster <bfoster@redhat.com>, Bart Van Assche <bvanassche@google.com>,
 Mike Snitzer <snitzer@kernel.org>, linux-kernel@vger.kernel.org,
 linux-block@vger.kernel.org, dm-devel@redhat.com,
 Andreas Dilger <adilger.kernel@dilger.ca>, linux-fsdevel@vger.kernel.org,
 linux-ext4@vger.kernel.org, Alasdair Kergon <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: chromium.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

T24gU3VuLCBPY3QgOCwgMjAyMyBhdCA0OjM34oCvUE0gRGF2ZSBDaGlubmVyIDxkYXZpZEBmcm9t
b3JiaXQuY29tPiB3cm90ZToKPgo+IE9uIEZyaSwgT2N0IDA2LCAyMDIzIGF0IDA2OjI4OjE1UE0g
LTA3MDAsIFNhcnRoYWsgS3VrcmV0aSB3cm90ZToKPiA+IEFkZCBzdXBwb3J0IGZvciBwcm92aXNp
b24gcmVxdWVzdHMgdG8gbG9vcGJhY2sgZGV2aWNlcy4KPiA+IExvb3AgZGV2aWNlcyB3aWxsIGNv
bmZpZ3VyZSBwcm92aXNpb24gc3VwcG9ydCBiYXNlZCBvbgo+ID4gd2hldGhlciB0aGUgdW5kZXJs
eWluZyBibG9jayBkZXZpY2UvZmlsZSBjYW4gc3VwcG9ydAo+ID4gdGhlIHByb3Zpc2lvbiByZXF1
ZXN0IGFuZCB1cG9uIHJlY2VpdmluZyBhIHByb3Zpc2lvbiBiaW8sCj4gPiB3aWxsIG1hcCBpdCB0
byB0aGUgYmFja2luZyBkZXZpY2Uvc3RvcmFnZS4gRm9yIGxvb3AgZGV2aWNlcwo+ID4gb3ZlciBm
aWxlcywgYSBSRVFfT1BfUFJPVklTSU9OIHJlcXVlc3Qgd2lsbCB0cmFuc2xhdGUgdG8KPiA+IGFu
IGZhbGxvY2F0ZSBtb2RlIDAgY2FsbCBvbiB0aGUgYmFja2luZyBmaWxlLgo+ID4KPiA+IFNpZ25l
ZC1vZmYtYnk6IFNhcnRoYWsgS3VrcmV0aSA8c2FydGhha2t1a3JldGlAY2hyb21pdW0ub3JnPgo+
ID4gU2lnbmVkLW9mZi1ieTogTWlrZSBTbml0emVyIDxzbml0emVyQGtlcm5lbC5vcmc+Cj4KPgo+
IEhtbW1tLgo+Cj4gVGhpcyBkb2Vzbid0IGFjdHVhbGx5IGltcGxlbWVudCB0aGUgcmVxdWlyZWQg
c2VtYW50aWNzIG9mCj4gUkVRX1BST1ZJU0lPTi4gWWVzLCBpdCBwYXNzZXMgdGhlIGNvbW1hbmQg
dG8gdGhlIGZpbGVzeXN0ZW0KPiBmYWxsb2NhdGUoKSBpbXBsZW1lbnRhdGlvbiwgYnV0IGZhbGxv
Y2F0ZSgpIGF0IHRoZSBmaWxlc3lzdGVtIGxldmVsCj4gZG9lcyBub3QgaGF2ZSB0aGUgc2FtZSBz
ZW1hbnRpY3MgYXMgUkVRX1BST1ZJU0lPTi4KPgo+IGkuZS4gYXQgdGhlIGZpbGVzeXN0ZW0gbGV2
ZWwsIGZhbGxvY2F0ZSgpIG9ubHkgZ3VhcmFudGVlcyB0aGUgbmV4dAo+IHdyaXRlIHRvIHRoZSBw
cm92aXNpb25lZCByYW5nZSB3aWxsIHN1Y2NlZWQgd2l0aG91dCBFTk9TUEMsIGl0IGRvZXMKPiBu
b3QgZ3VhcmFudGVlICpldmVyeSogd3JpdGUgdG8gdGhlIHJhbmdlIHdpbGwgc3VjY2VlZCB3aXRo
b3V0Cj4gRU5PU1BDLiBJZiBzb21lb25lIGNsb25lcyB0aGUgbG9vcCBmaWxlIHdoaWxlIGl0IGlz
IGluIHVzZSAoaS5lLgo+IHNuYXBzaG90cyBpdCB2aWEgY3AgLS1yZWZsaW5rKSB0aGVuIGFsbCBn
dWFyYW50ZWVzIHRoYXQgdGhlIG5leHQKPiB3cml0ZSB0byBhIHByb3Zpc2lvbmVkIExCQSByYW5n
ZSB3aWxsIHN1Y2NlZWQgd2l0aG91dCBFTk9TUEMgYXJlCj4gdm9pZGVkLgo+Cj4gU28gd2hpbGUg
dGhpcyB3aWxsIHdvcmsgZm9yIGJhc2ljIHRlc3RpbmcgdGhhdCB0aGUgZmlsZXN5c3RlbSBpcwo+
IGlzc3VpbmcgUkVRX1BST1ZJU0lPTiBiYXNlZCBJTyBjb3JyZWN0bHksIGl0IGNhbid0IGFjdHVh
bGx5IGJlIHVzZWQKPiBmb3IgaG9zdGluZyBwcm9kdWN0aW9uIGZpbGVzeXN0ZW1zIHRoYXQgbmVl
ZCBmdWxsIFJFUV9QUk9WSVNJT04KPiBndWFyYW50ZWVzIHdoZW4gdGhlIGxvb3AgZGV2aWNlIGJh
Y2tpbmcgZmlsZSBpcyBpbmRlcGVuZGVudGx5Cj4gc2hhcHNob3R0ZWQgdmlhIEZJQ0xPTkUuLi4u
Cj4KPiBBdCBtaW5pbXVpbSwgdGhpcyBzZXQgb2YgaW1wbGVtZW50YXRpb24gY29uc3RyYWludHMg
bmVlZHMgdG9iZQo+IGRvY3VtZW50ZWQgc29tZXdoZXJlLi4uCj4KRmFpciBwb2ludC4gSSB3YW50
ZWQgdG8gaGF2ZSBhIHNlcGFyYXRlIGZhbGxvY2F0ZSgpIG1vZGUKKEZBTExPQ19GTF9QUk9WSVNJ
T04pIGluIHRoZSBlYXJsaWVyIHNlcmllcyBvZiB0aGUgcGF0Y2hzZXQgc28gdGhhdCB3ZQpjYW4g
ZGlzdGluZ3Vpc2ggYmV0d2VlbiBhIHByb3Zpc2lvbiByZXF1ZXN0IGFuZCBhIHJlZ3VsYXIgZmFs
bG9jYXRlKCkKY2FsbDsgSSBkcm9wcGVkIGl0IGZyb20gdGhlIHNlcmllcyBhZnRlciBmZWVkYmFj
ayB0aGF0IHRoZSBkZWZhdWx0CmNhc2Ugc2hvdWxkIHN1ZmZpY2UuIEJ1dCB0aGlzIG1pZ2h0IGJl
IG9uZSBvZiB0aGUgY2FzZXMgd2hlcmUgd2UgbmVlZAphbiBleHBsaWNpdCBpbnRlbnQgdGhhdCB3
ZSB3YW50IHRvIHByb3Zpc2lvbiBzcGFjZS4KCkdpdmVuIGEgc2VwYXJhdGUgRkFMTE9DX0ZMX1BS
T1ZJU0lPTiBtb2RlIGluIHRoZSBzY2VuYXJpbyB5b3UKbWVudGlvbmVkLCB0aGUgZmlsZXN5c3Rl
bSBjb3VsZCBjb3B5IHByZXZpb3VzbHkgJ3Byb3Zpc2lvbmVkJyBibG9ja3MKdG8gbmV3IGJsb2Nr
cyAod2hpY2ggaW1wbGljaXRseSBwcm92aXNpb25zIHRoZW0pIG9yIHJlc2VydmUgYmxvY2tzIGZv
cgp1c2UgKGFuZCBwYXNzaW5nIHRocm91Z2ggUkVRX09QX1BST1ZJU0lPTiBiZWxvdykuIFRoYXQg
YWxzbyBtZWFucyB0aGF0CnRoZSBmaWxlc3lzdGVtIHNob3VsZCB0cmFjayAncHJvdmlzaW9uZWQn
IGJsb2NrcyBhbmQgdGFrZSBhcHByb3ByaWF0ZQphY3Rpb25zIHRvIGVuc3VyZSB0aGUgcHJvdmlz
aW9uaW5nIGd1YXJhbnRlZXMuCgpGb3IgZmlsZXN5c3RlbXMgd2l0aG91dCBjb3B5LW9uLXdyaXRl
IHNlbWFudGljcyAoZWcuIGV4dDQpLApSRVFfT1BfUFJPVklTSU9OIHNob3VsZCBzdGlsbCBiZSBl
cXVpdmFsZW50IHRvIG1vZGUgPT0gMC4KCkZvciBub3csIEknbGwgYWRkIHRoZSBkZXRhaWxzIHRv
IHRoZSBjb21taXQgbWVzc2FnZSBhbmQgdGhlIGxvb3AKZHJpdmVyIGNvZGUgKHNpZGUgbm90ZTog
c2hvdWxkIHRoZXJlIGJlIGRldmljZSBkb2N1bWVudGF0aW9uIG9uIHRoZQpsb29wIGRldmljZSBk
cml2ZXI/KS4gV0RZVD8KCkJlc3QKU2FydGhhawoKPiAtRGF2ZS4KPiAtLQo+IERhdmUgQ2hpbm5l
cgo+IGRhdmlkQGZyb21vcmJpdC5jb20KCi0tCmRtLWRldmVsIG1haWxpbmcgbGlzdApkbS1kZXZl
bEByZWRoYXQuY29tCmh0dHBzOi8vbGlzdG1hbi5yZWRoYXQuY29tL21haWxtYW4vbGlzdGluZm8v
ZG0tZGV2ZWwK

