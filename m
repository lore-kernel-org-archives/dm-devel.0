Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1B3CFC6FA83
	for <dm-devel@archiver.kernel.org>; Mon, 12 Sep 2022 12:54:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1662987270;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:in-reply-to:in-reply-to:
	 references:references:list-id:list-help:list-unsubscribe:
	 list-subscribe:list-post; bh=QLBfRz16KovEUVQIdo8uHBTVgUyd2OEH48L+bQhx9rk=;
	b=iHdEFEZYdpEwi1wsjcrPVA3CJZuMrwsMUm4AqxEPrxMty6W3v89eEtPB3jrTXsuxcsqI5P
	Ns8ueEoRgiHU/LU7ukuikMs+ymW19mplw8VbjIhWIt0Klgcl3UzrWLosIJ/LmivsBBfHwT
	bk4HFtUea7qVjgtjX4n2V+OrS6IQrT0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-104-RssbgnnWMlqnyXNei29xkw-1; Mon, 12 Sep 2022 08:54:27 -0400
X-MC-Unique: RssbgnnWMlqnyXNei29xkw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EDDBA101E98A;
	Mon, 12 Sep 2022 12:54:25 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 439F417593;
	Mon, 12 Sep 2022 12:54:24 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 1E6201946A44;
	Mon, 12 Sep 2022 12:54:24 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 3262E1946A43
 for <dm-devel@listman.corp.redhat.com>; Mon, 12 Sep 2022 12:54:23 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 1D63D4A9256; Mon, 12 Sep 2022 12:54:23 +0000 (UTC)
Received: from [10.40.194.83] (unknown [10.40.194.83])
 by smtp.corp.redhat.com (Postfix) with ESMTP id 8A15F4A9254;
 Mon, 12 Sep 2022 12:54:22 +0000 (UTC)
Message-ID: <8c979d00-cccb-f1da-b251-67e7f255f2a3@redhat.com>
Date: Mon, 12 Sep 2022 14:54:21 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.2.1
To: "Pra.. Dew.." <linux_learner@outlook.com>,
 "dm-devel@redhat.com" <dm-devel@redhat.com>
References: <BY5PR14MB3893CAD48C0E0661811682A386429@BY5PR14MB3893.namprd14.prod.outlook.com>
 <BY5PR14MB3893D6625238AD41746A53C786449@BY5PR14MB3893.namprd14.prod.outlook.com>
From: Zdenek Kabelac <zkabelac@redhat.com>
In-Reply-To: <BY5PR14MB3893D6625238AD41746A53C786449@BY5PR14MB3893.namprd14.prod.outlook.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
Subject: Re: [dm-devel] Location for the definition of dm_task
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
Content-Language: en-US
Content-Type: multipart/mixed; boundary="===============3294023772671773145=="

This is a multi-part message in MIME format.
--===============3294023772671773145==
Content-Type: multipart/alternative;
 boundary="------------aeT8H060q60Bgb0pSM1NBSq0"
Content-Language: en-US

This is a multi-part message in MIME format.
--------------aeT8H060q60Bgb0pSM1NBSq0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Dne 12. 09. 22 v 7:55 Pra.. Dew.. napsal(a):
>
> I see that in libdevmapper.c 
> <https://gitlab.com/cryptsetup/cryptsetup/-/blob/master/lib/libdevmapper.c#L266> 
> following line is defined
>
> struct||dm_task|*|dmt|;|
>
> ||
>
> |I cannot seem to find out where is dm_task and associated functions are 
> actually defined? I do not see them in the libdevmapper library headers and 
> .c files. Thank you for all the guidance.|
>

Hi


This structure is private to libdevmapper only usage.  Access to struct 
members is provided only via  public functions.

You  can always look at source files  - libdm/ioctl/libdm-targets.h  -  but as 
mentioned earlier - forget about using a copy of this struct in your tools - 
there is only public access - as the structure content may freely change 
between release of libdevmapper - which would have made you binary incompatible.


Regards


Zdenek


--------------aeT8H060q60Bgb0pSM1NBSq0
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: 8bit

<html>
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
  </head>
  <body>
    <div class="moz-cite-prefix">Dne 12. 09. 22 v 7:55 Pra.. Dew..
      napsal(a):<br>
    </div>
    <blockquote type="cite"
cite="mid:BY5PR14MB3893D6625238AD41746A53C786449@BY5PR14MB3893.namprd14.prod.outlook.com">
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
	text-decoration:underline;}code
	{mso-style-priority:99;
	font-family:"Courier New";}span.hljs-keyword
	{mso-style-name:hljs-keyword;}span.hljs-title
	{mso-style-name:hljs-title;}.MsoChpDefault
	{mso-style-type:export-only;}div.WordSection1
	{page:WordSection1;}</style>
      <div class="WordSection1">
        <p class="MsoNormal">I see that in <a
href="https://gitlab.com/cryptsetup/cryptsetup/-/blob/master/lib/libdevmapper.c#L266"
            moz-do-not-send="true">
            libdevmapper.c</a> following line is defined</p>
        <p class="MsoNormal"><o:p> </o:p></p>
        <p class="MsoNormal"><span class="hljs-keyword">struct</span><code><span
              style="font-size:10.0pt">
            </span></code><span class="hljs-title"><span
              style="font-size:10.0pt;font-family:&quot;Courier
              New&quot;">dm_task</span></span><code><span
              style="font-size:10.0pt"> *</span></code><span
            class="hljs-title"><span
              style="font-size:10.0pt;font-family:&quot;Courier
              New&quot;">dmt</span></span><code><span
              style="font-size:10.0pt">;<o:p></o:p></span></code></p>
        <p class="MsoNormal"><code><span style="font-size:10.0pt"><o:p> </o:p></span></code></p>
        <p class="MsoNormal"><code><span style="font-size:10.0pt">I
              cannot seem to find out where is dm_task and associated
              functions are actually defined? I do not see them in the
              libdevmapper library headers and .c files. Thank you for
              all the guidance.</span></code></p>
        <p class="MsoNormal"><o:p> </o:p></p>
      </div>
    </blockquote>
    <br>
    <p>Hi</p>
    <p><br>
    </p>
    <p>This structure is private to libdevmapper only usage.  Access to 
      struct members is provided only via  public functions.</p>
    <p>You  can always look at source files  -
      libdm/ioctl/libdm-targets.h  -  but as mentioned earlier - forget
      about using a copy of this struct in your tools - there is only
      public access - as the structure content may freely change between
      release of libdevmapper - which would have made you binary
      incompatible.</p>
    <p><br>
    </p>
    <p>Regards</p>
    <p><br>
    </p>
    <p>Zdenek</p>
    <p><br>
    </p>
  </body>
</html>

--------------aeT8H060q60Bgb0pSM1NBSq0--

--===============3294023772671773145==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

--===============3294023772671773145==--

