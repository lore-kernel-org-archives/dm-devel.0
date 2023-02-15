Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DA411C636CC
	for <dm-devel@archiver.kernel.org>; Wed, 15 Feb 2023 11:46:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1676461568;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=KxXMeVpi0HAPQqregI5sh2BFhzGt9O9Bkx8Ayb2C38U=;
	b=BIw4AjDibPk5ECoXUq+/zuL7fBUvqxtHVXWkSPMxbaOl1xB6//kV1AoBvDiK0sK1cp6gXC
	dv5mtbpK+iNMv67a9q13yQoq8XBVclMdLPxV7orew2kdN2aYQYiG4KnxVp6PHq3hSni0NH
	YasIXoLGz97KRwCsKvEpubqgTDHTx0g=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-244-jDPvvY1mONe5JVUcljc42Q-1; Wed, 15 Feb 2023 06:46:05 -0500
X-MC-Unique: jDPvvY1mONe5JVUcljc42Q-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2E9BC2999B3C;
	Wed, 15 Feb 2023 11:46:03 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id E90D340C10FA;
	Wed, 15 Feb 2023 11:46:01 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 9FD1319465B2;
	Wed, 15 Feb 2023 11:46:01 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 4420C1946588
 for <dm-devel@listman.corp.redhat.com>; Wed, 15 Feb 2023 11:44:16 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 3750C1415108; Wed, 15 Feb 2023 11:44:16 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 2F588140EBF4
 for <dm-devel@redhat.com>; Wed, 15 Feb 2023 11:44:16 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 04EFD3828893
 for <dm-devel@redhat.com>; Wed, 15 Feb 2023 11:44:16 +0000 (UTC)
Received: from mail-ua1-f51.google.com (mail-ua1-f51.google.com
 [209.85.222.51]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-52-ue7jxqdGPz-W_JdF7xyGfw-1; Wed, 15 Feb 2023 06:44:14 -0500
X-MC-Unique: ue7jxqdGPz-W_JdF7xyGfw-1
Received: by mail-ua1-f51.google.com with SMTP id z18so759025uav.1;
 Wed, 15 Feb 2023 03:44:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
 :reply-to;
 bh=awt3h/BgoD85tVDVGLaiObMzjnTgyZo2ngbTA8DaEYU=;
 b=0kkiBzATSXAekW0mzBifyt+h5LsgPumTKFKsyRECegl5xboeMuoiHp+AxJT5tcvtuk
 ned35J4V+lquATUbeB1Fzk4VD578qAtdk97MNU9Qs/lJ1+KI1Ug95X2aZPaUNeSgNpDj
 a2tVzjOAg6uZN7hA3iUOrWwDhMqVhYzF8Yl7dhj6JrRWRXAxqlIALj5yD54ubvNqH3nu
 Rw8rmvXXQaro6xjFwvmCnf8rm8wrYZ5HzuSYd9x9xGRLfh/ydLtdo/7XhxoK/Ilt+qeb
 a2lFwxMt41O2FgMCPDAXGdilXJ+yRLm2aA6L+WmjSmMh1J1ea80qC1UAMPGN4aFU92Fl
 X8NQ==
X-Gm-Message-State: AO0yUKWGU2dmpJ2JdTgFkxp9gUSGzWXuyynsuk9qVJqK91ySrTvNwZT9
 JqSu6c46qBcGQQY0osFhs9U7MbnmD3y+veI9oT15xuxajzY=
X-Google-Smtp-Source: AK7set/cc8b3+yjQliSQxdGVVOWi0u4hi6UpB28JhdhTs5H7m2uu+c6gg9rdkck8h74qXS86Mag3LLrKkqbBVvuMbac=
X-Received: by 2002:a05:6130:2104:b0:68a:570a:8ddb with SMTP id
 cl4-20020a056130210400b0068a570a8ddbmr217187uab.4.1676461453461; Wed, 15 Feb
 2023 03:44:13 -0800 (PST)
MIME-Version: 1.0
References: <CACsaVZJvXpCt37nQOoe8qd1EPUpfdMM1HwHk9tVO8HdU_Azhhw@mail.gmail.com>
 <25578.37401.314298.238192@quad.stoffel.home>
 <CACsaVZJ-5y7U5xqwL9bof69EKbTk+wrHWFcBFYyP_BwVSt+CNA@mail.gmail.com>
 <CAM23Vxr8LkkcVDFfW1=qEYGgo7JG1qx62eWSV4WOw4_MnD+TZA@mail.gmail.com>
 <CAAMCDeeHxMBoVkNYAyssjgjo4=FYd2NonS-mqC7OUEL89B9Cig@mail.gmail.com>
 <CAM23VxpzY6qYsdTYxe01FT7AJvEbODf8X_vq8ALL35TfyrB8xQ@mail.gmail.com>
In-Reply-To: <CAM23VxpzY6qYsdTYxe01FT7AJvEbODf8X_vq8ALL35TfyrB8xQ@mail.gmail.com>
From: Roger Heflin <rogerheflin@gmail.com>
Date: Wed, 15 Feb 2023 05:44:01 -0600
Message-ID: <CAAMCDee2hV1YP=119Rorz1uGTnyBD5q9hb20PvMq89FHow2wPw@mail.gmail.com>
To: Heinz Mauelshagen <heinzm@redhat.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

I think he is wanting the parity across the data blocks on the
separate filesystems (some sort of parity across fs[1-8]/block0 to
parity/block0).

it is not clear to me what this setup would be enough better than what
the current setups.    Given that one could have 8 spin + 1ssd or 12
spin for the same price.    And 2 6 disk raid6's would have the same
usable space, and be pretty safe (can lose any 2 of the 6 and lose no
data).  And given the separate filesystems requirement that would
require some software above the filesystems to manage spreading the
disks across multiple filesystems.   The risk of another disk going
bad (while one was failed) and losing a disk's worth of data would
push me to use the 6-disk raid6.

WOL: current SSD's are rated for around 1000-2000 writes.  So a 1Tb
disk can sustain 1000-2000TB of total writes.  And writes to
filesystem blocks would get re-written more often than data blocks.
 How well it would work would depend on how often the data is deleted
and re-written.   If the disks are some sort of long term storage then
the SSD is not going to get used up.   And I am not sure if the rated
used up really means anything unless you are using a STUPID enterprise
controller that proactively disables/kills the SSD when it says the
rated writes have happened.   I have a 500GB ssd in a mirror that
"FAILED" according to smart 2 years ago and so far is still fully
functional, and it is "GOOD" again because the counters used to
determine total writes seems to have rolled over.

On Tue, Feb 14, 2023 at 8:23 PM Heinz Mauelshagen <heinzm@redhat.com> wrote:
>
> Roger,
>
> as any of the currently implemented 'parity' algorithms (block xor/P-/Q-Syndrome) provided by DM/MD RAID
> have to have at least two data blocks to calculate:  are you, apart from the filesystem thoughts you bring up, thinking
> about running those on e.g. pairs of disks of mentioned even numbered set of 8?
>
> Heinz
>
> On Tue, Feb 14, 2023 at 11:28 PM Roger Heflin <rogerheflin@gmail.com> wrote:
>>
>> On Tue, Feb 14, 2023 at 3:27 PM Heinz Mauelshagen <heinzm@redhat.com> wrote:
>> >
>>
>> >
>> >
>> > ...which is RAID1 plus a parity disk which seems superfluous as you achieve (N-1)
>> > resilience against single device failures already without the later.
>> >
>> > What would you need such parity disk for?
>> >
>> > Heinz
>> >
>>
>> I thought that at first too, but threw that idea out as it did not
>> make much sense.
>>
>> What he appears to want is 8 linear non-striped data disks + a parity disk.
>>
>> Such that you can lose any one data disk and parity can rebuild that
>> disk.  And if you lose several data diskis, then you have intact
>> non-striped data for the remaining disks.
>>
>> It would almost seem that you would need to put a separate filesystem
>> on each data disk/section (or have a filesystem that is redundant
>> enough to survive) otherwise losing an entire data disk would leave
>> the filesystem in a mess..
>>
>> So N filesystems + a parity disk for the data on the N separate
>> filesystems.   And each write needs you to read the data from the disk
>> you are writing to, and the parity and recalculate the new parity and
>> write out the data and new parity.
>>
>> If the parity disk was an SSD it would be fast enough, but if parity
>> was an SSD I would expect it to get used up/burned out from all of
>> parity being re-written for each write on each disk unless you bought
>> an expensive high-write ssd.
>>
>> The only advantage of the setup is that if you lose too many disks you
>> still have some data.
>>
>> It is not clear to me that it would be any cheaper if parity needs to
>> be a normal ssd's (since ssds are about 4x the price/gb and high-write
>> ones are even more) than a classic bunch of mirrors, or even say a 4
>> disks raid6 where you can lose any 2 and still have data.
>>

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

