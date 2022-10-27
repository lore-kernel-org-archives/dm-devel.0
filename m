Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1BB67ECAAA1
	for <dm-devel@archiver.kernel.org>; Thu, 27 Oct 2022 21:54:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1666907671;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=6kbkdNQONkKhBa8Aq8DrcZmVp1VI2qmtqWDwQaRZbpM=;
	b=Z5yPs+D5jrSrettrx9SkaRV08v9Dn4zb5wt3PwHFxAT42dRCZidlWdnramorR3zr7dEEXK
	yiFk2Uf6/U6s3m3uRTFmUcMF/0Ii66aRcsnVyKDs10aFKA9UBUTm4F0nGZ4oDAez/0XIHq
	5fji9uN4i65SYUMScq5xILO81DISQ9o=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-588-LPG46tieN5ivJk_9LL-WGg-1; Thu, 27 Oct 2022 17:54:27 -0400
X-MC-Unique: LPG46tieN5ivJk_9LL-WGg-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1A7403C0E20E;
	Thu, 27 Oct 2022 21:54:26 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 7CCD24A9265;
	Thu, 27 Oct 2022 21:54:25 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 4917E19465A4;
	Thu, 27 Oct 2022 21:54:25 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 8FAA91946597
 for <dm-devel@listman.corp.redhat.com>; Thu, 27 Oct 2022 21:54:21 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id D6984112132D; Thu, 27 Oct 2022 21:54:21 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id CF0F81121325
 for <dm-devel@redhat.com>; Thu, 27 Oct 2022 21:54:21 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AF3B3800B30
 for <dm-devel@redhat.com>; Thu, 27 Oct 2022 21:54:21 +0000 (UTC)
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_128_GCM_SHA256) id us-mta-359-j7VD67alOAmNZpVqkAqZBQ-1; Thu,
 27 Oct 2022 17:54:19 -0400
X-MC-Unique: j7VD67alOAmNZpVqkAqZBQ-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out1.suse.de (Postfix) with ESMTPS id 8EC1B219E7;
 Thu, 27 Oct 2022 21:54:18 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 52EF4134CA;
 Thu, 27 Oct 2022 21:54:18 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap2.suse-dmz.suse.de with ESMTPSA id vCilEgr+WmOZagAAMHmgww
 (envelope-from <mwilck@suse.com>); Thu, 27 Oct 2022 21:54:18 +0000
Message-ID: <a9804dc28976efae881d461f3f28b26053c9b381.camel@suse.com>
From: Martin Wilck <mwilck@suse.com>
To: Paul Koetsier <github.com@unicast.nl>, dm-devel@redhat.com
Date: Thu, 27 Oct 2022 23:54:17 +0200
In-Reply-To: <20221027172928.28800-1-github.com@unicast.nl>
References: <20221027172928.28800-1-github.com@unicast.nl>
User-Agent: Evolution 3.46.0
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
Subject: Re: [dm-devel] [PATCH] libmultipath: fix 'show paths format' failure
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
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Thu, 2022-10-27 at 19:29 +0200, Paul Koetsier wrote:
> Prevent 'multipathd show paths format "%c"' from failing on orphan
> paths.
> For orphan paths the checker class isn't set, which caused
> snprint_path_checker() to fail which in turn caused 'show paths
> format' to fail
> when the format string contained "%c".
> ---
> =A0libmultipath/print.c | 8 ++++++--
> =A01 file changed, 6 insertions(+), 2 deletions(-)
>=20

Thanks!

Reviewed-by: Martin Wilck <mwilck@suse.com>

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

