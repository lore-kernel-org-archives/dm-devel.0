From: "Ishai Rabinovitz" <ishai@dev.mellanox.co.il>
Subject: Some questions about multipath and probably a deadlock
Date: Wed, 18 Oct 2006 19:49:43 +0200 (IST)
Message-ID: <13405.194.90.237.34.1161193783.squirrel@dev.mellanox.co.il>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
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
Cc: ishai@mellanox.co.il
List-Id: dm-devel.ids

Hi All,

I take part in the development of SRP (Scsi Rdma Protocol) for InfiniBand=
.

I'm trying to use multipath to implement High Availability for SRP.

I have some problems which I think are general for multipath and not SRP
dependent and I will applicate any help you can give me.

I'm running on SLES10 on x86_64 with multipath-tools v0.4.7.
I'm connecting to a target that has about 100 LUNs. Both initiator ports
are connected to both target ports using a switch, so there are total of =
4
paths between the initiator and the target.

  1. I added the following rule to udev:
     ACTION=3D=3D"add", KERNEL=3D=3D"sd*[!0-9]", RUN+=3D"/sbin/multipath =
%M:%m"
     Therefore udev executes an instance of multipath for each new
device. So when the initiator boots and connects to the target there
are 400 multipath instances (4 paths * 100 LUNs). Each of this
instances examines all existing devices. It takes a long time
(several minutes) for this process to settle down. Is there a way to
avoid this quadratic complexity?

  2. I'm using this rule in SLES10. RHEL4 distribution uses udev 039 that
does not support the RUN option. I want to use multipath without
installing higher version of udev. Is it possible? Is there a hack to
do it?

  3. While testing my solution I get what seems to be a deadlock between
multipath instances. It happens when there simultaneously
disconnections and connections (i.e., one path fails, and another path
connects). It seems that the multipath that is being executes for the
new LUNs, try to access the LUNs from the failed path and get stuck.
you can find the output of "echo t > /proc/sysrq-trigger" in
http://www.4shared.com/file/4723366/17a86be8/logmult2.html
(This is a sharing site - please press the download at the bottom).
I do not think that this problem is SRP dependent, because none of the
process is executing SRP code.

Thanks a lot for your time and help.
Ishai
