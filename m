Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E52F4C433F5
	for <dm-devel@archiver.kernel.org>; Mon, 29 Nov 2021 19:28:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1638214081;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=znQpAXgUdTZGIvqU4y+JVwrhpvfewqRfgdlN9VZAOiw=;
	b=W4BQf1udeqFwc3a0WpE5sqDiCEaSoOnnfUD2v4uaAgJ3CmhEM7KFYp7UJp5vaITWWYyNUc
	6ez6RBUTQpZq6s9JaJCAMUy6aJ3kXa45zE1oTzqjjdHZyYvyrnrz3A37awsV/mp6FuUy1y
	Tim3ssNkmzyN2iV2ZdjLI85DiutkTZQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-545-wkxip4NUPvSM0dX-_D5ceg-1; Mon, 29 Nov 2021 14:27:57 -0500
X-MC-Unique: wkxip4NUPvSM0dX-_D5ceg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7CF5C100CC84;
	Mon, 29 Nov 2021 19:27:53 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D7BD35D6BA;
	Mon, 29 Nov 2021 19:27:52 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 37C544CA93;
	Mon, 29 Nov 2021 19:27:51 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com
	[10.5.11.16])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1ATJRmNH030612 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 29 Nov 2021 14:27:48 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id D8BC5794A0; Mon, 29 Nov 2021 19:27:48 +0000 (UTC)
Received: from octiron.msp.redhat.com (unknown [10.15.80.209])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 6866F7945B;
	Mon, 29 Nov 2021 19:27:32 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
	by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 1ATJRUjw022097; 
	Mon, 29 Nov 2021 13:27:30 -0600
Received: (from bmarzins@localhost)
	by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 1ATJRT35022096;
	Mon, 29 Nov 2021 13:27:29 -0600
Date: Mon, 29 Nov 2021 13:27:29 -0600
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <mwilck@suse.com>
Message-ID: <20211129192729.GD19591@octiron.msp.redhat.com>
References: <20211118225840.19810-1-mwilck@suse.com>
	<20211118225840.19810-4-mwilck@suse.com>
	<20211124204118.GP19591@octiron.msp.redhat.com>
	<52ddff9a6d2b1813d1269a008eb92ee522c3d6ad.camel@suse.com>
MIME-Version: 1.0
In-Reply-To: <52ddff9a6d2b1813d1269a008eb92ee522c3d6ad.camel@suse.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-loop: dm-devel@redhat.com
Cc: lixiaokeng@huawei.com, dm-devel@redhat.com,
	Chongyun Wu <wu.chongyun@h3c.com>
Subject: Re: [dm-devel] [PATCH v2 03/48] libmultipath: add optional wakeup
 functionality to lock.c
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
Content-Disposition: inline
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 24, 2021 at 10:20:53PM +0100, Martin Wilck wrote:
> On Wed, 2021-11-24 at 14:41 -0600, Benjamin Marzinski wrote:
> > On Thu, Nov 18, 2021 at 11:57:55PM +0100, mwilck@suse.com=A0wrote:
> > > From: Martin Wilck <mwilck@suse.com>
> > >=20
> > > Have struct mutex_lock take an optional wakeup function.
> > > unlock() is renamed to __unlock() in order to prevent it from
> > > being called by mistake.
> > >=20
> > > This changes offsets in "struct vectors", requiring a major
> > > libmultipath version bump. While the strucure is already changed,
> > > in order to avoid this in the future, move the lock to the end
> > > of "struct vectors".
> > >=20
> > > Signed-off-by: Martin Wilck <mwilck@suse.com>
> >=20
> > In libmultipath.version, I would have said that set_wakeup_fn was
> > added
> > in 10.0.0, instead of 9.2.0, which is a version that never actually
> > existed, but I don't think that's going to cause any problems so,
> >=20
> > Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
>=20
> We should consider whether we want bump the version numbers only when
> we submit to Christophe, or maybe once per major patch series that
> touches the ABI. This is something that I could=20

I suppose that we could just bump the version the first time after a
push to Christophe that an ABI change is made, and then just make all
the symbol changes under that version until Christophe makes another
release. If the first change only caused a minor version bump, and a
later change needed a major bump we could have two version bumps in a
release, but I don't think we're getting any benefit from making more.
But once per patchset works fine for me too.

-Ben
>=20
> Martin

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

