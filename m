Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CB36544898
	for <dm-devel@lists.linux.dev>; Tue, 13 Oct 2026 20:09:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791922165; cv=none; b=P+MakjhRX1VI+3xnXaGEH8NKBpnHeHzqjSRFDTzUibaE0tGkngxVUEyadWqxBCZtPrPCc2iHWs/L/pHhsnCVkecI44lRNozKrsvvaYV6SRaLPCAieptfdx8E3EIm1/R0VJpwIGLFkZx0YSUvMeT+oIdvywyCtY0JjG0x+nbKofc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791922165; c=relaxed/simple;
	bh=NrenYkyGWgfz/6r9jzkmCjYiJ49/s0j3/93r31ckaP8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=s3lxKAFho/uzpc/FZGPJhvme1Za9tN2I6Nr2CaBf06vvM00PZ8ts4mHemHuzgkvxeJ0fpnCGmBBwZHGiAOsye8877BTtiEFkpk2GOGd0FLg30r47KY0YcwKESCuYwJMyQzJUCmHvlipHZqalMti7wCIH+p9TSVcSeUX6Y8otrkw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Y+9Nb4mW; arc=none smtp.client-ip=209.85.221.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Y+9Nb4mW"
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-48afcd7ba9bso1907237f8f.3
        for <dm-devel@lists.linux.dev>; Tue, 13 Oct 2026 13:09:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791922161; x=1792526961; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=v0gpLt7+oS9KQUHShMJeHfOIQi0PPRoxYfM2szDl9BQ=;
        b=Y+9Nb4mWmic7V4MBgE0uR7w0Apo2V873yey9GOU+yRNWXogJwf2WLmZ18NjfJcLvC/
         JXLqqH27/bVKsTkK4aGIxbf9LkG679dRp/wE6krr9Neo2UBu4h4fuQ1PxY0bJeE+MCkj
         8CZxFLSX7CCBgyNUJcdmceCE9Ir3rVnfoOo3VBk8z+MtufBZ6xJ37jm93RC1Py0bKIBL
         uWRc4NuRSvLLZiN6EAndpy9uA+zHJV0mQnK0aQigCMWdCb2U8L+a46YIi+ohye2WOOrH
         BDdNIakI4QDfNHGSchQZ1zMfVREiodRYu9YiDkVIPPupUhySfy+FRi4PhF5CeWOUYCfd
         PpQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791922161; x=1792526961;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=v0gpLt7+oS9KQUHShMJeHfOIQi0PPRoxYfM2szDl9BQ=;
        b=iN6NC4VLJeY/hZr7iFaW08CWdllyIKhZ9vl/hPf77LmpllCUCZUqB8SP3xYjQelrp3
         Qv4suBmeQSsoGS77M7RKRqWLEX7slVrB4snxugPoO9FH1/OITTw43CblpdWWjd+pmVi9
         Z+/PWY+ZzvcE1gNwgIVov8RrmnyAW9qKfrG8akG5GAxPxYE4hYeG6dlqtvYbf+5dWrIL
         Rfd0DH3LADPDm9OYZ/diQ3vVk5UE+cDPKwFnTL05q1ZjchNmc++Rh8qKirPAb0dIky0w
         vN4VhGu+TEUTeMG2jYaETeqDiLc1/uHh1/gMez7sXAiJzEgIcj5hRuaIXgDjGSvQNWgx
         KvTw==
X-Forwarded-Encrypted: i=1; AKwUvBzsGV7j+in3DTXIYrrNYnyame3EppPF3YG6TjqgEO0SXl+KfMlLuLnfW4JHTOjkQYzYB4dGGhBFHQ==@lists.linux.dev
X-Gm-Message-State: AFq9FYK3aJUjFSdOyMMjfWlFQyMVwofKwYmNwyqacRaJ+PTXfUMNcdBw
	9UFFJVqofAuxFQWdQG0la87EX+MtOpgtJpr91iIZROza7toaN0kMDcrE
X-Gm-Gg: AYBFou17mp3AqrtpwDSIHotJhs9ZMcxYYNNowsv199+0VAszMH3pQpW+SahaNxiAYJv
	K9WhhQqge4EOePQEX1xn9LvZzPzzi83lD7D6luP31zoUbsgpA1QWkiiWwly/FCzaoSW0swki7hJ
	ABVd8A130JwtobJckMTKS1JT3l4iACSictghcnQ2U88P1WYWNpdnKArdyPZcojFhcGDvEeVhvFJ
	SdyvfySmR9Jx/tX9p1xwiJ01ae5LNfHNksvvpwX9P2fAUJUB/bS6+rYO1FPzJ5hZbPbZMrMQRDv
	zZ/cvlEatPhV45Ux5Md9Aa3BNeWZtTA4sVZXX567GCtedZz/Q/uOZjN6UxZfdb0OkcQD6KcIqeV
	+mFxpQhVpf4zEmBKiEjCHGwK/bZCiqSMDQBBJtiQ1wTiZoHr0esTfJLm3iwSf+0i1THcaoGHZJz
	6Rt4by9ED7hnqm0xBFQoGVaSH1UGrtAwkiCsV1Dz1NguvVtttNqle1q1xZyd7+2S7/53gFuCDWa
	yJx07u6pbakKRczDwwyGwbkNj7bxCNi3TC2IJ/hbjND3w1Fx8oNLw9300NqYBKXJG+MWzxUsDec
	/MVetXyWBy77YnzvoKGn5mY3wj77PtepgjK1xhkAkLsMoPwn
X-Received: by 2002:a05:6000:310c:b0:487:8b9:526a with SMTP id ffacd0b85a97d-48dbacdaa60mr25864079f8f.36.1791922161609;
        Tue, 13 Oct 2026 13:09:21 -0700 (PDT)
Received: from ?IPV6:2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c? ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48de0ab5af7sm7243430f8f.31.2026.10.13.13.09.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 Oct 2026 13:09:20 -0700 (PDT)
Message-ID: <293d49fb-6488-46da-bd3c-6f8600dd123d@gmail.com>
Date: Tue, 13 Oct 2026 21:09:12 +0100
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 00/13] Add dmabuf read/write via io_uring
To: Matthew Brost <matthew.brost@intel.com>, Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
 dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
 linux-nvme@lists.infradead.org, linux-fsdevel@vger.kernel.org,
 io-uring@vger.kernel.org, Sumit Semwal <sumit.semwal@linaro.org>,
 =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>,
 Keith Busch <kbusch@kernel.org>, Sagi Grimberg <sagi@grimberg.me>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Andrew Morton <akpm@linux-foundation.org>,
 Nitesh Shetty <nj.shetty@samsung.com>, Kanchan Joshi <joshi.k@samsung.com>,
 Anuj Gupta <anuj20.g@samsung.com>, Tushar Gohad <tushar.gohad@intel.com>,
 William Power <william.power@intel.com>, Alasdair Kergon <agk@redhat.com>,
 Mike Snitzer <snitzer@kernel.org>, Mikulas Patocka <mpatocka@redhat.com>,
 Benjamin Marzinski <bmarzins@redhat.com>, dm-devel@lists.linux.dev
References: <cover.1791336930.git.asml.silence@gmail.com>
 <d00e43fa-8f5b-4a8b-8b83-421d637ba519@kernel.dk>
 <20261013141046.GA12680@lst.de> <as6BMYAsWehHddlT@gsse-cloud1.jf.intel.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <as6BMYAsWehHddlT@gsse-cloud1.jf.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/13/26 20:06, Matthew Brost wrote:
> On Tue, Oct 13, 2026 at 04:10:47PM +0200, Christoph Hellwig wrote:
>> On Mon, Oct 12, 2026 at 02:21:41PM -0600, Jens Axboe wrote:
>>> I've queued this series up for some testing, in a separate branch. JFYI.
>>
>> More testing it obviously good.  I've been waiting for addressing
>> of the Sashiko comments on the nvme patches before doing more ACKs,
>> and while I can't really judge the code those in the dma-buf code
>> also look somewhat serious.  So it would be useful to get them addressed
>> and the series reposted.  Same for folding in the PI vs dmabuf fix
>> from Anuj, although making the combination work would of course be
>> even better.
>>
> 
> Oops, I forgot to look at Sashiko's feedback when I acked the dma-buf
> patch. I think the two cleanup issues are valid,

I stopped answering to sashiko as it repeats the same from version
to version when false positive. Those two are warning paths, which
should never happen, I'd rather leak than crash on double free or
so.

  but the reclaim-related
> ones are not. 

Thanks for confirming, you already elaborated on one of them in
previous revision, the new one looked to me as the same class of
issue as well.

I'm not sure why Sashiko is confused here.
> 
> I wonder if there are some shrinkers in the tree that incorrectly take
> dma-resv locks in a blocking manner. They should only use trylocks in
> shrinkers and direct reclaim paths.
-- 
Pavel Begunkov

