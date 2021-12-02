Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 58EA7C4332F
	for <dm-devel@archiver.kernel.org>; Thu,  2 Dec 2021 09:30:14 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-140-gvouZ4NuNpCGXlVlQfOrXg-1; Thu, 02 Dec 2021 04:30:09 -0500
X-MC-Unique: gvouZ4NuNpCGXlVlQfOrXg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 72952839A43;
	Thu,  2 Dec 2021 09:30:05 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D7BCA5D6BA;
	Thu,  2 Dec 2021 09:30:04 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 010A54CA93;
	Thu,  2 Dec 2021 09:30:02 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1B29TxXx031922 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 2 Dec 2021 04:30:00 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 8B1D62166B26; Thu,  2 Dec 2021 09:29:59 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 835CC2166B3F
	for <dm-devel@redhat.com>; Thu,  2 Dec 2021 09:29:56 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9A173805C2F
	for <dm-devel@redhat.com>; Thu,  2 Dec 2021 09:29:56 +0000 (UTC)
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com
	[185.176.79.56]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-374-1k1ZTojZOVquq-bgL1MRVA-1; Thu, 02 Dec 2021 04:29:54 -0500
X-MC-Unique: 1k1ZTojZOVquq-bgL1MRVA-1
Received: from fraeml715-chm.china.huawei.com (unknown [172.18.147.200])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4J4Vtg2HNKz67YrM;
	Thu,  2 Dec 2021 17:25:47 +0800 (CST)
Received: from fraeml714-chm.china.huawei.com (10.206.15.33) by
	fraeml715-chm.china.huawei.com (10.206.15.34) with Microsoft SMTP
	Server
	(version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
	15.1.2308.20; Thu, 2 Dec 2021 10:29:52 +0100
Received: from fraeml714-chm.china.huawei.com ([10.206.15.33]) by
	fraeml714-chm.china.huawei.com ([10.206.15.33]) with mapi id
	15.01.2308.020; Thu, 2 Dec 2021 10:29:52 +0100
From: Roberto Sassu <roberto.sassu@huawei.com>
To: Christoph Hellwig <hch@infradead.org>
Thread-Topic: [RFC][PATCH] device mapper: Add builtin function dm_get_status()
Thread-Index: AQHX5tHI6VSZDPA0J0GM0KIP7fuaeKweu+CAgAAaFvD///01gIAAEg9Q
Date: Thu, 2 Dec 2021 09:29:52 +0000
Message-ID: <b4bf4a384b334cdab1522b3b082bd088@huawei.com>
References: <81d5e825-1ee2-8f6b-cd9d-07b0f8bd36d3@linux.microsoft.com>
	<20211201163708.3578176-1-roberto.sassu@huawei.com>
	<Yahz1SYRG1CQIh0z@infradead.org>
	<e57d2d23ec7845febb79ca4476c73fcb@huawei.com>
	<YaiHX+dWNUlmsNac@infradead.org>
In-Reply-To: <YaiHX+dWNUlmsNac@infradead.org>
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
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 1B29TxXx031922
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

> From: Christoph Hellwig [mailto:hch@infradead.org]
> Sent: Thursday, December 2, 2021 9:44 AM
> On Thu, Dec 02, 2021 at 07:59:38AM +0000, Roberto Sassu wrote:
> > ok, I will send it together with a patch for a not yet accepted
> > software, Integrity Policy Enforcement (IPE), that will be
> > the primary user of the introduced functionality.
> >
> > Regarding the patch itself, could you please provide a more
> > detailed explanation?
> 
> We don't build things into the kernel just as hooks.  So in doubt you
> need to restructured the code.  And that a security module pokes into
> a random block driver is a big hint that whatever you're trying to do is
> completely broken.

I will add more context to the discussion.

The problem being solved is how to grant access to files
which satisfy a property defined in the policy.

For example, a policy enforced by IPE could be:

policy_name="AllowDMVerityKmodules" policy_version=0.0.1
DEFAULT action=ALLOW
DEFAULT op=KMODULE action=DENY
op=KMODULE dmverity_roothash=3c64aae64ae5e8ca781df4d1fbff7c02cb78c4f18a79198263db192cc7f7ba11 action=ALLOW

This would require IPE to obtain somehow this property.

So far, there are two different approaches. The first one,
proposed by the IPE authors was to define a new LSM hook
for block devices, to append a security blob for those devices,
and to store the dm-verity root digest as soon as this information
can be determined. IPE will then access the security blob at
run-time and will match the blob content with the property
value in the policy.

The second one I'm proposing is to directly retrieve the
information at run-time, when files are accessed, and to
possibly cache the result of the evaluation per filesystem.
This would avoid to the introduction of a new LSM hook
and to append a security blob for the purpose of passing
information from the device mapper driver to IPE.

Security blobs are usually used to store LSM-specific
information such as a label (or a reference of it). Sometimes,
when the label must be stored persistently, the subsystem
responsible for this task, such as the VFS, uses subsystem-defined
methods to retrieve the label from the storage and copy it to
the security blob.

In this case, it is not an LSM-specific information but rather
an existing property of another subsystem IPE is interested in.
Since LSMs need anyway to inspect the object before making
the security decision, they could directly retrieve the information
that is already available, instead of making it redundant.

Even if I would prefer the second option, it would be fine for
me if the first is adopted.

Roberto

HUAWEI TECHNOLOGIES Duesseldorf GmbH, HRB 56063
Managing Director: Li Peng, Zhong Ronghua


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

