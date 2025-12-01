Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90858333433
	for <dm-devel@lists.linux.dev>; Mon,  1 Dec 2025 16:09:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764605362; cv=none; b=QmDBhlwqbYewXNJQ6FBu2F4q3qXOmzHvIOgI1f2DmCzIg1rM0WnOd7kzCHhP3DvBEEacRcWXrSKDI1jNaNO7DqH3aiU2j9nHzrdzqaSh/6SDBKxyea/TbB3N41i6k3MDDF/ZxK3bNc0Wz/rhXc+fsUFeb9mTiVYluXMoYMu/gI8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764605362; c=relaxed/simple;
	bh=5RoL+fp9XjGDbCpZK0NIe1QvYIElYxbNc1FCNOfVE00=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=GjI3VpuGwOm8svqM3vRBNxgbXVKzjZhuEMUveo9/VeVYePgqh4q+MOJAcqJcBEazZWvb49Nw9Ka7YkvKDtgTC69BEjIjm/tHVcRj5uQNXUvhjgzeHGL7O/mbjem+n6UbhtMoahrd3Rzu5/m55rT2zhlJerNm0+53x7sTO7s7JAE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CADxznFc; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CADxznFc"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764605359;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=MiRv4MTl2AcQ9/cR/lkFxmvu84n90A6LnmUyKbUDdic=;
	b=CADxznFcd7fFfDe++Fl+fj+RbVRd9UxX4PRejqCnAinkWByqVmTp4vquzNo1aFzn6sa9mB
	YZpfGe/6vWfOn/Wt82GI7xmAiOjkCw/obg0PV6Au+fyfdwTXY+kUgsbEsVvJ481yf9VSYw
	VncuLy5H7iV8lZuU6cgk5R5JtTN7+tI=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-463-7OlfBU4GPI2CqLCx4QxjSQ-1; Mon, 01 Dec 2025 11:09:17 -0500
X-MC-Unique: 7OlfBU4GPI2CqLCx4QxjSQ-1
X-Mimecast-MFC-AGG-ID: 7OlfBU4GPI2CqLCx4QxjSQ_1764605357
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-477a0ddd1d4so25810865e9.0
        for <dm-devel@lists.linux.dev>; Mon, 01 Dec 2025 08:09:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764605357; x=1765210157;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MiRv4MTl2AcQ9/cR/lkFxmvu84n90A6LnmUyKbUDdic=;
        b=GVfqdZZVAqz2V48saTPsa8YOrmrqKUw4xXgt9xBusWBjp9XY+2NYJUglEI7dnpES2O
         DHAmazCToGux+7cUyGic/yNk8GSolBwreAV+bKCCenqs3ySd8+WMZ2D89ZHTwb6IFPHQ
         TYhekW2xCuuBRh5mhCyeDTvDJP4cA64j7rbehi/+4/GsYJgorASK6HZnqd3zwSaNHRaO
         Aklm3Ni0EIMXXXKC3kZUoqt7RLg4ZVuJJsrfyA8e6gYSiRohsVWqhEDdjcHcuGcYAZlb
         9iWv4iefBuTeCltajahy7pg3Gp6mGaImLPO7oUVl7zCpLnDt634iW5HSDzgVZzlE3hBD
         KjHQ==
X-Gm-Message-State: AOJu0YzSU6bGzXZxmiUFhHUDd1TK/zvf7KsLju7xpaEDioVnvwQ1z2Vp
	MWCPzvK+JIN+Vrc99bWJuOklmHY5YKdvPAab2t1TgS0C/u5KUiAUyY31LXbRWG6pyBOAsvakzX8
	6sutMVZv+qr4RCsQLJLPP6gELR89CO5Su3UUtGUA+T5QJ6McGfJ7gwSiu5h4E
X-Gm-Gg: ASbGncvmaXPwmX0AsdzfTO7NgDjoCyIf201/Z0i+RPBqcAqtP3tHIkUiFLoMqi0IPxw
	1P8OvlBkE5IpEXeLsflqEYtP1wt61zJcOUNa+AFyr4SzH1zhGIm4UUJxYVKlKb/72gKZ3vsrllM
	Uvrbpb7O6ftg7EUKmLRspwpZs9dyB0MNRlnR6rh5Zil5YKlN8S1fOzNu41Jxho4qwg9Z2+x2wrb
	puC4lUr5RDDbSPMehIiBRD/dXJr59bRtsU0oe3h3UHLl+7vGiFI13aXgp8yg9N2ttQwFr7wfTLx
	/3kvJVdotRYk0ibbjcUPzA4tl/znp3oQZqqfZF/IYUp6hILWEq0HDISextjO73fa1AEHU1a2en8
	BF3O41ZxKxPByClwTxpMP/a+SYNU=
X-Received: by 2002:a05:600c:19cd:b0:477:c37:2ea7 with SMTP id 5b1f17b1804b1-477c1115febmr308959885e9.21.1764605356620;
        Mon, 01 Dec 2025 08:09:16 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGSD1pBa1Hw3foADKikErekPiC83z4sIlcH+M2I7iIAJYNb350MZ94rJoazGuHB7IWgQ1wQnA==
X-Received: by 2002:a05:600c:19cd:b0:477:c37:2ea7 with SMTP id 5b1f17b1804b1-477c1115febmr308959485e9.21.1764605356175;
        Mon, 01 Dec 2025 08:09:16 -0800 (PST)
Received: from redhat.com (128.19.187.81.in-addr.arpa. [81.187.19.128])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4790b0cc186sm304385195e9.13.2025.12.01.08.09.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Dec 2025 08:09:15 -0800 (PST)
Date: Mon, 1 Dec 2025 16:09:14 +0000
From: "Bryn M. Reeves" <bmr@redhat.com>
To: Heinz Mauelshagen <heinzm@redhat.com>
Cc: dm-devel@lists.linux.dev
Subject: Re: [PATCH] dm raid: add takeover/reshape raid1 -> raid5 table line
 examples
Message-ID: <aS29qjy6t09KMP3E@redhat.com>
References: <CAM23VxrJpHE4SBo82AnTwD14qA-GXfs48kfaaoenGAnEqTEUtw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <CAM23VxrJpHE4SBo82AnTwD14qA-GXfs48kfaaoenGAnEqTEUtw@mail.gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: yzuVi9jJfNIL-MHEpK2mIZyOaXYzM18HFKlJKG1mXi4_1764605357
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Dec 01, 2025 at 03:40:39PM +0100, Heinz Mauelshagen wrote:
> Also enhance possible takeover/reshape information and do some reformatting.

Patch seems to be line-wrapped at 80 characters. Does not apply:

$ git apply /var/tmp/dm-raid-doc.patch
error: git diff header lacks filename information when removing 1 leading pathname component (line 9)

There seems to be some tabs/space issues also even after fixing the line
breaks:

patching file Documentation/admin-guide/device-mapper/dm-raid.rst
Hunk #1 FAILED at 20.
Hunk #2 FAILED at 48.
Hunk #3 FAILED at 371.
Hunk #4 FAILED at 398.
4 out of 4 hunks FAILED -- saving rejects to file Documentation/admin-guide/device-mapper/dm-raid.rst.rej

Regards,
Bryn.

> ---
>  .../admin-guide/device-mapper/dm-raid.rst     | 49 +++++++++++++++----
>  1 file changed, 39 insertions(+), 10 deletions(-)
> 
> diff --git a/Documentation/admin-guide/device-mapper/dm-raid.rst
> b/Documentation/admin-guide/device-mapper/dm-raid.rst
> index 3554c44414e63..e11f107647709 100644
> --- a/Documentation/admin-guide/device-mapper/dm-raid.rst
> +++ b/Documentation/admin-guide/device-mapper/dm-raid.rst
> @@ -20,10 +20,10 @@ The target is named "raid" and it accepts the
> following parameters::
>    raid0 RAID0 striping (no resilience)
>    raid1 RAID1 mirroring
>    raid4 RAID4 with dedicated last parity disk
> -  raid5_n RAID5 with dedicated last parity disk supporting takeover
> +  raid5_n RAID5 with dedicated last parity disk supporting takeover
> from/to raid1
>   Same as raid4

