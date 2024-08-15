Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B63741AC898
	for <dm-devel@lists.linux.dev>; Thu, 15 Aug 2024 11:49:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723722582; cv=none; b=Ww2pKTQUOBf9MMlFnUe6HHOt9rFTAYinddMx8qWXmaOie4Arqg6GG/ske7YeVRlAJLV02nJyJN9YTiUgES9YQTP7LFgEwbFDZZ2JTHecnKmRAT5IASxiEywVIZfxKQ0RVCHp0FKn9eEX07dgyDQAYZmbBLBMKdDRacwIP9hHirk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723722582; c=relaxed/simple;
	bh=WfuYxv80qiIoFMl7csVF0Q6T6XtWknEkr8+3y5VdzJs=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=FzlJuxlNPeAxpqtfTXiK2oQxqH09qmXexIYaDrcQd6wzsaYkNMYwEwoq3vNi/qKNZVfX5a+OltQ6RFEvVowQvZBDTgvi6Q0eyfoV+JJNjWRo0insvuOctShTM3PshiY7l+wbGhcp360JE+YglqzhpOFimz+U6HdTa9z15YSvDCo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4Wl3Lp1pc1z4f3jXr
	for <dm-devel@lists.linux.dev>; Thu, 15 Aug 2024 19:49:22 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 16C2E1A018D
	for <dm-devel@lists.linux.dev>; Thu, 15 Aug 2024 19:49:36 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
	by APP4 (Coremail) with SMTP id gCh0CgBXfoRO671mhQ8LBw--.27439S3;
	Thu, 15 Aug 2024 19:49:35 +0800 (CST)
Subject: Re: PROBLEM: repeatable lockup on RAID-6 with LUKS dm-crypt on NVMe
 devices when rsyncing many files
To: Christian Theune <ct@flyingcircus.io>, Yu Kuai <yukuai1@huaweicloud.com>
Cc: John Stoffel <john@stoffel.org>,
 "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
 dm-devel@lists.linux.dev, "yukuai (C)" <yukuai3@huawei.com>
References: <ADF7D720-5764-4AF3-B68E-1845988737AA@flyingcircus.io>
 <EACD5B78-93F6-443C-BB5A-19C9174A1C5C@flyingcircus.io>
 <22C5E55F-9C50-4DB7-B656-08BEC238C8A7@flyingcircus.io>
 <26291.57727.410499.243125@quad.stoffel.home>
 <2EE0A3CE-CFF2-460C-97CD-262D686BFA8C@flyingcircus.io>
 <1dfc4792-02b2-5b3c-c3d1-bf1b187a182e@huaweicloud.com>
 <4363F3A3-46C2-419E-B43A-4CDA8C293CEB@flyingcircus.io>
 <C832C22B-E720-4457-83C6-CA259AD667B2@flyingcircus.io>
 <e92ccf15-be2a-a1aa-5ea2-a88def82e681@huaweicloud.com>
 <30D680B2-F494-42F5-8498-6ED586E05766@flyingcircus.io>
 <26294.40330.924457.532299@quad.stoffel.home>
 <C9A9855D-B0A2-4B13-947E-01AF5BA6DF04@flyingcircus.io>
 <26298.22106.810744.702395@quad.stoffel.home>
 <EBC67418-E60C-435A-8F63-114C67F07583@flyingcircus.io>
 <CEC90137-09B3-41AA-A115-1C172F9C6C4B@flyingcircus.io>
 <2F5F9789-1827-4105-934F-516582018540@flyingcircus.io>
 <adee77ef-f785-acd6-485a-fe2d0a1b9a92@huaweicloud.com>
 <CE700ADA-6AEF-4881-8F4F-85354E5F8C12@flyingcircus.io>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <9f53ae93-4046-7111-d0cc-25597fe6f0bb@huaweicloud.com>
Date: Thu, 15 Aug 2024 19:49:34 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <CE700ADA-6AEF-4881-8F4F-85354E5F8C12@flyingcircus.io>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgBXfoRO671mhQ8LBw--.27439S3
X-Coremail-Antispam: 1UD129KBjvJXoWxZr4rJFWrXFyxCF4fGw13CFg_yoW5Jw43pF
	ZrXas09rs8tr1rWwnrA34rXFyFyr9xAF9xXFyrW3s8ua4UJFnIqF4IkFWY9F1qywn3A3WY
	va1aqry5CF40qFDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvC14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26F1j6w1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26F4j
	6r4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
	Cq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0
	I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r
	4UM4x0Y48IcVAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwCYjI0SjxkI62AI1cAE67vI
	Y487MxkF7I0En4kS14v26r126r1DMxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r
	1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CE
	b7AF67AKxVWUAVWUtwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0x
	vE2Ix0cI8IcVCY1x0267AKxVWUJVW8JwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAI
	cVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2Kf
	nxnUUI43ZEXa7VUbSfO7UUUUU==
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

在 2024/08/15 19:24, Christian Theune 写道:
> Hi,
> 
>> On 15. Aug 2024, at 13:14, Yu Kuai <yukuai1@huaweicloud.com> wrote:
>>
>> Hi,
>>
>> 在 2024/08/15 18:03, Christian Theune 写道:
>>> Hi,
>>> small insight: even given my dataset that can reliably trigger this (after around 1.5 hours of rsyncing) it does not trigger on a specific set of files. I’ve deleted the data and started the rsync on a fresh directory (not a fresh filesystem, I can’t delete that as it carries important data) but it doesn’t always get stuck on the same files, even though rsync processes them in a repeatable order.
>>> I’m wondering how to generate more insights from that. Maybe keeping a blktrace log might help?
>>> It sounds like the specific pattern relies on XFS doing a specific thing there …
>>> Wild idea: maybe running the xfstest suite on an in-memory raid 6 setup could reproduce this?
>>> I’m guessing that the xfs people do not regularly run their test suite on a layered setup like mine with encryption and software raid?
>>
>> That sounds greate.
> 
> Alright. I will try that.
> 
>>>> @Yu: you mentioned that you might be able to provide me a kernel that produces more error logging to diagnose this? Any chance we could try that route?
>>
>> Yes, however, I still need some time to sort out the internal process of
>> raid5. I'm quite busy with some other work stuff and I'm familiar with
>> raid1/10, but not too much about raid5. :(
>>
>> Main idea is to figure out why IO are not dispatched to underlying
>> disks.
> 
> Sure, thanks - I’m happy to be patient. :)

Meanwhile, can you try the following patch to bypass bitmap? Let's
see what happens if bitmap counter will not block.

Noted with this patch, the bitmap will not work, and data can be
inconsistent after power failure.

Thanks,
Kuai

diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
index 0a2d37eb38ef..5ad51e9ad805 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -1463,8 +1463,7 @@ __acquires(bitmap->lock)

  int md_bitmap_startwrite(struct bitmap *bitmap, sector_t offset, 
unsigned long sectors, int behind)
  {
-       if (!bitmap)
-               return 0;
+       return 0;

         if (behind) {
                 int bw;
@@ -1528,8 +1527,8 @@ EXPORT_SYMBOL(md_bitmap_startwrite);
  void md_bitmap_endwrite(struct bitmap *bitmap, sector_t offset,
                         unsigned long sectors, int success, int behind)
  {
-       if (!bitmap)
-               return;
+       return;
+
         if (behind) {
                 if (atomic_dec_and_test(&bitmap->behind_writes))
                         wake_up(&bitmap->behind_wait);

> 
> Christian
> 

