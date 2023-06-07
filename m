Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1F240C7EE37
	for <dm-devel@archiver.kernel.org>; Thu,  8 Jun 2023 06:49:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686206941;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=PJbrrhz5EVasZw51Iv42YpZQwBlTmHTRSz87986d5ak=;
	b=dPhKzB5wNCfCRpzAJZQIikgAdKvz7kwWRlPf2KdrLDVBsDCsCkeic/qVW22rbFZKNQSdfA
	VciA+bYleHTgyCw2WgPtsQ+O2bXZzScRUsIfIcfGTBZwM6ISeEU/bRX0yYANZRrMLscdoW
	UJwlZlpLmARmrWe38T7hD3nwA5/QNGI=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-372-Xi5_40KdO4WAguLjXwKgfQ-1; Thu, 08 Jun 2023 02:48:56 -0400
X-MC-Unique: Xi5_40KdO4WAguLjXwKgfQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5D2B23C0F1A0;
	Thu,  8 Jun 2023 06:48:51 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 49A8C140E955;
	Thu,  8 Jun 2023 06:48:51 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id B744119451E7;
	Thu,  8 Jun 2023 06:48:48 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id BC93419465BA
 for <dm-devel@listman.corp.redhat.com>; Wed,  7 Jun 2023 09:42:54 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 54FCE140E955; Wed,  7 Jun 2023 09:42:54 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 4D4ED140E954
 for <dm-devel@redhat.com>; Wed,  7 Jun 2023 09:42:54 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 304CF3C13502
 for <dm-devel@redhat.com>; Wed,  7 Jun 2023 09:42:54 +0000 (UTC)
Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com
 [209.85.208.53]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-384-KQqzUCX-MMSK4X4eCRNV5A-1; Wed, 07 Jun 2023 05:42:52 -0400
X-MC-Unique: KQqzUCX-MMSK4X4eCRNV5A-1
Received: by mail-ed1-f53.google.com with SMTP id
 4fb4d7f45d1cf-5149429c944so1197308a12.0
 for <dm-devel@redhat.com>; Wed, 07 Jun 2023 02:42:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1686130971; x=1688722971;
 h=content-transfer-encoding:cc:to:subject:message-id:date:from
 :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=iTSJC08M16dk7ac+qC1NLiFtaB9M/5yyS+Z15P92ssA=;
 b=Jm1kog0Uw6APcT3l89N2YRSC7xUDnXIKE25SBd+0Eg1Zcx3/nqMB28EdTmK/H+EUZe
 ECG+QK1222tnN8LqtoeAPRx8QemoiS3MHIxYRK5N7pSGnzlHUdyEu2xxU1ht4oZr6IDp
 A4AD1Ya7hWdyybpi9k9wZhbqcUfqoysYCSzgu6hLmHXUAyme4ZDkVG2T8ZlGFjy+NMN4
 La2uAfVtXrh/kwEZnEFcgeJzD7KQYDu/0QJuG5Yodju673RNRnzfovZzRRxoJkQCt05A
 2mD5u9sXgU9rcmhRSaiByKaIbSgHymuN1E0SXVYwgkHdLqLuFYNFC4pYO9FC27QgoCs3
 XwPg==
X-Gm-Message-State: AC+VfDysXJIdl3RIg66wtYmIYzNIoku6FatM5fRIt4tAPJTY78L6pcMc
 WkAtcmYDzRQhApOMiu8EeTYuA5GvmcdCYCrnSW3XNA==
X-Google-Smtp-Source: ACHHUZ5i8f5AUVXLioiA4Msh4foVuVuox1MKnFKi4fucw3rKEDDzkk1m6bVkvWRpki6Lz1RgGXGnv70bM2LGvyL4BxY=
X-Received: by 2002:aa7:cd55:0:b0:514:8e6f:7113 with SMTP id
 v21-20020aa7cd55000000b005148e6f7113mr3506396edw.22.1686130971195; Wed, 07
 Jun 2023 02:42:51 -0700 (PDT)
MIME-Version: 1.0
References: <20230606073950.225178-1-hch@lst.de>
 <20230606073950.225178-10-hch@lst.de>
In-Reply-To: <20230606073950.225178-10-hch@lst.de>
From: Jinpu Wang <jinpu.wang@ionos.com>
Date: Wed, 7 Jun 2023 11:42:40 +0200
Message-ID: <CAMGffEkKpHzatfeJhKtJQMTNckJGc7sJQ_LWFg-KvazvOD4DWw@mail.gmail.com>
To: Christoph Hellwig <hch@lst.de>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Mailman-Approved-At: Thu, 08 Jun 2023 06:48:45 +0000
Subject: Re: [dm-devel] [PATCH 09/31] block: pass a gendisk to ->open
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
 linux-nilfs@vger.kernel.org, linux-scsi@vger.kernel.org,
 Richard Weinberger <richard@nod.at>, linux-pm@vger.kernel.org,
 linux-um@lists.infradead.org, Josef Bacik <josef@toxicpanda.com>,
 Coly Li <colyli@suse.de>, linux-block@vger.kernel.org,
 linux-bcache@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>,
 David Sterba <dsterba@suse.com>, Jens Axboe <axboe@kernel.dk>,
 Christian Brauner <brauner@kernel.org>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
 linux-mtd@lists.infradead.org, linux-btrfs@vger.kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: ionos.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

T24gVHVlLCBKdW4gNiwgMjAyMyBhdCA5OjQw4oCvQU0gQ2hyaXN0b3BoIEhlbGx3aWcgPGhjaEBs
c3QuZGU+IHdyb3RlOgo+Cj4gLT5vcGVuIGlzIG9ubHkgY2FsbGVkIG9uIHRoZSB3aG9sZSBkZXZp
Y2UuICBNYWtlIHRoYXQgZXhwbGljaXQgYnkKPiBwYXNzaW5nIGEgZ2VuZGlzayBpbnN0ZWFkIG9m
IHRoZSBibG9ja19kZXZpY2UuCj4KPiBTaWduZWQtb2ZmLWJ5OiBDaHJpc3RvcGggSGVsbHdpZyA8
aGNoQGxzdC5kZT4KPiAtLS0KPiAgYXJjaC91bS9kcml2ZXJzL3ViZF9rZXJuLmMgICAgICAgICAg
fCAgNSArKy0tLQo+ICBhcmNoL3h0ZW5zYS9wbGF0Zm9ybXMvaXNzL3NpbWRpc2suYyB8ICA0ICsr
LS0KPiAgYmxvY2svYmRldi5jICAgICAgICAgICAgICAgICAgICAgICAgfCAgMiArLQo+ICBkcml2
ZXJzL2Jsb2NrL2FtaWZsb3AuYyAgICAgICAgICAgICB8ICA4ICsrKystLS0tCj4gIGRyaXZlcnMv
YmxvY2svYW9lL2FvZWJsay5jICAgICAgICAgIHwgIDQgKystLQo+ICBkcml2ZXJzL2Jsb2NrL2F0
YWZsb3AuYyAgICAgICAgICAgICB8IDE2ICsrKysrKystLS0tLS0tLQo+ICBkcml2ZXJzL2Jsb2Nr
L2RyYmQvZHJiZF9tYWluLmMgICAgICB8ICA2ICsrKy0tLQo+ICBkcml2ZXJzL2Jsb2NrL2Zsb3Bw
eS5jICAgICAgICAgICAgICB8IDMwICsrKysrKysrKysrKysrKy0tLS0tLS0tLS0tLS0tCj4gIGRy
aXZlcnMvYmxvY2svbmJkLmMgICAgICAgICAgICAgICAgIHwgIDggKysrKy0tLS0KPiAgZHJpdmVy
cy9ibG9jay9wa3RjZHZkLmMgICAgICAgICAgICAgfCAgNiArKystLS0KPiAgZHJpdmVycy9ibG9j
ay9yYmQuYyAgICAgICAgICAgICAgICAgfCAgNCArKy0tCj4gIGRyaXZlcnMvYmxvY2svcm5iZC9y
bmJkLWNsdC5jICAgICAgIHwgIDQgKystLQpBY2tlZC1ieTogSmFjayBXYW5nIDxqaW5wdS53YW5n
QGlvbm9zLmNvbT4gIyBmb3Igcm5iZAoKLS0KZG0tZGV2ZWwgbWFpbGluZyBsaXN0CmRtLWRldmVs
QHJlZGhhdC5jb20KaHR0cHM6Ly9saXN0bWFuLnJlZGhhdC5jb20vbWFpbG1hbi9saXN0aW5mby9k
bS1kZXZlbAo=

