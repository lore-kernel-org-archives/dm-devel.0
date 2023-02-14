Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 04C96C64EC7
	for <dm-devel@archiver.kernel.org>; Tue, 14 Feb 2023 21:27:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1676410070;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:in-reply-to:in-reply-to:
	 references:references:list-id:list-help:list-unsubscribe:
	 list-subscribe:list-post; bh=+IbuuWms812eHHoNqMzoO9CpXoYxUqivdwMwTs308gQ=;
	b=Fplg5o924Wb+pOff3vu8Kj+0JlBJO49yIavy9yMi2ShNaisyW+vTjqZhM7uWib56gQH3Jc
	b+ifwrWFoANKQ4av5nnssZakCdqh+JKCUqDVvGEQeatz5XHjvzvMjlXYaTHs1rGaVN+fxp
	5qQF1y6zchGM2/MEMt0sPsx0sYUFWHY=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-554-RzrWVALoN3GiLXzWBkUd1A-1; Tue, 14 Feb 2023 16:27:47 -0500
X-MC-Unique: RzrWVALoN3GiLXzWBkUd1A-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C78491C05AA7;
	Tue, 14 Feb 2023 21:27:45 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 9C7F2140EBF6;
	Tue, 14 Feb 2023 21:27:43 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 622391946588;
	Tue, 14 Feb 2023 21:27:43 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 1BAF01946588
 for <dm-devel@listman.corp.redhat.com>; Tue, 14 Feb 2023 21:27:25 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 9C96C2166B2A; Tue, 14 Feb 2023 21:27:25 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 94F592166B29
 for <dm-devel@redhat.com>; Tue, 14 Feb 2023 21:27:25 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7297C2807D62
 for <dm-devel@redhat.com>; Tue, 14 Feb 2023 21:27:25 +0000 (UTC)
Received: from mail-ua1-f71.google.com (mail-ua1-f71.google.com
 [209.85.222.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-216-a5no2Am_NLCxHM3oXXv8lA-1; Tue, 14 Feb 2023 16:27:23 -0500
X-MC-Unique: a5no2Am_NLCxHM3oXXv8lA-1
Received: by mail-ua1-f71.google.com with SMTP id
 f40-20020ab049eb000000b006780ae44d28so5865769uad.1
 for <dm-devel@redhat.com>; Tue, 14 Feb 2023 13:27:23 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
 :reply-to;
 bh=J9Gn+5TNQ8DKrY4mgBKc3l2G9k3EfPu/+R1E7tIgANE=;
 b=cSIyE+CesYZkXo7G4nFgxbozqvKnbiQztUMqI1J3UdIgJ9WDFGuA+cY5Y6U12jFLJv
 MCf4HzU4fADkMH3TkIDsTdcbIdY3iMvNgEBvVm8P+i/QzaAo6saisBuejXvk57VxJdEE
 6v4PziWxQ6n/18UU/sVewZ6tLWnv4y4RPPZNBBD9dGOo/Iq+eVIkwa2CCUcpy4FEQy+C
 EehcRe3T/g/P3Oe+GVprWklHJzNt31OXExr70rM4ExRnhtt0sTcnZ6HEZbE/VLNTUkFE
 KoO19ERDO0/bMYRrojkxOcGWhz0xtkDrGq86fk1uLlB2fpyQZxrbXS2keG0lYuCMvf6Z
 T3kg==
X-Gm-Message-State: AO0yUKVWAyVxgBEptLZ4rRlKAc30LggufcyTJM1wMc6qh4Li1hp0XOcj
 kbKQEGUDWmdSkRTLriRLC4VRbHhmzggjs+xwhQhdtmwtoBKJMo412qJHeIlQAi0L56SANphs0r/
 GH7y2k8puY/HEor6dparHQI3OJOgVjQsKRnT9
X-Received: by 2002:a1f:a258:0:b0:401:b89:5375 with SMTP id
 l85-20020a1fa258000000b004010b895375mr622677vke.22.1676410043175; 
 Tue, 14 Feb 2023 13:27:23 -0800 (PST)
X-Google-Smtp-Source: AK7set+KM0YM/TxoMPGD9gjy7ulLY1Kne2pCqHZr04fdjZVS7jLE03g3+z1o++piJ0m1ASIzD+JN6yW/1L8mSzw28K4=
X-Received: by 2002:a1f:a258:0:b0:401:b89:5375 with SMTP id
 l85-20020a1fa258000000b004010b895375mr622672vke.22.1676410042933; Tue, 14 Feb
 2023 13:27:22 -0800 (PST)
MIME-Version: 1.0
References: <CACsaVZJvXpCt37nQOoe8qd1EPUpfdMM1HwHk9tVO8HdU_Azhhw@mail.gmail.com>
 <25578.37401.314298.238192@quad.stoffel.home>
 <CACsaVZJ-5y7U5xqwL9bof69EKbTk+wrHWFcBFYyP_BwVSt+CNA@mail.gmail.com>
In-Reply-To: <CACsaVZJ-5y7U5xqwL9bof69EKbTk+wrHWFcBFYyP_BwVSt+CNA@mail.gmail.com>
From: Heinz Mauelshagen <heinzm@redhat.com>
Date: Tue, 14 Feb 2023 22:27:12 +0100
Message-ID: <CAM23Vxr8LkkcVDFfW1=qEYGgo7JG1qx62eWSV4WOw4_MnD+TZA@mail.gmail.com>
To: Kyle Sanderson <kyle.leet@gmail.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
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
Cc: linux-raid@vger.kernel.org, Song Liu <song@kernel.org>,
 device-mapper development <dm-devel@redhat.com>,
 John Stoffel <john@stoffel.org>, Linux-Kernel <linux-kernel@vger.kernel.org>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/mixed; boundary="===============4399553342753133974=="

--===============4399553342753133974==
Content-Type: multipart/alternative; boundary="0000000000001b7a6805f4afa1ec"

--0000000000001b7a6805f4afa1ec
Content-Type: text/plain; charset="UTF-8"

On Tue, Feb 14, 2023 at 8:48 AM Kyle Sanderson <kyle.leet@gmail.com> wrote:

> > On Mon, Feb 13, 2023 at 11:40 AM John Stoffel <john@stoffel.org> wrote:
> >
> > >>>>> "Kyle" == Kyle Sanderson <kyle.leet@gmail.com> writes:
> >
> > > hi DM and Linux-RAID,
> > > There have been multiple proprietary solutions (some nearly 20 years
> > > old now) with a number of (userspace) bugs that are becoming untenable
> > > for me as an end user. Basically how they work is a closed MD module
> > > (typically administered through DM) that uses RAID4 for a dedicated
> > > parity disk across multiple other disks.
> >
> > You need to explain what you want in *much* beter detail.  Give simple
> > concrete examples.  From the sound of it, you want RAID6 but with
> > RAID4 dedicated Parity so you can spin down some of the data disks in
> > the array?  But if need be, spin up idle disks to recover data if you
> > lose an active disk?
>
> No, just a single dedicated parity disk - there's no striping on any
> of the data disks. The result of this is you can lose 8 data disks and
> the parity disk from an array of 10, and still access the last
> remaining disk because each disk maintains a complete copy of their
> own data.


...which is RAID1 plus a parity disk which seems superfluous as you achieve
(N-1)
resilience against single device failures already without the later.

What would you need such parity disk for?

Heinz

How the implementations do this is still expose each
> individual disk (/dev/md*) that are formatted (+ encrypted)
> independently, and when written to, update the parity information on
> the dedicated disk. That way, when you add a new disk that's fully
> zero'd to the array (parity disk is 16T, new disk is 4T), parity is
> preserved. Any bytes written beyond the 4T barrier do not include
> those disks in the parity calculation.
>
> > Really hard to understand what exactly you're looking for here.
>
> This might help https://www.snapraid.it/compare . There's at least
> hundreds of thousands of these systems out there (based on public
> sales from a single vendor), if not well into the millions.
>
> Kyle.
>
> On Mon, Feb 13, 2023 at 11:40 AM John Stoffel <john@stoffel.org> wrote:
> >
> > >>>>> "Kyle" == Kyle Sanderson <kyle.leet@gmail.com> writes:
> >
> > > hi DM and Linux-RAID,
> > > There have been multiple proprietary solutions (some nearly 20 years
> > > old now) with a number of (userspace) bugs that are becoming untenable
> > > for me as an end user. Basically how they work is a closed MD module
> > > (typically administered through DM) that uses RAID4 for a dedicated
> > > parity disk across multiple other disks.
> >
> > You need to explain what you want in *much* beter detail.  Give simple
> > concrete examples.  From the sound of it, you want RAID6 but with
> > RAID4 dedicated Parity so you can spin down some of the data disks in
> > the array?  But if need be, spin up idle disks to recover data if you
> > lose an active disk?
> >
> > Really hard to understand what exactly you're looking for here.
> >
> >
> > > As there is no striping, the maximum size of the protected data is the
> > > size of the parity disk (so a set of 4+8+12+16 disks can be protected
> > > by a single dedicated 16 disk).When a block is written on any disk,
> > > the parity bit is read from the parity disk again, and updated
> > > depending on the existing + new bit value (so writing disk + parity
> > > disk spun up). Additionally, if enough disks are already spun up, the
> > > parity information can be recalculated from all of the spinning disks,
> > > resulting in a single write to the parity disk (without a read on the
> > > parity, doubling throughput). Finally any of the data disks can be
> > > moved around within the array without impacting parity as the layout
> > > has not changed. I don't necessarily need all of these features, just
> > > the ability to remove a disk and still access the data that was on
> > > there by spinning up every other disk until the rebuild is complete is
> > > important.
> >
> > > The benefit of this can be the data disks are all zoned, and you can
> > > have a fast parity disk and still maintain excellent performance in
> > > the array (limited only by the speed of the disk in question +
> > > parity). Additionally, should 2 disks fail, you've either lost the
> > > parity and data disk, or 2 data disks with the parity and other disks
> > > not lost.
> >
> > > I was reading through the DM and MD code and it looks like everything
> > > may already be there to do this, just needs (significant) stubs to be
> > > added to support this mode (or new code). Snapraid is a friendly (and
> > > respectable) implementation of this. Unraid and Synology SHR compete
> > > in this space, as well as other NAS and enterprise SAN providers.
> >
> > > Kyle.
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://listman.redhat.com/mailman/listinfo/dm-devel
>
>

--0000000000001b7a6805f4afa1ec
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div dir=3D"ltr">On Tue, Feb 14, 2023 at 8:48 AM Kyle Sand=
erson &lt;<a href=3D"mailto:kyle.leet@gmail.com">kyle.leet@gmail.com</a>&gt=
; wrote:<br></div><div class=3D"gmail_quote"><blockquote class=3D"gmail_quo=
te" style=3D"margin:0px 0px 0px 0.8ex;border-left:1px solid rgb(204,204,204=
);padding-left:1ex">&gt; On Mon, Feb 13, 2023 at 11:40 AM John Stoffel &lt;=
<a href=3D"mailto:john@stoffel.org" target=3D"_blank">john@stoffel.org</a>&=
gt; wrote:<br>
&gt;<br>
&gt; &gt;&gt;&gt;&gt;&gt; &quot;Kyle&quot; =3D=3D Kyle Sanderson &lt;<a hre=
f=3D"mailto:kyle.leet@gmail.com" target=3D"_blank">kyle.leet@gmail.com</a>&=
gt; writes:<br>
&gt;<br>
&gt; &gt; hi DM and Linux-RAID,<br>
&gt; &gt; There have been multiple proprietary solutions (some nearly 20 ye=
ars<br>
&gt; &gt; old now) with a number of (userspace) bugs that are becoming unte=
nable<br>
&gt; &gt; for me as an end user. Basically how they work is a closed MD mod=
ule<br>
&gt; &gt; (typically administered through DM) that uses RAID4 for a dedicat=
ed<br>
&gt; &gt; parity disk across multiple other disks.<br>
&gt;<br>
&gt; You need to explain what you want in *much* beter detail.=C2=A0 Give s=
imple<br>
&gt; concrete examples.=C2=A0 From the sound of it, you want RAID6 but with=
<br>
&gt; RAID4 dedicated Parity so you can spin down some of the data disks in<=
br>
&gt; the array?=C2=A0 But if need be, spin up idle disks to recover data if=
 you<br>
&gt; lose an active disk?<br>
<br>
No, just a single dedicated parity disk - there&#39;s no striping on any<br=
>
of the data disks. The result of this is you can lose 8 data disks and<br>
the parity disk from an array of 10, and still access the last<br>
remaining disk because each disk maintains a complete copy of their<br>
own data.</blockquote><div><br></div><div>...which is RAID1 plus a parity d=
isk which seems superfluous as you achieve (N-1)<br>resilience against sing=
le device failures already=C2=A0without=C2=A0the later.</div><div><br>What =
would you need such parity disk for?</div><div><br></div><div>Heinz</div><d=
iv><br></div><blockquote class=3D"gmail_quote" style=3D"margin:0px 0px 0px =
0.8ex;border-left:1px solid rgb(204,204,204);padding-left:1ex">How the impl=
ementations do this is still expose each<br>
individual disk (/dev/md*) that are formatted (+ encrypted)<br>
independently, and when written to, update the parity information on<br>
the dedicated disk. That way, when you add a new disk that&#39;s fully<br>
zero&#39;d to the array (parity disk is 16T, new disk is 4T), parity is<br>
preserved. Any bytes written beyond the 4T barrier do not include<br>
those disks in the parity calculation.<br>
<br>
&gt; Really hard to understand what exactly you&#39;re looking for here.<br=
>
<br>
This might help <a href=3D"https://www.snapraid.it/compare" rel=3D"noreferr=
er" target=3D"_blank">https://www.snapraid.it/compare</a> . There&#39;s at =
least<br>
hundreds of thousands of these systems out there (based on public<br>
sales from a single vendor), if not well into the millions.<br>
<br>
Kyle.<br>
<br>
On Mon, Feb 13, 2023 at 11:40 AM John Stoffel &lt;<a href=3D"mailto:john@st=
offel.org" target=3D"_blank">john@stoffel.org</a>&gt; wrote:<br>
&gt;<br>
&gt; &gt;&gt;&gt;&gt;&gt; &quot;Kyle&quot; =3D=3D Kyle Sanderson &lt;<a hre=
f=3D"mailto:kyle.leet@gmail.com" target=3D"_blank">kyle.leet@gmail.com</a>&=
gt; writes:<br>
&gt;<br>
&gt; &gt; hi DM and Linux-RAID,<br>
&gt; &gt; There have been multiple proprietary solutions (some nearly 20 ye=
ars<br>
&gt; &gt; old now) with a number of (userspace) bugs that are becoming unte=
nable<br>
&gt; &gt; for me as an end user. Basically how they work is a closed MD mod=
ule<br>
&gt; &gt; (typically administered through DM) that uses RAID4 for a dedicat=
ed<br>
&gt; &gt; parity disk across multiple other disks.<br>
&gt;<br>
&gt; You need to explain what you want in *much* beter detail.=C2=A0 Give s=
imple<br>
&gt; concrete examples.=C2=A0 From the sound of it, you want RAID6 but with=
<br>
&gt; RAID4 dedicated Parity so you can spin down some of the data disks in<=
br>
&gt; the array?=C2=A0 But if need be, spin up idle disks to recover data if=
 you<br>
&gt; lose an active disk?<br>
&gt;<br>
&gt; Really hard to understand what exactly you&#39;re looking for here.<br=
>
&gt;<br>
&gt;<br>
&gt; &gt; As there is no striping, the maximum size of the protected data i=
s the<br>
&gt; &gt; size of the parity disk (so a set of 4+8+12+16 disks can be prote=
cted<br>
&gt; &gt; by a single dedicated 16 disk).When a block is written on any dis=
k,<br>
&gt; &gt; the parity bit is read from the parity disk again, and updated<br=
>
&gt; &gt; depending on the existing + new bit value (so writing disk + pari=
ty<br>
&gt; &gt; disk spun up). Additionally, if enough disks are already spun up,=
 the<br>
&gt; &gt; parity information can be recalculated from all of the spinning d=
isks,<br>
&gt; &gt; resulting in a single write to the parity disk (without a read on=
 the<br>
&gt; &gt; parity, doubling throughput). Finally any of the data disks can b=
e<br>
&gt; &gt; moved around within the array without impacting parity as the lay=
out<br>
&gt; &gt; has not changed. I don&#39;t necessarily need all of these featur=
es, just<br>
&gt; &gt; the ability to remove a disk and still access the data that was o=
n<br>
&gt; &gt; there by spinning up every other disk until the rebuild is comple=
te is<br>
&gt; &gt; important.<br>
&gt;<br>
&gt; &gt; The benefit of this can be the data disks are all zoned, and you =
can<br>
&gt; &gt; have a fast parity disk and still maintain excellent performance =
in<br>
&gt; &gt; the array (limited only by the speed of the disk in question +<br=
>
&gt; &gt; parity). Additionally, should 2 disks fail, you&#39;ve either los=
t the<br>
&gt; &gt; parity and data disk, or 2 data disks with the parity and other d=
isks<br>
&gt; &gt; not lost.<br>
&gt;<br>
&gt; &gt; I was reading through the DM and MD code and it looks like everyt=
hing<br>
&gt; &gt; may already be there to do this, just needs (significant) stubs t=
o be<br>
&gt; &gt; added to support this mode (or new code). Snapraid is a friendly =
(and<br>
&gt; &gt; respectable) implementation of this. Unraid and Synology SHR comp=
ete<br>
&gt; &gt; in this space, as well as other NAS and enterprise SAN providers.=
<br>
&gt;<br>
&gt; &gt; Kyle.<br>
<br>
--<br>
dm-devel mailing list<br>
<a href=3D"mailto:dm-devel@redhat.com" target=3D"_blank">dm-devel@redhat.co=
m</a><br>
<a href=3D"https://listman.redhat.com/mailman/listinfo/dm-devel" rel=3D"nor=
eferrer" target=3D"_blank">https://listman.redhat.com/mailman/listinfo/dm-d=
evel</a><br>
<br>
</blockquote></div></div>

--0000000000001b7a6805f4afa1ec--

--===============4399553342753133974==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

--===============4399553342753133974==--

