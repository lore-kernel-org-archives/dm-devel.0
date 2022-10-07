Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 56519C433FE
	for <dm-devel@archiver.kernel.org>; Mon, 10 Oct 2022 06:01:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1665381717;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:list-id:list-help:list-unsubscribe:
	 list-subscribe:list-post; bh=iH3ojn7hqp5A0vWCLkYEI0wr9KL2KGtT+2/TXkmqTDo=;
	b=a/32IT07YAMKqCKRR9S/OJFcBRSQVkadsUpLen27C/QUGfiOPHr8BdjqPOosL8VIcIxg0N
	9WCS3tFn9Scxaq7gV6dbu18FAkw0paxn822wVDkMzC5uTBCp+xQ+endixntvSeapSTrNyJ
	4DzL7KRD9F+VFnAXw+Ak7R2kS11OqBY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-549-Ybelm00WP0-O-W9ANEkOCg-1; Mon, 10 Oct 2022 02:01:53 -0400
X-MC-Unique: Ybelm00WP0-O-W9ANEkOCg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 40174830F9B;
	Mon, 10 Oct 2022 06:01:50 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 4758FBE5AC;
	Mon, 10 Oct 2022 06:01:47 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 166181946597;
	Mon, 10 Oct 2022 06:01:47 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 807951946595
 for <dm-devel@listman.corp.redhat.com>; Fri,  7 Oct 2022 16:40:11 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 63752145BA51; Fri,  7 Oct 2022 16:40:11 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 5BE4E14583FB
 for <dm-devel@redhat.com>; Fri,  7 Oct 2022 16:40:11 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3F5E3899B41
 for <dm-devel@redhat.com>; Fri,  7 Oct 2022 16:40:11 +0000 (UTC)
Received: from mail-yb1-f172.google.com (mail-yb1-f172.google.com
 [209.85.219.172]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-513-3TRB9VnfOFeJJ9keA0I9Fg-1; Fri, 07 Oct 2022 12:40:09 -0400
X-MC-Unique: 3TRB9VnfOFeJJ9keA0I9Fg-1
Received: by mail-yb1-f172.google.com with SMTP id 207so6400926ybn.1
 for <dm-devel@redhat.com>; Fri, 07 Oct 2022 09:40:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=to:subject:message-id:date:from:mime-version:x-gm-message-state
 :from:to:cc:subject:date:message-id:reply-to;
 bh=kMyR9c2mhWdMMy69DUVwOqB6Wq/reIbDJToueR7nPc4=;
 b=Lkm/63eU8KTZQBmEqj6XVxnkfAIELzLG0UonYg2CcgDpkI3RknHuH+3TmP+L9y6QGf
 z4jc9+ohgrLVNTlcHo/QM5IqVhO+T6JZb19n56nu4W8tZnRNryy2CVP7Fqm5GZZnOtyf
 JDq4L3aoMK1u6VsGQXzqXs0LGS4ZxXXVqJP82AnEC5GivFfvG2qC4g/UMQdWcB3Pc0KJ
 Jf/HmO/JEQBEx0dMZzdKui4dZACnEHt1lhR4GnuSrs2JcVZHLvdulthDe+QOYgRefWfS
 LlRLe5XZJtoEwqKhlv8eGIfxA/C4W+jwglLjFUzjjpZrI+rbpgILsOs+ASgcac8M43eL
 TaAw==
X-Gm-Message-State: ACrzQf1leOdImz2L5ijYXsusLMI0hdVyw80ZfD9Gjlfcw8gUJfgQfGPO
 qUbV7tWSeQ0IebkoGIv4DFW/rrXKJOOrEUZ2Q50h49zI
X-Google-Smtp-Source: AMsMyM7Qz9vI9QYKMv7mOYbgocy3vC6cv9EDrgmKqHAVrKy0KQuwOEQ8vw/5AvUXWF4aGqiQWG67+3uOzGjlp+cBk+0=
X-Received: by 2002:a25:3f06:0:b0:6bf:8d1:191d with SMTP id
 m6-20020a253f06000000b006bf08d1191dmr4840860yba.16.1665160808322; Fri, 07 Oct
 2022 09:40:08 -0700 (PDT)
MIME-Version: 1.0
From: ofthecentury <ofthecentury@gmail.com>
Date: Fri, 7 Oct 2022 22:39:42 +0600
Message-ID: <CAOociT7XPXddpvf7n0sc8QhH8bL7V0pm-R0rnnyT5tB1UUgrzA@mail.gmail.com>
To: dm-devel@redhat.com
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Mailman-Approved-At: Mon, 10 Oct 2022 06:01:46 +0000
Subject: [dm-devel] Writing code to work at the byte level
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
Content-Type: multipart/mixed; boundary="===============8285032193043951879=="

--===============8285032193043951879==
Content-Type: multipart/alternative; boundary="000000000000795cea05ea747615"

--000000000000795cea05ea747615
Content-Type: text/plain; charset="UTF-8"

Hi. I would like to modify source code to allow byte-level access vs
sector-level access. Since you are all very familiar with the code could
you point me roughly to where I'd need to start at? Is it even a simple
leap? Or does it require crazy hardware driver modifications or building an
abstract layer to work with bytes within the sectors?
Thanks!

--000000000000795cea05ea747615
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div class=3D"gmail_default" style=3D"font-family:georgia,=
serif;font-size:small;color:rgb(102,102,102)">Hi. I would like to modify so=
urce code to allow byte-level access vs sector-level access. Since you are =
all very familiar with the code could you point me roughly=C2=A0to where I&=
#39;d need to start at? Is it even a simple leap? Or does it require crazy =
hardware driver modifications or building an abstract layer to work with by=
tes within the sectors?</div><div class=3D"gmail_default" style=3D"font-fam=
ily:georgia,serif;font-size:small;color:rgb(102,102,102)">Thanks!</div></di=
v>

--000000000000795cea05ea747615--

--===============8285032193043951879==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

--===============8285032193043951879==--

