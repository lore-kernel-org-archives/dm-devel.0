Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 30EEAC77B75
	for <dm-devel@archiver.kernel.org>; Mon, 22 May 2023 16:11:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1684771892;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=g33f+z5NOC4ftXIGy3KR9XGttEhRxshuMwFB5m0sDYA=;
	b=DmKsySWmi4ZqeBgrwFeFnC9iGxmDLZSDnMm9Jui7n+SWUF/rAmvuijcCLJzqMhUZbdKBtH
	SDBpwG+tvQLk/MM+aoSbNrFM+yl0ae6hiiNemTmTLuHXeKWIa5GGRym1V1B+PjMZ3q6Njl
	mftf7RzV+l7pQPx5ts4QpZdYY5M49/s=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-517-xQ12NPlHMnaqomDdm48ILQ-1; Mon, 22 May 2023 12:11:29 -0400
X-MC-Unique: xQ12NPlHMnaqomDdm48ILQ-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AE63B185A78E;
	Mon, 22 May 2023 16:11:27 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 57E6440107B;
	Mon, 22 May 2023 16:11:25 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 02AF319465A0;
	Mon, 22 May 2023 16:11:25 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 1AE871946595
 for <dm-devel@listman.corp.redhat.com>; Mon, 22 May 2023 16:11:24 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id E811420296C8; Mon, 22 May 2023 16:11:18 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id E0B9420296C6
 for <dm-devel@redhat.com>; Mon, 22 May 2023 16:11:18 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C584B101B043
 for <dm-devel@redhat.com>; Mon, 22 May 2023 16:11:18 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-202-47tuMdX-NGG5I6mhVSJi_A-1; Mon,
 22 May 2023 12:11:16 -0400
X-MC-Unique: 47tuMdX-NGG5I6mhVSJi_A-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out2.suse.de (Postfix) with ESMTPS id 0864B1FF8A;
 Mon, 22 May 2023 16:11:15 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id D4B8113336;
 Mon, 22 May 2023 16:11:14 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap2.suse-dmz.suse.de with ESMTPSA id xe1kMiKUa2TbWQAAMHmgww
 (envelope-from <mwilck@suse.com>); Mon, 22 May 2023 16:11:14 +0000
Message-ID: <d0c9a2ca3ee3e66a151dd17ab9623d0701e2924e.camel@suse.com>
From: Martin Wilck <mwilck@suse.com>
To: "Dmitry V. Levin" <ldv@strace.io>
Date: Mon, 22 May 2023 18:11:14 +0200
In-Reply-To: <20230522104947.GA2575@altlinux.org>
References: <20230519223356.GA32042@altlinux.org>
 <d5c31607bd92583c8a487e74bd43542b6d7f1a70.camel@suse.com>
 <20230522104947.GA2575@altlinux.org>
User-Agent: Evolution 3.48.1
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
Subject: Re: [dm-devel] [PATCH] 11-dm-mpath.rules: fix warnings reported by
 udevadm verify
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
Cc: dm-devel@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: suse.com
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Mon, 2023-05-22 at 13:49 +0300, Dmitry V. Levin wrote:
> On Mon, May 22, 2023 at 12:19:04PM +0200, Martin Wilck wrote:
> > On Sat, 2023-05-20 at 01:33 +0300, Dmitry V. Levin wrote:
> > > Fix the following warnings reported by udevadm verify:
> > >=20
> > > multipath/11-dm-mpath.rules:18 Whitespace after comma is
> > > expected.
> > > multipath/11-dm-mpath.rules:73 Whitespace after comma is
> > > expected.
> > > multipath/11-dm-mpath.rules:73 Whitespace after comma is
> > > expected.
> > > multipath/11-dm-mpath.rules:78 Whitespace after comma is
> > > expected.
> > > multipath/11-dm-mpath.rules:78 Whitespace after comma is
> > > expected.
> > > multipath/11-dm-mpath.rules:78 Whitespace after comma is
> > > expected.
> > > multipath/11-dm-mpath.rules: udev rules check failed
> > >=20
> > > Signed-off-by: Dmitry V. Levin <ldv@strace.io>
> >=20
> > Maybe you should have mentioned that you've just invented this
> > syntax
> > rule yourself (https://github.com/systemd/systemd/pull/26980).
> > I see no requirement for adding whitespace after a comma in the
> > udev
> > man page.=A0
> >=20
> > Is this an attempt to change the udev rule syntax retroactively?
>=20
> As you probably know, udevd silently accepts much broader syntax, for
> example, it doesn't need neither comma no whitespace between
> KEY=3DVALUE
> expressions, and I doubt this will ever change in the future.

Ok, that answers what I was asking. Thanks. Btw I did not know that
commas could be left out, I found out while I looked into this issue.

> In contrast, `udevadm verify` is a tool that checks syntactic,
> semantic,
> and style correctness of udev rules files.=A0=A0

So this is about style and readability. Fair enough. It would have been
nice to mention that in the commit message.

> It indeed expects whitespace
> after a comma in udev rules - a style most of existing udev rules
> follow.

The multipath-tools rules do, too; they just don't add whitespace
between the comma and the line continuation marker '\'.

> but most of existing udev rules add whitespace
> between a comma and a backslash.

I see. I'll apply this patch then (and the other one with the missing
comma, too), but unless you object, I'll add a note to the
commit message explaining that this for improving readability=20
and coding style compliance. I want to avoid the impression that the
existing code is technically wrong, which it isn't.

Reviewed-by: Martin Wilck <mwilck@suse.com>

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

