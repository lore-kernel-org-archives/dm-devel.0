From: Douglas McClendon <dmc.fedora@filteredperception.org>
Subject: recent bug in dmsetup status of mirror
Date: Wed, 22 Aug 2007 18:56:24 -0500
Message-ID: <46CCCD28.4090201@filteredperception.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
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

Hello,

My name is Douglas McClendon, and this is my first post to this list.  I
cannot emphasize how insanely useful I find devicemapper.  Specifically,
in how snapshot is used for the Fedora LiveCDs, and how that enables the
ability to install/live-migrate the livecd filesystem to the host,
without rebooting.

Unfortunately, it appears that between the stock F7 kernel -
2.6.21-1.3194.fc7, and the updated F7 kernel 2.6.22.1-41.fc7, the
dmsetup status results on a mirror have regressed.  The userspace tools
are the same in both cases - device-mapper-1.02.17-7.fc7

With the 2.6.21 kernel, after creating a mirror, dmsetup status shows
the mirroring progress, e.g. [1234/56789].  With the 2.6.22 kernel, it
does not.  I don't have the exact output handy to cut and paste, if need
be I can do that, or file a bug.

I don't remember exactly, but I think it was buggy in that the dmsetup
status returned only information about 1 of the 2 devices, even after
the mirror process completed.  (the reason I know the process completed,
is because the target was a qemu sparse device, whose size I was
tracking with 'du -cms'.  And then upon completion, I reloaded the
table, which housed the system's rootfs with just the new device, and
things didn't fall over dead.  And then I wrote some files, rebooted,
and mounted the 2nd device, and the test files were there.  I.e.
everything was working correctly, just the dmsetup status output seemed
wrong).

Any ideas?

And while I'm here, I'll throw in another question-  Does anybody know
how to throttle the mirroring IO so that the process can take a longer
time, but leave the system more responsive during the process?  I know
that mdadm's raid1 supports write throttling.  I haven't yet figured out
a way to do that with dm.

Thanks,

-dmc
Douglas McClendon
