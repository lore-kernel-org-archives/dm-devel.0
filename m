Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0A392C64EC4
	for <dm-devel@archiver.kernel.org>; Tue,  7 Mar 2023 02:12:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1678155143;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=e1HbvEDTnPAfWY36ydVrTp3wsf4vTunAaby4idD3tdY=;
	b=SwlE3TFtnlqOFoyEFYaljdMDE0xgKuabj+SvA8L+QR9ltPTdnq9iR0/bhufTnqY3bVmUyw
	GfADH/8k/uygU8btSwFDWMfkB7huauTmeqnmM6tGTDkIOeQRvfi2T8/50G2iIYyr1RYQrz
	qm67tO0kUF4Z0vMuJkG5+vbwLcaBgqA=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-570-Z5bZPXhINs2DsEUguLCOsQ-1; Mon, 06 Mar 2023 21:12:20 -0500
X-MC-Unique: Z5bZPXhINs2DsEUguLCOsQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E5C24101A52E;
	Tue,  7 Mar 2023 02:12:18 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 759531410DD9;
	Tue,  7 Mar 2023 02:12:18 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 579F21946594;
	Tue,  7 Mar 2023 02:12:18 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id DE2EB1946589
 for <dm-devel@listman.corp.redhat.com>; Tue,  7 Mar 2023 02:12:16 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 8BC3540CF8F0; Tue,  7 Mar 2023 02:12:16 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 846474010E7B
 for <dm-devel@redhat.com>; Tue,  7 Mar 2023 02:12:16 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6A557299E743
 for <dm-devel@redhat.com>; Tue,  7 Mar 2023 02:12:16 +0000 (UTC)
Received: from dggsgout12.his.huawei.com (hwsga02-in.huaweimarine.com
 [45.249.212.56]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-396-VIm8GuCaPd-m8SpUB57Jog-1; Mon, 06 Mar 2023 21:12:14 -0500
X-MC-Unique: VIm8GuCaPd-m8SpUB57Jog-1
Received: from mail02.huawei.com (unknown [172.30.67.143])
 by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4PVzTz4wWVz4f3jJC;
 Tue,  7 Mar 2023 10:12:07 +0800 (CST)
Received: from [10.174.176.117] (unknown [10.174.176.117])
 by APP4 (Coremail) with SMTP id gCh0CgCHOa12nQZks2uNEw--.20984S2;
 Tue, 07 Mar 2023 10:12:09 +0800 (CST)
To: Mike Snitzer <snitzer@kernel.org>
References: <20230306134930.2878660-1-houtao@huaweicloud.com>
 <ZAY/o9ew9AtrCLE5@redhat.com>
From: Hou Tao <houtao@huaweicloud.com>
Message-ID: <e9b61952-98a8-6e3b-2d85-6aaf07208a7b@huaweicloud.com>
Date: Tue, 7 Mar 2023 10:12:06 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <ZAY/o9ew9AtrCLE5@redhat.com>
X-CM-TRANSID: gCh0CgCHOa12nQZks2uNEw--.20984S2
X-Coremail-Antispam: 1UD129KBjvdXoW7Wr13Gr4fGr4xAFWkKr45KFg_yoWDKFXE9a
 1FgFyxGw409Fn7tF1qyr43Jr93Xa1kJa1DKrWUX3y7Kr93Z39Yq3ZY9ryfC3W8Za4ayF9x
 ursIvasFvw1qgjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
 9fnUUIcSsGvfJTRUUUbzAYFVCjjxCrM7AC8VAFwI0_Jr0_Gr1l1xkIjI8I6I8E6xAIw20E
 Y4v20xvaj40_Wr0E3s1l1IIY67AEw4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28CjxkF64kEwV
 A0rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVWDJVCq3wA2z4x0Y4vE2Ix0cI8IcVCY1x02
 67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I
 0E14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40E
 x7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x
 0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lc7I2V7IY0VAS07AlzVAYIcxG8wCF04k20xvY0x0E
 wIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E74
 80Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_JF0_Jw1lIxkGc2Ij64vIr41lIxAIcVC0
 I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Jr0_Gr1lIxAIcVCF04
 k26cxKx2IYs7xG6rW3Jr0E3s1lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY
 1x0267AKxVWUJVW8JbIYCTnIWIevJa73UjIFyTuYvjxUzsqWUUUUU
X-CM-SenderInfo: xkrx3t3r6k3tpzhluzxrxghudrp/
X-CFilter-Loop: Reflected
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
Subject: Re: [dm-devel] dm crypt: initialize tasklet in crypt_io_init()
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/dm-devel/>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=subscribe>
Cc: dm-devel@redhat.com, houtao1@huawei.com, linux-kernel@vger.kernel.org,
 Alasdair Kergon <agk@redhat.com>, Ignat Korchagin <ignat@cloudflare.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi,

On 3/7/2023 3:31 AM, Mike Snitzer wrote:
> On Mon, Mar 06 2023 at  8:49P -0500,
> Hou Tao <houtao@huaweicloud.com> wrote:
>
>> From: Hou Tao <houtao1@huawei.com>
>>
>> When neither no_read_workqueue nor no_write_workqueue are enabled,
>> tasklet_trylock() in crypt_dec_pending() may still return false due to
>> an uninitialized state, and dm-crypt will do io completion in io_queue
>> instead of current context unnecessarily.
> Have you actually experienced this?
Yes. I had written a bpftrace script to check the completion context of
blkdev_bio_end_io_simple() when doing direct io read on dm-crypt device. The
expected context should be unbound workers of crypt_queue, but sometimes the
context is the bound worker of io_queue.
>
>> Fix it by initializing io->tasklet in crypt_io_init().
> Really would rather avoid always calling tasklet_init(). But I can
> optimize it away with a later patch.
My first though was "io->tasklet.state = 0", but it may be fragile because it
operated on the internal status of tasklet, so I switch to tasklet_init().
>
> Mike

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

