Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECC15129E72
	for <dm-devel@lists.linux.dev>; Tue, 30 Apr 2024 20:35:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714509354; cv=none; b=s/vrdvxCOrwZWeqhsNhJYJiI5v1CyKgDDV/XyBTENfDzXsUXgB42m5D236vkxRo6zYfoql2nKEf1FZz1C5l5nFmAPJvOVFHp4UTFSHKNG54Ug/9GUrnR3mgxitX6fWifBF7GVNfF36IGhdoDUrOZeFWsjqANTCSZyHtJbDz7QnE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714509354; c=relaxed/simple;
	bh=wUd0nXj1UufpWGT1dh+HRftQhqcNf/fPfNSAQ8y6JPY=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=FtCc6ckfk5veiBrBfbL3WEyVaEMWKyCM8qGqqx9GzJUT1ym02PxdyTA0pwU1LTYGgp0XLPxW5pjWvvvw6mxzFyUbmAxipP5E7PLcb6OeBJOOLhLIQdoWnFfc/NK7zMHkZ6A7xxywhamGOfTceB4AufoLbEdGRcwBLILKxaH40Vk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GtydE7Xs; arc=none smtp.client-ip=209.85.218.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GtydE7Xs"
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-a4702457ccbso816666066b.3
        for <dm-devel@lists.linux.dev>; Tue, 30 Apr 2024 13:35:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1714509351; x=1715114151; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=WuDn4uv6WwhlrUUmB1oaXSAR8ExM+MVqlmrw3Ho5zog=;
        b=GtydE7XsqBeTc+s1kjZaK1tHCrr8Q17wRiHFTuSH1tkFh+9JgByrVyVH7Fv6uB2n1g
         tNoxWuMo1QlTZMicIoJLBCh5SFnka6aPNKS2kA5pZj1+f/gID/c60TRADCSro2PWbVNP
         pMXipgeZCVE3xM1AMjSFTLWzBm8ZTSkS3jkoP5eJUvb+IwqeyjMDMcfn/OoFX8pxKMjD
         X9ocUpRBjVGUDbrXvIgdG9A2Wg+tPPm3LnQSQyMRyFGVT4sPH5tbV//V1AK2wils2E/z
         tMeafN5kjE52U/+IqIRBOWr97yknuPU5HDLnoL1B6UesVUQ0wo6COFc+wf1vrNSRwOBV
         xNrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714509351; x=1715114151;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WuDn4uv6WwhlrUUmB1oaXSAR8ExM+MVqlmrw3Ho5zog=;
        b=wxT3a+2lhEVuhI8s+DKPc2eGtNorIOc1rP/w9X3/MhZKuwnqCrcJzfTRZhBiJGz2vq
         oqZJij6ayxQBgjQnxkiyRVixAr3kuUy86EY18JyEfmLtRq2a703+QV+JL22GqMKq4Evc
         XnbtVRMkqdCf4ByZ6CRCInWuf6ht+RRnlwvpOE1ggOTofwxLfIVmChjRI2ObYumbWPTX
         AsBAZ7GKEJ/T5q/NCiF7jP7kEK4zxgKsp3tRvH+AR8wcCegcGz5aCqv9A/z+cQzsqqAT
         UT5OkqZwq6I5GbQFK/5zTtAJURUScPU+6QJbqHihNT97iCJlEwpLFspEe5T+oJ7/0wFo
         /BoA==
X-Forwarded-Encrypted: i=1; AJvYcCXTcisxEg//IcMBMBvRVjgwMQ7HFqkRXj7d3yDThg5LQLsux7B07qhAM1mrKY07E12lxl3ssmzcHEti+hl5QXoQrQ4YJYdD8fo=
X-Gm-Message-State: AOJu0YzSMFEwAtNX/QJR9iXsq9IdhaD+AOsWIpNeglEFq8ET+MdidQuO
	VjKhr0nY07J0Gls+NO1DPAVxcyoaPjnZv/laz7h5HalR6cXi/rA8
X-Google-Smtp-Source: AGHT+IF9K1bayEHnFgpxwrh3tLdIe8IN6ceac03jzsvVF0RusdhOcPuoFBEV9dVLyTidivose7fBQg==
X-Received: by 2002:a17:906:2615:b0:a55:67ae:bbe3 with SMTP id h21-20020a170906261500b00a5567aebbe3mr503989ejc.44.1714509350838;
        Tue, 30 Apr 2024 13:35:50 -0700 (PDT)
Received: from ?IPV6:2a03:a900:1000:7e9:403e:7c8b:351b:f333? ([2a03:a900:1000:7e9:403e:7c8b:351b:f333])
        by smtp.gmail.com with ESMTPSA id cd9-20020a170906b34900b00a5264576138sm15521308ejb.35.2024.04.30.13.35.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 Apr 2024 13:35:50 -0700 (PDT)
Message-ID: <bda0198d-22dd-43fb-bf81-68fb101e596c@gmail.com>
Date: Tue, 30 Apr 2024 22:35:49 +0200
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: delete on snapshot does not free space
To: Michael DiDomenico <mdidomenico4@gmail.com>, dm-devel@lists.linux.dev
References: <CABOsP2PL9AM5phv4ZhucGmpk6V1x+DozXLaPTBVaWqMdy-KdPA@mail.gmail.com>
Content-Language: en-US, cs
From: Zdenek Kabelac <zdenek.kabelac@gmail.com>
In-Reply-To: <CABOsP2PL9AM5phv4ZhucGmpk6V1x+DozXLaPTBVaWqMdy-KdPA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Dne 30. 04. 24 v 19:54 Michael DiDomenico napsal(a):
> this is probably expected behavior, but i'd like to confirm as i'm not
> a device-mapper expert
> 
> we're using COW snapshots overtop of a readonly block device.  this
> seems to be working fine, however, when a person deletes files the
> blocks are not freed.  case in point a RO block device with a COW
> filled up to 100% as shown in df.  when i deleted some files to free
> space the usage never decreased
> 
> to create the mount we do
> 
> echo "0 <realsize> linear /dev/loop1 0" | dmsetup create roimage-base-real
> echo "0 <cowsize> linear /dev/loop2 0" | dmsetup create roimage-snap-cow
> echo "0 <realsize> snapshot-origin /dev/mapper/roimage-base-real" |
> dmsetup create roimage-base
> echo "0 <realsize> snapshot /dev/mapper/roimage-base-real
> /dev/mapper/roimage-snap-cow n 1" | dmsetup create roimage-cow
> 
> mount /dev/mapper/roimage-cow /roimagemntpnt
> 
> this is working as the origin device is Read-Only, but we can change files.
> 
> so two questions come up
> 
> 1 when we delete files, how do we reclaim the space
> 2 should/can we roll the snapshots to reclaim space?

Please consider using  thin-pools - this should be giving you the features you 
are likely looking for.

Note - you can use thin-pool to  hold only snapshots  and use your read-only 
volume as the external origin for thin volume.

Regards

Zdenek




