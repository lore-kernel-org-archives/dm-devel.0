Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6B5BDC433EF
	for <dm-devel@archiver.kernel.org>; Wed, 23 Mar 2022 22:24:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1648074298;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=XARO0Si9H9FKG+oB7ryqyIwvyLligykZEvBgsGE7Xbk=;
	b=QDQnZRfIz3FexTqbPt1OhcPO94sRWUQoGPZb8zyTi60Z886VmmytKNhB6qj2F+biThK/9S
	C7c3xupl9V06g1jeEsJ35XGw5nZO0uyDfwVM7t3H5HsIjNSbHdzyl1npEGywYfKsdzsDCT
	ziBvE8dU2RzM/uEeJ0eje0RhiCRdARI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-345-VV4OsJ04PAqtMh6vseVASw-1; Wed, 23 Mar 2022 18:24:54 -0400
X-MC-Unique: VV4OsJ04PAqtMh6vseVASw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EABEB185A7B2;
	Wed, 23 Mar 2022 22:24:52 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 20FC8C27E86;
	Wed, 23 Mar 2022 22:24:51 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id B07C81940347;
	Wed, 23 Mar 2022 22:24:50 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 0448B1949763
 for <dm-devel@listman.corp.redhat.com>; Wed, 23 Mar 2022 22:24:49 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id AC86440CFD06; Wed, 23 Mar 2022 22:24:49 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 9C44340CFD05;
 Wed, 23 Mar 2022 22:24:49 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
 by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 22NMOmaZ020473;
 Wed, 23 Mar 2022 17:24:48 -0500
Received: (from bmarzins@localhost)
 by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 22NMOlZ4020472;
 Wed, 23 Mar 2022 17:24:47 -0500
Date: Wed, 23 Mar 2022 17:24:47 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: boli sudha <bolisudha@gmail.com>
Message-ID: <20220323222447.GK24684@octiron.msp.redhat.com>
References: <CAEgic_HjomW1WbB+XFzN2t_kJJr=-2P-zrNi2p0EqqMo2pc2Lg@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAEgic_HjomW1WbB+XFzN2t_kJJr=-2P-zrNi2p0EqqMo2pc2Lg@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
Subject: Re: [dm-devel] libmpathpersist: Getting undefined symbol during
 compilation
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
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Sat, Mar 19, 2022 at 08:57:08PM +0530, boli sudha wrote:
> Hi,
> 
> I found this mail Id on the Git page, I never used libmpathpersist or
> libmulitpath.
> One of our applications is using these libraries. Compilation was working
> fine on RedHat 7. I am trying to port our application to Redhat 8. During
> linking I am getting the following error. Can you please help me?
> 
> /usr/lib64/libmpathpersist.so: undefined reference to `put_multipath_config'
> /usr/lib64/libmpathpersist.so: undefined reference to `get_multipath_config'
> /usr/lib64/libmultipath.so: undefined reference to `udev'
> collect2: error: ld returned 1 exit status
> 
> These symbols were not present in the RedHat 7 version of libraries.
> 
> On RedHat 8, these symbols were undefined, I downloaded the git code,
> compiled, and observed that these symbols are defined in binaries, not
> libraries.
> 
> I also tried to remove these libraries from linker command, but so many
> symbols are missing.

Using libmpathpersist is kind of tricky. Later version of
device-mapper-multipath clean this up. But for the version in RHEL-8,
your binary needs to specify some things to work with libmpathpersist.

If your program is single threaded, then you should add something like
(pulled from mpathpersist/main.c):

======================
int logsink = 0;		/* or -1 */
struct config *multipath_conf;

struct config *get_multipath_config(void)
{
	return multipath_conf;
}

void put_multipath_config(__attribute__((unused)) void * arg)
{
	/* Noop for now */
}

void rcu_register_thread_memb(void) {}

void rcu_unregister_thread_memb(void) {}

struct udev *udev;
=====================

If you don't call all the mpathpersist commands with verbose = -1,
the library can log errors. Setting logsink to 0 will log them with a
timestamp. setting it to -1 will not add the timestamp.

Your main funciton also needs to set up these variables. It should
include something like (again pulled from mpathpersist/main.c):

====================
udev = udev_new();
multipath_conf = mpath_lib_init();	
====================

Both of these functions can return NULL on error.

Let me know if that helps.

-Ben

> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://listman.redhat.com/mailman/listinfo/dm-devel

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

