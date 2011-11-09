From: Mikulas Patocka <mpatocka@redhat.com>
Subject: i/o counting problems
Date: Tue, 8 Nov 2011 22:48:28 -0500 (EST)
Message-ID: <Pine.LNX.4.64.1111082226260.9155@hs20-bc2-1.build.redhat.com>
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
To: "Alasdair G. Kergon" <agk@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Hi

As we talked about those I/O counting ... the current situation is this:

There are functions submit_bio and generic_make_request --- they do the 
same thing (submit a bio), except that submit_bio counts the bio in global 
I/O counters and generic_make_request does not.

Currently, it is up to the creator of the bio to determine if the bio 
should be counted or not (by calling submit_bio or generic_make_request).

This is used inconsistently in the device mapper, sometimes the bio is 
submitted with submit_bio (for example raid1 write or snapshots 
copy-on-writes), sometimes withe generic_make_request. This results in 
some weird counting behaviour:

* when writing to raid1, vmstat reports three-times the actual throughput 
(it is counted once on entry to dm and once on each mirror leg).

* when submitting a lot of small bios pointing to random sectors to 
dm-crypt, dm-crypt resubmits them to the disks, but doesn't increase 
counters. This resubmitting can take several minutes (because of disk head 
seeks) and the machine appears deadlocked (there is nono I/O or CPU 
activity in vmstat, processes are hanging in 'D' state). In reality it is 
not deadlocked, it is sending data to the disks, but the data are not 
counted.

---

I think a correct solution to these problems would be to define that 
global I/O counters count only physical I/O to the disks and not I/O that 
is passed between midlayers. We should make both submit_bio and 
generic_make_requests increase the counters and make a per-queue flag 
meaning "this request queue belongs to a midlayer => don't count it". This 
flag would be set on all dm, md and loop devices.

Do you have any other ideas?

Mikulas
