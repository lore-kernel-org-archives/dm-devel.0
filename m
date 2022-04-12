Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6C2FAC433F5
	for <dm-devel@archiver.kernel.org>; Tue, 12 Apr 2022 22:38:47 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-369-ctF1-x-iPM-PQVHELrl0nw-1; Tue, 12 Apr 2022 18:38:43 -0400
X-MC-Unique: ctF1-x-iPM-PQVHELrl0nw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7A2D8802803;
	Tue, 12 Apr 2022 22:38:41 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 1DFB9404D8F4;
	Tue, 12 Apr 2022 22:38:41 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id D553A1949763;
	Tue, 12 Apr 2022 22:38:40 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id C04D81947BBE
 for <dm-devel@listman.corp.redhat.com>; Tue, 12 Apr 2022 22:38:39 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id ABC9C2167D63; Tue, 12 Apr 2022 22:38:39 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id A5B1F2166B1B
 for <dm-devel@redhat.com>; Tue, 12 Apr 2022 22:38:36 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8CF38101A52C
 for <dm-devel@redhat.com>; Tue, 12 Apr 2022 22:38:36 +0000 (UTC)
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-644-wQyYTXMaNzGqntnmemo7RQ-1; Tue, 12 Apr 2022 18:38:34 -0400
X-MC-Unique: wQyYTXMaNzGqntnmemo7RQ-1
X-IronPort-AV: E=Sophos;i="5.90,254,1643644800"; d="scan'208";a="196635188"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com)
 ([199.255.45.15])
 by ob1.hgst.iphmx.com with ESMTP; 13 Apr 2022 06:38:32 +0800
IronPort-SDR: IsJTTNBtWRZN/a9gGFWZ/0kYGX+QfJw4qVUUtNsnaVTr97M8PVCiYaJIzg9FOEl06jyy5L1Iw6
 t/P7sSWTLF5JreJPg3JKmSJAOqhRpRbW5P/UWCsfSH+f4u9VqPWIeOUW/zhIeF5xem7EHsnxR7
 inxoTwwSLPke4HjWTju+Pgp98DoMu5t9olXI00a3qIx11m4rbvZOeIA23IXlCU0Kj04ElY732U
 H9AZctPc/G96YFQw9VpdKnwILuntR5cX0DwIoLD4qMSwF05kwlj2uLCW/lEX+BotAJuqO4TTS8
 GxGf/osYyy13JN678pLuNWON
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
 by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256;
 12 Apr 2022 15:09:00 -0700
IronPort-SDR: JSLyzlkxvtqxoAXEEFcYJY03DprX1YLr8oXopJMAFxnqWoLbhH1rP1NStjFERWelcEerO9n5ui
 qwJePGc/qF71Mf+YoNMO+t0Mn8to4gd/0uuCYiUar4wO+WJEvBLNXqPBEkYoT9ixfsdJUsuBTK
 FtCmvC/eSkWYtCJ6Nn+zAdnRL/2vi+OEH8Zs4JGmXjmCekBlGUsxzIEHCfGYue59JjEkoxMvFQ
 2R9uVEXIfQZh9bmhblyF6///ioZb5WW5NSHYgAFcIgfD91y3mjMhxemKgQDqU9OjuPXlK0wsn+
 gqo=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
 by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256;
 12 Apr 2022 15:38:33 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
 by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4KdLGw4SmHz1SHwl
 for <dm-devel@redhat.com>; Tue, 12 Apr 2022 15:38:32 -0700 (PDT)
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
 by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new,
 port 10026) with ESMTP id JchVVfwlkusE for <dm-devel@redhat.com>;
 Tue, 12 Apr 2022 15:38:31 -0700 (PDT)
Received: from [10.225.163.9] (unknown [10.225.163.9])
 by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4KdLGv0chFz1Rvlx;
 Tue, 12 Apr 2022 15:38:30 -0700 (PDT)
Message-ID: <c4c83c0f-a4fc-2b37-180f-ccb272085fca@opensource.wdc.com>
Date: Wed, 13 Apr 2022 07:38:29 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
To: Mike Snitzer <snitzer@redhat.com>, Ming Lei <ming.lei@redhat.com>
References: <20220412085616.1409626-1-ming.lei@redhat.com>
 <20220412085616.1409626-6-ming.lei@redhat.com> <YlXmmB6IO7usz2c1@redhat.com>
From: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <YlXmmB6IO7usz2c1@redhat.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
Subject: Re: [dm-devel] [PATCH 5/8] dm: always setup ->orig_bio in alloc_io
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
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
 dm-devel@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 4/13/22 05:52, Mike Snitzer wrote:
> On Tue, Apr 12 2022 at  4:56P -0400,
> Ming Lei <ming.lei@redhat.com> wrote:
> 
>> The current DM codes setup ->orig_bio after __map_bio() returns,
>> and not only cause kernel panic for dm zone, but also a bit ugly
>> and tricky, especially the waiting until ->orig_bio is set in
>> dm_submit_bio_remap().
>>
>> The reason is that one new bio is cloned from original FS bio to
>> represent the mapped part, which just serves io accounting.
>>
>> Now we have switched to bdev based io accounting interface, and we
>> can retrieve sectors/bio_op from both the real original bio and the
>> added fields of .sector_offset & .sectors easily, so the new cloned
>> bio isn't necessary any more.
>>
>> Not only fixes dm-zone's kernel panic, but also cleans up dm io
>> accounting & split a bit.
> 
> You're conflating quite a few things here.  DM zone really has no
> business accessing io->orig_bio (dm-zone.c can just as easily inspect
> the tio->clone, because it hasn't been remapped yet it reflects the
> io->origin_bio, so there is no need to look at io->orig_bio) -- but
> yes I clearly broke things during the 5.18 merge and it needs fixing
> ASAP.

Problem is that we need to look at the BIO op in submission AND completion
path to handle zone append requests. So looking at the clone on submission
is OK since its op is still the original one. But on the completion path,
the clone may now be a regular write emulating a zone append op. And
looking at the clone only does not allow detecting that zone append.

We could have the orig_bio op saved in dm_io to avoid completely looking
at the orig_bio for detecting zone append.

> 
> But I'm (ab)using io->orig_bio assignment to indicate to completion
> that it may proceed.  See these dm-5.19 commits to see it imposed even
> further:
> https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=dm-5.19&id=311a8e6650601a79079000466db77386c5ec2abb
> https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=dm-5.19&id=56219ebb5f5c84785aa821f755d545eae41bdb1a
> 
> And then leveraged here:
> https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=dm-5.19&id=4aa7a368370c2a172d5a0b8927c6332c4b6a3514
> 
> Could be all these dm-5.19 changes suck.. but I do know dm-zone.c is
> too tightly coupled to DM core.  So I'll focus on that first, fix
> 5.18, and then circle back to "what's next?".
> 
> Mike
> 


-- 
Damien Le Moal
Western Digital Research

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

