From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: How to determine when a snapshot has finished
	merging?
Date: Tue, 26 Jan 2010 15:49:54 -0500
Message-ID: <20100126204954.GB17190@redhat.com>
References: <f03e393e1001240612l3cd3e5f7mc8d9ca1b11635954@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <f03e393e1001240612l3cd3e5f7mc8d9ca1b11635954@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Wicher Minnaard <wicher@gavagai.eu>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Sun, Jan 24 2010 at  9:12am -0500,
Wicher Minnaard <wicher@gavagai.eu> wrote:

> Hi, I'm new to the list.
> I'm experimenting with the snapshot-merge target on a 2.6.33_rc4 kernel:
> 
> echo 0 $(blockdev --getsize /dev/mapper/original) snapshot-merge
> /dev/mapper/original /dev/loop1 p 8 | dmsetup create mergeomatic
> 
> where /dev/loop1 is a COW volume I created earlier (with the
> 'snapshot' target, against /dev/mapper/original, of course).
> I wait for some time and then I just 'dmsetup remove' to break down
> the device stack, starting with the 'mergeomatic' device. I then take
> a look at /dev/mapper/original, and, much to my delight, I see stuff
> that has been merged back in from the snapshot.
> 
> But I don't know how to determine whether the merge has completed. I
> looked around in /proc and /sys, but those contained no obvious clues
> (not obvious to me, that is). My kernel logs never mention any dm
> activity (whereas the md driver is quite chatty and features
> /proc/mdstat).
> Any suggestions greatly appreciated.

Hi Wicher,

The status for the snapshot-merge (and snapshot) target was extended to
include the "allocated metadata sectors" at the end of its status
output, see commit: http://git.kernel.org/linus/985903bb3a6d98

And here is the corresponding lvm2 commit:
http://sources.redhat.com/git/?p=lvm2.git;a=commit;h=f02531802c002

The format is: <sectors_allocated>/<total_sectors> <metadata_sectors>

So merging has finished when <sectors_allocated> == <metadata_sectors>

Here is a practical example (using hybrid of lvm and dmsetup commands):

# lvs
  LV             VG   Attr   LSize Origin  Snap%  Move Log Copy%  Convert
  testlv1        test owi-a- 4.00g
  testlv1_snap   test swi-a- 1.00g testlv1  18.97

# dmsetup status test-testlv1_snap
0 8388608 snapshot 397896/2097152 1560
                                  ^^^^ metadata sectors

# lvconvert --merge -b test/testlv1_snap
  Merging of volume testlv1_snap started.

# lvs test/testlv1
  LV      VG   Attr   LSize Origin  Snap%  Move Log Copy%  Convert
  testlv1 test Owi-a- 4.00g          17.23

# dmsetup status test-testlv1
0 8388608 snapshot-merge 281688/2097152 1104

# dmsetup status test-testlv1
0 8388608 snapshot-merge 180480/2097152 712

# dmsetup status test-testlv1
0 8388608 snapshot-merge 16/2097152 16

Merge has completed

# lvs
  LV             VG   Attr   LSize Origin  Snap%  Move Log Copy%  Convert
  testlv1        test owi-a- 4.00g
