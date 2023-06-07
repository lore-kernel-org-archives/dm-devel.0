Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C06E0C7EE29
	for <dm-devel@archiver.kernel.org>; Wed,  7 Jun 2023 12:23:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686140628;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=BDlhjqDkEbrbzHoTc2aQL//Oac29HWGgb+o/t9Kxw6I=;
	b=ZDJV4GsEG0sV6yoNnnRe2hgG5yVx1+4CWszHSsuHbgM7j0llAGUN12+Oj/h4146bh63XvM
	LiLgdh/U/UGGSKC118RluNtNALScgvTiJHLs+ktMWEXJ/enscK0eDT/XGZZsjC5LlQA8Nq
	Ilf56c3/tMAZPsgdwJFZ7BviGEuEdHE=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-86-KvtkgmA5O1q3YDw5_ZSHoQ-1; Wed, 07 Jun 2023 08:23:45 -0400
X-MC-Unique: KvtkgmA5O1q3YDw5_ZSHoQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C73201C09046;
	Wed,  7 Jun 2023 12:23:43 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 7137F2166B25;
	Wed,  7 Jun 2023 12:23:43 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 3655719452C4;
	Wed,  7 Jun 2023 12:23:33 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id DE398194E126
 for <dm-devel@listman.corp.redhat.com>; Wed,  7 Jun 2023 12:17:05 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 076BC140E955; Wed,  7 Jun 2023 12:17:05 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id F3B0B140E954
 for <dm-devel@redhat.com>; Wed,  7 Jun 2023 12:17:04 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D2A55185A7AB
 for <dm-devel@redhat.com>; Wed,  7 Jun 2023 12:17:04 +0000 (UTC)
Received: from verein.lst.de (verein.lst.de [213.95.11.211]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-290-Ts0Qf0yUP0KOj5HjDfRpIw-1; Wed, 07 Jun 2023 08:17:02 -0400
X-MC-Unique: Ts0Qf0yUP0KOj5HjDfRpIw-1
Received: by verein.lst.de (Postfix, from userid 2407)
 id 52B4E6732D; Wed,  7 Jun 2023 14:16:58 +0200 (CEST)
Date: Wed, 7 Jun 2023 14:16:58 +0200
From: Christoph Hellwig <hch@lst.de>
To: Christian Brauner <brauner@kernel.org>
Message-ID: <20230607121658.GA13632@lst.de>
References: <20230606073950.225178-1-hch@lst.de>
 <20230606073950.225178-29-hch@lst.de>
 <20230607-kocht-kornfeld-a249c6740e38@brauner>
MIME-Version: 1.0
In-Reply-To: <20230607-kocht-kornfeld-a249c6740e38@brauner>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
Subject: Re: [dm-devel] [PATCH 28/31] block: replace fmode_t with a
 block-specific type for block open flags
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
Cc: Vignesh Raghavendra <vigneshr@ti.com>,
 "Rafael J. Wysocki" <rafael@kernel.org>, linux-nvme@lists.infradead.org,
 Phillip Potter <phil@philpotter.co.uk>, Chris Mason <clm@fb.com>,
 dm-devel@redhat.com, "Md. Haris Iqbal" <haris.iqbal@ionos.com>,
 Pavel Machek <pavel@ucw.cz>, Miquel Raynal <miquel.raynal@bootlin.com>,
 Jack Wang <jinpu.wang@ionos.com>, Christoph Hellwig <hch@lst.de>,
 linux-nilfs@vger.kernel.org, linux-scsi@vger.kernel.org,
 Richard Weinberger <richard@nod.at>, linux-pm@vger.kernel.org,
 linux-um@lists.infradead.org, Josef Bacik <josef@toxicpanda.com>,
 Coly Li <colyli@suse.de>, linux-block@vger.kernel.org,
 linux-bcache@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>,
 David Sterba <dsterba@suse.com>, Jens Axboe <axboe@kernel.dk>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
 linux-mtd@lists.infradead.org, linux-btrfs@vger.kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: lst.de
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

T24gV2VkLCBKdW4gMDcsIDIwMjMgYXQgMTE6MjE6MTRBTSArMDIwMCwgQ2hyaXN0aWFuIEJyYXVu
ZXIgd3JvdGU6Cj4gT24gVHVlLCBKdW4gMDYsIDIwMjMgYXQgMDk6Mzk6NDdBTSArMDIwMCwgQ2hy
aXN0b3BoIEhlbGx3aWcgd3JvdGU6Cj4gPiBUaGUgb25seSBvdmVybGFwIGJldHdlZW4gdGhlIGJs
b2NrIG9wZW4gZmxhZ3MgbWFwcGVkIGludG8gdGhlIGZtb2RlX3QgYW5kCj4gPiBvdGhlciB1c2Vz
IG9mIGZtb2RlX3QgYXJlIEZNT0RFX1JFQUQgYW5kIEZNT0RFX1dSSVRFLiAgRGVmaW5lIGEgbmV3
Cj4gCj4gYW5kIEZNT0RFX0VYQ0wgYWZhaWN0CgpGTU9ERV9FWENMIGlzbid0IHVzZWQgb3V0c2lk
ZSB0aGUgYmxvY2sgbGF5ZXIgYW5kIHJlbW92ZWQgaW4gdGhlIGxhc3QKcGF0Y2guCgo+ID4gK2Js
a19tb2RlX3QgZmlsZV90b19ibGtfbW9kZShzdHJ1Y3QgZmlsZSAqZmlsZSkKPiA+ICt7Cj4gPiAr
CWJsa19tb2RlX3QgbW9kZSA9IDA7Cj4gPiArCj4gPiArCWlmIChmaWxlLT5mX21vZGUgJiBGTU9E
RV9SRUFEKQo+ID4gKwkJbW9kZSB8PSBCTEtfT1BFTl9SRUFEOwo+ID4gKwlpZiAoZmlsZS0+Zl9t
b2RlICYgRk1PREVfV1JJVEUpCj4gPiArCQltb2RlIHw9IEJMS19PUEVOX1dSSVRFOwo+ID4gKwlp
ZiAoZmlsZS0+Zl9tb2RlICYgRk1PREVfRVhDTCkKPiA+ICsJCW1vZGUgfD0gQkxLX09QRU5fRVhD
TDsKPiA+ICsJaWYgKChmaWxlLT5mX2ZsYWdzICYgT19BQ0NNT0RFKSA9PSAzKQo+IAo+IEkgcmVh
bGx5IGRvbid0IGxpa2UgbWFnaWMgbnVtYmVycyBsaWtlIHRoaXMuCgpJIGRvbid0IGxpa2UgdGhl
bSBlaXRoZXIsIGJ1dCB0aGlzIGlzIGp1c3QgbW92ZWQgYXJvdW5kIGFuZCBub3QgbmV3LgoKPiBH
cm9hbiwgT19SRE9OTFkgYmVpbmcgZGVmaW5lZCBhcyAwIHN0cmlrZXMgYWdhaW4uLi4KPiBCZWN1
YXNlIG9mIHRoaXMgcXVpcmsgd2UgaW50ZXJuYWxseSBtYXAKPiAKPiBPX1JET05MWSgwKSAtPiBG
TU9ERV9SRUFEKDEpCj4gT19XUk9OTFkoMSkgLT4gRk1PREVfV1JJVEUoMikKPiBPX1JEV1IoMykg
ICAtPiAoRk1PREVfUkVBRCB8IEZNT0RFX1dSSVRFKQoKT19SRFdSIGlzIDIuCgo+IHNvIGNoZWNr
aW5nIGZvciB0aGUgcmF3IDMgaGVyZSBpcyBjb25mdXNpbmcgaW4gYWRkaXRpb24gdG8gYmVpbmcg
YSBtYWdpYwo+IG51bWJlciBhcyBpdCBjb3VsZCBnaXZlIHRoZSBpbXByZXNzaW9uIHRoYXQgd2hh
dCdzIGNoZWNrZWQgaGVyZSBpcwo+IChPX1dST05MWSB8IE9fUkRXUikgd2hpY2ggZG9lc24ndCBt
YWtlIHNlbnNlLi4uCgpXZWxsLCB0aGF0IGlzIGV4YWN0bHkgd2hhdCB3ZSBjaGVjayBmb3IuICBU
aGlzIGlzIGEgMzAtaXNoIHllYXIgb2xkCnF1aXJrIG9ubHkgdXNlZCBpbiB0aGUgZmxvcHB5IGRy
aXZlci4KCj4gU28gbXkgcGVyZmVyZW5jZSB3b3VsZCBiZSBpbiBkZXNjZW5kaW5nIG9yZGVyIG9m
IHByZWZlcmVuY2U6Cj4gCj4gKGZpbGUtPmZfZmxhZ3MgJiBPX0FDQ01PREUpID09IChGTU9ERV9S
RUFEIHwgRk1PREVfV1JJVEUpCj4gCj4gb3Igd2hpbGUgYSBsaXR0bGUgbGVzcyBjbGVhciBidXQg
aW5mb3JtYXRpdmUgZW5vdWdoIGZvciBwZW9wbGUgZmFtaWxpYXIKPiB3aXRoIHRoZSBPX1JET05M
WSBxdWlyazoKPiAKPiBpZiAoKGZpbGUtPmZfZmxhZ3MgJiBPX0FDQ01PREUpID09IE9fQUNDTU9E
RSkKCkkgZG9uJ3QgdW5kZXJzdGFuZCB0aGlzIHBhcnQuICBFc3BlY2lhbGx5IHRoZSBhYm92ZSBk
b2Vzbid0IG1ha2UKYW55IHNlbnNlIGFzIEZNT0RFX1JFQUQgYW5kIEZNT0RFX1dSSVRFIGFyZSBp
biBhIGNvbXBsZXRlbHkgZGlmZmVyZW50CnN5bWJvbCBzcGFjZSB0byBPXyosIGFuZCBub3QgYSBV
QVDQhiBidXQgYSBrZXJuZWwgaW50ZXJuYWwgdGhpbmcgdGhhdApjb3VsZCBiZSByZW51bWJlcmVk
IGFueSB0aW1lLgoKLS0KZG0tZGV2ZWwgbWFpbGluZyBsaXN0CmRtLWRldmVsQHJlZGhhdC5jb20K
aHR0cHM6Ly9saXN0bWFuLnJlZGhhdC5jb20vbWFpbG1hbi9saXN0aW5mby9kbS1kZXZlbAo=

