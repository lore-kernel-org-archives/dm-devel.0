Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 10FE4C19F28
	for <dm-devel@archiver.kernel.org>; Wed,  3 Aug 2022 16:30:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1659544228;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=ix8sm6HktgAUiBbOkJrHqfiqGAhCVwcJ+hsFvljXUk4=;
	b=BLJALaeUE5/H6CjZw365TKQ6KyWs6ECVVcR8lFntmRX+1JUK6cl92zeeXQfKx7Hay21tsC
	M/5ZFr+6htslvX3G+0MZydIndLscUVYKBeZWAddilHoyeaCufai/BtTxofk6qc2xRDY5Jm
	BuU+I3RwgcQX+3ffSJ4KDZA9Lj0bzdo=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-619-7s4rae1_M1mNr6IKIoHM2w-1; Wed, 03 Aug 2022 12:30:25 -0400
X-MC-Unique: 7s4rae1_M1mNr6IKIoHM2w-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C4A7E801585;
	Wed,  3 Aug 2022 16:30:22 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id A6B432026D4C;
	Wed,  3 Aug 2022 16:30:22 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 775461946A4E;
	Wed,  3 Aug 2022 16:30:22 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id E34F11946A4E
 for <dm-devel@listman.corp.redhat.com>; Wed,  3 Aug 2022 16:30:20 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id C121A40C1288; Wed,  3 Aug 2022 16:30:20 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id BCF68403D0D0
 for <dm-devel@redhat.com>; Wed,  3 Aug 2022 16:30:20 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A01FB18A0165
 for <dm-devel@redhat.com>; Wed,  3 Aug 2022 16:30:20 +0000 (UTC)
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-531-wdwip-IHMO-U7OTqmCwwhQ-1; Wed, 03 Aug 2022 12:30:19 -0400
X-MC-Unique: wdwip-IHMO-U7OTqmCwwhQ-1
Received: by mail-qk1-f200.google.com with SMTP id
 v13-20020a05620a0f0d00b006b5f0ec742eso13749850qkl.2
 for <dm-devel@redhat.com>; Wed, 03 Aug 2022 09:30:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
 bh=JEGwHpj/JAt/PomUVgL9JssMeg6/tOcFaY2m43nKSN0=;
 b=bxoxb+H/wPfsPVvoGI48IBo+tUMEbzDKRb4bpouaP1h91hKxvLIZ1Mvkc7zMb9OaAW
 1Lo+uOK6J0H4oelZovKYZeADtwwferbWEb0ClaQzUT+pf6v4RI6wBGn5IH52n9Us2Axf
 TvljP2uF5eb+nuURFlAo4IIF47oBsuK6Knm2YRIeISgd29BElJT8wwLx5+Dwuilg4NYy
 DJvbph2ZCrMA5pwKYBA1HjoFmCqmTeZSUmMmshhgTD7Pv7CWYwkKXvmHdd+TAXT2qiob
 kXRjRKn8/Gp3+uPAy6t/y87skYaEy252QbMGVtuKq8HNVqV19m+zKievMzCBQ7UGkjNS
 SN9g==
X-Gm-Message-State: ACgBeo1Z+D9DgrLi9DtVisqzFfl7/yPvrSJ3S+psgBWT0u/2Cx7P4pYH
 EwdO90AXhJx92V3Wfx9YHJm79py7eYNzW/gC8O2PIBQY/4vkfijUCdtbagyXRNSCZhTIyYSPe9c
 5FRdX+7axbfMrTQ==
X-Received: by 2002:a05:6214:4110:b0:476:d05d:71b3 with SMTP id
 kc16-20020a056214411000b00476d05d71b3mr9018253qvb.62.1659544218812; 
 Wed, 03 Aug 2022 09:30:18 -0700 (PDT)
X-Google-Smtp-Source: AA6agR5LbF1YWJL806wlgYMcddrY8rF1HHtfxNxg5ADl1BxWTZTR5HYT7ulzVwzYJpFHKEpcrLpQxA==
X-Received: by 2002:a05:6214:4110:b0:476:d05d:71b3 with SMTP id
 kc16-20020a056214411000b00476d05d71b3mr9018234qvb.62.1659544218629; 
 Wed, 03 Aug 2022 09:30:18 -0700 (PDT)
Received: from localhost (pool-68-160-173-162.bstnma.fios.verizon.net.
 [68.160.173.162]) by smtp.gmail.com with ESMTPSA id
 bs11-20020a05620a470b00b006b5ef0aff29sm13015523qkb.87.2022.08.03.09.30.17
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 03 Aug 2022 09:30:17 -0700 (PDT)
Date: Wed, 3 Aug 2022 12:30:16 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: Daniil Lunev <dlunev@chromium.org>
Message-ID: <YuqimBLSh/4wvoDU@redhat.com>
References: <20220704000225.345536-1-dlunev@chromium.org>
 <20220704100221.1.I15b3f7a84ba5a97fde9276648e391b54957103ff@changeid>
 <YtB45Lte5UhlEE6y@redhat.com>
 <CAONX=-dEG121RQ6L-4fPMXrLXb3JeYNVNiPzHXNaRLbwRzb3bw@mail.gmail.com>
 <alpine.LRH.2.02.2207150528170.5197@file01.intranet.prod.int.rdu2.redhat.com>
 <cca5b463-a860-de8d-b7e4-a8d30aef2ff2@gmail.com>
 <CAONX=-fJHgfGkwR5A1MT+8FHckueehOsUS_LyHkjrgp4Y+vOgw@mail.gmail.com>
 <CAONX=-ft=ewFDui4jmd2fvcNr2EJc90=ZNOueDdp6HaPZmvObQ@mail.gmail.com>
 <Yun4LH+StcuBXRtO@sol.localdomain>
 <CAONX=-esLr5bGUks_a8wQBky37NnCawh2eOMemYg32HcPA7pmA@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAONX=-esLr5bGUks_a8wQBky37NnCawh2eOMemYg32HcPA7pmA@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Subject: Re: [dm-devel] [PATCH 1/1] dm: add message command to disallow
 device open
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
Cc: Brian Geffon <bgeffon@google.com>, Mike Snitzer <snitzer@kernel.org>,
 linux-kernel@vger.kernel.org, Zdenek Kabelac <zdenek.kabelac@gmail.com>,
 Eric Biggers <ebiggers@kernel.org>, dm-devel@redhat.com,
 Mikulas Patocka <mpatocka@redhat.com>, Alasdair Kergon <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, Aug 03 2022 at 12:29P -0400,
Daniil Lunev <dlunev@chromium.org> wrote:

> > This seems like an access control policy, which the Linux kernel already has a
> > lot of mechanisms for.  Chrome OS already uses SELinux.  Couldn't this be solved
> > by giving the device node an SELinux label that no one has permission to open?
> That would be the ideal solution, but there is a number of challenges
> that prevent
> us enabling enforcement on all SELinux domains unfortunately. While in the long
> run that would be a preferred option, in the short run this doesn't
> seem feasible. I
> would assume the problem of enabling full SELInux enforcement would plague
> any big project that didn't have them enabled from the get going.
> --Daniil

I'm not going to take this patch. It isn't the proper way to handle
preventing use of a DM device. In addition, the patch's header doesn't
speak to a proper review/audit of implications this change would have
on all aspects of a DM device's capabilities. If Chrome OS needs this
as a stop-gap then please carry it as needed.

Regards,
Mike

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

