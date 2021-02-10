Return-Path: <SRS0=/g2B=HM=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 605EEC433E6
	for <dm-devel@archiver.kernel.org>; Wed, 10 Feb 2021 14:19:06 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id B1A2264E7C
	for <dm-devel@archiver.kernel.org>; Wed, 10 Feb 2021 14:19:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B1A2264E7C
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-133-5q0JV9iyOgyQGbg12FwLZg-1; Wed, 10 Feb 2021 09:19:01 -0500
X-MC-Unique: 5q0JV9iyOgyQGbg12FwLZg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EFC371005501;
	Wed, 10 Feb 2021 14:18:55 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 19C4919C44;
	Wed, 10 Feb 2021 14:18:55 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 6059857DFA;
	Wed, 10 Feb 2021 14:18:54 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 11AEIqm5023876 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 10 Feb 2021 09:18:52 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 5ABAD2166B2F; Wed, 10 Feb 2021 14:18:52 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 55ABC2166B2E
	for <dm-devel@redhat.com>; Wed, 10 Feb 2021 14:18:49 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DA2E8811760
	for <dm-devel@redhat.com>; Wed, 10 Feb 2021 14:18:49 +0000 (UTC)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-313-BoAHt8wIPDq3SJjLd8pCDA-1;
	Wed, 10 Feb 2021 09:18:45 -0500
X-MC-Unique: BoAHt8wIPDq3SJjLd8pCDA-1
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
	by mx2.suse.de (Postfix) with ESMTP id 129E3AB98;
	Wed, 10 Feb 2021 14:18:44 +0000 (UTC)
Message-ID: <9514cd1dfe58cddc1146601b17835cbbd67bdd6e.camel@suse.com>
From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, Benjamin Marzinski
	<bmarzins@redhat.com>
Date: Wed, 10 Feb 2021 15:18:43 +0100
In-Reply-To: <20210210122457.3415-1-mwilck@suse.com>
References: <20210210122457.3415-1-mwilck@suse.com>
User-Agent: Evolution 3.38.2
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 11AEIqm5023876
X-loop: dm-devel@redhat.com
Cc: dm-devel@redhat.com
Subject: Re: [dm-devel] [PATCH] multipath-tools tests: fix stringop-overflow
 build errors with gcc 11
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Wed, 2021-02-10 at 13:24 +0100, mwilck@suse.com wrote:
> From: Martin Wilck <mwilck@suse.com>
>=20
> gcc-11 throws an error compiling alias.c and dmevents.c:
>=20
> In file included from ../libmultipath/checkers.h:4,
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 from ../libmultipath/pri=
o.h:7,
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 from ../libmultipath/str=
ucts.h:8,
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 from dmevents.c:29:
> ../multipathd/dmevents.c: In function 'dmevent_loop':
> ../multipathd/dmevents.c:357:17: error: '__sigsetjmp' accessing 200
> bytes in a region of size 72 [-Werror=3Dstringop-overflow=3D]
> =A0 357 |=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 pthread_cleanup=
_push(cleanup_lock, &waiter-
> >vecs->lock);
> =A0=A0=A0=A0=A0 |=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 ^~~~~~~=
~~~~~~~~~~~~~
> ../multipathd/dmevents.c:357:17: note: referencing argument 1 of type
> 'struct __jmp_buf_tag *'
> /usr/include/pthread.h:734:12: note: in a call to function
> '__sigsetjmp'
> =A0 734 | extern int __sigsetjmp (struct __jmp_buf_tag *__env, int
> __savemask) __THROWNL;
> =A0=A0=A0=A0=A0 |=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 ^~~~~~~~~~~
>=20
> The reason seems to be a mismatch between the __sigsetjmp() prototype
> in <setjmp.h> and <pthread.h>. Until this is fixed in the toolchain,
> work around it by including <pthread.h> first.
>=20
> Signed-off-by: Martin Wilck <mwilck@suse.com>

I'm told that this issue is related to this glibc bug:
https://sourceware.org/bugzilla/show_bug.cgi?id=3D26647

and should be fixed in glibc 2.33. Yet adding this patch doesn't hurt
us and can serve as a workaround for environments with gcc 11.

Regards
Martin



--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

