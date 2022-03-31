Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 63254C433F5
	for <dm-devel@archiver.kernel.org>; Mon,  4 Apr 2022 06:48:41 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-56-cLoqSJMPO1mK9xxDqTplzA-1; Mon, 04 Apr 2022 02:48:39 -0400
X-MC-Unique: cLoqSJMPO1mK9xxDqTplzA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4BBAD1C05EA7;
	Mon,  4 Apr 2022 06:48:37 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id EF02240FA467;
	Mon,  4 Apr 2022 06:48:36 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 9D75A19451EC;
	Mon,  4 Apr 2022 06:48:35 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id B261419451F3
 for <dm-devel@listman.corp.redhat.com>; Thu, 31 Mar 2022 21:27:23 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 256AA5DF25F; Thu, 31 Mar 2022 21:27:23 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 211265AF708
 for <dm-devel@redhat.com>; Thu, 31 Mar 2022 21:27:23 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0333D185A79C
 for <dm-devel@redhat.com>; Thu, 31 Mar 2022 21:27:23 +0000 (UTC)
Received: from mailout1.w1.samsung.com (mailout1.w1.samsung.com
 [210.118.77.11]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-321-UsGNVTQkMPuVcNCEf73cmw-1; Thu, 31 Mar 2022 17:27:21 -0400
X-MC-Unique: UsGNVTQkMPuVcNCEf73cmw-1
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
 by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id
 20220331211806euoutp01c1cf6f7edc9760018106bfa0a5a0b00a~hk9YWhSC-1194011940euoutp013
 for <dm-devel@redhat.com>; Thu, 31 Mar 2022 21:18:06 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com
 20220331211806euoutp01c1cf6f7edc9760018106bfa0a5a0b00a~hk9YWhSC-1194011940euoutp013
Received: from eusmges2new.samsung.com (unknown [203.254.199.244]) by
 eucas1p2.samsung.com (KnoxPortal) with ESMTP id
 20220331211805eucas1p2a8a5006c03c42a203bd56896dafbf5b4~hk9Xbop573192531925eucas1p2Z;
 Thu, 31 Mar 2022 21:18:05 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
 eusmges2new.samsung.com (EUCPMTA) with SMTP id ED.B2.09887.D8A16426; Thu, 31
 Mar 2022 22:18:05 +0100 (BST)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
 eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
 20220331211804eucas1p28da21f2dfd57aa490abffb8f87417f42~hk9WlERhz0832008320eucas1p2F;
 Thu, 31 Mar 2022 21:18:04 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
 eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
 20220331211804eusmtrp20190ecaa189b027a004cf7cf2b9bcc1b~hk9WkFQiu0959209592eusmtrp2E;
 Thu, 31 Mar 2022 21:18:04 +0000 (GMT)
X-AuditID: cbfec7f4-471ff7000000269f-d8-62461a8d2ebf
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
 eusmgms2.samsung.com (EUCPMTA) with SMTP id 7F.43.09404.C8A16426; Thu, 31
 Mar 2022 22:18:04 +0100 (BST)
Received: from [106.210.134.192] (unknown [106.210.134.192]) by
 eusmtip1.samsung.com (KnoxPortal) with ESMTPA id
 20220331211803eusmtip1a9ccf738d9b7d324aba71fa048d24a9b~hk9VwfLgt1478114781eusmtip1M;
 Thu, 31 Mar 2022 21:18:03 +0000 (GMT)
Message-ID: <6696cc6a-3e3f-035e-5b8c-05ea361383f3@samsung.com>
Date: Thu, 31 Mar 2022 23:18:03 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0)
 Gecko/20100101 Thunderbird/91.7.0
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
From: Marek Szyprowski <m.szyprowski@samsung.com>
In-Reply-To: <20220308061551.737853-5-hch@lst.de>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrDKsWRmVeSWpSXmKPExsWy7djP87q9Um5JBg838VmsvtvPZjG98Ty7
 xd53s1ktLvxoZLJYufook8Wfh4YWx7ZdY7LYe0vb4tLjFewWl3fNYbNon7+L0WL58X9MFkd7
 NrNZtG38ymhxfPlfNovWpW+ZHAQ8Lp8t9di0qpPNY/fNBjaPj09vsXi833eVzWPK1+fMHuu3
 XGXx2Hy62mPC5o2sHp83yQVwRXHZpKTmZJalFunbJXBlbJ49m7WgRadi6/J57A2Me1W6GDk5
 JARMJJ7M3MEKYgsJrGCU2PvcuIuRC8j+wigx7/MeRgjnM6PE15P/WGE6Dt/6wwaRWM4o8X3P
 ShYI5yOjRHfDIaAMBwevgJ3E5WteIA0sAqoSbbO/MYPYvAKCEidnPmEBsUUFkiRWb18NVi4s
 ECAxb7cVSJhZQFzi1pP5TCC2iICDxOwNS8F2MQucZ5bY/OUOI0iCTcBQouttFxuIzQlk93y4
 wQbRLC/RvHU2M0iDhMBuTom5R98wQ1ztIvF+51yoD4QlXh3fwg5hy0j83wmyjQPIzpf4O8MY
 Ilwhce31GqhWa4k7536B3cksoCmxfpc+RNhR4mnjVjaITj6JG28FIS7gk5i0bTozRJhXoqNN
 CKJaTWLW8XVwOw9euMQ8gVFpFlKYzELy/Cwkv8xC2LuAkWUVo3hqaXFuemqxUV5quV5xYm5x
 aV66XnJ+7iZGYAI8/e/4lx2My1991DvEyMTBeIhRgoNZSYT3aqxrkhBvSmJlVWpRfnxRaU5q
 8SFGaQ4WJXHe5MwNiUIC6YklqdmpqQWpRTBZJg5OqQam9Iw27xM7eus6sqM4NSetOn73XsrL
 jPMnXyb/25a38anntEliL28rGemdCC07nuipf7QuN+/oBW22L9+eTZZfcG5mTrnk7Q72WnO+
 mUKFm+PTBCeFT1KTf74wL9moLzp9cSzn5QoLltvLP6hfttnq/alz0tZvTAoy9ZPEpy04fOpk
 nV6O3SPPe4zXdky93GDzZnbIs5xFN047H+XrnbBIzE1S8kzJqtMfzni+qbK6XSi5eqbWyQTj
 X5IrpHYqXOdjNPokXrY1jeH5h2L74oNOWo5uyneOG6952ts6M80pIFdtZVvN7x+v/7ELZyqV
 KvM9u8k44+XZYvU98ydVXdjHf/SzgKKv8LkIZck1n6WLlViKMxINtZiLihMBeBXxdu8DAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrIIsWRmVeSWpSXmKPExsVy+t/xu7o9Um5JBic+C1usvtvPZjG98Ty7
 xd53s1ktLvxoZLJYufook8Wfh4YWx7ZdY7LYe0vb4tLjFewWl3fNYbNon7+L0WL58X9MFkd7
 NrNZtG38ymhxfPlfNovWpW+ZHAQ8Lp8t9di0qpPNY/fNBjaPj09vsXi833eVzWPK1+fMHuu3
 XGXx2Hy62mPC5o2sHp83yQVwRenZFOWXlqQqZOQXl9gqRRtaGOkZWlroGZlY6hkam8daGZkq
 6dvZpKTmZJalFunbJehlbJ49m7WgRadi6/J57A2Me1W6GDk5JARMJA7f+sPWxcjFISSwlFHi
 5IedbBAJGYmT0xpYIWxhiT/XusDiQgLvGSUO3HLqYuTg4BWwk7h8zQskzCKgKtE2+xsziM0r
 IChxcuYTFhBbVCBJ4lJXOyOILSzgJ3Hh4gawMcwC4hK3nsxnArFFBBwkZm9YCnYDs8BFZon3
 h6czQuwKl7h3pQlsKJuAoUTXW4gbOIHsng83oAaZSXRt7WKEsOUlmrfOZp7AKDQLyR2zkOyb
 haRlFpKWBYwsqxhFUkuLc9Nzi430ihNzi0vz0vWS83M3MQLjftuxn1t2MK589VHvECMTB+Mh
 RgkOZiUR3quxrklCvCmJlVWpRfnxRaU5qcWHGE2BgTGRWUo0OR+YePJK4g3NDEwNTcwsDUwt
 zYyVxHk9CzoShQTSE0tSs1NTC1KLYPqYODilGpg04u5N1BdXFt3TNvtertcEwbUOK+pNbVMC
 0yqWC3NGHL6966WrV+5xzZjP55NOVL94uu/z3qqNTW36Ho7qbw15BLI+aAUd5d3MF6U0Jf10
 dOnCFx/XGnBld5xX57Dpa63Zmtxh4OjAVvLtxdmZt/ZJehVfOiZ2ZQ7P46oNwQ+iCzrclMvC
 tjdpTfrh6Thd9dS9BLs3GnxTF1T2fF0UaXMlrGqJq8ipS8/teWdEFh/v1fX21Mq7lqgipa35
 hVHyjf7D9SEfjtWubUxJrXohsy5CaavqvuOZ8qa/lzRf//jxlfZMhm23nU/5as3c5NO+t3AV
 87slnskMM2TlfvcdFQn2LnwWfz8/OJbrntDORCWW4oxEQy3mouJEAFsaRTyEAwAA
X-CMS-MailID: 20220331211804eucas1p28da21f2dfd57aa490abffb8f87417f42
X-Msg-Generator: CA
X-RootMTR: 20220331211804eucas1p28da21f2dfd57aa490abffb8f87417f42
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20220331211804eucas1p28da21f2dfd57aa490abffb8f87417f42
References: <20220308061551.737853-1-hch@lst.de>
 <20220308061551.737853-5-hch@lst.de>
 <CGME20220331211804eucas1p28da21f2dfd57aa490abffb8f87417f42@eucas1p2.samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
X-Mailman-Approved-At: Mon, 04 Apr 2022 06:48:34 +0000
Subject: Re: [dm-devel] [PATCH 4/5] block: turn bio_kmalloc into a simple
 kmalloc wrapper
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
Cc: linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org,
 Mike Snitzer <snitzer@redhat.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 linux-kernel@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>,
 Coly Li <colyli@suse.de>, linux-block@vger.kernel.org,
 Song Liu <song@kernel.org>, dm-devel@redhat.com, target-devel@vger.kernel.org,
 David Sterba <dsterba@suse.com>, Phillip Lougher <phillip@squashfs.org.uk>,
 linux-btrfs@vger.kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

SGkgQ2hyaXN0b3BoLAoKT24gMDguMDMuMjAyMiAwNzoxNSwgQ2hyaXN0b3BoIEhlbGx3aWcgd3Jv
dGU6Cj4gUmVtb3ZlIHRoZSBtYWdpYyBhdXRvZnJlZSBzZW1hbnRpY3MgYW5kIHJlcXVpcmUgdGhl
IGNhbGxlcnMgdG8gZXhwbGljaXRseQo+IGNhbGwgYmlvX2luaXQgdG8gaW5pdGlhbGl6ZSB0aGUg
YmlvLgo+Cj4gVGhpcyBhbGxvd3MgYmlvX2ZyZWUgdG8gY2F0Y2ggYWNjaWRlbnRhbCBiaW9fcHV0
IGNhbGxzIG9uIGJpb19pbml0KCllZAo+IGJpb3MgYXMgd2VsbC4KPgo+IFNpZ25lZC1vZmYtYnk6
IENocmlzdG9waCBIZWxsd2lnIDxoY2hAbHN0LmRlPgoKVGhpcyBwYXRjaCwgd2hpY2ggbGFuZGVk
IGluIHRvZGF5J3MgbmV4dC0yMDIyMDMzMSBhcyBjb21taXQgNTdjNDdiNDJmNDU0IAooImJsb2Nr
OiB0dXJuIGJpb19rbWFsbG9jIGludG8gYSBzaW1wbGUga21hbGxvYyB3cmFwcGVyIiksIGJyZWFr
cyBiYWRseSAKYWxsIG15IHRlc3Qgc3lzdGVtcywgd2hpY2ggdXNlIHNxdWFzaGZzIGluaXRyZDoK
ClJBTURJU0s6IHNxdWFzaGZzIGZpbGVzeXN0ZW0gZm91bmQgYXQgYmxvY2sgMApSQU1ESVNLOiBM
b2FkaW5nIDI0ODlLaUIgWzEgZGlza10gaW50byByYW0gZGlzay4uLiBkb25lLgp1c2luZyBkZXBy
ZWNhdGVkIGluaXRyZCBzdXBwb3J0LCB3aWxsIGJlIHJlbW92ZWQgaW4gMjAyMS4KLS0tLS0tLS0t
LS0tWyBjdXQgaGVyZSBdLS0tLS0tLS0tLS0tCldBUk5JTkc6IENQVTogNCBQSUQ6IDEgYXQgYmxv
Y2svYmlvLmM6MjI5IGJpb19mcmVlKzB4NmMvMHg3MApNb2R1bGVzIGxpbmtlZCBpbjoKQ1BVOiA0
IFBJRDogMSBDb21tOiBzd2FwcGVyLzAgTm90IHRhaW50ZWQgNS4xNy4wLW5leHQtMjAyMjAzMzEg
IzQ3NjcKSGFyZHdhcmUgbmFtZTogU2Ftc3VuZyBFeHlub3MgKEZsYXR0ZW5lZCBEZXZpY2UgVHJl
ZSkKIMKgdW53aW5kX2JhY2t0cmFjZSBmcm9tIHNob3dfc3RhY2srMHgxMC8weDE0CiDCoHNob3df
c3RhY2sgZnJvbSBkdW1wX3N0YWNrX2x2bCsweDU4LzB4NzAKIMKgZHVtcF9zdGFja19sdmwgZnJv
bSBfX3dhcm4rMHhjOC8weDIxOAogwqBfX3dhcm4gZnJvbSB3YXJuX3Nsb3dwYXRoX2ZtdCsweDVj
LzB4YjQKIMKgd2Fybl9zbG93cGF0aF9mbXQgZnJvbSBiaW9fZnJlZSsweDZjLzB4NzAKIMKgYmlv
X2ZyZWUgZnJvbSBzcXVhc2hmc19yZWFkX2RhdGErMHgxMTgvMHg3NDgKIMKgc3F1YXNoZnNfcmVh
ZF9kYXRhIGZyb20gc3F1YXNoZnNfcmVhZF90YWJsZSsweGRjLzB4MTQ0CiDCoHNxdWFzaGZzX3Jl
YWRfdGFibGUgZnJvbSBzcXVhc2hmc19maWxsX3N1cGVyKzB4MTAwLzB4OWVjCiDCoHNxdWFzaGZz
X2ZpbGxfc3VwZXIgZnJvbSBnZXRfdHJlZV9iZGV2KzB4MTU0LzB4MjQ4CiDCoGdldF90cmVlX2Jk
ZXYgZnJvbSB2ZnNfZ2V0X3RyZWUrMHgyNC8weGU0CiDCoHZmc19nZXRfdHJlZSBmcm9tIHBhdGhf
bW91bnQrMHgzZDAvMHhiMTQKIMKgcGF0aF9tb3VudCBmcm9tIGluaXRfbW91bnQrMHg1NC8weDgw
CiDCoGluaXRfbW91bnQgZnJvbSBkb19tb3VudF9yb290KzB4NzgvMHgxMDQKIMKgZG9fbW91bnRf
cm9vdCBmcm9tIG1vdW50X2Jsb2NrX3Jvb3QrMHhmMC8weDFmYwogwqBtb3VudF9ibG9ja19yb290
IGZyb20gaW5pdHJkX2xvYWQrMHhlYy8weDI5NAogwqBpbml0cmRfbG9hZCBmcm9tIHByZXBhcmVf
bmFtZXNwYWNlKzB4ZGMvMHgxOGMKIMKgcHJlcGFyZV9uYW1lc3BhY2UgZnJvbSBrZXJuZWxfaW5p
dCsweDE4LzB4MTJjCiDCoGtlcm5lbF9pbml0IGZyb20gcmV0X2Zyb21fZm9yaysweDE0LzB4MmMK
RXhjZXB0aW9uIHN0YWNrKDB4ZjA4MzVmYjAgdG8gMHhmMDgzNWZmOCkKLi4uCmlycSBldmVudCBz
dGFtcDogMzk4MjcxCmhhcmRpcnFzIGxhc3TCoCBlbmFibGVkIGF0ICgzOTgyNzkpOiBbPGMwMTlj
OTg0Pl0gX191cF9jb25zb2xlX3NlbSsweDUwLzB4NjAKaGFyZGlycXMgbGFzdCBkaXNhYmxlZCBh
dCAoMzk4MzM4KTogWzxjMDE5Yzk3MD5dIF9fdXBfY29uc29sZV9zZW0rMHgzYy8weDYwCnNvZnRp
cnFzIGxhc3TCoCBlbmFibGVkIGF0ICgzOTgzNTIpOiBbPGMwMTAxNjgwPl0gX19kb19zb2Z0aXJx
KzB4MzQ4LzB4NjEwCnNvZnRpcnFzIGxhc3QgZGlzYWJsZWQgYXQgKDM5ODM0Nyk6IFs8YzAxMmYw
NDg+XSBfX2lycV9leGl0X3JjdSsweDE0NC8weDFlYwotLS1bIGVuZCB0cmFjZSAwMDAwMDAwMDAw
MDAwMDAwIF0tLS0KODwtLS0gY3V0IGhlcmUgLS0tClVuYWJsZSB0byBoYW5kbGUga2VybmVsIE5V
TEwgcG9pbnRlciBkZXJlZmVyZW5jZSBhdCB2aXJ0dWFsIGFkZHJlc3MgMDAwMDAwMDQKWzAwMDAw
MDA0XSAqcGdkPTAwMDAwMDAwCkludGVybmFsIGVycm9yOiBPb3BzOiA1IFsjMV0gUFJFRU1QVCBT
TVAgQVJNCk1vZHVsZXMgbGlua2VkIGluOgpDUFU6IDQgUElEOiAxIENvbW06IHN3YXBwZXIvMCBU
YWludGVkOiBHwqDCoMKgwqDCoMKgwqAgVyA1LjE3LjAtbmV4dC0yMDIyMDMzMSAjNDc2NwpIYXJk
d2FyZSBuYW1lOiBTYW1zdW5nIEV4eW5vcyAoRmxhdHRlbmVkIERldmljZSBUcmVlKQpQQyBpcyBh
dCBiaW9fZnJlZSsweDI0LzB4NzAKTFIgaXMgYXQgYmlvX2ZyZWUrMHgyNC8weDcwCnBjIDogWzxj
MDUwMmQyOD5dwqDCoMKgIGxyIDogWzxjMDUwMmQyOD5dwqDCoMKgIHBzcjogODAwMDAxMTMKc3Ag
OiBmMDgzNWNmMMKgIGlwIDogMDAwMDAwMDDCoCBmcCA6IGMyOGNhZTgwCnIxMDogZWYwYTk1YzDC
oCByOSA6IGMyODA1Y2MwwqAgcjggOiAwMDAwMDA2MApyNyA6IDAwMDAwMDYwwqAgcjYgOiAwMDAw
MDA2MMKgIHI1IDogMDAwMDAwMDDCoCByNCA6IGMyODA0YTgwCnIzIDogYzI4MDRhYzjCoCByMiA6
IDAwMDAwMDAxwqAgcjEgOiBjMjgwNGFjOMKgIHIwIDogMDAwMDAwNzQKRmxhZ3M6IE56Y3bCoCBJ
UlFzIG9uwqAgRklRcyBvbsKgIE1vZGUgU1ZDXzMywqAgSVNBIEFSTcKgIFNlZ21lbnQgbm9uZQpD
b250cm9sOiAxMGM1Mzg3ZMKgIFRhYmxlOiA0MDAwNDA2YcKgIERBQzogMDAwMDAwNTEKUmVnaXN0
ZXIgcjAgaW5mb3JtYXRpb246IG5vbi1wYWdlZCBtZW1vcnkKUmVnaXN0ZXIgcjEgaW5mb3JtYXRp
b246IHNsYWIga21hbGxvYy0xMjggc3RhcnQgYzI4MDRhODAgcG9pbnRlciBvZmZzZXQgCjcyIHNp
emUgMTI4ClJlZ2lzdGVyIHIyIGluZm9ybWF0aW9uOiBub24tcGFnZWQgbWVtb3J5ClJlZ2lzdGVy
IHIzIGluZm9ybWF0aW9uOiBzbGFiIGttYWxsb2MtMTI4IHN0YXJ0IGMyODA0YTgwIHBvaW50ZXIg
b2Zmc2V0IAo3MiBzaXplIDEyOApSZWdpc3RlciByNCBpbmZvcm1hdGlvbjogc2xhYiBrbWFsbG9j
LTEyOCBzdGFydCBjMjgwNGE4MCBwb2ludGVyIG9mZnNldCAKMCBzaXplIDEyOApSZWdpc3RlciBy
NSBpbmZvcm1hdGlvbjogTlVMTCBwb2ludGVyClJlZ2lzdGVyIHI2IGluZm9ybWF0aW9uOiBub24t
cGFnZWQgbWVtb3J5ClJlZ2lzdGVyIHI3IGluZm9ybWF0aW9uOiBub24tcGFnZWQgbWVtb3J5ClJl
Z2lzdGVyIHI4IGluZm9ybWF0aW9uOiBub24tcGFnZWQgbWVtb3J5ClJlZ2lzdGVyIHI5IGluZm9y
bWF0aW9uOiBzbGFiIGttYWxsb2MtMTkyIHN0YXJ0IGMyODA1Y2MwIHBvaW50ZXIgb2Zmc2V0IAow
IHNpemUgMTkyClJlZ2lzdGVyIHIxMCBpbmZvcm1hdGlvbjogbm9uLXNsYWIvdm1hbGxvYyBtZW1v
cnkKUmVnaXN0ZXIgcjExIGluZm9ybWF0aW9uOiBzbGFiIGttYWxsb2MtNjQgc3RhcnQgYzI4Y2Fl
ODAgcG9pbnRlciBvZmZzZXQgCjAgc2l6ZSA2NApSZWdpc3RlciByMTIgaW5mb3JtYXRpb246IE5V
TEwgcG9pbnRlcgpQcm9jZXNzIHN3YXBwZXIvMCAocGlkOiAxLCBzdGFjayBsaW1pdCA9IDB4KHB0
cnZhbCkpClN0YWNrOiAoMHhmMDgzNWNmMCB0byAweGYwODM2MDAwKQouLi4KIMKgYmlvX2ZyZWUg
ZnJvbSBzcXVhc2hmc19yZWFkX2RhdGErMHgxMTgvMHg3NDgKIMKgc3F1YXNoZnNfcmVhZF9kYXRh
IGZyb20gc3F1YXNoZnNfcmVhZF90YWJsZSsweGRjLzB4MTQ0CiDCoHNxdWFzaGZzX3JlYWRfdGFi
bGUgZnJvbSBzcXVhc2hmc19maWxsX3N1cGVyKzB4MTAwLzB4OWVjCiDCoHNxdWFzaGZzX2ZpbGxf
c3VwZXIgZnJvbSBnZXRfdHJlZV9iZGV2KzB4MTU0LzB4MjQ4CiDCoGdldF90cmVlX2JkZXYgZnJv
bSB2ZnNfZ2V0X3RyZWUrMHgyNC8weGU0CiDCoHZmc19nZXRfdHJlZSBmcm9tIHBhdGhfbW91bnQr
MHgzZDAvMHhiMTQKIMKgcGF0aF9tb3VudCBmcm9tIGluaXRfbW91bnQrMHg1NC8weDgwCiDCoGlu
aXRfbW91bnQgZnJvbSBkb19tb3VudF9yb290KzB4NzgvMHgxMDQKIMKgZG9fbW91bnRfcm9vdCBm
cm9tIG1vdW50X2Jsb2NrX3Jvb3QrMHhmMC8weDFmYwogwqBtb3VudF9ibG9ja19yb290IGZyb20g
aW5pdHJkX2xvYWQrMHhlYy8weDI5NAogwqBpbml0cmRfbG9hZCBmcm9tIHByZXBhcmVfbmFtZXNw
YWNlKzB4ZGMvMHgxOGMKIMKgcHJlcGFyZV9uYW1lc3BhY2UgZnJvbSBrZXJuZWxfaW5pdCsweDE4
LzB4MTJjCiDCoGtlcm5lbF9pbml0IGZyb20gcmV0X2Zyb21fZm9yaysweDE0LzB4MmMKRXhjZXB0
aW9uIHN0YWNrKDB4ZjA4MzVmYjAgdG8gMHhmMDgzNWZmOCkKLi4uCi0tLVsgZW5kIHRyYWNlIDAw
MDAwMDAwMDAwMDAwMDAgXS0tLQpLZXJuZWwgcGFuaWMgLSBub3Qgc3luY2luZzogQXR0ZW1wdGVk
IHRvIGtpbGwgaW5pdCEgZXhpdGNvZGU9MHgwMDAwMDAwYgoKUmV2ZXJ0aW5nIGl0IG9uIHRvcCBv
ZiBsaW51eCBuZXh0LTIwMjIwMzMxICh0b2dldGhlciB3aXRoIGNvbW1pdCAKMTI5MmZiNTlmMjgz
ICgicGt0Y2R2ZDogc3RvcCB1c2luZyBiaW9fcmVzZXQiKSkgZml4ZXMgKG9yIGhpZGVzPykgdGhl
IGlzc3VlLgoKPiAtLS0KPiAgIGJsb2NrL2Jpby5jICAgICAgICAgICAgICAgICAgICAgICAgfCA0
NyArKysrKysrKysrKystLS0tLS0tLS0tLS0tLS0tLS0KPiAgIGJsb2NrL2Jsay1jcnlwdG8tZmFs
bGJhY2suYyAgICAgICAgfCAxNCArKysrKy0tLS0KPiAgIGJsb2NrL2Jsay1tYXAuYyAgICAgICAg
ICAgICAgICAgICAgfCA0MiArKysrKysrKysrKysrKysrLS0tLS0tLS0tLQo+ICAgZHJpdmVycy9i
bG9jay9wa3RjZHZkLmMgICAgICAgICAgICB8IDI1ICsrKysrKysrLS0tLS0tLS0KPiAgIGRyaXZl
cnMvbWQvYmNhY2hlL2RlYnVnLmMgICAgICAgICAgfCAxMCArKysrLS0tCj4gICBkcml2ZXJzL21k
L2RtLWJ1ZmlvLmMgICAgICAgICAgICAgIHwgIDkgKysrLS0tCj4gICBkcml2ZXJzL21kL3JhaWQx
LmMgICAgICAgICAgICAgICAgIHwgMTIgKysrKystLS0KPiAgIGRyaXZlcnMvbWQvcmFpZDEwLmMg
ICAgICAgICAgICAgICAgfCAyMSArKysrKysrKy0tLS0tCj4gICBkcml2ZXJzL3RhcmdldC90YXJn
ZXRfY29yZV9wc2NzaS5jIHwgMTAgKysrLS0tLQo+ICAgZnMvc3F1YXNoZnMvYmxvY2suYyAgICAg
ICAgICAgICAgICB8ICA5ICsrKy0tLQo+ICAgaW5jbHVkZS9saW51eC9iaW8uaCAgICAgICAgICAg
ICAgICB8ICAyICstCj4gICAxMSBmaWxlcyBjaGFuZ2VkLCAxMDggaW5zZXJ0aW9ucygrKSwgOTMg
ZGVsZXRpb25zKC0pCgogPiBbLi4uXQoKQmVzdCByZWdhcmRzCi0tIApNYXJlayBTenlwcm93c2tp
LCBQaEQKU2Ftc3VuZyBSJkQgSW5zdGl0dXRlIFBvbGFuZAoKLS0KZG0tZGV2ZWwgbWFpbGluZyBs
aXN0CmRtLWRldmVsQHJlZGhhdC5jb20KaHR0cHM6Ly9saXN0bWFuLnJlZGhhdC5jb20vbWFpbG1h
bi9saXN0aW5mby9kbS1kZXZlbAo=

