From: Wicher Minnaard <wicher@gavagai.eu>
Subject: How to determine when a snapshot has finished merging?
Date: Sun, 24 Jan 2010 15:12:25 +0100
Message-ID: <f03e393e1001240612l3cd3e5f7mc8d9ca1b11635954@mail.gmail.com>
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

Hi, I'm new to the list.
I'm experimenting with the snapshot-merge target on a 2.6.33_rc4 kernel:

echo 0 $(blockdev --getsize /dev/mapper/original) snapshot-merge
/dev/mapper/original /dev/loop1 p 8 | dmsetup create mergeomatic

where /dev/loop1 is a COW volume I created earlier (with the
'snapshot' target, against /dev/mapper/original, of course).
I wait for some time and then I just 'dmsetup remove' to break down
the device stack, starting with the 'mergeomatic' device. I then take
a look at /dev/mapper/original, and, much to my delight, I see stuff
that has been merged back in from the snapshot.

But I don't know how to determine whether the merge has completed. I
looked around in /proc and /sys, but those contained no obvious clues
(not obvious to me, that is). My kernel logs never mention any dm
activity (whereas the md driver is quite chatty and features
/proc/mdstat).
Any suggestions greatly appreciated.

Regards, Wicher
