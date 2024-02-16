Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D812D179AB
	for <dm-devel@lists.linux.dev>; Fri, 16 Feb 2024 06:58:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708066737; cv=none; b=aw2Kt8dUO2+SO9AQ1wqMRs1GyG3z4bf6ZS9FFgujFyrF5gKrQO+uL0qUicEZ5gwpo7iHgymISZXDU3IgbBxJT07dF1du1NsmsReRvU2Jo5FUjy7xF9XQsLBGWRLI7qcxTSf1zp0XgXNCoz9r+azvojRaVNj2nOlvHsyWFKdkElU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708066737; c=relaxed/simple;
	bh=YROb+eaJNu6/59TKOvdKSLmQg7w+kXyN6IwLF2JJH4s=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=g03S8/ZeWoOBniL40JezqyLPCnvJJVxCkNvfeFvUzumr5Hso3W3vklg0nWWAYkVJf8/Fobl++XxknFKm89k1oceULMFX3+/zUefQj6z8FmvTdGigm2asROcDq6ZZ+KIRj4mW3zOe/I/cruRCSVWWp7FhAexoaPDXo5xNTR1/wOw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=BlrJsITI; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BlrJsITI"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1708066734;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BNMvTmeWJ1ziFBp7Mx8IpeakAHCa+fvWpYKZaRcTpWg=;
	b=BlrJsITIvMgsXd9YFdy2p2nydycBakcFo90DKTq+I3KNLnJibmzGRTzgDobwz9Hkl+wF2+
	9nMTb4Oy3zqbJPnElF0Ti0b/8zn4KgiEz8cmpv8xIUOhG0h0I3wvMc08BoV4XMkj9d2JnR
	v8yaYufstArdEL8xZ1ed0Y1FD3M0ue4=
Received: from mail-ot1-f71.google.com (mail-ot1-f71.google.com
 [209.85.210.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-194-XdQmTu4_PFSBWqoEdyOjqw-1; Fri, 16 Feb 2024 01:58:52 -0500
X-MC-Unique: XdQmTu4_PFSBWqoEdyOjqw-1
Received: by mail-ot1-f71.google.com with SMTP id 46e09a7af769-6e103d403c4so2003896a34.0
        for <dm-devel@lists.linux.dev>; Thu, 15 Feb 2024 22:58:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708066732; x=1708671532;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BNMvTmeWJ1ziFBp7Mx8IpeakAHCa+fvWpYKZaRcTpWg=;
        b=Uu7xuxLeZkCM+V5A+wT3hGPC3ObVAuahbYpm7xvc+rjbY4OB+y441PKTB5djH2gxvx
         prip8EjG3ugmcvMDFZ56RTZ44A3cSYiP/tCBjmiFzI+xuuz9s1GPAIuNNul4dPo3A0My
         Vp5cc5SMk+ts6yOuX18BHEeFyVwp7RrOU6HGrUAl+V3IEPkQnmYEaSmuKDxGA9GzOwwJ
         2HHQeFAyHA9NjffW1oqyzdH9Uv/7QPViCAEh6og0w4shjKqTPvQmS4kGV4k0txLY7gtq
         5eUgE8K3BapB8JvBzKvxrzeCcfEf+jTPngbhszD8GsdV/N/8RYROqG2UKdUG4pon4DXV
         nDOQ==
X-Forwarded-Encrypted: i=1; AJvYcCUkxooyWzDuY93fkbjt3IDRMSVxs/t8wNcexkk0Y3r8DdzFOz0DSxTd16fznL6fujwv0Qr/ki3QNRgYZsKL3WdYhEMTghD8OVs=
X-Gm-Message-State: AOJu0YwA/6epMSy9fGye3cb5ZmLuFPdLqGGtvUKV43+M0prxFtRhBqz1
	Rd6aF6wpuejQSzEiCDXGTRlWzP1gvRyS6ywfc8Cwmt/pGdmT+6d2XSnMtG2f9K9NDb4xAflejv9
	YiGg86vW+3m6ZIbr6SV5mwjeBKbQi5Wb0xkNu+1g2oOHUBXPqEGDhIazsDBTEVOd2yRbbJ1d9qA
	9MiXaivqq6KaJB5mWyyAnNWIGpgRy4Fgc=
X-Received: by 2002:a05:6358:d04c:b0:178:7c7b:77bd with SMTP id jb12-20020a056358d04c00b001787c7b77bdmr4796304rwb.27.1708066732244;
        Thu, 15 Feb 2024 22:58:52 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEIS1mWsDcddpPxFekpeD1h3hjt8dIDVsyUqaSy4AgJ7AmFMXEA/DB1AOZvjCvNo30ZSH6kg0YD0Di4qNWMKJg=
X-Received: by 2002:a05:6358:d04c:b0:178:7c7b:77bd with SMTP id
 jb12-20020a056358d04c00b001787c7b77bdmr4796292rwb.27.1708066731962; Thu, 15
 Feb 2024 22:58:51 -0800 (PST)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240201092559.910982-1-yukuai1@huaweicloud.com> <20240201092559.910982-2-yukuai1@huaweicloud.com>
In-Reply-To: <20240201092559.910982-2-yukuai1@huaweicloud.com>
From: Xiao Ni <xni@redhat.com>
Date: Fri, 16 Feb 2024 14:58:40 +0800
Message-ID: <CALTww2-ZhRBJOD3jXs=xKFaD=iR=dtoC9h2rUQi5Stpi+tJ9Bw@mail.gmail.com>
Subject: Re: [PATCH v5 01/14] md: don't ignore suspended array in md_check_recovery()
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: mpatocka@redhat.com, heinzm@redhat.com, blazej.kucman@linux.intel.com, 
	agk@redhat.com, snitzer@kernel.org, dm-devel@lists.linux.dev, song@kernel.org, 
	yukuai3@huawei.com, jbrassow@f14.redhat.com, neilb@suse.de, shli@fb.com, 
	akpm@osdl.org, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, 
	yi.zhang@huawei.com, yangerkun@huawei.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 1, 2024 at 5:30=E2=80=AFPM Yu Kuai <yukuai1@huaweicloud.com> wr=
ote:
>
> From: Yu Kuai <yukuai3@huawei.com>
>
> mddev_suspend() never stop sync_thread, hence it doesn't make sense to
> ignore suspended array in md_check_recovery(), which might cause
> sync_thread can't be unregistered.
>
> After commit f52f5c71f3d4 ("md: fix stopping sync thread"), following
> hang can be triggered by test shell/integrity-caching.sh:

Hi Kuai

After applying this patch, it's still stuck at mddev_suspend. Maybe
the deadlock can be fixed by other patches from the patch set. But
this patch can't fix this issue. If so, the comment is not right.

>
> 1) suspend the array:
> raid_postsuspend
>  mddev_suspend
>
> 2) stop the array:
> raid_dtr
>  md_stop
>   __md_stop_writes
>    stop_sync_thread
>     set_bit(MD_RECOVERY_INTR, &mddev->recovery);
>     md_wakeup_thread_directly(mddev->sync_thread);
>     wait_event(..., !test_bit(MD_RECOVERY_RUNNING, &mddev->recovery))
>
> 3) sync thread done:
> md_do_sync
>  set_bit(MD_RECOVERY_DONE, &mddev->recovery);
>  md_wakeup_thread(mddev->thread);
>
> 4) daemon thread can't unregister sync thread:
> md_check_recovery
>  if (mddev->suspended)
>    return; -> return directly
>  md_read_sync_thread
>  clear_bit(MD_RECOVERY_RUNNING, &mddev->recovery);
>  -> MD_RECOVERY_RUNNING can't be cleared, hence step 2 hang;

I add some debug logs when stopping dmraid with lvremove command. The
step you mentioned are sequential but not async. The process is :
dev_remove->dm_destroy->__dm_destroy->dm_table_postsuspend_targets(raid_pos=
tsuspend)
-> dm_table_destroy(raid_dtr). It looks like mddev_suspend is waiting
for active_io to be zero.

Best Regards
Xiao

> This problem is not just related to dm-raid, fix it by ignoring
> suspended array in md_check_recovery(). And follow up patches will
> improve dm-raid better to frozen sync thread during suspend.
>
> Reported-by: Mikulas Patocka <mpatocka@redhat.com>
> Closes: https://lore.kernel.org/all/8fb335e-6d2c-dbb5-d7-ded8db5145a@redh=
at.com/
> Fixes: 68866e425be2 ("MD: no sync IO while suspended")
> Fixes: f52f5c71f3d4 ("md: fix stopping sync thread")
> Signed-off-by: Yu Kuai <yukuai3@huawei.com>
> ---
>  drivers/md/md.c | 3 ---
>  1 file changed, 3 deletions(-)
>
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 2266358d8074..07b80278eaa5 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -9469,9 +9469,6 @@ static void md_start_sync(struct work_struct *ws)
>   */
>  void md_check_recovery(struct mddev *mddev)
>  {
> -       if (READ_ONCE(mddev->suspended))
> -               return;
> -
>         if (mddev->bitmap)
>                 md_bitmap_daemon_work(mddev);
>
> --
> 2.39.2
>

