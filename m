From: Jonathan Brassow <jbrassow@redhat.com>
Subject: [2.6.22-rc1-mm1 PATCH 0/10] Mirror fault handling code.
Date: Mon, 21 May 2007 16:55:39 -0500
Message-ID: <1179784539.13913.12.camel@hydrogen.msp.redhat.com>
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
List-Id: dm-devel.ids

The following series of patches gives the ability to handle device
failures in device-mapper mirrors:

#dm-add-ratelimit-logging-macros-fix.patch -- Already sent
#dm-raid1-clear-region-outside-spinlock.patch -- Already sent
dm-raid1-handle_resync_failures.patch
dm-raid1-handle-log-failure.patch
dm-raid1-handle-recovery-write-failures.patch
dm-raid1-handle-write-failures.patch
dm-raid1-report-fault-status.patch
dm-log-split-suspend.patch
dm-raid1-fix-EIO-after-log-failure.patch
dm-raid1-handle-recovery-read-failures.patch
dm-raid1-handle-read-failures.patch
dm-raid1-version-bump.patch

 brassow
