From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Subject: [Regression/Behavior change]dm-flakey corrupt read bio, even the
 feature is drop_writes
Date: Mon, 22 Aug 2016 15:31:58 +0800
Message-ID: <cc2b06b5-7598-67ab-d528-9087cbf75f45@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-btrfs-owner@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
To: snitzer@redhat.com
Cc: btrfs <linux-btrfs@vger.kernel.org>, dm-devel@redhat.com
List-Id: dm-devel.ids

Hi, Mike and btrfs and dm guys

When doing regression test on v4.8-rc1, we found that fstests/btrfs/056 
always fails. With the following dmesg:
---
Buffer I/O error on dev dm-0, logical block 1310704, async page read
Buffer I/O error on dev dm-0, logical block 16, async page read
Buffer I/O error on dev dm-0, logical block 16, async page read
---

And bisect leads to the following commits:
---
commit 99f3c90d0d85708e7401a81ce3314e50bf7f2819
Author: Mike Snitzer <snitzer@redhat.com>
Date:   Fri Jul 29 13:19:55 2016 -0400

     dm flakey: error READ bios during the down_interval
---

While according to the document of dm-flakey, it says that when using 
drop_writes feature, read bios are not affected:
---
   drop_writes:
	All write I/O is silently ignored.
	Read I/O is handled correctly.
---

If I understand the word "correctly" correctly, it should means READ I/0 
is handled without problem.

However with this commit, it also corrupt the read bio, leading to the 
test failure.


At least there are two fixes available here;
1) Fix fstest scripts
    The related macro is "_flakey_drop_and_remount yes", which will
    check the fs during the "drop_writes" time.

    Currently, only btrfs/056 calls "_flakey_drop_and_remount" with
    "yes". So other test cases are not affected.

    However, even we move the fsck outside of the "drop_writes" range,
    although test case can pass without problem, but we will still
    get a dmesg error:
    "Buffer I/O error on dev dm-0, logical block 1310704, async page read"

2) Revert to flakey behavior to allow READ bio
    Then everything is back to the old good days.

Not sure which one is correct for current use case, as I'm not familiar 
with dm codes.

Any idea to fix dm-flaky and keep the READ bio behavior?

Thanks,
Qu





