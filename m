Received: from va-2-26.ptr.blmpb.com (va-2-26.ptr.blmpb.com [209.127.231.26])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8DDB2F362B
	for <dm-devel@lists.linux.dev>; Tue, 14 Apr 2026 06:20:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.26
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776147660; cv=none; b=L1b8HTuROhQa7NNX0r6DxZq+FFZWo97XLdgTGN/+yQXLhMHAzq1QTHBHqTULF+q/3K+rBYsz6c8ewE7CbMFRbprkuDwguhuvTLo3MVmUbdTzuHo5fV3BS8YqAQZdMx48O+jkjtwDBfoqTnqF8UfPP3UdVsA2WWGcVEJ6c+vumYM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776147660; c=relaxed/simple;
	bh=adDnJTbmOAkkTbAC/CrZrJCFwMvvEFA+H33FAoiuRyg=;
	h=Cc:Date:References:From:To:Subject:Message-Id:Mime-Version:
	 Content-Type:In-Reply-To; b=CqX7B0mcu6NV84p8OkJODYe67KRWwqZKhewmIgeypWWLRBA93dw3JK6FliQQpj2jYCCd5fi/ZMGXRwbvwXqf/GRC2kKopY1SAyumMb7i2yTidnW8NRKJ1oOSIKC9izBVexxDu61rsBmzolM/l3jlej7D7+T4kqkDDL8Wa7M2oPg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=none smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=jhplXVn+; arc=none smtp.client-ip=209.127.231.26
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="jhplXVn+"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1776147647;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=adDnJTbmOAkkTbAC/CrZrJCFwMvvEFA+H33FAoiuRyg=;
 b=jhplXVn+lTr/o5FOOYAt0zpid7H17J9DPPc1wQek/fdw6UgvKjvTElRwR3JeMrGgzYTfho
 pybXSFTB3treXaufF1pv+tgKz0U6YulGVOcvqG1pxpsK83Bzebuhwn3I6frt6ggTjpF380
 ha1R038jF5EsPlBqaVFuWVaVpbl4JtcaJKl7OM6SPX2HviQ2YUtM7tzPtnbSZeQOINC6jK
 KXF4h081TMdfChNqWaay+zWVemvIYdQf8lFcdv6Ac/kueZfDi9e23lXeEDzRM/xdn3Owzu
 FoDlQvyjebxndIH43VWljJFwH1ECugH25YjS1yQHYkFXX8rrNHCST/ZRCKXoMQ==
Content-Transfer-Encoding: quoted-printable
Content-Language: en-US
Cc: <linux-raid@vger.kernel.org>, <dm-devel@lists.linux.dev>, 
	"Xiao Ni" <xni@redhat.com>, "Nigel Croxon" <ncroxon@redhat.com>
Date: Tue, 14 Apr 2026 14:20:40 +0800
X-Original-From: Yu Kuai <yukuai@fnnas.com>
References: <20260413224556.1914504-1-bmarzins@redhat.com> <0e53701a-2471-9b72-eef8-27b168a0f3ea@huaweicloud.com>
Reply-To: yukuai@fnnas.com
From: "Yu Kuai" <yukuai@fnnas.com>
X-Lms-Return-Path: <lba+269dddcbd+7a92e4+lists.linux.dev+yukuai@fnnas.com>
To: "Li Nan" <linan666@huaweicloud.com>, 
	"Benjamin Marzinski" <bmarzins@redhat.com>, 
	"Yu Kuai" <yukuai@alb-78bjiv52429oh8qptp.cn-shenzhen.alb.aliyuncs.com>, 
	"Song Liu" <song@kernel.org>, <yukuai@fnnas.com>
Subject: Re: [PATCH] md/raid5: Don't set bi_status on STRIPE_WAIT_RESHAPE
Message-Id: <717caf7b-03ef-41d8-bbb3-f6ce5d4a49fa@fnnas.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
User-Agent: Mozilla Thunderbird
Received: from [192.168.1.104] ([39.182.0.184]) by smtp.feishu.cn with ESMTPS; Tue, 14 Apr 2026 14:20:43 +0800
Content-Type: text/plain; charset=UTF-8
In-Reply-To: <0e53701a-2471-9b72-eef8-27b168a0f3ea@huaweicloud.com>

Hi,

=E5=9C=A8 2026/4/14 9:25, Li Nan =E5=86=99=E9=81=93:
>
>
> =E5=9C=A8 2026/4/14 6:45, Benjamin Marzinski =E5=86=99=E9=81=93:
>> When make_stripe_request() encounters a clone bio that crosses the
>> reshape position while the reshape cannot make progress, it was setting
>> bi->bi_status to BLK_STS_RESOURCE when returning STRIPE_WAIT_RESHAPE.
>> This will update the original bio's bi_status in md_end_clone_io().
>> Afterwards, md_handle_request() will wait for the device to become
>> unsuspended and submit a new cloned bio. However, even if that clone
>> completes successfully, it will not clear the original bio's bi_status.
>>
>> There's no need to set bi_status when retrying the bio. md will already
>> error out the bio correctly if it is set REQ_NOWAIT. Otherwise it will
>> be retried. dm-raid will already end the bio with DM_MAPIO_REQUEUE.
>>
>> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
>> ---
>> =C2=A0 drivers/md/raid5.c | 1 -
>> =C2=A0 1 file changed, 1 deletion(-)
>>
>> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
>> index dc0c680ca199..690c65cd1e29 100644
>> --- a/drivers/md/raid5.c
>> +++ b/drivers/md/raid5.c
>> @@ -6042,7 +6042,6 @@ static enum stripe_result=20
>> make_stripe_request(struct mddev *mddev,
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 raid5_release_stripe(sh);
>> =C2=A0 out:
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (ret =3D=3D STRIPE_SCHEDULE_AND_RETRY =
&&=20
>> reshape_interrupted(mddev)) {
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 bi->bi_status =3D BLK_STS_RE=
SOURCE;
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ret =3D STRIPE_WA=
IT_RESHAPE;
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 pr_err_ratelimite=
d("dm-raid456: io across reshape position=20
>> while reshape can't make progress");
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>
> The link below leads to the same patch, which Kuai has already replied=20
> to.
>
> https://lore.kernel.org/all/20260203095156.2349174-1-yangxiuwei@kylinos.c=
n/

Perhaps instead of clearing the error code from error path, this problem ca=
n be fixed
by resetting the error code from the issue path if original bio is resubmit=
ted.

>
>
> --=20
> Thanks,
> Nan
>
>
--=20
Thansk,
Kuai
