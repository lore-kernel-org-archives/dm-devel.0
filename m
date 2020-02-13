From: Kirill Tkhai <ktkhai@virtuozzo.com>
Subject: Re: [PATCH v7 6/6] loop: Add support for REQ_ALLOCATE
Date: Thu, 13 Feb 2020 23:07:13 +0300
Message-ID: <6e3081f5-9462-c6e8-2ab9-524dc3d0304c@virtuozzo.com>
References: <158157930219.111879.12072477040351921368.stgit@localhost.localdomain>
 <158157957565.111879.5952051034259419400.stgit@localhost.localdomain>
 <20200213181141.GT6874@magnolia>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20200213181141.GT6874@magnolia>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: martin.petersen@oracle.com, bob.liu@oracle.com, axboe@kernel.dk, agk@redhat.com, snitzer@redhat.com, dm-devel@redhat.com, song@kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca, Chaitanya.Kulkarni@wdc.com, ming.lei@redhat.com, osandov@fb.com, jthumshirn@suse.de, minwoo.im.dev@gmail.com, damien.lemoal@wdc.com, andrea.parri@amarulasolutions.com, hare@suse.com, tj@kernel.org, ajay.joshi@wdc.com, sagi@grimberg.me, dsterba@suse.com, bvanassche@acm.org, dhowells@redhat.com, asml.silence@gmail.com, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

On 13.02.2020 21:11, Darrick J. Wong wrote:
> On Thu, Feb 13, 2020 at 10:39:35AM +0300, Kirill Tkhai wrote:
>> Support for new modifier of REQ_OP_WRITE_ZEROES command.
>> This results in allocation extents in backing file instead
>> of actual blocks zeroing.
>>
>> Signed-off-by: Kirill Tkhai <ktkhai@virtuozzo.com>
>> Reviewed-by: Bob Liu <bob.liu@oracle.com>
>> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
>> ---
>>  drivers/block/loop.c |   20 +++++++++++++-------
>>  1 file changed, 13 insertions(+), 7 deletions(-)
>>
>> diff --git a/drivers/block/loop.c b/drivers/block/loop.c
>> index 739b372a5112..0704167a5aaa 100644
>> --- a/drivers/block/loop.c
>> +++ b/drivers/block/loop.c
>> @@ -581,6 +581,16 @@ static int lo_rw_aio(struct loop_device *lo, struct loop_cmd *cmd,
>>  	return 0;
>>  }
>>  
> 
> Urgh, I meant "copy the comment directly to here", e.g.
> 
> /*
>  * Convert REQ_OP_WRITE_ZEROES modifiers into fallocate mode
>  *
>  * If the caller requires allocation, select that mode.  If the caller
>  * doesn't want deallocation, call zeroout to write zeroes the range.
>  * Otherwise, punch out the blocks.
>  */
> 
> The goal here is to reinforce the notion that FL_ZERO_RANGE is how we
> achieve nounmap zeroing...

The function is pretty small, and its meaning is easily seen from the name
and description.

I don't think we have to retell every function code line in a separate
sentence, since this distract the attention from really difficult places,
which are really need it.

Kirill
