Return-Path: <SRS0=7So8=MQ=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,HTML_MESSAGE,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8619C4338F
	for <dm-devel@archiver.kernel.org>; Sat, 24 Jul 2021 06:57:27 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 000CD60E9C
	for <dm-devel@archiver.kernel.org>; Sat, 24 Jul 2021 06:57:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 000CD60E9C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-587-1rtn_2UYO6OzP1S9Kj-OBw-1; Sat, 24 Jul 2021 02:57:23 -0400
X-MC-Unique: 1rtn_2UYO6OzP1S9Kj-OBw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1E2B161A;
	Sat, 24 Jul 2021 06:57:19 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 8E03569320;
	Sat, 24 Jul 2021 06:57:18 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id F2C75180B7A2;
	Sat, 24 Jul 2021 06:57:16 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 16O6vF8Q010977 for <dm-devel@listman.util.phx.redhat.com>;
	Sat, 24 Jul 2021 02:57:15 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 76FA82062A97; Sat, 24 Jul 2021 06:57:15 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 72572205B131
	for <dm-devel@redhat.com>; Sat, 24 Jul 2021 06:57:13 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DC609802A64
	for <dm-devel@redhat.com>; Sat, 24 Jul 2021 06:57:12 +0000 (UTC)
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182]) by
	relay.mimecast.com with ESMTP id us-mta-558-ak7sQ097PpS_Yl22fEifUw-1;
	Sat, 24 Jul 2021 02:57:09 -0400
X-MC-Unique: ak7sQ097PpS_Yl22fEifUw-1
Received: from [192.168.86.34] (c-71-197-163-6.hsd1.wa.comcast.net
	[71.197.163.6])
	by linux.microsoft.com (Postfix) with ESMTPSA id 63EF320B7178;
	Fri, 23 Jul 2021 23:57:08 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 63EF320B7178
To: Mike Snitzer <snitzer@redhat.com>
References: <20210713004904.8808-1-tusharsu@linux.microsoft.com>
	<YPc/vON2qvwjfvTe@redhat.com>
From: Tushar Sugandhi <tusharsu@linux.microsoft.com>
Message-ID: <ec75882e-c940-adab-43f0-412e5c266185@linux.microsoft.com>
Date: Fri, 23 Jul 2021 23:57:07 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
	Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <YPc/vON2qvwjfvTe@redhat.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-loop: dm-devel@redhat.com
Cc: linux-integrity@vger.kernel.org, dm-devel@redhat.com, zohar@linux.ibm.com,
	agk@redhat.com, nramas@linux.microsoft.com
Subject: Re: [dm-devel] [PATCH 0/7] device mapper target measurements using
	IMA
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: multipart/mixed; boundary="===============0871787465377197552=="

This is a multi-part message in MIME format.
--===============0871787465377197552==
Content-Type: multipart/alternative;
	boundary="------------60EB8E05BDC8F64F00CD9D15"
Content-Language: en-US

This is a multi-part message in MIME format.
--------------60EB8E05BDC8F64F00CD9D15
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable

Hi Mike,

On 7/20/21 2:27 PM, Mike Snitzer wrote:
> On Mon, Jul 12 2021 at  8:48P -0400,
> Tushar Sugandhi <tusharsu@linux.microsoft.com> wrote:
>
>> For a given system, various external services/infrastructure tools
>> (including the attestation service) interact with it - both during the
>> setup and during rest of the system run-time.  They share sensitive data
>> and/or execute critical workload on that system.  The external services
>> may want to verify the current run-time state of the relevant kernel
>> subsystems before fully trusting the system with business-critical
>> data/workload.
>>
>> Device mapper is one such kernel subsystem that plays a critical role on
>> a given system by providing various important functionalities to the
>> block devices with various target types like crypt, verity, integrity
>> etc.  Each of these target types=E2=80=99 functionalities can be configu=
red with
>> various attributes.  The attributes chosen to configure these target typ=
es
>> can significantly impact the security profile of the block device,
>> and in-turn, of the system itself.  For instance, the type of encryption
>> algorithm and the key size determines the strength of encryption for a
>> given block device.
>>
>> Therefore, verifying the current state of various block devices as well
>> as their various target attributes is crucial for external services
>> before fully trusting the system with business-critical data/workload.
>>
>> IMA provides the necessary functionality for device mapper to measure th=
e
>> state and configuration of various block devices -
>>    - BY device mapper itself, from within the kernel,
>>    - in a tamper resistant way,
>>    - and re-measured - triggered on state/configuration change.
>>
>> This patch series uses this IMA functionality, by calling the function
>> ima_measure_critical_data(), when a block device state is changed (e.g.
>> on device create, resume, rename, remove etc.)  It measures the device
>> state and configuration and stores it in IMA logs, so that it can be
>> used by external services for managing the system.
> I needed to EXPORT_SYMBOL_GPL(ima_measure_critical_data); otherwise I
> couldn't compile.. not sure but I can only imagine you compile DM
> (and all targets) to be builtin?

I believe the EXPORT_SYMBOL_GPL(ima_measure_critical_data) is now needed=20
because of the move =E2=80=9C#ifdef CONFIG_IMA from dm-ima.c to dm-ima.h=E2=
=80=9D, and=20
the associated change in the Makefile
+ifeq ($(CONFIG_IMA),y)
dm-mod-objs +=3D dm-ima.o
+endif
Earlier I needed to export symbol only if I was calling=20
ima_measure_critical_data() directly from various dm-*.c files.
With my earlier implementation, it wasn=E2=80=99t needed when it was called=
 from=20
the wrapper dm_ima_measure_data() in dm-ima.c.

> In addition to fixing that (in first table load patch) I changed
> various things along the way while I reviewed each patch.

Thank you so much for making the necessary changes Mike. Really=20
appreciate it.

> Things that I recall are:
> - moved #ifdef CONFIG_IMA from dm-ima.c to dm-ima.h
> - fixed various typos and whitespace
> - consistently prepend "," in STATUSTYPE_IMA's DMEMIT()s as opposed to
>    having a mix or pre and postfix throughout targets
> - fixed what seemed like malformed STATUSTYPE_IMA handling for
>    dm-multipath -- it was DMEMIT(";") for each dm-mpath's pathgroup
> - added some fields to dm-mpath, renamed some IMA names in name=3Dvalue
>    pairs to be more clear.

I went through the changes you made. They look fine. In addition to the=20
above changes, you also fixed a warning in dm-raid.c. (initializing the=20
recovery variable)
Thanks again. :)

> I've staged the result in linux-next via linux-dm.git's dm-5.15
> branch, see:
> https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.gi=
t/log/?h=3Ddm-5.15
>
> I've compiled tested both with and without CONFIG_IMA set.  But
> haven't actually tested the code.

No worries. I will test the changesthoroughly again.

> Please send any incremental fixes relative to the dm-5.15 branch and
> I'll get them folded in where appropriate.

Ok. I will send incremental patches against dm-5.15 as you've suggested.=20
Thanks again for the review and all the help so far. Really appreciate=20
it. ~Tushar

> Thanks,
> Mike

--------------60EB8E05BDC8F64F00CD9D15
Content-Type: text/html; charset=utf-8
Content-Transfer-Encoding: quoted-printable

<html>
  <head>
    <meta http-equiv=3D"Content-Type" content=3D"text/html; charset=3DUTF-8=
">
  </head>
  <body>
    <p>Hi Mike,<br>
    </p>
    <div class=3D"moz-cite-prefix">On 7/20/21 2:27 PM, Mike Snitzer wrote:<=
br>
    </div>
    <blockquote type=3D"cite" cite=3D"mid:YPc%2FvON2qvwjfvTe@redhat.com">
      <pre class=3D"moz-quote-pre" wrap=3D"">On Mon, Jul 12 2021 at  8:48P =
-0400,
Tushar Sugandhi <a class=3D"moz-txt-link-rfc2396E" href=3D"mailto:tusharsu@=
linux.microsoft.com">&lt;tusharsu@linux.microsoft.com&gt;</a> wrote:

</pre>
      <blockquote type=3D"cite">
        <pre class=3D"moz-quote-pre" wrap=3D"">For a given system, various =
external services/infrastructure tools
(including the attestation service) interact with it - both during the
setup and during rest of the system run-time.  They share sensitive data
and/or execute critical workload on that system.  The external services
may want to verify the current run-time state of the relevant kernel
subsystems before fully trusting the system with business-critical
data/workload.

Device mapper is one such kernel subsystem that plays a critical role on
a given system by providing various important functionalities to the
block devices with various target types like crypt, verity, integrity=20
etc.  Each of these target types=E2=80=99 functionalities can be configured=
 with
various attributes.  The attributes chosen to configure these target types
can significantly impact the security profile of the block device,
and in-turn, of the system itself.  For instance, the type of encryption
algorithm and the key size determines the strength of encryption for a
given block device.

Therefore, verifying the current state of various block devices as well
as their various target attributes is crucial for external services
before fully trusting the system with business-critical data/workload.

IMA provides the necessary functionality for device mapper to measure the
state and configuration of various block devices -
  - BY device mapper itself, from within the kernel,
  - in a tamper resistant way,
  - and re-measured - triggered on state/configuration change.

This patch series uses this IMA functionality, by calling the function
ima_measure_critical_data(), when a block device state is changed (e.g.
on device create, resume, rename, remove etc.)  It measures the device
state and configuration and stores it in IMA logs, so that it can be
used by external services for managing the system.
</pre>
      </blockquote>
      <pre class=3D"moz-quote-pre" wrap=3D"">
I needed to EXPORT_SYMBOL_GPL(ima_measure_critical_data); otherwise I
couldn't compile.. not sure but I can only imagine you compile DM
(and all targets) to be builtin?
</pre>
    </blockquote>
    <pre class=3D"western"><font color=3D"#000000">I believe the  EXPORT_SY=
MBOL_GPL(ima_measure_critical_data) is
now needed because of the move =E2=80=9C#ifdef CONFIG_IMA from dm-ima.c
to dm-ima.h=E2=80=9D, and the associated change in the Makefile </font>
<font color=3D"#000000">
+ifeq ($(CONFIG_IMA),y)</font>
<font color=3D"#000000">dm-mod-objs +=3D dm-ima.o</font>
<font color=3D"#000000">+endif</font>
<font color=3D"#000000">
Earlier I needed to export symbol </font><font color=3D"#000000"><font colo=
r=3D"#000000">only </font>if I was calling
ima_measure_critical_data() directly from various
dm-*.c files. </font>
<font color=3D"#000000">With my earlier implementation, </font><font color=
=3D"#000000"><font face=3D"Liberation Mono, monospace"><font style=3D"font-=
size: 10pt" size=3D"2">i</font></font></font><font color=3D"#000000">t wasn=
=E2=80=99t needed when it
was called from the wrapper dm_ima_measure_data() in dm-ima.c.</font></pre>
    <style type=3D"text/css">pre { background: transparent }pre.western { f=
ont-family: "Liberation Mono", monospace; font-size: 10pt }pre.cjk { font-f=
amily: "Noto Sans Mono CJK SC", monospace; font-size: 10pt }pre.ctl { font-=
family: "Liberation Mono", monospace; font-size: 10pt }p { margin-bottom: 0=
.1in; line-height: 115%; background: transparent }a:link { color: #000080; =
so-language: zxx; text-decoration: underline }</style>
    <blockquote type=3D"cite" cite=3D"mid:YPc%2FvON2qvwjfvTe@redhat.com">
      <pre class=3D"moz-quote-pre" wrap=3D"">
In addition to fixing that (in first table load patch) I changed
various things along the way while I reviewed each patch.
</pre>
    </blockquote>
    <pre class=3D"western"><font color=3D"#000000">Thank you so much for ma=
king the necessary changes Mike.
Really appreciate it.</font></pre>
    <style type=3D"text/css">pre { background: transparent }pre.western { f=
ont-family: "Liberation Mono", monospace; font-size: 10pt }pre.cjk { font-f=
amily: "Noto Sans Mono CJK SC", monospace; font-size: 10pt }pre.ctl { font-=
family: "Liberation Mono", monospace; font-size: 10pt }p { margin-bottom: 0=
.1in; line-height: 115%; background: transparent }a:link { color: #000080; =
so-language: zxx; text-decoration: underline }</style>
    <blockquote type=3D"cite" cite=3D"mid:YPc%2FvON2qvwjfvTe@redhat.com">
      <pre class=3D"moz-quote-pre" wrap=3D"">
Things that I recall are:
- moved #ifdef CONFIG_IMA from dm-ima.c to dm-ima.h
- fixed various typos and whitespace
- consistently prepend "," in STATUSTYPE_IMA's DMEMIT()s as opposed to
  having a mix or pre and postfix throughout targets
- fixed what seemed like malformed STATUSTYPE_IMA handling for
  dm-multipath -- it was DMEMIT(";") for each dm-mpath's pathgroup
- added some fields to dm-mpath, renamed some IMA names in name=3Dvalue
  pairs to be more clear.
</pre>
    </blockquote>
    <pre class=3D"western"><font color=3D"#000000">I went through the chang=
es you made. They look fine.
In addition to the above changes, you also fixed a warning in
dm-raid.c. (initializing the recovery variable) </font>
<font color=3D"#000000">Thanks again. :)</font></pre>
    <style type=3D"text/css">pre { background: transparent }pre.western { f=
ont-family: "Liberation Mono", monospace; font-size: 10pt }pre.cjk { font-f=
amily: "Noto Sans Mono CJK SC", monospace; font-size: 10pt }pre.ctl { font-=
family: "Liberation Mono", monospace; font-size: 10pt }p { margin-bottom: 0=
.1in; line-height: 115%; background: transparent }a:link { color: #000080; =
so-language: zxx; text-decoration: underline }</style>
    <blockquote type=3D"cite" cite=3D"mid:YPc%2FvON2qvwjfvTe@redhat.com">
      <pre class=3D"moz-quote-pre" wrap=3D"">
I've staged the result in linux-next via linux-dm.git's dm-5.15
branch, see:
<a class=3D"moz-txt-link-freetext" href=3D"https://git.kernel.org/pub/scm/l=
inux/kernel/git/device-mapper/linux-dm.git/log/?h=3Ddm-5.15">https://git.ke=
rnel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git/log/?h=3Ddm-5.=
15</a>

I've compiled tested both with and without CONFIG_IMA set.  But
haven't actually tested the code.
</pre>
    </blockquote>
    <pre class=3D"western"><font color=3D"#000000">No worries. I will test =
</font><font color=3D"#000000"><font face=3D"Liberation Mono, monospace"><f=
ont style=3D"font-size: 10pt" size=3D"2">the changes</font></font></font><f=
ont color=3D"#000000"> thoroughly again.</font></pre>
    <style type=3D"text/css">pre { background: transparent }pre.western { f=
ont-family: "Liberation Mono", monospace; font-size: 10pt }pre.cjk { font-f=
amily: "Noto Sans Mono CJK SC", monospace; font-size: 10pt }pre.ctl { font-=
family: "Liberation Mono", monospace; font-size: 10pt }p { margin-bottom: 0=
.1in; line-height: 115%; background: transparent }a:link { color: #000080; =
so-language: zxx; text-decoration: underline }</style>
    <blockquote type=3D"cite" cite=3D"mid:YPc%2FvON2qvwjfvTe@redhat.com">
      <pre class=3D"moz-quote-pre" wrap=3D"">
Please send any incremental fixes relative to the dm-5.15 branch and
I'll get them folded in where appropriate.
</pre>
    </blockquote>
    <pre class=3D"western" style=3D"margin-bottom: 0.2in"><font color=3D"#0=
00000">Ok. I will send incremental patches against dm-5.15 as you've sugges=
ted.
Thanks again for the review and all the help so far.
Really appreciate it.

~Tushar
</font></pre>
    <style type=3D"text/css">pre { background: transparent }pre.western { f=
ont-family: "Liberation Mono", monospace; font-size: 10pt }pre.cjk { font-f=
amily: "Noto Sans Mono CJK SC", monospace; font-size: 10pt }pre.ctl { font-=
family: "Liberation Mono", monospace; font-size: 10pt }p { margin-bottom: 0=
.1in; line-height: 115%; background: transparent }a:link { color: #000080; =
so-language: zxx; text-decoration: underline }</style>
    <blockquote type=3D"cite" cite=3D"mid:YPc%2FvON2qvwjfvTe@redhat.com">
      <pre class=3D"moz-quote-pre" wrap=3D"">
Thanks,
Mike
</pre>
    </blockquote>
  </body>
</html>

--------------60EB8E05BDC8F64F00CD9D15--

--===============0871787465377197552==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel
--===============0871787465377197552==--

