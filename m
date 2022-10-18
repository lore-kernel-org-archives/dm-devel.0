Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DDC66C4332F
	for <dm-devel@archiver.kernel.org>; Tue, 18 Oct 2022 07:10:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1666077043;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=uthyBLsJ2lCqkMpLUQGCDEqhrG4ryd0laodQry2LHck=;
	b=c55XhLE+Cmi+P/MmFmSobsFJF45sM3KGINHkcPR86PkH12s/yu09vdZUh/x0FqFlLV87F1
	kcGBICcweA+YT3q5DONcHdUKKwqeKNaQCWS20T0Y9rqvagNA6iJZeG7Hpe5aReU/QZmco8
	ADrsY/wr8qcuK8zZaeD/H+iFOpN0+lQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-517-6VG5b1gZNw-nv0pPmowfbA-1; Tue, 18 Oct 2022 03:10:40 -0400
X-MC-Unique: 6VG5b1gZNw-nv0pPmowfbA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id ACECE833AF1;
	Tue, 18 Oct 2022 07:10:38 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 01C65E56A7;
	Tue, 18 Oct 2022 07:10:37 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 36AC719465B2;
	Tue, 18 Oct 2022 07:10:36 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 995D8194658F
 for <dm-devel@listman.corp.redhat.com>; Tue, 18 Oct 2022 07:02:56 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 89328492B0A; Tue, 18 Oct 2022 07:02:56 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 8243856D17E
 for <dm-devel@redhat.com>; Tue, 18 Oct 2022 07:02:56 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6776D86F12C
 for <dm-devel@redhat.com>; Tue, 18 Oct 2022 07:02:56 +0000 (UTC)
Received: from cu-ua11p00im-quki08153402.ua.silu.net
 (cu-ua11p00im-quki08153402.ua.silu.net [123.126.78.67]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-595-PYDHxut4OUW56cdsc0IIhQ-1; Tue, 18 Oct 2022 03:02:54 -0400
X-MC-Unique: PYDHxut4OUW56cdsc0IIhQ-1
Received: from smtpclient.apple (unknown [116.2.60.88])
 by ua11p00im-quki08153402.ua.silu.net (Postfix) with ESMTPS id DFCE02FC00E6
 for <dm-devel@redhat.com>; Tue, 18 Oct 2022 06:54:30 +0000 (UTC)
From: xingyongji@icloud.com
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3696.120.41.1.1\))
Message-Id: <7BA86099-9397-45E4-A543-3BBF59106005@icloud.com>
References: <BE7F9CD3-8E2B-4273-8B29-A2811956EACA@icloud.com>
To: dm-devel@redhat.com
Date: Tue, 18 Oct 2022 14:54:04 +0800
X-Proofpoint-GUID: EAcejwEg8dMLKYxa77X7I9AYzqioFG7e
X-Proofpoint-ORIG-GUID: EAcejwEg8dMLKYxa77X7I9AYzqioFG7e
X-Proofpoint-Virus-Version: =?UTF-8?Q?vendor=3Dfsecure_engine=3D1.1.170-22c6f66c430a71ce266a39bfe25bc?=
 =?UTF-8?Q?2903e8d5c8f:6.0.528,18.0.895,17.0.605.474.0000000_definitions?=
 =?UTF-8?Q?=3D2022-09-21=5F12:2022-09-20=5F02,2022-09-21=5F12,2020-01-23?=
 =?UTF-8?Q?=5F02_signatures=3D0?=
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0
 mlxscore=0 spamscore=0
 phishscore=0 malwarescore=0 bulkscore=0 suspectscore=0 mlxlogscore=816
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2210180039
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mailman-Approved-At: Tue, 18 Oct 2022 07:10:34 +0000
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/mixed; boundary="===============0296190633685078902=="

--===============0296190633685078902==
Content-Type: multipart/alternative;
	boundary="Apple-Mail=_18EBC36A-E908-4D03-8376-CEDCFC5D956B"

--Apple-Mail=_18EBC36A-E908-4D03-8376-CEDCFC5D956B
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
--Apple-Mail=_18EBC36A-E908-4D03-8376-CEDCFC5D956B
Content-Transfer-Encoding: quoted-printable
Content-Type: text/html;
	charset=utf-8

<html><head><meta http-equiv=3D"Content-Type" content=3D"text/html; charset=
=3Dutf-8"></head><body style=3D"word-wrap: break-word; -webkit-nbsp-mode: s=
pace; line-break: after-white-space;" class=3D"">Hello:<div class=3D""><br =
class=3D""><div class=3D"" style=3D"caret-color: rgb(0, 0, 0); color: rgb(0=
, 0, 0);"><span class=3D"Apple-tab-span" style=3D"white-space:pre">=09</spa=
n>My environment like this:</div><div class=3D"" style=3D"caret-color: rgb(=
0, 0, 0); color: rgb(0, 0, 0);"><br class=3D""></div><div class=3D"" style=
=3D"caret-color: rgb(0, 0, 0); color: rgb(0, 0, 0);">Host</div><div class=
=3D"" style=3D"caret-color: rgb(0, 0, 0); color: rgb(0, 0, 0);">&nbsp; &nbs=
p; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;Multipath<=
/div><div class=3D"" style=3D"caret-color: rgb(0, 0, 0); color: rgb(0, 0, 0=
);">&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; Iscsi dev 1. &nbsp; &nbsp; &nbsp; &n=
bsp; &nbsp;Iscsi dev. 2</div><div class=3D"" style=3D"caret-color: rgb(0, 0=
, 0); color: rgb(0, 0, 0);">&nbsp; &nbsp; &nbsp; &nbsp; &nbsp;(A/ optimized=
) &nbsp; &nbsp; &nbsp;<span class=3D"">(A/ optimized) &nbsp; &nbsp; &nbsp; =
(ALUA)</span></div><div class=3D"" style=3D"caret-color: rgb(0, 0, 0); colo=
r: rgb(0, 0, 0);"><span class=3D""><br class=3D""></span></div><div class=
=3D"" style=3D"caret-color: rgb(0, 0, 0); color: rgb(0, 0, 0);"><font color=
=3D"#000000" class=3D"">Server</font></div><div class=3D"" style=3D"caret-c=
olor: rgb(0, 0, 0); color: rgb(0, 0, 0);"><font color=3D"#000000" class=3D"=
">&nbsp; &nbsp; &nbsp; &nbsp; &nbsp;Target 1 &nbsp; &nbsp; &nbsp; &nbsp; &n=
bsp; &nbsp; &nbsp; &nbsp;Target 2</font></div><div class=3D"" style=3D"care=
t-color: rgb(0, 0, 0); color: rgb(0, 0, 0);"><font color=3D"#000000" class=
=3D"">&nbsp; &nbsp; &nbsp; &nbsp; =EF=BC=88ser 1) &nbsp; &nbsp; &nbsp; &nbs=
p; &nbsp; &nbsp; &nbsp; &nbsp; (ser 2)</font></div><div class=3D"" style=3D=
"caret-color: rgb(0, 0, 0); color: rgb(0, 0, 0);"><font color=3D"#000000" c=
lass=3D""><br class=3D""></font></div><div class=3D"" style=3D"caret-color:=
 rgb(0, 0, 0); color: rgb(0, 0, 0);"><font color=3D"#000000" class=3D"">&nb=
sp; &nbsp;&nbsp;When dev 1 failed, the IO on dev 1 forward to dev2 without =
any operation,</font></div><div class=3D"" style=3D"caret-color: rgb(0, 0, =
0); color: rgb(0, 0, 0);"><font color=3D"#000000" class=3D"">So I&nbsp;have=
 no chance to do something for the dev 1=E2=80=99s error.</font></div><div =
class=3D"" style=3D"caret-color: rgb(0, 0, 0); color: rgb(0, 0, 0);"><font =
color=3D"#000000" class=3D"">&nbsp; &nbsp;&nbsp;<span class=3D"">Before I f=
inish the error on&nbsp;</span></font><span class=3D"">dev1, I do not want =
any IO on dev1 forward to dev2.</span></div><div class=3D"" style=3D"caret-=
color: rgb(0, 0, 0); color: rgb(0, 0, 0);"><span class=3D"">Is there any&nb=
sp;</span><span class=3D"">Mechanism or method can be used? &nbsp;</span></=
div><div class=3D"" style=3D"caret-color: rgb(0, 0, 0); color: rgb(0, 0, 0)=
;"><span class=3D"">&nbsp; &nbsp;&nbsp;</span><font color=3D"#000000" class=
=3D"">Best Wishes.</font></div></div></body></html>
--Apple-Mail=_18EBC36A-E908-4D03-8376-CEDCFC5D956B--

--===============0296190633685078902==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

--===============0296190633685078902==--

