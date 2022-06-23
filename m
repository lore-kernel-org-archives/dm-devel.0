Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 17D24C43334
	for <dm-devel@archiver.kernel.org>; Thu, 23 Jun 2022 15:48:38 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-413-pgzxPgQeOeOed0CjOsA0Yg-1; Thu, 23 Jun 2022 11:48:36 -0400
X-MC-Unique: pgzxPgQeOeOed0CjOsA0Yg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7097D8037B7;
	Thu, 23 Jun 2022 15:48:32 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id C55C740C141F;
	Thu, 23 Jun 2022 15:48:30 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 8EA73194B957;
	Thu, 23 Jun 2022 15:48:30 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 332AF194B957
 for <dm-devel@listman.corp.redhat.com>; Thu, 23 Jun 2022 15:48:29 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id DEA1D40D2853; Thu, 23 Jun 2022 15:48:28 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id DA9C840D282F
 for <dm-devel@redhat.com>; Thu, 23 Jun 2022 15:48:28 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 389B43C0E227
 for <dm-devel@redhat.com>; Thu, 23 Jun 2022 15:48:12 +0000 (UTC)
Received: from dfw.source.kernel.org (dfw.source.kernel.org
 [139.178.84.217]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-447-wm9iYBaeNIu9vRSgAKs08g-1; Thu, 23 Jun 2022 11:48:09 -0400
X-MC-Unique: wm9iYBaeNIu9vRSgAKs08g-1
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 64A8F61ED1;
 Thu, 23 Jun 2022 15:48:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 477D5C3411B;
 Thu, 23 Jun 2022 15:48:07 +0000 (UTC)
Date: Thu, 23 Jun 2022 17:48:04 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Mike Snitzer <snitzer@kernel.org>
Message-ID: <YrSLNE35zJELb1Jf@kroah.com>
References: <20220610042200.2561917-1-ovt@google.com>
 <YqLTV+5Q72/jBeOG@kroah.com> <YqNfBMOR9SE2TuCm@redhat.com>
 <Yqb/sT205Lrhl6Bv@kroah.com>
 <20220615143642.GA2386944@roeck-us.net>
 <Yqn64AMwoIzQXwXM@redhat.com>
 <50eeff2e-45c5-5eb2-c41d-3e0092a84483@roeck-us.net>
 <Yqo63CvFpTDFnH3x@redhat.com> <YrBdsTDrreF3H82o@kroah.com>
 <YrHzOGO5fOSFwqdJ@redhat.com>
MIME-Version: 1.0
In-Reply-To: <YrHzOGO5fOSFwqdJ@redhat.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Subject: Re: [dm-devel] [5.4.y PATCH v2] dm: remove special-casing of
 bio-based immutable singleton target on NVMe
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
Cc: keescook@chromium.org, sarthakkukreti@google.com, stable@vger.kernel.org,
 Oleksandr Tymoshenko <ovt@google.com>, dm-devel@redhat.com,
 Guenter Roeck <linux@roeck-us.net>, regressions@lists.linux.dev
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, Jun 21, 2022 at 12:35:04PM -0400, Mike Snitzer wrote:
> Commit 9c37de297f6590937f95a28bec1b7ac68a38618f upstream.
> 
> There is no benefit to DM special-casing NVMe. Remove all code used to
> establish DM_TYPE_NVME_BIO_BASED.
> 
> Also, remove 3 'struct mapped_device *md' variables in __map_bio() which
> masked the same variable that is available within __map_bio()'s scope.
> 
> Tested-by: Guenter Roeck <linux@roeck-us.net>
> Signed-off-by: Mike Snitzer <snitzer@kernel.org>
> ---
>  drivers/md/dm-table.c         | 32 +--------------
>  drivers/md/dm.c               | 73 ++++-------------------------------
>  include/linux/device-mapper.h |  1 -
>  3 files changed, 9 insertions(+), 97 deletions(-)

Now queued up, thanks.

greg k-h

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

