From: Ken Raeburn <raeburn@permabit.com>
Subject: multipathd, mpathpersist and APTPL
Date: Thu, 08 Jan 2015 19:27:52 -0500
Message-ID: <6e1tn4g5mf.fsf@just-testing.permabit.com>
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
To: dm-devel@redhat.com
List-Id: dm-devel.ids


If multipathd re-registers a system's reservation key along a formerly
faulty path that has started working, it will clear the APTPL (Activate
Persistence Through Power Loss) flag for all registrations on the LUN,
possibly overriding an application setting ("mpathpersist -Z") and
causing loss of all registrations upon a following power-loss event.

If some user-mode software registers the reservation key that is listed
in multipath.conf, setting the APTPL flag, and any path to the device
later transitions from faulty to ready, then multipathd will see the key
registration, and issue a MPATH_PROUT_REG_IGN_SA command with APTPL
clear. Per the SCSI spec (section 6.16.3 in draft revision 37 of SPC-4)
the APTPL setting from the last valid command processed for the LUN
dictates the device server's behavior until the next change. So APTPL=0
will override a previous APTPL=1 setting.

I've confirmed it by experimentation with a RHEL 6.6 initiator and an
SCST target (both by monitoring the existence and content of the
saved-PR file and by instrumenting the SCST driver code via SystemTap),
and by code inspection in the git.opensvc.com repository
(multipathd/main.c:mpath_pr_event_handler_fn never sets param->sa_flags
after the memset).

I think multipathd needs to be able to set the flag. I would expect some
use cases would always want the flag set if possible, but as some
devices may not support APTPL, I suspect it needs to be specified in the
config file. So I'm contemplating how to do that.

Two obvious approaches come to mind. First, a new configuration option
that can be specified along with reservation_key:

  defaults {
    reservation_key 123456abcdef
    reservation_aptpl yes
    ...
  }

Alternatively, I could imagine keeping all the reservation information
together in one config option:

  defaults {
    reservation_key "123456abcdef aptpl=1"
    ...
  }

I'm leaning slightly towards the first, and will probably try to
implement it at some point in the near future, in case anyone wants to
propose a different approach...

Ken
