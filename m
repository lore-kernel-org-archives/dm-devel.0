Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5BA14C77B73
	for <dm-devel@archiver.kernel.org>; Tue,  6 Jun 2023 16:15:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686068149;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=mc5/GduM/TzghI45X0MWGGHg3mUQwBhJWcpWlFs8AWE=;
	b=bEX+eAW4apMitwTcfMTvdbgSQmXoeMairIkoJbi0YU7v38IbOPHlLNUBRXQs4CvSD3gRoC
	ROLtDmp0JabBaaV/9SKNHbNzfYB71k93DPJ3BG5EMAxUdjIy3Fnbpg00anVGfRTa5yIhSE
	zPBiSwK75AG8HST2uZZB7waZRique44=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-647-Nu7eyS7SPjCAyM368w0hWA-1; Tue, 06 Jun 2023 12:15:48 -0400
X-MC-Unique: Nu7eyS7SPjCAyM368w0hWA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C50141C0ED00;
	Tue,  6 Jun 2023 16:15:45 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id AEB7240D1B66;
	Tue,  6 Jun 2023 16:15:45 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 7155019465BC;
	Tue,  6 Jun 2023 16:15:45 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 5C0FD19465BA
 for <dm-devel@listman.corp.redhat.com>; Tue,  6 Jun 2023 16:15:44 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 39D6040218C; Tue,  6 Jun 2023 16:15:44 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 2240B492B00;
 Tue,  6 Jun 2023 16:15:44 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
 by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 356GFfP5027720;
 Tue, 6 Jun 2023 11:15:41 -0500
Received: (from bmarzins@localhost)
 by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 356GFekL027719;
 Tue, 6 Jun 2023 11:15:40 -0500
Date: Tue, 6 Jun 2023 11:15:40 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <mwilck@suse.com>
Message-ID: <20230606161540.GZ24096@octiron.msp.redhat.com>
References: <a674434b-d365-1f07-2c6f-6a4ffa07578f@gmail.com>
 <946fc11571491dd39971288b48095b6480f7914f.camel@suse.com>
MIME-Version: 1.0
In-Reply-To: <946fc11571491dd39971288b48095b6480f7914f.camel@suse.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
Subject: Re: [dm-devel] multipath-tools: Debian patches
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
Cc: dm-devel mailing list <dm-devel@redhat.com>,
 Xose Vazquez Perez <xose.vazquez@gmail.com>, chris@hofstaedtler.name
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 06, 2023 at 05:18:36PM +0200, Martin Wilck wrote:
> On Mon, 2023-06-05 at 21:59 +0200, Xose Vazquez Perez wrote:
> > Hi,
> >=20
>=20
> I have no Debian salsa account, so I reply here, trying to reach Chris
> via email.
>=20
> >=20
> > A complaint about upstream, "Remove library development files and all
> > of libdmmp":
> > https://salsa.debian.org/linux-blocks-team/multipath-tools/-/commit/8c4=
6661697d757763192d8e011c9ad53358d20b7
>=20
> If Chris has followed the upstream discussion, he is probably aware
> that we do care about the ABI. We don't keep the libmultipath ABI
> stable, but track it using ABI versioning. It is true that most of the
> libmultipath headers are not used for other projects. Not installing
> any headers except the public ones makes sense, actually.
>=20
> The libmpathpersist API (LIBMPATHPERSIST_2.1.0) that's used by qemu is
> supposed to remain stable. We have moved those parts of the ABI that
> used to be more volatile into __LIBMPATHPERSIST_INT_1.0.0.
>=20
> Therefore it makes sense to keep shipping mpath_persist.h and drop the
> rest. If that works for Debian, it will probably work for other
> distros, too.
>=20
> libdmpp comes from Red Hat, perhaps Ben knows whether it is still used
> by any alive project. It does have a stable API/ABI.
>=20

I don't know of any users, but I don't feel confident in saying that
there aren't any, and I agree that it's ABI is stable.

libmpathvalid has a stable API/ABI as well.

So does libmpathcmd. That one doesn't even have any connection to
libmultipath in the library itself. It's just sockets.

-Ben

> > And maybe these are relevant for upstream ( repo:
> > https://salsa.debian.org/linux-blocks-team/multipath-tools/-/tree/maste=
r/debian/patches
> > =A0):
> >=20
> > https://udd.debian.org/patches.cgi?src=3Dmultipath-tools&version=3D0.9.=
4-3
> >=20
>=20
> That's not how we work. We don't pick downstream patches. If
> something's wrong with the upstream code, we'll happily discuss patches
> from the Debian project, preferably here on dm-devel.
>=20
> Regards
> Martin
--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

