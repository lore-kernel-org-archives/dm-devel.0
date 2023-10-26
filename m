Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18C8A11C9E
	for <dm-devel@lists.linux.dev>; Thu, 26 Oct 2023 21:34:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="c7cwSa1Y"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1698356053;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=4XTXNRGs6EFGxu4uzbSZ7r9fKh4mK0LSSScI1Qs6AQY=;
	b=c7cwSa1YyaQUSxr+u6ut8AuZRRALglcgwTd1lwInt6KEfBgrhW/uTkI7PI11vn+oSrDc5Y
	ixk++LVP1AC1YD3C97JTlgJL35aG0HdGIUa+9816jt/89p3W++WLhD8FWY/sDWhjiGpeR3
	/7RHIPcA9prEXkdacAXoIZiPps6O6NY=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-475-grP8oQBsPbmsn9cMPDmV9Q-1; Thu,
 26 Oct 2023 17:34:02 -0400
X-MC-Unique: grP8oQBsPbmsn9cMPDmV9Q-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 11B9B2823803
	for <dm-devel@lists.linux.dev>; Thu, 26 Oct 2023 21:34:02 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 097DC1121319
	for <dm-devel@lists.linux.dev>; Thu, 26 Oct 2023 21:34:02 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id CC4F51946595
	for <dm-devel@lists.linux.dev>; Thu, 26 Oct 2023 21:34:01 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id A0A0A194658C
 for <dm-devel@listman.corp.redhat.com>; Thu, 26 Oct 2023 21:34:00 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 473A4492BE9; Thu, 26 Oct 2023 21:34:00 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 11D7C492BE7
 for <dm-devel@redhat.com>; Thu, 26 Oct 2023 21:33:59 +0000 (UTC)
Received: from us-smtp-inbound-delivery-1.mimecast.com
 (us-smtp-delivery-1.mimecast.com [205.139.110.120])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D68B32823800
 for <dm-devel@redhat.com>; Thu, 26 Oct 2023 21:33:59 +0000 (UTC)
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182]) by
 relay.mimecast.com with ESMTP id us-mta-280-tfkE0J_HO4uEKel3OdrXpQ-1; Thu,
 26 Oct 2023 17:33:47 -0400
X-MC-Unique: tfkE0J_HO4uEKel3OdrXpQ-1
Received: from [10.137.106.151] (unknown [131.107.159.23])
 by linux.microsoft.com (Postfix) with ESMTPSA id 81AF920B74C0;
 Thu, 26 Oct 2023 14:33:46 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 81AF920B74C0
Message-ID: <616a6fd7-47b1-4b46-af23-46f9b1a3eedf@linux.microsoft.com>
Date: Thu, 26 Oct 2023 14:33:46 -0700
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v11 5/19] ipe: introduce 'boot_verified' as a trust
 provider
To: Paul Moore <paul@paul-moore.com>, corbet@lwn.net, zohar@linux.ibm.com,
 jmorris@namei.org, serge@hallyn.com, tytso@mit.edu, ebiggers@kernel.org,
 axboe@kernel.dk, agk@redhat.com, snitzer@kernel.org, eparis@redhat.com
References: <1696457386-3010-6-git-send-email-wufan@linux.microsoft.com>
 <c53599e9d278fc55be30e3bac9411328.paul@paul-moore.com>
From: Fan Wu <wufan@linux.microsoft.com>
In-Reply-To: <c53599e9d278fc55be30e3bac9411328.paul@paul-moore.com>
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
Cc: dm-devel@redhat.com, linux-doc@vger.kernel.org,
 Deven Bowers <deven.desai@linux.microsoft.com>, roberto.sassu@huawei.com,
 linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-block@vger.kernel.org, audit@vger.kernel.org,
 linux-fscrypt@vger.kernel.org, linux-integrity@vger.kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.3
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: linux.microsoft.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 10/23/2023 8:52 PM, Paul Moore wrote:
> On Oct  4, 2023 Fan Wu <wufan@linux.microsoft.com> wrote:
>>
>> IPE is designed to provide system level trust guarantees, this usually
>> implies that trust starts from bootup with a hardware root of trust,
>> which validates the bootloader. After this, the bootloader verifies the
>> kernel and the initramfs.
>>
>> As there's no currently supported integrity method for initramfs, and
>> it's typically already verified by the bootloader, introduce a property
>> that causes the first superblock to have an execution to be "pinned",
>> which is typically initramfs.
>>
>> When the "pinned" device is unmounted, it will be "unpinned" and
>> `boot_verified` property will always evaluate to false afterward.
>>
>> We use a pointer with a spin_lock to "pin" the device instead of rcu
>> because rcu synchronization may sleep, which is not allowed when
>> unmounting a device.
>>
>> Signed-off-by: Deven Bowers <deven.desai@linux.microsoft.com>
>> Signed-off-by: Fan Wu <wufan@linux.microsoft.com>
...
>> ---
>>   security/ipe/eval.c          | 72 +++++++++++++++++++++++++++++++++++-
>>   security/ipe/eval.h          |  2 +
>>   security/ipe/hooks.c         | 12 ++++++
>>   security/ipe/hooks.h         |  2 +
>>   security/ipe/ipe.c           |  1 +
>>   security/ipe/policy.h        |  2 +
>>   security/ipe/policy_parser.c | 35 +++++++++++++++++-
>>   7 files changed, 124 insertions(+), 2 deletions(-)
>>
>> diff --git a/security/ipe/eval.c b/security/ipe/eval.c
>> index 8a8bcc5c7d7f..bdac4abc0ddb 100644
>> --- a/security/ipe/eval.c
>> +++ b/security/ipe/eval.c
>> @@ -9,6 +9,7 @@
>>   #include <linux/file.h>
>>   #include <linux/sched.h>
>>   #include <linux/rcupdate.h>
>> +#include <linux/spinlock.h>
>>   
>>   #include "ipe.h"
>>   #include "eval.h"
>> @@ -16,6 +17,44 @@
>>   
>>   struct ipe_policy __rcu *ipe_active_policy;
>>   
>> +static const struct super_block *pinned_sb;
>> +static DEFINE_SPINLOCK(pin_lock);
>> +#define FILE_SUPERBLOCK(f) ((f)->f_path.mnt->mnt_sb)
>> +
>> +/**
>> + * pin_sb - Pin the underlying superblock of @f, marking it as trusted.
>> + * @sb: Supplies a super_block structure to be pinned.
>> + */
>> +static void pin_sb(const struct super_block *sb)
>> +{
>> +	if (!sb)
>> +		return;
>> +	spin_lock(&pin_lock);
>> +	if (!pinned_sb)
>> +		pinned_sb = sb;
>> +	spin_unlock(&pin_lock);
>> +}
>> +
>> +/**
>> + * from_pinned - Determine whether @sb is the pinned super_block.
>> + * @sb: Supplies a super_block to check against the pinned super_block.
>> + *
>> + * Return:
>> + * * true	- @sb is the pinned super_block
>> + * * false	- @sb is not the pinned super_block
>> + */
>> +static bool from_pinned(const struct super_block *sb)
>> +{
>> +	bool rv;
>> +
>> +	if (!sb)
>> +		return false;
>> +	spin_lock(&pin_lock);
>> +	rv = !IS_ERR_OR_NULL(pinned_sb) && pinned_sb == sb;
>> +	spin_unlock(&pin_lock);
> 
> It's okay for an initial version, but I still think you need to get
> away from this spinlock in from_pinned() as quickly as possible.
> Maybe I'm wrong, but this looks like a major source of lock contention.
> 
> I understand the issue around RCU and the potential for matching on
> a reused buffer/address, but if you modified IPE to have its own LSM
> security blob in super_block::security you could mark the superblock
> when it was mounted and do a lockless lookup here in from_pinned().
> 
Thank you for the suggestion. After some testing, I discovered that 
switching to RCU to pin the super block and using a security blob to 
mark a pinned super block works. This approach do avoid many spinlock 
operations. I'll incorporate these changes in the next version of the patch.

-Fan
>> +	return rv;
>> +}
> 
> --
> paul-moore.com

