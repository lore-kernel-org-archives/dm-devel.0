Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CD17DC433F5
	for <dm-devel@archiver.kernel.org>; Wed, 25 May 2022 15:23:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1653492190;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=S+AqLAI4M5m2IqslffVN1OWq9zfoHwUrKuFsyoeSkBM=;
	b=NMTqrjMCQCJIVUt7RJMZw2Xf+DbL/BABJh5wMie2HRgnl7mdBoqIFdesjN8TGM+lDdbLMD
	NuG1TkB1Oo73K+4dR14Th3bk8c9r4NwWhjtlnp6JRw5Fs1MH9UuJ5uZamIYM9GfXNh5qk7
	JGphBJ1WgoxAVh8rbTNJ0iNTKCDWUoI=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-610-dW67Kl1aMTKIpBFsylBfDQ-1; Wed, 25 May 2022 11:23:07 -0400
X-MC-Unique: dW67Kl1aMTKIpBFsylBfDQ-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2E561383328E;
	Wed, 25 May 2022 15:23:05 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id D5BC3492CA2;
	Wed, 25 May 2022 15:23:04 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 8727C194EB83;
	Wed, 25 May 2022 15:23:04 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 5F081194EB82
 for <dm-devel@listman.corp.redhat.com>; Wed, 25 May 2022 14:56:06 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 4E1742026D07; Wed, 25 May 2022 14:56:06 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 4989A2026D64
 for <dm-devel@redhat.com>; Wed, 25 May 2022 14:56:06 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2E6E1384F800
 for <dm-devel@redhat.com>; Wed, 25 May 2022 14:56:06 +0000 (UTC)
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-633-AbuoFFH1OQi5wj-UoPOvDw-1; Wed, 25 May 2022 10:56:04 -0400
X-MC-Unique: AbuoFFH1OQi5wj-UoPOvDw-1
Received: by mail-qt1-f197.google.com with SMTP id
 l20-20020ac81494000000b002f91203eeacso13494225qtj.10
 for <dm-devel@redhat.com>; Wed, 25 May 2022 07:56:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=s2sjvoZpt4zWn2aNFCYiXEU3SMPlIPO8qJSSV6hFX5A=;
 b=mqpBbanSnk4E2X05kfKCazDuXik4f9LbIfTgvh4sUg3wHxX1oD6SYymxH3iufhtjT9
 XAkHs8jhsTsYM98DbdIO7tiMtD8XX1/GKTqHoJuWDSFZ48fGExjV0lbztrN1OhYuZ6aF
 aUNK5CYmAv5oBCp+/HGsE7Vte96MdAniuZyqhrjlV484JCJ/R+SUtI/G658iRI0zAGqH
 lWmijQzWK8YxfQWF4IbC8y/nUDml7tFfbP5yVhM36EVpOqYrd0Gnvd5uCbHNHhnindBh
 FB/8gz/zq8w9mfANAZe3Ecf/jZlC5l7MtpFoAcTZFUvDzgtDVaIJhrLSdNo4PNST/pps
 NZLw==
X-Gm-Message-State: AOAM531C5OprEyDX89ckOlf4tIabl0WUgmSlDLY+aI2sGJbBkXs8AgPY
 aWk9nyHUqg3Oa+AyFelXPe6HPnI3xfCMDNIeIvNxXKiifnJgsDRjIakHlVi6dRS3tv1JCN8IkXW
 +UvRqIiQ3GvC6Tg==
X-Received: by 2002:ac8:7d4e:0:b0:2f9:f97:2258 with SMTP id
 h14-20020ac87d4e000000b002f90f972258mr23605214qtb.355.1653490564046; 
 Wed, 25 May 2022 07:56:04 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxTz3epMa4cVr1cAB4KSP7Zdy4tAV0qEiscGFVIlUzsYOzPbqn+P/T+3vZsBljsN4kq/ribIg==
X-Received: by 2002:ac8:7d4e:0:b0:2f9:f97:2258 with SMTP id
 h14-20020ac87d4e000000b002f90f972258mr23605188qtb.355.1653490563731; 
 Wed, 25 May 2022 07:56:03 -0700 (PDT)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net.
 [68.160.176.52]) by smtp.gmail.com with ESMTPSA id
 139-20020a370591000000b006a34a22bc60sm1423995qkf.9.2022.05.25.07.56.03
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 25 May 2022 07:56:03 -0700 (PDT)
Date: Wed, 25 May 2022 10:56:02 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: Richard Fontana <rfontana@redhat.com>, Thomas Gleixner <tglx@linutronix.de>
Message-ID: <Yo5DgoAsR+lZfl4l@redhat.com>
References: <165322121770.3770149.18166071018834854082.tglx@xen13>
 <CAC1cPGz4CVCqb7P72sWjJ5S6s6HcxzqiwuykwGFswkovOuALHA@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAC1cPGz4CVCqb7P72sWjJ5S6s6HcxzqiwuykwGFswkovOuALHA@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
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
Cc: linux-spdx@vger.kernel.org, dm-devel@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Sun, May 22 2022 at  1:33P -0400,
Richard Fontana <rfontana@redhat.com> wrote:

> On Sun, May 22, 2022 at 10:55 AM Thomas Gleixner <tglx@linutronix.de> wrote:
> >
> > Richard!
> >
> > Sorry for pestering you, but the amount of files is just too much to split
> > it up and targetting the authors is difficult because quite some of them
> > are not longer at RHT. The files are all (c) RedHat or Sistina Software,
> > which is part of RedHat since 2003.
> >
> > This is part of the effort to clean up the licensing mess in the kernel and
> > convert it to SPDX license identifiers as the only source of license
> > information.
> >
> > Archaeology found the following unspecific GPL license references, which
> > have been authored by RedHat/Sistina.
> >
> > To clean this up, can you please either advise the RHT kernel team or let
> > me know which GPLv2 variant to use for the files and I run it through my
> > cleanup machinery.

Hi Thomas, yes I'd love for you to take on the changes to run through
your machinery.  I think we have consensus in that I agree with
everything Richard has said.  Proposed changes look good, thanks!

> Hi Thomas,
> 
> I assume you're selecting files that have some sort of Red Hat or
> Sistina copyright notice. Just as a disclaimer, I can't speak to
> copyrights in these files that may be held by other organizations or
> individuals (and I can't say definitively whether any file bearing a
> Red Hat or Sistina copyright notice has or retains any copyright owned
> by Red Hat). With that said:
> 
> > 1) this file is released under the gpl
> 
> I am fine with saying that any Red Hat copyrights (including any
> Sistina copyrights acquired by Red Hat) in these can be represented
> with SPDX-License-Identifier: GPL-2.0.
> 
> I would note that the following files did not seem to have any Red Hat
> or Sistina copyright notices:
> 
> >    drivers/md/dm-log-writes.c
> >    drivers/md/dm-ps-queue-length.c
> >    drivers/md/dm-ps-service-time.c
> >    drivers/md/dm-unstripe.c
> >    drivers/md/dm-zero.c

These can all have the following added:
SPDX-License-Identifier: GPL-2.0.

> Skipping category 2 for the moment:
> 
> > 3) (c) 2000 red hat gpl d
> 
> > 4) this code is covered by the gpl
> 
> > 5) this software may be freely redistributed under the terms of the gnu
> >    general public license you should have received a copy of the gnu general
> >    public license along with this program if not write to the free software
> >    foundation inc 675 mass ave cambridge ma 02139 usa
> 
> > 6) released under the general public license (gpl)
> 
> I am fine with saying that any Red Hat copyrights (including any
> Sistina copyrights acquired by Red Hat) in these can be represented
> with SPDX-License-Identifier: GPL-2.0.
> 
> > 2) this file is released under the lgpl
> >
> >    drivers/md/dm-core.h
> >    drivers/md/dm-log-userspace-base.c
> >    drivers/md/dm-log-userspace-transfer.c
> >    drivers/md/dm-log-userspace-transfer.h
> >    drivers/md/dm-log.c
> >    drivers/md/dm-rq.h
> >    drivers/md/dm.h
> >    include/linux/device-mapper.h
> >    include/linux/dm-dirty-log.h
> 
> For these, if the question is just about what version of the LGPL we
> should treat these as, I'd be fine with representing them as
> SDPX-License-Identifier: LGPL-2.1.
> 
> However, and I realize this may go beyond my 'remit' as someone
> consulted for linux-spdx stuff or open some additional bag of worms,
> I'm wondering if these would be better off just relicensed under
> GPLv2, and thus represented as SPDX-License-Identifier: GPL-2.0.

Yes, I think we should do that.

> Even treating this code as having been LGPLv2.x-licensed, this would be
> authorized or at any rate contemplated by the largely-overlooked
> LGPLv2.0/LGPLv2.1 section 3. Suggesting this because it would seem to
> help marginally with some of the goals of this initiative and also
> because it's not obvious to me why LGPL would have been preferred over
> GPLv2 for these files to begin with, assuming they weren't copied from
> some unrelated LGPL-licensed project. I've cc'd Jonathan Brassow and
> Mike Snitzer in case they have any thoughts on this.

Thanks for bringing me in the loop.  I appreciate it.
Right,  No real need for LGPL here (that I'm aware of).

Thomas: do you have all the answers you need?

Mike

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

