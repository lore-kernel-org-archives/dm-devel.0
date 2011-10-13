From: Jonathan Brassow <jbrassow@redhat.com>
Subject: [PATCH 0 of 2] DM log userspace: Allow DM_ULOG_CTR
 exchange to accept devices for register
Date: Thu, 13 Oct 2011 14:15:12 -0500
Message-ID: <1318533312.28595.4.camel@f14.redhat.com>
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

The following two patches allow the dm-log-userspace module to have a
two-way communication when DM_ULOG_CTR is issued.  The outbound (kernel
-> userspace) msg sends the CTR information necessary to build the log
device.  The new inbound (userspace -> kernel) msg sends the log device
name to the kernel so the kernel can call 'dm_get_device' on it.  This
allows the necessary device dependencies to be built.

 brassow
