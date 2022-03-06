Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2EEB5C433EF
	for <dm-devel@archiver.kernel.org>; Sun,  6 Mar 2022 09:29:55 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-32-ZhD7B2zpOuaAu2QBPtMaMQ-1; Sun, 06 Mar 2022 04:29:51 -0500
X-MC-Unique: ZhD7B2zpOuaAu2QBPtMaMQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1C3C31C04B55;
	Sun,  6 Mar 2022 09:29:49 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 07BC02166B25;
	Sun,  6 Mar 2022 09:29:49 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id BB12C194E109;
	Sun,  6 Mar 2022 09:29:48 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 47F07194E107
 for <dm-devel@listman.corp.redhat.com>; Sun,  6 Mar 2022 09:29:47 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 2A1182166B3F; Sun,  6 Mar 2022 09:29:47 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 255352166B25
 for <dm-devel@redhat.com>; Sun,  6 Mar 2022 09:29:44 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1156685A5A8
 for <dm-devel@redhat.com>; Sun,  6 Mar 2022 09:29:44 +0000 (UTC)
Received: from verein.lst.de (verein.lst.de [213.95.11.211]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-281-YJS8IO-gMRGQiQ4b-8Sv1g-1; Sun, 06 Mar 2022 04:29:41 -0500
X-MC-Unique: YJS8IO-gMRGQiQ4b-8Sv1g-1
Received: by verein.lst.de (Postfix, from userid 2407)
 id E26C068B05; Sun,  6 Mar 2022 10:29:37 +0100 (CET)
Date: Sun, 6 Mar 2022 10:29:37 +0100
From: Christoph Hellwig <hch@lst.de>
To: Mike Snitzer <snitzer@redhat.com>
Message-ID: <20220306092937.GC22883@lst.de>
References: <20220305020804.54010-1-snitzer@redhat.com>
 <20220305020804.54010-3-snitzer@redhat.com>
MIME-Version: 1.0
In-Reply-To: <20220305020804.54010-3-snitzer@redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
Subject: Re: [dm-devel] [PATCH v5 2/2] dm: support bio polling
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
Cc: axboe@kernel.dk, linux-block@vger.kernel.org, dm-devel@redhat.com,
 hch@lst.de, ming.lei@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

> +/*
> + * Reuse ->bi_end_io as hlist head for storing all dm_io instances
> + * associated with this bio, and this bio's bi_end_io has to be
> + * stored in one of 'dm_io' instance first.
> + */
> +static inline struct hlist_head *dm_get_bio_hlist_head(struct bio *bio)
> +{
> +	WARN_ON_ONCE(!(bio->bi_opf & REQ_DM_POLL_LIST));
> +
> +	return (struct hlist_head *)&bio->bi_end_io;
> +}

So this reuse is what I really hated.  I still think we should be able
to find space in the bio by creatively shifting fields around to just
add the hlist there directly, which would remove the need for this
override and more importantly the quite cumbersome saving and restoring
of the end_io handler.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

