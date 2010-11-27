From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCHSET] block: clean up bdev claim/release handling
Date: Sat, 27 Nov 2010 19:47:39 +0100
Message-ID: <4CF1524B.8020207@kernel.dk>
References: <1288628129-12811-1-git-send-email-tj@kernel.org> <4CDC2488.1030801@kernel.org> <4CF12B4B.2050909@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <reiserfs-devel-owner@vger.kernel.org>
In-Reply-To: <4CF12B4B.2050909@kernel.org>
Sender: reiserfs-devel-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: hch@infradead.org, linux-kernel@vger.kernel.org, petero2@telia.com, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, jack@suse.cz, akpm@linux-foundation.org, adilger.kernel@dilger.ca, tytso@mit.edu, mfasheh@suse.com, joel.becker@oracle.com, aelder@sgi.com, dm-devel@redhat.com, drbd-dev@lists.linbit.com, neilb@suse.de, leochen@broadcom.com, sbranden@broadcom.com, chris.mason@oracle.com, swhiteho@redhat.com, shaggy@linux.vnet.ibm.com, joern@logfs.org, konishi.ryusuke@lab.ntt.co.jp, reiserfs-devel@vger.kernel.org, viro@zeniv.linux.org.uk
List-Id: dm-devel.ids

On 2010-11-27 17:01, Tejun Heo wrote:
> On 11/11/2010 06:14 PM, Tejun Heo wrote:
>> Hello,
>>
>> I just appended two patches to the series.  These two are the
>> blkdev_get_by_*() cleanup patches suggested in the fourth patch which
>> Christoph liked.
>>
>> I updated the git tree accordingly and added acked-by's.
>>
>>   git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git cleanup-bd_claim
>>
>> Jens, if you want the whole series resent, please let me know.
> 
> Ping.

You don't have to resend it, I'll pull it in.

-- 
Jens Axboe

