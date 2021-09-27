Return-Path: <SRS0=coXp=OR=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 370F4C433EF
	for <dm-devel@archiver.kernel.org>; Mon, 27 Sep 2021 15:11:42 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id D51A060F44
	for <dm-devel@archiver.kernel.org>; Mon, 27 Sep 2021 15:11:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org D51A060F44
Authentication-Results: mail.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1632755501;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=ZPniv5fzhO1jbC0QD6PaUn6D+S7eGglU+DC9Plr19Ng=;
	b=IXRQ/BAQQQE32D2q6r0fCVQZB3cHgvJyYruObwd4kTHNIUoKkaOCqFYT7z+F/FoUbUir75
	W2UBLl4ZJVyRizOSIqSqhzhZF9OH8d9eTWew0NwvaWVE5tOpX+ZwFrBExH3NKPn0uZL1kj
	FEvCYHwBtj9NDqq1Q2CGeoM1RRQU8l4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-526-iFc54x3OM5CxspR3aGiTdw-1; Mon, 27 Sep 2021 11:11:36 -0400
X-MC-Unique: iFc54x3OM5CxspR3aGiTdw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7D4B9802C92;
	Mon, 27 Sep 2021 15:11:30 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id AE18D10074EF;
	Mon, 27 Sep 2021 15:11:29 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 91AF51809C84;
	Mon, 27 Sep 2021 15:11:24 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com
	[10.5.11.14])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 18RFBN1D024496 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 27 Sep 2021 11:11:23 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 145DF175B4; Mon, 27 Sep 2021 15:11:23 +0000 (UTC)
Received: from octiron.msp.redhat.com (unknown [10.15.80.209])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id EFC495D9D3;
	Mon, 27 Sep 2021 15:11:22 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
	by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 18RFBFcU025810; 
	Mon, 27 Sep 2021 10:11:15 -0500
Received: (from bmarzins@localhost)
	by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 18RFBFfJ025809;
	Mon, 27 Sep 2021 10:11:15 -0500
Date: Mon, 27 Sep 2021 10:11:15 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
Message-ID: <20210927151115.GE3087@octiron.msp.redhat.com>
References: <1632180076-9294-1-git-send-email-bmarzins@redhat.com>
	<9bf07d41-44e3-0f44-0cff-59b7379fc490@gmail.com>
MIME-Version: 1.0
In-Reply-To: <9bf07d41-44e3-0f44-0cff-59b7379fc490@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-loop: dm-devel@redhat.com
Cc: DM-DEVEL ML <dm-devel@redhat.com>, Martin Wilck <mwilck@suse.com>
Subject: Re: [dm-devel] [PATCH 0/4] Add "reconfigure all" multipath command
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Fri, Sep 24, 2021 at 10:44:46PM +0200, Xose Vazquez Perez wrote:
> On 9/21/21 01:21, Benjamin Marzinski wrote:
> 
> >This patchset is supposed to replace Martin's
> >
> >multipathd: add "force_reconfigure" option
> >
> >patch from his uxlsnr overhaul patchset. It also makes the default
> >reconfigure be a weak reconfigure, but instead of adding a configuration
> >option to control this, it adds a new multipathd command,
> >"reconfigure all", to do a full reconfigure. The HUP signal is left
> >doing only weak reconfigures.
> >In order to keep from having two states that are handled nearly
> >identically, the code adds an extra variable to track the type of
> >configuration that was selected, but this could easily be switch to
> >use a new DAEMON_CONFIGURE_ALL state instead.
> >The final patch, that added the new command, is meant to apply on top of
> >Martin's changed client handler code. I can send one that works with the
> >current client handler code, if people would rather review that.
> 
> This change is going to affect some places, raw search:

Yes. I specifically broke the code that actually changes how multipathd
operates from a user' point of view into a seperate patch (4/4) because
distributions might need to revert in, if they want to pull in recent
upstream changes, but don't what this kind of change in multipathd's
behavior.

I admit, this patchset needs to include documentation to mention the
changed behavior. I'll add that.  But I'm not sure what to make of the
list below.  I don't see any code in it that I didn't think about.  We
can disagree as to whether, for instance, dmmp_reconfig() should do a
full or a weak reconfig. But without some more information, I'm not sure
what you are asking of me.

-Ben

> $ git grep reconfigure
> libdmmp/libdmmp.c:      snprintf(cmd, _IPC_MAX_CMD_LEN, "%s", "reconfigure");
> libmultipath/configure.c:        * If we are in this code path (startup or forced reconfigure),
> libmultipath/foreign.h:  * don't support it. "multipathd reconfigure" starts foreign device
> libmultipath/foreign.h:  * This is called if multipathd reconfigures itself.
> multipath/main.c:               p += snprintf(p, n, "reconfigure");
> multipathd/cli.c:       r += add_key(keys, "reconfigure", RECONFIGURE, 0);
> multipathd/cli_handlers.c:cli_reconfigure(void * v, char ** reply, int * len, void * data)
> multipathd/cli_handlers.c:      condlog(2, "reconfigure (operator)");
> multipathd/cli_handlers.h:int cli_reconfigure(void * v, char ** reply, int * len, void * data);
> multipathd/main.c:                              condlog(2, "reconfigure (delayed)");
> multipathd/main.c:      set_unlocked_handler_callback(RECONFIGURE, cli_reconfigure);
> multipathd/main.c:              condlog(2, "reconfigure (delayed)");
> multipathd/main.c:reconfigure (struct vectors * vecs)
> multipathd/main.c:              condlog(2, "reconfigure (signal)");
> multipathd/main.c:                              reconfigure(vecs);
> multipathd/main.h:int reconfigure (struct vectors *);
> multipathd/multipathd.8:happens, it will reconfigure the multipath map the path belongs to, so that this
> multipathd/multipathd.8:.B reconfigure
> multipathd/multipathd.service:ExecReload=/sbin/multipathd reconfigure
> multipathd/uxlsnr.c:     * do it once per reconfigure */

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

