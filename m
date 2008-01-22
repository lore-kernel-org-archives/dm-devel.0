From: "Sarraf, Ritesh" <Ritesh.Sarraf@netapp.com>
Subject: RE: Root device multipathed host freeze with the latest
	upstream multipath-tools package
Date: Tue, 22 Jan 2008 21:56:13 +0530
Message-ID: <7026BCCA258BA2438F885772CA0B431310523ACD@exbtc01.hq.netapp.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-class: urn:content-classes:message
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "George, Martin" <marting@netapp.com>, k-ueda@ct.jp.nec.com
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Now that 'relatime' is pushed to all major distribuitons, should we just
document and discourage 'noatime' ? (At least for SAN Boot)
Apart from Backup softwares and tmpclean, I can't recollect any other
user of it.
OTOH LUNs would be easily backed by users on the target.

Ritesh

________________________________

From: George, Martin=20
Sent: Tuesday, January 22, 2008 9:00 PM
To: k-ueda@ct.jp.nec.com
Cc: Sarraf, Ritesh
Subject: Root device multipathed host freeze with the latest upstream
multipath-tools package


Hi Kiyoshi,
=20
I took the latest upstream multipath-tools package (Jan 15, 2008) and
installed it on my RHEL 5.1 host to verify the libprio fix. To simulate
the FCP path faults, I ran your script (as attached in the mail) which
alternately offlined/onlined the corresponding SCSI paths of the root dm
device in the syfs. Listing my observations below:
=20
1) The freeze was still reproducible. On checking the sysrq dumps (as
attached), I could see it was the script itself i.e. test.sh which seems
to have stalled on the exec () system call perhaps waiting for inode
write out for updated access time (the script resides on my root dm
device itself). As suggested by you in the bugzilla, I remounted the
root device using the noatime option and then reran the script - I have
not hit the freeze yet. Is this the expected behavior?=20
=20
2) With the latest upstream multipath-tools package, "multipath -ll"
displays all paths with the same priority - I am not able to prioritize
paths into primary/secondary despite the normal group_by_prio setting.
Does the libprio fix alter the behavior here?
=20
Wanted to know your comments on the same.
=20
Thanks a lot,
-Martin
