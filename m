From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Shared snapshots
Date: Wed, 6 Jan 2010 09:38:00 -0500 (EST)
Message-ID: <Pine.LNX.4.64.1001060927120.28095@hs20-bc2-1.build.redhat.com>
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
To: Alasdair G Kergon <agk@redhat.com>
Cc: Mike Snitzer <msnitzer@redhat.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

Hi

I uploaded new code for shared snapshots at
http://people.redhat.com/mpatocka/patches/kernel/new-snapshots/devel/

Changes:
- two queues, one for reads and one for writes, to improve read latency 
when the device is write-congested
- limit number of reallocations in flight (VM subsystem sends all writes 
at once and without limit it creates big lags).
- fixed one place where it didn't handle on-disk errors
- simplified bitmap creation, removed some unneeded code
- new macro for error reporting, as suggested by Zdenek
- some comments added
- DM_ prefix added to some macros

Userspace for lvm 2.02.53 is at
http://people.redhat.com/mpatocka/patches/userspace/new-snapshots/lvm-2.02.54/

Please, someone, do offensive testing with this --- i.e. apply the 
patches, try it, and try all possible lvm commands with it, try to stress 
and crash it in various ways, etc. If we wait with testing until Alasdair 
reads the code, it won't get much testing...

Mikulas
