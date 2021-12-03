Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E6704C433F5
	for <dm-devel@archiver.kernel.org>; Fri,  3 Dec 2021 10:20:50 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-575-SshI-bFKOGSapAtsWfJL6g-1; Fri, 03 Dec 2021 05:20:46 -0500
X-MC-Unique: SshI-bFKOGSapAtsWfJL6g-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BC567106F71E;
	Fri,  3 Dec 2021 10:20:40 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 84CD35BAE2;
	Fri,  3 Dec 2021 10:20:39 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 7B4911809CB8;
	Fri,  3 Dec 2021 10:20:36 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
	[10.11.54.9])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1B3AKXHC004191 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 3 Dec 2021 05:20:34 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id A4381492C3B; Fri,  3 Dec 2021 10:20:33 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 9FB38492C38
	for <dm-devel@redhat.com>; Fri,  3 Dec 2021 10:20:33 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 86E53185A79C
	for <dm-devel@redhat.com>; Fri,  3 Dec 2021 10:20:33 +0000 (UTC)
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com
	[185.176.79.56]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-591-ewt--zQ3MP6-rNtGx2BWKA-1; Fri, 03 Dec 2021 05:20:29 -0500
X-MC-Unique: ewt--zQ3MP6-rNtGx2BWKA-1
Received: from fraeml707-chm.china.huawei.com (unknown [172.18.147.206])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4J582D1KjQz67wM9;
	Fri,  3 Dec 2021 18:19:32 +0800 (CST)
Received: from fraeml714-chm.china.huawei.com (10.206.15.33) by
	fraeml707-chm.china.huawei.com (10.206.15.35) with Microsoft SMTP
	Server
	(version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
	15.1.2308.20; Fri, 3 Dec 2021 11:20:27 +0100
Received: from fraeml714-chm.china.huawei.com ([10.206.15.33]) by
	fraeml714-chm.china.huawei.com ([10.206.15.33]) with mapi id
	15.01.2308.020; Fri, 3 Dec 2021 11:20:27 +0100
From: Roberto Sassu <roberto.sassu@huawei.com>
To: Christoph Hellwig <hch@infradead.org>
Thread-Topic: [RFC][PATCH] device mapper: Add builtin function dm_get_status()
Thread-Index: AQHX5tHI6VSZDPA0J0GM0KIP7fuaeKweu+CAgAAaFvD///01gIAAEg9QgAFg9oCAAC4FMA==
Date: Fri, 3 Dec 2021 10:20:27 +0000
Message-ID: <28208b7f142f4295ac5c857af5cffe07@huawei.com>
References: <81d5e825-1ee2-8f6b-cd9d-07b0f8bd36d3@linux.microsoft.com>
	<20211201163708.3578176-1-roberto.sassu@huawei.com>
	<Yahz1SYRG1CQIh0z@infradead.org>
	<e57d2d23ec7845febb79ca4476c73fcb@huawei.com>
	<YaiHX+dWNUlmsNac@infradead.org>
	<b4bf4a384b334cdab1522b3b082bd088@huawei.com>
	<Yam+m9eiLxIamGXm@infradead.org>
In-Reply-To: <Yam+m9eiLxIamGXm@infradead.org>
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
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 1B3AKXHC004191
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

> From: Christoph Hellwig [mailto:hch@infradead.org]
> Sent: Friday, December 3, 2021 7:52 AM
> On Thu, Dec 02, 2021 at 09:29:52AM +0000, Roberto Sassu wrote:
> > The problem being solved is how to grant access to files
> > which satisfy a property defined in the policy.
> 
> If you have want to enforce access to files in the block layer using
> a specific stacking block driver you don't just have one layering
> violation but a bunch of them.  Please go back to the drawing board.

Ok. I write my thoughts here, so that it is easier to align.

dm-verity provides block-level integrity, which means that
the block layer itself is responsible to not pass data to the
upper layer, the filesystem, if a block is found corrupted.

The dm-verity root digest represents the immutable state
of the block device. dm-verity is still responsible to enforce
accesses to the block device according to the root digest
passed at device setup time. Nothing changes, the block
layer still detects data corruption against the passed
reference value.

The task of the security layer is to decide whether or not
the root digest passed at device setup time is acceptable,
e.g. it represents a device containing genuine files coming
from a software vendor.

The mandatory policy can be enforced at different layers,
depending on whether the security controls are placed.
A possibility would be to deny mounting block devices that
don't satisfy the mandatory policy.

However, if the mandatory policy wants only to restrict
execution of approved files and allowing the rest, making
the decision at the block layer is too coarse and restrictive.
It would force the user to mount only approved block
devices. The security layer must operate on files to enforce
this policy.

Now probably there is the part where there is no agreement.

The integrity property of a block device applies also to the
files on the filesystem mounted from that device. User space
programs cannot access files in that filesystem coming from a
device with a different dm-verity root digest, or files stored
in a corrupted block device.

If what I wrote is correct, that the integrity property is preserved
across the layers, this would give enough flexibility to enforce
policies at a higher layer, although that property is guaranteed
by a lower layer.

Roberto

HUAWEI TECHNOLOGIES Duesseldorf GmbH, HRB 56063
Managing Director: Li Peng, Zhong Ronghua


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

