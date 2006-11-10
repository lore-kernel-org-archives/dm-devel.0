From: Edward Goggin <egoggin@emc.com>
Subject: boot scripts and dm-multipath
Date: Fri, 10 Nov 2006 15:11:35 -0500
Message-ID: <6CCEAEDF4D06984A83F427424F47D6E4013D152C@CORPUSMX40A.corp.emc.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
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

Resending this since I think I got no feedback last time.

Linux distributions currently invoke /sbin/multipath fairly early in the
boot sequence, followed sometime later by /sbin/multipathd.  I think
that these distributions run the risk of incurring a boot-time hang
when/if read I/Os issued (by kpartx in /etc/boot.multipath for instance)
to dm-multipath devices before multipathd is started, fail (due to
failures which are not SCSI transport related) when sent to storage
targets configured with the dm-multipath queue_if_no_path feature.
Without multipathd running there is no ability to timeout the "queue I/O
forever" behavior during an all-paths-down use case.

In these cases, the dm-multipath device is created because the storage
target responds successfully to the device id inquiry request for each
path but all path tests and read/write I/O requests issued on all paths
to the device will fail.  If the dm-multipath device was configured with
the queue_if_no_path feature, the kernel dm-multipath code will queue
the failed read/write I/O indefinitely.

Newer versions of multipathd (that is, ones based on
multipath-tools-0.4.7) do not need to invoke multipath in order to
configure the dm-multipath, simply invoking multipathd suffices.  Is it
reasonable to change these scripts to invoke multipathd instead of
multipath at early boot and not invoke multipath at all from these
scripts?
