Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49EC8314A98
	for <dm-devel@lists.linux.dev>; Fri, 19 Sep 2025 15:09:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758294552; cv=none; b=YXygK85s3Qymn5rBzMPF4J0LKnlmMx1F2KEfBHJ4zBLyuWbV6sRUtiVW9rQb9XRxBLKg28J4LX+uR9jerZoaek/FHiuB8ggmSkT+fW+wKfdIp7+ZNuytC3CiDnH3eDUnFwZ/nuibIeIaHT7ZVqzq6wy9nwIPtIStyPqzdoYZa5E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758294552; c=relaxed/simple;
	bh=qy51F63LZQ8eWexvK0Dvjg/6381tO3jOZtCSeZQjtSI=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=mkbmcgteCEC4XO3BNuz6xi74CSbh8JDqt0PmXBlEDKYcdEj6I6mOUhTAETxrYTWw+w0IESKyr92MhEAu3/dIvPCC8lPw4CjmnfLnJevu6R0ns8/P9fUliVprz0tylU12OmFu2Y/w1mUfMQz81GHAbkAGFWpW0pWoiaaiTu6LvbA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Ho1EoU3x; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ho1EoU3x"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758294549;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=zsuMpZeXvItDjtspxXQy7Wf3X3QdSNz8CMpyREyoECQ=;
	b=Ho1EoU3xoWBV5lzCrBG/J3yO8D9LitkSbXk1AaLSR5IQDpv4jRlvW7jwZYZRcmrMzWlaeO
	3vRyQTX8hf6vYQNYV1D9WC1Jjia5mfg1kXTqJqh/7FFuNHshDtwXrukqT1VQmbXd2+cDHZ
	HA+h7syUfCSNH6sz6WC5iNalfGO0078=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-339-Go2gnSSENX6LxzHKjkOWyw-1; Fri,
 19 Sep 2025 11:09:07 -0400
X-MC-Unique: Go2gnSSENX6LxzHKjkOWyw-1
X-Mimecast-MFC-AGG-ID: Go2gnSSENX6LxzHKjkOWyw_1758294546
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 66EE31800578
	for <dm-devel@lists.linux.dev>; Fri, 19 Sep 2025 15:09:06 +0000 (UTC)
Received: from [10.45.225.219] (unknown [10.45.225.219])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1DCD430002C5;
	Fri, 19 Sep 2025 15:09:04 +0000 (UTC)
Date: Fri, 19 Sep 2025 17:08:59 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Heinz Mauelshagen <heinzm@redhat.com>
cc: Xiao Ni <xni@redhat.com>, dm-devel@lists.linux.dev
Subject: Re: [PATCH] dm raid: use proper md_ro_state enumerators
In-Reply-To: <CAM23VxqDkph_BtVdPqFXNAa85VAjabAJeG4-4qvooTrwHpD4BQ@mail.gmail.com>
Message-ID: <276e2287-9f27-3602-6085-5943991a5ca8@redhat.com>
References: <cover.1758201368.git.heinzm@redhat.com> <e14e3358a3b0acc015c01c61e6471e622a2dbe8f.1758201368.git.heinzm@redhat.com> <CALTww2_B88au2WmDFm6-EpkZSUUz9DkQ64=ak6j-Nif+y6kT6w@mail.gmail.com>
 <CAM23VxqDkph_BtVdPqFXNAa85VAjabAJeG4-4qvooTrwHpD4BQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Znk3hKu-umHMLbul-YiLTjwDNl_l7iQ9Ax3Yro9osfk_1758294546
X-Mimecast-Originator: redhat.com
Content-Type: multipart/mixed; boundary="-1463811712-462517313-1758294546=:2752752"

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.
---1463811712-462517313-1758294546=:2752752
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT



On Fri, 19 Sep 2025, Heinz Mauelshagen wrote:

> Xiao,
> 
> This aspect of the patch corrects an asymmetry in device-mapper suspend/resume handling where MD_RDWR/MD_RDONLY
> flag management is unbalanced (resume sets read-write, but post_suspend does't properly set read-only).  Not setting
> MD_RDONLY would e.g. cause md_submit_bio() to not error any writes when it should.
> 
> Although no failures have been attributed to this inconsistency, the fix ensures correct state transitions for completeness.
> However, we could additionally catch writes to a read-only array in the target's map function.

OK, thanks. I staged the patch and added this explanation to the patch 
header.

Mikulas

> - lvmguy
> 
> On Fri, Sep 19, 2025 at 3:20 AM Xiao Ni <xni@redhat.com> wrote:
>       Hi Heinz
> 
>       On Thu, Sep 18, 2025 at 9:55 PM Heinz Mauelshagen <heinzm@redhat.com> wrote:
>       >
>       > The dm-raid code was using hardcoded integer values to represent the read-only/read-write state
>       > of RAID arrays instead of the proper enumeration constants defined in the md_ro_state enumerator type.
>       >
>       > Changes:
>       >
>       > - Replace hardcoded integers with the appropriate md_ro_state enumerator values
>       >
>       > - Add the missing MD_RDONLY setting in the post_suspend function
> 
>       It should be the most important change in this patch. Mind adding the
>       reproducer in the commit message? And explain why you say missing it?
> 
>       Best Regards
>       Xiao
>       >
>       > This improves code clarity and maintainability by using the defined enumeration constants
>       > rather than magic numbers, ensuring the code properly conforms to the established API interface.
>       >
>       > Signed-off-by: Heinz Mauelshagen <heinzm@redhat.com>
>       > ---
>       >  drivers/md/dm-raid.c | 13 +++++++------
>       >  1 file changed, 7 insertions(+), 6 deletions(-)
>       >
>       > diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
>       > index 79ea85d18e24..6cdfd7ca998c 100644
>       > --- a/drivers/md/dm-raid.c
>       > +++ b/drivers/md/dm-raid.c
>       > @@ -3247,7 +3247,7 @@ static int raid_ctr(struct dm_target *ti, unsigned int argc, char **argv)
>       >         rs_reset_inconclusive_reshape(rs);
>       >
>       >         /* Start raid set read-only and assumed clean to change in raid_resume() */
>       > -       rs->md.ro = 1;
>       > +       rs->md.ro = MD_RDONLY;
>       >         rs->md.in_sync = 1;
>       >
>       >         /* Has to be held on running the array */
>       > @@ -3385,7 +3385,7 @@ static enum sync_state decipher_sync_action(struct mddev *mddev, unsigned long r
>       >         /* The MD sync thread can be done with io or be interrupted but still be running */
>       >         if (!test_bit(MD_RECOVERY_DONE, &recovery) &&
>       >             (test_bit(MD_RECOVERY_RUNNING, &recovery) ||
>       > -            (!mddev->ro && test_bit(MD_RECOVERY_NEEDED, &recovery)))) {
>       > +            (md_is_rdwr(mddev) && test_bit(MD_RECOVERY_NEEDED, &recovery)))) {
>       >                 if (test_bit(MD_RECOVERY_RESHAPE, &recovery))
>       >                         return st_reshape;
>       >
>       > @@ -3775,11 +3775,11 @@ static int raid_message(struct dm_target *ti, unsigned int argc, char **argv,
>       >                 } else
>       >                         return -EINVAL;
>       >         }
>       > -       if (mddev->ro == 2) {
>       > +       if (mddev->ro == MD_AUTO_READ) {
>       >                 /* A write to sync_action is enough to justify
>       >                  * canceling read-auto mode
>       >                  */
>       > -               mddev->ro = 0;
>       > +               mddev->ro = MD_RDWR;
>       >                 if (!mddev->suspended)
>       >                         md_wakeup_thread(mddev->sync_thread);
>       >         }
>       > @@ -3858,6 +3858,7 @@ static void raid_postsuspend(struct dm_target *ti)
>       >                  */
>       >                 md_stop_writes(&rs->md);
>       >                 mddev_suspend(&rs->md, false);
>       > +               rs->md.ro = MD_RDONLY;
>       >         }
>       >  }
>       >
>       > @@ -3968,7 +3969,7 @@ static void rs_update_sbs(struct raid_set *rs)
>       >         int ro = mddev->ro;
>       >
>       >         set_bit(MD_SB_CHANGE_DEVS, &mddev->sb_flags);
>       > -       mddev->ro = 0;
>       > +       mddev->ro = MD_RDWR;
>       >         md_update_sb(mddev, 1);
>       >         mddev->ro = ro;
>       >  }
>       > @@ -4125,7 +4126,7 @@ static void raid_resume(struct dm_target *ti)
>       >                 WARN_ON_ONCE(rcu_dereference_protected(mddev->sync_thread,
>       >                                                        lockdep_is_held(&mddev->reconfig_mutex)));
>       >                 clear_bit(RT_FLAG_RS_FROZEN, &rs->runtime_flags);
>       > -               mddev->ro = 0;
>       > +               mddev->ro = MD_RDWR;
>       >                 mddev->in_sync = 0;
>       >                 md_unfrozen_sync_thread(mddev);
>       >                 mddev_unlock_and_resume(mddev);
>       > --
>       > 2.51.0
>       >
>       >
> 
> 
> 
---1463811712-462517313-1758294546=:2752752--

