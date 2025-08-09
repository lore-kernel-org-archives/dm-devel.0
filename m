Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B90B981724
	for <dm-devel@lists.linux.dev>; Sat,  9 Aug 2025 11:37:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754739429; cv=none; b=dIP0/9uO5xGOFLGxn0GWyk1W44rls9s6IUE2xiLo/3sjd2Ec91+uxll+GamTCMvDOLP93YbAowDa3cW89QqRMzZXFGLDau0BJErOZFhqFymapFIlWAY5AyItS8glTwofRBXV4CCrsoi/EoiCWMpH8LBK8I6qv0B7flaAZkpkV9w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754739429; c=relaxed/simple;
	bh=LdJofZ5ShRUrVsjbg1D/vDlO2pfiQu/0iaJWcXgl0yI=;
	h=From:Subject:To:Cc:References:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=m2Mp2DeyfW0wnJlz/R2m4+KNwYmIGK0TDdX+c5XDjQr2gR5xqW08UZX5m9IC8FeLXU2d5sv5TPa9+7m1iBx0Pmc7Yx5j27Imm/1qmelLxlRXh2FHW8LsoS4Xad56TaBsk2mII7MOMpdq8VvDGd8j/Hcv5c9rqFEabBWKVnxevyY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4bzf4k5RCKzKHMcC
	for <dm-devel@lists.linux.dev>; Sat,  9 Aug 2025 19:36:54 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id E22171A018D
	for <dm-devel@lists.linux.dev>; Sat,  9 Aug 2025 19:36:53 +0800 (CST)
Received: from [10.174.177.163] (unknown [10.174.177.163])
	by APP4 (Coremail) with SMTP id gCh0CgC3fg_SMpdo0SplDA--.26099S2;
	Sat, 09 Aug 2025 19:36:53 +0800 (CST)
From: Hou Tao <houtao@huaweicloud.com>
Subject: Re: [PATCH] dm: ima: more strlen() drops
To: Dmitry Antipov <dmantipov@yandex.ru>, Alasdair Kergon <agk@redhat.com>,
 Mike Snitzer <snitzer@kernel.org>, Mikulas Patocka <mpatocka@redhat.com>
Cc: dm-devel@lists.linux.dev
References: <20250805103541.490377-1-dmantipov@yandex.ru>
Message-ID: <eb8129bb-bef8-8481-8c03-555e5744e390@huaweicloud.com>
Date: Sat, 9 Aug 2025 19:36:50 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20250805103541.490377-1-dmantipov@yandex.ru>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-CM-TRANSID:gCh0CgC3fg_SMpdo0SplDA--.26099S2
X-Coremail-Antispam: 1UD129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7v73
	VFW2AGmfu7bjvjm3AaLaJ3UjIYCTnIWjp_UUUYI7kC6x804xWl14x267AKxVWUJVW8JwAF
	c2x0x2IEx4CE42xK8VAvwI8IcIk0rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII
	0Yj41l84x0c7CEw4AK67xGY2AK021l84ACjcxK6xIIjxv20xvE14v26F1j6w1UM28EF7xv
	wVC0I7IYx2IY6xkF7I0E14v26F4j6r4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7
	xvwVC2z280aVCY1x0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40E
	FcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr
	0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcVAKI48JMxk0xIA0c2IEe2xFo4CEbIxv
	r21l42xK82IYc2Ij64vIr41l4c8EcI0Ec7CjxVAaw2AFwI0_JF0_Jw1l4I8I3I0E4IkC6x
	0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2
	zVAF1VAY17CE14v26r126r1DMIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF
	4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWU
	CwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCT
	nIWIevJa73UjIFyTuYvjxUzsqWUUUUU
X-CM-SenderInfo: xkrx3t3r6k3tpzhluzxrxghudrp/



On 8/5/2025 6:35 PM, Dmitry Antipov wrote:
> Following commit ebbd17695e9e ("dm: ima: avoid extra calls to
> strlen()"), convert 'dm_ima_alloc_and_copy_capacity_str()' to
> return the number of characters emitted by 'scnprintf()' and
> simplify the users accordingly. Compile tested only.
>
> Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>

Reviewed-by: Hou Tao <houtao1@huawei.com>

