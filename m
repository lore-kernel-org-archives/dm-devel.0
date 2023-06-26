Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1AE13EB64D7
	for <dm-devel@archiver.kernel.org>; Mon, 26 Jun 2023 13:13:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1687785196;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=AivP+Aay/7UaH/zd7n8jHJCNC2J8h+grAKmYunHSWNw=;
	b=L7onUaSL+FqIUpu0aqhV6UJeTV6UI/5vJw6PX6riufN2iI+t1MaLo0z3UhAtUALgriVEnb
	8pc6sSZF+5iwmhUXqlDUPnEBGa1bPZUXz/E47Y+MH9bDjRnkYFumrnGZhpACe0qClNmoqQ
	as4lue0a6FSpRftWLkwB9IPOMlqNnXY=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-377-2IGpUpFFNrC6qUvBw9Dywg-1; Mon, 26 Jun 2023 09:13:01 -0400
X-MC-Unique: 2IGpUpFFNrC6qUvBw9Dywg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 53DFA38294B9;
	Mon, 26 Jun 2023 13:11:58 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id F4146C1ED97;
	Mon, 26 Jun 2023 13:11:57 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id D410B1946588;
	Mon, 26 Jun 2023 13:11:57 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 3A4251946587
 for <dm-devel@listman.corp.redhat.com>; Mon, 26 Jun 2023 13:11:56 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 16D0315230A1; Mon, 26 Jun 2023 13:11:56 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 0F02215230A0
 for <dm-devel@redhat.com>; Mon, 26 Jun 2023 13:11:56 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E71A93814947
 for <dm-devel@redhat.com>; Mon, 26 Jun 2023 13:11:37 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-439-V-8pjhbCOOqWdImaMi4f1g-1; Mon,
 26 Jun 2023 09:11:35 -0400
X-MC-Unique: V-8pjhbCOOqWdImaMi4f1g-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out2.suse.de (Postfix) with ESMTPS id 01AB31F896;
 Mon, 26 Jun 2023 13:11:31 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id C165413483;
 Mon, 26 Jun 2023 13:11:30 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap2.suse-dmz.suse.de with ESMTPSA id 2pOCLYKOmWTcXgAAMHmgww
 (envelope-from <mwilck@suse.com>); Mon, 26 Jun 2023 13:11:30 +0000
Message-ID: <f2aa7310447494294a0e274e9966ab6febb99b34.camel@suse.com>
From: Martin Wilck <mwilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>, Brian Bunker
 <brian@purestorage.com>
Date: Mon, 26 Jun 2023 15:11:30 +0200
In-Reply-To: <e19fd16143ae04c631f2e6eb6a55b2604876f9f2.camel@suse.com>
References: <CD5EC3B3-9A64-416A-A04C-C68EDB82F4C6@purestorage.com>
 <a85c4b5a6603be979ddb9aa0909808519a03fa3e.camel@suse.com>
 <20230320194146.GH19878@octiron.msp.redhat.com>
 <e19fd16143ae04c631f2e6eb6a55b2604876f9f2.camel@suse.com>
User-Agent: Evolution 3.48.3
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
Subject: Re: [dm-devel] [PATCH] multipath-tools Consider making 'smart' the
 default
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
Cc: device-mapper development <dm-devel@redhat.com>,
 Xose Vazquez Perez <xose.vazquez@gmail.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: suse.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, 2023-03-21 at 09:57 +0100, Martin Wilck wrote:
> On Mon, 2023-03-20 at 14:41 -0500, Benjamin Marzinski wrote:
> > On Mon, Mar 20, 2023 at 03:18:37PM +0100, Martin Wilck wrote:
> > > On Thu, 2023-03-16 at 14:47 -0700, Brian Bunker wrote:
> > > > 
> 
> > > > Subsequent volumes after the first one are discovered via unit
> > > > attentions triggering the udev rule which calls scan-scsi-
> > > > target.
> > > > The SCSI devices being discovered without creating the
> > > > corresponding
> > > > multipath devices seems to be a bad default. We would like to
> > > > control as much as possible from the target side to dictate
> > > > initiator
> > > > behavior. This comes as a regression to how it previously
> > > > worked.
> > > > 
> > > > Signed-off-by: Brian Bunker <brian@purestorage.com>
> > > 
> > > I'm fine with this, but keep in mind that distributions will
> > > probably
> > > override this anyway. Red Hat and SUSE have had different
> > > defaults
> > > for
> > > this basically forever. At least enterprise distros won't risk
> > > regressions because of changing defaults.
> > > 
> > > Ben, what's your opinion wrt the patch?
> > 
> > tl;dr: I think "yes" makes more sense than "smart".
> 
> TL;DR: I'd like to hear the "voice of the user" at this point. So if
> anyone except Ben, Brian, and myself has read this far, please speak
> up
> (and read on if you have the patience)!
> 

Well, nobody has spoken up for 3 months.

Reconsidering the past discussion, I think we shouldn't change this
default. As argued previously, I believe that the majority of multipath
users install some distribution package. Distros either change the
default by patching (like SUSE and Red Hat) or keep the upstream
default. The first class of distros won't change their defaults, so for
them it's just extra work (modifying the downstream patches) without
user benefit. For the second class of distros, changing the upstream
default would cause an unexpected change in behavior for end users.
People who compile the upstream code themselves should have the
knowledge to set the default to suit their needs.

Thoughts? Disagreement?

Martin

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

