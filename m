Return-Path: <SRS0=4utB=KI=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E708C433B4
	for <dm-devel@archiver.kernel.org>; Thu, 13 May 2021 19:49:14 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 049486143C
	for <dm-devel@archiver.kernel.org>; Thu, 13 May 2021 19:49:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 049486143C
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-334-EKjAOnQiOQ63sHpXnv-7Xg-1; Thu, 13 May 2021 15:49:10 -0400
X-MC-Unique: EKjAOnQiOQ63sHpXnv-7Xg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 69DFA192780E;
	Thu, 13 May 2021 19:49:06 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 0517D63BA7;
	Thu, 13 May 2021 19:49:06 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 76C0318005B6;
	Thu, 13 May 2021 19:49:05 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 14DJn4hT019344 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 13 May 2021 15:49:04 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id ED9C7206356F; Thu, 13 May 2021 19:49:03 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id E90F92063563
	for <dm-devel@redhat.com>; Thu, 13 May 2021 19:49:00 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 96C5485828E
	for <dm-devel@redhat.com>; Thu, 13 May 2021 19:49:00 +0000 (UTC)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-373-OMk1I728NbabgYMSB8F2Tw-1;
	Thu, 13 May 2021 15:48:57 -0400
X-MC-Unique: OMk1I728NbabgYMSB8F2Tw-1
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
	by mx2.suse.de (Postfix) with ESMTP id 68CB2B133;
	Thu, 13 May 2021 19:48:55 +0000 (UTC)
Message-ID: <0e13bbc731e9eb1081126fb43bed0293c9bda5c3.camel@suse.com>
From: Martin Wilck <mwilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>
Date: Thu, 13 May 2021 21:48:54 +0200
In-Reply-To: <20210513163559.GI25887@octiron.msp.redhat.com>
References: <20210512211705.31561-1-mwilck@suse.com>
	<20210513163559.GI25887@octiron.msp.redhat.com>
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
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 14DJn4hT019344
X-loop: dm-devel@redhat.com
Cc: dm-devel@redhat.com
Subject: Re: [dm-devel] [PATCH] multipathd: fix compilation issue with
	liburcu < 0.8
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Thu, 2021-05-13 at 11:35 -0500, Benjamin Marzinski wrote:
> >=20
> > diff --git a/multipathd/Makefile b/multipathd/Makefile
> > index d053c1e..dc7eb32 100644
> > --- a/multipathd/Makefile
> > +++ b/multipathd/Makefile
> > @@ -16,6 +16,8 @@ LDFLAGS +=3D $(BIN_LDFLAGS)
> > =A0LIBDEPS +=3D -L$(multipathdir) -lmultipath -L$(mpathpersistdir) -
> > lmpathpersist \
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 -L$(mpathcmddir) -lmpathcmd -ludev -ldl =
-lurcu -lpthread
> > \
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 -ldevmapper -lreadline
> > +CFLAGS +=3D $(shell pkg-config --modversion liburcu 2>/dev/null | \
> > +=A0=A0=A0=A0=A0=A0=A0awk -F. '{ printf("-DURCU_VERSION=3D0x%06x\n", 25=
6 * ( 256 *
> > $$1 + $$2) + $$3); }')
>=20
> Shouldn't this be
>=20
> $(shell $(PKGCONFIG) --modversion ...

Thanks for spotting that.

Martin






--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

