Return-Path: <SRS0=qllc=KC=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4882CC433B4
	for <dm-devel@archiver.kernel.org>; Fri,  7 May 2021 15:20:52 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id BA1B361460
	for <dm-devel@archiver.kernel.org>; Fri,  7 May 2021 15:20:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BA1B361460
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1620400850;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=GKHUocj6Q/WR4LwwESq1CYi7h+fug0BjSJKornI1axI=;
	b=BMTWEo4TA2G0QOVUTf/N9/WmVhi65PbdoosrNAzKjB1WWn5jp1P+06s++aipCFvFmyGA2u
	5g2iFM7VMMGWE2C2vXBPteDX/0YnMBxGhnGckR5Rn3kX1C4TQykQoN1gS7dzJQYotL3i0X
	f8t/TH4nRw213Fnk+qf/gZp5oJ83R60=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-245-Rw7foTniOnaOjOw0RtrSfg-1; Fri, 07 May 2021 11:20:48 -0400
X-MC-Unique: Rw7foTniOnaOjOw0RtrSfg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E2191801817;
	Fri,  7 May 2021 15:20:42 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 5A98036E0;
	Fri,  7 May 2021 15:20:41 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id A20C21800BB4;
	Fri,  7 May 2021 15:20:38 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 147FKaEI028495 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 7 May 2021 11:20:36 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id E856F217E43D; Fri,  7 May 2021 15:20:35 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id E3F2B216FD22
	for <dm-devel@redhat.com>; Fri,  7 May 2021 15:20:32 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9F9171857F2F
	for <dm-devel@redhat.com>; Fri,  7 May 2021 15:20:32 +0000 (UTC)
Received: from mail-qk1-f175.google.com (mail-qk1-f175.google.com
	[209.85.222.175]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-140-u_qtJu4iPy6e7MgHRHzI4g-1; Fri, 07 May 2021 11:20:28 -0400
X-MC-Unique: u_qtJu4iPy6e7MgHRHzI4g-1
Received: by mail-qk1-f175.google.com with SMTP id q10so4606140qkc.5;
	Fri, 07 May 2021 08:20:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
	:references:mime-version:content-disposition
	:content-transfer-encoding:in-reply-to;
	bh=vYrZM9ZAKhNoCCMKkkXordTzKuq5pch80jNXBzTUZaU=;
	b=VxiqyYQhQiuW7zs677pZQtR8wnV4d3tEwB8kuLU450Uvy3N33n2YLqRezuaQhsWPPt
	DBSa5OnKhSLrLZaViZfJtFNbCjiGZTJrvTmsNb+p/MJ+lyQsYxRSATxe2jQ2HxQeLtbC
	ErRtuhUZfo/HSSSlcDLGLxFby4/ResvkMBxZEcnVn69PXFZgBwaS0e0I6LO9Za2ZQUDL
	OKcx9IF5fNhCN4opIioBbwSzu+jH9m0okoTS6vuOC73TFiqYXjMHi5SQxiJBqMpNCFJp
	MKsUlx5Zjrao4hkPrXhcT/lQQ0JFeLRUIzvBESfTJtMl/z79NiuF4sLRY9dNOFjWwVhV
	2MfA==
X-Gm-Message-State: AOAM532FPp/oXsQdcX/bx1Vt5vyaHyGyvRjxzRC9u+Jk9xV6KUEvYSqZ
	mFEhvU/YvqnEuCWVFNQP3/8t3y9qQ9k=
X-Google-Smtp-Source: ABdhPJxToSoGPgFWEfMeyDdp9m8ypVfbQQPz3pqXMPGsDn4+2yZR/8DAnb4/Vd57A7sTg8EOMa5mgg==
X-Received: by 2002:a37:8744:: with SMTP id j65mr10771093qkd.304.1620400826953;
	Fri, 07 May 2021 08:20:26 -0700 (PDT)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net.
	[68.160.176.52]) by smtp.gmail.com with ESMTPSA id
	n15sm5030276qti.51.2021.05.07.08.20.25
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Fri, 07 May 2021 08:20:25 -0700 (PDT)
Date: Fri, 7 May 2021 11:20:25 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: Michael Tokarev <mjt@tls.msk.ru>
Message-ID: <YJVauS60BjSFkW9/@redhat.com>
References: <7104c94c-7408-0d58-ddd9-384102e820bc@msgid.tls.msk.ru>
	<6a71df25-d1fb-db02-ff55-384ba0828647@redhat.com>
	<84eaa68f-3ea3-8313-2953-46375dce9f86@msgid.tls.msk.ru>
MIME-Version: 1.0
In-Reply-To: <84eaa68f-3ea3-8313-2953-46375dce9f86@msgid.tls.msk.ru>
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
Cc: dm-devel@redhat.com, Zdenek Kabelac <zkabelac@redhat.com>
Subject: Re: [dm-devel] can we fix some dm snapshot crashes please? :)
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Fri, May 07 2021 at 10:10P -0400,
Michael Tokarev <mjt@tls.msk.ru> wrote:

> 07.05.2021 15:31, Zdenek Kabelac wrote:
> > Dne 07. 05. 21 v 12:31 Michael Tokarev napsal(a):
> ...
> > > =A0=A0sz=3D$(blockdev --getsize /dev/loop0)
> > > =A0=A0dmsetup create base --table "0 $sz snapshot-origin /dev/loop0"
> > > =A0=A0# and now the crash
> > > =A0=A0mkfs.ext4 /dev/mapper/base
>=20
> > Yes reproducible - can you please open BZ report here:
> >=20
> > https://bugzilla.redhat.com/enter_bug.cgi?product=3DLVM%20and%20device-=
mapper
>=20
> Ok, will do, thanks!

Thanks.  But when you do, please tone down the lamenting of how slow
snapshot crashes have been fixed -- or don't.  But that line of
rhetoric shows you're full of it.

> > I assume you are aware you are trying to using snapshot target in wrong=
 way,
> > but it should not be crashing kernel.
>=20
> Actually I'm not aware about the wrong way. The documentation is a bit la=
cking
> in this area. There are a few (maybe 2 or 3) guides describing the steps =
to do,
> most involves first using an 1:1 linear table, next replacing it on-the-f=
ly with
> snapshot-origin table, but nowhere it is told that I can't create snapsho=
t-origin
> directly, or that I need at least one snapshot device, or that the origin=
 of the
> snapshot-origin table should be a dm device, or many many other variation=
s.
>=20
> I just tried to create a snapshot to be able to revert changes if somethi=
ng goes
> wrong, and since I don't use lvm I thought that plain dmsetup should do, =
but
> discovered that it doesn't quite work and it actually is a dangerous thin=
g to use.. :)

Yes, it is dangerous to stab in the dark like you clearly are doing.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

