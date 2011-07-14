From: Jonathan Brassow <jbrassow@redhat.com>
Subject: [PATCH 0 of 2] Updates to existing dm-raid patches
Date: Thu, 14 Jul 2011 16:15:33 -0500
Message-ID: <1310678133.2246.25.camel@f14.redhat.com>
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

agk,

You currently have 6 patches going into linux-next for dm-raid.  I have
found two small, but necessary updates that must also be included.
These updates are listed as *-2.patch below.  They should be folded into
the existing patches for which they are named.

dm-raid-cleanup-parameter-handling.patch
<new> dm-raid-cleanup-parameter-handling-2.patch
dm-raid-improve-table-parameters-documentation.patch
dm-raid-add-region_size-parameter.patch
dm-raid-add-write_mostly-parameter.patch
dm-raid-support-metadata-devices.patch
dm-raid-add-md-raid1-support.patch
<new> dm-raid-add-md-raid1-support-2.patch

Please include these fixes.

Thanks,
 brassow
