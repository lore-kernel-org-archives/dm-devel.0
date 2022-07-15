Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 423E0C433EF
	for <dm-devel@archiver.kernel.org>; Fri, 15 Jul 2022 07:34:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1657870458;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=IL6aIdDzOGP9AMYgVrcGuXnjuiu08TEacObv3e0YpOc=;
	b=O5llH7nFBL5VHxOQnE1nOgfww+VT0rRbZi7Fo+ktD1l+HrcEwvSLXwwIq1Casmuc1CAIfs
	ZW0OhJW2JhOlY2kUG1e4dTI2kvvP12Bjc3BsYTHOLupqJQDYus4ru9HP9IZb4BboYgLjOP
	FocZSRyXGLol3S8ktl2/LTZ//AH+Rfg=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-644-cN0eyHoQP3mD8tZu1SYc4Q-1; Fri, 15 Jul 2022 03:34:08 -0400
X-MC-Unique: cN0eyHoQP3mD8tZu1SYc4Q-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id F0FE8805AF5;
	Fri, 15 Jul 2022 07:34:05 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id A65A940E8B04;
	Fri, 15 Jul 2022 07:34:05 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 6F6EA1947071;
	Fri, 15 Jul 2022 07:34:05 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id C0D3519466DF
 for <dm-devel@listman.corp.redhat.com>; Fri, 15 Jul 2022 07:34:03 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id A4DF540315D; Fri, 15 Jul 2022 07:34:03 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id A1060492C3B
 for <dm-devel@redhat.com>; Fri, 15 Jul 2022 07:34:03 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 87FCD80A0B9
 for <dm-devel@redhat.com>; Fri, 15 Jul 2022 07:34:03 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-661-pKsnYKLlNNeFyvmlgyuwJg-1; Fri, 15 Jul 2022 03:33:59 -0400
X-MC-Unique: pKsnYKLlNNeFyvmlgyuwJg-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out2.suse.de (Postfix) with ESMTPS id 690C01F8D1;
 Fri, 15 Jul 2022 07:33:57 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 384DE13754;
 Fri, 15 Jul 2022 07:33:57 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap2.suse-dmz.suse.de with ESMTPSA id 4Y0KDGUY0WLtDQAAMHmgww
 (envelope-from <mwilck@suse.com>); Fri, 15 Jul 2022 07:33:57 +0000
Message-ID: <5c7214e75574c6c380261464f92c791ab1ad371d.camel@suse.com>
From: Martin Wilck <mwilck@suse.com>
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
Date: Fri, 15 Jul 2022 09:33:56 +0200
In-Reply-To: <3ddb4a30-b478-7d34-9e55-45b0560da2cc@gmail.com>
References: <20220714190540.117283-1-xose.vazquez@gmail.com>
 <5a3b7d5920baa0d4a967f000b3b1ea61b16cbd69.camel@suse.com>
 <3ddb4a30-b478-7d34-9e55-45b0560da2cc@gmail.com>
User-Agent: Evolution 3.44.2
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
Subject: Re: [dm-devel] [PATCH 0/2] multipath-tools: update docs
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
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
 DM-DEVEL ML <dm-devel@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Fri, 2022-07-15 at 01:09 +0200, Xose Vazquez Perez wrote:
> On 7/14/22 21:38, Martin Wilck wrote:
>=20
> > On Thu, 2022-07-14 at 21:05 +0200, Xose Vazquez Perez wrote:
> > > Xose Vazquez Perez (2):
> > > =A0=A0 multipath-tools: update devel repo info in README.md
> > > =A0=A0 multipath-tools: delete README.alua
> >=20
> > Why complete delete it?
>=20
> It was written five years ago, and now maybe it is
> outdated/irrelevant.
> Three options were provided; let it be, delete it, or move the info
> to README.md
> Treat it like rfc.

For now, I'd move the information to README.md.

It clearly identifies the devices it's talking about. Sure, there
have been several generations of firmware updates since then, and
ALUA support is now mainstream on both the storage and host side.
But it also recommends to consult the storage documentation.
So, I believe keeping it won't hurt.

Perhaps we should just delete the sentence "usually it's disabled by
default"?

Martin

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

