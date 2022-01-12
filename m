Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 91833C433F5
	for <dm-devel@archiver.kernel.org>; Wed, 12 Jan 2022 16:24:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1642004693;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=5KEemN+ruThGSeZqlN+r3hRvlpYWjLsvHHN7cFEQP9o=;
	b=amywJNrjZvhvCGkvGOjP7+lerceTcr6NHrVMSNk0rLOOv+2FKM27OgT0w9RPH1X4b+EioN
	R1hr2Me3bZanl1dI4vKrGVRMsq6dblpx5piFL0cbV3Ids8V27lpa2HBbUb3tt1WrtRA2h1
	EOpkjkrc7k8GrrdxTjohKHQuO+qnGj0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-438-BBCbQYruPW2wKLa-LuijcA-1; Wed, 12 Jan 2022 11:24:52 -0500
X-MC-Unique: BBCbQYruPW2wKLa-LuijcA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2A42F81CCB6;
	Wed, 12 Jan 2022 16:24:48 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 4903C7DE5A;
	Wed, 12 Jan 2022 16:24:46 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 2EE9A4CA93;
	Wed, 12 Jan 2022 16:24:44 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
	[10.11.54.8])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 20CGOXa6027906 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 12 Jan 2022 11:24:33 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 070BEC4C7A5; Wed, 12 Jan 2022 16:24:33 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 030D5C4C7A0
	for <dm-devel@redhat.com>; Wed, 12 Jan 2022 16:24:32 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D8C3D1C093F2
	for <dm-devel@redhat.com>; Wed, 12 Jan 2022 16:24:32 +0000 (UTC)
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
	[209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-438-Gxa_3IwTNrCtT7kjS458_w-1; Wed, 12 Jan 2022 11:24:31 -0500
X-MC-Unique: Gxa_3IwTNrCtT7kjS458_w-1
Received: by mail-qk1-f197.google.com with SMTP id
	br12-20020a05620a460c00b004781fdc9944so2213388qkb.1
	for <dm-devel@redhat.com>; Wed, 12 Jan 2022 08:24:31 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
	:content-disposition;
	bh=K9t/QyNYgC/u/98MlWWWeCxOnDJcq4vk+x/vzUZHkCI=;
	b=up3YXkamavQZJK7HNCK+UAdGJqPqCV68LWZZLVy17LV4r4ssABRHYnRuiD97YLoMo7
	IFZonnr9YuQPa/k86p8KOZdkPXkbaROfOORA5l2BSUP07m8zCwtXdOH9/41nDwn5TfHX
	WOxMe1GeBYE4Id0KLIGxoHBJoVjyAOUTDo4XTTUD/t5faaCLJDv71YI3TIJEruqDMLrD
	SaOThlHHxw5QUS7q+hwHHUxYtfVLhHdSp6Weq6PHTuWEdEQbqejDq5AB7ze9fYujHqYt
	eEukcerwlt4f8+tAWh+VRAVCgC+dUmReN1pAowyKBjowXBxie1WUMehwMpL05UC0zq6t
	jHnA==
X-Gm-Message-State: AOAM533gfyCU4xCzED9GYsXEbp5Tk4sDekwgKFyPXfNXO7mNydulfti6
	pwkvQwu2+lk/KIEmWxgiM1JT1fIc+NPzyICqYXZ28b3bzLKI4fDR0uVaGEDYqbOaPiqaKwicPVj
	4Th7eeVkV5jeDzA==
X-Received: by 2002:a05:620a:470f:: with SMTP id
	bs15mr374248qkb.246.1642004671151; 
	Wed, 12 Jan 2022 08:24:31 -0800 (PST)
X-Google-Smtp-Source: ABdhPJw8lSelr28m+//ajK7hUfZdmxYtAbWM43Sg5O0Q8BHEHnwkIhq2Wfe+hTeXjlnWzzmTLTQy7w==
X-Received: by 2002:a05:620a:470f:: with SMTP id
	bs15mr374235qkb.246.1642004670915; 
	Wed, 12 Jan 2022 08:24:30 -0800 (PST)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net.
	[68.160.176.52])
	by smtp.gmail.com with ESMTPSA id d17sm132541qtx.96.2022.01.12.08.24.30
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Wed, 12 Jan 2022 08:24:30 -0800 (PST)
Date: Wed, 12 Jan 2022 11:24:29 -0500
From: Mike Snitzer <snitzer@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Message-ID: <Yd8AveH8D+Nk2ILp@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
X-loop: dm-devel@redhat.com
Cc: Kees Cook <keescook@chromium.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Joe Thornber <ejt@redhat.com>, linux-block@vger.kernel.org,
	dm-devel@redhat.com, Alasdair G Kergon <agk@redhat.com>
Subject: [dm-devel] [git pull] device mapper changes for 5.17
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi Linus,

The following changes since commit fc74e0a40e4f9fd0468e34045b0c45bba11dcbb2:

  Linux 5.16-rc7 (2021-12-26 13:17:17 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/for-5.17/dm-changes

for you to fetch changes up to eaac0b590a47c717ef36cbfd1c528cd154c965a1:

  dm sysfs: use default_groups in kobj_type (2022-01-06 09:48:55 -0500)

Please pull, thanks.
Mike

----------------------------------------------------------------
- Fixes and improvements to dm btree and dm space map code in
  persistent-data library used by thinp and cache.

- Update DM integrity to use struct_group() to zero struct
  journal_sector.

- Update DM sysfs to use default_groups in kobj_type.

----------------------------------------------------------------
Greg Kroah-Hartman (1):
      dm sysfs: use default_groups in kobj_type

Joe Thornber (5):
      dm btree spine: remove extra node_check function declaration
      dm btree spine: eliminate duplicate le32_to_cpu() in node_check()
      dm btree remove: change a bunch of BUG_ON() calls to proper errors
      dm btree: add a defensive bounds check to insert_at()
      dm space map common: add bounds check to sm_ll_lookup_bitmap()

Kees Cook (1):
      dm integrity: Use struct_group() to zero struct journal_sector

 drivers/md/dm-integrity.c                        |   9 +-
 drivers/md/dm-sysfs.c                            |   3 +-
 drivers/md/persistent-data/dm-btree-remove.c     | 173 ++++++++++++++++-------
 drivers/md/persistent-data/dm-btree-spine.c      |  12 +-
 drivers/md/persistent-data/dm-btree.c            |   8 +-
 drivers/md/persistent-data/dm-space-map-common.c |   5 +
 6 files changed, 145 insertions(+), 65 deletions(-)

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

