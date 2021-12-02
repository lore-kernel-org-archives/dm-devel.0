Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 84B35C433EF
	for <dm-devel@archiver.kernel.org>; Thu,  2 Dec 2021 08:55:52 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-532-ieB80-nCMFaPyOm9Yrzpog-1; Thu, 02 Dec 2021 03:55:48 -0500
X-MC-Unique: ieB80-nCMFaPyOm9Yrzpog-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D4FE43E741;
	Thu,  2 Dec 2021 08:55:43 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id DB9B319724;
	Thu,  2 Dec 2021 08:55:42 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 382911809CB7;
	Thu,  2 Dec 2021 08:55:41 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
	[10.11.54.1])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1B28te4Q029889 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 2 Dec 2021 03:55:40 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 11E9840CFD10; Thu,  2 Dec 2021 08:55:40 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 0D20740CFD0C
	for <dm-devel@redhat.com>; Thu,  2 Dec 2021 08:55:40 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E8034185A79C
	for <dm-devel@redhat.com>; Thu,  2 Dec 2021 08:55:39 +0000 (UTC)
Received: from bombadil.infradead.org (bombadil.infradead.org
	[198.137.202.133]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-385-WiSedrzaNsiTZ_gwYon4KQ-1; Thu, 02 Dec 2021 03:55:36 -0500
X-MC-Unique: WiSedrzaNsiTZ_gwYon4KQ-1
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red
	Hat Linux)) id 1msgOj-00BArf-A8; Thu, 02 Dec 2021 07:20:53 +0000
Date: Wed, 1 Dec 2021 23:20:53 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Roberto Sassu <roberto.sassu@huawei.com>
Message-ID: <Yahz1SYRG1CQIh0z@infradead.org>
References: <81d5e825-1ee2-8f6b-cd9d-07b0f8bd36d3@linux.microsoft.com>
	<20211201163708.3578176-1-roberto.sassu@huawei.com>
MIME-Version: 1.0
In-Reply-To: <20211201163708.3578176-1-roberto.sassu@huawei.com>
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
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-loop: dm-devel@redhat.com
Cc: axboe@kernel.dk, linux-block@vger.kernel.org, tytso@mit.edu,
	paul@paul-moore.com, snitzer@redhat.com, corbet@lwn.net,
	deven.desai@linux.microsoft.com, jannh@google.com,
	linux-doc@vger.kernel.org, jmorris@namei.org, eparis@redhat.com,
	linux-kernel@vger.kernel.org, ebiggers@kernel.org,
	dm-devel@redhat.com, linux-audit@redhat.com,
	linux-security-module@vger.kernel.org,
	tusharsu@linux.microsoft.com, linux-fscrypt@vger.kernel.org,
	linux-integrity@vger.kernel.org, agk@redhat.com, serge@hallyn.com
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
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, Dec 01, 2021 at 05:37:08PM +0100, Roberto Sassu wrote:
> Users of the device mapper driver might want to obtain a device status,
> with status types defined in the status_type_t enumerator.

The patch looks really odd.  And without the corresponding user of your
new functionality it is entirely unreviewable anyway.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

