From: Eddie Williams <Eddie.Williams@steeleye.com>
Subject: dm-emc:  failback does not seem to work correctly
Date: Fri, 28 Apr 2006 17:29:34 -0400
Message-ID: <1146259775.3117.71.camel@gator.sc.steeleye.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
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
Cc: James Bottomley <James.Bottomley@steeleye.com>, lmb@suse.redhat.com
List-Id: dm-devel.ids


I am testing SLES 9 SP3 with an EMC CLARiiON array (CX300).  When I pull
cables (on the storage side of the switches) the IO's are successfully
switched to the good paths (all the way down to a single good path).
However when I replace the cables the switchback does not seem to work
successfully.  Well, for the active devices, e.g. where there are IO's
being issued, everything seems to work fine.  For devices that are not
being used there lots of messages (every loop of multipathd).

I see the message:
multipathd: 360060160cfd0150045435fc76f20da11: switch to path group #1

and then
device-mapper: dm-emc: emc_pg_init: sending switch-over command

Then it repeats the switch to path group messages (each iteration of the
multipathd daemon).  This seems to repeat indefinitely.  There are no
other messages that would indicate a failure or problem.  

The output from multipath -ll shows everything is now active/ready:
360060160cfd0150045435fc76f20da11
[size=5 GB][features="1 queue_if_no_path"][hwhandler="1 emc"]
\_ round-robin 0 [prio=2][enabled]
 \_ 2:0:1:16 sdbz 68:208 [active][ready]
 \_ 1:0:0:16 sdr  65:16  [active][ready]
\_ round-robin 0 [enabled]
 \_ 1:0:1:16 sdal 66:80  [active][ready]
 \_ 2:0:0:16 sdbf 67:144 [active][ready]

The multipath.conf entry is:
  device {
          vendor                  "DGC"
          product                 "*"
          path_grouping_policy    group_by_prio
          getuid_callout          "/sbin/scsi_id -g -u -s /block/%n"
          prio_callout            "/sbin/mpath_prio_emc /dev/%n"
          hardware_handler        "1 emc"
          features                "1 queue_if_no_path"
          path_checker            emc_clariion
          failback                immediate
  }

If I startup IO to the luns that are being complained about the messages
stop.  It does not seem the switchover is performed unless there is IO
happening at the time the switchover is attempted.

Eddie
