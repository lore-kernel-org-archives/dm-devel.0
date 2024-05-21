Received: from dggsgout11.his.huawei.com (unknown [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61583634
	for <dm-devel@lists.linux.dev>; Tue, 21 May 2024 01:08:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716253742; cv=none; b=OsNFhjBF5xj5mJe4unjL7XmqvcuWBNk+40pUU8v1fSPoQOvzo8t439wgtRP/8ueXEgSPtqiflcNXwNWS70TNaY7EE5HIISnO53lTbm0loNYHmXlRzIqSfkmhAEcq97ArES6bRjC2sJJzsiLH9kKEDOcMNBaKRI97HclBZxhkdBQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716253742; c=relaxed/simple;
	bh=0VRRaR/3O3wMWddepqm1xcimmL+4ZkayhmSYYjCRsQA=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=rT+qU/yCxDM0w+iwHX+Rdqp/FPXvAk6zND0uYEFEBV4749Q2BIpp5keaWJIahzU0DX9eTjjGN+TzOHGAkLkuOsyIGjOzPgaeHGwO7UoZlCg2ccJ/QUpNGFbhWbR4ojxj9hpX4G6H/CsDL+ovM7plxxLLtIVO6f2gSnfNUP9mie8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4VjxCP5gsxz4f3jMM
	for <dm-devel@lists.linux.dev>; Tue, 21 May 2024 09:08:49 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id 87E961A083D
	for <dm-devel@lists.linux.dev>; Tue, 21 May 2024 09:08:55 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
	by APP1 (Coremail) with SMTP id cCh0CgBHGBEj9EtmPbjwNA--.15691S3;
	Tue, 21 May 2024 09:08:53 +0800 (CST)
Subject: Re: [bug report] INFO: task mdX_resync:42168 blocked for more than
 122 seconds
To: Changhui Zhong <czhong@redhat.com>, Yu Kuai <yukuai1@huaweicloud.com>
Cc: Ming Lei <ming.lei@redhat.com>,
 Linux Block Devices <linux-block@vger.kernel.org>, dm-devel@lists.linux.dev,
 Mike Snitzer <snitzer@kernel.org>, Mikulas Patocka <mpatocka@redhat.com>,
 Song Liu <song@kernel.org>, linux-raid@vger.kernel.org,
 Xiao Ni <xni@redhat.com>, "yukuai (C)" <yukuai3@huawei.com>,
 "yangerkun@huawei.com" <yangerkun@huawei.com>
References: <CAGVVp+Xsmzy2G9YuEatfMT6qv1M--YdOCQ0g7z7OVmcTbBxQAg@mail.gmail.com>
 <ZkXsOKV5d4T0Hyqu@fedora>
 <9b340157-dc0c-6e6a-3d92-f2c65b515461@huaweicloud.com>
 <CAGVVp+XtThX7=bZm441VxyVd-wv_ycdqMU=19a2pa4wUkbkJ3g@mail.gmail.com>
 <1b35a177-670a-4d2f-0b68-6eda769af37d@huaweicloud.com>
 <CAGVVp+WQVeV0PE12RvpojFTRB4rHXh6Lk01vLmdStw1W9zUACg@mail.gmail.com>
 <CAGVVp+WGyPS5nOQYhWtgJyQnXwUb-+Hui14pXqxd+-ZUjWpTrA@mail.gmail.com>
 <f1c98dd1-a62c-6857-3773-e05b80e6a763@huaweicloud.com>
 <CAGVVp+UdBekv2udwxtXBrtn0CMTrBa94oE4taUfynWncYF5ETQ@mail.gmail.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <0aef762b-ecc5-7dde-7020-08d1b85ed057@huaweicloud.com>
Date: Tue, 21 May 2024 09:08:51 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <CAGVVp+UdBekv2udwxtXBrtn0CMTrBa94oE4taUfynWncYF5ETQ@mail.gmail.com>
Content-Type: multipart/mixed;
 boundary="------------55A80B6ABFD688306F29E1A2"
X-CM-TRANSID:cCh0CgBHGBEj9EtmPbjwNA--.15691S3
X-Coremail-Antispam: 1UD129KBjvJXoWxJF43ArWDAr13KF1xJF18Krg_yoW5tr4xpa
	4Iva1akr48Zr109an2k3W2gFy0qa95Xr17t3yxGw1fJw12kF9xXayDJa1jgFnrur929w45
	Wa4UX343AF1FyFJanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUm014x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
	JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
	CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wASzI0EjI02j7AqF2xKxwAqx4xG64xvF2IE
	w4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMc
	vjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvEwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1l
	FcxC0VAYjxAxZF0Ex2IqxwACI402YVCY1x02628vn2kIc2xKxwCYjI0SjxkI62AI1cAE67
	vIY487MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAF
	wI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc4
	0Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AK
	xVW8JVWxJwCI42IY6xAIw20EY4v20xvaj40_WFyUJVCq3wCI42IY6I8E87Iv67AKxVWUJV
	W8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJwCE64xvF2IEb7IF0Fy7YxBIdaVFxhVj
	vjDU0xZFpf9x0JUQTmhUUUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

This is a multi-part message in MIME format.
--------------55A80B6ABFD688306F29E1A2
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit

Hi,

在 2024/05/20 18:38, Changhui Zhong 写道:
> On Mon, May 20, 2024 at 10:55 AM Yu Kuai <yukuai1@huaweicloud.com> wrote:
>>
>> Hi, Changhui
>>
>> 在 2024/05/20 8:39, Changhui Zhong 写道:
>>> [czhong@vm linux-block]$ git bisect bad
>>> 060406c61c7cb4bbd82a02d179decca9c9bb3443 is the first bad commit
>>> commit 060406c61c7cb4bbd82a02d179decca9c9bb3443
>>> Author: Yu Kuai<yukuai3@huawei.com>
>>> Date:   Thu May 9 20:38:25 2024 +0800
>>>
>>>       block: add plug while submitting IO
>>>
>>>       So that if caller didn't use plug, for example, __blkdev_direct_IO_simple()
>>>       and __blkdev_direct_IO_async(), block layer can still benefit from caching
>>>       nsec time in the plug.
>>>
>>>       Signed-off-by: Yu Kuai<yukuai3@huawei.com>
>>>       Link:https://lore.kernel.org/r/20240509123825.3225207-1-yukuai1@huaweicloud.com
>>>       Signed-off-by: Jens Axboe<axboe@kernel.dk>
>>>
>>>    block/blk-core.c | 6 ++++++
>>>    1 file changed, 6 insertions(+)
>>
>> Thanks for the test!
>>
>> I was surprised to see this blamed commit, and after taking a look at
>> raid1 barrier code, I found that there are some known problems, fixed in
>> raid10, while raid1 still unfixed. So I wonder this patch maybe just
>> making the exist problem easier to reporduce.
>>
>> I'll start cooking patches to sync raid10 fixes to raid1, meanwhile,
>> can you change your script to test raid10 as well, if raid10 is fine,
>> I'll give you these patches later to test raid1.
>>
>> Thanks,
>> Kuai
>>
> 
> Hi， Kuai
> 
> I tested raid10 and trigger this issue too，

Thanks for the test! Since raid10 has the same problem as well, then the
problem seems to be more common in raid. And related code to raid10 is
more simpler, attached is a patch to add debuginfo to raid10.

BTW, Xiao can reporduce the problem as well, and will lend a hand as
well.

Thanks,
Kuai
> 
> [  332.435340] Create raid10
> [  332.573160] device-mapper: raid: Superblocks created for new raid set
> [  332.595273] md/raid10:mdX: not clean -- starting background reconstruction
> [  332.595277] md/raid10:mdX: active with 4 out of 4 devices
> [  332.597017] mdX: bitmap file is out of date, doing full recovery
> [  332.603712] md: resync of RAID array mdX
> [  492.173892] INFO: task mdX_resync:3092 blocked for more than 122 seconds.
> [  492.180694]       Not tainted 6.9.0+ #1
> [  492.184536] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
> disables this message.
> [  492.192365] task:mdX_resync      state:D stack:0     pid:3092
> tgid:3092  ppid:2      flags:0x00004000
> [  492.192368] Call Trace:
> [  492.192370]  <TASK>
> [  492.192371]  __schedule+0x222/0x670
> [  492.192377]  schedule+0x2c/0xb0
> [  492.192381]  raise_barrier+0xc3/0x190 [raid10]
> [  492.192387]  ? __pfx_autoremove_wake_function+0x10/0x10
> [  492.192392]  raid10_sync_request+0x2c3/0x1ae0 [raid10]
> [  492.192397]  ? __schedule+0x22a/0x670
> [  492.192398]  ? prepare_to_wait_event+0x5f/0x190
> [  492.192401]  md_do_sync+0x660/0x1040
> [  492.192405]  ? __pfx_autoremove_wake_function+0x10/0x10
> [  492.192408]  md_thread+0xad/0x160
> [  492.192410]  ? __pfx_md_thread+0x10/0x10
> [  492.192411]  kthread+0xdc/0x110
> [  492.192414]  ? __pfx_kthread+0x10/0x10
> [  492.192416]  ret_from_fork+0x2d/0x50
> [  492.192420]  ? __pfx_kthread+0x10/0x10
> [  492.192421]  ret_from_fork_asm+0x1a/0x30
> [  492.192424]  </TASK>
> 
> Thanks，
> Changhui
> 
> 
> .
> 

--------------55A80B6ABFD688306F29E1A2
Content-Type: text/plain; charset=UTF-8;
 name="0001-raid10-debuginfo.patch"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="0001-raid10-debuginfo.patch"

RnJvbSBkNDQzYTViYzQzZWNkNDEzODZlOGU5MTAzY2Q1ZTE2OTE0YTFhMmMzIE1vbiBTZXAg
MTcgMDA6MDA6MDAgMjAwMQpGcm9tOiBZdSBLdWFpIDx5dWt1YWkzQGh1YXdlaS5jb20+CkRh
dGU6IE1vbiwgMjAgTWF5IDIwMjQgMTk6NDM6MjkgKzA4MDAKU3ViamVjdDogW1BBVENIXSB0
bXAKClNpZ25lZC1vZmYtYnk6IFl1IEt1YWkgPHl1a3VhaTNAaHVhd2VpLmNvbT4KLS0tCiBk
cml2ZXJzL21kL3JhaWQxMC5jIHwgNDkgKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKy0tLS0tCiAxIGZpbGUgY2hhbmdlZCwgNDQgaW5zZXJ0aW9ucygrKSwgNSBk
ZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9kcml2ZXJzL21kL3JhaWQxMC5jIGIvZHJpdmVy
cy9tZC9yYWlkMTAuYwppbmRleCBhNDU1NmQyZTQ2YmYuLmJjMDVkNGZmNTE4NSAxMDA2NDQK
LS0tIGEvZHJpdmVycy9tZC9yYWlkMTAuYworKysgYi9kcml2ZXJzL21kL3JhaWQxMC5jCkBA
IC0zMzEsNiArMzMxLDcgQEAgc3RhdGljIHZvaWQgcmFpZF9lbmRfYmlvX2lvKHN0cnVjdCBy
MTBiaW8gKnIxMF9iaW8pCiAJICovCiAJYWxsb3dfYmFycmllcihjb25mKTsKIAorCXByaW50
aygiJXM6IHIxMF9iaW8gJXB4IGRvbmVcbiIsIF9fZnVuY19fLCByMTBfYmlvKTsKIAlmcmVl
X3IxMGJpbyhyMTBfYmlvKTsKIH0KIApAQCAtODk5LDYgKzkwMCwzNCBAQCBzdGF0aWMgdm9p
ZCBmbHVzaF9wZW5kaW5nX3dyaXRlcyhzdHJ1Y3QgcjEwY29uZiAqY29uZikKIAkJc3Bpbl91
bmxvY2tfaXJxKCZjb25mLT5kZXZpY2VfbG9jayk7CiB9CiAKK3N0YXRpYyBib29sIGJhcnJp
ZXJfd2FpdGluZyhzdHJ1Y3QgcjEwY29uZiAqY29uZikKK3sKKwlpZiAoY29uZi0+bnJfd2Fp
dGluZykgeworCQlwcmludGsoIiVzOiBucl93YWl0aW5nICVkXG4iLCBfX2Z1bmNfXywgY29u
Zi0+bnJfd2FpdGluZyk7CisJCXJldHVybiBmYWxzZTsKKwl9CisKKwlyZXR1cm4gdHJ1ZTsK
K30KKworc3RhdGljIGJvb2wgdHJ5X3JhaXNlX2JhcnJpZXIoc3RydWN0IHIxMGNvbmYgKmNv
bmYpCit7CisJaW50IG5yOworCisJaWYgKGNvbmYtPmJhcnJpZXIgPj0gUkVTWU5DX0RFUFRI
KSB7CisJCXByaW50a19yYXRlbGltaXRlZCgiJXM6IHJlc3luYyBkZXB0aCBleGNlZWQgbGlt
aXRcbiIsIF9fZnVuY19fKTsKKwkJcmV0dXJuIGZhbHNlOworCX0KKworCW5yID0gYXRvbWlj
X3JlYWQoJmNvbmYtPm5yX3BlbmRpbmcpOworCWlmIChucikgeworCQlwcmludGsoIiVzOiBu
cl9wZW5kaW5nICVkXG4iLCBfX2Z1bmNfXywgbnIpOworCQlyZXR1cm4gZmFsc2U7CisJfQor
CisJcmV0dXJuIHRydWU7Cit9CisKIC8qIEJhcnJpZXJzLi4uLgogICogU29tZXRpbWVzIHdl
IG5lZWQgdG8gc3VzcGVuZCBJTyB3aGlsZSB3ZSBkbyBzb21ldGhpbmcgZWxzZSwKICAqIGVp
dGhlciBzb21lIHJlc3luYy9yZWNvdmVyeSwgb3IgcmVjb25maWd1cmUgdGhlIGFycmF5LgpA
QCAtOTI5LDE0ICs5NTgsMTMgQEAgc3RhdGljIHZvaWQgcmFpc2VfYmFycmllcihzdHJ1Y3Qg
cjEwY29uZiAqY29uZiwgaW50IGZvcmNlKQogCQlmb3JjZSA9IGZhbHNlOwogCiAJLyogV2Fp
dCB1bnRpbCBubyBibG9jayBJTyBpcyB3YWl0aW5nICh1bmxlc3MgJ2ZvcmNlJykgKi8KLQl3
YWl0X2V2ZW50X2JhcnJpZXIoY29uZiwgZm9yY2UgfHwgIWNvbmYtPm5yX3dhaXRpbmcpOwor
CXdhaXRfZXZlbnRfYmFycmllcihjb25mLCBmb3JjZSB8fCBiYXJyaWVyX3dhaXRpbmcoY29u
ZikpOwogCiAJLyogYmxvY2sgYW55IG5ldyBJTyBmcm9tIHN0YXJ0aW5nICovCiAJV1JJVEVf
T05DRShjb25mLT5iYXJyaWVyLCBjb25mLT5iYXJyaWVyICsgMSk7CiAKIAkvKiBOb3cgd2Fp
dCBmb3IgYWxsIHBlbmRpbmcgSU8gdG8gY29tcGxldGUgKi8KLQl3YWl0X2V2ZW50X2JhcnJp
ZXIoY29uZiwgIWF0b21pY19yZWFkKCZjb25mLT5ucl9wZW5kaW5nKSAmJgotCQkJCSBjb25m
LT5iYXJyaWVyIDwgUkVTWU5DX0RFUFRIKTsKKwl3YWl0X2V2ZW50X2JhcnJpZXIoY29uZiwg
dHJ5X3JhaXNlX2JhcnJpZXIoY29uZikpOwogCiAJd3JpdGVfc2VxdW5sb2NrX2lycSgmY29u
Zi0+cmVzeW5jX2xvY2spOwogfQpAQCAtMTAwNiw4ICsxMDM0LDEwIEBAIHN0YXRpYyBib29s
IHdhaXRfYmFycmllcihzdHJ1Y3QgcjEwY29uZiAqY29uZiwgYm9vbCBub3dhaXQpCiB7CiAJ
Ym9vbCByZXQgPSB0cnVlOwogCi0JaWYgKHdhaXRfYmFycmllcl9ub2xvY2soY29uZikpCisJ
aWYgKHdhaXRfYmFycmllcl9ub2xvY2soY29uZikpIHsKKwkJcHJpbnRrKCIlczogbnJfcGVu
ZGluZzogJWRcbiIsIF9fZnVuY19fLCBhdG9taWNfcmVhZCgmY29uZi0+bnJfcGVuZGluZykp
OwogCQlyZXR1cm4gdHJ1ZTsKKwl9CiAKIAl3cml0ZV9zZXFsb2NrX2lycSgmY29uZi0+cmVz
eW5jX2xvY2spOwogCWlmIChjb25mLT5iYXJyaWVyKSB7CkBAIC0xMDI0LDkgKzEwNTQsMTIg
QEAgc3RhdGljIGJvb2wgd2FpdF9iYXJyaWVyKHN0cnVjdCByMTBjb25mICpjb25mLCBib29s
IG5vd2FpdCkKIAkJCXdha2VfdXAoJmNvbmYtPndhaXRfYmFycmllcik7CiAJfQogCS8qIE9u
bHkgaW5jcmVtZW50IG5yX3BlbmRpbmcgd2hlbiB3ZSB3YWl0ICovCi0JaWYgKHJldCkKKwlp
ZiAocmV0KSB7CiAJCWF0b21pY19pbmMoJmNvbmYtPm5yX3BlbmRpbmcpOworCQlwcmludGso
IiVzOiBucl9wZW5kaW5nOiAlZFxuIiwgX19mdW5jX18sIGF0b21pY19yZWFkKCZjb25mLT5u
cl9wZW5kaW5nKSk7CisJfQogCXdyaXRlX3NlcXVubG9ja19pcnEoJmNvbmYtPnJlc3luY19s
b2NrKTsKKwogCXJldHVybiByZXQ7CiB9CiAKQEAgLTEwMzUsNiArMTA2OCw4IEBAIHN0YXRp
YyB2b2lkIGFsbG93X2JhcnJpZXIoc3RydWN0IHIxMGNvbmYgKmNvbmYpCiAJaWYgKChhdG9t
aWNfZGVjX2FuZF90ZXN0KCZjb25mLT5ucl9wZW5kaW5nKSkgfHwKIAkJCShjb25mLT5hcnJh
eV9mcmVlemVfcGVuZGluZykpCiAJCXdha2VfdXBfYmFycmllcihjb25mKTsKKworCXByaW50
aygiJXM6IG5yX3BlbmRpbmc6ICVkXG4iLCBfX2Z1bmNfXywgYXRvbWljX3JlYWQoJmNvbmYt
Pm5yX3BlbmRpbmcpKTsKIH0KIAogc3RhdGljIHZvaWQgZnJlZXplX2FycmF5KHN0cnVjdCBy
MTBjb25mICpjb25mLCBpbnQgZXh0cmEpCkBAIC0xMTg3LDYgKzEyMjIsOCBAQCBzdGF0aWMg
dm9pZCByYWlkMTBfcmVhZF9yZXF1ZXN0KHN0cnVjdCBtZGRldiAqbWRkZXYsIHN0cnVjdCBi
aW8gKmJpbywKIAogCWlmICghcmVndWxhcl9yZXF1ZXN0X3dhaXQobWRkZXYsIGNvbmYsIGJp
bywgcjEwX2Jpby0+c2VjdG9ycykpCiAJCXJldHVybjsKKworCXByaW50aygiJXM6IHIxMF9i
aW8gJXB4IHN0YXJ0XG4iLCBfX2Z1bmNfXywgcjEwX2Jpbyk7CiAJcmRldiA9IHJlYWRfYmFs
YW5jZShjb25mLCByMTBfYmlvLCAmbWF4X3NlY3RvcnMpOwogCWlmICghcmRldikgewogCQlp
ZiAoZXJyX3JkZXYpIHsKQEAgLTEzNzQsNiArMTQxMSw4IEBAIHN0YXRpYyB2b2lkIHJhaWQx
MF93cml0ZV9yZXF1ZXN0KHN0cnVjdCBtZGRldiAqbWRkZXYsIHN0cnVjdCBiaW8gKmJpbywK
IAlzZWN0b3JzID0gcjEwX2Jpby0+c2VjdG9yczsKIAlpZiAoIXJlZ3VsYXJfcmVxdWVzdF93
YWl0KG1kZGV2LCBjb25mLCBiaW8sIHNlY3RvcnMpKQogCQlyZXR1cm47CisKKwlwcmludGso
IiVzOiByMTBfYmlvICVweCBzdGFydFxuIiwgX19mdW5jX18sIHIxMF9iaW8pOwogCWlmICh0
ZXN0X2JpdChNRF9SRUNPVkVSWV9SRVNIQVBFLCAmbWRkZXYtPnJlY292ZXJ5KSAmJgogCSAg
ICAobWRkZXYtPnJlc2hhcGVfYmFja3dhcmRzCiAJICAgICA/IChiaW8tPmJpX2l0ZXIuYmlf
c2VjdG9yIDwgY29uZi0+cmVzaGFwZV9zYWZlICYmCi0tIAoyLjM5LjIKCg==
--------------55A80B6ABFD688306F29E1A2--

