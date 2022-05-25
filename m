Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7328EC433F5
	for <dm-devel@archiver.kernel.org>; Wed, 25 May 2022 15:17:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1653491874;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=3JqIR+4ydWu4bKdwr8Wmz+L45jrz17wZ4pZVAbv+gCs=;
	b=LLU9uIbJzZf8D/JvdNetosRBZpMeJt1XJ8/EoYhpfKZ1pYqJXdFEDzI0RxPcYxfuNcpXrB
	tTvBnU1Z+heqfcS7APY8pu5ACKwVU0HokAtUtzXqOi2AiYlTboifQ+8ftoWE4SK8ABPaKv
	PoRldUF/AoeLwimD1MVA1LqlpnTbOoY=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-464-RLKM656YPmyR3i2AnWn8gw-1; Wed, 25 May 2022 11:17:53 -0400
X-MC-Unique: RLKM656YPmyR3i2AnWn8gw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9F5931C00135;
	Wed, 25 May 2022 15:17:51 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 498E140CF8EF;
	Wed, 25 May 2022 15:17:45 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id AD06C194EB88;
	Wed, 25 May 2022 15:17:45 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id CFA13194EB82
 for <dm-devel@listman.corp.redhat.com>; Wed, 25 May 2022 14:58:39 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 9D8DF492CA3; Wed, 25 May 2022 14:58:39 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 99331492CA2
 for <dm-devel@redhat.com>; Wed, 25 May 2022 14:58:39 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 806C829DD99B
 for <dm-devel@redhat.com>; Wed, 25 May 2022 14:58:39 +0000 (UTC)
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-52-DbKW9qbfMe213ZG7HsHbWQ-1; Wed, 25 May 2022 10:58:35 -0400
X-MC-Unique: DbKW9qbfMe213ZG7HsHbWQ-1
Received: by mail-qk1-f198.google.com with SMTP id
 m26-20020a05620a13ba00b006a32a7adb78so14181945qki.10
 for <dm-devel@redhat.com>; Wed, 25 May 2022 07:58:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=Q/qYjRZwsKAI9dPkaWSNsjN+CazVDSjjlEWv9BGdfS8=;
 b=38uPQEn1MXGUn+hgPIr1wCKWMItJb6xcDkm/J81EM5m8KzOHv20d6paLZf0E/0h/zO
 ib1yO7CrKQMZFkeaqQKwsYdr5Swm5lwy/7b/m4m5bH7C/j6TeAomV1tfCXDuwXXoAy86
 NIb6ostoQHDqq38BROtJ79rzfyuq6zfkpnSisidxutK7SBvx607mFpGk9uvRox5aA8pz
 4xEJrof0PRJ2bpZXQ6af8oD83IXVA0DFFw/SDJS1IxeBDqDNQ9SRFqLp7kbC2SHvEESc
 xmbs53iTRWUALmZkdzs57QQEozdadTTAKdU55cV6g2V0najwlJaoWV3B33AoUKp+rsTp
 MuJA==
X-Gm-Message-State: AOAM532sUQF/xrOt3JXinox91+fx36L+cJckZHuR/tlzmeis2p6/owj9
 Vy8uewl2cpvRzOOqKDWEoI5Tdu4SiYoD3L2t52WWEmZ12n1OQTAx7ZWkueqgTuC5qmMMO3dKX63
 qIpdb2S8HZAO+aQ==
X-Received: by 2002:a05:6214:931:b0:461:d289:b7f6 with SMTP id
 dk17-20020a056214093100b00461d289b7f6mr26707349qvb.55.1653490714791; 
 Wed, 25 May 2022 07:58:34 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzeXhIV5Rn0JH8NaISvi81JKLrzopSbsg9h6s5UgnJH/RQ3v82QAI5Hm5rItw73viOE/kTqUw==
X-Received: by 2002:a05:6214:931:b0:461:d289:b7f6 with SMTP id
 dk17-20020a056214093100b00461d289b7f6mr26707331qvb.55.1653490714508; 
 Wed, 25 May 2022 07:58:34 -0700 (PDT)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net.
 [68.160.176.52]) by smtp.gmail.com with ESMTPSA id
 y21-20020a05622a005500b002fafd1643d0sm1023264qtw.8.2022.05.25.07.58.33
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 25 May 2022 07:58:34 -0700 (PDT)
Date: Wed, 25 May 2022 10:58:33 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: Thomas Gleixner <tglx@linutronix.de>
Message-ID: <Yo5EGfu7ST5os2R/@redhat.com>
References: <165322121770.3770149.18166071018834854082.tglx@xen13>
 <CAC1cPGz4CVCqb7P72sWjJ5S6s6HcxzqiwuykwGFswkovOuALHA@mail.gmail.com>
 <874k1higgo.ffs@tglx>
MIME-Version: 1.0
In-Reply-To: <874k1higgo.ffs@tglx>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
Subject: Re: [dm-devel] treewide: License cleanup - RedHat originated
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
Cc: Richard Fontana <rfontana@redhat.com>, dm-devel@redhat.com,
 linux-spdx@vger.kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Sun, May 22 2022 at  2:12P -0400,
Thomas Gleixner <tglx@linutronix.de> wrote:

> Richard!
> 
> On Sun, May 22 2022 at 13:33, Richard Fontana wrote:
> > On Sun, May 22, 2022 at 10:55 AM Thomas Gleixner <tglx@linutronix.de> wrote:
> > I assume you're selecting files that have some sort of Red Hat or
> > Sistina copyright notice. Just as a disclaimer, I can't speak to
> > copyrights in these files that may be held by other organizations or
> > individuals (and I can't say definitively whether any file bearing a
> > Red Hat or Sistina copyright notice has or retains any copyright owned
> > by Red Hat). With that said:
> >
> >> 1) this file is released under the gpl
> >
> > I am fine with saying that any Red Hat copyrights (including any
> > Sistina copyrights acquired by Red Hat) in these can be represented
> > with SPDX-License-Identifier: GPL-2.0.
> >
> > I would note that the following files did not seem to have any Red Hat
> > or Sistina copyright notices:
> >
> >>    drivers/md/dm-log-writes.c
> >>    drivers/md/dm-ps-queue-length.c
> >>    drivers/md/dm-ps-service-time.c
> >>    drivers/md/dm-unstripe.c
> >>    drivers/md/dm-zero.c
> 
> Oops, yes. They are clearly flagged as not Red Hat.

True, though Red Hat has contributed code to these files and continues
to mainatin these files.

If we need further approval from original authors I can work to reach
out to them.

Thanks,
Mike

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

