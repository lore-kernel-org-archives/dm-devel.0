From: "John A. Sullivan III" <jsullivan@opensourcedevel.com>
Subject: Re: Question regarding failback option in multipath.conf
Date: Thu, 01 Oct 2009 20:39:12 -0400
Message-ID: <1254443952.6539.11.camel@jaspav.missionsit.net.missionsit.net>
References: <5A70833B-9208-470E-88B7-7C351EED2122@aclue.com>
	<4AC3AC88.9020404@redhat.com>
	<06F122DE-B7E5-4721-BA08-D0453D10581C@aclue.com>
	<4AC3B084.4060700@redhat.com>
	<B38A0B62-A47C-4400-B113-5D46D13453D6@aclue.com>
	<3f5a695c0910011416i6d87dcbcr94a04dfd825fba04@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <3f5a695c0910011416i6d87dcbcr94a04dfd825fba04@mail.gmail.com>
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

I don't have the expertise to help very much but did you address the
previous comment about duplicate default blocks? Good luck - John

On Thu, 2009-10-01 at 15:16 -0600, Eli Klein wrote:
> Any ideas on this? Not sure if this e-mail made it out to the list.
> 
> 
> Thanks!
> 
> 
> -Eli
> 
> On Wed, Sep 30, 2009 at 1:36 PM, Eli Klein <elijah@aclue.com> wrote:
>         
>         On Sep 30, 2009, at 1:24 PM, John Brier wrote:
>         
>         > On 09/30/2009 03:16 PM, Eli Klein wrote:
>         > > 
>         > > Here's the abbreviated output from multipath -v3:
>         > > 
>         > > mpath1: pgfailback = 120 (config file default)
>         > > mpath1: pgpolicy = multibus (config file default)
>         > > mpath1: selector = round-robin 0 (internal default)
>         > > mpath1: features = 1 queue_if_no_path (internal default)
>         > > mpath1: hwhandler = 0 (internal default)
>         > > mpath1: rr_weight = 2 (config file default)
>         > > mpath1: minio = 10 (config file default)
>         > > mpath1: no_path_retry = 1 (config file default)
>         > > pg_timeout = NONE (internal default)
>         > > mpath1: set ACT_NOTHING (map unchanged)
>         > > 
>         > > It's definitely picking up the settings correctly from
>         > > multipath.conf,
>         > > but the paths are still reinstated immediately once
>         > > they're reconnected
>         > > (even if it's just for a split second).
>         > > 
>         > 
>         > What does /var/log/messages look like when this happens?
>         > Since you changed failback to 120 did you restart multipathd
>         > or restart the box?
>         > 
>         > John Brier
>         > 
>         > --
>         > dm-devel mailing list
>         > dm-devel@redhat.com
>         > https://www.redhat.com/mailman/listinfo/dm-devel
>         > 
>         
>         
>         I've tried rebooting, restarting multipath (and iscsid),
>         flushing multipath (-F), removing all the iscsi targets
>         completely and then reinitializing the targets.  Nothing
>         changes the behavior.  Here's output from /var/log/messages..
>         note the time between when the link becomes active (13:31:08)
>         to when the path is reinstated (13:31:15):
>         
>         
>         Sep 30 13:30:28 testbox kernel:  connection7:0: ping timeout
>         of 5 secs expired, recv timeout 5, last rx 4470061909, last
>         ping 4470066909, now 4470071909
>         Sep 30 13:30:28 testbox kernel:  connection7:0: detected conn
>         error (1011)
>         Sep 30 13:30:28 testbox multipathd: sdf: readsector0 checker
>         reports path is down
>         Sep 30 13:30:28 testbox multipathd: checker failed path 8:80
>         in map mpath0
>         Sep 30 13:30:28 testbox multipathd: mpath0: remaining active
>         paths: 1
>         Sep 30 13:30:28 testbox kernel: device-mapper: multipath:
>         Failing path 8:80.
>         Sep 30 13:30:28 testbox iscsid: Kernel reported iSCSI
>         connection 7:0 error (1011) state (3)
>         Sep 30 13:30:29 testbox kernel:  connection9:0: ping timeout
>         of 5 secs expired, recv timeout 5, last rx 4470063232, last
>         ping 4470068232, now 4470073232
>         Sep 30 13:30:29 testbox kernel:  connection9:0: detected conn
>         error (1011)
>         Sep 30 13:30:29 testbox multipathd: sdg: readsector0 checker
>         reports path is down
>         Sep 30 13:30:29 testbox multipathd: checker failed path 8:96
>         in map mpath1
>         Sep 30 13:30:29 testbox multipathd: mpath1: remaining active
>         paths: 1
>         Sep 30 13:30:29 testbox kernel: device-mapper: multipath:
>         Failing path 8:96.
>         Sep 30 13:30:30 testbox kernel:  connection11:0: ping timeout
>         of 5 secs expired, recv timeout 5, last rx 4470064373, last
>         ping 4470069373, now 4470074373
>         Sep 30 13:30:30 testbox kernel:  connection11:0: detected conn
>         error (1011)
>         Sep 30 13:30:30 testbox iscsid: Kernel reported iSCSI
>         connection 9:0 error (1011) state (3)
>         Sep 30 13:30:30 testbox multipathd: sdh: readsector0 checker
>         reports path is down
>         Sep 30 13:30:30 testbox multipathd: checker failed path 8:112
>         in map mpath2
>         Sep 30 13:30:30 testbox kernel: device-mapper: multipath:
>         Failing path 8:112.
>         Sep 30 13:30:30 testbox multipathd: mpath2: remaining active
>         paths: 1
>         Sep 30 13:30:30 testbox multipathd: dm-4: add map (uevent)
>         Sep 30 13:30:30 testbox multipathd: dm-4: devmap already
>         registered
>         Sep 30 13:30:30 testbox multipathd: dm-2: add map (uevent)
>         Sep 30 13:30:30 testbox multipathd: dm-2: devmap already
>         registered
>         Sep 30 13:30:30 testbox multipathd: dm-3: add map (uevent)
>         Sep 30 13:30:30 testbox multipathd: dm-3: devmap already
>         registered
>         Sep 30 13:30:31 testbox iscsid: Kernel reported iSCSI
>         connection 11:0 error (1011) state (3)
>         Sep 30 13:30:43 testbox kernel:  session7: session recovery
>         timed out after 15 secs
>         Sep 30 13:30:43 testbox multipathd: sdf: readsector0 checker
>         reports path is down
>         Sep 30 13:30:44 testbox kernel:  session9: session recovery
>         timed out after 15 secs
>         Sep 30 13:30:44 testbox multipathd: sdg: readsector0 checker
>         reports path is down
>         Sep 30 13:30:45 testbox kernel:  session11: session recovery
>         timed out after 15 secs
>         Sep 30 13:30:45 testbox kernel: sd 13:0:0:0: SCSI error:
>         return code = 0x000f0000
>         Sep 30 13:30:45 testbox kernel: end_request: I/O error, dev
>         sdh, sector 407978223
>         Sep 30 13:30:45 testbox multipathd: sdh: readsector0 checker
>         reports path is down
>         Sep 30 13:30:55 testbox multipathd: sdf: readsector0 checker
>         reports path is down
>         Sep 30 13:31:05 testbox multipathd: sdg: readsector0 checker
>         reports path is down
>         Sep 30 13:31:05 testbox multipathd: sdh: readsector0 checker
>         reports path is down
>         Sep 30 13:31:05 testbox multipathd: sdf: readsector0 checker
>         reports path is down
>         Sep 30 13:31:05 testbox multipathd: sdg: readsector0 checker
>         reports path is down
>         Sep 30 13:31:05 testbox multipathd: sdh: readsector0 checker
>         reports path is down
>         Sep 30 13:31:08 testbox iscsid: connection9:0 is operational
>         after recovery (3 attempts)
>         Sep 30 13:31:08 testbox iscsid: connection11:0 is operational
>         after recovery (3 attempts)
>         Sep 30 13:31:11 testbox iscsid: connection7:0 is operational
>         after recovery (3 attempts)
>         Sep 30 13:31:15 testbox multipathd: sdf: readsector0 checker
>         reports path is up
>         Sep 30 13:31:15 testbox multipathd: 8:80: reinstated
>         Sep 30 13:31:15 testbox multipathd: mpath0: remaining active
>         paths: 2
>         Sep 30 13:31:15 testbox multipathd: sdg: readsector0 checker
>         reports path is up
>         Sep 30 13:31:15 testbox multipathd: 8:96: reinstated
>         Sep 30 13:31:15 testbox multipathd: mpath1: remaining active
>         paths: 2
>         Sep 30 13:31:15 testbox multipathd: sdh: readsector0 checker
>         reports path is up
>         Sep 30 13:31:15 testbox multipathd: 8:112: reinstated
>         Sep 30 13:31:15 testbox multipathd: mpath2: remaining active
>         paths: 2
>         Sep 30 13:31:15 testbox multipathd: dm-4: add map (uevent)
>         Sep 30 13:31:15 testbox multipathd: dm-4: devmap already
>         registered
>         Sep 30 13:31:15 testbox multipathd: dm-2: add map (uevent)
>         Sep 30 13:31:15 testbox multipathd: dm-2: devmap already
>         registered
>         Sep 30 13:31:15 testbox multipathd: dm-3: add map (uevent)
>         Sep 30 13:31:15 testbox multipathd: dm-3: devmap already
>         registered
>         
>         
> 
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
-- 
John A. Sullivan III
Open Source Development Corporation
+1 207-985-7880
jsullivan@opensourcedevel.com

http://www.spiritualoutreach.com
Making Christianity intelligible to secular society
