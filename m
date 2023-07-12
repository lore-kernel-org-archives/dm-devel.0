Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9516FEB64DD
	for <dm-devel@archiver.kernel.org>; Thu, 13 Jul 2023 06:24:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1689229496;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:in-reply-to:in-reply-to:
	 references:references:list-id:list-help:list-unsubscribe:
	 list-subscribe:list-post; bh=WY9mBIhFnjjg44RHb09jBeYbtz1lU0JjTPMD0/y7jHc=;
	b=ChCzP6HDWtb31Zz45xF9LKXiE8dUzRWNAApzC7724xiD+qaZn6ptKqn3cQ74QNIeLPCMha
	fcxt0P9lYXksig8dy7vOXh78o5ninDk9Y+gUPe+43m0DxEmHH6u5yVk/uk+4nLUYpFQfSM
	mnm8gmzQRp+xnojTIziKifk6ON/vrTs=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-586-RauL6R4KNmSGb10WZ812qw-1; Thu, 13 Jul 2023 02:24:53 -0400
X-MC-Unique: RauL6R4KNmSGb10WZ812qw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3F6198F9E46;
	Thu, 13 Jul 2023 06:24:51 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 7745F4087C69;
	Thu, 13 Jul 2023 06:24:49 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 0DF7A1946A45;
	Thu, 13 Jul 2023 06:24:48 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 57DDD19465B6
 for <dm-devel@listman.corp.redhat.com>; Wed, 12 Jul 2023 13:39:33 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 381F54CD0CD; Wed, 12 Jul 2023 13:39:33 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 308AB4CD0C6
 for <dm-devel@redhat.com>; Wed, 12 Jul 2023 13:39:33 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-inbound-delivery-1.mimecast.com
 [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EDA5A8EBBB8
 for <dm-devel@redhat.com>; Wed, 12 Jul 2023 13:39:32 +0000 (UTC)
Received: from mail-lf1-f41.google.com (mail-lf1-f41.google.com
 [209.85.167.41]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-38-kDKhS_0TOcOj0-2LcExUkg-1; Wed, 12 Jul 2023 09:39:30 -0400
X-MC-Unique: kDKhS_0TOcOj0-2LcExUkg-1
Received: by mail-lf1-f41.google.com with SMTP id
 2adb3069b0e04-4fbf1f6c771so1813824e87.1
 for <dm-devel@redhat.com>; Wed, 12 Jul 2023 06:39:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1689169161; x=1691761161;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
 :reply-to;
 bh=+evqX27DGBiWJkyZnqGeEHQI9QcDiX7JHwbrqFd6EpQ=;
 b=ZZxXIEK6/u3JNIQPnSXn4pNsJrNjQ11u6YPoVkuLa4l/UEtD/ot/VCxe8cD4+KtvmB
 V0vpkV0TX4zxRJQbqycNlnlHfdzUHPHA3k9wDKGUc+8U6k6jvp+qq0BOhDdQ06qD8oGo
 R1s1yiRbO0+V7YGBDrXtWtS4utPRWjfo//31iHVLtUs1GUbvD3mpX45COn9EBq52wiJF
 GVEdkGjQtBMOGmMyru105nKB+gSFUmGz6suDPBcs/LESQUFXnPUQqDzQ8vr6K8CRKM2R
 roV/DIO6n/SbXK2mOggDB6Lv8CTMJP7am2yM/ySHY7iUiHPC/3wdQCvl1COcqAKBfRkR
 PYWQ==
X-Gm-Message-State: ABy/qLYXCzWNVp9L1hWIRSINNatJapl52y97NlsNWC+KnNO+BWPrGq0g
 UpCubvZ6yiJYlSH5JpLyGZleLtcq8fUEZPLUvZUgjw==
X-Google-Smtp-Source: APBJJlEI1gyVFA9e0vzN1OZw8HqZ9LgUDYjdSVkcc/YNKBWyCbO3ruOl1C16YRvIxaIjAxVOOIhj+dxwF3VF9wwHpIo=
X-Received: by 2002:a05:6512:34cd:b0:4fb:82ac:9d23 with SMTP id
 w13-20020a05651234cd00b004fb82ac9d23mr13814794lfr.36.1689169161029; Wed, 12
 Jul 2023 06:39:21 -0700 (PDT)
MIME-Version: 1.0
References: <20230629165206.383-1-jack@suse.cz>
 <20230704122224.16257-1-jack@suse.cz>
 <ZKbgAG5OoHVyUKOG@infradead.org>
In-Reply-To: <ZKbgAG5OoHVyUKOG@infradead.org>
From: Haris Iqbal <haris.iqbal@ionos.com>
Date: Wed, 12 Jul 2023 15:39:09 +0200
Message-ID: <CAJpMwyhKW23zEfMcsGrBG6Bq0Md40vZ4qj-PgDkR6KWPv8+7PQ@mail.gmail.com>
To: Christoph Hellwig <hch@infradead.org>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mailman-Approved-At: Thu, 13 Jul 2023 06:24:47 +0000
Subject: Re: [dm-devel] [PATCH 01/32] block: Provide blkdev_get_handle_*
 functions
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
Cc: Dave Kleikamp <shaggy@kernel.org>, jfs-discussion@lists.sourceforge.net,
 Jan Kara <jack@suse.cz>, "Darrick J. Wong" <djwong@kernel.org>,
 linux-nvme@lists.infradead.org, Joseph Qi <joseph.qi@linux.alibaba.com>,
 dm-devel@redhat.com, target-devel@vger.kernel.org,
 linux-mtd@lists.infradead.org, Jack Wang <jinpu.wang@ionos.com>,
 Alasdair Kergon <agk@redhat.com>, drbd-dev@lists.linbit.com,
 linux-s390@vger.kernel.org, linux-nilfs@vger.kernel.org,
 linux-scsi@vger.kernel.org, Sergey Senozhatsky <senozhatsky@chromium.org>,
 xen-devel@lists.xenproject.org, Gao Xiang <xiang@kernel.org>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Kent Overstreet <kent.overstreet@gmail.com>,
 Sven Schnelle <svens@linux.ibm.com>, linux-pm@vger.kernel.org,
 Mike Snitzer <snitzer@kernel.org>, Chao Yu <chao@kernel.org>,
 Joern Engel <joern@lazybastard.org>, reiserfs-devel@vger.kernel.org,
 linux-block@vger.kernel.org, linux-bcache@vger.kernel.org,
 David Sterba <dsterba@suse.com>, Jaegeuk Kim <jaegeuk@kernel.org>,
 Trond Myklebust <trond.myklebust@hammerspace.com>,
 Jens Axboe <axboe@kernel.dk>, linux-raid@vger.kernel.org,
 linux-nfs@vger.kernel.org, linux-ext4@vger.kernel.org, Ted Tso <tytso@mit.edu>,
 linux-mm@kvack.org, Song Liu <song@kernel.org>,
 linux-f2fs-devel@lists.sourceforge.net, linux-xfs@vger.kernel.org,
 Minchan Kim <minchan@kernel.org>, ocfs2-devel@oss.oracle.com,
 Anna Schumaker <anna@kernel.org>, linux-fsdevel@vger.kernel.org,
 Andrew Morton <akpm@linux-foundation.org>, linux-erofs@lists.ozlabs.org,
 linux-btrfs@vger.kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: ionos.com
Content-Type: multipart/mixed; boundary="===============6215059131314035413=="

--===============6215059131314035413==
Content-Type: multipart/alternative; boundary="000000000000cf1dc906004a5728"

--000000000000cf1dc906004a5728
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 6, 2023 at 5:38=E2=80=AFPM Christoph Hellwig <hch@infradead.org=
> wrote:

> On Tue, Jul 04, 2023 at 02:21:28PM +0200, Jan Kara wrote:
> > Create struct bdev_handle that contains all parameters that need to be
> > passed to blkdev_put() and provide blkdev_get_handle_* functions that
> > return this structure instead of plain bdev pointer. This will
> > eventually allow us to pass one more argument to blkdev_put() without
> > too much hassle.
>
> Can we use the opportunity to come up with better names?  blkdev_get_*
> was always a rather horrible naming convention for something that
> ends up calling into ->open.
>
> What about:
>
> struct bdev_handle *bdev_open_by_dev(dev_t dev, blk_mode_t mode, void
> *holder,
>                 const struct blk_holder_ops *hops);
> struct bdev_handle *bdev_open_by_path(dev_t dev, blk_mode_t mode,
>                 void *holder, const struct blk_holder_ops *hops);
> void bdev_release(struct bdev_handle *handle);
>

+1 to this.
Also, if we are removing "handle" from the function, should the name of the
structure it returns also change? Would something like bdev_ctx be better?


>
> ?
>

--000000000000cf1dc906004a5728
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div dir=3D"ltr"><br></div><br><div class=3D"gmail_quote">=
<div dir=3D"ltr" class=3D"gmail_attr">On Thu, Jul 6, 2023 at 5:38=E2=80=AFP=
M Christoph Hellwig &lt;<a href=3D"mailto:hch@infradead.org">hch@infradead.=
org</a>&gt; wrote:<br></div><blockquote class=3D"gmail_quote" style=3D"marg=
in:0px 0px 0px 0.8ex;border-left:1px solid rgb(204,204,204);padding-left:1e=
x">On Tue, Jul 04, 2023 at 02:21:28PM +0200, Jan Kara wrote:<br>
&gt; Create struct bdev_handle that contains all parameters that need to be=
<br>
&gt; passed to blkdev_put() and provide blkdev_get_handle_* functions that<=
br>
&gt; return this structure instead of plain bdev pointer. This will<br>
&gt; eventually allow us to pass one more argument to blkdev_put() without<=
br>
&gt; too much hassle.<br>
<br>
Can we use the opportunity to come up with better names?=C2=A0 blkdev_get_*=
<br>
was always a rather horrible naming convention for something that<br>
ends up calling into -&gt;open.<br>
<br>
What about:<br>
<br>
struct bdev_handle *bdev_open_by_dev(dev_t dev, blk_mode_t mode, void *hold=
er,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 const struct blk_ho=
lder_ops *hops);<br>
struct bdev_handle *bdev_open_by_path(dev_t dev, blk_mode_t mode,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 void *holder, const=
 struct blk_holder_ops *hops);<br>
void bdev_release(struct bdev_handle *handle);<br></blockquote><div><br></d=
iv><div>+1 to this.</div><div>Also, if we are removing &quot;handle&quot; f=
rom the function, should the name of the structure it returns also change? =
Would something like bdev_ctx be better?<br></div><div>=C2=A0</div><blockqu=
ote class=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex;border-left:1px=
 solid rgb(204,204,204);padding-left:1ex">
<br>
?<br>
</blockquote></div></div>

--000000000000cf1dc906004a5728--

--===============6215059131314035413==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

--===============6215059131314035413==--

