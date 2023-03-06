Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3D4A9C61DA4
	for <dm-devel@archiver.kernel.org>; Mon,  6 Mar 2023 09:24:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1678094660;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:in-reply-to:in-reply-to:
	 references:references:list-id:list-help:list-unsubscribe:
	 list-subscribe:list-post; bh=X6Sc33v01OWP8EAEjvlp3hNsAZUpjX/u1hu6B293nQk=;
	b=EKc7+Ur/g9TNAwcQ/8yP0DrWb/8ROa1cpNCVstuMh7DGdwbc1NMG0BVpuzdSW0GjLXy0oa
	+l5RBZv+va3hWZ0IL9MZ+AQzslgxuYUCj9LU5Q+Hv+zQmpz91+8edYfCDG7i8hdwQD0ln0
	wx94MFwvho6U88G/q3qqX/By3e7h9a0=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-179--p8eNUVwOweKid-NytDtXg-1; Mon, 06 Mar 2023 04:24:16 -0500
X-MC-Unique: -p8eNUVwOweKid-NytDtXg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D471C3C20EE2;
	Mon,  6 Mar 2023 09:24:14 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 4A0E22166B26;
	Mon,  6 Mar 2023 09:24:13 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id E0448194658C;
	Mon,  6 Mar 2023 09:24:12 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 6CB281946586
 for <dm-devel@listman.corp.redhat.com>; Mon,  6 Mar 2023 09:24:12 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 5E86D2026D4B; Mon,  6 Mar 2023 09:24:12 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 572142026D76
 for <dm-devel@redhat.com>; Mon,  6 Mar 2023 09:24:12 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 388C82A59571
 for <dm-devel@redhat.com>; Mon,  6 Mar 2023 09:24:12 +0000 (UTC)
Received: from mail-yw1-f197.google.com (mail-yw1-f197.google.com
 [209.85.128.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-249-MBwZR2QpPdaZ6ngeY9c_Sw-1; Mon, 06 Mar 2023 04:24:09 -0500
X-MC-Unique: MBwZR2QpPdaZ6ngeY9c_Sw-1
Received: by mail-yw1-f197.google.com with SMTP id
 00721157ae682-536af109f9aso97559337b3.13
 for <dm-devel@redhat.com>; Mon, 06 Mar 2023 01:24:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112; t=1678094649;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
 :reply-to;
 bh=p+gTzx3XSldioQeWTuPxhG0FkPuBiTadn4Ln1JCuilg=;
 b=lGUOoqWu52VPZY29PelWWjhrr/QcH80qMB5Rp2TilW0xc4cbSkKl2umVZXxrKmm3RU
 9Br+uYYmsHB8+N0yl4itVzN1fqN+hGiYZx/vcCSCIL+SuRWgvNOJTJmm2vxl+gKHpqvN
 JEuUlTsWf9Ckh3oxU8WY0dWg8qs/bgNpWWrUczeU34u2cXMxgLc4gxOrr0jA4ZEH6lhr
 FEcziNI3WSYSEC9o3dkhCVMQ7kuBx0dmFenabpkcFqUrq+ZiWn6VihuAWQ2WqFpXP5aJ
 ge5+55nl4w45h6xsKZRjbFk8jGEL82v0axzl5pdtNc0uWyrrCuNr70NxvCuXmF6sjUFi
 kdQg==
X-Gm-Message-State: AO0yUKXnVNt4xTiUH3wCFI/5lPSkEpoiGvj5sGWWrElqUF1vS0J1CXvA
 VH0go7fag1BEDgC3F5u/sTWnJFZgUOuXtDojsjX0rxiwYYy8OtvFPGe1QOTdeOYUqUezmHH915G
 3ZWb+vR7HmgrE53rtawn/BerRmZf9hbg+NFRyT+8=
X-Received: by 2002:a25:9112:0:b0:a4a:4324:2b1f with SMTP id
 v18-20020a259112000000b00a4a43242b1fmr6110902ybl.8.1678094649043; 
 Mon, 06 Mar 2023 01:24:09 -0800 (PST)
X-Google-Smtp-Source: AK7set+94VCnzOrdhhhWOyAxfVHXi9wTnggFL3WpP5kRtaWOf9Ui1vXcKqoBPP4TFF17exUhbL3MbK6dzff8T20ZXCc=
X-Received: by 2002:a25:9112:0:b0:a4a:4324:2b1f with SMTP id
 v18-20020a259112000000b00a4a43242b1fmr6110889ybl.8.1678094648756; Mon, 06 Mar
 2023 01:24:08 -0800 (PST)
MIME-Version: 1.0
References: <CAJ0trDZW8FRFuuonKrgSMp7i7m0sLdPGyFHd2ap0Gw8iadrA-A@mail.gmail.com>
 <74a2b8c1-71cf-10b5-a837-c1af60773e98@ewheeler.net>
 <CAJ0trDYAyHHh2crMAQuQPMt3FzFmii0nmLnsL5N-cdhfvWZnMg@mail.gmail.com>
 <b4874d2f-12ec-bd7a-889d-e4f59dcfc6bc@ewheeler.net>
In-Reply-To: <b4874d2f-12ec-bd7a-889d-e4f59dcfc6bc@ewheeler.net>
From: Joe Thornber <thornber@redhat.com>
Date: Mon, 6 Mar 2023 09:23:57 +0000
Message-ID: <CAJ0trDaWtZ0XeV8kE8g6K-Ay3yM01ZZZ6cBx6hZvj12U_qty_g@mail.gmail.com>
To: Eric Wheeler <dm-devel@lists.ewheeler.net>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
Subject: Re: [dm-devel] [announce] thin-provisioning-tools v1.0.0-rc1
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
Cc: "development, device-mapper" <dm-devel@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/mixed; boundary="===============2393654682600340001=="

--===============2393654682600340001==
Content-Type: multipart/alternative; boundary="00000000000070630b05f637dbad"

--00000000000070630b05f637dbad
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Eric,

On Fri, Mar 3, 2023 at 9:21=E2=80=AFPM Eric Wheeler <dm-devel@lists.ewheele=
r.net>
wrote:

>
> It would be nice to get people testing the new improvements:
>
> Do you think it can make it for the 6.3 merge window that is open?
>

Doubtful.  The bulk of the changes are in dm-bufio, which is used by a lot
of targets.  So
I want to do a lot more testing before pushing upstream.



> Did thinp v2 get dropped, or just turn into the patchset above?
>
>
I've shelved thinp v2 in favour of userland approach I outlined.

 > I think io_uring, and ublk have shown us that this is viable.  That way

> > a snapshot copy-on-write, or dm-cache data migration, which are very
> > slow operations can be done with ordinary userland code.
>
> Would be nice to minimize CoW latency somehow if going to userspace
> increases that a notable amount.  CoW for spinning disks is definitely
> slow, but NVMe's are pretty quick to copy a 64k chunk.
>

Yes, minimising latency would be good.  I don't mind performing the CoW
within kernel, but I don't want to
handle the metadata updates in kernel.


> > For the fast paths, layering will be removed by having userland give
> > the kernel instruction to execute for specific regions of the virtual
> > device (ie. remap to here).
>
> Maybe you just answered my question of latency?
>

Yep.


>
> > The kernel driver will have nothing specific to thin/cache etc. I'm not
> > sure how many of the current dm-targets would fit into this model, but
> > I'm sure thin provisioning, caching, linear, and stripe can.
>
> To be clear, linear and stripe would stay in the kernel?


Linear and stripe would not need a call out to userland to service.  And
very little of thin/cache io would either.

 - Joe

--00000000000070630b05f637dbad
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div>Hi Eric,</div><br><div class=3D"gmail_quote"><div dir=
=3D"ltr" class=3D"gmail_attr">On Fri, Mar 3, 2023 at 9:21=E2=80=AFPM Eric W=
heeler &lt;<a href=3D"mailto:dm-devel@lists.ewheeler.net">dm-devel@lists.ew=
heeler.net</a>&gt; wrote:</div><blockquote class=3D"gmail_quote" style=3D"m=
argin:0px 0px 0px 0.8ex;border-left:1px solid rgb(204,204,204);padding-left=
:1ex">
<br>
It would be nice to get people testing the new improvements:<br>
<br>
Do you think it can make it for the 6.3 merge window that is open?<br></blo=
ckquote><div><br></div><div>Doubtful.=C2=A0 The bulk of the changes are in =
dm-bufio, which is used by a lot of targets.=C2=A0 So</div><div>I want to d=
o a lot more testing before pushing upstream.</div><div><br></div><div>=C2=
=A0</div><blockquote class=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8e=
x;border-left:1px solid rgb(204,204,204);padding-left:1ex">
Did thinp v2 get dropped, or just turn into the patchset above?<br>
<br></blockquote><div><br></div><div>I&#39;ve shelved thinp v2 in favour of=
 userland approach I outlined.</div><div><br></div><div>=C2=A0&gt; I think =
io_uring, and ublk have shown us that this is viable.=C2=A0 That way</div><=
blockquote class=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex;border-l=
eft:1px solid rgb(204,204,204);padding-left:1ex">
&gt; a snapshot copy-on-write, or dm-cache data migration, which are very <=
br>
&gt; slow operations can be done with ordinary userland code.<br>
<br>
Would be nice to minimize CoW latency somehow if going to userspace <br>
increases that a notable amount.=C2=A0 CoW for spinning disks is definitely=
 <br>
slow, but NVMe&#39;s are pretty quick to copy a 64k chunk.<br></blockquote>=
<div><br></div><div>Yes, minimising latency would be good.=C2=A0 I don&#39;=
t mind performing the CoW within kernel, but I don&#39;t want to</div><div>=
handle the metadata updates in kernel.</div><div>=C2=A0</div><blockquote cl=
ass=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex;border-left:1px solid=
 rgb(204,204,204);padding-left:1ex">
&gt;=C2=A0For the fast paths, layering will be removed by having userland g=
ive<br>
&gt; the kernel instruction to execute for specific regions of the virtual =
<br>
&gt; device (ie. remap to here).<br>
<br>
Maybe you just answered my question of latency?<br></blockquote><div><br></=
div><div>Yep.</div><div>=C2=A0</div><blockquote class=3D"gmail_quote" style=
=3D"margin:0px 0px 0px 0.8ex;border-left:1px solid rgb(204,204,204);padding=
-left:1ex">
<br>
&gt; The kernel driver will have nothing specific to thin/cache etc. I&#39;=
m not <br>
&gt; sure how many of the current dm-targets would fit into this model, but=
 <br>
&gt; I&#39;m sure thin provisioning, caching, linear, and stripe can.<br>
<br>
To be clear, linear and stripe would stay in the kernel?</blockquote><div><=
br></div><div>Linear and stripe would not need a call out to userland to se=
rvice.=C2=A0 And very little of thin/cache io would either.</div><div><br><=
/div><div>=C2=A0- Joe<br></div></div></div>

--00000000000070630b05f637dbad--

--===============2393654682600340001==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

--===============2393654682600340001==--

