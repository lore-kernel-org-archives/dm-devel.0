From: Douglas McClendon <dmc.fedora@filteredperception.org>
Subject: Re: recent bug in dmsetup status of mirror
Date: Mon, 27 Aug 2007 04:07:56 -0500
Message-ID: <46D2946C.1040801@filteredperception.org>
References: <46CCCD28.4090201@filteredperception.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <46CCCD28.4090201@filteredperception.org>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Douglas McClendon wrote:

> 
> Unfortunately, it appears that between the stock F7 kernel -
> 2.6.21-1.3194.fc7, and the updated F7 kernel 2.6.22.1-41.fc7, the
> dmsetup status results on a mirror have regressed.  The userspace tools
> are the same in both cases - device-mapper-1.02.17-7.fc7
> 
> With the 2.6.21 kernel, after creating a mirror, dmsetup status shows
> the mirroring progress, e.g. [1234/56789].  With the 2.6.22 kernel, it
> does not.  I don't have the exact output handy to cut and paste, if need
> be I can do that, or file a bug.

just noticed it is fixed as of 2.6.22.4-65.fc7

I'm still curious whether write-throttling a mirror is possible. 
Anybody have any ideas?  Can the dm thread be ionice-d?  Can the 
destination device be throttled at the block layer independent of dm? 
Can the table just be reloaded rapidly, increasing the device size 
incrementally?  It sure does seem to make the system unusable.  I.e. 
when running the following test, it took 10 seconds to open another tab 
in a gnome-terminal, and then 30+ seconds to launch gedit.  (core duo 
laptop with 1G ram, and reasonably modern sata drive).

#!/bin/bash
dd if=/dev/zero of=./test10ga bs=1k count=1 seek=$(( 1024 * 1024 * 10))
dd if=/dev/zero of=./test10gb bs=1k count=1 seek=$(( 1024 * 1024 * 10))
loa=$( losetup -f )
losetup ${loa} ./test10ga
lob=$( losetup -f )
losetup ${lob} ./test10gb
echo "0 $( blockdev --getsize ${loa} ) mirror core 2 32 sync 2 ${loa} 0 
${lob} 0" | dmsetup create testmir
echo "testmir created"
dmsetup status testmir


thanks,

-dmc
