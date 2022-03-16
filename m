Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 19BB6C433F5
	for <dm-devel@archiver.kernel.org>; Wed, 16 Mar 2022 23:30:47 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-584-XtNuzjYWMcqjy7XBw33qYQ-1; Wed, 16 Mar 2022 19:30:43 -0400
X-MC-Unique: XtNuzjYWMcqjy7XBw33qYQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E9108185A7BA;
	Wed, 16 Mar 2022 23:30:41 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id A43E4C28100;
	Wed, 16 Mar 2022 23:30:40 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 6E2D51949763;
	Wed, 16 Mar 2022 23:30:40 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 1F92F1949761
 for <dm-devel@listman.corp.redhat.com>; Wed, 16 Mar 2022 23:30:40 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 0AE6DC28107; Wed, 16 Mar 2022 23:30:40 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 06AB4C28100
 for <dm-devel@redhat.com>; Wed, 16 Mar 2022 23:30:39 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D86863803501
 for <dm-devel@redhat.com>; Wed, 16 Mar 2022 23:30:39 +0000 (UTC)
Received: from mout.gmx.net (mout.gmx.net [212.227.17.21]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-652-sDkEAx2yPziQ-E9hGetbmw-1; Wed, 16 Mar 2022 19:30:38 -0400
X-MC-Unique: sDkEAx2yPziQ-E9hGetbmw-1
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.net (mrgmx104
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1MNKhm-1njOoy0auw-00Oq4X; Thu, 17
 Mar 2022 00:30:34 +0100
Message-ID: <99f7371d-f818-f533-d82b-71729a5bfb9d@gmx.com>
Date: Thu, 17 Mar 2022 07:30:30 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
To: Josef Bacik <josef@toxicpanda.com>, Qu Wenruo <wqu@suse.com>
References: <20211201051756.53742-1-wqu@suse.com>
 <20211201051756.53742-12-wqu@suse.com>
 <YjI+hkhhTTWMmPkz@localhost.localdomain>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
In-Reply-To: <YjI+hkhhTTWMmPkz@localhost.localdomain>
X-Provags-ID: V03:K1:gIK32EJoOO5bu//AY9fiTTXVQGmcy8/RH/SJQkoLy1CqCCD6YXU
 Aj7i0u6LDFMEVOMHUFzRgdiGVdhM5b/YEVbhmI1oH9t2Xya7fdVSWDF8NV6vqlQVEyb5yIG
 gSt4ibL2JA2J8+L1sWs6/VWl3GpOD0YfauA9tJ4pAIY6tMWbN3EKSTvfiDq0Q0iZhO18I95
 0ynMUpHrleUlAOhHlcB3Q==
X-UI-Out-Filterresults: notjunk:1;V03:K0:G/+nrPI6jcc=:K/mLfXhJc31KhMjgACSmUf
 yPezyPL/7b7u6w5LSlGltvz6UozPQxuboZ/K6cPrzPI5fFA6P7FuStf05UA/uURA3mNTuZE+F
 WRqvEU/yCMGnIzf3NuqJEjnPe9UCIEGPk9Z24wRgU+oz0O18acjEFc5KobhkUA4h0SmKLmKeS
 yvsLBiPbftH1BvvGg4fiE4fYyK8lQR0oTJLfF6drx+79qehBslYlhc5Xlro/byHGw9Ea39QLg
 ip9v7vyAJxw3xWhIt8/HPZMvlTJ9kzd0tdPGVQ+0GCtj9WGACdoR4VNDBJ//0Rxo89FwcWFN/
 JFTYqiq5BKeHMlpj+99lE+Q5sS3xqV9DNZXDkZC7Yi2ITbBQt+YtihPhs5A9yKndLO/4Bn3pH
 HgoWU1nM8HpPmrgDjRlUngUbVdHLuA6oNznkO5bVppm3Yts34Ai6vNPp0uA5sb0VETUWgCCQd
 rzq0LzkxsaYtkKJKa36ajxaxGqlFCp4Qj7x+lEEUepeiR7dwtkmlNajWPmDanfNJMinujhw1y
 YSYL3apD2oUkxtLNnWMpKVbYnXiMVA1Q/xU1+f1CsC5CGsMEQognWfGyAeU1wSiz+BIqyc7/i
 LeSDqiN/N23UD35mnu2h+4ci1awwPmbKCyWC+HXb5d3j5tUj9wpuOZqYa5NP7rTPaFKhzmcyk
 rNQEduop8lz0OYWOybr2zvHHiDajsJg4SDP4qDFcpaVuKdXD0QMtjwZYEKjSZ/HcJqa7j2W7s
 aD07hMJgRUR/X7YKQqDOKIALzX+zu9kskvJVIEdq+ovi1Do9yPVsur8BwkwMW/RHxMuGjImkA
 iYTb6yA/nZUCm+6N037oo7c6oGTf9u9LTNXargMkQdIKhA7tis30pXIMBiod6wgguinkZCm5+
 PcG3utB8XI08CG9f/P0li+YPFIgHMq02cq6cqZgUUtdtv59BHGKzyQN7M4TVJUY/nexmTLu1D
 Vz5LwQL2RRrWIFFPB3NezuKYHXcOjZcLUTYCYtqjMGKV89bNw+/M6emRvNFE7DGdeZfo9gaor
 KNIowE6OiqraVG2/mmIfASVbgJGExuJPOM4ebfBHD2da6uoSMl+4WUZyv+ROL+uB+L9W539+Q
 bPc//0d8l07/ng=
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
Subject: Re: [dm-devel] [PATCH 11/17] btrfs: make
 dec_and_test_compressed_bio() to be split bio compatible
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
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com,
 linux-btrfs@vger.kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"



On 2022/3/17 03:46, Josef Bacik wrote:
> On Wed, Dec 01, 2021 at 01:17:50PM +0800, Qu Wenruo wrote:
>> For compression read write endio functions, they all rely on
>> dec_and_test_compressed_bio() to determine if they are the last bio.
>>
>> So here we only need to convert the bio_for_each_segment_all() call into
>> __bio_for_each_segment() so that compression read/write endio functions
>> will handle both split and unsplit bios well.
>>
>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>> ---
>>   fs/btrfs/compression.c | 14 +++++---------
>>   1 file changed, 5 insertions(+), 9 deletions(-)
>>
>> diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
>> index 8668c5190805..8b4b84b59b0c 100644
>> --- a/fs/btrfs/compression.c
>> +++ b/fs/btrfs/compression.c
>> @@ -205,18 +205,14 @@ static int check_compressed_csum(struct btrfs_inode *inode, struct bio *bio,
>>   static bool dec_and_test_compressed_bio(struct compressed_bio *cb, struct bio *bio)
>>   {
>>   	struct btrfs_fs_info *fs_info = btrfs_sb(cb->inode->i_sb);
>> +	struct bio_vec bvec;
>> +	struct bvec_iter iter;
>>   	unsigned int bi_size = 0;
>>   	bool last_io = false;
>> -	struct bio_vec *bvec;
>> -	struct bvec_iter_all iter_all;
>>
>> -	/*
>> -	 * At endio time, bi_iter.bi_size doesn't represent the real bio size.
>> -	 * Thus here we have to iterate through all segments to grab correct
>> -	 * bio size.
>> -	 */
>> -	bio_for_each_segment_all(bvec, bio, iter_all)
>> -		bi_size += bvec->bv_len;
>> +	ASSERT(btrfs_bio(bio)->iter.bi_size);
>
> We're tripping this assert with generic/476 with -o compress, so I assume
> there's some error condition that isn't being handled properly.  Thanks,

Thank you very much for catching it.

It turns out the ASSERT() is really helpful to detect uninitialized
btrfs_bio::iter.

The problem is related to two call sites:
- btrfs_submit_compressed_read()
- btrfs_submit_compressed_write()

The compressed bio doesn't have its iter properly initialized for error
path, thus it's causing the problem.

Just two new lines and the problem can be fixed.

I'll refresh the patchset.

Thank you again for catching this,
Qu

>
> Josef

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

