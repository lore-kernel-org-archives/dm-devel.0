Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ABBB4C433EF
	for <dm-devel@archiver.kernel.org>; Tue, 12 Jul 2022 08:15:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1657613745;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:list-id:list-help:list-unsubscribe:
	 list-subscribe:list-post; bh=FegFs/U/QClN0ddGnmRTiOeqTYow4GunXhHBRHoZJ7c=;
	b=Q0pNIbfvYb+U8IwAh3gZ6uKAAUK1AppQ31WAQ2yTvpouwBoF5PK6dxSUsR0+vgusW1WpJE
	VuZNr4So/s7SWl2OAou1XAnQM1k4meLUOly7uXsbGtkf9Ui7mTqN4eS67/WojNqycSkgOq
	wXu5rpxcABmq2ngY24BRZoVrplHnrFg=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-161-EwoP55cUNT6rrKx5HrzL6A-1; Tue, 12 Jul 2022 04:15:42 -0400
X-MC-Unique: EwoP55cUNT6rrKx5HrzL6A-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 34CBE101AA48;
	Tue, 12 Jul 2022 08:15:32 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 485ED1121315;
	Tue, 12 Jul 2022 08:15:31 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id F1E141947B81;
	Tue, 12 Jul 2022 08:15:29 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 5AD93194706B
 for <dm-devel@listman.corp.redhat.com>; Fri,  8 Jul 2022 05:47:33 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 4EC96401E54; Fri,  8 Jul 2022 05:47:33 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 4A3F5492C3B
 for <dm-devel@redhat.com>; Fri,  8 Jul 2022 05:47:33 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2CD6C1C04B48
 for <dm-devel@redhat.com>; Fri,  8 Jul 2022 05:47:33 +0000 (UTC)
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com
 [209.85.210.173]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-324-g25oUBCaN8mopnS_1ck48g-1; Fri, 08 Jul 2022 01:47:29 -0400
X-MC-Unique: g25oUBCaN8mopnS_1ck48g-1
Received: by mail-pf1-f173.google.com with SMTP id y141so22666216pfb.7
 for <dm-devel@redhat.com>; Thu, 07 Jul 2022 22:47:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:from:to:cc:subject:thread-topic:thread-index
 :date:message-id:accept-language:content-language:mime-version;
 bh=Ymtst1dOB0e5/k2F2LjTNkIh+ikjxyyxHdjJ3OK7R+o=;
 b=T8quK4GzFtx/CrAAPuLa17XOIwDJOijB1rF9iWa4i9G9I8+xQnzMera/lyudfkPBdY
 yqRQbSxIO8EnXBXJ/axc1t6OjktB8iK4RBtXkBJv9MWKk3fz3rI9uubd04YIUghbC12o
 io7ERIruy8ugI3UqxWtBUfQqkVob31zf7DhtOzen4v9ArHYpEeHBZvxYb3hiYWAxHVhc
 Ao0SmBJiWZ4ot/QJADl2pAehCOY37iuB+NeqnXnPsx/JAZVj3x2vJZDILpQYUghYRRCs
 n+lMq1ErNfVLvCexVwGReNIDBmAMRzRq8NLKPV4Pj1T7qDNZBZ3O12xwLdn8r4GkHJ/l
 PSWg==
X-Gm-Message-State: AJIora/VYcAtPM+uaiIhLRwE1+LRIEk14vBhCz36i0TdhHak4mtn1ReX
 St8bLY5+hXBhaYUCu7itU7kCUsnvpxYP5g==
X-Google-Smtp-Source: AGRyM1va/6ihLgT/wXIUkxxjezUZ/EXDJfBQ+dR6eBYLmFdQ1wAWUk8hKWeRjSr1BBTKBGNXI9GS3A==
X-Received: by 2002:a63:5446:0:b0:40d:91e2:e9bf with SMTP id
 e6-20020a635446000000b0040d91e2e9bfmr1788125pgm.235.1657259248168; 
 Thu, 07 Jul 2022 22:47:28 -0700 (PDT)
Received: from BY5PR13MB3601.namprd13.prod.outlook.com
 ([2603:1036:307:4014::5]) by smtp.gmail.com with ESMTPSA id
 u12-20020a17090341cc00b0016c19417495sm1906358ple.239.2022.07.07.22.47.26
 (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
 Thu, 07 Jul 2022 22:47:27 -0700 (PDT)
From: Uday Jonnala <uday.jonnala@tessell.com>
To: "dm-devel@redhat.com" <dm-devel@redhat.com>
Thread-Topic: Regarding dm-clone
Thread-Index: AQHYko3nhcEoO0d5wky+aTHTq4IWJw==
X-MS-Exchange-MessageSentRepresentingType: 1
Date: Fri, 8 Jul 2022 05:47:25 +0000
Message-ID: <BY5PR13MB36015939B775B8841309EC62FC829@BY5PR13MB3601.namprd13.prod.outlook.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-Exchange-Organization-SCL: -1
X-MS-TNEF-Correlator: 
X-MS-Exchange-Organization-RecordReviewCfmType: 0
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
X-Mailman-Approved-At: Tue, 12 Jul 2022 08:15:28 +0000
Subject: [dm-devel] Regarding dm-clone
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
Cc: "swaminathan.ks@tessell.com" <swaminathan.ks@tessell.com>,
 "uday.jonnala@tessell.com" <Uday.jonnala@tessell.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: multipart/mixed; boundary="===============8109955536152250172=="

--===============8109955536152250172==
Content-Language: en-US
Content-Type: multipart/alternative;
	boundary="_000_BY5PR13MB36015939B775B8841309EC62FC829BY5PR13MB3601namp_"

--_000_BY5PR13MB36015939B775B8841309EC62FC829BY5PR13MB3601namp_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Hi Team,

Looking to see if dm-clone is supported in
5.4.17-2136.308.9.el8uek.x86_64 : Kernel Version (OEL RHEL 8 based)

Which RHEL version has dm-clone checkedin

Thanks & Regards,
Uday Kiran

--_000_BY5PR13MB36015939B775B8841309EC62FC829BY5PR13MB3601namp_
Content-Type: text/html; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

<html xmlns:o=3D"urn:schemas-microsoft-com:office:office" xmlns:w=3D"urn:sc=
hemas-microsoft-com:office:word" xmlns:m=3D"http://schemas.microsoft.com/of=
fice/2004/12/omml" xmlns=3D"http://www.w3.org/TR/REC-html40">
<head>
<meta http-equiv=3D"Content-Type" content=3D"text/html; charset=3Dus-ascii"=
>
<meta name=3D"Generator" content=3D"Microsoft Word 15 (filtered medium)">
<style><!--
/* Font Definitions */
@font-face
=09{font-family:"Cambria Math";
=09panose-1:2 4 5 3 5 4 6 3 2 4;}
@font-face
=09{font-family:Calibri;
=09panose-1:2 15 5 2 2 2 4 3 2 4;}
/* Style Definitions */
p.MsoNormal, li.MsoNormal, div.MsoNormal
=09{margin:0in;
=09font-size:11.0pt;
=09font-family:"Calibri",sans-serif;}
span.EmailStyle17
=09{mso-style-type:personal-compose;
=09font-family:"Calibri",sans-serif;
=09color:windowtext;}
.MsoChpDefault
=09{mso-style-type:export-only;
=09font-family:"Calibri",sans-serif;}
@page WordSection1
=09{size:8.5in 11.0in;
=09margin:1.0in 1.0in 1.0in 1.0in;}
div.WordSection1
=09{page:WordSection1;}
--></style>
</head>
<body lang=3D"EN-US" link=3D"#0563C1" vlink=3D"#954F72" style=3D"word-wrap:=
break-word">
<div class=3D"WordSection1">
<p class=3D"MsoNormal">Hi Team,<o:p></o:p></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal">Looking to see if dm-clone is supported in <o:p></o:=
p></p>
<p class=3D"MsoNormal"><span style=3D"font-size:11.5pt;font-family:&quot;Ar=
ial&quot;,sans-serif;color:#1D1C1D;background:#F8F8F8">5.4.17-2136.308.9.el=
8uek.x86_64 : Kernel Version (OEL RHEL 8 based)</span><o:p></o:p></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal">Which RHEL version has dm-clone checkedin<o:p></o:p>=
</p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal">Thanks &amp; Regards,<o:p></o:p></p>
<p class=3D"MsoNormal">Uday Kiran<o:p></o:p></p>
</div>
</body>
</html>

--_000_BY5PR13MB36015939B775B8841309EC62FC829BY5PR13MB3601namp_--

--===============8109955536152250172==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

--===============8109955536152250172==--

