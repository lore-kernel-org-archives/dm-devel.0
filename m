Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (usb-smtp-delivery-124.mimecast.com [170.10.153.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0CC3FC433EF
	for <dm-devel@archiver.kernel.org>; Thu,  2 Dec 2021 07:59:58 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-4-7_FxsQdhMtGz4Ir8EjK5QA-1; Thu, 02 Dec 2021 02:59:54 -0500
X-MC-Unique: 7_FxsQdhMtGz4Ir8EjK5QA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 944501006AA0;
	Thu,  2 Dec 2021 07:59:50 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 4BB0919724;
	Thu,  2 Dec 2021 07:59:50 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 25B0B1809C89;
	Thu,  2 Dec 2021 07:59:50 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
	[10.11.54.1])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1B27xjqd025426 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 2 Dec 2021 02:59:45 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 8F2B94010E8A; Thu,  2 Dec 2021 07:59:45 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 89C2340CFD0C
	for <dm-devel@redhat.com>; Thu,  2 Dec 2021 07:59:45 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6FB2E80A0AE
	for <dm-devel@redhat.com>; Thu,  2 Dec 2021 07:59:45 +0000 (UTC)
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com
	[185.176.79.56]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-39-AZlsx3-OMV-PR3qPkpQtxw-1; Thu, 02 Dec 2021 02:59:41 -0500
X-MC-Unique: AZlsx3-OMV-PR3qPkpQtxw-1
Received: from fraeml707-chm.china.huawei.com (unknown [172.18.147.206])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4J4StZ1WDLz67x6V;
	Thu,  2 Dec 2021 15:55:34 +0800 (CST)
Received: from fraeml714-chm.china.huawei.com (10.206.15.33) by
	fraeml707-chm.china.huawei.com (10.206.15.35) with Microsoft SMTP
	Server
	(version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
	15.1.2308.20; Thu, 2 Dec 2021 08:59:39 +0100
Received: from fraeml714-chm.china.huawei.com ([10.206.15.33]) by
	fraeml714-chm.china.huawei.com ([10.206.15.33]) with mapi id
	15.01.2308.020; Thu, 2 Dec 2021 08:59:39 +0100
From: Roberto Sassu <roberto.sassu@huawei.com>
To: Christoph Hellwig <hch@infradead.org>
Thread-Topic: [RFC][PATCH] device mapper: Add builtin function dm_get_status()
Thread-Index: AQHX5tHI6VSZDPA0J0GM0KIP7fuaeKweu+CAgAAaFvA=
Date: Thu, 2 Dec 2021 07:59:38 +0000
Message-ID: <e57d2d23ec7845febb79ca4476c73fcb@huawei.com>
References: <81d5e825-1ee2-8f6b-cd9d-07b0f8bd36d3@linux.microsoft.com>
	<20211201163708.3578176-1-roberto.sassu@huawei.com>
	<Yahz1SYRG1CQIh0z@infradead.org>
In-Reply-To: <Yahz1SYRG1CQIh0z@infradead.org>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.204.63.33]
MIME-Version: 1.0
X-CFilter-Loop: Reflected
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 1B27xjqd025426
X-loop: dm-devel@redhat.com
Cc: "axboe@kernel.dk" <axboe@kernel.dk>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"tytso@mit.edu" <tytso@mit.edu>,
	"paul@paul-moore.com" <paul@paul-moore.com>,
	"snitzer@redhat.com" <snitzer@redhat.com>,
	"corbet@lwn.net" <corbet@lwn.net>,
	"deven.desai@linux.microsoft.com" <deven.desai@linux.microsoft.com>,
	"jannh@google.com" <jannh@google.com>,
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
	"jmorris@namei.org" <jmorris@namei.org>,
	"eparis@redhat.com" <eparis@redhat.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"ebiggers@kernel.org" <ebiggers@kernel.org>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>,
	"linux-audit@redhat.com" <linux-audit@redhat.com>,
	"linux-security-module@vger.kernel.org"
	<linux-security-module@vger.kernel.org>,
	"tusharsu@linux.microsoft.com" <tusharsu@linux.microsoft.com>,
	"linux-fscrypt@vger.kernel.org" <linux-fscrypt@vger.kernel.org>,
	"linux-integrity@vger.kernel.org" <linux-integrity@vger.kernel.org>,
	"agk@redhat.com" <agk@redhat.com>, "serge@hallyn.com" <serge@hallyn.com>
Subject: Re: [dm-devel] [RFC][PATCH] device mapper: Add builtin function
	dm_get_status()
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

> From: Christoph Hellwig [mailto:hch@infradead.org]
> Sent: Thursday, December 2, 2021 8:21 AM
> On Wed, Dec 01, 2021 at 05:37:08PM +0100, Roberto Sassu wrote:
> > Users of the device mapper driver might want to obtain a device status,
> > with status types defined in the status_type_t enumerator.
> 
> The patch looks really odd.  And without the corresponding user of your
> new functionality it is entirely unreviewable anyway.

Hi Christoph

ok, I will send it together with a patch for a not yet accepted
software, Integrity Policy Enforcement (IPE), that will be
the primary user of the introduced functionality.

Regarding the patch itself, could you please provide a more
detailed explanation?

Thanks

Roberto

HUAWEI TECHNOLOGIES Duesseldorf GmbH, HRB 56063
Managing Director: Li Peng, Zhong Ronghua


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

