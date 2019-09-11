From: "John Stoffel" <john@stoffel.org>
Subject: Re: [PATCH V2] dm-raid: fix updating
	of	max_discard_sectors limit
Date: Wed, 11 Sep 2019 14:59:28 -0400
Message-ID: <23929.17424.161332.501830@quad.stoffel.home>
References: <20190911113133.837-1-ming.lei@redhat.com>
	<20190911133523.GA32121@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20190911133523.GA32121@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>
Cc: dm-devel@redhat.com, stable@vger.kernel.org, Ming Lei <ming.lei@redhat.com>
List-Id: dm-devel.ids

>>>>> "Mike" == Mike Snitzer <snitzer@redhat.com> writes:

Mike> On Wed, Sep 11 2019 at  7:31am -0400,
Mike> Ming Lei <ming.lei@redhat.com> wrote:

>> Unit of 'chunk_size' is byte, instead of sector, so fix it.
>> 
>> Without this fix, too big max_discard_sectors is applied on the request queue
>> of dm-raid, finally raid code has to split the bio again.
>> 
>> This re-split done by raid causes the following nested clone_endio:
>> 
>> 1) one big bio 'A' is submitted to dm queue, and served as the original
>> bio
>> 
>> 2) one new bio 'B' is cloned from the original bio 'A', and .map()
>> is run on this bio of 'B', and B's original bio points to 'A'
>> 
>> 3) raid code sees that 'B' is too big, and split 'B' and re-submit
>> the remainded part of 'B' to dm-raid queue via generic_make_request().
>> 
>> 4) now dm will hanlde 'B' as new original bio, then allocate a new
>> clone bio of 'C' and run .map() on 'C'. Meantime C's original bio
>> points to 'B'.
>> 
>> 5) suppose now 'C' is completed by raid direclty, then the following
>> clone_endio() is called recursively:
>> 
>> clone_endio(C)
-> clone_endio(B)		#B is original bio of 'C'
-> bio_endio(A)
>> 
>> 'A' can be big enough to make handreds of nested clone_endio(), then
>> stack can be corrupted easily.
>> 
>> Cc: <stable@vger.kernel.org>
>> Signed-off-by: Ming Lei <ming.lei@redhat.com>
>> ---
>> V2:
>> - fix commit log a bit
>> 
>> drivers/md/dm-raid.c | 2 +-
>> 1 file changed, 1 insertion(+), 1 deletion(-)
>> 
>> diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
>> index 8a60a4a070ac..c26aa4e8207a 100644
>> --- a/drivers/md/dm-raid.c
>> +++ b/drivers/md/dm-raid.c
>> @@ -3749,7 +3749,7 @@ static void raid_io_hints(struct dm_target *ti, struct queue_limits *limits)
>> */
>> if (rs_is_raid1(rs) || rs_is_raid10(rs)) {
limits-> discard_granularity = chunk_size;
>> -		limits->max_discard_sectors = chunk_size;
>> +		limits->max_discard_sectors = chunk_size >> 9;
>> }
>> }
>> 
>> -- 
>> 2.20.1
>> 

Mike> Thanks a lot Ming!  But oof, really embarassing oversight on my part!

Mike> FYI, I added a "Fixes:" tag to the commit header and switched to
Mike> shifting by SECTOR_SHIFT instead of 9, staged commit for 5.4 is here:

Mike> https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=dm-5.4&id=509818079bf1fefff4ed02d6a1b994e20efc0480

Mike> --
Mike> dm-devel mailing list
Mike> dm-devel@redhat.com
Mike> https://www.redhat.com/mailman/listinfo/dm-devel



Would it make sense to re-name the variable to chunk_size_bytes as
well?  
