From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [git pull] device mapper changes for 4.21
Date: Mon, 31 Dec 2018 13:10:54 -0700
Message-ID: <c761fb03-5bfe-9096-894a-36820983b7fd@kernel.dk>
References: <20181227160944.GA12190@redhat.com>
	<20181230090646.GB1022@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20181230090646.GB1022@infradead.org>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christoph Hellwig <hch@infradead.org>, Mike Snitzer <snitzer@redhat.com>
Cc: Sweet Tea <sweettea@redhat.com>, wuzhouhui <wuzhouhui14@mails.ucas.ac.cn>, AliOS system security <alios_sys_security@linux.alibaba.com>, Nikos Tsironis <ntsironis@arrikto.com>, Eric Biggers <ebiggers@google.com>, Heinz Mauelshagen <heinzm@redhat.com>, Shenghui Wang <shhuiw@foxmail.com>, linux-block@vger.kernel.org, dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>, Jaegeuk Kim <jaegeuk@kernel.org>, Colin Ian King <colin.king@canonical.com>, Linus Torvalds <torvalds@linux-foundation.org>, Milan Broz <gmazyland@gmail.com>, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On 12/30/18 2:06 AM, Christoph Hellwig wrote:
> On Thu, Dec 27, 2018 at 11:09:44AM -0500, Mike Snitzer wrote:
>> - Fix various DM targets to check for device sector overflow if
>>   CONFIG_LBDAF is not set.
> 
> Question to Jens and Linus:
> 
> is there any good reason to keep the CONFIG_LBDAF=n option around?
> Less than 2gig block devices seem to be an absolutele niche, and I
> wonder if it is still worth maintaining the special case just for that.

I'd be fine with removing it, I seriously doubt that the extended
math is going to be noticeable at all.

I'll try and run some null_blk testing as micro benchmarks when
I'm back in a few days.

-- 
Jens Axboe
