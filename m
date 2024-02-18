Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8ADA6E546
	for <dm-devel@lists.linux.dev>; Sun, 18 Feb 2024 05:56:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708235781; cv=none; b=t7vKIHGxusgFYvg3wooNxLZ0iHdt+LKd8W5TooGHqsCCtKtfUjHMpOvG5l2lalm2TBv+XC/pniRZgPnROu9FBbijGexgB40fNA1bhewAUVpB1XOk5OTVm0MY+oBHcE+6mCY8syUj8uxSFrxVXFnrVP/j+ns2BFu4uqDZblZ6iIo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708235781; c=relaxed/simple;
	bh=ykciOYIUf3ziL/MfvckOIh5TxEtXF0aoZrWYpsipNEg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=HD9HgVGjXGsPpNlEPNoyAXu3xu8FtyNtsP5ujVOszX1LeapHelPO9dXTmH9GuciWAaUyO+UUU0CyjHwwMrJB6EEa/sPr5Ad3VFSQsiFd1Sa25sdrYqh16FLP0IBoGWi84O5SdDzPX0ytBhGUPzaxZVVhSrCyb1C8ETcZ+W7A9YA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=N86D5dVB; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="N86D5dVB"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1708235777;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Can3YssHnCfkpH1KexyMkQMSXqdagr3d1VhL/3Id/+U=;
	b=N86D5dVBXRiqJ9p8HqnDDgwlJ1uCWuLNEBGP2kJgqh75/iXoVWwOGZuntHlX37bH45sef3
	sPJPBnFzFEiYe9VrvPcJ9W2yxLsYMBkk9zzXNWtY4/G1LhQr1EwOP4MzU6SYWLLGV1x5u2
	JGNMVubKwqLaU8FoYkrIW52k/YoQ2S0=
Received: from mail-oo1-f69.google.com (mail-oo1-f69.google.com
 [209.85.161.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-281-6LnVIZw8PW-UdV5QBeaqvw-1; Sun, 18 Feb 2024 00:56:16 -0500
X-MC-Unique: 6LnVIZw8PW-UdV5QBeaqvw-1
Received: by mail-oo1-f69.google.com with SMTP id 006d021491bc7-5997417c351so2544419eaf.2
        for <dm-devel@lists.linux.dev>; Sat, 17 Feb 2024 21:56:15 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708235775; x=1708840575;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Can3YssHnCfkpH1KexyMkQMSXqdagr3d1VhL/3Id/+U=;
        b=bznMJhP7hHm5gVVZbzYWs5sP3LKuBJbV8BZfCWcIrIs/lbtwf5qH0lnrhfmj5TkDd9
         /KIavIdlL5N32Mp+d3e7OcnfXzqQ3fK70+xSjfKAJcVGjTXfdXI+e4gvlDCBlvgTAw4s
         yIfVWwslPAWQDaXQQo2G2ukVxS8tE0SxxM3bP95+5n+ydLEyIZuYTkTA0DZbAvWw1JU/
         7dSR2O9H/hc9fixqsgyzf+P2Uj3lJVvdo6zYEyCxq1hXdr5rZlxFAVUHYqv751wy9rB6
         1HBPNdLDwxaZHwe5kFOPHpSozaz3DCIBmPChKcy0QcUhhudP4rgQ2jjYtDMZuD/YwaXK
         8j/w==
X-Forwarded-Encrypted: i=1; AJvYcCV2kC1QzIu4aZdafokjlkTlad0m0imgpj+y7s3U7cevSEhkv6BK95pMPf0jrhwjOnsPcHNbgYsREzYgZAngboCqovPKbzpADM4=
X-Gm-Message-State: AOJu0Yzbt3Fez7VZotSKZqsRqdVkfkORLq0vYfNqRK1YBSLRURYfJuhQ
	NVjqyo6SGApH1Gj5S01axCSp3pOj1pzgL/fNUOFJeeeEuy2frnhJwhxUwgdG6nAn0+N6NwebRY1
	1Nhq1HUY5OK3f5ZsoTnHM5A/is97JAMtpU+WyecIXX4T1vO6igZLN3zSVbOVUq6I9RUI2y4HqhK
	chRHspjxvPB/Ioy+dp8rT+qmTx/l+pkkY=
X-Received: by 2002:a05:6359:4c23:b0:17b:426d:74f3 with SMTP id kj35-20020a0563594c2300b0017b426d74f3mr85576rwc.29.1708235775255;
        Sat, 17 Feb 2024 21:56:15 -0800 (PST)
X-Google-Smtp-Source: AGHT+IG1oH3m48AGF5d9LWhpYqM/Ix7rL56PvuuMXgyGuIZ4+ENeuNFaOoxZhB6pcFZriK0iTrvDr5pU0tSWKeTn3pY=
X-Received: by 2002:a05:6359:4c23:b0:17b:426d:74f3 with SMTP id
 kj35-20020a0563594c2300b0017b426d74f3mr85561rwc.29.1708235774919; Sat, 17 Feb
 2024 21:56:14 -0800 (PST)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240201092559.910982-1-yukuai1@huaweicloud.com> <20240201092559.910982-4-yukuai1@huaweicloud.com>
In-Reply-To: <20240201092559.910982-4-yukuai1@huaweicloud.com>
From: Xiao Ni <xni@redhat.com>
Date: Sun, 18 Feb 2024 13:56:03 +0800
Message-ID: <CALTww283nysUDy=jmW4w45GbS6O2nS0XLYX=KEiO2BUp5+cLaA@mail.gmail.com>
Subject: Re: [PATCH v5 03/14] md: make sure md_do_sync() will set MD_RECOVERY_DONE
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
> stop_sync_thread() will interrupt md_do_sync(), and md_do_sync() must
> set MD_RECOVERY_DONE, so that follow up md_check_recovery() will
> unregister sync_thread, clear MD_RECOVERY_RUNNING and wake up
> stop_sync_thread().
>
> If MD_RECOVERY_WAIT is set or the array is read-only, md_do_sync() will
> return without setting MD_RECOVERY_DONE, and after commit f52f5c71f3d4
> ("md: fix stopping sync thread"), dm-raid switch from
> md_reap_sync_thread() to stop_sync_thread() to unregister sync_thread
> from md_stop() and md_stop_writes(), causing the test
> shell/lvconvert-raid-reshape.sh hang.
>
> We shouldn't switch back to md_reap_sync_thread() because it's
> problematic in the first place. Fix the problem by making sure
> md_do_sync() will set MD_RECOVERY_DONE.
>
> Reported-by: Mikulas Patocka <mpatocka@redhat.com>
> Closes: https://lore.kernel.org/all/ece2b06f-d647-6613-a534-ff4c9bec1142@=
redhat.com/
> Fixes: d5d885fd514f ("md: introduce new personality funciton start()")
> Fixes: 5fd6c1dce06e ("[PATCH] md: allow checkpoint of recovery with versi=
on-1 superblock")
> Fixes: f52f5c71f3d4 ("md: fix stopping sync thread")
> Signed-off-by: Yu Kuai <yukuai3@huawei.com>
> ---
>  drivers/md/md.c | 12 ++++++++----
>  1 file changed, 8 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 6906d023f1d6..c65dfd156090 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -8788,12 +8788,16 @@ void md_do_sync(struct md_thread *thread)
>         int ret;
>
>         /* just incase thread restarts... */
> -       if (test_bit(MD_RECOVERY_DONE, &mddev->recovery) ||
> -           test_bit(MD_RECOVERY_WAIT, &mddev->recovery))
> +       if (test_bit(MD_RECOVERY_DONE, &mddev->recovery))
>                 return;
> -       if (!md_is_rdwr(mddev)) {/* never try to sync a read-only array *=
/
> +
> +       if (test_bit(MD_RECOVERY_INTR, &mddev->recovery))
> +               goto skip;
> +
> +       if (test_bit(MD_RECOVERY_WAIT, &mddev->recovery) ||
> +           !md_is_rdwr(mddev)) {/* never try to sync a read-only array *=
/
>                 set_bit(MD_RECOVERY_INTR, &mddev->recovery);
> -               return;
> +               goto skip;
>         }

Hi all

I have a question here. The codes above means if MD_RECOVERY_WAIT is
set, it sets MD_RECOVERY_INTR. If so, the sync thread can't happen.
But from the codes in md_start function:

                set_bit(MD_RECOVERY_WAIT, &mddev->recovery);
                md_wakeup_thread(mddev->thread);
                ret =3D mddev->pers->start(mddev);
                clear_bit(MD_RECOVERY_WAIT, &mddev->recovery);
                md_wakeup_thread(mddev->sync_thread);

MD_RECOVERY_WAIT means "it'll run sync thread later not interrupt it".
I guess this patch can introduce a new bug for raid5 journal?

And to resolve this deadlock, we can use this patch:

--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -3796,8 +3796,10 @@ static void raid_postsuspend(struct dm_target *ti)
        struct raid_set *rs =3D ti->private;

        if (!test_and_set_bit(RT_FLAG_RS_SUSPENDED, &rs->runtime_flags)) {
+               if (test_bit(MD_RECOVERY_WAIT, &rs->md.recovery))
+                       clear_bit(MD_RECOVERY_WAIT, &rs->md.recovery);

Regards
Xiao
>
>         if (mddev_is_clustered(mddev)) {
> --
> 2.39.2
>

