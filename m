From: Phillip Susi <psusi@cfl.rr.com>
Subject: 2.6.35 causes deadlock when snapshotting root lv
Date: Thu, 17 Jun 2010 09:50:49 -0400
Message-ID: <4C1A2839.5010407@cfl.rr.com>
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

What:

lvcreate -s -n snap -L 1g vg/root hangs in an unkillable state while
trying to flush the fs and suspend the device to switch tables over to
the snapshot, and no further IO is possible so the system must be hard
booted with magic-sysrq.

Where: 2.6.35, all 3 release candidates.  2.6.34 and earlier kernels are
fine.
