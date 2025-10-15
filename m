Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D15E6315D21
	for <dm-devel@lists.linux.dev>; Wed, 15 Oct 2025 07:58:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760515083; cv=none; b=CxRL9HBcd4yGe+YOIvTxgnbAMeIXVW1eRn+t0rxIl7GPDqimymv8V8x0TtQRRwz96pMxLrb5EEtEPrUL7ChkxIVspPP2s2mVwea2lYoMAMsDCW9ktZ8OlJCR4Rc3n3L+o/qZhtQ3sNgFLWKAGIxIRepYYZOOZS0HWwk3TSoIlBs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760515083; c=relaxed/simple;
	bh=1YYw4Jn3tvdoPcbTs2nVqXtk638BBLY5zWdTwzXZZwU=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=TzG3YEdjgrbvYt/ux4slSk1OoKFM8LoT9qf3X3nh5WTOKSsCy0B4V1UNdNjU3itwx5yk4BUiJH2Qf9SW10Tk2xYp/Dc5eqV8DV1eiizI5gg7ZmVYL6zTG1bcDpC9ZD/6v8qG3yJuVhXRjE9XhWQa2ii4IK9Rs3P5jcXzRUQftmk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4cmk2M4dp0zKHMVk
	for <dm-devel@lists.linux.dev>; Wed, 15 Oct 2025 15:57:15 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.75])
	by mail.maildlp.com (Postfix) with ESMTP id 0CA8F1A1D33
	for <dm-devel@lists.linux.dev>; Wed, 15 Oct 2025 15:57:53 +0800 (CST)
Received: from [10.174.179.143] (unknown [10.174.179.143])
	by APP2 (Coremail) with SMTP id Syh0CgBHnET_U+9o0MK8AQ--.58742S3;
	Wed, 15 Oct 2025 15:57:52 +0800 (CST)
Subject: Re: [PATCH] md: fix rcu protection in md_wakeup_thread
To: "Zhou, Yun" <yun.zhou@windriver.com>, Yu Kuai <yukuai1@huaweicloud.com>,
 Paul Menzel <pmenzel@molgen.mpg.de>
Cc: agk@redhat.com, snitzer@kernel.org, mpatocka@redhat.com, song@kernel.org,
 dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
 linux-raid@vger.kernel.org, "yukuai (C)" <yukuai3@huawei.com>
References: <20251015055924.899423-1-yun.zhou@windriver.com>
 <86705912-07a3-4a24-bacd-ad5ac2038201@molgen.mpg.de>
 <d2574af5-9410-d296-ef74-97f3e43dc1cc@huaweicloud.com>
 <040131e6-08f7-4f64-a317-deaa21e1a5e1@windriver.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <e60b45da-e37d-5530-1511-f6e56effebb2@huaweicloud.com>
Date: Wed, 15 Oct 2025 15:57:50 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <040131e6-08f7-4f64-a317-deaa21e1a5e1@windriver.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:Syh0CgBHnET_U+9o0MK8AQ--.58742S3
X-Coremail-Antispam: 1UD129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7v73
	VFW2AGmfu7bjvjm3AaLaJ3UjIYCTnIWjp_UUUYt7AC8VAFwI0_Gr0_Xr1l1xkIjI8I6I8E
	6xAIw20EY4v20xvaj40_Wr0E3s1l1IIY67AEw4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28Cjx
	kF64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVW7JVWDJwA2z4x0Y4vE2Ix0cI8I
	cVCY1x0267AKxVWxJVW8Jr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2js
	IEc7CjxVAFwI0_GcCE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE
	5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeV
	CFs4IE7xkEbVWUJVW8JwACjcxG0xvEwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lFIxG
	xcIEc7CjxVA2Y2ka0xkIwI1lc7I2V7IY0VAS07AlzVAYIcxG8wCF04k20xvY0x0EwIxGrw
	CF54CYxVCY1x0262kKe7AKxVWUtVW8ZwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02
	F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GF
	ylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7Cj
	xVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r
	1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUd
	HUDUUUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

在 2025/10/15 15:31, Zhou, Yun 写道:
> This method only changes a little code. But it holds the lock before the 
> function jumps, which seems to violate the principle of minimizing the 
> critical area.

use rcu to protect the function is fine, all related code is not from
IO fast path.

Please also notice this patch is impossible for stable backport because
of too much modifications.

Thanks,
Kuai

