Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3E943C43219
	for <dm-devel@archiver.kernel.org>; Thu, 20 Oct 2022 22:57:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1666306659;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=KfzoUuwCslEU/Xu4MHV5tUuG/9ODeBu3Bhm7Doms2tI=;
	b=XeoS+VUhH0ab1jSLUE28T3nVvp2eA5no9dr4LUKYZhVxeF+wnVZYsI9IeJqEziuWUqvp8P
	0f7HF+zrOe9H1iHQLu35hnkJOR0J6JooLmzcIJVu317eaVYJI+8deLTBswZwpO+ekRAS1a
	eiaogGV2G2n3Av6Jc14/5sbs5q6fI3k=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-616-tV2b30QPNoiKWkhRXkdRQA-1; Thu, 20 Oct 2022 18:57:36 -0400
X-MC-Unique: tV2b30QPNoiKWkhRXkdRQA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BEFA32A59566;
	Thu, 20 Oct 2022 22:57:34 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 884A92028DC1;
	Thu, 20 Oct 2022 22:57:32 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 72A081946595;
	Thu, 20 Oct 2022 22:57:32 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id A8CDB1946587
 for <dm-devel@listman.corp.redhat.com>; Thu, 20 Oct 2022 22:57:30 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 846F12028DC1; Thu, 20 Oct 2022 22:57:30 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 5DE812024CBB;
 Thu, 20 Oct 2022 22:57:30 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
 by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 29KMvSFe020158;
 Thu, 20 Oct 2022 17:57:29 -0500
Received: (from bmarzins@localhost)
 by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 29KMvSZh020155;
 Thu, 20 Oct 2022 17:57:28 -0500
Date: Thu, 20 Oct 2022 17:57:02 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Message-ID: <20221020225702.GA19568@octiron.msp.redhat.com>
References: <1665525183-27377-1-git-send-email-bmarzins@redhat.com>
 <ea71be8dba1dd8103d8d46d76011bc74d1a73034.camel@suse.com>
MIME-Version: 1.0
In-Reply-To: <ea71be8dba1dd8103d8d46d76011bc74d1a73034.camel@suse.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
Subject: Re: [dm-devel] [PATCH 0/4] remove dangerous cleanup __attribute__
 uses
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
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 20, 2022 at 04:03:46PM +0000, Martin Wilck wrote:
> On Tue, 2022-10-11 at 16:52 -0500, Benjamin Marzinski wrote:
> > the cleanup __attribute__ is only run when a variable goes out of
> > scope
> > normally. It is not run on pthread cancellation. This means that
> > multipathd could leak whatever resources were supposed to be cleaned
> > up
> > if the thread was cancelled in a function using variables with the
> > cleanup __attribute__. This patchset removes all these uses in cases
> > where the code is run by multipathd and includes a cancellation point
> > in the variables scope (usually condlog(), which calls fprintf(), a
> > cancellation point, the way multipathd is usually run).
>=20
> I have to say I don't like this.=A0
>=20
> Cleaning up resources is certainly  very important, but in most of
> cases it's only about freeing memory on exit: memory which is going to
> be freed by the system anyway when multipathd terminates. Resource
> cleanup matters much more during runtime than on exit. The only threads
> that are cancelled during multipathd runtime are the TUR threads.
> It's nice to have valgrind show zero leaks when we kill multipathd out
> if the sudden. But we should weigh this against the side effects it
> has, which is ugly, hard-to-maintain code.
>=20
> pthread_cleanup_push()/pop() calls contribute a lot to the bad
> readability and maintainability of much of the multipath code base, not
> to mention the weird errors some gcc versions throw for
> pthread_cleanup() constructs.=A0I'd rather try to get rid of as much of
> them as we can. I know it won't be possible everywhere, because some
> resources (like file descriptors) really need to be cleaned up, but I
> am really unsure whether we need pthread cleanup for every free()
> operation.
>=20
> __attribute__((cleanup())), on the contrary, goes a long way to make
> code more readable and easier to review. It actually helps a lot to
> ensure resources are properly cleaned up, considering how easily a
> "goto cleanup;" statement may be forgotten. Replacing it by
> pthread_cleanup() and goto statements is undesirable, IMO.
>=20
> If your concern is really condlog(), let's discuss if we can find a way
> to convert this such that it is no cancellation point any more. I can
> imagine converting the locking in log_safe() from a mutex into some
> lockless scheme, using atomic variables, and using the log thread not
> only for syslog, but also for the fprintf() case.

Actually, I've never been a huge fan of all the work that we do to keep
multipathd from leaking memory when it's killed, but I though that was
the goal. If you don't care about these leaks, then I'm fine with
ignoring them.  How about just taking the first and third patches?

libmultipath: don't print garbage keywords=20
libmultipath: use regular array for field widths

-Ben
=20
> Regards
> Martin
>=20
>=20
> >=20
> > Benjamin Marzinski (4):
> > =A0 libmultipath: don't print garbage keywords
> > =A0 libmultipath: avoid STRBUF_ON_STACK with cancellation points
> > =A0 libmultipath: use regular array for field widths
> > =A0 libmultipath: avoid cleanup __attribute__ with cancellation points
> >=20
> > =A0libmpathutil/parser.c=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0 | 13 ++--
> > =A0libmpathutil/strbuf.h=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0 |=A0 4 +-
> > =A0libmultipath/alias.c=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0 | 59 ++++++++++-------
> > =A0libmultipath/blacklist.c=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0 |=A0 4 +-
> > =A0libmultipath/configure.c=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0 |=A0 6 +-
> > =A0libmultipath/discovery.c=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0 | 34 ++++++----
> > =A0libmultipath/dmparser.c=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0 | 23 +++----
> > =A0libmultipath/foreign.c=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0 |=A0 9 +--
> > =A0libmultipath/generic.c=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0 | 14 ++--
> > =A0libmultipath/libmultipath.version=A0=A0=A0=A0=A0=A0=A0 |=A0 4 +-
> > =A0libmultipath/print.c=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0 | 82 ++++++++++++++--------
> > --
> > =A0libmultipath/print.h=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0 |=A0 4 +-
> > =A0libmultipath/prioritizers/weightedpath.c | 22 ++++---
> > =A0libmultipath/propsel.c=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0 | 76 ++++++++++++++++------
> > =A0libmultipath/sysfs.h=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0 | 11 +---
> > =A0libmultipath/uevent.c=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0 |=A0 6 +-
> > =A0multipath/main.c=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0 |=A0 5 +-
> > =A0multipathd/cli_handlers.c=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0 | 52 +++++++--------
> > =A0multipathd/main.c=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0 | 49 ++++++++------
> > =A019 files changed, 286 insertions(+), 191 deletions(-)
> >=20
--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

