Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 203A8C433EF
	for <dm-devel@archiver.kernel.org>; Fri,  8 Jul 2022 16:31:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1657297893;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:in-reply-to:in-reply-to:
	 references:references:list-id:list-help:list-unsubscribe:
	 list-subscribe:list-post; bh=/lUo21u8baPK3LQXufBMjf/VXjaEw0+596sR78vIC8M=;
	b=VAwVkf+i3nNi5dRAH+PuPUJ7csjqMfR7FEy2rHuLDp679gUTCPbGaoNvUUC8ilhpjVyYVR
	hnQq39z0oNLoUE4/NDTxhKW/vK3ftcRkIZ4+guYfnCEPb3Tml7Fm7Bpljvl8MDpZWelDJZ
	VfRb61w65ouFAYAJl40oEjWOhzjHGYY=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-166-0pp8DUwcPmSka34KJ6_osA-1; Fri, 08 Jul 2022 12:31:25 -0400
X-MC-Unique: 0pp8DUwcPmSka34KJ6_osA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2695938173C5;
	Fri,  8 Jul 2022 16:31:24 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 68B65C15D40;
	Fri,  8 Jul 2022 16:31:19 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 14514194706D;
	Fri,  8 Jul 2022 16:31:19 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 0834C194706C
 for <dm-devel@listman.corp.redhat.com>; Fri,  8 Jul 2022 16:31:17 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id DAD8A18EB5; Fri,  8 Jul 2022 16:31:16 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id D6D6418EAA
 for <dm-devel@redhat.com>; Fri,  8 Jul 2022 16:31:16 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BAC3F85A583
 for <dm-devel@redhat.com>; Fri,  8 Jul 2022 16:31:16 +0000 (UTC)
Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com
 [209.85.216.42]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-175-aY4SFlyvPTaaP7tWR4kq9w-1; Fri, 08 Jul 2022 12:31:14 -0400
X-MC-Unique: aY4SFlyvPTaaP7tWR4kq9w-1
Received: by mail-pj1-f42.google.com with SMTP id fz10so12358294pjb.2
 for <dm-devel@redhat.com>; Fri, 08 Jul 2022 09:31:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:from:to:cc:subject:thread-topic:thread-index
 :date:message-id:references:in-reply-to:accept-language
 :content-language:mime-version;
 bh=Six8p0CcxUUf9RojpBbz3D91dl8imNLqXEevFlz0LiA=;
 b=qBQQKZEnukb1rCAl9D9soVrU2rqQja5FpQfrG+Bjt/a6BqXFQeNZdToXwED3AI4oIZ
 3Y3cfZf2UtNI2j4P0B1OgN+QnC/pvWrsg2+/T9wREqwchd1p6bj00q3BYZHVyFZrmJbJ
 eYu3Mxk4F5CSDqCMnIOOkZwj5DDkIc/bqRN+N4g0UG/H+zTrHXdn9zp2zJm9WB9CLKIx
 O5R4qJreMxZ6OqrsZ6MmkQIBjwffx8ZUHAwOxi+zBkEWXcVlDtUH90B05TmcsrkfZcHm
 84gEKbSthTUglqyAWPhqNvoeTvPbb4KnDv8ma7ixftuCxMGpdPc5imy+7In6KJPWrZ3o
 Faww==
X-Gm-Message-State: AJIora8ALRNAef5GZjm51GRiB/Sg/p+8BVdIcTDZwR7b3lDlDSv4rsq7
 6VEAi20Bc09vrLsqj2B8dHvCmUuRBNFRCQ==
X-Google-Smtp-Source: AGRyM1ufzM3AnvqHAqMffWZlLB/CKPxM1HhzYrIgSWWsNQwxXcnyPs0OfWk6aA6YWAJMrMRgEGpEng==
X-Received: by 2002:a17:903:124f:b0:16b:8167:e34e with SMTP id
 u15-20020a170903124f00b0016b8167e34emr4497999plh.52.1657297873343; 
 Fri, 08 Jul 2022 09:31:13 -0700 (PDT)
Received: from BY5PR13MB3601.namprd13.prod.outlook.com
 ([2603:1036:307:4014::5]) by smtp.gmail.com with ESMTPSA id
 c3-20020a17090a020300b001ef7e5f2a82sm1844449pjc.25.2022.07.08.09.31.07
 (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
 Fri, 08 Jul 2022 09:31:10 -0700 (PDT)
From: Uday Jonnala <uday.jonnala@tessell.com>
To: Roger Heflin <rogerheflin@gmail.com>
Thread-Topic: [dm-devel] Regarding dm-clone on RHEL+OEL
Thread-Index: AQHYktfy1uF2kMqoDESHDLUViY7es610jvEAgAAauFs=
X-MS-Exchange-MessageSentRepresentingType: 1
Date: Fri, 8 Jul 2022 16:31:06 +0000
Message-ID: <BY5PR13MB3601B9E57CFFDC4597A22CDEFC829@BY5PR13MB3601.namprd13.prod.outlook.com>
References: <BY5PR13MB3601CBD8C5B444A014F19012FC829@BY5PR13MB3601.namprd13.prod.outlook.com>
 <CAAMCDecFg6iDEETdojjWkgSAio2hCDBsH3N=hfoLkg3a=8tc3w@mail.gmail.com>
In-Reply-To: <CAAMCDecFg6iDEETdojjWkgSAio2hCDBsH3N=hfoLkg3a=8tc3w@mail.gmail.com>
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
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
Subject: Re: [dm-devel] Regarding dm-clone on RHEL+OEL
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
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: multipart/mixed; boundary="===============7892502750588093221=="

--===============7892502750588093221==
Content-Language: en-US
Content-Type: multipart/alternative;
	boundary="_000_BY5PR13MB3601B9E57CFFDC4597A22CDEFC829BY5PR13MB3601namp_"

--_000_BY5PR13MB3601B9E57CFFDC4597A22CDEFC829BY5PR13MB3601namp_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Hi Roger,

Yes, seems like it is not supported on my box

grep -i clone /boot/config-5.4.17-2011.7.4.el8uek.x86_64
# CONFIG_DM_CLONE is not set

Seems like this is not supported.

Thanks & Regards,
Uday Kiran

From: Roger Heflin <rogerheflin@gmail.com>
Date: Friday, July 8, 2022 at 7:52 AM
To: Uday Jonnala <uday.jonnala@tessell.com>
Cc: dm-devel@redhat.com <dm-devel@redhat.com>
Subject: Re: [dm-devel] Regarding dm-clone on RHEL+OEL
You probably have to inquire with the vendor support who supplied the
kernel, but checking on a UEK kernel I have of that major version I
see this (mine is el7 not el8, but I suspect the both UEK kernels are
basically identical).

grep -i clone /boot/config-5.4.17-2102.203.6.el7uek.x86_64
# CONFIG_DM_CLONE is not set

So it was not configured/compiled into my kernel and likely not yours.

And dm-clone appears to have initially been added in 5.4 from what I
can tell so I have zero clue how stable/functional it was in that
version even if it was enabled.

On Fri, Jul 8, 2022 at 9:38 AM Uday Jonnala <uday.jonnala@tessell.com> wrot=
e:
>
> Hi Team,
>
>
>
> Looking to see if dm-clone is supported in RHEL based OEL (Oracle Enterpr=
ise Licence)
>
> 5.4.17-2136.308.9.el8uek.x86_64 : Kernel Version (OEL RHEL 8 based)
>
>
>
> Which RHEL version has dm-clone checkedin ?
>
> We are getting following error on clone
>
> device-mapper: reload ioctl on clone (252:3) failed: Invalid argument
>
>
>
> Thanks & Regards,
>
> Uday Kiran
>
>
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://listman.redhat.com/mailman/listinfo/dm-devel

--_000_BY5PR13MB3601B9E57CFFDC4597A22CDEFC829BY5PR13MB3601namp_
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
=09font-size:10.0pt;
=09font-family:"Calibri",sans-serif;}
a:link, span.MsoHyperlink
=09{mso-style-priority:99;
=09color:blue;
=09text-decoration:underline;}
span.EmailStyle19
=09{mso-style-type:personal-reply;
=09font-family:"Calibri",sans-serif;
=09color:windowtext;}
.MsoChpDefault
=09{mso-style-type:export-only;
=09font-size:10.0pt;}
@page WordSection1
=09{size:8.5in 11.0in;
=09margin:1.0in 1.0in 1.0in 1.0in;}
div.WordSection1
=09{page:WordSection1;}
--></style>
</head>
<body lang=3D"EN-US" link=3D"blue" vlink=3D"purple" style=3D"word-wrap:brea=
k-word">
<div class=3D"WordSection1">
<p class=3D"MsoNormal"><span style=3D"font-size:11.0pt">Hi Roger,<br>
<br>
Yes, seems like it is not supported on my box<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:11.0pt"><o:p>&nbsp;</o:p></=
span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:11.5pt;font-family:&quot;Ar=
ial&quot;,sans-serif;color:#1D1C1D;background:#F8F8F8">grep -i clone /boot/=
config-5.4.17-2011.7.4.el8uek.x86_64</span><span style=3D"font-size:11.5pt;=
font-family:&quot;Arial&quot;,sans-serif;color:#1D1C1D"><br>
<span style=3D"background:#F8F8F8"># CONFIG_DM_CLONE is not set</span></spa=
n><span style=3D"font-size:11.0pt"><o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:11.0pt"><o:p>&nbsp;</o:p></=
span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:11.0pt">Seems like this is =
not supported.<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:11.0pt"><o:p>&nbsp;</o:p></=
span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:11.0pt">Thanks &amp; Regard=
s,<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:11.0pt">Uday Kiran<o:p></o:=
p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:11.0pt"><o:p>&nbsp;</o:p></=
span></p>
<div style=3D"border:none;border-top:solid #B5C4DF 1.0pt;padding:3.0pt 0in =
0in 0in">
<p class=3D"MsoNormal" style=3D"margin-bottom:12.0pt"><b><span style=3D"fon=
t-size:12.0pt;color:black">From:
</span></b><span style=3D"font-size:12.0pt;color:black">Roger Heflin &lt;ro=
gerheflin@gmail.com&gt;<br>
<b>Date: </b>Friday, July 8, 2022 at 7:52 AM<br>
<b>To: </b>Uday Jonnala &lt;uday.jonnala@tessell.com&gt;<br>
<b>Cc: </b>dm-devel@redhat.com &lt;dm-devel@redhat.com&gt;<br>
<b>Subject: </b>Re: [dm-devel] Regarding dm-clone on RHEL+OEL<o:p></o:p></s=
pan></p>
</div>
<div>
<p class=3D"MsoNormal"><span style=3D"font-size:11.0pt">You probably have t=
o inquire with the vendor support who supplied the<br>
kernel, but checking on a UEK kernel I have of that major version I<br>
see this (mine is el7 not el8, but I suspect the both UEK kernels are<br>
basically identical).<br>
<br>
grep -i clone /boot/config-5.4.17-2102.203.6.el7uek.x86_64<br>
# CONFIG_DM_CLONE is not set<br>
<br>
So it was not configured/compiled into my kernel and likely not yours.<br>
<br>
And dm-clone appears to have initially been added in 5.4 from what I<br>
can tell so I have zero clue how stable/functional it was in that<br>
version even if it was enabled.<br>
<br>
On Fri, Jul 8, 2022 at 9:38 AM Uday Jonnala &lt;uday.jonnala@tessell.com&gt=
; wrote:<br>
&gt;<br>
&gt; Hi Team,<br>
&gt;<br>
&gt;<br>
&gt;<br>
&gt; Looking to see if dm-clone is supported in RHEL based OEL (Oracle Ente=
rprise Licence)<br>
&gt;<br>
&gt; 5.4.17-2136.308.9.el8uek.x86_64 : Kernel Version (OEL RHEL 8 based)<br=
>
&gt;<br>
&gt;<br>
&gt;<br>
&gt; Which RHEL version has dm-clone checkedin ?<br>
&gt;<br>
&gt; We are getting following error on clone<br>
&gt;<br>
&gt; device-mapper: reload ioctl on clone (252:3) failed: Invalid argument<=
br>
&gt;<br>
&gt;<br>
&gt;<br>
&gt; Thanks &amp; Regards,<br>
&gt;<br>
&gt; Uday Kiran<br>
&gt;<br>
&gt;<br>
&gt;<br>
&gt; --<br>
&gt; dm-devel mailing list<br>
&gt; dm-devel@redhat.com<br>
&gt; <a href=3D"https://listman.redhat.com/mailman/listinfo/dm-devel">https=
://listman.redhat.com/mailman/listinfo/dm-devel</a><o:p></o:p></span></p>
</div>
</div>
</body>
</html>

--_000_BY5PR13MB3601B9E57CFFDC4597A22CDEFC829BY5PR13MB3601namp_--

--===============7892502750588093221==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

--===============7892502750588093221==--

