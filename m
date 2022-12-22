Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EE523C4332F
	for <dm-devel@archiver.kernel.org>; Thu, 22 Dec 2022 14:23:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1671718993;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=KQUHKWVL+YGjgqK9rmdPz87OFFHifhcEVocpddVi4fg=;
	b=P9WzQPe4BMD7HXOn4470TOaSktx6ROGGDTJowGEccBq7tWFyUdInkANvBe9IWGGBKcwxsg
	CgDMJ6o7Eghmvr0GV8OKp2Ysi7HXMnpyqaZ81LaEdvr2ICBhpjMMO1OzViCfif8OxJPw5B
	xIGo1EKWc1te1F8Hs4dx0NwJvys508Y=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-14-HKe3h9H5MhG02K-riCuArg-1; Thu, 22 Dec 2022 09:23:10 -0500
X-MC-Unique: HKe3h9H5MhG02K-riCuArg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C695085A588;
	Thu, 22 Dec 2022 14:23:08 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 3E1312026D4B;
	Thu, 22 Dec 2022 14:23:06 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id EE29F19465B1;
	Thu, 22 Dec 2022 14:23:05 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id BA2E819465A8
 for <dm-devel@listman.corp.redhat.com>; Thu, 22 Dec 2022 14:23:04 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 991562166B2B; Thu, 22 Dec 2022 14:23:04 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 714692166B26
 for <dm-devel@redhat.com>; Thu, 22 Dec 2022 14:23:04 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4FBBB1C09B74
 for <dm-devel@redhat.com>; Thu, 22 Dec 2022 14:23:04 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_128_GCM_SHA256) id us-mta-338-KAQpCvJsNvOQveSvB5xuNA-1; Thu,
 22 Dec 2022 09:23:00 -0500
X-MC-Unique: KAQpCvJsNvOQveSvB5xuNA-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out2.suse.de (Postfix) with ESMTPS id 4FE8D3E7C0;
 Thu, 22 Dec 2022 14:22:59 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 2A24E13918;
 Thu, 22 Dec 2022 14:22:59 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap2.suse-dmz.suse.de with ESMTPSA id wWKsCENopGMlSAAAMHmgww
 (envelope-from <mwilck@suse.com>); Thu, 22 Dec 2022 14:22:59 +0000
Message-ID: <ab6bddf1023ba2777cb8d0dd4158ad9936190a89.camel@suse.com>
From: Martin Wilck <mwilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>
Date: Thu, 22 Dec 2022 15:22:58 +0100
In-Reply-To: <1d0b29df40355efa83bdb0aee930eff3da6fecdc.camel@suse.com>
References: <20221202234338.2960-1-mwilck@suse.com>
 <20221207003730.GC19568@octiron.msp.redhat.com>
 <3cddb507361a3c582a11a2c752bfbae43c92aa37.camel@suse.com>
 <20221213175048.GG19568@octiron.msp.redhat.com>
 <1d0b29df40355efa83bdb0aee930eff3da6fecdc.camel@suse.com>
User-Agent: Evolution 3.46.2
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
Subject: Re: [dm-devel] [PATCH v2] libmultipath: is_path_valid(): check if
 device is in use
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Tue, 2022-12-13 at 22:35 +0100, Martin Wilck wrote:
> On Tue, 2022-12-13 at 11:50 -0600, Benjamin Marzinski wrote:
> > On Tue, Dec 13, 2022 at 08:46:28AM +0100, Martin Wilck wrote:
> > > On Tue, 2022-12-06 at 18:37 -0600, Benjamin Marzinski wrote:
> > >=20
> > > > is set to "smart", the common case will still be
> > > > that
> > > > the device is in the wwids file, so we know that it's valid. I
> > > > don't
> > > > see
> > > > a reason to do this check in that case.=A0 I was thinking that
> > > > for
> > > > the
> > > > "smart" case, this check should go at the end of the function,
> > > > before
> > > > we
> > > > return PATH_IS_MAYBE_VALID. Or do you have a reason why we
> > > > should
> > > > do
> > > > it
> > > > here that I'm missing?
> > >=20
> > > I'd argue the other way around: if the device is in use, it
> > > doesn't
> > > matter any more whether or not it's listed in the WWIDs file.
> > > This
> > > situation can only occur if something went wrong beforehand (most
> > > probably, an inconsistent WWIDs file in the initrd, or some other
> > > component misbehaving). If we tag such a device VALID although
> > > it's
> > > mounted, we'll almost certainly fall into emergency mode,
> > > regardless of
> > > the find_multipaths mode we're in. The reason is that multipathd
> > > will
> > > fail to map the mounted device, and systemd will consider the
> > > path
> > > device unusable, leading to the device being inaccessible either
> > > way.
> >=20
> > Sure. We can leave it like this. I don't have strong opinions one
> > way
> > or
> > the other.
>=20
> Thanks.
>=20
> Next step is: I provide this to the partner for testing who observed
> the issues described in the commit message. I will only push this
> upstream if we find it to be helpful.
>=20
> Martin

Tests have shown that this patch indeed stabilizes booting on a very
large system with "greedy" mode and a non-blacklisted non-multipath
root disk a lot, without causing measurable delays in uevent
processing.

I have also tested in on other systems without noticing regressions.
I'll send a v3 and push it to "queue" when reviewed.

Martin


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

