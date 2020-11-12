Return-Path: <SRS0=vluQ=ES=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,HTML_MESSAGE,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1DB79C56201
	for <dm-devel@archiver.kernel.org>; Thu, 12 Nov 2020 09:24:22 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 0791E21D40
	for <dm-devel@archiver.kernel.org>; Thu, 12 Nov 2020 09:24:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0791E21D40
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=opensvc.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-595-7-keeDk2OiW9ekBySKah9w-1; Thu, 12 Nov 2020 04:24:16 -0500
X-MC-Unique: 7-keeDk2OiW9ekBySKah9w-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 798BC8031F9;
	Thu, 12 Nov 2020 09:24:10 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 636A55C662;
	Thu, 12 Nov 2020 09:24:08 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 8FF1518199F8;
	Thu, 12 Nov 2020 09:24:00 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0AC9Nwik015692 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 12 Nov 2020 04:23:58 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 442D72156A4C; Thu, 12 Nov 2020 09:23:58 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 3ED272156A49
	for <dm-devel@redhat.com>; Thu, 12 Nov 2020 09:23:55 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D4BF0858290
	for <dm-devel@redhat.com>; Thu, 12 Nov 2020 09:23:55 +0000 (UTC)
Received: from mslow2.mail.gandi.net (mslow2.mail.gandi.net
	[217.70.178.242]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-84-1KdUXT6tOKGnwjSf3gQx1A-1; Thu, 12 Nov 2020 04:23:52 -0500
X-MC-Unique: 1KdUXT6tOKGnwjSf3gQx1A-1
Received: from relay3-d.mail.gandi.net (unknown [217.70.183.195])
	by mslow2.mail.gandi.net (Postfix) with ESMTP id B2C5A3AEC96
	for <dm-devel@redhat.com>; Thu, 12 Nov 2020 09:00:02 +0000 (UTC)
X-Originating-IP: 209.85.166.54
Received: from mail-io1-f54.google.com (mail-io1-f54.google.com
	[209.85.166.54]) (Authenticated sender: smtp@opensvc.com)
	by relay3-d.mail.gandi.net (Postfix) with ESMTPSA id 2A5EA6000F
	for <dm-devel@redhat.com>; Thu, 12 Nov 2020 08:59:58 +0000 (UTC)
Received: by mail-io1-f54.google.com with SMTP id u21so5201842iol.12
	for <dm-devel@redhat.com>; Thu, 12 Nov 2020 00:59:58 -0800 (PST)
X-Gm-Message-State: AOAM532ELTO2rf/+rg++EymDQrbHsHIHc7nkL8HLArWBPxjNOr2F4lgq
	3kAYHz7UTJtZrtcN7O3mr9oz8T5d9psErKuQILI=
X-Google-Smtp-Source: ABdhPJwYo14qUfOpRKtYfZFx541uhdGVdbRN0k2EM4GGQCjfUhCAU47GuSkkxVe6HqQZsgjkfPGfyBBrkBvhfj/days=
X-Received: by 2002:a02:883:: with SMTP id 125mr12016993jac.30.1605171597721; 
	Thu, 12 Nov 2020 00:59:57 -0800 (PST)
MIME-Version: 1.0
From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Date: Thu, 12 Nov 2020 09:59:46 +0100
X-Gmail-Original-Message-ID: <CABr-GncX_v92i5x39sS1w9=8Vf18bDu+Nb1NVznSzjz+DYoGdg@mail.gmail.com>
Message-ID: <CABr-GncX_v92i5x39sS1w9=8Vf18bDu+Nb1NVznSzjz+DYoGdg@mail.gmail.com>
To: device-mapper development <dm-devel@redhat.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-loop: dm-devel@redhat.com
Subject: [dm-devel] multipath-tool 0.8.5 release
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/mixed; boundary="===============8658318627486163889=="

--===============8658318627486163889==
Content-Type: multipart/alternative; boundary="000000000000e2ca0805b3e522cd"

--000000000000e2ca0805b3e522cd
Content-Type: text/plain; charset="UTF-8"

The multipath-tool 0.8.5 release is now available.

Starting with this release, the project upstream git is now
https://github.com/opensvc/multipath-tools

This page shows the updated usage and contribution guidelines.

The repository at https://git.opensvc.com is also at 0.8.5, but will no
longer be updated. It is scheduled for removal early 2021.

This new organisation should allow us to release at least quarterly from
now on.

Best regards,
Christophe

--000000000000e2ca0805b3e522cd
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">The=C2=A0multipath-tool 0.8.5 release is now available.<di=
v><br></div><div>Starting with this release, the project upstream git is no=
w <a href=3D"https://github.com/opensvc/multipath-tools">https://github.com=
/opensvc/multipath-tools</a></div><div><br></div><div>This page shows the u=
pdated usage and contribution guidelines.</div><div><br></div><div>The repo=
sitory at <a href=3D"https://git.opensvc.com">https://git.opensvc.com</a> i=
s also at 0.8.5, but will no longer be updated. It is scheduled for removal=
 early 2021.</div><div><br></div><div>This new organisation should allow us=
 to release at least quarterly from now on.</div><div><br></div><div>Best r=
egards,</div><div>Christophe</div></div>

--000000000000e2ca0805b3e522cd--

--===============8658318627486163889==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel
--===============8658318627486163889==--

