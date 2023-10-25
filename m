Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8669D14283
	for <dm-devel@lists.linux.dev>; Wed, 25 Oct 2023 05:59:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Nwg7EnAL"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1698213591;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=0STYB4Yoo5keZThXadV78HY3PlmY6HeiVDCnsZ5+p2k=;
	b=Nwg7EnALTo47WiLAS17FNIbVYkfRGR+8nWzVghqOIvZXbx3uMhddHiQpXRcEkI/kToCkYc
	IXpm9pNP2Ean9GcCl2jYem8UbF+LiSxJDWsn/1PtibTNzrTyx/gCpkq66/lxolNdwKayDD
	6V3nhk+KlI+leXc6xyXDA3z+MHYCtcE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-659-rQz8eEjrMH-k52gJUXjhUQ-1; Wed, 25 Oct 2023 01:59:49 -0400
X-MC-Unique: rQz8eEjrMH-k52gJUXjhUQ-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id ACE7580E868
	for <dm-devel@lists.linux.dev>; Wed, 25 Oct 2023 05:59:49 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id A4819492BD9
	for <dm-devel@lists.linux.dev>; Wed, 25 Oct 2023 05:59:49 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 3DEB4194658C
	for <dm-devel@lists.linux.dev>; Wed, 25 Oct 2023 05:59:49 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id D48761946586
 for <dm-devel@listman.corp.redhat.com>; Wed, 25 Oct 2023 05:59:47 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 8467B492BE2; Wed, 25 Oct 2023 05:59:47 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 7C4C9492BD9
 for <dm-devel@redhat.com>; Wed, 25 Oct 2023 05:59:47 +0000 (UTC)
Received: from us-smtp-inbound-delivery-1.mimecast.com (us-smtp-2.mimecast.com
 [205.139.110.61])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 549192824764
 for <dm-devel@redhat.com>; Wed, 25 Oct 2023 05:59:47 +0000 (UTC)
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-340--n5CzteCMPyC9yjQT78dTg-1; Wed,
 25 Oct 2023 01:59:43 -0400
X-MC-Unique: -n5CzteCMPyC9yjQT78dTg-1
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
 by sin.source.kernel.org (Postfix) with ESMTP id DCD2BCE2A78;
 Wed, 25 Oct 2023 05:53:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F856C433C7;
 Wed, 25 Oct 2023 05:53:18 +0000 (UTC)
Message-ID: <8410daaa-8f6e-46bd-ae4a-c9c362156b77@kernel.org>
Date: Wed, 25 Oct 2023 14:53:17 +0900
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] dm: error: Add support for zoned block devices
To: Naohiro Aota <Naohiro.Aota@wdc.com>
References: <20231023224513.344380-1-dlemoal@kernel.org>
 <fuyglwmrwyvrx6w3vwi2zlkpxqc5mafnf5cehill5vovnwfhmh@ddzacow35ki5>
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <fuyglwmrwyvrx6w3vwi2zlkpxqc5mafnf5cehill5vovnwfhmh@ddzacow35ki5>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.9
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
Cc: Johannes Thumshirn <Johannes.Thumshirn@wdc.com>,
 "dm-devel@redhat.com" <dm-devel@redhat.com>, Christoph Hellwig <hch@lst.de>,
 Mike Snitzer <snitzer@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.9
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/25/23 14:22, Naohiro Aota wrote:
> On Tue, Oct 24, 2023 at 07:45:13AM +0900, Damien Le Moal wrote:
>> dm-error is used in several test cases in the xfstests test suite to
>> check the handling of IO errors in file syatems. However, with several
>                                           ^ systems
> 
>> file systems getting native support for zoned block devices (e.g. btrfs
>> and f2fs), dm-error lack of zoned block device support creates problems
>> as the file system attempt executing zone commands (e.g. a zone append
>> operation) against a dm-error non-zoned block device, which causes
>> various issues in the block layer (e.g. WARN_ON triggers).
>>
>> This patch adds supports for zoned block devices to dm-error, allowing
>> an error table to be exposed as a zoned block device. This is done by
>> relying on the first argument passed to dmsetup when creating the device
>> table: if that first argument is a path to a backing block device, the
>> dm-error device is created by copying the limits of the backing device,
>> thus also copying its zone model. This is consistent with how xfstests
>> creates dm-error devices (always passing the path to the backing device
>> as the first argument).
>>
>> The zone support for dm-error requires the definition of the
>> report_zones target type method, which is done by introducing the
>> function io_err_report_zones(). Given that this function fails report
>> zones operations (similarly to any other command issued to the dm-error
>> device), dm_set_zones_restrictions() is tweaked to do nothing for a
>> wildcard target to avoid failing zone revalidation. As the dm-error
>> target does not implemt the iterate_devices method,
>                   ^implement

Thanks. Will fix that.

> 
>> dm_table_supports_zoned_model() is also changed to return true.
>>
>> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
>> ---
>>  drivers/md/dm-table.c  |  3 +++
>>  drivers/md/dm-target.c | 42 ++++++++++++++++++++++++++++++++++++++++--
>>  drivers/md/dm-zone.c   |  9 +++++++++
>>  3 files changed, 52 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
>> index 37b48f63ae6a..5e4d887063d3 100644
>> --- a/drivers/md/dm-table.c
>> +++ b/drivers/md/dm-table.c
>> @@ -1600,6 +1600,9 @@ static bool dm_table_supports_zoned_model(struct dm_table *t,
>>  	for (unsigned int i = 0; i < t->num_targets; i++) {
>>  		struct dm_target *ti = dm_table_get_target(t, i);
>>  
>> +		if (dm_target_is_wildcard(ti->type))
>> +			continue;
>> +
> 
> This seems tricky to me. Currently, dm-error is the only dm target having
> DM_TARGET_WILDCARD. But, can we expect that will be so forever?

Yes, I saw that. Not sure. Mike ?

> Also, I considered what happens if the backing device is non-zoned
> one. dm_table_supports_zoned_model() returns true in that case. But, it is
> still reported as non-zoned as we copy non-zoned queue limits. So, it is
> OK ... but it is a bit tricky.

Returning true for dm_table_supports_zoned_model() is not an issue. As the name
of the function says, this checks that the device table is OK with zoned device
but does not force the dm device to be zoned.

> Instead, how about implementing the .iterate_devices just like
> linear_iterate_devices?

Because that would change how dm-error needs to be setup. Currently, there are
no arguments needed for the table entry for dm-error. If we define the
->iterate_devices operation, we'll need a backing device and mapping start
sector. Changing the dmsetup command line for all users is probably not the best
approach... Unless I am missing something...

>> diff --git a/drivers/md/dm-target.c b/drivers/md/dm-target.c
>> index 27e2992ff249..1bf4ecda3012 100644
>> --- a/drivers/md/dm-target.c
>> +++ b/drivers/md/dm-target.c
>> @@ -118,6 +118,21 @@ EXPORT_SYMBOL(dm_unregister_target);
>>   */
>>  static int io_err_ctr(struct dm_target *tt, unsigned int argc, char **args)
>>  {
>> +	struct dm_dev *ddev;
>> +	int ret;
>> +
>> +	/*
>> +	 * If we have an argument, assume it is the path to the target
>> +	 * block device we are replacing. In this case, get the device
>> +	 * so that we can copy its limits in io_err_io_hints().
>> +	 */
>> +	if (argc) {
>> +		ret = dm_get_device(tt, args[0], dm_table_get_mode(tt->table),
>> +				    &ddev);
>> +		if (ret == 0)
>> +			tt->private = ddev;
> 
> No need to handle an error case here? Or, I guess it ignores an error for
> compatibility when non-device argument is specified. Then, I'd like to add
> a note here.

Yes, exactly. Before the change, arguments were ignored. I will add a comment.

-- 
Damien Le Moal
Western Digital Research

