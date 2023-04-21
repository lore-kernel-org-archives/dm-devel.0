Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A6529C7618E
	for <dm-devel@archiver.kernel.org>; Fri, 21 Apr 2023 22:25:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1682115910;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=WlIrjOCffnxluiK64sAyQK7IuDi8wA/TMvTUxGbym2Y=;
	b=OmIAiufpcPRwoyCfb9Aox4n3v0AhWrlqLGtSCjuOHXZuzwJeP2Db+QqQz92b9kfwf9LBcd
	lNUpG+TdOxUctsb6uqFr6cz6y7wK9s6qaHgKORFID4ilkk0kMOlYjx9Q8qdrGFkYg/FsDE
	SwaiYcBgiCBeqNcjm6T/h5ZdWO7cOCw=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-54-77gEsPCOMOqiVWuqu-aFIQ-1; Fri, 21 Apr 2023 18:25:08 -0400
X-MC-Unique: 77gEsPCOMOqiVWuqu-aFIQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CDDA729AA2DD;
	Fri, 21 Apr 2023 22:25:06 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 5438F2166B33;
	Fri, 21 Apr 2023 22:25:06 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 0D5551946A40;
	Fri, 21 Apr 2023 22:25:06 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id D521719466DF
 for <dm-devel@listman.corp.redhat.com>; Fri, 21 Apr 2023 22:25:03 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 86B61492B00; Fri, 21 Apr 2023 22:25:03 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 7EA8C492C3E
 for <dm-devel@redhat.com>; Fri, 21 Apr 2023 22:25:03 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 643CC3813F30
 for <dm-devel@redhat.com>; Fri, 21 Apr 2023 22:25:03 +0000 (UTC)
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com
 [209.85.214.173]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-554-QZ7JjAfmNCi5cpEQtTi9iA-1; Fri, 21 Apr 2023 18:25:01 -0400
X-MC-Unique: QZ7JjAfmNCi5cpEQtTi9iA-1
Received: by mail-pl1-f173.google.com with SMTP id
 d9443c01a7336-1a931e5a712so4389755ad.0
 for <dm-devel@redhat.com>; Fri, 21 Apr 2023 15:25:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1682115900; x=1684707900;
 h=content-transfer-encoding:in-reply-to:from:references:cc:to
 :content-language:subject:user-agent:mime-version:date:message-id
 :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=wtOk22wHsRTIJLakW5pQsLDvU50er+NeXN7SxTWy9qk=;
 b=LihbSz13IoBMOuQbPr2OjMyh3fxKNMyg2TReVrOw2NHDAAuBq+ObkG+2sxfYrUUxrY
 chdJSxvUOsa+PBXu+BHPp6YSMD3IGQxVx5N3SfpdD/ak2CSQMejlupx2/12+4napHcf2
 J2Sjc35vFsXr85DvuY3pVWh5RpZXDigSRlCOinO5HUmcRI7LDSDmlnSR5AM84+1WVtjx
 FukpJcXWpHfhxKvWiea1RPgCx1jlrucyx2O4V3TzyOY1r+5yCJwmMvnkakR9MKmTxLJS
 9soRo+oZgNSG0CSRDKqc5glH+vhCbwBVBBDODKlP3zVzvSn8DZEMZeL0o26STaU/Kwdy
 7T0A==
X-Gm-Message-State: AAQBX9dwyFWWVsWQ/ySklPJ+0Aa2PouXWDv4KoMDlj8AabxKaChkhY81
 q95/F3IKCTHK71XbCB3ItFoflg==
X-Google-Smtp-Source: AKy350ab5zsgqMFX9gmLPlFbJI6JNwFXd5UcuHSryHmhAdUudcIDmmGg6bERrDL3LQkvBwimuDuVEg==
X-Received: by 2002:a17:902:c94f:b0:1a2:1a52:14b3 with SMTP id
 i15-20020a170902c94f00b001a21a5214b3mr7699856pla.4.1682115900155; 
 Fri, 21 Apr 2023 15:25:00 -0700 (PDT)
Received: from [192.168.1.136] ([198.8.77.157])
 by smtp.gmail.com with ESMTPSA id
 jn15-20020a170903050f00b001a945e7147asm1657335plb.231.2023.04.21.15.24.58
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Fri, 21 Apr 2023 15:24:59 -0700 (PDT)
Message-ID: <47688c1d-9cf1-3e08-1f1d-a051b25d010e@kernel.dk>
Date: Fri, 21 Apr 2023 16:24:57 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
To: Luis Chamberlain <mcgrof@kernel.org>, Matthew Wilcox <willy@infradead.org>
References: <20230421195807.2804512-1-mcgrof@kernel.org>
 <20230421195807.2804512-4-mcgrof@kernel.org>
 <ZELuiBNNHTk4EdxH@casper.infradead.org>
 <ZEMH9h/cd9Cp1t+X@bombadil.infradead.org>
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <ZEMH9h/cd9Cp1t+X@bombadil.infradead.org>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
Subject: Re: [dm-devel] [PATCH 3/5] iomap: simplify iomap_init() with
 PAGE_SECTORS
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
Cc: p.raghav@samsung.com, linux-block@vger.kernel.org,
 linux-kernel@vger.kernel.org, minchan@kernel.org, da.gomez@samsung.com,
 djwong@kernel.org, snitzer@kernel.org, philipp.reisner@linbit.com,
 kbusch@kernel.org, patches@lists.linux.dev, hch@infradead.org,
 christoph.boehmwalder@linbit.com, dm-devel@redhat.com,
 linux-fsdevel@vger.kernel.org, lars.ellenberg@linbit.com,
 linux-xfs@vger.kernel.org, senozhatsky@chromium.org, linux-mm@kvack.org,
 agk@redhat.com, drbd-dev@lists.linbit.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.dk
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

T24gNC8yMS8yMyA0OjAy4oCvUE0sIEx1aXMgQ2hhbWJlcmxhaW4gd3JvdGU6Cj4gT24gRnJpLCBB
cHIgMjEsIDIwMjMgYXQgMDk6MTQ6MDBQTSArMDEwMCwgTWF0dGhldyBXaWxjb3ggd3JvdGU6Cj4+
IE9uIEZyaSwgQXByIDIxLCAyMDIzIGF0IDEyOjU4OjA1UE0gLTA3MDAsIEx1aXMgQ2hhbWJlcmxh
aW4gd3JvdGU6Cj4+PiBKdXN0IHVzZSB0aGUgUEFHRV9TRUNUT1JTIGdlbmVyaWMgZGVmaW5lLiBU
aGlzIHByb2R1Y2VzIG5vIGZ1bmN0aW9uYWwKPj4+IGNoYW5nZXMuIFdoaWxlIGF0IGl0IHVzZSBs
ZWZ0IHNoaWZ0IHRvIHNpbXBsaWZ5IHRoaXMgZXZlbiBmdXJ0aGVyLgo+Pgo+PiBIb3cgaXMgRk9P
IDw8IDIgc2ltcGxlciB0aGFuIEZPTyAqIDQ/Cj4+Cj4+PiAtCXJldHVybiBiaW9zZXRfaW5pdCgm
aW9tYXBfaW9lbmRfYmlvc2V0LCA0ICogKFBBR0VfU0laRSAvIFNFQ1RPUl9TSVpFKSwKPj4+ICsJ
cmV0dXJuIGJpb3NldF9pbml0KCZpb21hcF9pb2VuZF9iaW9zZXQsIFBBR0VfU0VDVE9SUyA8PCAy
LAo+IAo+IFdlIGNvdWxkIGp1c3QgZG86Cj4gCj4gCj4gLQlyZXR1cm4gYmlvc2V0X2luaXQoJmlv
bWFwX2lvZW5kX2Jpb3NldCwgNCAqIChQQUdFX1NJWkUgLyBTRUNUT1JfU0laRSksCj4gKwlyZXR1
cm4gYmlvc2V0X2luaXQoJmlvbWFwX2lvZW5kX2Jpb3NldCwgNCAqIFBBR0VfU0VDVE9SUywKPiAK
PiBUaGUgc2hpZnQganVzdCBzZWVtZWQgb3B0aW1hbCBpZiB3ZSdyZSBqdXN0IGdvaW5nIHRvIGNo
YW5nZSBpdC4KCkl0J3MgZ29pbmcgdG8gZ2VuZXJhdGUgdGhlIHNhbWUgY29kZSwgYnV0IHRoZSBt
dWx0aXBsaWNhdGlvbiBpcyBhcmd1YWJseQplYXNpZXIgdG8gcmVhZCAob3IgaGFyZGVyIHRvIG1p
c3JlYWQpLgoKLS0gCkplbnMgQXhib2UKCgotLQpkbS1kZXZlbCBtYWlsaW5nIGxpc3QKZG0tZGV2
ZWxAcmVkaGF0LmNvbQpodHRwczovL2xpc3RtYW4ucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZv
L2RtLWRldmVsCg==

