Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 86397C433F5
	for <dm-devel@archiver.kernel.org>; Mon, 29 Nov 2021 16:19:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1638202760;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=mMLrLLbBpi9gOKRlFkhJclbLP8AEZ59sDdelF4Nrcbs=;
	b=Po0vVoAkwLtHmYkvkRa20j92EntgDjI85n4JIoGG8MlEXe8CzLEe83Sz1VTKGMQ5MscSND
	AFbdq1tlLHW84opbIO6gzj0yL7FWXry5A366sbnIoLWYpj1u0HVhq32ipzaSBGljQJl0MZ
	qqz2O7bFZwyP5jQ9yLYF4wH0hZKtO08=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-254-mUJ1Zw9SPJKXiQhjkps3ag-1; Mon, 29 Nov 2021 11:19:16 -0500
X-MC-Unique: mUJ1Zw9SPJKXiQhjkps3ag-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7CFA3192CC41;
	Mon, 29 Nov 2021 16:19:12 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 8FD5710016F2;
	Mon, 29 Nov 2021 16:19:11 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id D5C061809C89;
	Mon, 29 Nov 2021 16:19:09 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com
	[10.5.11.22])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1ATGJ7Uu015049 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 29 Nov 2021 11:19:07 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 7C38810016FE; Mon, 29 Nov 2021 16:19:07 +0000 (UTC)
Received: from octiron.msp.redhat.com (unknown [10.15.80.209])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 620B110016F2;
	Mon, 29 Nov 2021 16:19:07 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
	by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 1ATGJ5YD020946; 
	Mon, 29 Nov 2021 10:19:05 -0600
Received: (from bmarzins@localhost)
	by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 1ATGJ4vR020945;
	Mon, 29 Nov 2021 10:19:04 -0600
Date: Mon, 29 Nov 2021 10:19:04 -0600
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <mwilck@suse.com>
Message-ID: <20211129161904.GA19591@octiron.msp.redhat.com>
References: <20211118225840.19810-1-mwilck@suse.com>
	<20211118225840.19810-30-mwilck@suse.com>
	<20211125003859.GT19591@octiron.msp.redhat.com>
	<d0d0a5bbcd78083550f0df6c17463f133ca9021e.camel@suse.com>
MIME-Version: 1.0
In-Reply-To: <d0d0a5bbcd78083550f0df6c17463f133ca9021e.camel@suse.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-loop: dm-devel@redhat.com
Cc: lixiaokeng@huawei.com, dm-devel@redhat.com,
	Chongyun Wu <wu.chongyun@h3c.com>
Subject: Re: [dm-devel] [PATCH v2 29/48] multipathd: uxlsnr: merge
 uxsock_trigger() into state machine
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 26, 2021 at 03:34:59PM +0100, Martin Wilck wrote:
> On Wed, 2021-11-24 at 18:38 -0600, Benjamin Marzinski wrote:
> > On Thu, Nov 18, 2021 at 11:58:21PM +0100, mwilck@suse.com=A0wrote:
> > > From: Martin Wilck <mwilck@suse.com>
> > >=20
> > > This patch sets up the bulk of the state machine.
> > > client_state_machine()
> > > is called in a loop, proceeding from state to state until it needs
> > > to poll for input or wait for a lock, in which case it returns
> > > STM_BREAK.
> > >=20
> > > While doing this, switch to negative error codes for the functions
> > > in uxlsnr.c (e.g. parse_cmd()). Positive return codes are reserved
> > > for the cli_handler functions themselves. This way we can clearly
> > > distinguish the error source, and avoid confusion and misleading
> > > error messages. No cli_handler returns negative values.
> > >=20
> > > Note: with this patch applied, clients may hang and time out if
> > > the handler fails to acquire the vecs lock. This will be fixed in
> > > the
> > > follow-up patch "multipathd: uxlsnr: add idle notification".
> > >=20
> >=20
> > Actually, one nitpick. See below
> >=20
> > > +
> >=20
> > This switch statement is indented with 8 spaces, instead of a tab
>=20
> I'm going to fix that, but I assume you're aware that our code is far
> from being consistent in this respect. This holds also for other
> patches in this series. Do you want me to re-format all of them?

Huh? I mean that the line doesn't start with a tab, but instead has 8
spaces.  A quick grep through the source code in your queue branch only
turns that up in some of the files in the tests directory and in files
we've just imported

# grep -l "^        " `find ./ -name "*.[ch]"`
./libmultipath/nvme/nvme-ioctl.c
./tests/pgpolicy.c
./tests/util.c
./tests/directio.c
./tests/mpathvalid.c
./tests/dmevents.c
./third-party/valgrind/drd.h
./third-party/valgrind/valgrind.h

-Ben

>=20
> Martin

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

