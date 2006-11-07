From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH 2.6.19 5/5] fs: freeze_bdev with semaphore not mutex
Date: Tue, 07 Nov 2006 16:45:07 -0600
Message-ID: <45510C73.7060408@redhat.com>
References: <20061107183459.GG6993@agk.surrey.redhat.com> <20061107122837.54828e24.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1753816AbWKGWps@vger.kernel.org>
In-Reply-To: <20061107122837.54828e24.akpm@osdl.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: Alasdair G Kergon <agk@redhat.com>, linux-kernel@vger.kernel.org, dm-devel@redhat.com, Ingo Molnar <mingo@elte.hu>, Srinivasa DS <srinivasa@in.ibm.com>
List-Id: dm-devel.ids

Andrew Morton wrote:

>> --- linux-2.6.19-rc4.orig/fs/buffer.c	2006-11-07 17:06:20.000000000 +0000
>> +++ linux-2.6.19-rc4/fs/buffer.c	2006-11-07 17:26:04.000000000 +0000
>> @@ -188,7 +188,9 @@ struct super_block *freeze_bdev(struct b
>>  {
>>  	struct super_block *sb;
>>  
>> -	mutex_lock(&bdev->bd_mount_mutex);
>> +	if (down_trylock(&bdev->bd_mount_sem))
>> +		return -EBUSY;
>> +
> 
> This is a functional change which isn't described in the changelog.  What's
> happening here?

Only allow one bdev-freezer in at a time, rather than queueing them up?

-Eric
