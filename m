From: Li Zefan <lizf@cn.fujitsu.com>
Subject: Re: [RFC PATCH dm-ioband] Added in blktrace msgs for dm-ioband
Date: Tue, 12 May 2009 16:10:15 +0800
Message-ID: <4A092EE7.4070403@cn.fujitsu.com>
References: <20090507.092322.71121515.ryov@valinux.co.jp>	<20090511.193115.189717098.ryov@valinux.co.jp>	<4A08F1B3.4060700@cn.fujitsu.com> <20090512.151104.71103166.ryov@valinux.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1758734AbZELIKK@vger.kernel.org>
In-Reply-To: <20090512.151104.71103166.ryov@valinux.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
To: Ryo Tsuruta <ryov@valinux.co.jp>
Cc: Alan.Brunelle@hp.com, dm-devel@redhat.com, linux-kernel@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>, Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>, Frederic Weisbecker <fweisbec@gmail.com>
List-Id: dm-devel.ids

CC more people on tracing issue

Ryo Tsuruta wrote:
> Hi Li,
> 
> From: Li Zefan <lizf@cn.fujitsu.com>
> Subject: Re: [RFC PATCH dm-ioband] Added in blktrace msgs for dm-ioband
> Date: Tue, 12 May 2009 11:49:07 +0800
> 
>> Ryo Tsuruta wrote:
>>> Hi Li,
>>>
>>> From: Ryo Tsuruta <ryov@valinux.co.jp>
>>> Subject: Re: [RFC PATCH dm-ioband] Added in blktrace msgs for dm-ioband
>>> Date: Thu, 07 May 2009 09:23:22 +0900 (JST)
>>>
>>>> Hi Li,
>>>>
>>>> From: Li Zefan <lizf@cn.fujitsu.com>
>>>> Subject: Re: [RFC PATCH dm-ioband] Added in blktrace msgs for dm-ioband
>>>> Date: Mon, 04 May 2009 11:24:27 +0800
>>>>
>>>>> Ryo Tsuruta wrote:
>>>>>> Hi Alan,
>>>>>>
>>>>>>> Hi Ryo -
>>>>>>>
>>>>>>> I don't know if you are taking in patches, but whilst trying to uncover
>>>>>>> some odd behavior I added some blktrace messages to dm-ioband-ctl.c. If
>>>>>>> you're keeping one code base for old stuff (2.6.18-ish RHEL stuff) and
>>>>>>> upstream you'll have to #if around these (the blktrace message stuff
>>>>>>> came in around 2.6.26 or 27 I think).
>>>>>>>
>>>>>>> My test case was to take a single 400GB storage device, put two 200GB
>>>>>>> partitions on it and then see what the "penalty" or overhead for adding
>>>>>>> dm-ioband on top. To do this I simply created an ext2 FS on each
>>>>>>> partition in parallel (two processes each doing a mkfs to one of the
>>>>>>> partitions). Then I put two dm-ioband devices on top of the two
>>>>>>> partitions (setting the weight to 100 in both cases - thus they should
>>>>>>> have equal access).
>>>>>>>
>>>>>>> Using default values I was seeing /very/ large differences - on the
>>>>>>> order of 3X. When I bumped the number of tokens to a large number
>>>>>>> (10,240) the timings got much closer (<2%). I have found that using
>>>>>>> weight-iosize performs worse than weight (closer to 5% penalty).
>>>>>> I could reproduce similar results. One dm-ioband device seems to stop
>>>>>> issuing I/Os for a few seconds at times. I'll investigate more on that.
>>>>>>  
>>>>>>> I'll try to formalize these results as I go forward and report out on
>>>>>>> them. In any event, I thought I'd share this patch with you if you are
>>>>>>> interested...
>>>>>> Thanks. I'll include your patche into the next release.
>>>>>>  
>>>>> IMO we should use TRACE_EVENT instead of adding new blk_add_trace_msg().
>>>> Thanks for your suggestion. I'll use TRACE_EVENT instead.
>>> blk_add_trace_msg() supports both blktrace and tracepoints. I can
>>> get messages from dm-ioband through debugfs. Could you expain why
>>> should we use TRACE_EVENT instead?
>>>
>> Actually blk_add_trace_msg() has nothing to do with tracepoints..
>>
>> If we use blk_add_trace_msg() is dm, we can use it in md, various block
>> drivers and even ext4. So the right thing is, if a subsystem wants to add
>> trace facility, it should use tracepoints/TRACE_EVENT.
>>
>> With TRACE_EVENT, you can get output through debugfs too, and it can be used
>> together with blktrace:
>>
>>  # echo 1 > /sys/block/dm/trace/enable
>>  # echo blk > /debugfs/tracing/current_tracer
>>  # echo dm-ioband-foo > /debugfs/tracing/tracing/set_event
>>  # cat /deubgfs/tracing/trace_pipe
>>  
>> And you can enable dm-ioband-foo while disabling dm-ioband-bar, and you can
>> use filter feature too.
> 
> Thanks for explaining.
> The base kernel of current dm tree (2.6.30-rc4) has not supported
> dm-device tracing yet. I'll consider using TRACE_EVENT when the base
> kernel supports dm-device tracing.
> 

I think we don't have any plan on dm-device tracing support, do we? And you
don't need that.

I downloaded dm-ioband 1.10.4, and applied it to latest tip-tree, and made
a patch to convert those blktrace msgs to trace events.

 # ls /debug/tracing/events/dm-ioband
 enable  ioband_endio     ioband_issue_list    ioband_urgent_bio
 filter  ioband_hold_bio  ioband_make_request
 # echo 1 /debug/tracing/events/dm-ioband/enable
 # echo blk /debug/tracing/current_tracer
 ...

Here is a sample output:

         pdflush-237   [001]  1706.377788: ioband_hold_bio: 8,9 ioband 1 hold_nrm 1
         pdflush-237   [001]  1706.377795: 254,0    Q   W 188832 + 8 [pdflush]
         pdflush-237   [001]  1706.377800: ioband_hold_bio: 8,9 ioband 1 hold_nrm 2
         pdflush-237   [001]  1706.377806: 254,0    Q   W 197032 + 8 [pdflush]
         pdflush-237   [001]  1706.377835: 254,0    C   W 82232 + 8 [0]
       kioband/1-2569  [001]  1706.377922: ioband_issue_list: 8,9 ioband 1 add_iss 1 1
       kioband/1-2569  [001]  1706.377923: ioband_issue_list: 8,9 ioband 1 add_iss 0 0
       kioband/1-2569  [001]  1706.377925: ioband_make_request: 8,9 ioband 1 pop_iss
       kioband/1-2569  [001]  1706.377940: ioband_make_request: 8,9 ioband 1 pop_iss
         konsole-2140  [001]  1706.377969: 254,0    C   W 90432 + 8 [0]
         konsole-2140  [001]  1706.378087: 254,0    C   W 98632 + 8 [0]
         konsole-2140  [001]  1706.378232: 254,0    C   W 106832 + 8 [0]
         konsole-2140  [001]  1706.378350: 254,0    C   W 115032 + 8 [0]
         konsole-2140  [001]  1706.378466: 254,0    C   W 123232 + 8 [0]
         konsole-2140  [001]  1706.378581: 254,0    C   W 131432 + 8 [0]

---
 drivers/md/dm-ioband-ctl.c       |   19 +++++-
 include/trace/events/dm-ioband.h |  134 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 150 insertions(+), 3 deletions(-)
 create mode 100644 include/trace/events/dm-ioband.h

diff --git a/drivers/md/dm-ioband-ctl.c b/drivers/md/dm-ioband-ctl.c
index 151b178..4033724 100644
--- a/drivers/md/dm-ioband-ctl.c
+++ b/drivers/md/dm-ioband-ctl.c
@@ -17,6 +17,9 @@
 #include "md.h"
 #include "dm-ioband.h"
 
+#define CREATE_TRACE_POINTS
+#include <trace/events/dm-ioband.h>
+
 #define POLICY_PARAM_START 6
 #define POLICY_PARAM_DELIM "=:,"
 
@@ -632,9 +635,11 @@ static void hold_bio(struct ioband_group *gp, struct bio *bio)
 		 */
 		dp->g_prepare_bio(gp, bio, IOBAND_URGENT);
 		bio_list_add(&dp->g_urgent_bios, bio);
+		trace_ioband_hold_bio(bio, dp, true);
 	} else {
 		gp->c_blocked++;
 		dp->g_hold_bio(gp, bio);
+		trace_ioband_hold_bio(bio, dp, false);
 	}
 }
 
@@ -675,14 +680,17 @@ static int make_issue_list(struct ioband_group *gp, struct bio *bio,
 		clear_group_blocked(gp);
 		wake_up_all(&gp->c_waitq);
 	}
-	if (should_pushback_bio(gp))
+	if (should_pushback_bio(gp)) {
 		bio_list_add(pushback_list, bio);
+		trace_ioband_issue_list(bio, dp, gp, true);
+	}
 	else {
 		int rw = bio_data_dir(bio);
 
 		gp->c_stat[rw].deferred++;
 		gp->c_stat[rw].sectors += bio_sectors(bio);
 		bio_list_add(issue_list, bio);
+		trace_ioband_issue_list(bio, dp, gp, false);
 	}
 	return prepare_to_issue(gp, bio);
 }
@@ -702,6 +710,7 @@ static void release_urgent_bios(struct ioband_device *dp,
 		dp->g_blocked--;
 		dp->g_issued[bio_data_dir(bio)]++;
 		bio_list_add(issue_list, bio);
+		trace_ioband_urgent_bio(bio, dp);
 	}
 }
 
@@ -915,10 +924,14 @@ static void ioband_conduct(struct work_struct *work)
 
 	spin_unlock_irqrestore(&dp->g_lock, flags);
 
-	while ((bio = bio_list_pop(&issue_list)))
+	while ((bio = bio_list_pop(&issue_list))) {
+		trace_ioband_make_request(bio, dp);
 		generic_make_request(bio);
-	while ((bio = bio_list_pop(&pushback_list)))
+	}
+	while ((bio = bio_list_pop(&pushback_list))) {
+		trace_ioband_endio(bio, dp);
 		bio_endio(bio, -EIO);
+	}
 }
 
 static int ioband_end_io(struct dm_target *ti, struct bio *bio,
diff --git a/include/trace/events/dm-ioband.h b/include/trace/events/dm-ioband.h
new file mode 100644
index 0000000..17dd61c
--- /dev/null
+++ b/include/trace/events/dm-ioband.h
@@ -0,0 +1,134 @@
+#if !defined(_TRACE_DM_IOBAND_H) || defined(TRACE_HEADER_MULTI_READ)
+#define _TRACE_DM_IOBAND_H
+
+#include <linux/tracepoint.h>
+#include <linux/interrupt.h>
+
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM dm-ioband
+
+TRACE_EVENT(ioband_hold_bio,
+
+	TP_PROTO(struct bio *bio, struct ioband_device *dp, bool urg),
+
+	TP_ARGS(bio, dp, urg),
+
+	TP_STRUCT__entry(
+		__field(	dev_t,		dev		)
+		__field(	bool,		urg		)
+		__field(	int,		g_blocked	)
+		__string(	g_name,		dp->g_name	)
+	),
+
+	TP_fast_assign(
+		__entry->dev		= bio->bi_bdev->bd_dev;
+		__entry->urg		= urg;
+		__entry->g_blocked	= dp->g_blocked;
+		__assign_str(g_name, dp->g_name);
+	),
+
+	TP_printk("%d,%d ioband %s hold_%s %d",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __get_str(g_name),
+		  __entry->urg ? "urg" : "nrm", __entry->g_blocked)
+);
+
+TRACE_EVENT(ioband_issue_list,
+
+	TP_PROTO(struct bio *bio, struct ioband_device *dp,
+		 struct ioband_group *gp, bool pushback),
+
+	TP_ARGS(bio, dp, gp, pushback),
+
+	TP_STRUCT__entry(
+		__field(	dev_t,		dev		)
+		__field(	bool,		pushback	)
+		__field(	int,		g_blocked	)
+		__field(	int,		c_blocked	)
+		__string(	g_name,		dp->g_name	)
+	),
+
+	TP_fast_assign(
+		__entry->dev		= bio->bi_bdev->bd_dev;
+		__entry->pushback	= pushback;
+		__entry->g_blocked	= dp->g_blocked;
+		__entry->c_blocked	= gp->c_blocked;
+		__assign_str(g_name, dp->g_name);
+	),
+
+	TP_printk("%d,%d ioband %s add_%s %d %d",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __get_str(g_name),
+		  __entry->pushback ? "pback" : "iss",
+		  __entry->g_blocked, __entry->c_blocked)
+);
+
+TRACE_EVENT(ioband_urgent_bio,
+
+	TP_PROTO(struct bio *bio, struct ioband_device *dp),
+
+	TP_ARGS(bio, dp),
+
+	TP_STRUCT__entry(
+		__field(	dev_t,		dev		)
+		__field(	int,		g_blocked	)
+		__string(	g_name,		dp->g_name	)
+	),
+
+	TP_fast_assign(
+		__entry->dev		= bio->bi_bdev->bd_dev;
+		__entry->g_blocked	= dp->g_blocked;
+		__assign_str(g_name, dp->g_name);
+	),
+
+	TP_printk("%d,%d ioband %s urg_add_iss %d",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __get_str(g_name), __entry->g_blocked)
+);
+
+TRACE_EVENT(ioband_make_request,
+
+	TP_PROTO(struct bio *bio, struct ioband_device *dp),
+
+	TP_ARGS(bio, dp),
+
+	TP_STRUCT__entry(
+		__field(	dev_t,		dev		)
+		__string(	g_name,		dp->g_name	)
+	),
+
+	TP_fast_assign(
+		__entry->dev		= bio->bi_bdev->bd_dev;
+		__assign_str(g_name, dp->g_name);
+	),
+
+	TP_printk("%d,%d ioband %s pop_iss",
+		  MAJOR(__entry->dev), MINOR(__entry->dev), __get_str(g_name))
+);
+
+TRACE_EVENT(ioband_endio,
+
+	TP_PROTO(struct bio *bio, struct ioband_device *dp),
+
+	TP_ARGS(bio, dp),
+
+	TP_STRUCT__entry(
+		__field(	dev_t,		dev		)
+		__string(	g_name,		dp->g_name	)
+	),
+
+	TP_fast_assign(
+		__entry->dev		= bio->bi_bdev->bd_dev;
+		__assign_str(g_name, dp->g_name);
+	),
+
+	TP_printk("%d,%d ioband %s pop_pback",
+		  MAJOR(__entry->dev), MINOR(__entry->dev), __get_str(g_name))
+);
+
+#endif /*  _TRACE_DM_IOBAND_H */
+
+/* This part must be outside protection */
+#include <trace/define_trace.h>
+
+
-- 
1.5.4.rc3
