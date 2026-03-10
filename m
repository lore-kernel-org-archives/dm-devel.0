Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C62DB2DC332
	for <dm-devel@lists.linux.dev>; Tue, 10 Mar 2026 13:27:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773149234; cv=none; b=azXeYjSUcRcpgYxbzbafbgiam+9hAZRFLq9o/Tj/WFFtaA8VVYa24A9mMpVpzgW/OhSy6SmoDTuQuHFMfRot6/vWnOra9CD8Tasee6NqKEP3YS3Xwhx9uDE66pQVgBW129l15Fud+MyvhAcGsG+h7174+gG9om1ovLzsQ2xnEtQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773149234; c=relaxed/simple;
	bh=Q0M3CsB4GtTszDcqyzgt4PMuFmQpYA4jX4liu+GU3Zg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lnk6FTxBu7pG/uo4yeYAjR2lJNE0nJh5fJgqIHhSmBkraAu3w6sIVlPtxpx8gqnUM7dthfmFjsmF4aMNiqUNf0ENd13mSoVWVQE9uyqWH7m9ci+REI8FRge8uWO+BtwpxPpxcL/8kDboqTFttJ9fr3t5v+pDyZdN7BmaHxjC9xs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=aG88ze5l; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="aG88ze5l"
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-4852f8ac7e9so39700345e9.1
        for <dm-devel@lists.linux.dev>; Tue, 10 Mar 2026 06:27:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1773149231; x=1773754031; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=KQMwiNesWOvbkCjUoTZhAGMhdNBr4mXDGAT5peoa0g4=;
        b=aG88ze5li11ZXeXdhaZusqMpAl66yOfLJjihyJ9mU6lO1R2zFZWdY53j28J5ujSQgG
         u0X7PVrvNRpJy7Ajic0rwpMSlWRCKT9RyADCmneYSxpbUiJy/qV+VggwWGxm/bhqTRlO
         oTAnuZRbbAIpakw9ZifLTzQR4HmsGQ1rlKzDbyWQHxs6Nmittq9LxtkM4n+jc0FfsgK6
         vpEqjszQK1t2yBygU/PUaEvUarWbpvCRILz7ibRSGm5iPem0IN8FGGO880gNgRJNP0mW
         uD8YfBO91YFlU8u9B3SFRzdrzLc8cUvHQ1ddy8HvBnWdug0t8c37cNPSewlb9xG3+qZ9
         cd9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773149231; x=1773754031;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=KQMwiNesWOvbkCjUoTZhAGMhdNBr4mXDGAT5peoa0g4=;
        b=fCmT4tdpH3H12eDfiZ/UqLZWvA5tyZCwyg/YflTvHS+NvXX+H0lzptKnqf35mSTXYi
         S0DQ7NCOmH+Rcgc4TWGB/E8BPAgwxhMcfxjcsP5Mx40aekaCga3GxPN1KDbYKnd2/aNt
         aTEv0EY+x0KYXGcx5Jqob+yLv4VqJiMyCUHd54RPiklS4nNRCjBtAkz94YScokSqPljw
         V+1HN9B8YtMVHmeNc0CdHzNOYZD1V7qNiaRyK80l/T/CwD1sXagDrvI9/LnCfoxsDqBP
         vLDNnoSM71BT1fmYXpJ8D7O5gqTdIYJcatVJOR22cCF73KP81d2VxN62+wdznpUBndO3
         QVJA==
X-Forwarded-Encrypted: i=1; AJvYcCUOi5O0mk8Aq8PpiU4777N2oiaNEEEjKznvRCo7zpnoYjho9i1OucjuWjcJbXdm9ox5auw3VFis1A==@lists.linux.dev
X-Gm-Message-State: AOJu0YyKOQD+wjPaNdXpaWp3SzEQzaxfQ5o0lQVaDW81JLswAWZOXJcQ
	1z7mt2fNictQfgcpAu/NGg7W4SohHYAlZF9CBMEfrIsLXjrGxZQHHhvLJj9QVqXw/e1ExxIC0gL
	OuDMUxvs=
X-Gm-Gg: ATEYQzwQV4rVcucrbvhBfLG44gi6HubjhOLvU/ZMafqtnoTNsXYybN28OP4k1TA9IAU
	9V7Pr7zJ5BlvNnt/KbOzx7BU+GAkAiKdDpcGDS6y2jYhk/WKmXzIv9deN5M3h3VI+WfAwP0Px0+
	QorP0kVWUVEWa/aYLxkRdN2WZYYM4QAibdH2UMQTCIgPhZH9tzAQVt2MCD9fJuVtXdZKF5PQMkX
	VxmEeq1M7ymmjEdpFfYC61trEw4JL0V9zm1i98DCy0W6VKfQh05n/2M5W6ymZ2K6NXcp63qo2+L
	3D0lJJ4feppSL4drqR1b6t0fxO2kLOWBxUsUckp7eF7O7Zhak479YUZiOIaRRakA1z1cLQsb5pT
	64ULhjyXW/xZROeJWC03ngEjoNghku/ftTYdj5U/d/0DjHS2iVeuVkmJSE6UQ9DXnwh2AzA4qV4
	5EcAKEudRd8HVEhGn8fj5k9gPD1X4R8Tw95fINLNSlFIaVhLj1qzMw8AP3
X-Received: by 2002:a05:600d:1a:b0:485:2c61:9457 with SMTP id 5b1f17b1804b1-4852c61be45mr169997465e9.10.1773149231164;
        Tue, 10 Mar 2026 06:27:11 -0700 (PDT)
Received: from ?IPV6:2a07:de40:a101:3:ce70:3e6f:3b9c:9125? ([2a01:4a0:2e:ffff:ffff:ffff:ffff:ffff])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-439dae46353sm42155639f8f.33.2026.03.10.06.27.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Mar 2026 06:27:10 -0700 (PDT)
Message-ID: <c7a62f70-8a69-426e-9947-d2363a124583@suse.com>
Date: Tue, 10 Mar 2026 14:27:09 +0100
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6/8] scsi: scsi-multipath: Maintain sdev->access_state
To: John Garry <john.g.garry@oracle.com>, hch@lst.de, kbusch@kernel.org,
 martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
 bmarzins@redhat.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org, sagi@grimberg.me,
 axboe@fb.com, linux-scsi@vger.kernel.org, michael.christie@oracle.com,
 snitzer@kernel.org, dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
 nilay@linux.ibm.com
References: <20260310114925.1222263-1-john.g.garry@oracle.com>
 <20260310114925.1222263-7-john.g.garry@oracle.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.com>
In-Reply-To: <20260310114925.1222263-7-john.g.garry@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 3/10/26 12:49, John Garry wrote:
> Now that ALUA is supported, we can maintain sdev->access_state.
> 
> However, preferred_path is still not maintained as that that is related
> to transitioning  state and we do not yet support that (for SCSI
> multipath).
> 
There is an issue with the preferred path in general, namely that it 
overlays the ALUA states (ie you can have 'acive/non-optimized' _and_
the preferred path bit set). So it only makes sense for explicit ALUA
as then the preferred path bit gives us an indicator that we might /
should switch paths.

If we restrict ourselves to implicit ALUA (which I'm advocating anyway
for scsi-multipath) the preferred path becomes rather pointless as
we cannot influence path selection at all.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.com                               +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
