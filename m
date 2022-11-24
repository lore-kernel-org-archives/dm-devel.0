Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D0CE4C4332F
	for <dm-devel@archiver.kernel.org>; Thu, 24 Nov 2022 08:29:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1669278559;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:list-id:list-help:list-unsubscribe:
	 list-subscribe:list-post; bh=z2+I07ZfL7HiMpPhgVjlBlnBTbVGdU4h3hwoqiFtTKM=;
	b=DuZp6p7Hqz8452xIjpzyrGFztDbOqfxBKBpuEKomNSVATDvx7Yte1rALIJaK4TKY9YnI07
	aeeqtdEE7IdLUC17orJzdMRLIDUt6RcgBDxTjx6GHZ5Dl6LMVYFn4iSYuon3CfC3Z2iUA8
	dd8kipA38hqdsXcrTVvULlizy4a4PGo=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-271-5rb4xwvrOSuFFfsqcIH3Ig-1; Thu, 24 Nov 2022 03:29:16 -0500
X-MC-Unique: 5rb4xwvrOSuFFfsqcIH3Ig-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3AFFD3C01C0F;
	Thu, 24 Nov 2022 08:29:14 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id E37362166B26;
	Thu, 24 Nov 2022 08:29:09 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 4770E1946589;
	Thu, 24 Nov 2022 08:29:06 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id B92B31946587
 for <dm-devel@listman.corp.redhat.com>; Thu, 24 Nov 2022 05:38:37 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 8570F111E3ED; Thu, 24 Nov 2022 05:38:37 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 7DB39111E3EB
 for <dm-devel@redhat.com>; Thu, 24 Nov 2022 05:38:37 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 59EC53C0D19D
 for <dm-devel@redhat.com>; Thu, 24 Nov 2022 05:38:37 +0000 (UTC)
Received: from mail-qv1-f53.google.com (mail-qv1-f53.google.com
 [209.85.219.53]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-399-xCfpXuV2OnCNTvTGo20CHQ-1; Thu, 24 Nov 2022 00:38:34 -0500
X-MC-Unique: xCfpXuV2OnCNTvTGo20CHQ-1
Received: by mail-qv1-f53.google.com with SMTP id q10so380645qvt.10
 for <dm-devel@redhat.com>; Wed, 23 Nov 2022 21:38:34 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=to:subject:message-id:date:from:mime-version:x-gm-message-state
 :from:to:cc:subject:date:message-id:reply-to;
 bh=dHRZVuyAMBgxbBLfWpjkY6Fk3E3tOxd0yhdteOI9fbo=;
 b=ipZlYpaO6Ot+Do7Y4qusYuJww+w5VWCHFvhY/cpXPPVJsc7rNCYZuMNeldEQ4S6C1Q
 G7oZ8uhEqXMtr1bxnGhSGRIhgGQsMskrfOPurzzpqoXRIvSjQNpU4l4EbMGZT9Xwga2h
 jGsIO0hcc+3hpxPXr9RX9aEaep4uejf2TmjIP1aIYZeQuWbAS3TEUUyQjDnMa4CyJ91m
 dlreDKZqoN2kQAVqoT/+x1viLA7gayb3wvQv+Z0H9N8zdfVK1bcf+77txjpEP+6+wnZ/
 3Qami72ouExGHWgcgzEr//4XDZFdwS0Ym9rtnNOVwOnh0BGbLgQ7D5f0vtTx7llDvL4m
 BMPw==
X-Gm-Message-State: ANoB5plqeEp7pkcsU95CstYpFgB31Akr6/LWn1yN8YnIkohA1Fv8f/4U
 ix3WB69RLgOKAgR26Z9kH7LP0zqhpR2URx2/LOUuqEQvbhdvVDipdjIakvSWBSO4laE5UfgZDi+
 oUJFO+RXI6odMjm6zYQgG9aYOaGrw
X-Google-Smtp-Source: AA0mqf4/keqlc2YrrCKPpEaAsPrD+1w1K/1sXkZcVeiB00+TsBfngQT1uHLm3EsIEVhlD9Fv7IpQuhfwNmhAgCS8lKo=
X-Received: by 2002:a0c:9c43:0:b0:4c6:62af:5e17 with SMTP id
 w3-20020a0c9c43000000b004c662af5e17mr13414906qve.95.1669268313991; Wed, 23
 Nov 2022 21:38:33 -0800 (PST)
MIME-Version: 1.0
From: Vivek Patil <vivek.patil@forgeahead.io>
Date: Thu, 24 Nov 2022 11:07:58 +0530
Message-ID: <CAN506jTJhpN9mgBDFmAM0jvzVar9xnNNN1pmCHPEOTERVv5F+g@mail.gmail.com>
To: christophe.varoqui@opensvc.com, dm-devel@redhat.com
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Mailman-Approved-At: Thu, 24 Nov 2022 08:29:05 +0000
Subject: [dm-devel] Update issues for kpartx
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
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/mixed; boundary="===============5743007164114596591=="

--===============5743007164114596591==
Content-Type: multipart/alternative; boundary="000000000000e4041405ee30d05a"

--000000000000e4041405ee30d05a
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

I have a bunch of "CentOS Linux release 7.9.2009 (Core)" running production
load.
My security team informed me that the package
"kpartx-0.4.9-135.el7_9.x86_64" has some vulnerabilities [CVE-2022-41974].

When I tried to do "yum update kpartx" it showed no updates available.
I have checked the update repo for centos
<http://mirror.centos.org/centos/7/updates/x86_64/Packages/>, it also
doesn't have the updates for kpartx.

I need to update the version to kpartx-0.4.9-*136*.el7_9.x86_64.

Can you please help me out with this?

--=20
Vivek Patil
IT Department

--=20
Email Disclaimer:=C2=A0*http://www.forgeahead.io/disclaimer/=20
<http://www.forgeahead.io/disclaimer/>*

--000000000000e4041405ee30d05a
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div class=3D"gmail_default" style=3D"font-family:verdana,=
sans-serif">Hi,</div><div class=3D"gmail_default" style=3D"font-family:verd=
ana,sans-serif"><br></div><div class=3D"gmail_default" style=3D"font-family=
:verdana,sans-serif">I have a bunch of &quot;CentOS Linux release 7.9.2009 =
(Core)&quot; running production load.</div><div class=3D"gmail_default" sty=
le=3D"font-family:verdana,sans-serif">My security team informed me that the=
 package &quot;kpartx-0.4.9-135.el7_9.x86_64&quot; has some vulnerabilities=
=C2=A0[CVE-2022-41974].</div><div class=3D"gmail_default" style=3D"font-fam=
ily:verdana,sans-serif"><br></div><div class=3D"gmail_default" style=3D"fon=
t-family:verdana,sans-serif">When I tried to do &quot;yum update kpartx&quo=
t; it showed no updates available.</div><div class=3D"gmail_default" style=
=3D"font-family:verdana,sans-serif">I have checked=C2=A0the <a href=3D"http=
://mirror.centos.org/centos/7/updates/x86_64/Packages/">update repo for cen=
tos</a>, it also doesn&#39;t have the updates for kpartx.</div><div class=
=3D"gmail_default" style=3D"font-family:verdana,sans-serif"><br></div><div =
class=3D"gmail_default" style=3D"font-family:verdana,sans-serif">I need to =
update the version to=C2=A0kpartx-0.4.9-<b>136</b>.el7_9.x86_64.</div><div =
class=3D"gmail_default" style=3D"font-family:verdana,sans-serif"><br></div>=
<div class=3D"gmail_default" style=3D"font-family:verdana,sans-serif">Can y=
ou please help me out with this?</div><div><br></div>-- <br><div dir=3D"ltr=
" class=3D"gmail_signature" data-smartmail=3D"gmail_signature"><div dir=3D"=
ltr"><div style=3D"color:rgb(0,0,0);font-weight:bold"></div></div></div><di=
v><div class=3D"gmail_default" style=3D"font-family:verdana,sans-serif">Viv=
ek Patil</div><div class=3D"gmail_default" style=3D"font-family:verdana,san=
s-serif">IT Department</div><br></div></div>

<br>
<span style=3D"font-family:arial,sans-serif;font-size:12.8px;color:rgb(34,3=
4,34);background-color:rgb(255,255,255)">Email Disclaimer:</span><span styl=
e=3D"font-family:arial,sans-serif;font-size:12.8px;color:rgb(31,73,125);bac=
kground-color:rgb(255,255,255)">=C2=A0</span><font color=3D"#1155cc" face=
=3D"arial, sans-serif"><span style=3D"font-size:12.8px"><u><a href=3D"http:=
//www.forgeahead.io/disclaimer/" target=3D"_blank">http://www.<wbr>forgeahe=
ad.io/disclaimer/</a></u></span></font>
--000000000000e4041405ee30d05a--

--===============5743007164114596591==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

--===============5743007164114596591==--

