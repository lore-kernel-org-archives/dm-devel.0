Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9C1F2C7EE23
	for <dm-devel@archiver.kernel.org>; Wed,  1 Mar 2023 22:26:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1677709567;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:in-reply-to:in-reply-to:
	 references:references:list-id:list-help:list-unsubscribe:
	 list-subscribe:list-post; bh=YZ2zFNMR7MyRjj6VVourH48Aw4svj6v9INVgDDRflKw=;
	b=WUgNhRerUEP+3YcJ8GRUpcJtUEkfYAlx5VFtWVhlP8W6t04EKjniP1hpCcyuZYDi5fY/aS
	KBugmdqI591v+fDUSnU7+fkfREvtBjAqxvPAWPoPu4a1mfKfRw50UTmj/7KQol82iz4y9H
	VeLVrtZaFB/eSA47cs1dDcUfNQE4lsc=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-8-HI_dEsPaMMW1w3rpcx_x6Q-1; Wed, 01 Mar 2023 17:26:06 -0500
X-MC-Unique: HI_dEsPaMMW1w3rpcx_x6Q-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6AB793C0D18A;
	Wed,  1 Mar 2023 22:26:04 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 19E12492C3E;
	Wed,  1 Mar 2023 22:26:04 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id DDBF119452CD;
	Wed,  1 Mar 2023 22:26:03 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 5E22C19472FC
 for <dm-devel@listman.corp.redhat.com>; Wed,  1 Mar 2023 22:26:02 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 104452166B26; Wed,  1 Mar 2023 22:26:02 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 09B892166B2A
 for <dm-devel@redhat.com>; Wed,  1 Mar 2023 22:26:02 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DF70C803503
 for <dm-devel@redhat.com>; Wed,  1 Mar 2023 22:26:01 +0000 (UTC)
Received: from mx.ewheeler.net (mx.ewheeler.net [173.205.220.69]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-45-uoWybGEpO1-4zdFc_mTWuw-1; Wed, 01 Mar 2023 17:25:57 -0500
X-MC-Unique: uoWybGEpO1-4zdFc_mTWuw-1
Received: from localhost (localhost [127.0.0.1])
 by mx.ewheeler.net (Postfix) with ESMTP id 8E90184;
 Wed,  1 Mar 2023 14:25:56 -0800 (PST)
X-Virus-Scanned: amavisd-new at ewheeler.net
Received: from mx.ewheeler.net ([127.0.0.1])
 by localhost (mx.ewheeler.net [127.0.0.1]) (amavisd-new, port 10024)
 with LMTP id Q8gog9oYEn7l; Wed,  1 Mar 2023 14:25:55 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mx.ewheeler.net (Postfix) with ESMTPSA id 5DC5481;
 Wed,  1 Mar 2023 14:25:55 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx.ewheeler.net 5DC5481
Date: Wed, 1 Mar 2023 14:25:55 -0800 (PST)
From: Eric Wheeler <dm-devel@lists.ewheeler.net>
To: Joe Thornber <thornber@redhat.com>
In-Reply-To: <CAJ0trDZW8FRFuuonKrgSMp7i7m0sLdPGyFHd2ap0Gw8iadrA-A@mail.gmail.com>
Message-ID: <74a2b8c1-71cf-10b5-a837-c1af60773e98@ewheeler.net>
References: <CAJ0trDZW8FRFuuonKrgSMp7i7m0sLdPGyFHd2ap0Gw8iadrA-A@mail.gmail.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
Subject: Re: [dm-devel] [announce] thin-provisioning-tools v1.0.0-rc1
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
Cc: "development, device-mapper" <dm-devel@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/mixed; BOUNDARY="8323328-2080667159-1677709232=:14692"

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.
--8323328-2080667159-1677709232=:14692
Content-Type: text/plain; CHARSET=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

On Mon, 12 Dec 2022, Joe Thornber wrote:
> We're pleased to announce the first release candidate of v1.0.0 of the
> thin-provisioning-tools (which also contains tools for dm-cache and
> dm-era).
>
> # Rust
>
> This is a complete rewrite of the tools in the Rust language.=A0 This swi=
tch
> was made for three primary reasons:
>=20
> # thin_dump/restore retains snapshot sharing
>=20
> Another issue with previous versions of the tools is dumping and restorin=
g
> thin metadata would have the effect of losing sharing of the metadata
> btrees for snapshots.=A0 Meaning restored metadata often took up more spa=
ce, and
> in some cases would exceed the 16G metadata limit.=A0 This is no longer t=
he case.

Hurrah! I've been looking forward to this for a long time...


Joe, I seem to remember you had you mentioned the possibility of adding=20
metadata range support for dm-thin in the Linux kernel once the Linux=20
kernel supported Rust. Now that it does, is this still on the roadmap?

Relatedly, we had an email conversation sometime about go porting the=20
dm-thin path to handle multi-queue behavior better than it does now. I=20
could not find the thread, but I seem to remember that you said this was=20
already applied to dm-cache.  I was considering attempting the port, but=20
it looked complicated so you suggested to wait for Rust in the kernel to=20
get metadata range support before looking at dm-thin.

...So if you have any commentary on the future of dm-thin with respect=20
to metadata range support, or dm-thin performance in general, that I would=
=20
be very curious about your roadmap and your plans.

Thanks again for all your great work on this.

-Eric
=20
> [note: _data_ sharing was always maintained, this is purely about metadat=
a space usage]
>=20
> # thin_metadata_pack/unpack
>=20
> These are a couple of new tools that are used for support.=A0 They compre=
ss
> thin metadata, typically to a tenth of the size (much better than you'd
> get with generic compressors).=A0 This makes it easier to pass damaged
> metadata around for inspection.
>=20
> # blk-archive
>=20
> The blk-archive tools were initially part of this thin-provisioning-tools
> package.=A0 But have now been split off to their own project:
>=20
> =A0 =A0 https://github.com/jthornber/blk-archive
>=20
> They allow efficient archiving of thin devices (data deduplication
> and compression).=A0 Which will be of interest to those of you who are
> holding large numbers of snapshots in thin pools as a poor man's backup.
>=20
> In particular:
>=20
> =A0 =A0 - Thin snapshots can be used to archive live data.
> =A0 =A0 - it avoids reading unprovisioned areas of thin devices.
> =A0 =A0 - it can calculate deltas between thin devices to minimise
> =A0 =A0 =A0 how much data is read and deduped (incremental backups).
> =A0 =A0 - restoring to a thin device tries to maximise data sharing
> =A0 =A0 =A0 within the thin pool (a big win if you're restoring snapshots=
).
>=20
> 
--8323328-2080667159-1677709232=:14692
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

--8323328-2080667159-1677709232=:14692--

