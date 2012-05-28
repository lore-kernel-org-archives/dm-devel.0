From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH v3 03/16] block: Add bio_reset()
Date: Mon, 28 May 2012 13:02:45 +0300
Message-ID: <4FC34D45.7040806@panasas.com>
References: <1337977539-16977-1-git-send-email-koverstreet@google.com> <1337977539-16977-4-git-send-email-koverstreet@google.com> <20120528012307.GC9891@dhcp-172-17-108-109.mtv.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20120528012307.GC9891@dhcp-172-17-108-109.mtv.corp.google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: Kent Overstreet <koverstreet@google.com>, linux-kernel@vger.kernel.org, linux-bcache@vger.kernel.org, dm-devel@redhat.com, linux-fsdevel@vger.kernel.org, axboe@kernel.dk, agk@redhat.com, neilb@suse.de, drbd-dev@lists.linbit.com, vgoyal@redhat.com, mpatocka@redhat.com, sage@newdream.net, yehuda@hq.newdream.net
List-Id: dm-devel.ids

On 05/28/2012 04:23 AM, Tejun Heo wrote:

> On Fri, May 25, 2012 at 01:25:26PM -0700, Kent Overstreet wrote:
>> Reusing bios is something that's been highly frowned upon in the past,
>> but driver code keeps doing it anyways. If it's going to happen anyways,
>> we should provide a generic method.
>>
>> This'll help with getting rid of bi_destructor - drivers/block/pktcdvd.c
>> was open coding it, by doing a bio_init() and resetting bi_destructor.
>>
>> Signed-off-by: Kent Overstreet <koverstreet@google.com>
>> Change-Id: Ib0a43dfcb3f6c22a54da513d4a86be544b5ffd95
>> ---
>>  fs/bio.c                  |    8 ++++++++
>>  include/linux/bio.h       |    1 +
>>  include/linux/blk_types.h |    6 ++++++
>>  3 files changed, 15 insertions(+)
>>
>> diff --git a/fs/bio.c b/fs/bio.c
>> index 3667cef..240da21 100644
>> --- a/fs/bio.c
>> +++ b/fs/bio.c
>> @@ -259,6 +259,14 @@ void bio_init(struct bio *bio)
>>  }
>>  EXPORT_SYMBOL(bio_init);
>>  
> 
> Function comment please.


And please make this inline in header. We should not 
EXPORT_SYMBOL a memset. (Even the memset gets inlined by
compiler.

Boaz

> 
>> +void bio_reset(struct bio *bio)
>> +{
>> +	memset(bio, 0, BIO_RESET_BYTES);
>> +	bio->bi_flags = 1 << BIO_UPTODATE;
>> +
>> +}
>> +EXPORT_SYMBOL(bio_reset);
> 
