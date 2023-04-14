Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6009FC77B6E
	for <dm-devel@archiver.kernel.org>; Fri, 14 Apr 2023 13:33:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1681479180;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:in-reply-to:in-reply-to:
	 references:references:list-id:list-help:list-unsubscribe:
	 list-subscribe:list-post; bh=oIwvEppsPikbiT9Tzv1YUKnuQj2gyj28bwMnGiaoVFA=;
	b=V0csKcX+5bzvCw+okVEuiuzdCQ7GZHTov8E91WGPsD3N5WEVxWQoGKq3UVQLf9m+8L4MbC
	VQogdHObcv0//fzJaC4ZrJBGYZf9MOoEj3E8CnhY6plHxMU3YZB3r0GM4lVSMb3sVT4er/
	PYPwHPRrqfzqmqTsZrK8euBD1MOqce4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-500-I3koaM27P56WUIaBwM4hpg-1; Fri, 14 Apr 2023 09:32:56 -0400
X-MC-Unique: I3koaM27P56WUIaBwM4hpg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DA72F855304;
	Fri, 14 Apr 2023 13:32:54 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 1763EC16028;
	Fri, 14 Apr 2023 13:32:51 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id DCA2119459FC;
	Fri, 14 Apr 2023 13:32:50 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id C217C1946A7F
 for <dm-devel@listman.corp.redhat.com>; Fri, 14 Apr 2023 13:32:49 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 508D6492C14; Fri, 14 Apr 2023 13:32:49 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 495D0492C13
 for <dm-devel@redhat.com>; Fri, 14 Apr 2023 13:32:49 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2D4E8858F0E
 for <dm-devel@redhat.com>; Fri, 14 Apr 2023 13:32:49 +0000 (UTC)
Received: from mail-yw1-f198.google.com (mail-yw1-f198.google.com
 [209.85.128.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-403-_6O2GzqGMryccZFCohQqyw-1; Fri, 14 Apr 2023 09:32:43 -0400
X-MC-Unique: _6O2GzqGMryccZFCohQqyw-1
Received: by mail-yw1-f198.google.com with SMTP id
 00721157ae682-54f69fb5cafso125490507b3.12
 for <dm-devel@redhat.com>; Fri, 14 Apr 2023 06:32:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1681479163; x=1684071163;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
 :reply-to;
 bh=qiZ6xGR1+shMcUKHKrXEqZ3GxAVuvJO4tkdbPJ4Qa+w=;
 b=Px/77314GZP+2e1cP9NuJfW8Ea2Ypj6ZPnPVsfSKXipwNP3y4VOR8LyYn3ZFlDRyR6
 R6eqsLP/R1PXWKHOcBdFBfCZFzNfU215Jgs4SHP4HTaXDMzfuZdhvaYSjJ2Huk+phwm2
 nZ/mfcO5XxL+rrPpR1bd7dQB0QxHYSuVAOKz5U/Nk4LMZtVKOSa8yn6U0xCs/S1l9ec0
 01PvJtAeNeTJXG2/QEu8/QoglFqeUpJXllvBzoggbK44AjLWtrkaQlOFkX2LNatcgf9M
 hEp8JNSFmRWM+QTL3S12JkuKohjqIjJ3cWjZyraMfxtxXql+vBafclG3OPJRfrCx8Hlx
 MfZA==
X-Gm-Message-State: AAQBX9dcIkIf+GQzGxB/9a8J721kAkRAScbQFVHAiuT7dfq3mNOh766V
 GcYD8tBeHOTgkv/wQt1LQyrtcKFgINxZhYAVd2wbmJoLd6yPxwpHYEEL0ggY7UG1HupLNMDhurj
 kTqXg+Y35VubKYpKQbyfnf4hZc8osrJY=
X-Received: by 2002:a25:cfce:0:b0:b8f:54f5:89ff with SMTP id
 f197-20020a25cfce000000b00b8f54f589ffmr3744491ybg.11.1681479162845; 
 Fri, 14 Apr 2023 06:32:42 -0700 (PDT)
X-Google-Smtp-Source: AKy350bc0jucjLxOaDncmJ2lqlh+3OIbcT2yz5fth7/Iif+VdlRfMwHulrdYoGLUdQMY6pR2KJk+TPKOj5F4Zd80U0g=
X-Received: by 2002:a25:cfce:0:b0:b8f:54f5:89ff with SMTP id
 f197-20020a25cfce000000b00b8f54f589ffmr3744476ybg.11.1681479162580; Fri, 14
 Apr 2023 06:32:42 -0700 (PDT)
MIME-Version: 1.0
References: <20221229071647.437095-1-sarthakkukreti@chromium.org>
 <20230414000219.92640-1-sarthakkukreti@chromium.org>
 <20230414000219.92640-3-sarthakkukreti@chromium.org>
In-Reply-To: <20230414000219.92640-3-sarthakkukreti@chromium.org>
From: Joe Thornber <thornber@redhat.com>
Date: Fri, 14 Apr 2023 14:32:31 +0100
Message-ID: <CAJ0trDbyqoKEDN4kzcdn+vWhx+hk6pTM4ndf-E02f3uT9YZ3Uw@mail.gmail.com>
To: Sarthak Kukreti <sarthakkukreti@chromium.org>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
Subject: Re: [dm-devel] [PATCH v3 2/3] dm: Add support for block provisioning
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
 Theodore Ts'o <tytso@mit.edu>, "Michael S. Tsirkin" <mst@redhat.com>,
 sarthakkukreti@google.com, "Darrick J. Wong" <djwong@kernel.org>,
 Jason Wang <jasowang@redhat.com>, Bart Van Assche <bvanassche@google.com>,
 Mike Snitzer <snitzer@kernel.org>, linux-kernel@vger.kernel.org,
 linux-block@vger.kernel.org, dm-devel@redhat.com,
 Andreas Dilger <adilger.kernel@dilger.ca>, Daniil Lunev <dlunev@google.com>,
 Stefan Hajnoczi <stefanha@redhat.com>, linux-fsdevel@vger.kernel.org,
 linux-ext4@vger.kernel.org, Brian Foster <bfoster@redhat.com>,
 Alasdair Kergon <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/mixed; boundary="===============7792129218009807477=="

--===============7792129218009807477==
Content-Type: multipart/alternative; boundary="0000000000002ee75605f94be0ad"

--0000000000002ee75605f94be0ad
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Apr 14, 2023 at 7:52=E2=80=AFAM Sarthak Kukreti <sarthakkukreti@chr=
omium.org>
wrote:

> Add support to dm devices for REQ_OP_PROVISION. The default mode
> is to passthrough the request to the underlying device, if it
> supports it. dm-thinpool uses the provision request to provision
> blocks for a dm-thin device. dm-thinpool currently does not
> pass through REQ_OP_PROVISION to underlying devices.
>
> For shared blocks, provision requests will break sharing and copy the
> contents of the entire block.
>

I see two issue with this patch:

i) You use get_bio_block_range() to see which blocks the provision bio
covers.  But this function only returns
complete blocks that are covered (it was designed for discard).  Unlike
discard, provision is not a hint so those
partial blocks will need to be provisioned too.

ii) You are setting off multiple dm_thin_new_mapping operations in flight
at once.  Each of these receives
the same virt_cell and frees it  when it completes.  So I think we have
multiple frees occuring?  In addition you also
release the cell yourself in process_provision_cell().  Fixing this is not
trivial, you'll need to reference count the cells,
and aggregate the mapping operation results.

I think it would be far easier to restrict the size of the provision bio to
be no bigger than one thinp block (as we do for normal io).  This way dm
core can split the bios, chain the child bios rather than having to
reference count mapping ops, and aggregate the results.

- Joe

--0000000000002ee75605f94be0ad
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div dir=3D"ltr"><br></div><br><div class=3D"gmail_quote">=
<div dir=3D"ltr" class=3D"gmail_attr">On Fri, Apr 14, 2023 at 7:52=E2=80=AF=
AM Sarthak Kukreti &lt;<a href=3D"mailto:sarthakkukreti@chromium.org">sarth=
akkukreti@chromium.org</a>&gt; wrote:<br></div><blockquote class=3D"gmail_q=
uote" style=3D"margin:0px 0px 0px 0.8ex;border-left:1px solid rgb(204,204,2=
04);padding-left:1ex">Add support to dm devices for REQ_OP_PROVISION. The d=
efault mode<br>
is to passthrough the request to the underlying device, if it<br>
supports it. dm-thinpool uses the provision request to provision<br>
blocks for a dm-thin device. dm-thinpool currently does not<br>
pass through REQ_OP_PROVISION to underlying devices.<br>
<br>
For shared blocks, provision requests will break sharing and copy the<br>
contents of the entire block.<br></blockquote><div><br></div><div>I see two=
 issue with this patch:</div><div><br></div><div>i) You use get_bio_block_r=
ange() to see which blocks the provision bio covers.=C2=A0 But this functio=
n only returns</div><div>complete blocks that are covered (it was designed =
for discard).=C2=A0 Unlike discard, provision is not a hint so those</div><=
div>partial blocks will need to be provisioned too.</div><div><br></div><di=
v>ii) You are setting off multiple dm_thin_new_mapping operations in flight=
 at once.=C2=A0 Each of these receives</div><div>the same virt_cell and fre=
es it=C2=A0 when it completes.=C2=A0 So I think we have multiple frees occu=
ring?=C2=A0 In addition you also</div><div>release the cell yourself in pro=
cess_provision_cell().=C2=A0 Fixing this is not trivial, you&#39;ll need to=
 reference count the cells,</div><div>and aggregate the mapping operation r=
esults.</div><div><br></div><div>I think it would be far easier to restrict=
 the size of the provision bio to be no bigger than one thinp block (as we =
do for normal io).=C2=A0 This way dm core can split the bios, chain the chi=
ld bios rather than having to reference count mapping ops, and aggregate th=
e results.</div><div><br></div><div>- Joe</div><div><br></div><div><br></di=
v><div><br></div><div>=C2=A0</div></div></div>

--0000000000002ee75605f94be0ad--

--===============7792129218009807477==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

--===============7792129218009807477==--

