Received: from mail-ed2-f32.google.com (mail-ed2-f32.google.com [74.125.228.96])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA81E3C109A
	for <dm-devel@lists.linux.dev>; Wed, 30 Sep 2026 10:09:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.96
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790762993; cv=none; b=q8ovtNtVyak0VN+7ph4ljx8nt/9M+2ronU6B7Xb69y7pEvKSRzlW9b/zj7ZntCcO/gf6qnBC4Zq9JybVppbS5a3XR3QhTVaSWFgCiBSepdFDrlnE43Az/pwWh6jLAKIDzAmTVmaY8YLX3Hyshfhz+yRovJX9MSenBuuvYlkFXCw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790762993; c=relaxed/simple;
	bh=hrw1dd3W52X2PRIBJ61p/Ixy3mLjm6opZZ+GWT4oBp4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dHOe+93RL83I7Q1ceItnBJI2Vgg+vR1U6S88q0JEZ5flsBcIaQQ8qSfaxDmenrRJKdXEwv5tpOUxy1snXjRgImmUvRvn9StLjSPvYl9sHsDm3kNMbUbT6k+TgK0QwSCA17IJJNb8yLu3dxKxPMl+TBITr5wuZxHBBGbjViYHlNE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LmQcDNPH; arc=none smtp.client-ip=74.125.228.96
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LmQcDNPH"
Received: by mail-ed2-f32.google.com with SMTP id 4fb4d7f45d1cf-6acbdf627ccso1761751a12.2
        for <dm-devel@lists.linux.dev>; Wed, 30 Sep 2026 03:09:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790762987; x=1791367787; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ruocdeJmKgpaQFus+PucSGDLt7ZSCHmy/3XR1sTVzPs=;
        b=LmQcDNPHuc9BTeoE6kRDHt5JGLF4CzRuK2PPKiGyB63LQ/BfHhTM9w/YzI3/Gaz/3j
         1kWEMmkZNIZ0l6Mr9rYCjgSaSsaQEAHavD707oHFYnX/9d46/F4pukBWbs0MQv/D5bHg
         0KD3Ajj1wWixaM0+ThmiSqqdepgrOESe6uLTfEqwxrf+vX/V0Ol6/TciuFLWEIkPdI2S
         QKUd8SIRAXNuOoMjEzbsFzQOfgy7kWzJ8mbNtvrGyiTpltfiGM7X+6aa+999hCqwQCJj
         DRflBjXrHxkGsLTHKU9LPN91zBFhEnjQdxrtESqSpba2I2vU5VjO5JR/bsfIG/JVmM+5
         xHxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790762987; x=1791367787;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ruocdeJmKgpaQFus+PucSGDLt7ZSCHmy/3XR1sTVzPs=;
        b=lKziY8Jv8BlKuAHRltLcUK8A3etYtg3VCsuw+MauAgoEdYYa+c4Kro2f3Vu0rqt5pk
         yLwyVOnxfP4sAIXK9pipN2p+H54PAs7XcK8jtp8MGeZS5Aoty5TdyxvUgKHrbmgmABPR
         igG6vcV/lV4MmUlQCIrGHVKMsRZ5bBAyTmFkkpQ8r4GrBVbzMBmHHmgxTZxYLlbd88hd
         PBvv7AcTMSYb5a1qZ3Kf2D6qg5jkOuW0EI70nwhQ03JwquM0kLcK2Fys56c7rUiEMEAz
         k6wW1heNo0XF6mHPInBLWxL9jxCUmxMLKb4yQTzcccUvYLvfLhZ46alaKnoRS3E87wh0
         gtiA==
X-Forwarded-Encrypted: i=1; AKwUvByP/93Fem0aesDzuv+Vq3dC55ffaO76QHYsa7Q5lbMrD0LpSmM64FNURrtsZOunLJTbehhZpn1YYA==@lists.linux.dev
X-Gm-Message-State: AFq9FYJgJLwZuReH4NWdCCwwgBKbnmFgzSNv0PFxgQwcQeNyRifownWY
	MUNsT018IVANH6bvsSLTYvUkQtoVMsFnh5KBoIiC+ckhOQFPIq5D6KS4
X-Gm-Gg: AYBFou1FT68PIJp7BcfS+yvHEI3O4XZINZbkerB4MyDjcrcJoQK83yfl4Zjhk8qKguJ
	RuIiO+q4ZegUs2Wb/GF/42grFZeNv9JVIpiHNS9YXvN0eGh2gAvVDM7iYHJPH4evP6/JbFvDiqJ
	80y78m3hOi2hbOatWMnk/vDf7JGeq9coRIx+m5N6f85bHFvH2sMD+27eiziagqAi8JsFVishMw7
	2wV7VF5XixpndGrYW+1U/P/3ITBpKkl9KVPCs8kzea27WbUsYpYQ/AG+6jfzM2VVycMHGsbWpgU
	sq/IY5Ul+wncQ4/th5ryCTFVhOnTdx+tBdElj/Ln9wTE42dhTxQm8iqU8xOO2Zp7iiUEfnZfoNM
	FQf8CgUJ34N3/9nUJ0oAf6xw9QEUPf9TBks7C8feh5pLRlCR9LseuozlEB1V+hjXcBZM2pUldqN
	Sz5+H0TtpKaYHvw3zo0NzSsgjsIMsDrgvRv5LW2RMm0A0OqGEkRo6fcZBZU+ef6n2PCc+jE43R4
	uH5VrtOkHPqtWbFA+ua9PZiGIirJAcpWYRa3DB7iT3LkeW2MfjxATEhWHho+U4Y0bpjsz/LBHbz
	JFHX57veboogoJkPQfQ8nyWdadPuhtZfwqMtJNSeZw470IIQ
X-Received: by 2002:a05:6402:27d0:b0:6aa:ec02:7de1 with SMTP id 4fb4d7f45d1cf-6ae199152a4mr634773a12.24.1790762987076;
        Wed, 30 Sep 2026 03:09:47 -0700 (PDT)
Received: from ?IPV6:2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c? ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6ae15690dbbsm551642a12.22.2026.09.30.03.09.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Sep 2026 03:09:46 -0700 (PDT)
Message-ID: <77db5aa5-f160-48fb-ab59-a754b100bc34@gmail.com>
Date: Wed, 30 Sep 2026 11:09:41 +0100
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 06/13] nvme-pci: implement dma-buf backed requests
To: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc: agk@redhat.com, akpm@linux-foundation.org, anuj20.g@samsung.com,
 axboe@kernel.dk, bmarzins@redhat.com, brauner@kernel.org,
 christian.koenig@amd.com, dm-devel@lists.linux.dev,
 dri-devel@lists.freedesktop.org, hch@lst.de, io-uring@vger.kernel.org,
 jack@suse.cz, joshi.k@samsung.com, kbusch@kernel.org,
 linaro-mm-sig@lists.linaro.org, linux-block@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-media@vger.kernel.org, linux-nvme@lists.infradead.org,
 matthew.brost@intel.com, mpatocka@redhat.com, nj.shetty@samsung.com,
 phil.cayton@intel.com, sagi@grimberg.me, snitzer@kernel.org,
 sumit.semwal@linaro.org, tushar.gohad@intel.com, viro@zeniv.linux.org.uk,
 william.power@intel.com
References: <cover.1790602223.git.asml.silence@gmail.com>
 <e99dd5221c71cbf9aafb5737468d814cb83b9174.1790602223.git.asml.silence@gmail.com>
 <5a35ad21-c9d4-4dab-a4f0-97baee6e2301@wanadoo.fr>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <5a35ad21-c9d4-4dab-a4f0-97baee6e2301@wanadoo.fr>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 9/29/26 16:45, Christophe JAILLET wrote:
...>> +    for_each_sgtable_dma_sg(sgt, sg, tmp) {
>> +        dma_addr_t dma_addr = sg_dma_address(sg);
>> +        unsigned long sg_len = sg_dma_len(sg);
>> +
>> +        if ((sg_len % NVME_CTRL_PAGE_SIZE) ||
>> +            (dma_addr % NVME_CTRL_PAGE_SIZE)) {
>> +            ret = -EINVAL;
>> +            goto err;
>> +        }
>> +        while (sg_len) {
>> +            map->dma_list[i++] = dma_addr;
>> +            dma_addr += NVME_CTRL_PAGE_SIZE;
>> +            sg_len -= NVME_CTRL_PAGE_SIZE;
>> +        }
>> +    }
>> +
>> +    ret = dma_buf_io_init_map(ctx, &map->base, sgt);
>> +    if (ret)
>> +        goto err;
>> +    map->nr_entries = nr_entries;
>> +    map->sgt = sgt;
>> +    return &map->base;
>> +err:
>> +    if (sgt)
>> +        dma_buf_unmap_attachment(attach, sgt, ctx->dir);
>> +    kfree(map);
> 
> kvfree()?

Sashiko also flagged this one. I'm going to apply the nits from
both emails, thanks.

-- 
Pavel Begunkov

