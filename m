Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 989B0C433EF
	for <dm-devel@archiver.kernel.org>; Thu, 24 Mar 2022 15:35:04 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-470-nrXqUDFYP36dFq0iMp-PnQ-1; Thu, 24 Mar 2022 11:34:55 -0400
X-MC-Unique: nrXqUDFYP36dFq0iMp-PnQ-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 560DC1066569;
	Thu, 24 Mar 2022 15:34:51 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 44080417E3A;
	Thu, 24 Mar 2022 15:34:51 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id D8374193F6E0;
	Thu, 24 Mar 2022 15:34:49 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 611661940347
 for <dm-devel@listman.corp.redhat.com>; Thu, 24 Mar 2022 05:01:58 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 401314021C0; Thu, 24 Mar 2022 05:01:58 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 3C3544021D9
 for <dm-devel@redhat.com>; Thu, 24 Mar 2022 05:01:58 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 23897811E76
 for <dm-devel@redhat.com>; Thu, 24 Mar 2022 05:01:58 +0000 (UTC)
Received: from mail-lj1-f175.google.com (mail-lj1-f175.google.com
 [209.85.208.175]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-198-rLyXNoyLNfmOvl-aTfcG8Q-1; Thu, 24 Mar 2022 01:01:54 -0400
X-MC-Unique: rLyXNoyLNfmOvl-aTfcG8Q-1
Received: by mail-lj1-f175.google.com with SMTP id b43so97057ljr.10;
 Wed, 23 Mar 2022 22:01:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=1bQgTuS7LJpZ0VQTtbmoe4h60a+jA37qoukGvL5tGj8=;
 b=7uWICrwk3ryHnYoeAF9YNlqnC8AKdW4poSh8UYCb/jVkgMltH00BK5off4sKyU8N5j
 6EiChvn/tL0/Of3/EK2BWZ/ub/a63R1c6f9KMdv557zOLUa1xGxZf1hJhAcq9QWfiP3A
 ontQPwSfN59AceXcVQgR67fbpSc8jiFR+K9G43Eqc9CtJuBorwAKpkAdUKLf0aree7uy
 6WgXDq3IYrT1glREKx0uaHS2aHa4A7PuT6KaZDIm+aJHusD5V0+tdLzcj7xiQ9Xhztkh
 26Glt5qpcxvjrQ6QYqWcA1rawXG6XiUvDYXxWqxNFQP5MMTGnlxnPRPyKRek8VeagGqe
 qi5Q==
X-Gm-Message-State: AOAM53186DILC9ErYoLMXC9v+hSj3soKrmSwa8lsiXa5yU3F2QHAyV5k
 68lGoJDp349ySOYn1oAgEDTg052bYqCUg2JQcu0uN8Q=
X-Google-Smtp-Source: ABdhPJzYULWm9eAxp56RN11n5aHFdnRoEaipCk9TixJpy7SGAFVwQdMHWZPLTy+ZY/J/bBxtfclZgp5JWlT8PpgHNrs=
X-Received: by 2002:a2e:99c8:0:b0:249:9231:93e6 with SMTP id
 l8-20020a2e99c8000000b00249923193e6mr2672215ljj.40.1648098111873; Wed, 23 Mar
 2022 22:01:51 -0700 (PDT)
MIME-Version: 1.0
References: <CAEgic_HjomW1WbB+XFzN2t_kJJr=-2P-zrNi2p0EqqMo2pc2Lg@mail.gmail.com>
 <20220323222447.GK24684@octiron.msp.redhat.com>
In-Reply-To: <20220323222447.GK24684@octiron.msp.redhat.com>
From: boli sudha <bolisudha@gmail.com>
Date: Thu, 24 Mar 2022 10:31:02 +0530
Message-ID: <CAEgic_HUK+1dFSoA-KM0Hn-n8OwQhe43G8+f9kCEpUWt5i+MBQ@mail.gmail.com>
To: Benjamin Marzinski <bmarzins@redhat.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
X-Mailman-Approved-At: Thu, 24 Mar 2022 15:34:43 +0000
Subject: Re: [dm-devel] libmpathpersist: Getting undefined symbol during
 compilation
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
Cc: dm-devel@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/mixed; boundary="===============3001934001123067837=="

--===============3001934001123067837==
Content-Type: multipart/alternative; boundary="0000000000008364eb05daefbeaa"

--0000000000008364eb05daefbeaa
Content-Type: text/plain; charset="UTF-8"

Thanks Benjamin,

Thanks for your reply. After I posted this question, I went through the
source code and figured out that these functions are defined as weak. So
they are not getting added to the library and binaries which are using them
are re-defining these definitions.

I will try the suggestions as per below. But as a work around, we tried to
use the RedHat 7 version of RPM to see if it works and it worked.

Anyhow, I will definitely try the suggestion and get back to you.

Thanks once again,
Sudhakar.

On Thu, Mar 24, 2022 at 3:54 AM Benjamin Marzinski <bmarzins@redhat.com>
wrote:

> On Sat, Mar 19, 2022 at 08:57:08PM +0530, boli sudha wrote:
> > Hi,
> >
> > I found this mail Id on the Git page, I never used libmpathpersist or
> > libmulitpath.
> > One of our applications is using these libraries. Compilation was working
> > fine on RedHat 7. I am trying to port our application to Redhat 8. During
> > linking I am getting the following error. Can you please help me?
> >
> > /usr/lib64/libmpathpersist.so: undefined reference to
> `put_multipath_config'
> > /usr/lib64/libmpathpersist.so: undefined reference to
> `get_multipath_config'
> > /usr/lib64/libmultipath.so: undefined reference to `udev'
> > collect2: error: ld returned 1 exit status
> >
> > These symbols were not present in the RedHat 7 version of libraries.
> >
> > On RedHat 8, these symbols were undefined, I downloaded the git code,
> > compiled, and observed that these symbols are defined in binaries, not
> > libraries.
> >
> > I also tried to remove these libraries from linker command, but so many
> > symbols are missing.
>
> Using libmpathpersist is kind of tricky. Later version of
> device-mapper-multipath clean this up. But for the version in RHEL-8,
> your binary needs to specify some things to work with libmpathpersist.
>
> If your program is single threaded, then you should add something like
> (pulled from mpathpersist/main.c):
>
> ======================
> int logsink = 0;                /* or -1 */
> struct config *multipath_conf;
>
> struct config *get_multipath_config(void)
> {
>         return multipath_conf;
> }
>
> void put_multipath_config(__attribute__((unused)) void * arg)
> {
>         /* Noop for now */
> }
>
> void rcu_register_thread_memb(void) {}
>
> void rcu_unregister_thread_memb(void) {}
>
> struct udev *udev;
> =====================
>
> If you don't call all the mpathpersist commands with verbose = -1,
> the library can log errors. Setting logsink to 0 will log them with a
> timestamp. setting it to -1 will not add the timestamp.
>
> Your main funciton also needs to set up these variables. It should
> include something like (again pulled from mpathpersist/main.c):
>
> ====================
> udev = udev_new();
> multipath_conf = mpath_lib_init();
> ====================
>
> Both of these functions can return NULL on error.
>
> Let me know if that helps.
>
> -Ben
>
> > --
> > dm-devel mailing list
> > dm-devel@redhat.com
> > https://listman.redhat.com/mailman/listinfo/dm-devel
>
>

--0000000000008364eb05daefbeaa
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Thanks Benjamin,<div><br></div><div>Thanks for your reply.=
 After I posted this question, I went through the source code and figured o=
ut that these functions=C2=A0are defined as weak. So they are not getting a=
dded to the library and binaries which are using them are re-defining these=
 definitions.</div><div><br></div><div>I will try the suggestions as per be=
low. But as a work around, we tried to use the RedHat 7 version of RPM to s=
ee if it works and it worked.</div><div><br></div><div>Anyhow, I will defin=
itely try the suggestion and get back to you.</div><div><br></div><div>Than=
ks once again,</div><div>Sudhakar.=C2=A0</div></div><br><div class=3D"gmail=
_quote"><div dir=3D"ltr" class=3D"gmail_attr">On Thu, Mar 24, 2022 at 3:54 =
AM Benjamin Marzinski &lt;<a href=3D"mailto:bmarzins@redhat.com">bmarzins@r=
edhat.com</a>&gt; wrote:<br></div><blockquote class=3D"gmail_quote" style=
=3D"margin:0px 0px 0px 0.8ex;border-left:1px solid rgb(204,204,204);padding=
-left:1ex">On Sat, Mar 19, 2022 at 08:57:08PM +0530, boli sudha wrote:<br>
&gt; Hi,<br>
&gt; <br>
&gt; I found this mail Id on the Git page, I never used libmpathpersist or<=
br>
&gt; libmulitpath.<br>
&gt; One of our applications is using these libraries. Compilation was work=
ing<br>
&gt; fine on RedHat 7. I am trying to port our application to Redhat 8. Dur=
ing<br>
&gt; linking I am getting the following error. Can you please help me?<br>
&gt; <br>
&gt; /usr/lib64/libmpathpersist.so: undefined reference to `put_multipath_c=
onfig&#39;<br>
&gt; /usr/lib64/libmpathpersist.so: undefined reference to `get_multipath_c=
onfig&#39;<br>
&gt; /usr/lib64/libmultipath.so: undefined reference to `udev&#39;<br>
&gt; collect2: error: ld returned 1 exit status<br>
&gt; <br>
&gt; These symbols were not present in the RedHat 7 version of libraries.<b=
r>
&gt; <br>
&gt; On RedHat 8, these symbols were undefined, I downloaded the git code,<=
br>
&gt; compiled, and observed that these symbols are defined in binaries, not=
<br>
&gt; libraries.<br>
&gt; <br>
&gt; I also tried to remove these libraries from linker command, but so man=
y<br>
&gt; symbols are missing.<br>
<br>
Using libmpathpersist is kind of tricky. Later version of<br>
device-mapper-multipath clean this up. But for the version in RHEL-8,<br>
your binary needs to specify some things to work with libmpathpersist.<br>
<br>
If your program is single threaded, then you should add something like<br>
(pulled from mpathpersist/main.c):<br>
<br>
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D<br>
int logsink =3D 0;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 /=
* or -1 */<br>
struct config *multipath_conf;<br>
<br>
struct config *get_multipath_config(void)<br>
{<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 return multipath_conf;<br>
}<br>
<br>
void put_multipath_config(__attribute__((unused)) void * arg)<br>
{<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 /* Noop for now */<br>
}<br>
<br>
void rcu_register_thread_memb(void) {}<br>
<br>
void rcu_unregister_thread_memb(void) {}<br>
<br>
struct udev *udev;<br>
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D<br>
<br>
If you don&#39;t call all the mpathpersist commands with verbose =3D -1,<br=
>
the library can log errors. Setting logsink to 0 will log them with a<br>
timestamp. setting it to -1 will not add the timestamp.<br>
<br>
Your main funciton also needs to set up these variables. It should<br>
include something like (again pulled from mpathpersist/main.c):<br>
<br>
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D<br>
udev =3D udev_new();<br>
multipath_conf =3D mpath_lib_init();=C2=A0 =C2=A0 =C2=A0 <br>
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D<br>
<br>
Both of these functions can return NULL on error.<br>
<br>
Let me know if that helps.<br>
<br>
-Ben<br>
<br>
&gt; --<br>
&gt; dm-devel mailing list<br>
&gt; <a href=3D"mailto:dm-devel@redhat.com" target=3D"_blank">dm-devel@redh=
at.com</a><br>
&gt; <a href=3D"https://listman.redhat.com/mailman/listinfo/dm-devel" rel=
=3D"noreferrer" target=3D"_blank">https://listman.redhat.com/mailman/listin=
fo/dm-devel</a><br>
<br>
</blockquote></div>

--0000000000008364eb05daefbeaa--

--===============3001934001123067837==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

--===============3001934001123067837==--

