Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 21E88C433F5
	for <dm-devel@archiver.kernel.org>; Wed, 16 Feb 2022 06:29:16 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-367-XD59NxWwNhuazY-lWOtgoA-1; Wed, 16 Feb 2022 01:29:12 -0500
X-MC-Unique: XD59NxWwNhuazY-lWOtgoA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 24F3F1006AA0;
	Wed, 16 Feb 2022 06:29:08 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 06E7C5DBBA;
	Wed, 16 Feb 2022 06:29:08 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id D40D84A7CB;
	Wed, 16 Feb 2022 06:29:07 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
	[10.11.54.7])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 21FGQ3Dc009426 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 15 Feb 2022 11:26:03 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 01E06145FBAB; Tue, 15 Feb 2022 16:26:03 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id EE0F7145FBA0
	for <dm-devel@redhat.com>; Tue, 15 Feb 2022 16:26:02 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A2A2E18A6592
	for <dm-devel@redhat.com>; Tue, 15 Feb 2022 16:26:00 +0000 (UTC)
Received: from mail-oi1-f178.google.com (mail-oi1-f178.google.com
	[209.85.167.178]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-398-sdwAmNrNMiWBzSZk01UGFw-1; Tue, 15 Feb 2022 11:25:57 -0500
X-MC-Unique: sdwAmNrNMiWBzSZk01UGFw-1
Received: by mail-oi1-f178.google.com with SMTP id r19so2261704oic.5;
	Tue, 15 Feb 2022 08:25:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:mime-version:references:in-reply-to:from:date
	:message-id:subject:to:cc;
	bh=X3ppC21bSUZkihxAtVWukCcb04TCvsFGaK3j6AN71Kc=;
	b=A8OGslQKDPXXWN3EarbKb3lvuV6IWx5MYdgshSlZOMXhc/WrSzHt54KrKWQm4JsUPd
	3TV8/Wccupj+6v6sO39aB4ZJg79fVE9DYkp/zQhe8TRg9Dox516NPmMs9JBTjQeSQogw
	mx7HFchzC69kBujYaFoc6kPZhtCFMjmU/fw63iSN8Pc4PNIQ2AHDayQ2pYTQmC89tchd
	Oo1I9RMCgTkf0eoZQnz6HMSCqqGERcHJmkgYJTNq1ycSSKdAwtiUrh2gk+a5Zmc/urw+
	OWumI2TNHMdwF2LMTuWhqRRefLm14pz4Tn4bPy+xQ7+qAQOy823986YfEjjxF4/dlRwh
	O/TA==
X-Gm-Message-State: AOAM533Q00zF92vF4CNr82OP6PR3Xr07/ZQLKJiP2aOno9xHRi3Ij6TQ
	Dxls+a2DkeTLR4z2d6DTwQsWVK7QFak2k7GeuGc=
X-Google-Smtp-Source: ABdhPJxpgRYYuztDWeESEdVeSkFpL+y1JsqiDt+iYAnS0xMg8eHf1DKVLSNkq4fMz9jcCxVuXxP61MpTdjmTjORT3AM=
X-Received: by 2002:a05:6808:1705:b0:2d4:d7a:9c25 with SMTP id
	bc5-20020a056808170500b002d40d7a9c25mr1533695oib.51.1644942356957;
	Tue, 15 Feb 2022 08:25:56 -0800 (PST)
MIME-Version: 1.0
References: <CAOOPZo4uNCicVmoHa2za0=O1_XiBdtBvTuUzqBTeBc3FmDqEJw@mail.gmail.com>
In-Reply-To: <CAOOPZo4uNCicVmoHa2za0=O1_XiBdtBvTuUzqBTeBc3FmDqEJw@mail.gmail.com>
From: Donald Williams <don.e.williams@gmail.com>
Date: Tue, 15 Feb 2022 11:25:44 -0500
Message-ID: <CAK3e-EZbJMDHkozGiz8LnMNAZ+SoCA+QeK0kpkqM4vQ4pz86SQ@mail.gmail.com>
To: open-iscsi@googlegroups.com
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Mimecast-Bulk-Signature: yes
X-Mimecast-Spam-Signature: bulk
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Wed, 16 Feb 2022 01:28:09 -0500
Cc: dm-devel@redhat.com, leech@redhat.com, lduncan@suse.com,
	linux-scsi@vger.kernel.org, bob.liu@oracle.com
Subject: Re: [dm-devel] Question about iscsi session block
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/mixed; boundary="===============5519893479448908738=="

--===============5519893479448908738==
Content-Type: multipart/alternative; boundary="000000000000dccc3c05d810fc3c"

--000000000000dccc3c05d810fc3c
Content-Type: text/plain; charset="UTF-8"

Hello,
   Something else to check is your MPIO configuration.  I have seen this
same symptom when the linux MPIO feature "queue_if_no_path" was enabled

 From the /etc/multipath.conf file showing it enabled.

    failback                immediate
    features                "1 queue_if_no_path"

 Also, in the past some versions of linux multipathd would wait for a
very long time before moving all I/O to the remaining path.

 Regards,
Don


On Tue, Feb 15, 2022 at 10:49 AM Zhengyuan Liu <liuzhengyuang521@gmail.com>
wrote:

> Hi, all
>
> We have an online server which uses multipath + iscsi to attach storage
> from Storage Server. There are two NICs on the server and for each it
> carries about 20 iscsi sessions and for each session it includes about 50
>  iscsi devices (yes, there are totally about 2*20*50=2000 iscsi block
> devices
>  on the server). The problem is: once a NIC gets faulted, it will take too
> long
> (nearly 80s) for multipath to switch to another good NIC link, because it
> needs to block all iscsi devices over that faulted NIC firstly. The
> callstack is
>  shown below:
>
>     void iscsi_block_session(struct iscsi_cls_session *session)
>     {
>         queue_work(iscsi_eh_timer_workq, &session->block_work);
>     }
>
>  __iscsi_block_session() -> scsi_target_block() -> target_block() ->
>   device_block() ->  scsi_internal_device_block() -> scsi_stop_queue() ->
>  blk_mq_quiesce_queue()>synchronize_rcu()
>
> For all sessions and all devices, it was processed sequentially, and we
> have
> traced that for each synchronize_rcu() call it takes about 80ms, so
> the total cost
> is about 80s (80ms * 20 * 50). It's so long that the application can't
> tolerate and
> may interrupt service.
>
> So my question is that can we optimize the procedure to reduce the time
> cost on
> blocking all iscsi devices?  I'm not sure if it is a good idea to increase
> the
> workqueue's max_active of iscsi_eh_timer_workq to improve concurrency.
>
> Thanks in advance.
>
> --
> You received this message because you are subscribed to the Google Groups
> "open-iscsi" group.
> To unsubscribe from this group and stop receiving emails from it, send an
> email to open-iscsi+unsubscribe@googlegroups.com.
> To view this discussion on the web visit
> https://groups.google.com/d/msgid/open-iscsi/CAOOPZo4uNCicVmoHa2za0%3DO1_XiBdtBvTuUzqBTeBc3FmDqEJw%40mail.gmail.com
> .
>

--000000000000dccc3c05d810fc3c
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Hello,=C2=A0<div>=C2=A0 =C2=A0Something else to check is y=
our MPIO configuration.=C2=A0 I have seen this same symptom when the linux =
MPIO feature &quot;queue_if_no_path&quot; was enabled=C2=A0</div><div><br><=
/div><div>=C2=A0From the /etc/multipath.conf file showing it enabled.=C2=A0=
</div><div><br></div><div><span style=3D"color:rgb(17,17,17);font-family:Ro=
boto,sans-serif;font-size:16px">=C2=A0 =C2=A0 failback=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 immed=
iate</span><br style=3D"box-sizing:border-box;color:rgb(17,17,17);font-fami=
ly:Roboto,sans-serif;font-size:16px"><span style=3D"color:rgb(17,17,17);fon=
t-family:Roboto,sans-serif;font-size:16px">=C2=A0=C2=A0=C2=A0 features=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 &quot;1 queue_if_no_path&quot;</span><br></div><div><span styl=
e=3D"color:rgb(17,17,17);font-family:Roboto,sans-serif;font-size:16px"><br>=
</span></div><div><span style=3D"color:rgb(17,17,17);font-family:Roboto,san=
s-serif;font-size:16px">=C2=A0Also, in the past some versions of linux mult=
ipathd would wait for a very=C2=A0long time before moving=C2=A0all I/O to t=
he remaining path.=C2=A0</span></div><div><span style=3D"color:rgb(17,17,17=
);font-family:Roboto,sans-serif;font-size:16px"><br></span></div><div><span=
 style=3D"color:rgb(17,17,17);font-family:Roboto,sans-serif;font-size:16px"=
>=C2=A0Regards,</span></div><div><span style=3D"color:rgb(17,17,17);font-fa=
mily:Roboto,sans-serif;font-size:16px">Don</span></div><div><span style=3D"=
color:rgb(17,17,17);font-family:Roboto,sans-serif;font-size:16px">=C2=A0</s=
pan></div></div><br><div class=3D"gmail_quote"><div dir=3D"ltr" class=3D"gm=
ail_attr">On Tue, Feb 15, 2022 at 10:49 AM Zhengyuan Liu &lt;<a href=3D"mai=
lto:liuzhengyuang521@gmail.com">liuzhengyuang521@gmail.com</a>&gt; wrote:<b=
r></div><blockquote class=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex=
;border-left:1px solid rgb(204,204,204);padding-left:1ex">Hi, all<br>
<br>
We have an online server which uses multipath + iscsi to attach storage<br>
from Storage Server. There are two NICs on the server and for each it<br>
carries about 20 iscsi sessions and for each session it includes about 50<b=
r>
=C2=A0iscsi devices (yes, there are totally about 2*20*50=3D2000 iscsi bloc=
k devices<br>
=C2=A0on the server). The problem is: once a NIC gets faulted, it will take=
 too long<br>
(nearly 80s) for multipath to switch to another good NIC link, because it<b=
r>
needs to block all iscsi devices over that faulted NIC firstly. The callsta=
ck is<br>
=C2=A0shown below:<br>
<br>
=C2=A0 =C2=A0 void iscsi_block_session(struct iscsi_cls_session *session)<b=
r>
=C2=A0 =C2=A0 {<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 queue_work(iscsi_eh_timer_workq, &amp;session-&=
gt;block_work);<br>
=C2=A0 =C2=A0 }<br>
<br>
=C2=A0__iscsi_block_session() -&gt; scsi_target_block() -&gt; target_block(=
) -&gt;<br>
=C2=A0 device_block() -&gt;=C2=A0 scsi_internal_device_block() -&gt; scsi_s=
top_queue() -&gt;<br>
=C2=A0blk_mq_quiesce_queue()&gt;synchronize_rcu()<br>
<br>
For all sessions and all devices, it was processed sequentially, and we hav=
e<br>
traced that for each synchronize_rcu() call it takes about 80ms, so<br>
the total cost<br>
is about 80s (80ms * 20 * 50). It&#39;s so long that the application can&#3=
9;t<br>
tolerate and<br>
may interrupt service.<br>
<br>
So my question is that can we optimize the procedure to reduce the time cos=
t on<br>
blocking all iscsi devices?=C2=A0 I&#39;m not sure if it is a good idea to =
increase the<br>
workqueue&#39;s max_active of iscsi_eh_timer_workq to improve concurrency.<=
br>
<br>
Thanks in advance.<br>
<br>
-- <br>
You received this message because you are subscribed to the Google Groups &=
quot;open-iscsi&quot; group.<br>
To unsubscribe from this group and stop receiving emails from it, send an e=
mail to <a href=3D"mailto:open-iscsi%2Bunsubscribe@googlegroups.com" target=
=3D"_blank">open-iscsi+unsubscribe@googlegroups.com</a>.<br>
To view this discussion on the web visit <a href=3D"https://groups.google.c=
om/d/msgid/open-iscsi/CAOOPZo4uNCicVmoHa2za0%3DO1_XiBdtBvTuUzqBTeBc3FmDqEJw=
%40mail.gmail.com" rel=3D"noreferrer" target=3D"_blank">https://groups.goog=
le.com/d/msgid/open-iscsi/CAOOPZo4uNCicVmoHa2za0%3DO1_XiBdtBvTuUzqBTeBc3FmD=
qEJw%40mail.gmail.com</a>.<br>
</blockquote></div>

--000000000000dccc3c05d810fc3c--

--===============5519893479448908738==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel
--===============5519893479448908738==--

