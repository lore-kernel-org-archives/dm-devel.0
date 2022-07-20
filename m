Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 62584C433EF
	for <dm-devel@archiver.kernel.org>; Wed, 20 Jul 2022 06:46:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1658299598;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=MKji+FpQ9X+CwTAQswO/kKbt/QW85KnHoxEAJFmWrxs=;
	b=B5owXStsBParLIGzIargn5TXMZVNu0/6Ec5SHyP1hnw6MevnBl0mhFaXKiUe8Ehbho9vNB
	O5EXWdIGqEBW4HXbOKaThtB63EjSaCwaRW4jm+EeAdlNXakXL4McyB4Cp815Oaiy46M0uW
	7D+RwRwcRy7pnJUdajoM2FVmkATg6LY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-347-YsCq_LasMd2U84Kaopix5Q-1; Wed, 20 Jul 2022 02:46:34 -0400
X-MC-Unique: YsCq_LasMd2U84Kaopix5Q-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CF6D2101A54E;
	Wed, 20 Jul 2022 06:46:32 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id EBD5C18EA8;
	Wed, 20 Jul 2022 06:46:29 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 9FAB0194705F;
	Wed, 20 Jul 2022 06:46:29 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 0D2E01945DA7
 for <dm-devel@listman.corp.redhat.com>; Wed, 20 Jul 2022 06:46:29 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id E375E401473; Wed, 20 Jul 2022 06:46:28 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id DF13B492C3B
 for <dm-devel@redhat.com>; Wed, 20 Jul 2022 06:46:28 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C7831801231
 for <dm-devel@redhat.com>; Wed, 20 Jul 2022 06:46:28 +0000 (UTC)
Received: from bombadil.infradead.org (bombadil.infradead.org
 [198.137.202.133]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-42-oDo9jIruNvahUP7ZHYGk1w-1; Wed, 20 Jul 2022 02:46:20 -0400
X-MC-Unique: oDo9jIruNvahUP7ZHYGk1w-1
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red
 Hat Linux)) id 1oE308-0013dP-G1; Wed, 20 Jul 2022 06:16:04 +0000
Date: Tue, 19 Jul 2022 23:16:04 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Mike Christie <michael.christie@oracle.com>
Message-ID: <YtedpBxV3Y/b33Sx@infradead.org>
References: <20220707202711.10836-1-michael.christie@oracle.com>
 <20220707202711.10836-3-michael.christie@oracle.com>
 <0c2c37c2-84f0-d6c7-b060-be7c5ba6dede@oracle.com>
 <YtBlLDShzLdW8xDx@redhat.com>
 <ffce063b-6afc-bf76-c429-353c70a73439@oracle.com>
 <YtT1uTW04BC38NSK@infradead.org>
 <0bfd6a7f-7ddd-60e5-d37a-0c399b4d2fb7@oracle.com>
MIME-Version: 1.0
In-Reply-To: <0bfd6a7f-7ddd-60e5-d37a-0c399b4d2fb7@oracle.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by
 bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
Subject: Re: [dm-devel] [PATCH 2/3] dm: Start pr_reserve from the same
 starting path
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
Cc: Christoph Hellwig <hch@infradead.org>, dm-devel@redhat.com,
 Mike Snitzer <snitzer@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Mon, Jul 18, 2022 at 12:39:12PM -0500, Mike Christie wrote:
> 1. Let's say you do an active-active setup with 2 paths in one priority group,
> and the Write Exclusive or Exclusive Access reservation went down pathA so it's
> the holder. When the app does IO to /dev/dm-0 the path selectors aren't PGR aware
> so IO can go down any path. For Write Exclusive, when WRITEs go down pathB they
> get failed with reservation conflicts (sbc4r22 table 13). So this type of
> reservation and active-active would only be useful for read-only work loads.
> 
> For Exclusive Access READ/WRITEs can only go down pathA ok. If they go down
> PathB we will get reservation conflicts. So it's really useless in an active-
> active setup.

It's not useless.  It just needs all paths to be registered.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

