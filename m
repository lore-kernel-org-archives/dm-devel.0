Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1F231E7D0AE
	for <dm-devel@archiver.kernel.org>; Thu, 21 Sep 2023 21:49:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1695332948;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=bzn6Hw26kMvkSOPKplU2avGsZB3Cc/EsK9GjZZTiajY=;
	b=TrZ5v/vVh+8IbP5u+qLJxivZa+oizYjc0pZfRa+3DmkECh4GfWGak/FdqY2GWnv9vQpXn8
	EWR0+qeVHNzFbRIoQbB9H5C3M170whJfFRGAfOd86xZCASc72fxxyeyfFGUTtNa5Do774N
	9KV/qBTjDZ948pWFcj3az69O6RHeU74=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-133-c1pvOKBnMte1F8DrmLiL1g-1; Thu, 21 Sep 2023 17:49:05 -0400
X-MC-Unique: c1pvOKBnMte1F8DrmLiL1g-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0478F85A5A8;
	Thu, 21 Sep 2023 21:49:03 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 8EA872904;
	Thu, 21 Sep 2023 21:49:02 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 64D691946595;
	Thu, 21 Sep 2023 21:49:01 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 7E2E61946586
 for <dm-devel@listman.corp.redhat.com>; Thu, 21 Sep 2023 21:45:28 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 389D29A; Thu, 21 Sep 2023 21:45:28 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 30DA710EA0
 for <dm-devel@redhat.com>; Thu, 21 Sep 2023 21:45:28 +0000 (UTC)
Received: from us-smtp-inbound-delivery-1.mimecast.com
 (us-smtp-delivery-1.mimecast.com [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 112D62812950
 for <dm-devel@redhat.com>; Thu, 21 Sep 2023 21:45:28 +0000 (UTC)
Received: from mail-qv1-f49.google.com (mail-qv1-f49.google.com
 [209.85.219.49]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-350-kg0XepicOAywO8QlWADyxA-1; Thu, 21 Sep 2023 17:45:26 -0400
X-MC-Unique: kg0XepicOAywO8QlWADyxA-1
Received: by mail-qv1-f49.google.com with SMTP id
 6a1803df08f44-65627d499e1so7707556d6.0
 for <dm-devel@redhat.com>; Thu, 21 Sep 2023 14:45:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20230601; t=1695332726; x=1695937526;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
 :message-id:reply-to;
 bh=QgzNGTzTkPRkR0XMm81Mz7n51ssIigIV04M2unjen8M=;
 b=M9RH0BpIg7xBOK+WQXTJupt+hJHDb7FRTLX3qxjHdm7KlfZEPC5fKJMmLgZ93dwi/A
 tf8xiTfo8mWsiPztsaQn8lXRVtVn5CbIWjgs6sz3oW0Ptn/ApqbHL9kEDUvdPIC0YwE0
 JnhcofICii5vr9Ey+4ekQ1SsW2avAycwr0g5uvpaIgIZNrVQU3LbkKXUXFo7GXWrmWcO
 tO6i+sQn2eCId+vh2OT8ST8nY1+XxKyDsSPXsQgHRgyLpr7fq6CzNfKUT8xodIF2LkSM
 mRe7xODt+Y2//La5ibn4CkuI7wBuY3XhczW5FAxLy5bbqxYHL7TsaLYyd2ONJBjdv9Lk
 2F2g==
X-Gm-Message-State: AOJu0Yzqmd502CFfxU7RG4VG4Rol72yPC8AV+m8QPUPwy03LgJSfdg/Z
 JVyFS5OpmCl7cktdmlCZlG7wtnU=
X-Google-Smtp-Source: AGHT+IEAJ1YG+6DyxdjHFvDbvTBrNOzDLMvzeb50IyfajoiVHlzIhioS9od5xLSKftza0uwpbddERg==
X-Received: by 2002:a0c:f548:0:b0:63c:fbd0:6361 with SMTP id
 p8-20020a0cf548000000b0063cfbd06361mr6110413qvm.37.1695332725726; 
 Thu, 21 Sep 2023 14:45:25 -0700 (PDT)
Received: from localhost (pool-68-160-141-91.bstnma.fios.verizon.net.
 [68.160.141.91]) by smtp.gmail.com with ESMTPSA id
 n1-20020a0ce481000000b006588bd29c7esm905832qvl.28.2023.09.21.14.45.25
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 21 Sep 2023 14:45:25 -0700 (PDT)
Date: Thu, 21 Sep 2023 17:45:24 -0400
From: Mike Snitzer <snitzer@kernel.org>
To: Kirill Kirilenko <kirill@ultracoder.org>
Message-ID: <ZQy5dClooWaZoS/N@redhat.com>
References: <0e15b760-2d5f-f639-0fc7-eed67f8c385c@ultracoder.org>
MIME-Version: 1.0
In-Reply-To: <0e15b760-2d5f-f639-0fc7-eed67f8c385c@ultracoder.org>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
Subject: Re: [dm-devel] fstrim on raid1 LV with writemostly PV leads to
 system freeze
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
Cc: linux-raid@vger.kernel.org, heinzm@redhat.com, dm-devel@redhat.com,
 Alasdair Kergon <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

[cc'ing Heinz and the linux-raid mailing list]

On Thu, Sep 21 2023 at  4:34P -0400,
Kirill Kirilenko <kirill@ultracoder.org> wrote:

> Hello.
> 
> I created two LVM physical volumes: one on NVMe device and one on SATA SSD.
> I added them to a volume group and created a logical RAID1 volume in it.
> Then I enabled 'writemostly' flag on the second (slowest) PV.
> And my system started to freeze at random times with no messages in syslog.
> I was able to determine that the freezing was happening during execution of
> 'fstrim' (via systemd timer). I checked this by running 'fstrim' manually.
> If I disable the 'writemostly' flag, I experience no freezes. I can
> reproduce this behavior on vanilla 6.5.0 kernel.
> 
> My LV is 150 GB ext4 volume, and it has lots of files in it, so running
> 'fstrim' takes around a minute. This may be important.
> 
> Additional information:
> OS: Linux Mint 21.2
> CPU: AMD Ryzen 7 5800X
> NVMe: Samsung SSD 980 500GB
> SATA SSD: Samsung SSD 850 EVO M.2 250GB
> 
> Best regards,
> Kirill Kirilenko.
> 

I just verified that 6.5.0 does have this DM core fix (needed to
prevent excessive splitting of discard IO.. which could cause fstrim
to take longer for a DM device), but again 6.5.0 has this fix so it
isn't relevant:
be04c14a1bd2 dm: use op specific max_sectors when splitting abnormal io

Given your use of 'writemostly' I'm inferring you're using lvm2's
raid1 that uses MD raid1 code in terms of the dm-raid target.

Discards (more generic term for fstrim) are considered writes, so
writemostly really shouldn't matter... but I know that there have been
issues with MD's writemostly code (identified by others relatively
recently).

All said: hopefully someone more MD oriented can review your report
and help you further.

Mike

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

