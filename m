From: Dave Olien <dmo@osdl.org>
Subject: Multipath and IO statistics.
Date: Thu, 10 Mar 2005 15:00:49 -0800
Message-ID: <20050310230049.GA19544@osdl.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com, agk@redhat.com
List-Id: dm-devel.ids


Alasdair,

You mentioned this morning there might be some old code laying around
related to IO statistics and device mapper/multipath?  Could you
email me a pointer, if there is such?

Otherwise, I'll try to start by just throwing out some ideas and
going from there.

I'm guessing we'd like some way to collect statistics through
the /sys file system.  But we don't want the numbers to be reported
in the same way as for real disks, because we don't want to confuse
tools like iostat.  So we want some other sysfs file for these counters.

But then we have to worry about tools for reporting those statistics.

In addition, it would be nice to have the statistics implementation
be modular in some way, either as a library within the kernel dm code,
or as a "io statistics layer" that can be pushed onto the device mapper
stack.

Does this summarize where things stand right now?

Thanks!
Dave
