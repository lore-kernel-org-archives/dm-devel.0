From: christophe varoqui <christophe.varoqui@free.fr>
Subject: Re: dm-multipath + iscsi-initiator-core success,
	example, and questions
Date: Fri, 01 Apr 2005 23:16:55 +0200
Message-ID: <1112390215.8118.31.camel@zezette>
References: <1112313131.14802.59.camel@haakon>
	<20050401083504.GA22636@averon.dyndns.org>
	<1112387223.8176.23.camel@haakon>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1112387223.8176.23.camel@haakon>
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

On ven, 2005-04-01 at 12:27 -0800, Nicholas A. Bellinger wrote:
> On Fri, 2005-04-01 at 10:35 +0200, Christophe Varoqui wrote:
> > On Thu, Mar 31, 2005 at 03:52:11PM -0800, Nicholas A. Bellinger wrote:
> > > 
> > > ...
> > >
> > > IO never goes back across iSCSI Channel 20.  I also noticed that this
> > > does not occur every time iSCSI Channel 20 is paused.  Sometimes IO will
> > > stop over iSCSI Channel 21 as well, but iSCSI Channel 20 can be started
> > > and IO resumes correctly to both iSCSI Channels.
> > > 
> > > So my main question is this, once the iSCSI Channel is restarted and IO
> > > is allowed to flow again, how does dm-multipath know that the device is
> > > unlocked and online?
> > > 
> > It's userspace responsability to maintain the device map.
> > In the current available implementation, multipathd does the path checking and reinstate offline paths when they come back up.
> > 
> 
> The problem that I have been encountering is multipathd never testing
> for the path (iSCSI Channel 20 in the above example) once the struct
> scsi_device goes from a blocked to unblocked state.  Is there anything
> that I am missing in the setup in the above example?
> 
You may be hit by a bug in multipath/main.c:pgcmp() I discovered today.

You can try 0.4.4-pre7 or simply :

--- multipath-tools-0.4.4-pre6/multipath/main.c 2005-03-31
11:05:32.000000000 +0200
+++ multipath-tools-0.4.4-pre7/multipath/main.c 2005-04-01
21:54:44.000000000 +0200

@@ -503,10 +512,9 @@
                                if (found)
                                        break;
                        }
-                       if (found) {
+                       if (found)
                                found = 0;
-                               break;
-                       } else
+                       else
                                return 1;

-- 
christophe varoqui <christophe.varoqui@free.fr>
