Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1B47BECAAD5
	for <dm-devel@archiver.kernel.org>; Mon, 12 Sep 2022 13:02:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1662987721;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:in-reply-to:in-reply-to:
	 references:references:list-id:list-help:list-unsubscribe:
	 list-subscribe:list-post; bh=IEQtuKAJgrUuB2jXVhd5zwVWqQcoBnDIn/aVLF/KoEU=;
	b=W36O8tzSE2fRs8Ex2GU09RNUxdr+uPUe/g/zee+yAvheGG16/rOetlrsbDx4waPcBVBBkr
	BXQxvys5UrPjlW+O6ryGQp/AlM944TL3sMZjPL0aG5xn9qM6TBX8AS2kX1mxlIG8r2h6KH
	gAHufJfgWseRGo6Q6xmTLrIvw0nfM0g=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-608-lnFCq-zGPTiMAuZ5KC1EiQ-1; Mon, 12 Sep 2022 09:01:54 -0400
X-MC-Unique: lnFCq-zGPTiMAuZ5KC1EiQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BB8B129ABA22;
	Mon, 12 Sep 2022 13:01:42 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 56236C15BA4;
	Mon, 12 Sep 2022 13:01:42 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 285101946A44;
	Mon, 12 Sep 2022 13:01:42 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 7D11F1946A43
 for <dm-devel@listman.corp.redhat.com>; Mon, 12 Sep 2022 13:01:41 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 5E7532166B29; Mon, 12 Sep 2022 13:01:41 +0000 (UTC)
Received: from [10.40.194.83] (unknown [10.40.194.83])
 by smtp.corp.redhat.com (Postfix) with ESMTP id CBFDF2166B26;
 Mon, 12 Sep 2022 13:01:40 +0000 (UTC)
Message-ID: <c7b61c01-a12a-9ed1-d3d0-f82b765a166f@redhat.com>
Date: Mon, 12 Sep 2022 15:01:40 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.2.1
To: "Pra.. Dew.." <linux_learner@outlook.com>,
 "dm-devel@redhat.com" <dm-devel@redhat.com>
References: <BY5PR14MB3893CAD48C0E0661811682A386429@BY5PR14MB3893.namprd14.prod.outlook.com>
From: Zdenek Kabelac <zkabelac@redhat.com>
In-Reply-To: <BY5PR14MB3893CAD48C0E0661811682A386429@BY5PR14MB3893.namprd14.prod.outlook.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
Subject: Re: [dm-devel] setting up dmverity using device mapper IOCTLs
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: multipart/mixed; boundary="===============4016329441974345248=="

This is a multi-part message in MIME format.
--===============4016329441974345248==
Content-Type: multipart/alternative;
 boundary="------------6DEFkfbeqBauphRiXCKZOnvV"
Content-Language: en-US

This is a multi-part message in MIME format.
--------------6DEFkfbeqBauphRiXCKZOnvV
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Dne 10. 09. 22 v 20:46 Pra.. Dew.. napsal(a):
>
> Hello,
>
> I need to setup dm-verity from my program-basically mount verity enabled 
> filesystems from my code. I have looked at veritysetup and devicemapper 
> (libdm) library. I was wondering if there is some simple C code to use the 
> DM IOCTLs directly to setup verity. Any guidance to directly use the dm 
> IOCTLs or libdm would also be helpful. Thank you for the guidance.
>

Hi

I'd recommend  to exec "dmsetup"  call - as that's by far the simplest 
solution for your problem.

Verity tool should supposedly solve 'compatibility' between various versions 
and various capabilities of driver.

What is the idea behind redevelopment of this tool by your  C code  (as 
clearly you should then do the same thing as verity tool)  ?


Regards


Zdenek

--------------6DEFkfbeqBauphRiXCKZOnvV
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: 8bit

<html>
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
  </head>
  <body>
    <div class="moz-cite-prefix">Dne 10. 09. 22 v 20:46 Pra.. Dew..
      napsal(a):<br>
    </div>
    <blockquote type="cite"
cite="mid:BY5PR14MB3893CAD48C0E0661811682A386429@BY5PR14MB3893.namprd14.prod.outlook.com">
      <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
      <meta name="Generator" content="Microsoft Word 15 (filtered
        medium)">
      <style>@font-face
	{font-family:"Cambria Math";
	panose-1:2 4 5 3 5 4 6 3 2 4;}@font-face
	{font-family:Calibri;
	panose-1:2 15 5 2 2 2 4 3 2 4;}p.MsoNormal, li.MsoNormal, div.MsoNormal
	{margin:0in;
	font-size:11.0pt;
	font-family:"Calibri",sans-serif;}a:link, span.MsoHyperlink
	{mso-style-priority:99;
	color:blue;
	text-decoration:underline;}.MsoChpDefault
	{mso-style-type:export-only;}div.WordSection1
	{page:WordSection1;}</style>
      <div class="WordSection1">
        <p class="MsoNormal">Hello,</p>
        <p class="MsoNormal"><o:p> </o:p></p>
        <p class="MsoNormal">I need to setup dm-verity from my
          program-basically mount verity enabled filesystems from my
          code. I have looked at veritysetup and devicemapper (libdm)
          library. I was wondering if there is some simple C code to use
          the DM IOCTLs directly to setup verity. Any guidance to
          directly use the dm IOCTLs or libdm would also be helpful.
          Thank you for the guidance.</p>
        <p class="MsoNormal"><o:p> </o:p></p>
      </div>
    </blockquote>
    <p><br>
    </p>
    <p>Hi<br>
    </p>
    <p>I'd recommend  to exec "dmsetup"  call - as that's by far the
      simplest solution for your problem.</p>
    <p>Verity tool should supposedly solve 'compatibility' between
      various versions and various capabilities of driver.</p>
    <p>What is the idea behind redevelopment of this tool by your  C
      code  (as clearly you should then do the same thing as verity
      tool)  ?<br>
    </p>
    <p><br>
    </p>
    <p>Regards</p>
    <p><br>
    </p>
    <p>Zdenek<br>
    </p>
  </body>
</html>

--------------6DEFkfbeqBauphRiXCKZOnvV--

--===============4016329441974345248==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

--===============4016329441974345248==--

