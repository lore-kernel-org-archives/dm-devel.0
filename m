Return-Path: <SRS0=zaPp=GX=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C481C433E0
	for <dm-devel@archiver.kernel.org>; Wed, 20 Jan 2021 13:05:17 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 50D4A23355
	for <dm-devel@archiver.kernel.org>; Wed, 20 Jan 2021 13:05:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 50D4A23355
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-223-1CQqKBOEPmyk-MQtczID5w-1; Wed, 20 Jan 2021 08:04:34 -0500
X-MC-Unique: 1CQqKBOEPmyk-MQtczID5w-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B05C0CE65A;
	Wed, 20 Jan 2021 13:04:29 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 3EF5A5D75A;
	Wed, 20 Jan 2021 13:04:29 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id C3B5D46F45;
	Wed, 20 Jan 2021 13:04:28 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 10KD2Vc2006580 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 20 Jan 2021 08:02:31 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 5FCF52166B33; Wed, 20 Jan 2021 13:02:31 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 5ABBC2166B31
	for <dm-devel@redhat.com>; Wed, 20 Jan 2021 13:02:28 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 40B1E8015B9
	for <dm-devel@redhat.com>; Wed, 20 Jan 2021 13:02:28 +0000 (UTC)
Received: from mail-lj1-f170.google.com (mail-lj1-f170.google.com
	[209.85.208.170]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-504-XMdz9TThMd-d27MpJ4kqsg-1; Wed, 20 Jan 2021 08:02:26 -0500
X-MC-Unique: XMdz9TThMd-d27MpJ4kqsg-1
Received: by mail-lj1-f170.google.com with SMTP id f11so25968444ljm.8;
	Wed, 20 Jan 2021 05:02:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:mime-version:references:in-reply-to:from:date
	:message-id:subject:to:cc;
	bh=DUsgLO7/WOOSw/K5bbQplwFcnSsbrz/PshMse9QHIFY=;
	b=QUfPNPV5vSWHXIBp+iXgHku8JREGHeCT1gMyKzigr/KF1s53uswSaHupqyX2alq0Ym
	9VI/o1BChuB0ejw8TpAnK3YguRJDDM7Bys4LdPldcpKdmstRmJsPmOfmpmRjLqWfROTp
	j+zd5NgHimxbhY9RsUnEb8fwmgww25qGeSEnjt3vWEEvtHl/dVgsYq/+z0tgStcmpZGV
	pU+MxQii1CI4bO0qcOjiIPVpMf4Wv0k2/IsYwCUq92y10ZpDTlgsJyMbt08KqFofoOtZ
	LIbML4aNVIneCDowi3Y6PcRcKosWlikiX7obt5LUWQHr2vlwNrOED9LU8jChGlAnONL8
	5VXg==
X-Gm-Message-State: AOAM533AHC0kXWwAeh8bnQNL1VJ6pMG5MiYTCJNlne6dZA++1ydL92MT
	NLkjaHjaoBNp+T1fOLYFqQZh1mBBQuWmXLxoajI=
X-Google-Smtp-Source: ABdhPJykkJe0cGFtnVMKqtssqi89Af9g1/6zduMYck0d8PficCPspWNuDWYCtUF0x9CUTuKGsQJzZJsz0uFHvPCU5ng=
X-Received: by 2002:a2e:8ec7:: with SMTP id e7mr4327165ljl.249.1611147744181; 
	Wed, 20 Jan 2021 05:02:24 -0800 (PST)
MIME-Version: 1.0
References: <063bbeeb-15aa-f7c0-b881-7526c3a2720c@huawei.com>
	<f86753b17cc7e85e7e0f7e711adec349323a7c5a.camel@suse.com>
In-Reply-To: <f86753b17cc7e85e7e0f7e711adec349323a7c5a.camel@suse.com>
From: Roger Heflin <rogerheflin@gmail.com>
Date: Wed, 20 Jan 2021 07:02:13 -0600
Message-ID: <CAAMCDec3jH4f+fFX1jjndG0g6iM5t-V+k+uFkEhBsU1EXHLRBA@mail.gmail.com>
To: Martin Wilck <mwilck@suse.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-loop: dm-devel@redhat.com
Cc: lixiaokeng <lixiaokeng@huawei.com>, lihaotian9@huawei.com,
	linfeilong <linfeilong@huawei.com>,
	dm-devel mailing list <dm-devel@redhat.com>,
	"liuzhiqiang \(I\)" <liuzhiqiang26@huawei.com>
Subject: Re: [dm-devel] [QUESTION]: multipath device with wrong path lead to
 metadata err
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

> verify_paths() would detect this. We do call verify_paths() in
> coalesce_paths() before calling domap(), but not immediately before.
> Perhaps we should move the verify_paths() call down to immediately
> before the domap() call. That would at least minimize the time window
> for this race. It's hard to avoid it entirely. The way multipathd is
> written, the vecs lock is held all the time during coalesce_paths(),
> and thus no uevents can be processed. We could also consider calling
> verify_paths() before *and* after domap().
>
> Was this a map creation or a map reload? Was the map removed after the
> failure? Do you observe the message "ignoring map" or "removing map"?
>
> Do you observe a "remove" uevent for sdi?
>

>
> I wonder if you'd see the issue also if you run the same test without
> the "multipath -F; multipath -r" loop, or with just one. Ok, one
> multipath_query() loop simulates an admin working on the system, but 2
> parallel loops - 2 admins working in parallel, plus the intensive
> sequence of actions done in multipathd_query at the same time? The
> repeated "multipath -r" calls and multipathd commands will cause
> multipathd to spend a lot of time in reconfigure() and in cli_* calls
> holding the vecs lock, which makes it likely that uevents are missed or
> processed late.
>
> Don't get me wrong, I don't argue against tough testing. But we should
> be aware that there are always time intervals during which multipathd's
> picture of the present devices is different from what the kernel sees.
>
> There's definitely room for improvement in multipathd wrt locking and
> event processing in general, but that's a BIG piece of work.
>
>

I don't know if this helps, or is exactly like what he is duplicating:

I debugged and verified a corruption issue a few years ago where this
was what happened:

DiskA was presented at say sdh (via SAN) and a multipath device was
created on top of its paths, then diskA was unpresented and new disks
were put back in the same zone.
DiskB was now presented in the same slot (zone+lunid/sdh) and
inherited by the still in place multipath device/mapping.    In this
case I don't believe there was ever a device level event for sdh.

In our case, we did not log a case with our vendor as this was never
supposed to happen and this seemed at the time to be how we expected
it to work and because during the unpresent a script was supposed to
have been run to clean up all of the dead paths prior to any new
storage being presented.

You might have to verify the path is still the same device any time
you are recovering from a path like failure since in the above case
the sdh device always existed but had the underlying storage/lun
changed.   I am not sure in his case if this is what is going on or if
the sdX device he is using actually goes away in his test.

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

