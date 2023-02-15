Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6EFDFC61DA4
	for <dm-devel@archiver.kernel.org>; Wed, 15 Feb 2023 02:23:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1676427822;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:in-reply-to:in-reply-to:
	 references:references:list-id:list-help:list-unsubscribe:
	 list-subscribe:list-post; bh=Blk9ncRlwGVvk5osmM+29tJ5zuAe4XIrXHUgam7+E94=;
	b=PhGS5ehI/Fu48eE1ObPgGzf7UdT7iYGDV1FTVTohi/LdAAa8+6ba+ppXvZTwmx+G6PB9uo
	4h21f8WuHlkBKZGqSH7YE2/28T0w3wFvLr5zZ84akkkI+F5BY6UUW7Si/f8uHqKrXwNDQX
	2W6Kb4Iou/AUODLOPfxI/j6xSdctQw4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-564-FqVBa6uMNf66yMt78DCSdg-1; Tue, 14 Feb 2023 21:23:38 -0500
X-MC-Unique: FqVBa6uMNf66yMt78DCSdg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1EE6C811E6E;
	Wed, 15 Feb 2023 02:23:37 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 1F6164035703;
	Wed, 15 Feb 2023 02:23:35 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id DD2D41946588;
	Wed, 15 Feb 2023 02:23:34 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 166B01946586
 for <dm-devel@listman.corp.redhat.com>; Wed, 15 Feb 2023 02:23:31 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id F0E6018EC7; Wed, 15 Feb 2023 02:23:30 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id E95601C55A
 for <dm-devel@redhat.com>; Wed, 15 Feb 2023 02:23:30 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C95568588E1
 for <dm-devel@redhat.com>; Wed, 15 Feb 2023 02:23:30 +0000 (UTC)
Received: from mail-ua1-f69.google.com (mail-ua1-f69.google.com
 [209.85.222.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-468-kiuyIyyxO7KCYnoEw7A30w-1; Tue, 14 Feb 2023 21:23:29 -0500
X-MC-Unique: kiuyIyyxO7KCYnoEw7A30w-1
Received: by mail-ua1-f69.google.com with SMTP id
 e15-20020ab02b0f000000b0066119a9d3bbso6197734uar.21
 for <dm-devel@redhat.com>; Tue, 14 Feb 2023 18:23:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
 :reply-to;
 bh=IiaF6fJCTHH6dvzKfS96ZCPb4HOU6dOwDNaS95JOYjg=;
 b=bM9usn24z4orgReC6R/q5Jzilr2rkc0dZhqWlxnnu/iU23dn3K235TtHi3RSiiJWpw
 F6v+i30/hReaUtDVmVBFiJGCKNk0wmaqDnorIJklIyUa1qYqdi3XbBOGjUBR1HUfH+vJ
 wG6ZWPI7MLd2IMDO0dGgGBNP9v3Hi/XiwsmxCMds7Lql92LF5Ymg+7TNROEZu+tzU+Gj
 LeRkTboBcg5v1nVdCYtkAuFPFwxaiPIbE+Ndu88RuVBaPtGvN0eB6o5Arf0/FNJ6PwT8
 7A+gOBbYz4cKHYXIluIZAgn61m9pTvcNJRA5UoE1fp2CQE7yr1Gz7HG2NtjdhcY92qgJ
 /tEw==
X-Gm-Message-State: AO0yUKWU9GhQBn9034p6/WezpkGDRDB7liuqsUUyXxDlOUJxt7tuPFuB
 H2bUvSblTwzeTpDQ/i25JeSveESXqnq4KZOSrBNe7PwwLscf4uRZ/hs5aN+FD2XP7ywlSYOOIFG
 34qvi/iFggzejTPHM6fJ5H9j4l/KKZvc=
X-Received: by 2002:a1f:2510:0:b0:401:b89:5375 with SMTP id
 l16-20020a1f2510000000b004010b895375mr88032vkl.22.1676427808719; 
 Tue, 14 Feb 2023 18:23:28 -0800 (PST)
X-Google-Smtp-Source: AK7set9UuUv2z4chrinD8jSMwnjVYoHzx2q2dc71lDlxfG7qg6wDUsC/0djMRxe15pOTS4/u0qq6LBtwH08vCJz+Gcs=
X-Received: by 2002:a1f:2510:0:b0:401:b89:5375 with SMTP id
 l16-20020a1f2510000000b004010b895375mr88028vkl.22.1676427808504; Tue, 14 Feb
 2023 18:23:28 -0800 (PST)
MIME-Version: 1.0
References: <CACsaVZJvXpCt37nQOoe8qd1EPUpfdMM1HwHk9tVO8HdU_Azhhw@mail.gmail.com>
 <25578.37401.314298.238192@quad.stoffel.home>
 <CACsaVZJ-5y7U5xqwL9bof69EKbTk+wrHWFcBFYyP_BwVSt+CNA@mail.gmail.com>
 <CAM23Vxr8LkkcVDFfW1=qEYGgo7JG1qx62eWSV4WOw4_MnD+TZA@mail.gmail.com>
 <CAAMCDeeHxMBoVkNYAyssjgjo4=FYd2NonS-mqC7OUEL89B9Cig@mail.gmail.com>
In-Reply-To: <CAAMCDeeHxMBoVkNYAyssjgjo4=FYd2NonS-mqC7OUEL89B9Cig@mail.gmail.com>
From: Heinz Mauelshagen <heinzm@redhat.com>
Date: Wed, 15 Feb 2023 03:23:17 +0100
Message-ID: <CAM23VxpzY6qYsdTYxe01FT7AJvEbODf8X_vq8ALL35TfyrB8xQ@mail.gmail.com>
To: Roger Heflin <rogerheflin@gmail.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/mixed; boundary="===============4398799366802042392=="

--===============4398799366802042392==
Content-Type: multipart/alternative; boundary="00000000000004948205f4b3c474"

--00000000000004948205f4b3c474
Content-Type: text/plain; charset="UTF-8"

Roger,

as any of the currently implemented 'parity' algorithms (block
xor/P-/Q-Syndrome) provided by DM/MD RAID
have to have at least two data blocks to calculate:  are you, apart from
the filesystem thoughts you bring up, thinking
about running those on e.g. pairs of disks of mentioned even numbered set
of 8?

Heinz

On Tue, Feb 14, 2023 at 11:28 PM Roger Heflin <rogerheflin@gmail.com> wrote:

> On Tue, Feb 14, 2023 at 3:27 PM Heinz Mauelshagen <heinzm@redhat.com>
> wrote:
> >
>
> >
> >
> > ...which is RAID1 plus a parity disk which seems superfluous as you
> achieve (N-1)
> > resilience against single device failures already without the later.
> >
> > What would you need such parity disk for?
> >
> > Heinz
> >
>
> I thought that at first too, but threw that idea out as it did not
> make much sense.
>
> What he appears to want is 8 linear non-striped data disks + a parity disk.
>
> Such that you can lose any one data disk and parity can rebuild that
> disk.  And if you lose several data diskis, then you have intact
> non-striped data for the remaining disks.
>
> It would almost seem that you would need to put a separate filesystem
> on each data disk/section (or have a filesystem that is redundant
> enough to survive) otherwise losing an entire data disk would leave
> the filesystem in a mess..
>
> So N filesystems + a parity disk for the data on the N separate
> filesystems.   And each write needs you to read the data from the disk
> you are writing to, and the parity and recalculate the new parity and
> write out the data and new parity.
>
> If the parity disk was an SSD it would be fast enough, but if parity
> was an SSD I would expect it to get used up/burned out from all of
> parity being re-written for each write on each disk unless you bought
> an expensive high-write ssd.
>
> The only advantage of the setup is that if you lose too many disks you
> still have some data.
>
> It is not clear to me that it would be any cheaper if parity needs to
> be a normal ssd's (since ssds are about 4x the price/gb and high-write
> ones are even more) than a classic bunch of mirrors, or even say a 4
> disks raid6 where you can lose any 2 and still have data.
>
>

--00000000000004948205f4b3c474
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Roger,<div><br></div><div>as any of the currently implemen=
ted &#39;parity&#39; algorithms (block xor/P-/Q-Syndrome) provided by DM/MD=
 RAID<br>have to have at least two data blocks to calculate:=C2=A0 are you,=
 apart from the filesystem thoughts=C2=A0you bring up, thinking<br>about ru=
nning those on e.g. pairs of disks of mentioned even numbered set of 8?</di=
v><div><br></div><div>Heinz</div></div><br><div class=3D"gmail_quote"><div =
dir=3D"ltr" class=3D"gmail_attr">On Tue, Feb 14, 2023 at 11:28 PM Roger Hef=
lin &lt;<a href=3D"mailto:rogerheflin@gmail.com">rogerheflin@gmail.com</a>&=
gt; wrote:<br></div><blockquote class=3D"gmail_quote" style=3D"margin:0px 0=
px 0px 0.8ex;border-left:1px solid rgb(204,204,204);padding-left:1ex">On Tu=
e, Feb 14, 2023 at 3:27 PM Heinz Mauelshagen &lt;<a href=3D"mailto:heinzm@r=
edhat.com" target=3D"_blank">heinzm@redhat.com</a>&gt; wrote:<br>
&gt;<br>
<br>
&gt;<br>
&gt;<br>
&gt; ...which is RAID1 plus a parity disk which seems superfluous as you ac=
hieve (N-1)<br>
&gt; resilience against single device failures already without the later.<b=
r>
&gt;<br>
&gt; What would you need such parity disk for?<br>
&gt;<br>
&gt; Heinz<br>
&gt;<br>
<br>
I thought that at first too, but threw that idea out as it did not<br>
make much sense.<br>
<br>
What he appears to want is 8 linear non-striped data disks + a parity disk.=
<br>
<br>
Such that you can lose any one data disk and parity can rebuild that<br>
disk.=C2=A0 And if you lose several data diskis, then you have intact<br>
non-striped data for the remaining disks.<br>
<br>
It would almost seem that you would need to put a separate filesystem<br>
on each data disk/section (or have a filesystem that is redundant<br>
enough to survive) otherwise losing an entire data disk would leave<br>
the filesystem in a mess..<br>
<br>
So N filesystems + a parity disk for the data on the N separate<br>
filesystems.=C2=A0 =C2=A0And each write needs you to read the data from the=
 disk<br>
you are writing to, and the parity and recalculate the new parity and<br>
write out the data and new parity.<br>
<br>
If the parity disk was an SSD it would be fast enough, but if parity<br>
was an SSD I would expect it to get used up/burned out from all of<br>
parity being re-written for each write on each disk unless you bought<br>
an expensive high-write ssd.<br>
<br>
The only advantage of the setup is that if you lose too many disks you<br>
still have some data.<br>
<br>
It is not clear to me that it would be any cheaper if parity needs to<br>
be a normal ssd&#39;s (since ssds are about 4x the price/gb and high-write<=
br>
ones are even more) than a classic bunch of mirrors, or even say a 4<br>
disks raid6 where you can lose any 2 and still have data.<br>
<br>
</blockquote></div>

--00000000000004948205f4b3c474--

--===============4398799366802042392==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

--===============4398799366802042392==--

