Return-Path: <SRS0=GHLL=MP=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9BCAFC4338F
	for <dm-devel@archiver.kernel.org>; Fri, 23 Jul 2021 16:56:24 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 3831660E97
	for <dm-devel@archiver.kernel.org>; Fri, 23 Jul 2021 16:56:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 3831660E97
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1627059383;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=icXTLdu+oAfbHgV+a1a6R81Jzy4yduyleRYr/cJc1s8=;
	b=GhB/naJ9fytO4QbWUZTwiXV5sgX8fcgLaQK8QVdUugU//H7Ct4cs/fJ5IF/4E5Ka4AkIxH
	km/mlT92GDvTGDvRu6kSMWXdXKuvGG+H4NgkdHqeeLD5ofl+1RO6uL6CNYJD3asOARkJhD
	aoGyLia1pdVc14K0A/9ne2i8vTC/XII=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-404-2Lb87x-ZMTWjT_STz7Lx8A-1; Fri, 23 Jul 2021 12:56:21 -0400
X-MC-Unique: 2Lb87x-ZMTWjT_STz7Lx8A-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 36F0BDC5A;
	Fri, 23 Jul 2021 16:56:17 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A98411007604;
	Fri, 23 Jul 2021 16:56:15 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 035E5180140E;
	Fri, 23 Jul 2021 16:56:13 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com
	[10.5.11.15])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 16NGuBJW003965 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 23 Jul 2021 12:56:11 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 8E4113A47; Fri, 23 Jul 2021 16:56:11 +0000 (UTC)
Received: from octiron.msp.redhat.com (unknown [10.15.80.209])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 6F6EB5D6AD;
	Fri, 23 Jul 2021 16:56:06 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
	by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 16NGu49U000417; 
	Fri, 23 Jul 2021 11:56:05 -0500
Received: (from bmarzins@localhost)
	by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 16NGu4e2000416;
	Fri, 23 Jul 2021 11:56:04 -0500
Date: Fri, 23 Jul 2021 11:56:03 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: lixiaokeng <lixiaokeng@huawei.com>
Message-ID: <20210723165603.GE3087@octiron.msp.redhat.com>
References: <37767722-8e6c-4176-d234-87134c21cd4c@huawei.com>
	<20210722214253.GC3087@octiron.msp.redhat.com>
	<85cb30a7-a873-b33d-4105-6e3e9675f105@huawei.com>
MIME-Version: 1.0
In-Reply-To: <85cb30a7-a873-b33d-4105-6e3e9675f105@huawei.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-loop: dm-devel@redhat.com
Cc: linfeilong <linfeilong@huawei.com>,
	dm-devel mailing list <dm-devel@redhat.com>,
	Martin Wilck <mwilck@suse.com>,
	"liuzhiqiang \(I\)" <liuzhiqiang26@huawei.com>
Subject: Re: [dm-devel] [Question] multipathd.service start failed when
 /var/run isn't mount
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

On Fri, Jul 23, 2021 at 02:27:58PM +0800, lixiaokeng wrote:
> 
> 
> On 2021/7/23 5:42, Benjamin Marzinski wrote:
> > On Thu, Jul 22, 2021 at 10:51:22AM +0800, lixiaokeng wrote:
> >> When we enable multipathd.service with systemctl and reboot,
> >> multipathd doesn't start and log "failed to create pidfile".
> >>
> >> The reason is following:
> >>
> >> The RUN is /var/run in multipath-tools. When we start linux, we
> >> mount a disk to /var. So if multipathd.service start before mount,
> >> it will fail to activate.(If mount firstly, multipathd will start
> >> successfully)
> >>
> >> The RUN is defined in Makefile.inc:
> >>
> >> ifndef RUN
> >>         ifeq ($(shell test -L /var/run -o ! -d /var/run && echo 1),1)
> >>                 RUN=run
> >>         else
> >>                 RUN=var/run
> >>         endif
> >> endif
> >>
> >> Can it always be defined as run?
> > 
> > I believe all modern distributions make /var/run a symlink to /run.
> > However, if that's the case, then I don't understand why you are running
> > into this issue at all, since multipath should be using /run. What
> > multipath packages are you using?
> Yes, there is a symlink to /run in /var. But it is in the disk (such as
> sdb) mounted on /var actually. When reboot, systemd start multipathd
> service firstly then mount sdb to /var. In this way, the multipath
> service will not start.
> 
> After sdb mounted to /var, we can start multipathd service successfully.

But when the binaries were compiled, if /var/run existed and was a
symlink in your build environment, then RUN should equal "run", and
multipath should should be using /run instead of /var/run, right?

This is why I asked what multipath packages are you using.

-Ben
 
> > 
> > -Ben
> > 
> >>
> >> Regards,
> >> Lixiaokeng
> > 
> > .
> > 

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

