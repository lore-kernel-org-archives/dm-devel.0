Return-Path: <SRS0=blFE=HK=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: **
X-Spam-Status: No, score=2.4 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	HTML_MESSAGE,MAILING_LIST_MULTI,MIME_HTML_MOSTLY,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF700C433E0
	for <dm-devel@archiver.kernel.org>; Mon,  8 Feb 2021 14:09:59 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 1804B64E5A
	for <dm-devel@archiver.kernel.org>; Mon,  8 Feb 2021 14:09:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1804B64E5A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-198-SFyz47umNQ2kxrM_L58b9w-1; Mon, 08 Feb 2021 09:09:53 -0500
X-MC-Unique: SFyz47umNQ2kxrM_L58b9w-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 968F9DF8DA;
	Mon,  8 Feb 2021 14:09:29 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id BA4B810ADD5B;
	Mon,  8 Feb 2021 14:09:27 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id A4EB018095CB;
	Mon,  8 Feb 2021 14:09:23 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 118E9LLW001204 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 8 Feb 2021 09:09:21 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 90D832026D14; Mon,  8 Feb 2021 14:09:21 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 8A8372026D46
	for <dm-devel@redhat.com>; Mon,  8 Feb 2021 14:09:18 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B3077857AB2
	for <dm-devel@redhat.com>; Mon,  8 Feb 2021 14:09:18 +0000 (UTC)
Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com
	[209.85.218.51]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-545-PikBEMhjOH-BOkqzgoBsmg-1; Mon, 08 Feb 2021 09:09:15 -0500
X-MC-Unique: PikBEMhjOH-BOkqzgoBsmg-1
Received: by mail-ej1-f51.google.com with SMTP id bl23so24882912ejb.5
	for <dm-devel@redhat.com>; Mon, 08 Feb 2021 06:09:15 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
	bh=/1BITYAnoh74jikYfVuftSXxBvsXhkQXG/xeSCnFTT4=;
	b=sCKqE283BM1KeAD/EMMJCT6ehueC6HgJH3K8uUCKXb0nBfSjJA2HQawqIwp8YzoAZ9
	GFrosksc5lGQYR+2SUFYkmpzio3sOLUGubr4H0oVE3vg5JmDndzYSMej2tg1l8jV4T/J
	vFMOyzR6DTZX+K8i0GJXhLkz6EsmVgqsiIl+Z1R10KO5MfNNMk5Q6qcezsMLgAUfCNXb
	IqH31UlGRCm9T/gkR/+gNKuetjIfWrj8r3opkDaw5nR6lTDRGQhtLtNK+1kNjBLTrBKH
	0s36C5kjnzPbpX3xIrKXEHqr5VUoAmQekteJZ6LdcYE+0LdEtY/vH9wsmaMb46ZxodkW
	Yy6A==
X-Gm-Message-State: AOAM533jAN0wqDCMvMYtjzDpuQTbFCcjZFHvV01wOeeDIhlsDFaH2VWG
	32sWNLZ6kHtOQ68aQ2YosnHrNO0l2bbYAm01VFvna/uFdXA=
X-Google-Smtp-Source: ABdhPJwD8GF96WWkyYvaI3E3CmR6tqy/lCFLfizyuGW4eZvdLDqpW7YKPg8HppKiPYkT6KWH4Nos7wS631MbQ0J6Y/k=
X-Received: by 2002:a17:906:3105:: with SMTP id
	5mr17465677ejx.168.1612793353875; 
	Mon, 08 Feb 2021 06:09:13 -0800 (PST)
MIME-Version: 1.0
From: Srinivasa Raghavan <ssraghavan76@gmail.com>
Date: Mon, 8 Feb 2021 19:38:58 +0530
Message-ID: <CAENXB_R_m=dGXr4Cy0uorbfyoC3qh6wsSrNedyw29nXqkYCjSA@mail.gmail.com>
To: dm-devel@redhat.com
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-loop: dm-devel@redhat.com
Subject: [dm-devel] RAID call traces during cold boot test
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/mixed; boundary="===============3418037504681142001=="

--===============3418037504681142001==
Content-Type: multipart/alternative; boundary="000000000000f4344005bad3b6c6"

--000000000000f4344005bad3b6c6
Content-Type: text/plain; charset="UTF-8"

Hi,

We encountered the following warnings during cold reboot tests on rhel
since 8.3 (i.e., 4.18.0-259). Is it a known bug on 8.3 onwards? Could not
figure out the actual cause of this. Any insight would be highly
appreciated. Thanks in Advance

Following are the call trace:
==================
Aug 20 08:01:50 lin403 kernel: RIP:
0010:__percpu_ref_switch_mode+0x17d/0x190
Aug 20 08:01:50 lin403 kernel: Code: 89 43 08 e9 7c ff ff ff 4d 85 e4 0f 84
73 ff ff ff 48 89 df e8 54 15 7b 00 e9 66 ff ff ff f0 48 83 03 01 e9 4c ff
ff ff 0f 0b <0f> 0b e9 53 ff ff ff e8 87 4a c6 ff 0f 1f 80 00 00 00 00 41
54 49
Aug 20 08:01:50 lin403 kernel: RSP: 0018:ffff9c928797fcf0 EFLAGS: 00010046
Aug 20 08:01:50 lin403 kernel: RAX: 0000330aef61c5d9 RBX: ffff89876c635338
RCX: dead000000000200
Aug 20 08:01:50 lin403 kernel: RDX: 0000000000000000 RSI: 0000000000000000
RDI: ffff89876c635338
Aug 20 08:01:50 lin403 kernel: RBP: 0000330aef61c5d8 R08: ffffffffa4b23eb8
R09: 0000000000000000
Aug 20 08:01:50 lin403 kernel: R10: 0000000000000000 R11: 00000006a086e9c0
R12: 0000000000000000
Aug 20 08:01:50 lin403 kernel: R13: 0000000000000001 R14: ffff89876c6b6c00
R15: ffffffffa3eb3dc0
Aug 20 08:01:50 lin403 kernel: FS: 0000000000000000(0000)
GS:ffff898790300000(0000) knlGS:0000000000000000
Aug 20 08:01:50 lin403 kernel: CS: 0010 DS: 0000 ES: 0000 CR0:
0000000080050033
Aug 20 08:01:50 lin403 kernel: CR2: 0000559d2e4b8380 CR3: 00000007e4c0a004
CR4: 00000000007606a0
Aug 20 08:01:50 lin403 kernel: DR0: 0000000000000000 DR1: 0000000000000000
DR2: 0000000000000000
Aug 20 08:01:50 lin403 kernel: DR3: 0000000000000000 DR6: 00000000fffe0ff0
DR7: 0000000000000400
Aug 20 08:01:50 lin403 kernel: PKRU: 55555554
Aug 20 08:01:50 lin403 kernel: Call Trace:
Aug 20 08:01:50 lin403 kernel: ? percpu_ref_switch_to_atomic_sync+0x6a/0x90
Aug 20 08:01:50 lin403 kernel: percpu_ref_switch_to_percpu+0x22/0x40
Aug 20 08:01:50 lin403 kernel: set_in_sync+0xc4/0xd0
Aug 20 08:01:50 lin403 kernel: md_check_recovery+0x49d/0x530
Aug 20 08:01:50 lin403 kernel: raid1d+0x5c/0x12a0 [raid1]
Aug 20 08:01:50 lin403 kernel: ? lock_timer_base+0x67/0x80
Aug 20 08:01:50 lin403 kernel: ? try_to_del_timer_sync+0x4d/0x80
Aug 20 08:01:50 lin403 kernel: ? del_timer_sync+0x25/0x40
Aug 20 08:01:50 lin403 kernel: ? schedule_timeout+0x161/0x310
Aug 20 08:01:50 lin403 kernel: ? __next_timer_interrupt+0xc0/0xc0
Aug 20 08:01:50 lin403 kernel: ? md_register_thread+0xd0/0xd0
Aug 20 08:01:50 lin403 kernel: ? md_thread+0x94/0x150
Aug 20 08:01:50 lin403 kernel: ? process_checks+0x4a0/0x4a0 [raid1]
Aug 20 08:01:50 lin403 kernel: md_thread+0x94/0x150
Aug 20 08:01:50 lin403 kernel: ? finish_wait+0x80/0x80
Aug 20 08:01:50 lin403 kernel: kthread+0x112/0x130
Aug 20 08:01:50 lin403 kernel: ? kthread_flush_work_fn+0x10/0x10
Aug 20 08:01:50 lin403 kernel: ret_from_fork+0x35/0x40
Aug 20 08:01:50 lin403 kernel: ---[ end trace c6ca999cff8213e0 ]---

Regards,
Srinivasa Raghavan

--000000000000f4344005bad3b6c6
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div><span style=3D"background-color:rgb(235,236,240);colo=
r:rgb(23,43,77);font-family:-apple-system,BlinkMacSystemFont,&quot;Segoe UI=
&quot;,Roboto,Oxygen,Ubuntu,&quot;Fira Sans&quot;,&quot;Droid Sans&quot;,&q=
uot;Helvetica Neue&quot;,sans-serif;font-size:1em;font-variant-numeric:norm=
al;font-variant-east-asian:normal;letter-spacing:0em;line-height:1.714;whit=
e-space:pre-wrap">Hi,</span></div><div><span style=3D"background-color:rgb(=
235,236,240);color:rgb(23,43,77);font-family:-apple-system,BlinkMacSystemFo=
nt,&quot;Segoe UI&quot;,Roboto,Oxygen,Ubuntu,&quot;Fira Sans&quot;,&quot;Dr=
oid Sans&quot;,&quot;Helvetica Neue&quot;,sans-serif;font-size:1em;font-var=
iant-numeric:normal;font-variant-east-asian:normal;letter-spacing:0em;line-=
height:1.714;white-space:pre-wrap"><br></span></div><div><span style=3D"bac=
kground-color:rgb(235,236,240);color:rgb(23,43,77);font-family:-apple-syste=
m,BlinkMacSystemFont,&quot;Segoe UI&quot;,Roboto,Oxygen,Ubuntu,&quot;Fira S=
ans&quot;,&quot;Droid Sans&quot;,&quot;Helvetica Neue&quot;,sans-serif;font=
-size:1em;font-variant-numeric:normal;font-variant-east-asian:normal;letter=
-spacing:0em;line-height:1.714;white-space:pre-wrap">We encountered the fol=
lowing warnings during cold reboot tests on rhel since 8.3 (i.e., 4.18.0-25=
9). Is it a known bug on 8.3 onwards? Could not figure out the actual cause=
 of this. Any insight would be highly appreciated. Thanks in Advance</span>=
</div><span style=3D"background-color:rgb(235,236,240);color:rgb(23,43,77);=
font-family:-apple-system,BlinkMacSystemFont,&quot;Segoe UI&quot;,Roboto,Ox=
ygen,Ubuntu,&quot;Fira Sans&quot;,&quot;Droid Sans&quot;,&quot;Helvetica Ne=
ue&quot;,sans-serif;font-size:1em;font-variant-numeric:normal;font-variant-=
east-asian:normal;letter-spacing:0em;line-height:1.714;white-space:pre-wrap=
"><div><span style=3D"background-color:rgb(235,236,240);color:rgb(23,43,77)=
;font-family:-apple-system,BlinkMacSystemFont,&quot;Segoe UI&quot;,Roboto,O=
xygen,Ubuntu,&quot;Fira Sans&quot;,&quot;Droid Sans&quot;,&quot;Helvetica N=
eue&quot;,sans-serif;font-size:1em;font-variant-numeric:normal;font-variant=
-east-asian:normal;letter-spacing:0em;line-height:1.714;white-space:pre-wra=
p"><br></span></div><div><span style=3D"background-color:rgb(235,236,240);c=
olor:rgb(23,43,77);font-family:-apple-system,BlinkMacSystemFont,&quot;Segoe=
 UI&quot;,Roboto,Oxygen,Ubuntu,&quot;Fira Sans&quot;,&quot;Droid Sans&quot;=
,&quot;Helvetica Neue&quot;,sans-serif;font-size:1em;font-variant-numeric:n=
ormal;font-variant-east-asian:normal;letter-spacing:0em;line-height:1.714;w=
hite-space:pre-wrap">Following are the call trace:</span></div><div><span s=
tyle=3D"background-color:rgb(235,236,240);color:rgb(23,43,77);font-family:-=
apple-system,BlinkMacSystemFont,&quot;Segoe UI&quot;,Roboto,Oxygen,Ubuntu,&=
quot;Fira Sans&quot;,&quot;Droid Sans&quot;,&quot;Helvetica Neue&quot;,sans=
-serif;font-size:1em;font-variant-numeric:normal;font-variant-east-asian:no=
rmal;letter-spacing:0em;line-height:1.714;white-space:pre-wrap">=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D</span></div>Aug 20 08:01:50 l=
in403 kernel: RIP: 0010:__percpu_ref_switch_mode+0x17d/0x190</span><br styl=
e=3D"color:rgb(23,43,77);font-size:14px;font-variant-numeric:normal;font-va=
riant-east-asian:normal;white-space:pre-wrap"><span style=3D"background-col=
or:rgb(235,236,240);color:rgb(23,43,77);font-family:-apple-system,BlinkMacS=
ystemFont,&quot;Segoe UI&quot;,Roboto,Oxygen,Ubuntu,&quot;Fira Sans&quot;,&=
quot;Droid Sans&quot;,&quot;Helvetica Neue&quot;,sans-serif;font-size:1em;f=
ont-variant-numeric:normal;font-variant-east-asian:normal;letter-spacing:0e=
m;line-height:1.714;white-space:pre-wrap">Aug 20 08:01:50 lin403 kernel: Co=
de: 89 43 08 e9 7c ff ff ff 4d 85 e4 0f 84 73 ff ff ff 48 89 df e8 54 15 7b=
 00 e9 66 ff ff ff f0 48 83 03 01 e9 4c ff ff ff 0f 0b &lt;0f&gt; 0b e9 53 =
ff ff ff e8 87 4a c6 ff 0f 1f 80 00 00 00 00 41 54 49</span><br style=3D"co=
lor:rgb(23,43,77);font-size:14px;font-variant-numeric:normal;font-variant-e=
ast-asian:normal;white-space:pre-wrap"><span style=3D"background-color:rgb(=
235,236,240);color:rgb(23,43,77);font-family:-apple-system,BlinkMacSystemFo=
nt,&quot;Segoe UI&quot;,Roboto,Oxygen,Ubuntu,&quot;Fira Sans&quot;,&quot;Dr=
oid Sans&quot;,&quot;Helvetica Neue&quot;,sans-serif;font-size:1em;font-var=
iant-numeric:normal;font-variant-east-asian:normal;letter-spacing:0em;line-=
height:1.714;white-space:pre-wrap">Aug 20 08:01:50 lin403 kernel: RSP: 0018=
:ffff9c928797fcf0 EFLAGS: 00010046</span><br style=3D"color:rgb(23,43,77);f=
ont-size:14px;font-variant-numeric:normal;font-variant-east-asian:normal;wh=
ite-space:pre-wrap"><span style=3D"background-color:rgb(235,236,240);color:=
rgb(23,43,77);font-family:-apple-system,BlinkMacSystemFont,&quot;Segoe UI&q=
uot;,Roboto,Oxygen,Ubuntu,&quot;Fira Sans&quot;,&quot;Droid Sans&quot;,&quo=
t;Helvetica Neue&quot;,sans-serif;font-size:1em;font-variant-numeric:normal=
;font-variant-east-asian:normal;letter-spacing:0em;line-height:1.714;white-=
space:pre-wrap">Aug 20 08:01:50 lin403 kernel: RAX: 0000330aef61c5d9 RBX: f=
fff89876c635338 RCX: dead000000000200</span><br style=3D"color:rgb(23,43,77=
);font-size:14px;font-variant-numeric:normal;font-variant-east-asian:normal=
;white-space:pre-wrap"><span style=3D"background-color:rgb(235,236,240);col=
or:rgb(23,43,77);font-family:-apple-system,BlinkMacSystemFont,&quot;Segoe U=
I&quot;,Roboto,Oxygen,Ubuntu,&quot;Fira Sans&quot;,&quot;Droid Sans&quot;,&=
quot;Helvetica Neue&quot;,sans-serif;font-size:1em;font-variant-numeric:nor=
mal;font-variant-east-asian:normal;letter-spacing:0em;line-height:1.714;whi=
te-space:pre-wrap">Aug 20 08:01:50 lin403 kernel: RDX: 0000000000000000 RSI=
: 0000000000000000 RDI: ffff89876c635338</span><br style=3D"color:rgb(23,43=
,77);font-size:14px;font-variant-numeric:normal;font-variant-east-asian:nor=
mal;white-space:pre-wrap"><span style=3D"background-color:rgb(235,236,240);=
color:rgb(23,43,77);font-family:-apple-system,BlinkMacSystemFont,&quot;Sego=
e UI&quot;,Roboto,Oxygen,Ubuntu,&quot;Fira Sans&quot;,&quot;Droid Sans&quot=
;,&quot;Helvetica Neue&quot;,sans-serif;font-size:1em;font-variant-numeric:=
normal;font-variant-east-asian:normal;letter-spacing:0em;line-height:1.714;=
white-space:pre-wrap">Aug 20 08:01:50 lin403 kernel: RBP: 0000330aef61c5d8 =
R08: ffffffffa4b23eb8 R09: 0000000000000000</span><br style=3D"color:rgb(23=
,43,77);font-size:14px;font-variant-numeric:normal;font-variant-east-asian:=
normal;white-space:pre-wrap"><span style=3D"background-color:rgb(235,236,24=
0);color:rgb(23,43,77);font-family:-apple-system,BlinkMacSystemFont,&quot;S=
egoe UI&quot;,Roboto,Oxygen,Ubuntu,&quot;Fira Sans&quot;,&quot;Droid Sans&q=
uot;,&quot;Helvetica Neue&quot;,sans-serif;font-size:1em;font-variant-numer=
ic:normal;font-variant-east-asian:normal;letter-spacing:0em;line-height:1.7=
14;white-space:pre-wrap">Aug 20 08:01:50 lin403 kernel: R10: 00000000000000=
00 R11: 00000006a086e9c0 R12: 0000000000000000</span><br style=3D"color:rgb=
(23,43,77);font-size:14px;font-variant-numeric:normal;font-variant-east-asi=
an:normal;white-space:pre-wrap"><span style=3D"background-color:rgb(235,236=
,240);color:rgb(23,43,77);font-family:-apple-system,BlinkMacSystemFont,&quo=
t;Segoe UI&quot;,Roboto,Oxygen,Ubuntu,&quot;Fira Sans&quot;,&quot;Droid San=
s&quot;,&quot;Helvetica Neue&quot;,sans-serif;font-size:1em;font-variant-nu=
meric:normal;font-variant-east-asian:normal;letter-spacing:0em;line-height:=
1.714;white-space:pre-wrap">Aug 20 08:01:50 lin403 kernel: R13: 00000000000=
00001 R14: ffff89876c6b6c00 R15: ffffffffa3eb3dc0</span><br style=3D"color:=
rgb(23,43,77);font-size:14px;font-variant-numeric:normal;font-variant-east-=
asian:normal;white-space:pre-wrap"><span style=3D"background-color:rgb(235,=
236,240);color:rgb(23,43,77);font-family:-apple-system,BlinkMacSystemFont,&=
quot;Segoe UI&quot;,Roboto,Oxygen,Ubuntu,&quot;Fira Sans&quot;,&quot;Droid =
Sans&quot;,&quot;Helvetica Neue&quot;,sans-serif;font-size:1em;font-variant=
-numeric:normal;font-variant-east-asian:normal;letter-spacing:0em;line-heig=
ht:1.714;white-space:pre-wrap">Aug 20 08:01:50 lin403 kernel: FS:  00000000=
00000000(0000) GS:ffff898790300000(0000) knlGS:0000000000000000</span><br s=
tyle=3D"color:rgb(23,43,77);font-size:14px;font-variant-numeric:normal;font=
-variant-east-asian:normal;white-space:pre-wrap"><span style=3D"background-=
color:rgb(235,236,240);color:rgb(23,43,77);font-family:-apple-system,BlinkM=
acSystemFont,&quot;Segoe UI&quot;,Roboto,Oxygen,Ubuntu,&quot;Fira Sans&quot=
;,&quot;Droid Sans&quot;,&quot;Helvetica Neue&quot;,sans-serif;font-size:1e=
m;font-variant-numeric:normal;font-variant-east-asian:normal;letter-spacing=
:0em;line-height:1.714;white-space:pre-wrap">Aug 20 08:01:50 lin403 kernel:=
 CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033</span><br style=3D"color=
:rgb(23,43,77);font-size:14px;font-variant-numeric:normal;font-variant-east=
-asian:normal;white-space:pre-wrap"><span style=3D"background-color:rgb(235=
,236,240);color:rgb(23,43,77);font-family:-apple-system,BlinkMacSystemFont,=
&quot;Segoe UI&quot;,Roboto,Oxygen,Ubuntu,&quot;Fira Sans&quot;,&quot;Droid=
 Sans&quot;,&quot;Helvetica Neue&quot;,sans-serif;font-size:1em;font-varian=
t-numeric:normal;font-variant-east-asian:normal;letter-spacing:0em;line-hei=
ght:1.714;white-space:pre-wrap">Aug 20 08:01:50 lin403 kernel: CR2: 0000559=
d2e4b8380 CR3: 00000007e4c0a004 CR4: 00000000007606a0</span><br style=3D"co=
lor:rgb(23,43,77);font-size:14px;font-variant-numeric:normal;font-variant-e=
ast-asian:normal;white-space:pre-wrap"><span style=3D"background-color:rgb(=
235,236,240);color:rgb(23,43,77);font-family:-apple-system,BlinkMacSystemFo=
nt,&quot;Segoe UI&quot;,Roboto,Oxygen,Ubuntu,&quot;Fira Sans&quot;,&quot;Dr=
oid Sans&quot;,&quot;Helvetica Neue&quot;,sans-serif;font-size:1em;font-var=
iant-numeric:normal;font-variant-east-asian:normal;letter-spacing:0em;line-=
height:1.714;white-space:pre-wrap">Aug 20 08:01:50 lin403 kernel: DR0: 0000=
000000000000 DR1: 0000000000000000 DR2: 0000000000000000</span><br style=3D=
"color:rgb(23,43,77);font-size:14px;font-variant-numeric:normal;font-varian=
t-east-asian:normal;white-space:pre-wrap"><span style=3D"background-color:r=
gb(235,236,240);color:rgb(23,43,77);font-family:-apple-system,BlinkMacSyste=
mFont,&quot;Segoe UI&quot;,Roboto,Oxygen,Ubuntu,&quot;Fira Sans&quot;,&quot=
;Droid Sans&quot;,&quot;Helvetica Neue&quot;,sans-serif;font-size:1em;font-=
variant-numeric:normal;font-variant-east-asian:normal;letter-spacing:0em;li=
ne-height:1.714;white-space:pre-wrap">Aug 20 08:01:50 lin403 kernel: DR3: 0=
000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400</span><br style=
=3D"color:rgb(23,43,77);font-size:14px;font-variant-numeric:normal;font-var=
iant-east-asian:normal;white-space:pre-wrap"><span style=3D"background-colo=
r:rgb(235,236,240);color:rgb(23,43,77);font-family:-apple-system,BlinkMacSy=
stemFont,&quot;Segoe UI&quot;,Roboto,Oxygen,Ubuntu,&quot;Fira Sans&quot;,&q=
uot;Droid Sans&quot;,&quot;Helvetica Neue&quot;,sans-serif;font-size:1em;fo=
nt-variant-numeric:normal;font-variant-east-asian:normal;letter-spacing:0em=
;line-height:1.714;white-space:pre-wrap">Aug 20 08:01:50 lin403 kernel: PKR=
U: 55555554</span><br style=3D"color:rgb(23,43,77);font-size:14px;font-vari=
ant-numeric:normal;font-variant-east-asian:normal;white-space:pre-wrap"><sp=
an style=3D"background-color:rgb(235,236,240);color:rgb(23,43,77);font-fami=
ly:-apple-system,BlinkMacSystemFont,&quot;Segoe UI&quot;,Roboto,Oxygen,Ubun=
tu,&quot;Fira Sans&quot;,&quot;Droid Sans&quot;,&quot;Helvetica Neue&quot;,=
sans-serif;font-size:1em;font-variant-numeric:normal;font-variant-east-asia=
n:normal;letter-spacing:0em;line-height:1.714;white-space:pre-wrap">Aug 20 =
08:01:50 lin403 kernel: Call Trace:</span><br style=3D"color:rgb(23,43,77);=
font-size:14px;font-variant-numeric:normal;font-variant-east-asian:normal;w=
hite-space:pre-wrap"><span style=3D"background-color:rgb(235,236,240);color=
:rgb(23,43,77);font-family:-apple-system,BlinkMacSystemFont,&quot;Segoe UI&=
quot;,Roboto,Oxygen,Ubuntu,&quot;Fira Sans&quot;,&quot;Droid Sans&quot;,&qu=
ot;Helvetica Neue&quot;,sans-serif;font-size:1em;font-variant-numeric:norma=
l;font-variant-east-asian:normal;letter-spacing:0em;line-height:1.714;white=
-space:pre-wrap">Aug 20 08:01:50 lin403 kernel: ? percpu_ref_switch_to_atom=
ic_sync+0x6a/0x90</span><br style=3D"color:rgb(23,43,77);font-size:14px;fon=
t-variant-numeric:normal;font-variant-east-asian:normal;white-space:pre-wra=
p"><span style=3D"background-color:rgb(235,236,240);color:rgb(23,43,77);fon=
t-family:-apple-system,BlinkMacSystemFont,&quot;Segoe UI&quot;,Roboto,Oxyge=
n,Ubuntu,&quot;Fira Sans&quot;,&quot;Droid Sans&quot;,&quot;Helvetica Neue&=
quot;,sans-serif;font-size:1em;font-variant-numeric:normal;font-variant-eas=
t-asian:normal;letter-spacing:0em;line-height:1.714;white-space:pre-wrap">A=
ug 20 08:01:50 lin403 kernel: percpu_ref_switch_to_percpu+0x22/0x40</span><=
br style=3D"color:rgb(23,43,77);font-size:14px;font-variant-numeric:normal;=
font-variant-east-asian:normal;white-space:pre-wrap"><span style=3D"backgro=
und-color:rgb(235,236,240);color:rgb(23,43,77);font-family:-apple-system,Bl=
inkMacSystemFont,&quot;Segoe UI&quot;,Roboto,Oxygen,Ubuntu,&quot;Fira Sans&=
quot;,&quot;Droid Sans&quot;,&quot;Helvetica Neue&quot;,sans-serif;font-siz=
e:1em;font-variant-numeric:normal;font-variant-east-asian:normal;letter-spa=
cing:0em;line-height:1.714;white-space:pre-wrap">Aug 20 08:01:50 lin403 ker=
nel: set_in_sync+0xc4/0xd0</span><br style=3D"color:rgb(23,43,77);font-size=
:14px;font-variant-numeric:normal;font-variant-east-asian:normal;white-spac=
e:pre-wrap"><span style=3D"background-color:rgb(235,236,240);color:rgb(23,4=
3,77);font-family:-apple-system,BlinkMacSystemFont,&quot;Segoe UI&quot;,Rob=
oto,Oxygen,Ubuntu,&quot;Fira Sans&quot;,&quot;Droid Sans&quot;,&quot;Helvet=
ica Neue&quot;,sans-serif;font-size:1em;font-variant-numeric:normal;font-va=
riant-east-asian:normal;letter-spacing:0em;line-height:1.714;white-space:pr=
e-wrap">Aug 20 08:01:50 lin403 kernel: md_check_recovery+0x49d/0x530</span>=
<br style=3D"color:rgb(23,43,77);font-size:14px;font-variant-numeric:normal=
;font-variant-east-asian:normal;white-space:pre-wrap"><span style=3D"backgr=
ound-color:rgb(235,236,240);color:rgb(23,43,77);font-family:-apple-system,B=
linkMacSystemFont,&quot;Segoe UI&quot;,Roboto,Oxygen,Ubuntu,&quot;Fira Sans=
&quot;,&quot;Droid Sans&quot;,&quot;Helvetica Neue&quot;,sans-serif;font-si=
ze:1em;font-variant-numeric:normal;font-variant-east-asian:normal;letter-sp=
acing:0em;line-height:1.714;white-space:pre-wrap">Aug 20 08:01:50 lin403 ke=
rnel: raid1d+0x5c/0x12a0 [raid1]</span><br style=3D"color:rgb(23,43,77);fon=
t-size:14px;font-variant-numeric:normal;font-variant-east-asian:normal;whit=
e-space:pre-wrap"><span style=3D"background-color:rgb(235,236,240);color:rg=
b(23,43,77);font-family:-apple-system,BlinkMacSystemFont,&quot;Segoe UI&quo=
t;,Roboto,Oxygen,Ubuntu,&quot;Fira Sans&quot;,&quot;Droid Sans&quot;,&quot;=
Helvetica Neue&quot;,sans-serif;font-size:1em;font-variant-numeric:normal;f=
ont-variant-east-asian:normal;letter-spacing:0em;line-height:1.714;white-sp=
ace:pre-wrap">Aug 20 08:01:50 lin403 kernel: ? lock_timer_base+0x67/0x80</s=
pan><br style=3D"color:rgb(23,43,77);font-size:14px;font-variant-numeric:no=
rmal;font-variant-east-asian:normal;white-space:pre-wrap"><span style=3D"ba=
ckground-color:rgb(235,236,240);color:rgb(23,43,77);font-family:-apple-syst=
em,BlinkMacSystemFont,&quot;Segoe UI&quot;,Roboto,Oxygen,Ubuntu,&quot;Fira =
Sans&quot;,&quot;Droid Sans&quot;,&quot;Helvetica Neue&quot;,sans-serif;fon=
t-size:1em;font-variant-numeric:normal;font-variant-east-asian:normal;lette=
r-spacing:0em;line-height:1.714;white-space:pre-wrap">Aug 20 08:01:50 lin40=
3 kernel: ? try_to_del_timer_sync+0x4d/0x80</span><br style=3D"color:rgb(23=
,43,77);font-size:14px;font-variant-numeric:normal;font-variant-east-asian:=
normal;white-space:pre-wrap"><span style=3D"background-color:rgb(235,236,24=
0);color:rgb(23,43,77);font-family:-apple-system,BlinkMacSystemFont,&quot;S=
egoe UI&quot;,Roboto,Oxygen,Ubuntu,&quot;Fira Sans&quot;,&quot;Droid Sans&q=
uot;,&quot;Helvetica Neue&quot;,sans-serif;font-size:1em;font-variant-numer=
ic:normal;font-variant-east-asian:normal;letter-spacing:0em;line-height:1.7=
14;white-space:pre-wrap">Aug 20 08:01:50 lin403 kernel: ? del_timer_sync+0x=
25/0x40</span><br style=3D"color:rgb(23,43,77);font-size:14px;font-variant-=
numeric:normal;font-variant-east-asian:normal;white-space:pre-wrap"><span s=
tyle=3D"background-color:rgb(235,236,240);color:rgb(23,43,77);font-family:-=
apple-system,BlinkMacSystemFont,&quot;Segoe UI&quot;,Roboto,Oxygen,Ubuntu,&=
quot;Fira Sans&quot;,&quot;Droid Sans&quot;,&quot;Helvetica Neue&quot;,sans=
-serif;font-size:1em;font-variant-numeric:normal;font-variant-east-asian:no=
rmal;letter-spacing:0em;line-height:1.714;white-space:pre-wrap">Aug 20 08:0=
1:50 lin403 kernel: ? schedule_timeout+0x161/0x310</span><br style=3D"color=
:rgb(23,43,77);font-size:14px;font-variant-numeric:normal;font-variant-east=
-asian:normal;white-space:pre-wrap"><span style=3D"background-color:rgb(235=
,236,240);color:rgb(23,43,77);font-family:-apple-system,BlinkMacSystemFont,=
&quot;Segoe UI&quot;,Roboto,Oxygen,Ubuntu,&quot;Fira Sans&quot;,&quot;Droid=
 Sans&quot;,&quot;Helvetica Neue&quot;,sans-serif;font-size:1em;font-varian=
t-numeric:normal;font-variant-east-asian:normal;letter-spacing:0em;line-hei=
ght:1.714;white-space:pre-wrap">Aug 20 08:01:50 lin403 kernel: ? __next_tim=
er_interrupt+0xc0/0xc0</span><br style=3D"color:rgb(23,43,77);font-size:14p=
x;font-variant-numeric:normal;font-variant-east-asian:normal;white-space:pr=
e-wrap"><span style=3D"background-color:rgb(235,236,240);color:rgb(23,43,77=
);font-family:-apple-system,BlinkMacSystemFont,&quot;Segoe UI&quot;,Roboto,=
Oxygen,Ubuntu,&quot;Fira Sans&quot;,&quot;Droid Sans&quot;,&quot;Helvetica =
Neue&quot;,sans-serif;font-size:1em;font-variant-numeric:normal;font-varian=
t-east-asian:normal;letter-spacing:0em;line-height:1.714;white-space:pre-wr=
ap">Aug 20 08:01:50 lin403 kernel: ? md_register_thread+0xd0/0xd0</span><br=
 style=3D"color:rgb(23,43,77);font-size:14px;font-variant-numeric:normal;fo=
nt-variant-east-asian:normal;white-space:pre-wrap"><span style=3D"backgroun=
d-color:rgb(235,236,240);color:rgb(23,43,77);font-family:-apple-system,Blin=
kMacSystemFont,&quot;Segoe UI&quot;,Roboto,Oxygen,Ubuntu,&quot;Fira Sans&qu=
ot;,&quot;Droid Sans&quot;,&quot;Helvetica Neue&quot;,sans-serif;font-size:=
1em;font-variant-numeric:normal;font-variant-east-asian:normal;letter-spaci=
ng:0em;line-height:1.714;white-space:pre-wrap">Aug 20 08:01:50 lin403 kerne=
l: ? md_thread+0x94/0x150</span><br style=3D"color:rgb(23,43,77);font-size:=
14px;font-variant-numeric:normal;font-variant-east-asian:normal;white-space=
:pre-wrap"><span style=3D"background-color:rgb(235,236,240);color:rgb(23,43=
,77);font-family:-apple-system,BlinkMacSystemFont,&quot;Segoe UI&quot;,Robo=
to,Oxygen,Ubuntu,&quot;Fira Sans&quot;,&quot;Droid Sans&quot;,&quot;Helveti=
ca Neue&quot;,sans-serif;font-size:1em;font-variant-numeric:normal;font-var=
iant-east-asian:normal;letter-spacing:0em;line-height:1.714;white-space:pre=
-wrap">Aug 20 08:01:50 lin403 kernel: ? process_checks+0x4a0/0x4a0 [raid1]<=
/span><br style=3D"color:rgb(23,43,77);font-size:14px;font-variant-numeric:=
normal;font-variant-east-asian:normal;white-space:pre-wrap"><span style=3D"=
background-color:rgb(235,236,240);color:rgb(23,43,77);font-family:-apple-sy=
stem,BlinkMacSystemFont,&quot;Segoe UI&quot;,Roboto,Oxygen,Ubuntu,&quot;Fir=
a Sans&quot;,&quot;Droid Sans&quot;,&quot;Helvetica Neue&quot;,sans-serif;f=
ont-size:1em;font-variant-numeric:normal;font-variant-east-asian:normal;let=
ter-spacing:0em;line-height:1.714;white-space:pre-wrap">Aug 20 08:01:50 lin=
403 kernel: md_thread+0x94/0x150</span><br style=3D"color:rgb(23,43,77);fon=
t-size:14px;font-variant-numeric:normal;font-variant-east-asian:normal;whit=
e-space:pre-wrap"><span style=3D"background-color:rgb(235,236,240);color:rg=
b(23,43,77);font-family:-apple-system,BlinkMacSystemFont,&quot;Segoe UI&quo=
t;,Roboto,Oxygen,Ubuntu,&quot;Fira Sans&quot;,&quot;Droid Sans&quot;,&quot;=
Helvetica Neue&quot;,sans-serif;font-size:1em;font-variant-numeric:normal;f=
ont-variant-east-asian:normal;letter-spacing:0em;line-height:1.714;white-sp=
ace:pre-wrap">Aug 20 08:01:50 lin403 kernel: ? finish_wait+0x80/0x80</span>=
<br style=3D"color:rgb(23,43,77);font-size:14px;font-variant-numeric:normal=
;font-variant-east-asian:normal;white-space:pre-wrap"><span style=3D"backgr=
ound-color:rgb(235,236,240);color:rgb(23,43,77);font-family:-apple-system,B=
linkMacSystemFont,&quot;Segoe UI&quot;,Roboto,Oxygen,Ubuntu,&quot;Fira Sans=
&quot;,&quot;Droid Sans&quot;,&quot;Helvetica Neue&quot;,sans-serif;font-si=
ze:1em;font-variant-numeric:normal;font-variant-east-asian:normal;letter-sp=
acing:0em;line-height:1.714;white-space:pre-wrap">Aug 20 08:01:50 lin403 ke=
rnel: kthread+0x112/0x130</span><br style=3D"color:rgb(23,43,77);font-size:=
14px;font-variant-numeric:normal;font-variant-east-asian:normal;white-space=
:pre-wrap"><span style=3D"background-color:rgb(235,236,240);color:rgb(23,43=
,77);font-family:-apple-system,BlinkMacSystemFont,&quot;Segoe UI&quot;,Robo=
to,Oxygen,Ubuntu,&quot;Fira Sans&quot;,&quot;Droid Sans&quot;,&quot;Helveti=
ca Neue&quot;,sans-serif;font-size:1em;font-variant-numeric:normal;font-var=
iant-east-asian:normal;letter-spacing:0em;line-height:1.714;white-space:pre=
-wrap">Aug 20 08:01:50 lin403 kernel: ? kthread_flush_work_fn+0x10/0x10</sp=
an><br style=3D"color:rgb(23,43,77);font-size:14px;font-variant-numeric:nor=
mal;font-variant-east-asian:normal;white-space:pre-wrap"><span style=3D"bac=
kground-color:rgb(235,236,240);color:rgb(23,43,77);font-family:-apple-syste=
m,BlinkMacSystemFont,&quot;Segoe UI&quot;,Roboto,Oxygen,Ubuntu,&quot;Fira S=
ans&quot;,&quot;Droid Sans&quot;,&quot;Helvetica Neue&quot;,sans-serif;font=
-size:1em;font-variant-numeric:normal;font-variant-east-asian:normal;letter=
-spacing:0em;line-height:1.714;white-space:pre-wrap">Aug 20 08:01:50 lin403=
 kernel: ret_from_fork+0x35/0x40</span><br style=3D"color:rgb(23,43,77);fon=
t-size:14px;font-variant-numeric:normal;font-variant-east-asian:normal;whit=
e-space:pre-wrap"><span style=3D"background-color:rgb(235,236,240);color:rg=
b(23,43,77);font-family:-apple-system,BlinkMacSystemFont,&quot;Segoe UI&quo=
t;,Roboto,Oxygen,Ubuntu,&quot;Fira Sans&quot;,&quot;Droid Sans&quot;,&quot;=
Helvetica Neue&quot;,sans-serif;font-size:1em;font-variant-numeric:normal;f=
ont-variant-east-asian:normal;letter-spacing:0em;line-height:1.714;white-sp=
ace:pre-wrap">Aug 20 08:01:50 lin403 kernel: ---[ end trace c6ca999cff8213e=
0 ]---</span><br><div><span style=3D"background-color:rgb(235,236,240);colo=
r:rgb(23,43,77);font-family:-apple-system,BlinkMacSystemFont,&quot;Segoe UI=
&quot;,Roboto,Oxygen,Ubuntu,&quot;Fira Sans&quot;,&quot;Droid Sans&quot;,&q=
uot;Helvetica Neue&quot;,sans-serif;font-size:1em;font-variant-numeric:norm=
al;font-variant-east-asian:normal;letter-spacing:0em;line-height:1.714;whit=
e-space:pre-wrap"><br></span></div><div><span style=3D"background-color:rgb=
(235,236,240);color:rgb(23,43,77);font-family:-apple-system,BlinkMacSystemF=
ont,&quot;Segoe UI&quot;,Roboto,Oxygen,Ubuntu,&quot;Fira Sans&quot;,&quot;D=
roid Sans&quot;,&quot;Helvetica Neue&quot;,sans-serif;font-size:1em;font-va=
riant-numeric:normal;font-variant-east-asian:normal;letter-spacing:0em;line=
-height:1.714;white-space:pre-wrap">Regards,</span></div><div><span style=
=3D"background-color:rgb(235,236,240);color:rgb(23,43,77);font-family:-appl=
e-system,BlinkMacSystemFont,&quot;Segoe UI&quot;,Roboto,Oxygen,Ubuntu,&quot=
;Fira Sans&quot;,&quot;Droid Sans&quot;,&quot;Helvetica Neue&quot;,sans-ser=
if;font-size:1em;font-variant-numeric:normal;font-variant-east-asian:normal=
;letter-spacing:0em;line-height:1.714;white-space:pre-wrap">Srinivasa Ragha=
van</span></div></div>

--000000000000f4344005bad3b6c6--

--===============3418037504681142001==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel
--===============3418037504681142001==--

