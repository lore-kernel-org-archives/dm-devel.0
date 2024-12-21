Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 158492AE77
	for <dm-devel@lists.linux.dev>; Sat, 21 Dec 2024 02:34:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734748459; cv=none; b=OaOrbO+//g0eOQMN3LLa5Mdb0tLVD0WYjvfBqRnqFbpxIhyyXOn5xWhM6yzu6KUBwvdOYOiDY4I4Mi3eM3POGr3rtoQF9lcKsOct+KFueSKQPFkec7xL27VdbBGLoy89PtaR3nkNAxMkOpekfzYWQfgXKtMHQZDMnULNp7o+MjY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734748459; c=relaxed/simple;
	bh=ITJv1jAxpqYbeMnOODyIjFLwzbxKRE5ow5Fh06ZFLj0=;
	h=From:Subject:To:Message-ID:Date:MIME-Version:Content-Type; b=WfwZu2jFVIpBmKJPyiMDqewk3EbH4KiacNL/X+uZ7X8ygf8NY3HCOjZBYuhKhnRK9jA+DPjq/lNPeX3qcqtwBuGZ1je0SyAlWFZtaJHHUqbNjxjZXMvSVq4wx70Kg7om8U/Bab8nZ6jeqmv8r3USou6SFkJU8DMvvOakCsNeAk4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4YFSyh1lzVz4f3jMw
	for <dm-devel@lists.linux.dev>; Sat, 21 Dec 2024 10:33:48 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id CDB0B1A0568
	for <dm-devel@lists.linux.dev>; Sat, 21 Dec 2024 10:34:07 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
	by APP4 (Coremail) with SMTP id gCh0CgCnzoIeKWZnmM7CFA--.62580S3;
	Sat, 21 Dec 2024 10:34:07 +0800 (CST)
From: Yu Kuai <yukuai1@huaweicloud.com>
Subject: [discussion] proposal to bypass zero data for dm-crypt
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
 Mikulas Patocka <mpatocka@redhat.com>, dm-devel@lists.linux.dev,
 lkml <linux-kernel@vger.kernel.org>, "yukuai (C)" <yukuai3@huawei.com>
Message-ID: <73152f2b-2a3e-37a7-4578-9a4ae7ec903f@huaweicloud.com>
Date: Sat, 21 Dec 2024 10:34:05 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:gCh0CgCnzoIeKWZnmM7CFA--.62580S3
X-Coremail-Antispam: 1UD129KBjvdXoWrKF1UCry3XF1fAFW7ArW7CFg_yoWfJrb_XF
	98WrWDG340yrWrAa17tFWfXr9xtrZ0kayrXayUt3ZrK3s5XwnxXFnrurWvv34Iqw45JF4k
	ur4fXFyxWw15WjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUb4kYFVCjjxCrM7AC8VAFwI0_Gr0_Xr1l1xkIjI8I6I8E6xAIw20E
	Y4v20xvaj40_Wr0E3s1l1IIY67AEw4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28CjxkF64kEwV
	A0rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVW5JVW7JwA2z4x0Y4vE2Ix0cI8IcVCY1x02
	67AKxVWxJVW8Jr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxV
	AFwI0_GcCE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2
	j2WlYx0E2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7x
	kEbVWUJVW8JwACjcxG0xvEwIxGrwCYjI0SjxkI62AI1cAE67vIY487MxkF7I0En4kS14v2
	6r126r1DMxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrV
	AFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUAVWUtwCI
	c40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267
	AKxVWUJVW8JwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_
	Gr1lIxAIcVC2z280aVCY1x0267AKxVWUJVW8JbIYCTnIWIevJa73UjIFyTuYvjxUwxhLUU
	UUU
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Background

We provide virtual machines for customers to use, which include an 
important feature: in the initial state, the disks in the virtual 
machine do not occupy actual storage space, and the data read by users 
is all zeros until the user writes data for the first time. This can 
save a large amount of storage.

Problem

However, after introducing dm-crypt, this feature has failed. Because we 
expect the data read by users in the initial state to be zero, we have 
to write all zeros from dm-crypt.

Hence we'd like to propose to bypass zero data for dm-crypt, for
example:

before:
zero data -> encrypted zero data
decrypted zero data -> zero data
others

after:
zero data -> zero data
decrypted zero data -> encrypted zero data
others(doesn't change)

We'd like to hear from the community for suggestions first, before we
start. :)

Thanks,
Kuai

