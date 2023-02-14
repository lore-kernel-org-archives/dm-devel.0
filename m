Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3ED46C05027
	for <dm-devel@archiver.kernel.org>; Tue, 14 Feb 2023 22:48:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1676414894;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=aPstgBqKdoa5BHSR1SeXEpytSpBKL6BExqOyPEBYHkU=;
	b=KL224TSPVhkumSd0QxYnziEmhRioUqIJf2f6quD2hXUT8/jS1bqiqR/cF3nh8+KyUVCxMk
	FkYMlImKvAAqhrOzNXl1hPV/HWghwCkrXXPAwVsfRn8Ps8/nGCGNd4pn7MzGJ0q++u2jef
	DD2Omx2CMuix9YT2/rYiEdEhNB1Av4M=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-47-RCi41jxVN7mSCgtskVSr9w-1; Tue, 14 Feb 2023 17:48:12 -0500
X-MC-Unique: RCi41jxVN7mSCgtskVSr9w-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A557285CBE7;
	Tue, 14 Feb 2023 22:48:10 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 09AC82026D4B;
	Tue, 14 Feb 2023 22:48:09 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id CC6841946588;
	Tue, 14 Feb 2023 22:48:08 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 39E921946586
 for <dm-devel@listman.corp.redhat.com>; Tue, 14 Feb 2023 22:28:51 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 18409C15BAD; Tue, 14 Feb 2023 22:28:51 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 106D9C15BA0
 for <dm-devel@redhat.com>; Tue, 14 Feb 2023 22:28:51 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E943E183B3C3
 for <dm-devel@redhat.com>; Tue, 14 Feb 2023 22:28:50 +0000 (UTC)
Received: from mail-vs1-f51.google.com (mail-vs1-f51.google.com
 [209.85.217.51]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-265-A5ZoSO6MPEmF48h7sjkXHg-1; Tue, 14 Feb 2023 17:28:47 -0500
X-MC-Unique: A5ZoSO6MPEmF48h7sjkXHg-1
Received: by mail-vs1-f51.google.com with SMTP id p14so5799004vsn.0;
 Tue, 14 Feb 2023 14:28:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112; t=1676413726;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
 :reply-to;
 bh=plqHRAI8Pfx3LpYamylhfhBOqt+fLpnOArGMZObrn2U=;
 b=gY8GaxMwAEpL0ygMjvmBG46UVAeLVPHZG0DJMdH9aCAVToL2R7BddmJ7tgvG8fspIK
 cPz3/mAHFSu/0J+J+3oN9CWeeX5AGc/K1e0QCUcrGyqpXFVDfnpXpRU/o+h8wX6bmTmS
 1r8YU6xZB63QK25amxR/uXu1iBR0vzKzEna5vxqdrcPdKmTlTJDAPjxRyVAnK7o4cNUR
 h4sMuoG0rmq0ljGgndwyuAH+5LHShNkpRkvL/Su0x6gVPqGaMk98o6YbxXGfvL4aHnt4
 B3xuiTEwK9XMIW2JrioFUvA397Sg+nqWql7jMW5VMytf04DcGd1H7/9edNAseXP5SI41
 Xz3g==
X-Gm-Message-State: AO0yUKUN5tys99/uD1C+Z7bHTNoAhdEO/R+WsJMXmGzJrN27oFAMXC/j
 USAz9POnjmbx0P/DoNLqO5ea2zn+izGpmoxy/8jvNJVPi4g=
X-Google-Smtp-Source: AK7set/44hMy5ENsS6Z0/yejw8yOcoTBn/fVLjtxEYcM/BoKHwiJZY7crwQgI4SNayyqUDqO7Ab9vCsO4V6WthLRU8c=
X-Received: by 2002:a67:e0cf:0:b0:3fc:3a9e:3203 with SMTP id
 m15-20020a67e0cf000000b003fc3a9e3203mr73221vsl.84.1676413726415; Tue, 14 Feb
 2023 14:28:46 -0800 (PST)
MIME-Version: 1.0
References: <CACsaVZJvXpCt37nQOoe8qd1EPUpfdMM1HwHk9tVO8HdU_Azhhw@mail.gmail.com>
 <25578.37401.314298.238192@quad.stoffel.home>
 <CACsaVZJ-5y7U5xqwL9bof69EKbTk+wrHWFcBFYyP_BwVSt+CNA@mail.gmail.com>
 <CAM23Vxr8LkkcVDFfW1=qEYGgo7JG1qx62eWSV4WOw4_MnD+TZA@mail.gmail.com>
In-Reply-To: <CAM23Vxr8LkkcVDFfW1=qEYGgo7JG1qx62eWSV4WOw4_MnD+TZA@mail.gmail.com>
From: Roger Heflin <rogerheflin@gmail.com>
Date: Tue, 14 Feb 2023 16:28:36 -0600
Message-ID: <CAAMCDeeHxMBoVkNYAyssjgjo4=FYd2NonS-mqC7OUEL89B9Cig@mail.gmail.com>
To: Heinz Mauelshagen <heinzm@redhat.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
Subject: Re: [dm-devel] RAID4 with no striping mode request
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
Cc: John Stoffel <john@stoffel.org>,
 Linux-Kernel <linux-kernel@vger.kernel.org>, linux-raid@vger.kernel.org,
 Song Liu <song@kernel.org>, device-mapper development <dm-devel@redhat.com>,
 Kyle Sanderson <kyle.leet@gmail.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, Feb 14, 2023 at 3:27 PM Heinz Mauelshagen <heinzm@redhat.com> wrote:
>

>
>
> ...which is RAID1 plus a parity disk which seems superfluous as you achieve (N-1)
> resilience against single device failures already without the later.
>
> What would you need such parity disk for?
>
> Heinz
>

I thought that at first too, but threw that idea out as it did not
make much sense.

What he appears to want is 8 linear non-striped data disks + a parity disk.

Such that you can lose any one data disk and parity can rebuild that
disk.  And if you lose several data diskis, then you have intact
non-striped data for the remaining disks.

It would almost seem that you would need to put a separate filesystem
on each data disk/section (or have a filesystem that is redundant
enough to survive) otherwise losing an entire data disk would leave
the filesystem in a mess..

So N filesystems + a parity disk for the data on the N separate
filesystems.   And each write needs you to read the data from the disk
you are writing to, and the parity and recalculate the new parity and
write out the data and new parity.

If the parity disk was an SSD it would be fast enough, but if parity
was an SSD I would expect it to get used up/burned out from all of
parity being re-written for each write on each disk unless you bought
an expensive high-write ssd.

The only advantage of the setup is that if you lose too many disks you
still have some data.

It is not clear to me that it would be any cheaper if parity needs to
be a normal ssd's (since ssds are about 4x the price/gb and high-write
ones are even more) than a classic bunch of mirrors, or even say a 4
disks raid6 where you can lose any 2 and still have data.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

