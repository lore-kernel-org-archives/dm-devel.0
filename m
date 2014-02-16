From: "Steinar H. Gunderson" <sgunderson@bigfoot.com>
Subject: Another metadata corruption issue in dm-cache
Date: Sun, 16 Feb 2014 17:51:14 +0100
Message-ID: <20140216165113.GA7518@sesse.net>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
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

Hi,

I recently upgraded to 3.13.2, and the number of dirty blocks suddenly
started to plummet (I guess somebody fixed writeback :-) ). However,
later I inserted two new disks into my RAID, reshaped it, and then
reloaded the cache device (directly on top of the md, below LVM) to
increase its size.

This worked fine; however, all blocks were now considered dirty, and
a new writeback started (I always get this issue whenever I do load/resume
on dm-cache). At the very end, however, the kernel log spit out:

  [233728.653343] device-mapper: space map common: index_check failed: blocknr 34359738543 != wanted 1726
  [233728.662920] device-mapper: block manager: index validator check failed for block 1726
  [233728.674456] device-mapper: space map common: unable to decrement a reference count below 0
  [233728.683282] device-mapper: cache: could not commit metadata for accurate status

nd then the reference count and commit messages several times, and all
my filesystems started getting into problems.

Rebooting didn't help; it complained about the same index_check issue,
refusing to set up the device.

I didn't take a snapshot of the metadata device (it's not so easy to rescue
things out from the initramfs); I zeroed it, since all the filesystems
appeared to be in reasonably good shape anyway (not so strange with
everything written back), and some fsck rounds later, everything was back
into shape.

So, seemingly there are still issues...

/* Steinar */
-- 
Homepage: http://www.sesse.net/
