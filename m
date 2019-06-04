From: "zhangyi (F)" <yi.zhang@huawei.com>
Subject: Re: dm log writes: make sure the log super sectors are
 written in order
Date: Tue, 4 Jun 2019 12:20:53 +0800
Message-ID: <fae337b4-146e-743e-fe7d-6c796bfd560d@huawei.com>
References: <1559571534-16467-1-git-send-email-yi.zhang@huawei.com>
	<20190603144608.GA22116@redhat.com>
	<20190603190243.zqbfsgz22k3wghby@MacBook-Pro-91.local>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20190603190243.zqbfsgz22k3wghby@MacBook-Pro-91.local>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Josef Bacik <josef@toxicpanda.com>, Mike Snitzer <snitzer@redhat.com>
Cc: Josef Bacik <jbacik@fb.com>, dm-devel@redhat.com, agk@redhat.com, houtao1@huawei.com
List-Id: dm-devel.ids

On 2019/6/4 3:02, Josef Bacik Wrote:
> On Mon, Jun 03, 2019 at 10:46:08AM -0400, Mike Snitzer wrote:
>> On Mon, Jun 03 2019 at 10:18am -0400,
>> zhangyi (F) <yi.zhang@huawei.com> wrote:
>>
>>> Currently, although we submit super bios in log-write thread orderly
>>> (the super.nr_entries is incremented by each logged entry), the
>>> submit_bio() cannot make sure that each super sector is written to log
>>> device in order. So the submitting bio of each super sector may be
>>> out-of-order, and then the final nr_entries maybe small than the real
>>> entries submitted.
>>>
>>> This problem can be reproduced by the xfstests generic/455 with ext4,
>>> which may complained below after running the test:
>>>
>>>   QA output created by 455
>>>  -Silence is golden
>>>  +mark 'end' does not exist
>>>
>>> This patch serialize submitting super secotrs to make sure each super
>>> sectors are written to log disk in order.
>>>
>>> Signed-off-by: zhangyi (F) <yi.zhang@huawei.com>
>>
>> This doesn't feel right.
>>
>> You raised 2 things you're trying to address:
>> 1) IO is out of order
>> 2) accounting (nr_entries) isn't correct
>>
>> I'll need to reviewer closer but serializing "super" bios doesn't seem
>> like the best fix.
>>
>> Josef, any chance you can weigh in on this?  AFAIK you are still "the
>> man" for dm-log-writes ;)
>>
> 
> Well the #2 is caused by #1, we submit the bio for a super two times in a row
> and it's a crapshoot which one makes it to disk.  So he's right, and it's kind
> of funny because this is the sort of problem that dm-log-writes was written to
> catch, and I fucked it up here ;).  That being said this is a bit
> over-engineered, can we just add a completion to the log buff and do a
> wait_for_completion() when we're writing out the super?  It's not like this thing
> needs to be super performant.  Thanks,
> 

Hi, Josef

Thanks for your suggestions. It's fine by me to switch to use completion
instead. Some thing like this?

...
@@ -180,6 +182,15 @@ static void log_end_io(struct bio *bio)
        bio_put(bio);
 }

+static void log_end_super(struct bio *bio)
+{
+       struct log_writes_c *lc = bio->bi_private;
+
+       /* Wake up log-write kthread that super has been written */
+       complete(&lc->super_comp);
+       log_end_io(bio);
+}
+
 /*
  * Meant to be called if there is an error, it will free all the pages
  * associated with the block.
@@ -215,7 +226,8 @@ static int write_metadata(struct log_writes_c *lc, void *entry,
        bio->bi_iter.bi_size = 0;
        bio->bi_iter.bi_sector = sector;
        bio_set_dev(bio, lc->logdev->bdev);
-       bio->bi_end_io = log_end_io;
+       bio->bi_end_io = (sector == WRITE_LOG_SUPER_SECTOR) ?
+                         log_end_super : log_end_io;
        bio->bi_private = lc;
        bio_set_op_attrs(bio, REQ_OP_WRITE, 0);

@@ -418,11 +430,19 @@ static int log_super(struct log_writes_c *lc)
        super.nr_entries = cpu_to_le64(lc->logged_entries);
        super.sectorsize = cpu_to_le32(lc->sectorsize);

-       if (write_metadata(lc, &super, sizeof(super), NULL, 0, 0)) {
+       if (write_metadata(lc, &super, sizeof(super), NULL, 0,
+                          WRITE_LOG_SUPER_SECTOR)) {
                DMERR("Couldn't write super");
                return -1;
        }

+       /*
+        * Super sector should be writen in-order, or else the
+        * nr_entries could be rewritten by the old bio and small
+        * than the real submitted entries.
+        */
+       wait_for_completion_io(&lc->super_comp);
+
        return 0;
 }
...

But one thing need to mention is that, IIUC, If we use completion, the
log_writes_kthread have to wait on writing out every super bio, so it cannot
keep on submitting subsequent log bios. It maybe more performance impact
than my v1 (it only wait on previous super if it was not finished).

Thanks,
Yi.
