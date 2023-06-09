Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 27BF7C7EE25
	for <dm-devel@archiver.kernel.org>; Fri,  9 Jun 2023 04:45:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686285924;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=Tpk4I7TWLxlvD+ZaAhGD/nA7gPYT81DJ8FcVosPKlq4=;
	b=R/UTsbb3FWqouk8na6fAtW1XCqZA+8HKFrrwNyhfIehOOQ6ccr7VazgTO6MDBYSgpP1QLH
	cz2JpynSzNsA7qkpn76GxAxvVbdqV/460Nctj7cUQnbeGXTq4W2uXpBmXxAYGwd/Wu/srF
	CQfB6ftJ44hhNTCUOZtDvNu552CsIuc=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-516-iyDTVBG6M0CCVA53GbWQHw-1; Fri, 09 Jun 2023 00:45:20 -0400
X-MC-Unique: iyDTVBG6M0CCVA53GbWQHw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C8A9D296A60E;
	Fri,  9 Jun 2023 04:45:18 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 1AAF3C16044;
	Fri,  9 Jun 2023 04:45:13 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 984FC19451C0;
	Fri,  9 Jun 2023 04:45:13 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 41D44194658C
 for <dm-devel@listman.corp.redhat.com>; Fri,  9 Jun 2023 04:45:12 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id D033F40CFD47; Fri,  9 Jun 2023 04:45:11 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id C83C140CFD46
 for <dm-devel@redhat.com>; Fri,  9 Jun 2023 04:45:11 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-2.mimecast.com
 [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A8C58185A78F
 for <dm-devel@redhat.com>; Fri,  9 Jun 2023 04:45:11 +0000 (UTC)
Received: from dfw.source.kernel.org (dfw.source.kernel.org
 [139.178.84.217]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-527-8HqT6rZHMJqEr223dbnjWg-1; Fri, 09 Jun 2023 00:45:09 -0400
X-MC-Unique: 8HqT6rZHMJqEr223dbnjWg-1
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id F3CFC60C89;
 Fri,  9 Jun 2023 04:45:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F108C433D2;
 Fri,  9 Jun 2023 04:45:08 +0000 (UTC)
Received: by mail-lf1-f51.google.com with SMTP id
 2adb3069b0e04-4f658a17aa4so616374e87.0; 
 Thu, 08 Jun 2023 21:45:08 -0700 (PDT)
X-Gm-Message-State: AC+VfDxIIyyfFOynEtdZA3XLjxkCzfQ15XB162lOhijAehLeJPVbE3UR
 5scvmkAwBwq75p85/ZIUxrti9sK27Z9P5m9s1ZA=
X-Google-Smtp-Source: ACHHUZ6HaFF03H53+7vGQJhIsVAaRL+rCqTGiTnj3esTnBlt6KHYOgFQdTsKM9JhvmvBMcUu7+cv00YuNa2U0huGCE0=
X-Received: by 2002:ac2:5b0d:0:b0:4f4:b3a6:4135 with SMTP id
 v13-20020ac25b0d000000b004f4b3a64135mr143022lfn.55.1686285906337; Thu, 08 Jun
 2023 21:45:06 -0700 (PDT)
MIME-Version: 1.0
References: <20230529132037.2124527-1-yukuai1@huaweicloud.com>
 <0a38ddc1-b47e-04e8-dbf5-25afcd13fff4@huaweicloud.com>
In-Reply-To: <0a38ddc1-b47e-04e8-dbf5-25afcd13fff4@huaweicloud.com>
From: Song Liu <song@kernel.org>
Date: Thu, 8 Jun 2023 21:44:53 -0700
X-Gmail-Original-Message-ID: <CAPhsuW65AFL=vbcubantu=O-6uVVeDHrO73Oun07DqnYHsv8CA@mail.gmail.com>
Message-ID: <CAPhsuW65AFL=vbcubantu=O-6uVVeDHrO73Oun07DqnYHsv8CA@mail.gmail.com>
To: Yu Kuai <yukuai1@huaweicloud.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
Subject: Re: [dm-devel] [PATCH -next v2 0/6] md: fix that
 MD_RECOVERY_RUNNING can be cleared while sync_thread is still running
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
Cc: yi.zhang@huawei.com, yangerkun@huawei.com, snitzer@kernel.org,
 linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, dm-devel@redhat.com,
 guoqing.jiang@linux.dev, "yukuai \(C\)" <yukuai3@huawei.com>, agk@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

T24gV2VkLCBKdW4gNywgMjAyMyBhdCA3OjQx4oCvUE0gWXUgS3VhaSA8eXVrdWFpMUBodWF3ZWlj
bG91ZC5jb20+IHdyb3RlOgo+Cj4gSGksCj4KPiDlnKggMjAyMy8wNS8yOSAyMToyMCwgWXUgS3Vh
aSDlhpnpgZM6Cj4gPiBGcm9tOiBZdSBLdWFpIDx5dWt1YWkzQGh1YXdlaS5jb20+Cj4gPgo+ID4g
Q2hhbmdlcyBpbiB2MjoKPiA+ICAgLSByZWJhc2UgZm9yIHRoZSBsYXRlc3QgbWQtbmV4dAo+ID4K
PiA+IFBhdGNoIDEgcmV2ZXJ0IHRoZSBjb21taXQgYmVjYXVzZSBpdCB3aWxsIGNhdXNlIE1EX1JF
Q09WRVJZX1JVTk5JTkcgdG8gYmUKPiA+IGNsZWFyZWQgd2hpbGUgc3luY190aHJlYWQgaXMgc3Rp
bGwgcnVubmluZy4gVGhlIGRlYWRsb2NrIHRoaXMgcGF0Y2ggdHJpZXMKPiA+IHRvIGZpeCB3aWxs
IGJlIGZpeGVkIGJ5IHBhdGNoIDItNS4KPiA+Cj4gPiBQYXRjaCA2IGVuaGFuY2UgY2hlY2tpbmcg
dG8gcHJldmVudCBNRF9SRUNPVkVSWV9SVU5OSU5HIHRvIGJlIGNsZWFyZWQKPiA+IHdoaWxlIHN5
bmNfdGhyZWFkIGlzIHN0aWxsIHJ1bm5pbmcuCj4KPiBBbnkgc3VnZ2VzdGlvbnMgb24gdGhpcyBw
YXRjaHNldD8gSSBhbHJlYWR5IHNlbnQgcmVncmVzc2lvbiB0ZXN0Cj4gZm9yIHRoZSBkZWFkbG9j
ayBwcm9ibGVtIGZvciBib3RoIHJhaWQxMCBhbmQgcmFpZDQ1Ni4KClNvcnJ5IGZvciB0aGUgZGVs
YXkuIEkgd2lsbCBsb29rIGludG8gdGhpcyBzb29uLgoKVGhhbmtzLApTb25nCgotLQpkbS1kZXZl
bCBtYWlsaW5nIGxpc3QKZG0tZGV2ZWxAcmVkaGF0LmNvbQpodHRwczovL2xpc3RtYW4ucmVkaGF0
LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRldmVsCg==

