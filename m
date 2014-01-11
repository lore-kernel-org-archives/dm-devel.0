From: Akira Hayakawa <ruby.wktk@gmail.com>
Subject: dm-writeboost: Progress Report
Date: Sat, 11 Jan 2014 16:27:25 +0900
Message-ID: <52D0F25D.6030904@gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

Hi, DM Guys, 

This is the latest progress report of dm-writeboost.
I will send you the patch in the following post. Please merge it for 3.14.

To get broad interests to Writeboost I presented in two workshops in Japan.
Writeboost has now potential users waiting for it to merge in the main tree.
I heard some companies discuss about Writeboost in their R&D team.

Writeboost is now involving other third party developers now.

A Ph.D candidate in Seoul university has a great interest in the log-structured nature
and we discussed privately. He forked Writeboost and is working on his branch.
Writeboost has a potential to gain interest even from the academic researchers.

I also discussed with the developer of WalB (http://lkml.org/lkml/2013/6/3/115).
WalB also has the log-structured nature but the difference from Writeboost is that
it focuses on incremental backup. I don't know what will be the consequence of
our on-going discussion but there is a possibility that the functionality of WalB
will be merged into Writeboost. However, without this, Writeboost is worthy as a
pure caching module like dm-cache.

The code is improved much better.
Please merge my code for 3.14 after reviewing the patch.

The major code-level changes are described below

1. Improved the log replay algorithm to gain robustness
-------------------------------------------------------
The paper "Understanding the Robustness of SSDs under Power Fault (FAST13)"
made me re-think the log replay algorithm and I improved it.
Now, the algorithm is even robust for failure due to power fault
such as partial write of the log.
Each log now has the checksum of the log except the first 1 sector
and exploits it to check the validity of the log.
See struct segment_header_device changed.

2. Enabled flushing the logs execute in parallel
------------------------------------------------
Since we have multiple RAM buffers in Writeboost we can writes them to
the cache device in parallel to exploits the maximum parallelism in the
SSD.
Changing the log replay algorithm enabled this.
Now Writeboost uses workqueue instead of single kthread for the parallel
execution. The workqueue exhibits the sysfs to control the parallelism.
Thanks to Tejun (https://lkml.org/lkml/2013/3/1/629). Changing the
max_active parameter can change the number of executors.

3. Fully refactored (please read the code)
------------------------------------------
The code is much refactored and split into piece of small well-named
functions. I believe the code itself is production-ready. please check it.

4. Add some codes to Joe's device-mapper-test-suite
---------------------------------------------------
Joe maintains a testing framework in his Github repo.
I merged some test codes for Writeboost but I don't work on this project
recently. I will add more code later.

5. Add regression tests under testing/ of my Github tree
--------------------------------------------------------
Joe's test-suite is really well-designed but it has too many things before stand-by.
Instead, I prepare simple regression tests (written in shell) in Github repo.
https://github.com/akiradeveloper/dm-writeboost/tree/develop/testing
I want contributors to pass this tests before submitting their patch.

Thank you for reading,

Akira
