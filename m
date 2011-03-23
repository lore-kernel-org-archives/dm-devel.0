From: Phillip Susi <psusi@cfl.rr.com>
Subject: Differentiating between dm devices
Date: Wed, 23 Mar 2011 13:30:59 -0400
Message-ID: <4D8A2E53.10401@cfl.rr.com>
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
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

There are different classes of dm devices that different utilities may
or may not care about.  Some are intended to represent whole disks (
dmraid ) that can be partitioned.  Some ARE partitions and should
contain filesystems.  Still others are used only internally by the tools
( -real, -cow for lvm, and raid10 subvolumes for dmraid ).  I can not
find any good way to differentiate between these types.

One way of fixing this is to add a new attribute to the device where the
tools creating them can specify a hint about what they are and how they
should be used.  Another way is to embed that information in the UUID.
For instance, logical volumes have UUIDs that start with "LVM-" and
dmraid disks start with "DMRAID-".  Perhaps dmraid partitions could have
their uuids changed to "DMRAIDP-" and internal devices changed to
"DMRAIDI-" and "LVMI-" for dmraid and lvm respectively.

Which of these ways sounds best, or is there a better one I have not
thought of?
