Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2A7437CD3A
	for <dm-devel@lists.linux.dev>; Tue,  3 Mar 2026 06:57:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772521037; cv=none; b=bSJdPRUfYt8+s7cfPDOBMOAVYmEFfaRsJYT9SXwdsiAILv9237QfYwc5e2g20ikm4ll8rsB6tinKD+Wl3DUDYyagdKO7ZH9461TXVmstMZi7woiKhFD5WXdvZuPXTcT9XNQgL8XRP7FpjnGeJtpOTmz4D/YBZovSXMHHM+k/H9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772521037; c=relaxed/simple;
	bh=brmgYvldAEzJ2O8fsEmwzrbBh4ultBTeueXu8bmByKQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ctiXU75Dc2PA1ZalSxiAL+QCCFfwEjllpMlHu8sQQBlZOwkojg1gx4tg5li1nJraXeoYmXTiq97pbX1F7Q7b7SjxtQU7iAGbBiD7eWN3i9XcZo4UzSpmVqAFFVsYiZWnLRlWI85nbFKN9MEWIOUNfD+urFYPxWY416KgixHO1Kw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=L59w0JrD; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="L59w0JrD"
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-4836f363d0dso46190625e9.3
        for <dm-devel@lists.linux.dev>; Mon, 02 Mar 2026 22:57:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1772521034; x=1773125834; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=+UWoE6mn2375qZ/+kFXj+S+YU2oT2pZiLz3gYYgeg/c=;
        b=L59w0JrD+AS4Vzijk3CiamJJRbOgN0A6IazxSm+sLaqQO9vI4e01SYYUXd5XzhbsYN
         OvpqZuW4ornIUB0TgBUuNKzLEPtHjsGs10aW1s9NGCi8XRhjUwJ5rFsxdjk6gmm/Jnkk
         N36aakCc4ukpXFvp5Hgu2ylpik/2BNgM+wyU9lpf5PqrDOCQJ9474hKTNf7ImTiZYVan
         94A+obw2BoY9GfMHfJk7TLiIvYhz158lyqM+tZzqOyfC5QrKn0ZZNGK5lbWrBJiaecgM
         Llul1lOLC2V8aG9pB3Jl/eedjVzVuTyMS4OLo+ySaj0FsmYW3rfiCNRXSNckzVSKX97g
         IbGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772521034; x=1773125834;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+UWoE6mn2375qZ/+kFXj+S+YU2oT2pZiLz3gYYgeg/c=;
        b=dGoU+XX6YZIYs3O8VQSYnMksctY2KGgpNmXOwGQNmfLLzjoHOG8NToMdpp8mNLRX3f
         6IPpPDEhV0xaUqFuoB5KAWBTQtyJCahwL7we6hRo109rGhDJrNn50RCECrdY5Sw7FpS9
         7zfMRZ4eHkgrCHMxltovfHKSF/FL8ZULHLjqWrx9juVwiaCnwwnEDaWORsZTjZvjg3yx
         lRdU8R+yGQcqTWLgnCsAt6XN7UkEdlS7ADrGijzUDIm7fmkvjC/OJjsj0D2OcIvJK/+6
         Yem1F5vyUe4jWAXlp24xVuwPbOa5Fll0PWNzo46TJj1pp9y3nvnou30SDy3HbJhlNLBl
         XGIQ==
X-Forwarded-Encrypted: i=1; AJvYcCXRe7Gq0RZ+HFv/RGBwp9f3x5hRphJVvxe+aQRYrNdueC6KrQKFQhx8uAhgPoiC15caCaF9iloWuQ==@lists.linux.dev
X-Gm-Message-State: AOJu0YzcvJ4In+t2oPQC1C7WPXYcAnL+82DGR2jWNpGBbxKLX5G71Ge0
	v7x7BG7G6V8MbnGe65Cb9JHVtL/GocPlMEjkzyVMmIJBIN3uHH2uB+apNdNA/duOgVA=
X-Gm-Gg: ATEYQzyvSxa1cYec535HCRmwLD6LAr8bI3AxT0e8vaBh/633d1kEedpVxieZK0ZfZft
	G0oxIsdPX/uDq+468by1mRj5rGtu99WuWUoXGoSkubYjkNIaBjWulEp3QqI8p3qwHO5Bfhqu8WI
	XZNIH56sNyua9ltXPjZBrKBz1Mz0Biz6Y0CToek0aHKJ4DdqccgfI5RPILEFR7BQ50Vjk6zm1RT
	Fk6oJ/fXNfX9/A91RtnbPjs6lKLNz1LKFE6ZgRODlZ4x/g7dIMVWhPU/kGvfBx1c5SuRXkY11/0
	oo474xhNvu8SRx91RqaM9pu5zXap7PAD6Y1poM6X3gM5Sg2W5QbLNDGxxWhYS8lJjQO24R3kpg4
	Nz3gm3eEZ9rva8lvM3sTu/zxy1sNXAkUaJlMlylhzfYKRXXWFpSlIe1zsAvKAf/Pi+R4FZ+mCcn
	Bv/yREf1BUn4WUD3N1LQfW4Xy3DFoT0pVnVJDQMYBTjxxlyF4LhN39m9JI9fH8I9z0JA==
X-Received: by 2002:a05:600c:8108:b0:483:7907:ea02 with SMTP id 5b1f17b1804b1-483c9bfa9eamr271767355e9.16.1772521034082;
        Mon, 02 Mar 2026 22:57:14 -0800 (PST)
Received: from [192.168.178.47] (aftr-82-135-83-117.dynamic.mnet-online.de. [82.135.83.117])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-485132f202bsm16289535e9.0.2026.03.02.22.57.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Mar 2026 22:57:13 -0800 (PST)
Message-ID: <e22f5444-f8ff-4c91-b9ab-fa95714f2df7@suse.com>
Date: Tue, 3 Mar 2026 07:57:12 +0100
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 02/24] scsi-multipath: introduce basic SCSI device support
To: John Garry <john.g.garry@oracle.com>, hch@lst.de, kbusch@kernel.org,
 sagi@grimberg.me, axboe@fb.com, martin.petersen@oracle.com,
 james.bottomley@hansenpartnership.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
 linux-scsi@vger.kernel.org, michael.christie@oracle.com, snitzer@kernel.org,
 bmarzins@redhat.com, dm-devel@lists.linux.dev, linux-block@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260225153627.1032500-1-john.g.garry@oracle.com>
 <20260225153627.1032500-3-john.g.garry@oracle.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.com>
In-Reply-To: <20260225153627.1032500-3-john.g.garry@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 2/25/26 16:36, John Garry wrote:
> For a scsi_device to support multipath, introduce structure
> scsi_mpath_device to hold multipath-specific details.
> 
> Like NS structure for NVME, scsi_mpath_device holds the mpath_device
> structure to device management and path selection.
> 
> Two module params are introduced to enable multipath:
> - scsi_multipath
> - scsi_multipath_always
> 
> SCSI multipath will only be available until the following conditions:
> - scsi_multipath enabled and ALUA supported and unique ID available in
>    VPD page 83.
> - scsi_multipath_always enabled and unique ID available in VPD page 83
> 
Why don't you merge these two options, and have
scsi_multipath=on
and
scsi_multipath=always
?

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.com                               +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
