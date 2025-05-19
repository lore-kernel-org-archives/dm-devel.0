Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D537327586A
	for <dm-devel@lists.linux.dev>; Mon, 19 May 2025 11:39:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747654752; cv=none; b=lMi59TL+zlTikuaeg/F3IlEJU3G74uyp5S90DBrwJ+8KiDURu1uAOdzg7RfMadgWeUbg8KAUu7mNgdAJw0zF1cGm/4Xs48fPVfwrYWBg+Ygh2E69hjkBWjeoAGhe5X3FFBfbGpF4t7TUSwDdpq7sbjyiXK6T6k4Ef7xSc5PMVB0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747654752; c=relaxed/simple;
	bh=KXCx6vuDqf/6iEnqL4CpdSDwk+Kso+oeRkMYpk+jxBk=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=mZFTBW8oBTTuLq625stqhaXgozGQPldyOQYrFlitp+m+InEXjglsviQVkU9zmedEIgNJ+zQ9YEjRiAf8JbisArHExsvmVjrro6bIqLsPhoXSwpt7m5BykYbd6Ej08GzoTXui8eqANAPIIU7evNl8rKxYuXOkTauc75sbWTJ/A7o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4b1G156dHDzYQtw1
	for <dm-devel@lists.linux.dev>; Mon, 19 May 2025 19:39:05 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 278A71A018D
	for <dm-devel@lists.linux.dev>; Mon, 19 May 2025 19:39:05 +0800 (CST)
Received: from [10.174.179.143] (unknown [10.174.179.143])
	by APP4 (Coremail) with SMTP id gCh0CgDnSl9XGCtoU+Z_Mw--.36004S3;
	Mon, 19 May 2025 19:39:05 +0800 (CST)
Subject: Re: [PATCH] md/raid1,raid10: don't pass down the REQ_RAHEAD flag
To: Yu Kuai <yukuai1@huaweicloud.com>, Mikulas Patocka <mpatocka@redhat.com>
Cc: Song Liu <song@kernel.org>, zkabelac@redhat.com,
 linux-raid@vger.kernel.org, dm-devel@lists.linux.dev,
 "yukuai (C)" <yukuai3@huawei.com>
References: <34fa755d-62c8-4588-8ee1-33cb1249bdf2@redhat.com>
 <98ac5772-9931-17fd-1fc4-18d2c737b079@huaweicloud.com>
 <04231d91-cf1f-a932-f24f-996f888f0dd7@redhat.com>
 <c561484d-f056-2531-8fd6-27be0dabca05@redhat.com>
 <10db5f49-0662-49da-9535-75aded725950@huaweicloud.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <b560f87d-0072-91be-2a87-43f3510737d1@huaweicloud.com>
Date: Mon, 19 May 2025 19:39:03 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <10db5f49-0662-49da-9535-75aded725950@huaweicloud.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgDnSl9XGCtoU+Z_Mw--.36004S3
X-Coremail-Antispam: 1UD129KBjvJXoW7tF4kArW7CF4UZr4fGF4kZwb_yoW8uFy7pw
	srWa4I93yDG3yUA3ZrZ3y7ZayrG3W5Ka45CFyrZ3y8Zr1YqFZxAFWktayagrZ8Xr10g3y2
	vr4Dt3yUWFyrtFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
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

ÔÚ 2025/05/19 19:19, Yu Kuai Ð´µÀ:
>> The commit e879a0d9cb08 ("md/raid1,raid10: don't ignore IO flags") breaks
>> the lvm2 test shell/lvcreate-large-raid.sh. The commit changes raid1 and
>> raid10 to pass down all the flags from the incoming bio. The problem is
>> when we pass down the REQ_RAHEAD flag - bios with this flag may fail
>> anytime and md-raid is not prepared to handle this failure.
> 
> Can dm-raid handle this falg? At least from md-raid array, for read
> ahead IO, it doesn't make sense to kill that flag.
> 
> If we want to fall back to old behavior, can we kill that flag from
> dm-raid?

Please ignore the last reply, I misunderstand your commit message, I
thought you said dm-raid, actually you said mdraid, and it's correct,
if read_bio faild raid1/10 will set badblocks which is not expected.

Then for reada head IO, I still think don't kill REQ_RAHEAD for
underlying disks is better, what do you think about skip handling IO
error for ead ahead IO?

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 657d481525be..b8b4fead31f3 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -380,7 +380,10 @@ static void raid1_end_read_request(struct bio *bio)
                 /* This was a fail-fast read so we definitely
                  * want to retry */
                 ;
-       else {
+       else if (bio->bi_opf & REQ_RAHEAD) {
+               /* don't handle readahead error, which can fail at 
anytime. */
+               uptodate = 1;
+       } else {
                 /* If all other devices have failed, we want to return
                  * the error upwards rather than fail the last device.
                  * Here we redefine "uptodate" to mean "Don't want to 
retry"
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index dce06bf65016..4d51aaf3b39b 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -399,6 +399,9 @@ static void raid10_end_read_request(struct bio *bio)
                  * wait for the 'master' bio.
                  */
                 set_bit(R10BIO_Uptodate, &r10_bio->state);
+       } else if (bio->bi_opf & REQ_RAHEAD) {
+               /* don't handle readahead error, which can fail at 
anytime. */
+               uptodate = 1;
         } else {
                 /* If all other devices that store this block have
                  * failed, we want to return the error upwards rather

Thanks,
Kuai

