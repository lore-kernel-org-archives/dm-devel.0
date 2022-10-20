Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CD82DC433FE
	for <dm-devel@archiver.kernel.org>; Thu, 20 Oct 2022 05:27:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1666243642;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=9TfWskd5SD3GJC8S5eVr81Q23TK7d1Y9t6BOH/5w6X8=;
	b=TQEvonZn4aCB09z4BuMUTVUurXf9VPvN55nuL+OnBaNEIE25xNjwPMM60KJ0AP01w2s9+p
	jZu7n5cwlWQKaC3EEwR3wzTTbzK9ZXXcfwFJuBpmJDD83t5d+2H2v8Msqn6lLZGrnJ8mt9
	teFluQExy5LfqytJFsso/j5ReoiZvR0=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-310-ImDxV--wNEyVs1fGTFkX9A-1; Thu, 20 Oct 2022 01:27:19 -0400
X-MC-Unique: ImDxV--wNEyVs1fGTFkX9A-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 64B633C0D86C;
	Thu, 20 Oct 2022 05:26:55 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id DF4FA1402BDA;
	Thu, 20 Oct 2022 05:26:33 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id AC36A19465A4;
	Thu, 20 Oct 2022 05:26:32 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id E340D1946595
 for <dm-devel@listman.corp.redhat.com>; Thu, 20 Oct 2022 05:26:30 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 11E63111DCF9; Thu, 20 Oct 2022 05:26:30 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 0A2BC111DCE0
 for <dm-devel@redhat.com>; Thu, 20 Oct 2022 05:26:29 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 62524185A78B
 for <dm-devel@redhat.com>; Thu, 20 Oct 2022 05:26:29 +0000 (UTC)
Received: from cu-gy11p00im-quki08153201.gy.silu.net
 (cu-gy11p00im-quki08153201.gy.silu.net [157.255.1.67]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-172-SWF6sPG0M9KtVeLuecGgkQ-1; Thu, 20 Oct 2022 01:26:20 -0400
X-MC-Unique: SWF6sPG0M9KtVeLuecGgkQ-1
Received: from smtpclient.apple (unknown [116.2.40.196])
 by gy11p00im-quki08153201.gy.silu.net (Postfix) with ESMTPS id 1BB792E8015E
 for <dm-devel@redhat.com>; Thu, 20 Oct 2022 05:18:48 +0000 (UTC)
From: xingyongji@icloud.com
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3696.120.41.1.1\))
Message-Id: <C23F08B5-052A-4769-8190-089F7450B6BE@icloud.com>
References: <BE7F9CD3-8E2B-4273-8B29-A2811956EACA@icloud.com>
To: dm-devel@redhat.com
Date: Thu, 20 Oct 2022 13:18:21 +0800
X-Proofpoint-ORIG-GUID: y8IKRqUF-gPWC5ecnC8DYGleDQDIT4xC
X-Proofpoint-GUID: y8IKRqUF-gPWC5ecnC8DYGleDQDIT4xC
X-Proofpoint-Virus-Version: =?UTF-8?Q?vendor=3Dfsecure_engine=3D1.1.170-22c6f66c430a71ce266a39bfe25bc?=
 =?UTF-8?Q?2903e8d5c8f:6.0.528,18.0.895,17.0.605.474.0000000_definitions?=
 =?UTF-8?Q?=3D2022-09-21=5F12:2022-09-20=5F02,2022-09-21=5F12,2020-01-23?=
 =?UTF-8?Q?=5F02_signatures=3D0?=
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0
 suspectscore=0 phishscore=0
 malwarescore=0 adultscore=0 bulkscore=0 mlxscore=0 mlxlogscore=802
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2210200029
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
Subject: [dm-devel] Problem about multipath failover
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/mixed; boundary="===============3749603469597611256=="

--===============3749603469597611256==
Content-Type: multipart/alternative;
	boundary="Apple-Mail=_7671A190-1F3C-4135-ABF4-FBED5FF5FE2F"

--Apple-Mail=_7671A190-1F3C-4135-ABF4-FBED5FF5FE2F
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=utf-8

Hello:

=09My environment like this:

Host
                     Multipath
          Iscsi dev 1.          Iscsi dev. 2
         (A/ optimized)      (A/ optimized)       (ALUA)

Server
         Target 1                Target 2
        =EF=BC=88ser 1)                 (ser 2)

    When dev 1 failed, the IO on dev 1 forward to dev2 without any operatio=
n,
So I have no chance to do something for the dev 1=E2=80=99s error.
    Before I finish the error on dev1, I do not want any IO on dev1 forward=
 to dev2.
Is there any Mechanism or method can be used? =20
    Best Wishes.
--Apple-Mail=_7671A190-1F3C-4135-ABF4-FBED5FF5FE2F
Content-Transfer-Encoding: quoted-printable
Content-Type: text/html;
	charset=utf-8

<html><head><meta http-equiv=3D"Content-Type" content=3D"text/html; charset=
=3Dutf-8"></head><body style=3D"word-wrap: break-word; -webkit-nbsp-mode: s=
pace; line-break: after-white-space;" class=3D""><div dir=3D"auto" style=3D=
"word-wrap: break-word; -webkit-nbsp-mode: space; line-break: after-white-s=
pace;" class=3D""><meta http-equiv=3D"Content-Type" content=3D"text/html; c=
harset=3Dutf-8" class=3D""><div style=3D"word-wrap: break-word; -webkit-nbs=
p-mode: space; line-break: after-white-space;" class=3D"">Hello:<div class=
=3D""><br class=3D""><div class=3D"" style=3D"caret-color: rgb(0, 0, 0); co=
lor: rgb(0, 0, 0);"><span class=3D"Apple-tab-span" style=3D"white-space:pre=
">=09</span>My environment like this:</div><div class=3D"" style=3D"caret-c=
olor: rgb(0, 0, 0); color: rgb(0, 0, 0);"><br class=3D""></div><div class=
=3D"" style=3D"caret-color: rgb(0, 0, 0); color: rgb(0, 0, 0);">Host</div><=
div class=3D"" style=3D"caret-color: rgb(0, 0, 0); color: rgb(0, 0, 0);">&n=
bsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;M=
ultipath</div><div class=3D"" style=3D"caret-color: rgb(0, 0, 0); color: rg=
b(0, 0, 0);">&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; Iscsi dev 1. &nbsp; &nbsp; =
&nbsp; &nbsp; &nbsp;Iscsi dev. 2</div><div class=3D"" style=3D"caret-color:=
 rgb(0, 0, 0); color: rgb(0, 0, 0);">&nbsp; &nbsp; &nbsp; &nbsp; &nbsp;(A/ =
optimized) &nbsp; &nbsp; &nbsp;<span class=3D"">(A/ optimized) &nbsp; &nbsp=
; &nbsp; (ALUA)</span></div><div class=3D"" style=3D"caret-color: rgb(0, 0,=
 0); color: rgb(0, 0, 0);"><span class=3D""><br class=3D""></span></div><di=
v class=3D"" style=3D"caret-color: rgb(0, 0, 0); color: rgb(0, 0, 0);"><fon=
t color=3D"#000000" class=3D"">Server</font></div><div class=3D"" style=3D"=
caret-color: rgb(0, 0, 0); color: rgb(0, 0, 0);"><font color=3D"#000000" cl=
ass=3D"">&nbsp; &nbsp; &nbsp; &nbsp; &nbsp;Target 1 &nbsp; &nbsp; &nbsp; &n=
bsp; &nbsp; &nbsp; &nbsp; &nbsp;Target 2</font></div><div class=3D"" style=
=3D"caret-color: rgb(0, 0, 0); color: rgb(0, 0, 0);"><font color=3D"#000000=
" class=3D"">&nbsp; &nbsp; &nbsp; &nbsp; =EF=BC=88ser 1) &nbsp; &nbsp; &nbs=
p; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; (ser 2)</font></div><div class=3D"" s=
tyle=3D"caret-color: rgb(0, 0, 0); color: rgb(0, 0, 0);"><font color=3D"#00=
0000" class=3D""><br class=3D""></font></div><div class=3D"" style=3D"caret=
-color: rgb(0, 0, 0); color: rgb(0, 0, 0);"><font color=3D"#000000" class=
=3D"">&nbsp; &nbsp;&nbsp;When dev 1 failed, the IO on dev 1 forward to dev2=
 without any operation,</font></div><div class=3D"" style=3D"caret-color: r=
gb(0, 0, 0); color: rgb(0, 0, 0);"><font color=3D"#000000" class=3D"">So I&=
nbsp;have no chance to do something for the dev 1=E2=80=99s error.</font></=
div><div class=3D"" style=3D"caret-color: rgb(0, 0, 0); color: rgb(0, 0, 0)=
;"><font color=3D"#000000" class=3D"">&nbsp; &nbsp;&nbsp;<span class=3D"">B=
efore I finish the error on&nbsp;</span></font><span class=3D"">dev1, I do =
not want any IO on dev1 forward to dev2.</span></div><div class=3D"" style=
=3D"caret-color: rgb(0, 0, 0); color: rgb(0, 0, 0);"><span class=3D"">Is th=
ere any&nbsp;</span><span class=3D"">Mechanism or method can be used? &nbsp=
;</span></div><div class=3D"" style=3D"caret-color: rgb(0, 0, 0); color: rg=
b(0, 0, 0);"><span class=3D"">&nbsp; &nbsp;&nbsp;</span><font color=3D"#000=
000" class=3D"">Best Wishes.</font></div></div></div></div></body></html>
--Apple-Mail=_7671A190-1F3C-4135-ABF4-FBED5FF5FE2F--

--===============3749603469597611256==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

--===============3749603469597611256==--

