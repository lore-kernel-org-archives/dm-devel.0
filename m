Return-Path: <SRS0=eE7R=JJ=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A27F9C43460
	for <dm-devel@archiver.kernel.org>; Mon, 12 Apr 2021 08:05:37 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 2548661209
	for <dm-devel@archiver.kernel.org>; Mon, 12 Apr 2021 08:05:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2548661209
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-600-i3EsHjlyOKCdf9HrfFXU_g-1; Mon, 12 Apr 2021 04:05:33 -0400
X-MC-Unique: i3EsHjlyOKCdf9HrfFXU_g-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 445355B378;
	Mon, 12 Apr 2021 08:05:29 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 0DA535C559;
	Mon, 12 Apr 2021 08:05:29 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id CBA9918095C9;
	Mon, 12 Apr 2021 08:05:26 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 13C85OIj017589 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 12 Apr 2021 04:05:25 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id CCE322182DDE; Mon, 12 Apr 2021 08:05:24 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id C72612182DD5
	for <dm-devel@redhat.com>; Mon, 12 Apr 2021 08:05:21 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 09DF385A5B5
	for <dm-devel@redhat.com>; Mon, 12 Apr 2021 08:05:21 +0000 (UTC)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-363-vlDkXugtOhyL8sqaoYviwg-1;
	Mon, 12 Apr 2021 04:05:16 -0400
X-MC-Unique: vlDkXugtOhyL8sqaoYviwg-1
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
	by mx2.suse.de (Postfix) with ESMTP id D8A02AE27;
	Mon, 12 Apr 2021 08:05:14 +0000 (UTC)
Message-ID: <d285fe1145c70fbfa6310e30e9c43bdcecb04c70.camel@suse.com>
From: Martin Wilck <mwilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>, lixiaokeng
	<lixiaokeng@huawei.com>
Date: Mon, 12 Apr 2021 10:05:14 +0200
In-Reply-To: <20210409145907.GB20773@octiron.msp.redhat.com>
References: <bdc30cf9-dcc6-dedb-dead-2aa3db6e25b4@huawei.com>
	<20210409145907.GB20773@octiron.msp.redhat.com>
User-Agent: Evolution 3.38.4
MIME-Version: 1.0
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 13C85OIj017589
X-loop: dm-devel@redhat.com
Cc: dm-devel, list <dm-devel@redhat.com>, linfeilong <linfeilong@huawei.com>,
	"liuzhiqiang \(I\)" <liuzhiqiang26@huawei.com>
Subject: Re: [dm-devel] [PATCH] libmultipath: fix memory leak in
	checker_cleanup_thread
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Fri, 2021-04-09 at 09:59 -0500, Benjamin Marzinski wrote:
> On Fri, Apr 09, 2021 at 03:15:05PM +0800, lixiaokeng wrote:
> > If checker_cleanup_thread is called after cleanup_checkers,
> > the checker_class will not be freed.
> >=20
> > Here, we use free_checker_class instead of checker_class_unref
> > in checker_cleanup_thread.
> >=20
> > Signed-off-by: Lixiaokeng <lixiaokeng@huawei.com>
> > ---
> > =A0libmultipath/checkers.c | 2 +-
> > =A01 file changed, 1 insertion(+), 1 deletion(-)
> >=20
> > diff --git a/libmultipath/checkers.c b/libmultipath/checkers.c
> > index 2dd9915d..7cc80f0b 100644
> > --- a/libmultipath/checkers.c
> > +++ b/libmultipath/checkers.c
> > @@ -368,7 +368,7 @@ static void checker_cleanup_thread(void *arg)
> > =A0{
> > =A0=A0=A0=A0=A0=A0=A0=A0struct checker_class *cls =3D arg;
> >=20
> > -=A0=A0=A0=A0=A0=A0=A0(void)checker_class_unref(cls);
> > +=A0=A0=A0=A0=A0=A0=A0(void)free_checker_class(cls);
> > =A0=A0=A0=A0=A0=A0=A0=A0rcu_unregister_thread();
> > =A0}
> >=20
> > --=20
>=20
> Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
>=20

Nit: The cast to void is wrong, as free_checker_class() is a void
function anyway. I'll take the freedom to remove it when I apply this
to the "queue" branch.

Thanks,
Martin

Reviewed-by: Martin Wilck <mwilck@suse.com>






--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

