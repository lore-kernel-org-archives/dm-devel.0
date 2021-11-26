Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 44647C433EF
	for <dm-devel@archiver.kernel.org>; Fri, 26 Nov 2021 16:30:40 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-63-SdJuihhQObmNeERfk4AfnA-1; Fri, 26 Nov 2021 11:30:35 -0500
X-MC-Unique: SdJuihhQObmNeERfk4AfnA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0665B80BCA8;
	Fri, 26 Nov 2021 16:30:31 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id F3EEA5F4E1;
	Fri, 26 Nov 2021 16:30:29 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 45A2B1809C89;
	Fri, 26 Nov 2021 16:30:29 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
	[10.11.54.2])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1AQGURf7029358 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 26 Nov 2021 11:30:27 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 2EA12404727A; Fri, 26 Nov 2021 16:30:27 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 2AD1A4047272
	for <dm-devel@redhat.com>; Fri, 26 Nov 2021 16:30:27 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1259E106655B
	for <dm-devel@redhat.com>; Fri, 26 Nov 2021 16:30:27 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-402-mqB3x6E0P2m2OZ43KTxTNQ-1; Fri, 26 Nov 2021 11:30:25 -0500
X-MC-Unique: mqB3x6E0P2m2OZ43KTxTNQ-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id F31361FC9E;
	Fri, 26 Nov 2021 16:30:23 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id A75DE13C69;
	Fri, 26 Nov 2021 16:30:23 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA id GMbDJp8LoWHZBwAAMHmgww
	(envelope-from <mwilck@suse.com>); Fri, 26 Nov 2021 16:30:23 +0000
Message-ID: <3bd43e3c784fa97e4c590b21e690a41bc0a91d81.camel@suse.com>
From: Martin Wilck <mwilck@suse.com>
To: lixiaokeng <lixiaokeng@huawei.com>, Christophe Varoqui
	<christophe.varoqui@opensvc.com>, Benjamin Marzinski <bmarzins@redhat.com>,
	dm-devel mailing list <dm-devel@redhat.com>
Date: Fri, 26 Nov 2021 17:30:23 +0100
In-Reply-To: <e587e49b-1bb6-2943-b65e-85fb31fe936f@huawei.com>
References: <e587e49b-1bb6-2943-b65e-85fb31fe936f@huawei.com>
User-Agent: Evolution 3.42.1
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 1AQGURf7029358
X-loop: dm-devel@redhat.com
Cc: linfeilong <linfeilong@huawei.com>,
	"liuzhiqiang \(I\)" <liuzhiqiang26@huawei.com>
Subject: Re: [dm-devel] [PATCH] remove unuseful MALLOC/REALLOC/STRDUP/FREE
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
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Fri, 2021-11-26 at 16:37 +0800, lixiaokeng wrote:
> Now there are tools such as valgrind and asan to detect memory leaks,
> so it is unnecessary to use _DEBUG_. Remove _DEBUG_ code.
>=20
> Signed-off-by: Lixiaokeng<lixiaokeng@huawei.com>
> ---
> =A0libmpathpersist/mpath_persist.c=A0=A0=A0=A0=A0=A0=A0=A0=A0 |=A0=A0 4 +=
-
> =A0libmpathpersist/mpath_updatepr.c=A0=A0=A0=A0=A0=A0=A0=A0 |=A0=A0 1 -
> =A0libmultipath/Makefile=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0 |=A0=A0 2 +-
> =A0libmultipath/alias.c=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0 |=A0=A0 2 +-
> =A0libmultipath/blacklist.c=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0 |=A0 27 +-
> =A0libmultipath/checkers.c=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0 |=A0=A0 4 +-
> =A0libmultipath/checkers.h=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0 |=A0=A0 4 +-
> =A0libmultipath/checkers/emc_clariion.c=A0=A0=A0=A0 |=A0=A0 3 +-
> =A0libmultipath/config.c=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0 |=A0 85 +++--
> =A0libmultipath/configure.c=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0 |=A0 21 +-
> =A0libmultipath/defaults.c=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0 |=A0=A0 1 -
> =A0libmultipath/defaults.h=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0 |=A0=A0 1 +
> =A0libmultipath/devmapper.c=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0 |=A0 15 +-
> =A0libmultipath/dict.c=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0 |=A0 49 ++-
> =A0libmultipath/discovery.c=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0 |=A0=A0 1 -
> =A0libmultipath/dmparser.c=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0 |=A0 47 ++-
> =A0libmultipath/io_err_stat.c=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 |=
=A0 13 +-
> =A0libmultipath/log.c=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0 |=A0 22 +-
> =A0libmultipath/log_pthread.c=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 |=
=A0=A0 2 -
> =A0libmultipath/memory.c=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0 | 444 -----------------------
> =A0libmultipath/memory.h=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0 |=A0 66 ----
> =A0libmultipath/parser.c=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0 |=A0 25 +-
> =A0libmultipath/pgpolicies.c=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
 |=A0=A0 5 +-
> =A0libmultipath/prio.c=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0 |=A0=A0 4 +-
> =A0libmultipath/prio.h=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0 |=A0=A0 1 -
> =A0libmultipath/prioritizers/path_latency.c |=A0=A0 6 +-
> =A0libmultipath/prioritizers/weightedpath.c |=A0=A0 1 -
> =A0libmultipath/propsel.c=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0 |=A0 11 +-
> =A0libmultipath/structs.c=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0 |=A0 51 ++-
> =A0libmultipath/sysfs.c=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0 |=A0=A0 2 +-
> =A0libmultipath/uevent.c=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0 |=A0 13 +-
> =A0libmultipath/util.c=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0 |=A0=A0 7 +-
> =A0libmultipath/util.h=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0 |=A0=A0 1 +
> =A0libmultipath/uxsock.c=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0 |=A0=A0 5 +-
> =A0libmultipath/vector.c=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0 |=A0 15 +-
> =A0multipath/main.c=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0 |=A0 19 +-
> =A0multipathd/cli.c=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0 |=A0 23 +-
> =A0multipathd/cli.h=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0 |=A0=A0 2 +-
> =A0multipathd/cli_handlers.c=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
 |=A0=A0 7 +-
> =A0multipathd/main.c=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0 |=A0 33 +-
> =A0multipathd/uxclnt.c=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0 |=A0=A0 5 +-
> =A0multipathd/uxlsnr.c=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0 |=A0 17 +-
> =A0multipathd/waiter.c=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0 |=A0=A0 5 +-
> =A0tests/pgpolicy.c=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0 |=A0=A0 1 +
> =A0tests/uevent.c=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0 |=A0=A0 8 +-
> =A045 files changed, 268 insertions(+), 813 deletions(-)
> =A0delete mode 100644 libmultipath/memory.c
> =A0delete mode 100644 libmultipath/memory.h
>=20
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0}
> diff --git a/libmultipath/io_err_stat.c b/libmultipath/io_err_stat.c
> index d8d91f64..b74a9131 100644
> --- a/libmultipath/io_err_stat.c
> +++ b/libmultipath/io_err_stat.c
> @@ -22,9 +22,9 @@
> =A0#include <errno.h>
> =A0#include <sys/mman.h>
> =A0#include <sys/select.h>
> +#include <stdio.h>

AFAICS, this #include is unnecessary.

I'll remove this, apply the change mentioned in my previous post, and
push to the queue branch
(https://github.com/openSUSE/multipath-tools/tree/queue).

Regards
Martin




--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

