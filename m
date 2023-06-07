Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F2416C7EE25
	for <dm-devel@archiver.kernel.org>; Thu,  8 Jun 2023 06:49:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686206954;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=RpOyJdOkQmttjyyXZPnjDZeunWHM9MGPxdkxBdhJYN0=;
	b=FyMzSXaj+2ZNOK0DHhLXOoEei2i7Fxx2ItOsycQkR2ug4Zu1kzU2tm2ysPite+Tif6YQLa
	Ekcugg1KXMXye0s47FK0XWebFUi3L9001CWOr8YxInB7zz8F0QOdkSGjTxmJE+4SC4YzV4
	/IC2Br9uzjPqFAfG8bXxvPmP7D/22bg=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-266-TkOIox64OVKxFeNKpvgz4Q-1; Thu, 08 Jun 2023 02:49:12 -0400
X-MC-Unique: TkOIox64OVKxFeNKpvgz4Q-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D51AC858299;
	Thu,  8 Jun 2023 06:49:06 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id C25E99E94;
	Thu,  8 Jun 2023 06:49:06 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 924A9195439E;
	Thu,  8 Jun 2023 06:48:56 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 4059919465BA
 for <dm-devel@listman.corp.redhat.com>; Wed,  7 Jun 2023 09:40:15 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 1F7F5C16044; Wed,  7 Jun 2023 09:40:15 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 17A60C1603B
 for <dm-devel@redhat.com>; Wed,  7 Jun 2023 09:40:15 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-2.mimecast.com
 [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EDBCB1C0514F
 for <dm-devel@redhat.com>; Wed,  7 Jun 2023 09:40:14 +0000 (UTC)
Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com
 [209.85.208.42]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-596-ATYzR9paNaeT-K8i24CFRw-1; Wed, 07 Jun 2023 05:40:13 -0400
X-MC-Unique: ATYzR9paNaeT-K8i24CFRw-1
Received: by mail-ed1-f42.google.com with SMTP id
 4fb4d7f45d1cf-51478f6106cso1136312a12.1
 for <dm-devel@redhat.com>; Wed, 07 Jun 2023 02:40:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1686130812; x=1688722812;
 h=content-transfer-encoding:cc:to:subject:message-id:date:from
 :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=OKacAnva3Yv49FZ4mmigtapivvs6Pz0X+m8VvMKeakc=;
 b=mD4vwEDJxkffjHpQ4DyReykMy7bMU0ZuxbY52fFzr1pRm2UTqiKQjTINjF/DCGr7uE
 pMEjR2lixWoK8pOmnO0l6uuRkwEqD0DXSh/O/Rm64qKxIxIrMbN66XwbNNYC0k3pZIWg
 DTVIHak0TMMbfah/QWn7JXbrzev4EswDMbMiPbjpnvHU74rk7orqkJBHv0ogP4MhGSR5
 5tGXpYVhAW6nzn+Ew2npPqWd39MvFqPBmeeiRDEd8J9ENoNkraHuuJqIYVst8IOkCW8Y
 /w/A5fdeKChg9nthLTcKGLFFjjdBo2Ze/4cL1onGcRHmVp6mSq626kh7TsBqdFXvmdkq
 qjeA==
X-Gm-Message-State: AC+VfDy4zJ7jZWrN6d+DlrllWRMhIDOihPRRM5IcdKkL0aDKAwxwl16A
 spbHIRMUilT3mAfFo7J7FzKTiP3H9jEdb9QYeFL6zQ==
X-Google-Smtp-Source: ACHHUZ6qGErDhBYRK2EQNWjsiTZgthNZdqE08xgi5M9Zl1p8ZDd17beUaKBrj0/jBLtUwBleXb1y7OCzWAlQzI4iqec=
X-Received: by 2002:aa7:c3c3:0:b0:516:3261:17d with SMTP id
 l3-20020aa7c3c3000000b005163261017dmr3772815edr.20.1686130811848; Wed, 07 Jun
 2023 02:40:11 -0700 (PDT)
MIME-Version: 1.0
References: <20230606073950.225178-1-hch@lst.de>
 <20230606073950.225178-17-hch@lst.de>
In-Reply-To: <20230606073950.225178-17-hch@lst.de>
From: Jinpu Wang <jinpu.wang@ionos.com>
Date: Wed, 7 Jun 2023 11:40:01 +0200
Message-ID: <CAMGffEkXqRMD3yeyjXzTn1ZyHnszmPhqRdP8eN12KXcTdz=9Xw@mail.gmail.com>
To: Christoph Hellwig <hch@lst.de>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Mailman-Approved-At: Thu, 08 Jun 2023 06:48:45 +0000
Subject: Re: [dm-devel] [PATCH 16/31] block: use the holder as indication
 for exclusive opens
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: ionos.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

T24gVHVlLCBKdW4gNiwgMjAyMyBhdCA5OjQw4oCvQU0gQ2hyaXN0b3BoIEhlbGx3aWcgPGhjaEBs
c3QuZGU+IHdyb3RlOgo+Cj4gVGhlIGN1cnJlbnQgaW50ZXJmYWNlIGZvciBleGNsdXNpdmUgb3Bl
bnMgaXMgcmF0aGVyIGNvbmZ1c2luZyBhcyBpdAo+IHJlcXVpcmVzIGJvdGggdGhlIEZNT0RFX0VY
Q0wgZmxhZyBhbmQgYSBob2xkZXIuICBSZW1vdmUgdGhlIG5lZWQgdG8gcGFzcwo+IEZNT0RFX0VY
Q0wgYW5kIGp1c3Qga2V5IG9mZiB0aGUgZXhjbHVzaXZlIG9wZW4gb2ZmIGEgbm9uLU5VTEwgaG9s
ZGVyLgo+Cj4gRm9yIGJsa2Rldl9wdXQgdGhpcyByZXF1aXJlcyBhZGRpbmcgdGhlIGhvbGRlciBh
cmd1bWVudCwgd2hpY2ggcHJvdmlkZXMKPiBiZXR0ZXIgZGVidWcgY2hlY2tpbmcgdGhhdCBvbmx5
IHRoZSBob2xkZXIgYWN0dWFsbHkgcmVsZWFzZXMgdGhlIGhvbGQsCj4gYnV0IGF0IHRoZSBzYW1l
IHRpbWUgYWxsb3dzIHJlbW92aW5nIHRoZSBub3cgc3VwZXJmbHVvdXMgbW9kZSBhcmd1bWVudC4K
Pgo+IFNpZ25lZC1vZmYtYnk6IENocmlzdG9waCBIZWxsd2lnIDxoY2hAbHN0LmRlPgo+IC0tLQo+
ICBibG9jay9iZGV2LmMgICAgICAgICAgICAgICAgICAgICAgICB8IDM3ICsrKysrKysrKysrKysr
KystLS0tLS0tLS0tLS0KPiAgYmxvY2svZm9wcy5jICAgICAgICAgICAgICAgICAgICAgICAgfCAg
NiArKystLQo+ICBibG9jay9nZW5oZC5jICAgICAgICAgICAgICAgICAgICAgICB8ICA1ICsrLS0K
PiAgYmxvY2svaW9jdGwuYyAgICAgICAgICAgICAgICAgICAgICAgfCAgNSArKy0tCj4gIGRyaXZl
cnMvYmxvY2svZHJiZC9kcmJkX25sLmMgICAgICAgIHwgMjMgKysrKysrKysrKy0tLS0tLS0KPiAg
ZHJpdmVycy9ibG9jay9wa3RjZHZkLmMgICAgICAgICAgICAgfCAxMyArKysrKy0tLS0tCj4gIGRy
aXZlcnMvYmxvY2svcm5iZC9ybmJkLXNydi5jICAgICAgIHwgIDQgKy0tCkFja2VkLWJ5OiBKYWNr
IFdhbmcgPGppbnB1LndhbmdAaW9ub3MuY29tPiAjIGZvciBybmJkCgotLQpkbS1kZXZlbCBtYWls
aW5nIGxpc3QKZG0tZGV2ZWxAcmVkaGF0LmNvbQpodHRwczovL2xpc3RtYW4ucmVkaGF0LmNvbS9t
YWlsbWFuL2xpc3RpbmZvL2RtLWRldmVsCg==

