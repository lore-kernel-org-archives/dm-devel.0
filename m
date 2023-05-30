Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 33CBEC7EE2C
	for <dm-devel@archiver.kernel.org>; Tue, 30 May 2023 14:56:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685458565;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:in-reply-to:in-reply-to:
	 references:references:list-id:list-help:list-unsubscribe:
	 list-subscribe:list-post; bh=qLqcZWKnlcpZoD5x6R0AzyB1iz0w9FNqD6AmdsqRH18=;
	b=hi//M9tBglR5+9HHK4OXirtH28NArQaAkybLIKSWpoqOhBMdX37SDpNu5bMXS3FC3kek+N
	KMYaWL1DyIQsXhu0NDKXjT3sywJHyW9XjkfX7oASK4wgqzckCHO0ickZft8MQomCPG00ds
	8oegUpCdYxqKIrAZ2AJeygYv/lawTKw=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-557-c74DCIL7P0O-7I-zaPKJGQ-1; Tue, 30 May 2023 10:56:03 -0400
X-MC-Unique: c74DCIL7P0O-7I-zaPKJGQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 64DAF1C0784D;
	Tue, 30 May 2023 14:56:00 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 9CBBA140EBB8;
	Tue, 30 May 2023 14:55:59 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 3EE3C19465A0;
	Tue, 30 May 2023 14:55:59 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id DBBED1946595
 for <dm-devel@listman.corp.redhat.com>; Tue, 30 May 2023 14:55:57 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id C7DB3202696C; Tue, 30 May 2023 14:55:57 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id BF92220296C6
 for <dm-devel@redhat.com>; Tue, 30 May 2023 14:55:57 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9E8C42800C21
 for <dm-devel@redhat.com>; Tue, 30 May 2023 14:55:57 +0000 (UTC)
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-647-OGtOESr_POu4dQVlXdKMXw-1; Tue, 30 May 2023 10:55:55 -0400
X-MC-Unique: OGtOESr_POu4dQVlXdKMXw-1
Received: by mail-wr1-f72.google.com with SMTP id
 ffacd0b85a97d-30ae8776c12so1239786f8f.1
 for <dm-devel@redhat.com>; Tue, 30 May 2023 07:55:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1685458555; x=1688050555;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
 :reply-to;
 bh=CtY4u2VTVLqzERLtwqiZeDfxDB3Jj51VaougWQ/ZBro=;
 b=XU7hOWhQJ3bYe88rHDa9MCV+wl13TsfliR1My7pq2MNm1GXrhEWgQ8umR3A41a1AB+
 +2DDYXp2u+W/DIooJhU5rsJyI2tINkc5w1QjobGcNkwRv7cBrVb2McK/3AZMxiggfEqW
 JdvclAyFmE0nVDrVm3OeDK0iAhvQTNxAsAEHk9090n+5scVfIEc489gp6vP/dqmxXxEl
 K02/MPeo2VnVcIvOg4++I72k/kbPOSW2P5HCqU3jd5O3Ezc3xCieG0iNgbGcrplJHP12
 EJYyVE4V9Kkh4IK/DeNQe6lg99iceYGRnOtTOybPjnL8XT0C68EL55Bv6Fy18tjT8oSa
 aLSg==
X-Gm-Message-State: AC+VfDx+sk++d69cxfUqblmLyHVe2RemqbJk0BP2xRh82ZSS9lrH0+5+
 eGJ1Lz52M/Xjx3Xb4YWXeInDQ6N7tSk7sKQrSWfymddQ0J4lexXjGbEJpuiWQhwj7st1PaF4P5g
 n7Va4t08+ROWyg7Eebnb868BD1ShnpPc=
X-Received: by 2002:adf:f485:0:b0:30a:c681:fd2e with SMTP id
 l5-20020adff485000000b0030ac681fd2emr2222994wro.22.1685458554960; 
 Tue, 30 May 2023 07:55:54 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ5+FRjq3fgi/n7gfB9z0F5JLFVS8mjSPkD6bglqdSR3t1BcXbBoaibKj2we+xGa0I9uSN28mddNOsRAHSXADFA=
X-Received: by 2002:adf:f485:0:b0:30a:c681:fd2e with SMTP id
 l5-20020adff485000000b0030ac681fd2emr2222968wro.22.1685458554740; Tue, 30 May
 2023 07:55:54 -0700 (PDT)
MIME-Version: 1.0
References: <ZGgBQhsbU9b0RiT1@dread.disaster.area>
 <ZGu0LaQfREvOQO4h@redhat.com>
 <ZGzIJlCE2pcqQRFJ@bfoster> <ZGzbGg35SqMrWfpr@redhat.com>
 <ZG1dAtHmbQ53aOhA@dread.disaster.area>
 <ZG+KoxDMeyogq4J0@bfoster> <ZHB954zGG1ag0E/t@dread.disaster.area>
 <CAJ0trDbspRaDKzTzTjFdPHdB9n0Q9unfu1cEk8giTWoNu3jP8g@mail.gmail.com>
 <ZHFEfngPyUOqlthr@dread.disaster.area>
 <CAJ0trDZJQwvAzngZLBJ1hB0XkQ1HRHQOdNQNTw9nK-U5i-0bLA@mail.gmail.com>
 <ZHYB/6l5Wi+xwkbQ@redhat.com>
In-Reply-To: <ZHYB/6l5Wi+xwkbQ@redhat.com>
From: Joe Thornber <thornber@redhat.com>
Date: Tue, 30 May 2023 15:55:43 +0100
Message-ID: <CAJ0trDaUOevfiEpXasOESrLHTCcr=oz28ywJU+s+YOiuh7iWow@mail.gmail.com>
To: Mike Snitzer <snitzer@kernel.org>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
Subject: Re: [dm-devel] [PATCH v7 0/5] Introduce provisioning primitives
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
Cc: Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@infradead.org>,
 Theodore Ts'o <tytso@mit.edu>, Sarthak Kukreti <sarthakkukreti@chromium.org>,
 dm-devel@redhat.com, "Michael S. Tsirkin" <mst@redhat.com>,
 "Darrick J. Wong" <djwong@kernel.org>, Brian Foster <bfoster@redhat.com>,
 Bart Van Assche <bvanassche@google.com>, Dave Chinner <david@fromorbit.com>,
 linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
 Joe Thornber <ejt@redhat.com>, Andreas Dilger <adilger.kernel@dilger.ca>,
 Stefan Hajnoczi <stefanha@redhat.com>, linux-fsdevel@vger.kernel.org,
 linux-ext4@vger.kernel.org, Jason Wang <jasowang@redhat.com>,
 Alasdair Kergon <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/mixed; boundary="===============5717961736341811184=="

--===============5717961736341811184==
Content-Type: multipart/alternative; boundary="0000000000007078a905fcea6610"

--0000000000007078a905fcea6610
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, May 30, 2023 at 3:02=E2=80=AFPM Mike Snitzer <snitzer@kernel.org> w=
rote:

>
> Also Joe, for you proposed dm-thinp design where you distinquish
> between "provision" and "reserve": Would it make sense for REQ_META
> (e.g. all XFS metadata) with REQ_PROVISION to be treated as an
> LBA-specific hard request?  Whereas REQ_PROVISION on its own provides
> more freedom to just reserve the length of blocks? (e.g. for XFS
> delalloc where LBA range is unknown, but dm-thinp can be asked to
> reserve space to accomodate it).
>

My proposal only involves 'reserve'.  Provisioning will be done as part of
the usual io path.

- Joe

--0000000000007078a905fcea6610
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div dir=3D"ltr"><br></div><br><div class=3D"gmail_quote">=
<div dir=3D"ltr" class=3D"gmail_attr">On Tue, May 30, 2023 at 3:02=E2=80=AF=
PM Mike Snitzer &lt;<a href=3D"mailto:snitzer@kernel.org">snitzer@kernel.or=
g</a>&gt; wrote:<br></div><blockquote class=3D"gmail_quote" style=3D"margin=
:0px 0px 0px 0.8ex;border-left:1px solid rgb(204,204,204);padding-left:1ex"=
><br>
Also Joe, for you proposed dm-thinp design where you distinquish<br>
between &quot;provision&quot; and &quot;reserve&quot;: Would it make sense =
for REQ_META<br>
(e.g. all XFS metadata) with REQ_PROVISION to be treated as an<br>
LBA-specific hard request?=C2=A0 Whereas REQ_PROVISION on its own provides<=
br>
more freedom to just reserve the length of blocks? (e.g. for XFS<br>
delalloc where LBA range is unknown, but dm-thinp can be asked to<br>
reserve space to accomodate it).<br></blockquote><div><br></div><div>My pro=
posal only involves &#39;reserve&#39;.=C2=A0 Provisioning will be done as p=
art of the usual io path.</div><div><br></div><div>- Joe</div><div>=C2=A0</=
div></div></div>

--0000000000007078a905fcea6610--

--===============5717961736341811184==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

--===============5717961736341811184==--

