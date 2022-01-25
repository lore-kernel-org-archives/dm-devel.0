Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 147A5C28CF5
	for <dm-devel@archiver.kernel.org>; Wed, 26 Jan 2022 04:41:54 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-622-qp6Pmod5P2yni1uwcJez6g-1; Tue, 25 Jan 2022 23:41:49 -0500
X-MC-Unique: qp6Pmod5P2yni1uwcJez6g-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 727C72F5B;
	Wed, 26 Jan 2022 04:41:44 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 0C9DB7F814;
	Wed, 26 Jan 2022 04:41:43 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id C19694BB7C;
	Wed, 26 Jan 2022 04:41:42 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
	[10.11.54.7])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 20PHC69F005651 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 25 Jan 2022 12:12:06 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id EE4311454548; Tue, 25 Jan 2022 17:12:05 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id EA6FC1454539
	for <dm-devel@redhat.com>; Tue, 25 Jan 2022 17:12:05 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D1B453803919
	for <dm-devel@redhat.com>; Tue, 25 Jan 2022 17:12:05 +0000 (UTC)
Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com
	[209.85.218.49]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-532-UdYZio87MfOtJkmm-1YKcA-1; Tue, 25 Jan 2022 12:12:04 -0500
X-MC-Unique: UdYZio87MfOtJkmm-1YKcA-1
Received: by mail-ej1-f49.google.com with SMTP id d10so31951941eje.10
	for <dm-devel@redhat.com>; Tue, 25 Jan 2022 09:12:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:mime-version:references:in-reply-to:from:date
	:message-id:subject:to;
	bh=nNrS4+Y2kpA/4I+O0j+MEfMovuuGqzczw7+9uw0ZYvg=;
	b=M15zLhFx+rfo6oLTUclE9WgbbRkXn1HmOSolMNwLtFA48tqOM+Zct9rPvb6ssU7cXq
	g7GlYBjimtQp/IyQ5Hxo8dhpmlvMJewJRGfyt69jpRtE9+QvHhZTADTOQEgg+mHdIJPk
	EPnq+at/WF4dmN6yrELBKyzWn84fjGARAS1qGZFpyU3+gyLNwaYuPqKApaqxNHtYPmAn
	YJ/vRWs9r0/AuNwD9REYHT7XsaExlj3Q0Y1/z3wr3JsX4c+6bRBmKHJvWmyoTGoiCHrn
	DMopONJLdcHJEkmtm0iduqZ0LoX1aey2ZxTXfhlQ7q7H/PEi6TviypPGCB6adRvEswF2
	rfuw==
X-Gm-Message-State: AOAM531lF3xPvqBbXyLvYYcRl8yWQ3n+3NGgYE08uSqH9EkVZHBaowek
	EY9hQg/2AVDIlfWDm2kIbBDlGt5mHlrezsm/zQDCcA==
X-Google-Smtp-Source: ABdhPJyLfH1HWR8h43VVS0XIc2bSN8+5RKivIAAJh8I8ticiEoS9VRmwfk9Jaw3pumNtgYCON/DHMifOOqFaP9jHNro=
X-Received: by 2002:a17:907:e87:: with SMTP id
	ho7mr1513006ejc.481.1643130722625; 
	Tue, 25 Jan 2022 09:12:02 -0800 (PST)
MIME-Version: 1.0
References: <20220124150209.22202-1-bgeffon@google.com>
	<20220124151434.GB20331@agk-cloud1.hosts.prod.upshift.rdu2.redhat.com>
	<CADyq12ykDCswWZw05OdyYfP-zT6afuhXbckii1m1egQ2fSwB4w@mail.gmail.com>
	<20220125002025.GA21887@agk-cloud1.hosts.prod.upshift.rdu2.redhat.com>
In-Reply-To: <20220125002025.GA21887@agk-cloud1.hosts.prod.upshift.rdu2.redhat.com>
From: Brian Geffon <bgeffon@google.com>
Date: Tue, 25 Jan 2022 12:11:26 -0500
Message-ID: <CADyq12wE7mx2tPeK0gaLhBaUStrvV7cgfXqj7vWZ4F=KfR7zzQ@mail.gmail.com>
To: Brian Geffon <bgeffon@google.com>, Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com,
	LKML <linux-kernel@vger.kernel.org>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Tue, 25 Jan 2022 23:35:56 -0500
Subject: Re: [dm-devel] [PATCH] dm: introduce a no open flag for deferred
	remove
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Mon, Jan 24, 2022 at 7:21 PM Alasdair G Kergon <agk@redhat.com> wrote:
>
> On Mon, Jan 24, 2022 at 10:25:47AM -0500, Brian Geffon wrote:
> > Thank you for looking at this. There are a few reasons this might be
> > useful, the first is if you're trying to speed up a graceful teardown
> > of the device by informing userspace that this device is going to be
> > removed in the near future. Another might be on systems where it might
> > be worthwhile to not have users with CAP_DAC_OVERRIDE be able to open
> > the device. The logic on this second case is that, suppose you have a
> > dm-crypt block device which is backing swap, the data on this device
> > is ephemeral so a flow might be to setup swap followed by dmsetup
> > remove --deferred /dev/mapper/encrypted-swap. This will guarantee that
> > as soon as swap is torn down the encrypted block device is dropped,
> > additionally with this new flag you'll be guaranteed that there can be
> > no further opens on it.
>
> And is that the reason you propose this?
> - You want a special exclusive 'one time open' device that
>   self-destructs when closed?
>
> > No, this is fully backwards compatible with the current deferred
> > remove behavior, it's not required. Additionally, since on the actual
> > remove userspace would receive an -ENXIO already once the remove
> > process has started it seems reasonable to return -ENXIO in the
> > deferred remove case when this flag is enabled.
>
> Well I feel it does break existing semantics which is why we wrote
> the code the way we did.  The state can be long-lived, the code
> that has it open might legitimately want to open it again in
> parallel etc. - in general this seems a bad idea.
>
> But if the reason for this is basically "make it harder for
> anything else to access my encrypted swap" and to deliberately
> prevent access, then let's approach the requirement from that angle.
> Are there alternative implementations with interventions at different
> points?

I was thinking perhaps another implementation might involve using
open_count on dm_ioctl as an in param on DM_DEV_CREATE only. Using
open_count as an in parameter on DM_DEV_CREATE could be activated by a
new flag, perhaps DM_ENFORCE_OPEN_COUNT_FLAG. This would allow the
behavior to be baked into the device from the start. We would then
enforce it in dm_blk_open. What would you think about an approach like
this?

Thanks,
Brian

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

