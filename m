From: Edward Goggin <egoggin@emc.com>
Subject: boot scripts and dm-multipath
Date: Wed, 4 Oct 2006 15:42:02 -0400
Message-ID: <6CCEAEDF4D06984A83F427424F47D6E4013D1410@CORPUSMX40A.corp.emc.com>
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
To: dm-devel@redhat.com
List-Id: dm-devel.ids

SuSE and Red Hat (maybe others also) enterprise distributions currently
invoke multipath fairly early in the boot sequence, followed sometime
later by multipathd.  I think that these distributions run the risk of
incurring a boot-time hang when read I/Os issued (by kpartx in
/etc/boot.multipath for instance) to dm-multipath mapped devices before
multipathd is started, fail (due to failures which are not SCSI
transport related) when sent to storage targets configured with the
dm-multipath queue_if_no_path.  Without multipathd running there is no
ability to timeout the "queue I/O forever" behavior during an
all-paths-down use case.

In these cases, the dm-multipath device is created because the storage
target responds successfully to the device id (VPD page 0x83) inquiry
request for each path but all path tests and read/write I/O requests
issued on any/all paths to the block device will fail.  Currently, the
kernel resident dm-multipath code will queue the failed read/write I/O
indefinitely if the queue_if_no_path attribute is configured for the
mapped device since this code is currently unable to differentiate
between SCSI transport related failures and other errors.

Newer versions of multipathd (that is, ones based on
multipath-tools-0.4.7) do not need to invoke multipath in order to
configure the dm-multipath mapped devices, simply invoking multipathd
suffices.  Is it reasonable to change these scripts to invoke multipathd
instead of multipath at early boot and not invoke multipath at all from
these scripts?
