From: Peter Osterlund <petero2@telia.com>
Subject: Re: 2.6.24.2: 4KSTACKS + pcdrw + dm + mount -> stack overflow: ide-cd related? dm-related?
Date: Sun, 24 Feb 2008 17:56:09 +0100
Message-ID: <m363wepa3a.fsf@telia.com>
References: <87wsovkth5.fsf@hades.wkstn.nix> <87skzipcpw.fsf@hades.wkstn.nix>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1759840AbYBXSHA@vger.kernel.org>
In-Reply-To: <87skzipcpw.fsf@hades.wkstn.nix> (nix@esperi.org.uk's message of "Sun\, 24 Feb 2008 15\:59\:23 +0000")
Sender: linux-kernel-owner@vger.kernel.org
To: Nix <nix@esperi.org.uk>
Cc: linux-kernel@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids

Nix <nix@esperi.org.uk> writes:

> On 24 Feb 2008, nix@esperi.org.uk outgrape:
>
>> A loop mount/umounting a pcdrw or iso9660 (through the pktcdvd device)
>> sees a stack overflow in four or five tries. Doing the same thing with
>> the same CD in a normal non-pktcdvd-mounted drive doesn't cause a crash.
>
>> (This may or may not be PREEMPT+PREEMPT_BKL-specific: I'll try turning
>> them off tomorrow and repeating.)
>
> It is not preempt-specific, nor dm-specific. Nor it is very easy to
> capture tracebacks of: even netconsole generally gives up when faced
> with a string of recursive tracebacks blurring past forever at blinding
> speed.
>
> But while I'd normally blame pktcdvd there's only one pktcdvd function
> in these tracebacks (pkt_open) and it's not got a significant stack
> footprint.

Did you verify that with "make checkstack" or just by looking at the
source code? On my system, pkt_open() consumes 584 bytes because the
compiler decides to inline lots of functions that would not normally
be part of long call chains. The following patch fixes that problem on
my system.

> More notable is a great stack of mutual recursion between
> dm_bio_destructor() and the CDROM code: it seems to burn most of the
> stack on this sort of thrashing. Here's one of those tracebacks again:

Maybe dm_bio_destructor() is just old cruft left on the stack from
previous function calls?


From: Peter Osterlund <petero2@telia.com>

Signed-off-by: Peter Osterlund <petero2@telia.com>
---

 drivers/block/pktcdvd.c |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/block/pktcdvd.c b/drivers/block/pktcdvd.c
index 674cd66..f2510e7 100644
--- a/drivers/block/pktcdvd.c
+++ b/drivers/block/pktcdvd.c
@@ -849,7 +849,7 @@ static int pkt_flush_cache(struct pktcdvd_device *pd)
 /*
  * speed is given as the normal factor, e.g. 4 for 4x
  */
-static int pkt_set_speed(struct pktcdvd_device *pd, unsigned write_speed, unsigned read_speed)
+static noinline int pkt_set_speed(struct pktcdvd_device *pd, unsigned write_speed, unsigned read_speed)
 {
 	struct packet_command cgc;
 	struct request_sense sense;
@@ -1776,7 +1776,7 @@ static int pkt_get_track_info(struct pktcdvd_device *pd, __u16 track, __u8 type,
 	return pkt_generic_packet(pd, &cgc);
 }
 
-static int pkt_get_last_written(struct pktcdvd_device *pd, long *last_written)
+static noinline int pkt_get_last_written(struct pktcdvd_device *pd, long *last_written)
 {
 	disc_information di;
 	track_information ti;
@@ -1813,7 +1813,7 @@ static int pkt_get_last_written(struct pktcdvd_device *pd, long *last_written)
 /*
  * write mode select package based on pd->settings
  */
-static int pkt_set_write_settings(struct pktcdvd_device *pd)
+static noinline int pkt_set_write_settings(struct pktcdvd_device *pd)
 {
 	struct packet_command cgc;
 	struct request_sense sense;
@@ -1972,7 +1972,7 @@ static int pkt_writable_disc(struct pktcdvd_device *pd, disc_information *di)
 	return 1;
 }
 
-static int pkt_probe_settings(struct pktcdvd_device *pd)
+static noinline int pkt_probe_settings(struct pktcdvd_device *pd)
 {
 	struct packet_command cgc;
 	unsigned char buf[12];
@@ -2071,7 +2071,7 @@ static int pkt_probe_settings(struct pktcdvd_device *pd)
 /*
  * enable/disable write caching on drive
  */
-static int pkt_write_caching(struct pktcdvd_device *pd, int set)
+static noinline int pkt_write_caching(struct pktcdvd_device *pd, int set)
 {
 	struct packet_command cgc;
 	struct request_sense sense;
@@ -2116,7 +2116,7 @@ static int pkt_lock_door(struct pktcdvd_device *pd, int lockflag)
 /*
  * Returns drive maximum write speed
  */
-static int pkt_get_max_speed(struct pktcdvd_device *pd, unsigned *write_speed)
+static noinline int pkt_get_max_speed(struct pktcdvd_device *pd, unsigned *write_speed)
 {
 	struct packet_command cgc;
 	struct request_sense sense;
@@ -2177,7 +2177,7 @@ static char us_clv_to_speed[16] = {
 /*
  * reads the maximum media speed from ATIP
  */
-static int pkt_media_speed(struct pktcdvd_device *pd, unsigned *speed)
+static noinline int pkt_media_speed(struct pktcdvd_device *pd, unsigned *speed)
 {
 	struct packet_command cgc;
 	struct request_sense sense;
@@ -2249,7 +2249,7 @@ static int pkt_media_speed(struct pktcdvd_device *pd, unsigned *speed)
 	}
 }
 
-static int pkt_perform_opc(struct pktcdvd_device *pd)
+static noinline int pkt_perform_opc(struct pktcdvd_device *pd)
 {
 	struct packet_command cgc;
 	struct request_sense sense;

-- 
Peter Osterlund - petero2@telia.com
http://web.telia.com/~u89404340
