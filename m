Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 913F3C433F5
	for <dm-devel@archiver.kernel.org>; Fri,  3 Dec 2021 08:45:21 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-442-yJ3lsXtGNaG6UzRiZrt_yg-1; Fri, 03 Dec 2021 03:45:16 -0500
X-MC-Unique: yJ3lsXtGNaG6UzRiZrt_yg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5BC2F1019999;
	Fri,  3 Dec 2021 08:45:12 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 1E1365F4E0;
	Fri,  3 Dec 2021 08:45:12 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 3F2B81809CBF;
	Fri,  3 Dec 2021 08:45:11 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1B38j64l028431 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 3 Dec 2021 03:45:07 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 9F45A2026D69; Fri,  3 Dec 2021 08:45:06 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 9A03C2026D5D
	for <dm-devel@redhat.com>; Fri,  3 Dec 2021 08:45:03 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 86EA01066559
	for <dm-devel@redhat.com>; Fri,  3 Dec 2021 08:45:03 +0000 (UTC)
Received: from bombadil.infradead.org (bombadil.infradead.org
	[198.137.202.133]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-80-7urukIHKOCCBIJlhNRNfig-1; Fri, 03 Dec 2021 03:45:01 -0500
X-MC-Unique: 7urukIHKOCCBIJlhNRNfig-1
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red
	Hat Linux)) id 1mt2QV-00EcqD-Aj; Fri, 03 Dec 2021 06:52:11 +0000
Date: Thu, 2 Dec 2021 22:52:11 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Roberto Sassu <roberto.sassu@huawei.com>
Message-ID: <Yam+m9eiLxIamGXm@infradead.org>
References: <81d5e825-1ee2-8f6b-cd9d-07b0f8bd36d3@linux.microsoft.com>
	<20211201163708.3578176-1-roberto.sassu@huawei.com>
	<Yahz1SYRG1CQIh0z@infradead.org>
	<e57d2d23ec7845febb79ca4476c73fcb@huawei.com>
	<YaiHX+dWNUlmsNac@infradead.org>
	<b4bf4a384b334cdab1522b3b082bd088@huawei.com>
MIME-Version: 1.0
In-Reply-To: <b4bf4a384b334cdab1522b3b082bd088@huawei.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by
	bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-loop: dm-devel@redhat.com
Cc: "snitzer@redhat.com" <snitzer@redhat.com>,
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
	"deven.desai@linux.microsoft.com" <deven.desai@linux.microsoft.com>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>,
	"agk@redhat.com" <agk@redhat.com>, Christoph Hellwig <hch@infradead.org>,
	"paul@paul-moore.com" <paul@paul-moore.com>,
	"corbet@lwn.net" <corbet@lwn.net>, "jmorris@namei.org" <jmorris@namei.org>,
	"ebiggers@kernel.org" <ebiggers@kernel.org>,
	"serge@hallyn.com" <serge@hallyn.com>,
	"jannh@google.com" <jannh@google.com>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"linux-fscrypt@vger.kernel.org" <linux-fscrypt@vger.kernel.org>,
	"tusharsu@linux.microsoft.com" <tusharsu@linux.microsoft.com>,
	"axboe@kernel.dk" <axboe@kernel.dk>, "tytso@mit.edu" <tytso@mit.edu>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"eparis@redhat.com" <eparis@redhat.com>,
	"linux-security-module@vger.kernel.org"
	<linux-security-module@vger.kernel.org>,
	"linux-audit@redhat.com" <linux-audit@redhat.com>,
	"linux-integrity@vger.kernel.org" <linux-integrity@vger.kernel.org>
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
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Thu, Dec 02, 2021 at 09:29:52AM +0000, Roberto Sassu wrote:
> The problem being solved is how to grant access to files
> which satisfy a property defined in the policy.

If you have want to enforce access to files in the block layer using
a specific stacking block driver you don't just have one layering
violation but a bunch of them.  Please go back to the drawing board.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

