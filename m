Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 636E6C433EF
	for <dm-devel@archiver.kernel.org>; Wed, 18 May 2022 06:54:07 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-391-eFqlaL0EPiScTMyDuaKavw-1; Wed, 18 May 2022 02:54:05 -0400
X-MC-Unique: eFqlaL0EPiScTMyDuaKavw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A07AE800B21;
	Wed, 18 May 2022 06:54:03 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id BBCFD40C1421;
	Wed, 18 May 2022 06:54:00 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 843F51947B8E;
	Wed, 18 May 2022 06:54:00 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 5DDD31947B84
 for <dm-devel@listman.corp.redhat.com>; Wed, 18 May 2022 06:54:00 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 3A5CB40CF8F6; Wed, 18 May 2022 06:54:00 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 3591840CF8EE
 for <dm-devel@redhat.com>; Wed, 18 May 2022 06:54:00 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1D4D9185A79C
 for <dm-devel@redhat.com>; Wed, 18 May 2022 06:54:00 +0000 (UTC)
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-221-ZFKVbH85Pom6uZf5YnU9ig-1; Wed, 18 May 2022 02:53:58 -0400
X-MC-Unique: ZFKVbH85Pom6uZf5YnU9ig-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out1.suse.de (Postfix) with ESMTPS id 2819921B9B;
 Wed, 18 May 2022 06:53:57 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id C215E13A6D;
 Wed, 18 May 2022 06:53:56 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap2.suse-dmz.suse.de with ESMTPSA id g60kLQSYhGKXPwAAMHmgww
 (envelope-from <mwilck@suse.com>); Wed, 18 May 2022 06:53:56 +0000
Message-ID: <60c1def627811b09f81d1d9a7fafd861144ffb81.camel@suse.com>
From: Martin Wilck <mwilck@suse.com>
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
Date: Wed, 18 May 2022 08:53:56 +0200
In-Reply-To: <20220514230431.139763-1-xose.vazquez@gmail.com>
References: <20220514230431.139763-1-xose.vazquez@gmail.com>
User-Agent: Evolution 3.44.1
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
Subject: Re: [dm-devel] [PATCH 0/9] add new devices to hw table
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
Cc: Zou Ming <zouming.zouming@huawei.com>,
 Uday Shankar <ushankar@purestorage.com>,
 NetApp RDAC team <ng-eseries-upstream-maintainers@netapp.com>,
 DM-DEVEL ML <dm-devel@redhat.com>, Brian Bunker <brian@purestorage.com>,
 Christophe Varoqui <christophe.varoqui@opensvc.com>,
 Zhouweigang <zhouweigang09@huawei.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Sun, 2022-05-15 at 01:04 +0200, Xose Vazquez Perez wrote:
> Xose Vazquez Perez (9):
> =A0 multipath-tools: fix misspellings
> =A0 multipath-tools: add HPE Alletra 9000 NVMe to hardware table
> =A0 multipath-tools: delete redundant ONTAP NVMe comment
> =A0 multipath-tools: add NetApp E-Series NVMe to hardware table
> =A0 multipath-tools: add Huawei OceanStor NVMe to hardware table
> =A0 multipath-tools: add IBM FlashSystem(TMS RamSan) NVMe to hardware
> table
> =A0 multipath-tools: add IBM FlashSystem(Storwize/SVC) NVMe to hardware
> table
> =A0 multipath-tools: add Pure FlashArray NVMe to hardware table
> =A0 multipath-tools: add Dell EMC PowerStore NVMe to hardware table
>=20
> =A0README.md=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0 |=A0 2 +-
> =A0libmultipath/checkers/rdac.c=A0=A0=A0 |=A0 2 +-
> =A0libmultipath/hwtable.c=A0=A0=A0=A0=A0=A0=A0=A0=A0 | 60 +++++++++++++++=
+++++++++++++++-
> --
> =A0libmultipath/prioritizers/iet.c |=A0 2 +-
> =A0multipath/multipath.conf.5=A0=A0=A0=A0=A0 |=A0 2 +-
> =A0tests/directio.c=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 |=A0 2 +=
-
> =A06 files changed, 60 insertions(+), 10 deletions(-)
>=20
> Cc: NetApp RDAC team <ng-eseries-upstream-maintainers@netapp.com>
> Cc: Uday Shankar <ushankar@purestorage.com>
> Cc: Brian Bunker <brian@purestorage.com>
> Cc: Zhouweigang (Jack) <zhouweigang09@huawei.com>
> Cc: Zou Ming <zouming.zouming@huawei.com>
> Cc: Martin Wilck <mwilck@suse.com>
> Cc: Benjamin Marzinski <bmarzins@redhat.com>
> Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
> Cc: DM-DEVEL ML <dm-devel@redhat.com>

For the set:=A0
Reviewed-by: Martin Wilck <mwilck@suse.com>

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

