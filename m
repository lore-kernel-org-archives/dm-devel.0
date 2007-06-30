From: Ross Vandegrift <ross@kallisti.us>
Subject: dump of ext3 very slow from dm LV
Date: Sat, 30 Jun 2007 16:28:21 -0400
Message-ID: <20070630202821.GA2770@kallisti.us>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1753947AbXF3Uwb@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Hello everyone,

A while back I asked about this on the LVM mailing list, but didn't
receive a response.  Am revisiting it now, so would like a broader
audience.

I've run into some substantial read slowness when using dump or tar
to backup filesystems that are stored on LVM2 LVs.  All of my tests
are dumping ext3 filesystems to /dev/null.

I'm seeing speeds in the range of 3-4MiB/s.  If I increase dump's
blocksize to 128KiB records, speed jumps up to about 20KiB/s, which
is better but still frustratingly slow. Going to 1024KiB gets me
about 28MiB/s.

Today I loop mounted a file on my LVM, filled it up with some crap
from urandom and dumped it out.  I was able to get 50-60MiB/s.  

Is this amount of performance loss due to dm expected? My LV is just two
SATA hard disks that I put into a VG. Stupid benchmarks with dd gives me
a raw read speed from the LV of about 60MiB/sec.

I'm using kernel 2.6.18-4-686 from debian.  Any ideas on what's
slowing down dump? 
-- 
Ross Vandegrift
ross@kallisti.us

"The good Christian should beware of mathematicians, and all those who
make empty prophecies. The danger already exists that the mathematicians
have made a covenant with the devil to darken the spirit and to confine
man in the bonds of Hell."
	--St. Augustine, De Genesi ad Litteram, Book II, xviii, 37
