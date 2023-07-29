Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0B8DDC001DC
	for <dm-devel@archiver.kernel.org>; Sat, 29 Jul 2023 10:40:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1690627215;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=KqThqixEL3F1MxMSrL6AZGwwxEN4tMlajuL2GrbuojI=;
	b=bTcMRwKGHIeFfJFE9aBElQxN/gmZZgm852eS1HPPVgNX0iGEtl0P5DDYGfUrbWJ8OjW0bR
	Dk9NHE4lWIrIi7NFgnCi8zLsDlYcMLEW6j6UWm9BhpZPgtL02CCsW1wqZM6q5bCyD8QTNe
	nbDn+lug7s504mo7cEjYcBimy9UHoYs=
Received: from mimecast-mx02.redhat.com (66.187.233.73 [66.187.233.73]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-176-X7pmAefNOpePb9i9t8JH3w-1; Sat, 29 Jul 2023 06:40:11 -0400
X-MC-Unique: X7pmAefNOpePb9i9t8JH3w-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 829363806702;
	Sat, 29 Jul 2023 10:40:09 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 6C247C57964;
	Sat, 29 Jul 2023 10:40:04 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 32C441946A6A;
	Sat, 29 Jul 2023 10:40:04 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 57ADD194658C
 for <dm-devel@listman.corp.redhat.com>; Sat, 29 Jul 2023 10:40:03 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id EA2D2400F45; Sat, 29 Jul 2023 10:40:02 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id E2750400F36
 for <dm-devel@redhat.com>; Sat, 29 Jul 2023 10:40:02 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C361E1C05122
 for <dm-devel@redhat.com>; Sat, 29 Jul 2023 10:40:02 +0000 (UTC)
Received: from dfw.source.kernel.org (dfw.source.kernel.org
 [139.178.84.217]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-284-YO9R40c0NyCgcA904UEWgg-1; Sat, 29 Jul 2023 06:40:01 -0400
X-MC-Unique: YO9R40c0NyCgcA904UEWgg-1
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature RSA-PSS (2048 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 3F56A60B7A;
 Sat, 29 Jul 2023 10:33:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98B2AC433C7;
 Sat, 29 Jul 2023 10:33:04 +0000 (UTC)
Received: by mail-lf1-f44.google.com with SMTP id
 2adb3069b0e04-4fe1c285690so3670598e87.3; 
 Sat, 29 Jul 2023 03:33:04 -0700 (PDT)
X-Gm-Message-State: ABy/qLY7UZ2/UeWC1hyHQYv1KtC9KKIYeX2rIQLmRaha7w4brxli1WKQ
 qY+153zHeVfsv3VY1ClRUo1o4bVFwwKgUIRFPmQ=
X-Google-Smtp-Source: APBJJlGeYb8hNy/oFr34uGXpmibjsARwkGDXhWuL5vf6q6/6EGpONGXt7KE18g1UWMPfQfNjEFd/fv4w/7as5tTqYDA=
X-Received: by 2002:a05:6512:2391:b0:4f8:6e6e:4100 with SMTP id
 c17-20020a056512239100b004f86e6e4100mr4600338lfv.52.1690626782624; Sat, 29
 Jul 2023 03:33:02 -0700 (PDT)
MIME-Version: 1.0
References: <20230708092153.1418570-1-yukuai1@huaweicloud.com>
In-Reply-To: <20230708092153.1418570-1-yukuai1@huaweicloud.com>
From: Song Liu <song@kernel.org>
Date: Sat, 29 Jul 2023 18:32:49 +0800
X-Gmail-Original-Message-ID: <CAPhsuW5cBipY=JT8nRvJptyU9uePVYgqQ5ZaTtL7KnNO97K9BQ@mail.gmail.com>
Message-ID: <CAPhsuW5cBipY=JT8nRvJptyU9uePVYgqQ5ZaTtL7KnNO97K9BQ@mail.gmail.com>
To: Yu Kuai <yukuai1@huaweicloud.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
Subject: Re: [dm-devel] [PATCH -next v2 0/3] dm-raid: minor fixes
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
Cc: pmenzel@molgen.mpg.de, yi.zhang@huawei.com, heinzm@redhat.com,
 yangerkun@huawei.com, snitzer@kernel.org, linux-kernel@vger.kernel.org,
 linux-raid@vger.kernel.org, dm-devel@redhat.com, yukuai3@huawei.com,
 agk@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

T24gU2F0LCBKdWwgOCwgMjAyMyBhdCA1OjIz4oCvUE0gWXUgS3VhaSA8eXVrdWFpMUBodWF3ZWlj
bG91ZC5jb20+IHdyb3RlOgo+Cj4gRnJvbTogWXUgS3VhaSA8eXVrdWFpM0BodWF3ZWkuY29tPgo+
Cj4gQ2hhbmdlcyBpbiB2MjoKPiAgLSBpbXByb3ZlIHRpdGxlIGFuZCBjb21taXQgbWVzc2FnZSBm
b3IgcGF0Y2ggMgo+Cj4gVGhpcyBwYXRjaHNldCBmaXggdHdvIHN0cmFpZ2h0Zm9yd2FyZCBhbmQg
ZWFzeSBwcm9ibGVtcyB0aGF0IGlzIGZvdW5kIGJ5Cj4gY29kZSByZXZpZXcsIHBsZWFzZSBjb25z
aWRlciBpdCBmb3IgdGhlIG5leHQgbWVyZ2Ugd2luZG93Lgo+Cj4gWXUgS3VhaSAoMyk6Cj4gICBt
ZC9kbS1yYWlkOiBmaXggdGhhdCAncmVjb25maWdfbXV0ZXgnIGlzIG5vdCByZWxlYXNlZCBmcm9t
IGVycm9yIHBhdGgKPiAgICAgaW4gcmFpZF9jdHIoKQo+ICAgbWQvZG0tcmFpZDogY2xlYW4gdXAg
bXVsdGlwbGUgZXF1aXZhbGVudCBnb3RvIHRhZ3MgZnJvbSByYWlkX2N0cigpCj4gICBtZC9kbS1y
YWlkOiBwcm90ZWN0IG1kX3N0b3AoKSB3aXRoICdyZWNvbmZpZ19tdXRleCcKCkZvciB0aGUgc2V0
OgoKUmV2aWV3ZWQtYnk6IFNvbmcgTGl1IDxzb25nQGtlcm5lbC5vcmc+Cgo+Cj4gIGRyaXZlcnMv
bWQvZG0tcmFpZC5jIHwgMjAgKysrKysrKysrLS0tLS0tLS0tLS0KPiAgZHJpdmVycy9tZC9tZC5j
ICAgICAgfCAgMiArKwo+ICAyIGZpbGVzIGNoYW5nZWQsIDExIGluc2VydGlvbnMoKyksIDExIGRl
bGV0aW9ucygtKQo+Cj4gLS0KPiAyLjM5LjIKPgoKLS0KZG0tZGV2ZWwgbWFpbGluZyBsaXN0CmRt
LWRldmVsQHJlZGhhdC5jb20KaHR0cHM6Ly9saXN0bWFuLnJlZGhhdC5jb20vbWFpbG1hbi9saXN0
aW5mby9kbS1kZXZlbAo=

