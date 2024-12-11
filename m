Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 875CB2451C0
	for <dm-devel@lists.linux.dev>; Wed, 11 Dec 2024 07:41:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733902886; cv=none; b=p+6mTouHNQ/yQPGkHU4JUGr2Wf2PjltvEC0smvx7P4Feyp6yFwq2FNokOYJFcdd3aVt+0MtLGWH1uKoj/lGVT1wvBzkm/ZFLYa9CNYkVJYe1BLIy5R6+DVTF9pDWVCrRFTTaFBoiZD0OldeshSu/PbIiSb7H+IirVTUAa+XcoT4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733902886; c=relaxed/simple;
	bh=4FoTgsNgDpx2DiIsYdVCQ5yElOQp09K77FtiRztztUA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=gQQOy0UG7C5/Rkxw/Hragmueaw75VcCJBfbVr4M5K8tysPpdKctVGHpXxJ7nklHgCrXk5bOUgbWdtbUoX8DFwDUJc1d39xEVblCC/X1f5El+eCY5P+5cA1wmFdt19pSt5aCf7hp+MDqD1V1nUZMzIfAxHFyYvJCPXWbyZyfxfDc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=a1yiYBwt; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="a1yiYBwt"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1733902883;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4FoTgsNgDpx2DiIsYdVCQ5yElOQp09K77FtiRztztUA=;
	b=a1yiYBwtnn4JucSWVKjxQkt/olSdVyR3WdFHVna7vX3+BLt2dNpf9RcrfI162cbCEA1bo1
	5w/kZ0o1vitY+1xzFrLRhPGc4v6zhFraKoTcxXauIk+AJblW04whE8DSAtzPW5r11z7S8v
	8fixP9cXOwliPTfbc1/TQ4cko4mK1T0=
Received: from mail-oi1-f197.google.com (mail-oi1-f197.google.com
 [209.85.167.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-128-1tAvv937O1qs0isYooY8VA-1; Wed, 11 Dec 2024 02:41:22 -0500
X-MC-Unique: 1tAvv937O1qs0isYooY8VA-1
X-Mimecast-MFC-AGG-ID: 1tAvv937O1qs0isYooY8VA
Received: by mail-oi1-f197.google.com with SMTP id 5614622812f47-3eb398fc208so1337200b6e.3
        for <dm-devel@lists.linux.dev>; Tue, 10 Dec 2024 23:41:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733902881; x=1734507681;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4FoTgsNgDpx2DiIsYdVCQ5yElOQp09K77FtiRztztUA=;
        b=hypBzQJmJnoC48KGG9+ndTPemKhIhctXEHMeng+xb7ndG2u0EOeN2u4YW9BxyT2ip+
         w0l6/9dbhLbtUW4VCX7YCHCX/fbNclm9bVfli1rFad90uWIaKJ4wiMxw7H+SZPUqWhn8
         qeqBf2CpVj3TmkpHxDl21SSbkGvFkwYzqovi3tPyR0oQkpIxC2Sb3da4Rbq/hn/wWVvB
         Lbo/QT9zmUq2JaHC9+NfK2xAGqt6VY6g8GDIySDz1lEsIWV+9LmOIVwXdO41dhvglH7k
         C1juvOGn5qPxTnrm4hPRfvYGrVE3UG7IWf1zD/oDHCAbAfzYSi2v2x0Nr1y23Q+pxUK4
         b+NA==
X-Gm-Message-State: AOJu0YxPupXAguhqGr1izZe8xIe+kc5Lsd7+Mc7FRVQyDzb7DXlOoKDu
	0k0C+iUjUmoUOfmIxFvYEz2zSmUCpxdc9Wvj+jQUUn67useZawhX/68ti9FuiOm1Xv22Iok8DrH
	bDfzOoD6qWjn+21bIdlm1u4TU7195UTTXB8FkUwW5R5EKUqSEIxfwGgrls+bDVy8/cNUEv3wH1y
	fd+n6qJl/a/2NyPrrBH+BKtIOBvTnh6pn3EEU6sd2s
X-Gm-Gg: ASbGnctp100F6RDAVXC0Cjq9yRszg834786TeuAMcHYX792malp3ZLsCzCnUH9CEptr
	l6db+XL4Lf9lpNBxbvchjve/NdggKuESBg9tW
X-Received: by 2002:a05:6808:13d1:b0:3eb:4b4c:80d8 with SMTP id 5614622812f47-3eb856f3cbemr1134363b6e.0.1733902881177;
        Tue, 10 Dec 2024 23:41:21 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGykuoYkXECb5W/Oird50vSgG3LCacLnhXzRWXx6Qs+UHD7/qSnncRJBWUGtT9EQwDxp59fxx0YSbWdhPPIW1g=
X-Received: by 2002:a05:6808:13d1:b0:3eb:4b4c:80d8 with SMTP id
 5614622812f47-3eb856f3cbemr1134354b6e.0.1733902880898; Tue, 10 Dec 2024
 23:41:20 -0800 (PST)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241205114153.1496986-1-mtsai@redhat.com> <20241205114153.1496986-2-mtsai@redhat.com>
In-Reply-To: <20241205114153.1496986-2-mtsai@redhat.com>
From: Ming Hung Tsai <mtsai@redhat.com>
Date: Wed, 11 Dec 2024 15:41:09 +0800
Message-ID: <CALjSBEsnUjcZ3ge_hDtzVRkegL88aYzao5+FU1SJHV5Dvq+81w@mail.gmail.com>
Subject: Re: [PATCH v2 1/3] dm array: fix releasing a faulty array block twice
 in dm_array_cursor_end
To: dm-devel@lists.linux.dev
Cc: Mikulas Patocka <mpatocka@redhat.com>, Joe Thornber <thornber@redhat.com>, 
	Heinz Mauelshagen <heinzm@redhat.com>, Mike Snitzer <snitzer@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: pJkutFf6WUx_gfGYHvJAbD2YUNMEJbY3YciW9fYnIHc_1733902881
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Dec 5, 2024 at 7:42=E2=80=AFPM Ming-Hung Tsai <mtsai@redhat.com> wr=
ote:
>
> Reproduce steps:
>
> 1. initialize a cache device
>
> dmsetup create cmeta --table "0 8192 linear /dev/sdc 0"
> dmsetup create cdata --table "0 65536 linear /dev/sdc 8192"
> dmsetup create corig --table "0 524288 linear /dev/sdc $262144"
> dd if=3D/dev/zero of=3D/dev/mapper/cmeta bs=3D4k count=3D1
> dmsetup create cache --table "0 524288 cache /dev/mapper/cmeta \
> /dev/mapper/cdata /dev/mapper/corig 128 2 metadata2 writethrough smq 0"
>
> 2. wipe the second array block offline
>
> dmsteup remove cache cmeta cdata corig
> mapping_root=3D$(dd if=3D/dev/sdc bs=3D1c count=3D8 skip=3D192 \
> 2>/dev/null | hexdump -e '1/8 "%u\n"')
> ablock=3D$(dd if=3D/dev/sdc bs=3D1c count=3D8 skip=3D$((4096*mapping_root=
+2056)) \
> 2>/dev/null | hexdump -e '1/8 "%u\n"')
> dd if=3D/dev/zero of=3D/dev/sdc bs=3D4k count=3D1 seek=3D$ablock
>
> 3. try reopen the cache device
>
> dmsetup create cmeta --table "0 8192 linear /dev/sdc 0"
> dmsetup create cdata --table "0 65536 linear /dev/sdc 8192"
> dmsetup create corig --table "0 524288 linear /dev/sdc $262144"
> dmsetup create cache --table "0 524288 cache /dev/mapper/cmeta \
> /dev/mapper/cdata /dev/mapper/corig 128 2 metadata2 writethrough smq 0"
>
> Kernel logs:
>
> (snip)
> device-mapper: array: array_block_check failed: blocknr 0 !=3D wanted 10
> device-mapper: block manager: array validator check failed for block 10
> device-mapper: array: get_ablock failed
> device-mapper: cache metadata: dm_array_cursor_next for mapping failed
> ------------[ cut here ]------------
> kernel BUG at drivers/md/dm-bufio.c:638!
>
> Fix by setting the cached block pointer to NULL on errors.
>

In addition to the reproducer described above, the patch can be verified
using the "array_cursor/damaged" test in dm-unit:

dm-unit run /pdata/array_cursor/damaged --kernel-dir <KERNEL_DIR>

