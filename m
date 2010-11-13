From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 1/5] mtd: fix bdev exclusive open bugs in block2mtd::add_device()
Date: Sat, 13 Nov 2010 11:42:58 +0100
Message-ID: <4CDE6BB2.5070806@kernel.org>
References: <1288628129-12811-1-git-send-email-tj@kernel.org>	 <1288628129-12811-2-git-send-email-tj@kernel.org> <1289644735.2218.8.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <reiserfs-devel-owner@vger.kernel.org>
In-Reply-To: <1289644735.2218.8.camel@localhost>
Sender: reiserfs-devel-owner@vger.kernel.org
To: dedekind1@gmail.com
Cc: axboe@kernel.dk, hch@infradead.org, linux-kernel@vger.kernel.org, petero2@telia.com, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, jack@suse.cz, akpm@linux-foundation.org, adilger.kernel@dilger.ca, tytso@mit.edu, mfasheh@suse.com, joel.becker@oracle.com, aelder@sgi.com, dm-devel@redhat.com, drbd-dev@lists.linbit.com, neilb@suse.de, leochen@broadcom.com, sbranden@broadcom.com, chris.mason@oracle.com, swhiteho@redhat.com, shaggy@linux.vnet.ibm.com, joern@logfs.org, konishi.ryusuke@lab.ntt.co.jp, reiserfs-devel@vger.kernel.org, viro@zeniv.linux.org.uk, linux-mtd@lists.infradead.org
List-Id: dm-devel.ids

Hello,

On 11/13/2010 11:38 AM, Artem Bityutskiy wrote:
> On Mon, 2010-11-01 at 17:15 +0100, Tejun Heo wrote:
>> +			if (!IS_ERR(bdev)) {
>> +				int ret;
>> +				ret = bd_claim(bdev, dev);
>> +				if (ret) {
>> +					blkdev_put(bdev,
>> +						   FMODE_READ | FMODE_WRITE);
> 
> Would be a bit cleaner to define ea temporary variable:
> 
> fmode_t mode = FMODE_READ | FMODE_WRITE;
> 
> Would you to re-send with this little change please?

Yeap, sure.

> And ideally, 2 independent patches would be nicer because you fix 2
> independent issues.

Hmmm... not really.  The patch is small enough and splitting it won't
really buy as any better bisectability.  Splitting patches into
logical changes is a good thing but it's no religious dogma.  Let's
apply it to the point it actually helps.

Thank you.

-- 
tejun
