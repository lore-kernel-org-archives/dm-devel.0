Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 67966C433F5
	for <dm-devel@archiver.kernel.org>; Fri, 20 May 2022 07:02:03 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-142-o4X34IWqNfWC5blXPPjNTg-1; Fri, 20 May 2022 03:01:58 -0400
X-MC-Unique: o4X34IWqNfWC5blXPPjNTg-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D96603C02196;
	Fri, 20 May 2022 07:01:56 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id C6C65492C3B;
	Fri, 20 May 2022 07:01:56 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 877C3194EBAA;
	Fri, 20 May 2022 07:01:55 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 7408B194705A
 for <dm-devel@listman.corp.redhat.com>; Thu, 19 May 2022 15:25:51 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 550632166B26; Thu, 19 May 2022 15:25:51 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 509D02166B25
 for <dm-devel@redhat.com>; Thu, 19 May 2022 15:25:51 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 31A493C025B5
 for <dm-devel@redhat.com>; Thu, 19 May 2022 15:25:51 +0000 (UTC)
Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com
 [209.85.208.48]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-605-LZNnfgCWNp2QBNDyumoi9Q-1; Thu, 19 May 2022 11:25:49 -0400
X-MC-Unique: LZNnfgCWNp2QBNDyumoi9Q-1
Received: by mail-ed1-f48.google.com with SMTP id h11so6270434eda.8
 for <dm-devel@redhat.com>; Thu, 19 May 2022 08:25:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:content-transfer-encoding:from:mime-version
 :subject:date:message-id:references:cc:in-reply-to:to;
 bh=QTIQet1MwfaPkuVkZ6VAO4F74yKlRL1Luu8IUjHxYMk=;
 b=JR8NdFYPyS8sMs+8OI0qGSjOgtCjmnV/GTBTXs4hL61KfuJ+JyHUkloR9BCWCMrcMP
 ytnIqtf/kx313JmZaNIwAbRqu5BzgbNmznd5wG348NqzIQln0ZD7XqemGUWQ7PZH27aa
 fkfl43757lX7xTJWgshwPZU4oWzxPM0iMhFo/8y9E4hhjLmEM5NucsLW+ZOLpdbfOafy
 O/4VhEosd+KDD4mk5qQvo+/adjum7dKU8L8FKxsVGbdqvJFVkZAUXVgGcUz/j5N1e5qi
 w0Wxw1vZXe5kY2cNjyYSEkL4PUIx0gsDLswS7cDjanSKTfTcrnN7/wDjOfgXdoK6llLl
 tvZA==
X-Gm-Message-State: AOAM533INw/uO3Db+omn1vyX1itJ/Kawdd6c2TUiaqOA6ySRjGyZeYmo
 WkGOn0t+Hp75/VgVKxxwAZSdxQ==
X-Google-Smtp-Source: ABdhPJxqZsGrBLw1XfZ4Nx2omW80JrXR4I67dHiPrXDO/V/6B5AKsOnb4m6w+WedzFlbburvxrD0kQ==
X-Received: by 2002:a05:6402:2741:b0:41f:69dc:9bcd with SMTP id
 z1-20020a056402274100b0041f69dc9bcdmr5928160edd.239.1652973947883; 
 Thu, 19 May 2022 08:25:47 -0700 (PDT)
Received: from smtpclient.apple (5.186.196.163.dhcp.fibianet.dk.
 [5.186.196.163]) by smtp.gmail.com with ESMTPSA id
 ca7-20020aa7cd67000000b0042617ba63absm2892556edb.53.2022.05.19.08.25.47
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Thu, 19 May 2022 08:25:47 -0700 (PDT)
From: =?utf-8?Q?Javier_Gonz=C3=A1lez?= <javier@javigon.com>
Mime-Version: 1.0 (1.0)
Date: Thu, 19 May 2022 17:25:46 +0200
Message-Id: <40FFE5A8-35B9-4707-8D8C-A24254EB9A9B@javigon.com>
References: <20220518080020.GA3697@lst.de>
In-Reply-To: <20220518080020.GA3697@lst.de>
To: Christoph Hellwig <hch@lst.de>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-Mailman-Approved-At: Fri, 20 May 2022 07:01:49 +0000
Subject: Re: [dm-devel] [PATCH v4 00/13] support non power of 2 zoned devices
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
Cc: Pankaj Raghav <p.raghav@samsung.com>, axboe@kernel.dk, pankydev8@gmail.com,
 gost.dev@samsung.com, damien.lemoal@opensource.wdc.com,
 jiangbo.365@bytedance.com, linux-nvme@lists.infradead.org,
 linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, dm-devel@redhat.com, dsterba@suse.com,
 =?utf-8?Q?Javier_Gonz=C3=A1lez?= <javier.gonz@samsung.com>,
 linux-btrfs@vger.kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

Cj4gT24gMTggTWF5IDIwMjIsIGF0IDEwLjE2LCBDaHJpc3RvcGggSGVsbHdpZyA8aGNoQGxzdC5k
ZT4gd3JvdGU6Cj4gCj4g77u/T24gVHVlLCBNYXkgMTcsIDIwMjIgYXQgMTE6MTg6MzRBTSArMDIw
MCwgSmF2aWVyIEdvbnrDoWxleiB3cm90ZToKPj4gRG9lcyB0aGUgYWJvdmUgaGVscCB5b3UgcmVj
b25zaWRlcmluZyB5b3VyIGludGVyZXN0IGluIHN1cHBvcnRpbmcgdGhpcwo+PiBpbiBOVk1lPwo+
IAo+IFZlcnkgbGl0dGxlLiAgSXQganVzdCBzZWVtcyBsaWtlIGEgcmVhbGx5IGJhZCBpZGVhLgoK
SSB1bmRlcnN0YW5kIHlvdSBkb27igJl0IGxpa2UgdGhpcywgYnV0IEkgc3RpbGwgaG9wZSB5b3Ug
c2VlIHZhbHVlIGluIHN1cHBvcnRpbmcgaXQuIFdlIGFyZSBnZXR0aW5nIGNsb3NlIHRvIGEgdmVy
eSBtaW5pbWFsIHBhdGNoc2V0LCB3aGljaCBpcyBhbHNvIGhlbHBpbmcgdG8gZml4IGJ1Z3MgaW4g
dGhlIHpvbmVkIHN0YWNrLgoKSWYgeW91IHRha2UgYSBsb29rIGF0IHRoZSBsYXN0IHZlcnNpb24g
YWJzIGdpdmUgc29tZSBmZWVkYmFjaywgSeKAmW0gc3VyZSB3ZSBjYW4gZW5kIHVwIHdpdGggYSBn
b29kIHNvbHV0aW9uLiAKCkNhbiB5b3UgaGVscD8KCi0tCmRtLWRldmVsIG1haWxpbmcgbGlzdApk
bS1kZXZlbEByZWRoYXQuY29tCmh0dHBzOi8vbGlzdG1hbi5yZWRoYXQuY29tL21haWxtYW4vbGlz
dGluZm8vZG0tZGV2ZWwK

