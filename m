Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 80B36C87FDC
	for <dm-devel@archiver.kernel.org>; Thu,  8 Jun 2023 06:49:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686206960;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=e8PeIx3sbo9CFlUHbLN7RKUtbWz5VFg+cVNhHXcYIKE=;
	b=Dv/yNW/HAiKgqxkRU0Ruc1cW2qTqYnVXcPGOmpn36OYGlUODEP/1KeNRZel0O8xi68KG7k
	PYbzGw+gzk7/FCKxRbHRFjOi0/VnZAltmM+RHEcXIGhoWafycgGgbJBsMJiBF0u9h2Zlyh
	fDf88WpI+v355wW2jp3wyFNSghiaDxI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-448-gzxturwbPZ-_H3n94vc4Aw-1; Thu, 08 Jun 2023 02:49:16 -0400
X-MC-Unique: gzxturwbPZ-_H3n94vc4Aw-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C9C3985A5BD;
	Thu,  8 Jun 2023 06:49:13 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id B946C492B0B;
	Thu,  8 Jun 2023 06:49:13 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 8C79319378C6;
	Thu,  8 Jun 2023 06:48:58 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id C94F619465BA
 for <dm-devel@listman.corp.redhat.com>; Wed,  7 Jun 2023 09:41:26 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id A431A40218C; Wed,  7 Jun 2023 09:41:26 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 9C9A2492B00
 for <dm-devel@redhat.com>; Wed,  7 Jun 2023 09:41:26 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 804288002BF
 for <dm-devel@redhat.com>; Wed,  7 Jun 2023 09:41:26 +0000 (UTC)
Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com
 [209.85.208.53]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-520-Vt5nfUByM8OnIkiHFoyUBQ-1; Wed, 07 Jun 2023 05:41:24 -0400
X-MC-Unique: Vt5nfUByM8OnIkiHFoyUBQ-1
Received: by mail-ed1-f53.google.com with SMTP id
 4fb4d7f45d1cf-5149c76f4dbso1141886a12.1
 for <dm-devel@redhat.com>; Wed, 07 Jun 2023 02:41:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1686130883; x=1688722883;
 h=content-transfer-encoding:cc:to:subject:message-id:date:from
 :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=/hFPeu/3BJQ1XAEBfX/WbvMEVzeUhOBPi58IZ/Esj6w=;
 b=IIDyW8uiVBkYUbxNvNiptN+BYsAvswctCTg3WVJJqKOdErDkUslU40BTGDzLcCdO9H
 lVOpGYB/Jyj4LVhYyS4mzLbiDEqge+HbPJ3uWWxYp6JEFup5J1Ljd5hZVrpb7gYosHVK
 EV239sAtRd9XFoeHABxnkxAn3d2a5Zj1vrxPslM6bWBwbLS6UsLZ8zfFPTgnf2+zwu4y
 tfjZb7w3uKsYXo8loVQmxoYNIJ1i1Xc8mCfrIJowG7Py/BbhG0/PbBI5gOvC7BPIMYvo
 fAO3Ftnm03gx/CcQI51tGM+iGpnPH2ToclC3xk6HUsepp+Z+8zTQRsZvhWje/Oev4zsb
 A33Q==
X-Gm-Message-State: AC+VfDwQTYwPHArM60E9mgJZPyXhtRjsHa8Z6yw1bu0qTsyhEFCSpcJL
 BwFAPpc5o023n+LLs/MPvgWSNKeJwCEb+HBRx8YDBw==
X-Google-Smtp-Source: ACHHUZ78LLb5/9Eve9DZQqNC/TRa3vxkXV4pVMAtKfHjnQnscHPEcmWv/7uCCN4Q8kcsT8KuG+XDWcwCZO/ggZjCnJk=
X-Received: by 2002:a17:907:2d8c:b0:94e:e97b:c65 with SMTP id
 gt12-20020a1709072d8c00b0094ee97b0c65mr5404803ejc.60.1686130883637; Wed, 07
 Jun 2023 02:41:23 -0700 (PDT)
MIME-Version: 1.0
References: <20230606073950.225178-1-hch@lst.de>
 <20230606073950.225178-11-hch@lst.de>
In-Reply-To: <20230606073950.225178-11-hch@lst.de>
From: Jinpu Wang <jinpu.wang@ionos.com>
Date: Wed, 7 Jun 2023 11:41:12 +0200
Message-ID: <CAMGffEkqXCkxpA+qqDVfx0echCPvNpWgK3hZWbb11F6cv2EQ-A@mail.gmail.com>
To: Christoph Hellwig <hch@lst.de>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Mailman-Approved-At: Thu, 08 Jun 2023 06:48:45 +0000
Subject: Re: [dm-devel] [PATCH 10/31] block: remove the unused mode argument
 to ->release
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: ionos.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

T24gVHVlLCBKdW4gNiwgMjAyMyBhdCA5OjQw4oCvQU0gQ2hyaXN0b3BoIEhlbGx3aWcgPGhjaEBs
c3QuZGU+IHdyb3RlOgo+Cj4gVGhlIG1vZGUgYXJndW1lbnQgdG8gdGhlIC0+cmVsZWFzZSBibG9j
a19kZXZpY2Vfb3BlcmF0aW9uIGlzIG5ldmVyIHVzZWQsCj4gc28gcmVtb3ZlIGl0Lgo+Cj4gU2ln
bmVkLW9mZi1ieTogQ2hyaXN0b3BoIEhlbGx3aWcgPGhjaEBsc3QuZGU+Cj4gLS0tCj4gIGFyY2gv
dW0vZHJpdmVycy91YmRfa2Vybi5jICAgICAgICAgIHwgIDQgKystLQo+ICBhcmNoL3h0ZW5zYS9w
bGF0Zm9ybXMvaXNzL3NpbWRpc2suYyB8ICAyICstCj4gIGJsb2NrL2JkZXYuYyAgICAgICAgICAg
ICAgICAgICAgICAgIHwgMTQgKysrKysrKy0tLS0tLS0KPiAgZHJpdmVycy9ibG9jay9hbWlmbG9w
LmMgICAgICAgICAgICAgfCAgMiArLQo+ICBkcml2ZXJzL2Jsb2NrL2FvZS9hb2VibGsuYyAgICAg
ICAgICB8ICAyICstCj4gIGRyaXZlcnMvYmxvY2svYXRhZmxvcC5jICAgICAgICAgICAgIHwgIDQg
KystLQo+ICBkcml2ZXJzL2Jsb2NrL2RyYmQvZHJiZF9tYWluLmMgICAgICB8ICA0ICsrLS0KPiAg
ZHJpdmVycy9ibG9jay9mbG9wcHkuYyAgICAgICAgICAgICAgfCAgMiArLQo+ICBkcml2ZXJzL2Js
b2NrL2xvb3AuYyAgICAgICAgICAgICAgICB8ICAyICstCj4gIGRyaXZlcnMvYmxvY2svbmJkLmMg
ICAgICAgICAgICAgICAgIHwgIDIgKy0KPiAgZHJpdmVycy9ibG9jay9wa3RjZHZkLmMgICAgICAg
ICAgICAgfCAgNCArKy0tCj4gIGRyaXZlcnMvYmxvY2svcmJkLmMgICAgICAgICAgICAgICAgIHwg
IDIgKy0KPiAgZHJpdmVycy9ibG9jay9ybmJkL3JuYmQtY2x0LmMgICAgICAgfCAgMiArLQpBY2tl
ZC1ieTogSmFjayBXYW5nIDxqaW5wdS53YW5nQGlvbm9zLmNvbT4gIyBmb3Igcm5iZAoKLS0KZG0t
ZGV2ZWwgbWFpbGluZyBsaXN0CmRtLWRldmVsQHJlZGhhdC5jb20KaHR0cHM6Ly9saXN0bWFuLnJl
ZGhhdC5jb20vbWFpbG1hbi9saXN0aW5mby9kbS1kZXZlbAo=

