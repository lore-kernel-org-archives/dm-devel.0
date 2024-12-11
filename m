Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1270D1C6F59
	for <dm-devel@lists.linux.dev>; Wed, 11 Dec 2024 07:54:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733903699; cv=none; b=uVc+I24ffPBTBXTsH2r9QfnS8v4cV9chvLojEa2Y3UYwXEDDIKiVvFxzsEMLTscZVE8qMFmVuBTPPNR52nNCLNJLM4IOgk/7HVMS1EZ4prnACzq4dWvCLJEmylF+7oad6+939kBW5q3pB0XHW/eWeYNSw0ibO63W56+BLknh88k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733903699; c=relaxed/simple;
	bh=reg0AQY7mjftKRF7IfdX6Xr/J+jUdveZCJ9/GkDeeCQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=RoOqJFE4wl0DsuWF9ZKlMPKHKG7x1gGfQqexl1UMIMwXmSWfVVRJea8klgFwpXwVeyfZdpsBxOmeAifuiqoCSBdsPjMXs8Jdv6Fmu6foN82/QwqCAtCH9fppgoCx0kSn13Nly4vgfWDnm81f0ra3APNd6D59m7n2KnYp8ddz9/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fI1WulCm; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fI1WulCm"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1733903697;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GgzuRPDbF2R/ajGjI3dtLdOOA2tO+dp4ddXv8ckSFR8=;
	b=fI1WulCm2NBsDpIHo5gyCU8XIjT2myovNkmngyGsdUEl8RvDoJnia0PYz/wzMtMEPKuESy
	zDRte9M0CZ93Dzdd23toeDoWIcugUpUY9rFf3ydwjXHaazM7xkgK776dRgyIXSov4dGohR
	dMnF0FyOoTjOv/8a7VIoWgaAmgWm7uI=
Received: from mail-oi1-f197.google.com (mail-oi1-f197.google.com
 [209.85.167.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-669-Ay43H0bQNACZdxum0texpw-1; Wed, 11 Dec 2024 02:54:56 -0500
X-MC-Unique: Ay43H0bQNACZdxum0texpw-1
X-Mimecast-MFC-AGG-ID: Ay43H0bQNACZdxum0texpw
Received: by mail-oi1-f197.google.com with SMTP id 5614622812f47-3eb34fc865cso2776184b6e.3
        for <dm-devel@lists.linux.dev>; Tue, 10 Dec 2024 23:54:55 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733903695; x=1734508495;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GgzuRPDbF2R/ajGjI3dtLdOOA2tO+dp4ddXv8ckSFR8=;
        b=BUdtPRykNXffX/29uKSm8Mk7PbLvkL1xwH7/twCgzN0vvBYtcE6vec8CDBQNwvpln5
         3G8xHI+oIZaLFoTjIaQTULoN+OzanMJoPpNp7T8ObIUeshxGw+CFOVpcXRY40k1RBA7v
         NOwTkCFmraQhIz5bTpVNcV6RIP2JOEhb0HISC2AiKckuISlD3cXdvpi1uLsHwiFqxFgf
         p1IzIssnW0Tgyxu6YIlPW7opr0md04UM52mZeJN/ocjUPBmZjLmLSPvCcwfUgFpYOWV+
         Ce3Te6gzp2pkgMOQRVMgaIoZPPBb9qSXlBRxZx3tE6WK2i2FzpSTz7uW+0EziJHIXp/T
         Q3cg==
X-Gm-Message-State: AOJu0Ywi40G54A7tcpPTCPKr4/wZ4otj03pDyZO+r+FDJem1VUdDoSN3
	kFOGxZibn9joJx6mL9WdtlmDKrWI4R5jSh7ABKtoutXaaQlqlsqqjOoshQ9qSTSipAeHoISVrCB
	jwORKJAFIQt7N7J2XCFjYmAgtd7b7890AgirPD2eBooFhrLyZZtBN5Qni0Q7wlf5jAnbZhJ7qPR
	Rc/5kCGIplB6vQ6Pw48fgfNBYd7uBnPSb+K/WA7UzWNmk=
X-Gm-Gg: ASbGnctoNF8FoMzpPLdhrQkXjsOkHOHDgqS+N/VZqfCDTOXapujRApLfXTPvRB23m9o
	AcnwjYBUfctxnrDCi+pyJBcXX9NBaBxW4FKQs
X-Received: by 2002:a05:6808:21a4:b0:3eb:3b6e:a731 with SMTP id 5614622812f47-3eb85c3faa7mr1071160b6e.6.1733903695058;
        Tue, 10 Dec 2024 23:54:55 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHpuu9MBeCFgSUx8aNTw5rAuIEK/lQ1QfQ63c7797UsDv6w3p5Fs2wB2IYSP9ncXeERbHUtNuFOA1/VhOUlpnQ=
X-Received: by 2002:a05:6808:21a4:b0:3eb:3b6e:a731 with SMTP id
 5614622812f47-3eb85c3faa7mr1071154b6e.6.1733903694844; Tue, 10 Dec 2024
 23:54:54 -0800 (PST)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241205114153.1496986-1-mtsai@redhat.com> <20241205114153.1496986-4-mtsai@redhat.com>
In-Reply-To: <20241205114153.1496986-4-mtsai@redhat.com>
From: Ming Hung Tsai <mtsai@redhat.com>
Date: Wed, 11 Dec 2024 15:54:43 +0800
Message-ID: <CALjSBEvuW0iG5gj9h2zPLUYKh7sn1mSUqUrLYByTYcnMFzuu=g@mail.gmail.com>
Subject: Re: [PATCH v2 3/3] dm array: fix cursor index when skipping across
 block boundaries
To: dm-devel@lists.linux.dev
Cc: Mikulas Patocka <mpatocka@redhat.com>, Joe Thornber <thornber@redhat.com>, 
	Heinz Mauelshagen <heinzm@redhat.com>, Mike Snitzer <snitzer@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 9MvUhuJfPotWW35uVTmJwHbg59i1tLMAx6ZNVvjJMWk_1733903695
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Dec 5, 2024 at 7:42=E2=80=AFPM Ming-Hung Tsai <mtsai@redhat.com> wr=
ote:
>
> This bug affects cache resizing in v2 metadata and could lead to data
> loss if the fast device is shrunk during the first-time resume. For
> example:
>
> 1. create a cache metadata consists of 32768 blocks, with a dirty block
>    assigned to the second bitmap block. cache_restore v1.0 is required.
>
> cat <<EOF >> cmeta.xml
> <superblock uuid=3D"" block_size=3D"64" nr_cache_blocks=3D"32768" \
> policy=3D"smq" hint_width=3D"4">
>   <mappings>
>     <mapping cache_block=3D"32767" origin_block=3D"0" dirty=3D"true"/>
>   </mappings>
> </superblock>
> EOF
> dmsetup create cmeta --table "0 8192 linear /dev/sdc 0"
> cache_restore -i cmeta.xml -o /dev/mapper/cmeta --metadata-version=3D2
>
> 2. bring up the cache while attempt to discard all the blocks belonging
>    to the second bitmap block (block# 32576 to 32767). The last command
>    is expected to fail, but it actually succeeds.
>
> dmsetup create cdata --table "0 2084864 linear /dev/sdc 8192"
> dmsetup create corig --table "0 65536 linear /dev/sdc 2105344"
> dmsetup create cache --table "0 65536 cache /dev/mapper/cmeta \
> /dev/mapper/cdata /dev/mapper/corig 64 2 metadata2 writeback smq \
> 2 migration_threshold 0"
>

In addition to the reproducer described above, the patch can be verified
using the "array_cursor/skip" tests in dm-unit:

dm-unit run /pdata/array_cursor/skip/ --kernel-dir <KERNEL_DIR>

