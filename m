Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 10C5CC433EF
	for <dm-devel@archiver.kernel.org>; Tue, 23 Nov 2021 23:37:15 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-568-_ZvlJltiMW2-wx_wvLcbdw-1; Tue, 23 Nov 2021 18:37:11 -0500
X-MC-Unique: _ZvlJltiMW2-wx_wvLcbdw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 647921922025;
	Tue, 23 Nov 2021 23:37:07 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 370A960862;
	Tue, 23 Nov 2021 23:37:07 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id D718D4E58F;
	Tue, 23 Nov 2021 23:37:06 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
	[10.11.54.1])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1ANNRxMq028008 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 23 Nov 2021 18:27:59 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 150CF4010FE9; Tue, 23 Nov 2021 23:27:59 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 100AD40149A9
	for <dm-devel@redhat.com>; Tue, 23 Nov 2021 23:27:59 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E96AE808784
	for <dm-devel@redhat.com>; Tue, 23 Nov 2021 23:27:58 +0000 (UTC)
Received: from mail-ua1-f47.google.com (mail-ua1-f47.google.com
	[209.85.222.47]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-453-HWOKgHpSOse5btZdvyPzJA-1; Tue, 23 Nov 2021 18:27:57 -0500
X-MC-Unique: HWOKgHpSOse5btZdvyPzJA-1
Received: by mail-ua1-f47.google.com with SMTP id p37so1200547uae.8
	for <dm-devel@redhat.com>; Tue, 23 Nov 2021 15:27:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:mime-version:references:in-reply-to:from:date
	:message-id:subject:to;
	bh=CH0uplYCU+Cj7LRpYlXRpplkEzPyhoQ86Q0PlJEHWbQ=;
	b=7wmy25AKWNFLrPHACQoNqz7i1WO5a7JXRgpFJCmRhOsaLlOatryN9R+aX1dc4PgAEd
	wXNTPcXK/TyjQyiieNy23+GjEq3QZkHZeSKitZWLCHG3CxQeX5lkipHHtFSwmf57fkk4
	k0GTLJsxQJ95jOIfolUykzWuajTvpB+QzSz5xENnyBxxpWNjjE4X6ZY+3boy255U/Q34
	rxAqnjWRGK8pdW8y1PAdjB8HE7YqZ6mewr8cLnkxpjjSuPdfQINazpCIYaT4qkWemOnz
	HHHcvtqhPmathPEA8/AlL5VK5wyFL0vDP5leOIBWa2UpgwXTVdStC73fg7YdEEfaCVuH
	QBQg==
X-Gm-Message-State: AOAM533EpNQSbB54on983aahGsW0dUgOJWA6z/7b/Ec+YICGD+2OEyvm
	+cEBjeLFjFuBudu1cQKCQHYeJaBTjb6HdVCG3NoqvA==
X-Google-Smtp-Source: ABdhPJz9ZQlQ5LgMRXAxJOy7jAn4didm0zk/ZVZnGGxHGMey0KokX1VQk4OI6m0ft8rIfSd5SSA1YWtfqOMZpNgYAQ4=
X-Received: by 2002:a05:6102:3748:: with SMTP id
	u8mr15561798vst.48.1637710076540; 
	Tue, 23 Nov 2021 15:27:56 -0800 (PST)
MIME-Version: 1.0
References: <alpine.LRH.2.02.2111231421490.24195@file01.intranet.prod.int.rdu2.redhat.com>
	<CABSDvDJX8tVtGbuxo_Xqo=7GNd66W_FoVk=i6Kssp-6zP5cmmA@mail.gmail.com>
	<20211123231518.GA63964@agk-cloud1.hosts.prod.upshift.rdu2.redhat.com>
In-Reply-To: <20211123231518.GA63964@agk-cloud1.hosts.prod.upshift.rdu2.redhat.com>
From: David Anderson <dvander@google.com>
Date: Tue, 23 Nov 2021 15:27:45 -0800
Message-ID: <CA+FmFJBs9ocSbXHxdEncdGRRByamziXc+h9DMNH=r6qWPk3nzQ@mail.gmail.com>
To: Akilesh Kailash <akailash@google.com>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Mike Snitzer <msnitzer@redhat.com>, Alasdair Kergon <agk@redhat.com>,
	Jonathan Brassow <jbrassow@redhat.com>,
	Heinz Mauelshagen <heinzm@redhat.com>,
	David Anderson <dvander@google.com>, dm-devel@redhat.com
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Tue, 23 Nov 2021 18:32:52 -0500
Subject: Re: [dm-devel] [PATCH] announcing the dm-update target
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

In our ecosystem, the OTA generation and on-device application process
has evolved continually, in every release, for over 10 years now. So
we think it's unlikely that we'll stop making improvements to it. Our
current roadmap has other changes in the pipeline too. It's not just
us trying to eek out diminishing returns. Other parts of the system
change around us, and the OTA system needs to adapt.

The performance penalty is something we've been working on, and have
improved a lot since our first iteration. We're currently
experimenting with io_uring as well.

Best,

-David

On Tue, Nov 23, 2021 at 3:17 PM Alasdair G Kergon <agk@redhat.com> wrote:
>
> On Tue, Nov 23, 2021 at 02:27:18PM -0800, Akilesh Kailash wrote:
> > On Tue, Nov 23, 2021 at 1:03 PM Mikulas Patocka <mpatocka@redhat.com> wrote:
> > Older devices do not get new kernel features, only LTS updates. On the
> > other hand, by having
> > it in user-space, we have more control by adding in new features. For
> > ex: On Android S, we
> > introduced the first version of Android COW format. Now in Android T,
> > we plan to support
> > new features by having XOR compression (which saves more space).
>
> While you are developing this, sure, you're finding new ways that
> make significant space savings and want to roll them out easily
> and the userspace approach helps you to do that.
>
> But the law of diminishing returns will eventually kick in, where you
> have reached a format that provides "good enough" space savings and then
> reducing the runtime performance penalty will become the overriding
> concern and that'll point back to an in-kernel solution.
>
> So that's the end point I think we are aiming for here.  Combining the
> requirements to find a sweet spot between space saving and performance.
>
> By then, the ability still to make a tweak that saves a tiny bit more
> space isn't going to be worth paying an ongoing performance penalty
> for.  (And there could still be some sort of ebpf-style option.)
>
> Alasdair
>

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

