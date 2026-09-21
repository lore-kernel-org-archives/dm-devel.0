Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82B874A6887
	for <dm-devel@lists.linux.dev>; Mon, 21 Sep 2026 14:29:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790000999; cv=none; b=Tx3M2fqxyELzgtFSN3g5Pz0sn2iPU41E5uoWmij0KAKD57abqyu8+TYOg/ebKPErRAPuMdpA8JniSKnddWCkvWsXcteCQMLM/7nKpbnXM7bYCgKaEJfl5vpTTCt1jZ1yIIoEcCMG8CmsJuaJFRxMA6YwLpTSmviXBrFmoc8Xk0o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790000999; c=relaxed/simple;
	bh=aHmSDEox5unyo5rBT5HswPBoY3cjScx7iK573f2E5hg=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=h2JY0lwPCPsNhckIs35lVTuVBbsahn8+d89jM9umYyDHUemdOUZb7KALrsY82ktoA6Chgz4+Tnj6CsLqh39NxnVmg+aJl1X/9073rTZNHDPWs8VS5wzQ3zvCfo6/vpguk0gmcVfM23jSESD/oNkydlF0sRRzA/XoDyZebNaRtn0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=XzaLaTLl; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XzaLaTLl"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790000996;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2SPlmkLvWk9PpLgPSN8V3xc5g1sWFhg/iDECwVzzJ4c=;
	b=XzaLaTLlwNIhyT5EM+Z79p0Zg2OCNmlotXJuQ1coFGo2DtRZlIeqVEeXKPZYGLmKUDAvLZ
	Ezbyw7qPLM97KdietRa2F7RPl1cV9bSqoIa96L4frLGcYz7sqM3rA0yaWkJRQEHVSKlJcI
	kKEzpCX7Dv3icHy+q7T/gYh1UNVfvtY=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-564-2wbglG7APSmlHI_acoQYzw-1; Mon,
 21 Sep 2026 10:29:51 -0400
X-MC-Unique: 2wbglG7APSmlHI_acoQYzw-1
X-Mimecast-MFC-AGG-ID: 2wbglG7APSmlHI_acoQYzw_1790000989
Received: from mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.95])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 832A318011D4;
	Mon, 21 Sep 2026 14:29:49 +0000 (UTC)
Received: from mpatocka-thinkpadx1carbongen12.rmtcz.csb (headnet03.pony-001.prod.iad2.dc.redhat.com [10.2.32.114])
	by mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 2849641B;
	Mon, 21 Sep 2026 14:29:45 +0000 (UTC)
Date: Mon, 21 Sep 2026 16:29:43 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Palla Raghunath <raghunathpalla.0209@gmail.com>
cc: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, 
    Benjamin Marzinski <bmarzins@redhat.com>, Milan Broz <mbroz@redhat.com>, 
    dm-devel@lists.linux.dev, Shuah Khan <shuah@kernel.org>, 
    Brigham Campbell <me@brighamcampbell.com>, linux-kernel@vger.kernel.org, 
    linux-kernel-mentees@lists.linux.dev, 
    syzbot+48d935cf48a4a76be346@syzkaller.appspotmail.com
Subject: Re: [PATCH] dm ioctl: don't let data_start run past the buffer
In-Reply-To: <20260918234339.54105-1-raghunathpalla.0209@gmail.com>
Message-ID: <956ce83b-ef24-56f1-d70a-f7378f55cdf8@redhat.com>
References: <20260918234339.54105-1-raghunathpalla.0209@gmail.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.6 on 10.30.177.95
X-Mimecast-MFC-PROC-ID: _rHJs9i7AToliWRel-M4dckH1e-eL_xfPs6OBu45O4g_1790000989
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII



On Sat, 19 Sep 2026, Palla Raghunath wrote:

> struct dm_ioctl has seven bytes of trailing padding, so the smallest
> buffer userspace is allowed to ask for, offsetof(struct dm_ioctl, data),
> is seven bytes shorter than sizeof(struct dm_ioctl).
> 
> get_result_buffer() sets data_start to sizeof(struct dm_ioctl) without
> looking at how big the buffer actually is. Ask for the minimum and
> data_start ends up seven bytes past the end. Callers add it to
> data_size, and ctl_ioctl() copies that much back to userspace:
> 
>   BUG: KASAN: slab-out-of-bounds in _copy_to_user+0xad/0xd0
>   Read of size 312 at addr ffff8880169e4c00 by task repro-dm/140
>    ctl_ioctl+0x5e3/0xcb0
>    dm_ctl_ioctl+0x25/0x40
>   allocated 305-byte region [ffff8880169e4c00, ffff8880169e4d31)
> 
> A DM_LIST_DEVICES with data_size set to 305 is enough to hit it, and the
> seven bytes that leak are whatever sat next to the allocation.
> 
> Clamp data_start to the buffer size.
> 
> Reported-by: syzbot+48d935cf48a4a76be346@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=48d935cf48a4a76be346
> Fixes: 76c072b48e39 ("dm ioctl: move compat code")
> Cc: stable@vger.kernel.org
> Signed-off-by: Palla Raghunath <raghunathpalla.0209@gmail.com>
> ---
>  drivers/md/dm-ioctl.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/drivers/md/dm-ioctl.c b/drivers/md/dm-ioctl.c
> index a6b8e97755cd..211569dd3c54 100644
> --- a/drivers/md/dm-ioctl.c
> +++ b/drivers/md/dm-ioctl.c
> @@ -656,6 +656,13 @@ static void *get_result_buffer(struct dm_ioctl *param, size_t param_size,
>  {
>  	param->data_start = align_ptr(param + 1) - (void *) param;
>  
> +	/*
> +	 * The buffer can be as small as offsetof(*param, data), which is
> +	 * less than sizeof(*param), so don't run off the end of it.
> +	 */
> +	if (param->data_start > param_size)
> +		param->data_start = param_size;
> +
>  	if (param->data_start < param_size)
>  		*len = param_size - param->data_start;
>  	else
> -- 
> 2.34.1

Hi

I accepted the patch, but I changed it slightly, so that there is just one 
condition in get_result_buffer. The resulting function is:

static void *get_result_buffer(struct dm_ioctl *param, size_t param_size,
                               size_t *len)
{
        param->data_start = align_ptr(param + 1) - (void *) param;

        if (param->data_start < param_size) {
                *len = param_size - param->data_start;
        } else {
                /*
                 * The buffer can be as small as offsetof(*param, data), which
                 * is less than sizeof(*param), so don't run off the end of it.
                 */
                *len = 0;
                param->data_start = param_size;
        }

        return ((void *) param) + param->data_start;
}

Mikulas

