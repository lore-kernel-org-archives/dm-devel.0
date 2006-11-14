From: Dave Wysochanski <dave.wysochanski@redhat.com>
Subject: RE: patch to discovery.c to still get path priority
	forpaths with path state of PATH_DOWN
Date: Tue, 14 Nov 2006 09:26:32 -0500
Message-ID: <1163514392.4850.22.camel@linux-cxyg.rtp.netapp.com>
References: <6CCEAEDF4D06984A83F427424F47D6E4013D1540@CORPUSMX40A.corp.emc.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-/3m2jQnSWyZXDtgWKo1L"
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <6CCEAEDF4D06984A83F427424F47D6E4013D1540@CORPUSMX40A.corp.emc.com>
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
Cc: christophe.varoqui@free.fr
List-Id: dm-devel.ids


--=-/3m2jQnSWyZXDtgWKo1L
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Ed,

Are you saying that there's no way in the path checker to distinguish
between this kind of path and a path that is genuinely down?  By "down",
I mean "fails ioctl" either directly or with an unexpected
CHECK_CONDITION (this seems to be what PATH_DOWN means in the code today
for all the path checkers).  Can you return another state in your path
checker for this type of path/LUN?

IMO, if at all possible, it would be good to leave "PATH_DOWN" with its
current meaning and not call the priority callouts for paths in this
state.  If the priority callouts could obtain priorities without SG_IO
succeeding, it might make sense, but this is not the case today.  If you
once had a good priority because you could get a command through, now
you call it when the path is down it will be replaced with an incorrect
one.

Arguably the states are fuzzy and "types of paths" are mixed in with
"path states" which leads to the fuzzyness/confusion.  Right now I don't
have a good enough feel for it to offer clarifying suggestions though
other than the attached comment patch which tries to clarify the meaning
of each state as it is in the code today.


On Mon, 2006-11-13 at 15:47 -0500, Edward Goggin wrote:
> Dave,
> 
> Sorry for the confusion.
> 
> I realize that at first glance the patch may not make sense, but it
> is an attempt to avoid the case of not being able to properly assign
> path groups with a group_by_priority path grouping policy if any of
> the paths respond successfully to scsi_id(8) and mpath_prio_* but not
> their multipath path checker.  Such is the case for LUNZ and inactive
> snapshot logical units on CLARiiON.
> 
> Ed
> 
> > -----Original Message-----
> > From: dm-devel-bounces@redhat.com 
> > [mailto:dm-devel-bounces@redhat.com] On Behalf Of Dave Wysochanski
> > Sent: Monday, November 13, 2006 3:05 PM
> > To: device-mapper development
> > Cc: christophe.varoqui@free.fr
> > Subject: Re: [dm-devel] patch to discovery.c to still get 
> > path priority forpaths with path state of PATH_DOWN
> > 
> > Ed, I am looking through your patches and in particular this change,
> > which reverts a previous change I submitted a little while back.
> > 
> > Maybe we can do something better like clarify states.  Looking through
> > the code now and will have more feedback.
> > 
> > 
> > 
> > On Fri, 2006-11-10 at 18:01 -0500, Edward Goggin wrote:
> > > --
> > > dm-devel mailing list
> > > dm-devel@redhat.com
> > > https://www.redhat.com/mailman/listinfo/dm-devel
> > 
> > --
> > dm-devel mailing list
> > dm-devel@redhat.com
> > https://www.redhat.com/mailman/listinfo/dm-devel
> > 
> > 
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel

--=-/3m2jQnSWyZXDtgWKo1L
Content-Disposition: attachment; filename=clarify-path-states.patch
Content-Type: text/x-patch; name=clarify-path-states.patch; charset=utf-8
Content-Transfer-Encoding: 7bit

Index: multipath-tools/libcheckers/checkers.h
===================================================================
--- multipath-tools.orig/libcheckers/checkers.h	2006-10-17 18:28:05.000000000 -0400
+++ multipath-tools/libcheckers/checkers.h	2006-11-14 09:18:39.000000000 -0500
@@ -2,7 +2,47 @@
 #define _CHECKERS_H
 
 /*
- * path states
+ *
+ * Userspace (multipath/multipathd) path states
+ *
+ * PATH_WILD:
+ * Use: None of the checkers (returned if we don't have an fd)
+ * Description: Corner case where "fd <= 0" for path fd (see checker_check())
+ * ??? Might need clarification (when does it happen, etc)
+ *
+ * PATH_UNCHECKED:
+ * - Use: Only in directio checker
+ * - Description: set when fcntl(F_GETFL) fails to return flags or O_DIRECT
+ *   not include in flags, or O_DIRECT read fails
+ * - Notes:
+ *   - multipathd: uses it to skip over paths in sync_map_state()
+ *   - multipath: used in update_paths(); if state==PATH_UNCHECKED, call
+ *     pathinfo()
+ * ??? Might need clarification
+ *
+ * PATH_DOWN
+ * - Use: All checkers (directio, emc_clariion, hp_sw, readsector0, tur)
+ * - Description: Either a) SG_IO ioctl failed, or b) check condition on some
+ *   SG_IO ioctls that succeed (tur, readsector0 checkers); path is down and
+ *   you shouldn't try to send commands to it
+ *
+ * PATH_UP
+ * - Use: All checkers (directio, emc_clariion, hp_sw, readsector0, tur)
+ * - Description: Path is up and I/O can be sent to it
+ *
+ * PATH_SHAKY
+ * - Use: Only emc_clariion
+ * - Description: Indicates path not available for "normal" operations
+ * ??? Probably needs a little clarification
+ *
+ * PATH_GHOST
+ * - Use: Only hp_sw
+ * - Description: Indicates a "passive/standby" path on active/passive HP
+ *   arrays.  These paths will return valid answers to certain SCSI commands
+ *   (tur, read_capacity, inquiry, start_stop), but will fail I/O commands.
+ *   The path needs an initialization command to be sent to it in order for
+ *   I/Os to succeed.
+ *
  */
 #define PATH_WILD	-1
 #define PATH_UNCHECKED	0

--=-/3m2jQnSWyZXDtgWKo1L
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--=-/3m2jQnSWyZXDtgWKo1L--
