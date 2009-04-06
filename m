From: Jonathan Brassow <jbrassow@redhat.com>
Subject: [PATCH 0 of 33] DM Exception Store API change (repost
	patches)
Date: Mon, 06 Apr 2009 16:32:00 -0500
Message-ID: <1239053520.13756.6.camel@hydrogen.msp.redhat.com>
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

I am reposting the patches due to the following changes:

dm-exception-store-rename-drop_snapshot.patch
- Removed two unneeded '#define's that were not necessary in the patch

dm-exception-store-add-arg-to-lookup_exception.patch
- Changed the added argument from an 'int' used as a boolean to a
uint32_t used as 'flags'

dm-snap-utilize-snapshare.patch
- Fixed a race condition that was introduced between dtr and I/O
completion

Other patches in the series had to be adjusted due to the above changes.
Sorry to post the entire lot again; but I figured it was better to
correct them before they went in than after.

I will again mark the old patches as 'superseded' and archive them.
 brassow
