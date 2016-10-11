From: Mike Christie <mchristi@redhat.com>
Subject: [PATCH 0/5] rbd checker fixes
Date: Tue, 11 Oct 2016 16:36:50 -0500
Message-ID: <1476221815-17900-1-git-send-email-mchristi@redhat.com>
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
To: dm-devel@redhat.com, christophe.varoqui@opensvc.com
List-Id: dm-devel.ids

The following pathces made over the multipath-tools tree today
fix some bugs in the rbd checker and sync up log messages.

The first 4 patches are a resend from here:
https://www.redhat.com/archives/dm-devel/2016-August/msg00429.html
I did not see any review comments (of course let me know if I missed
them), so the only changes are from being rebased on the current tree.

The last patch is new and adds a fix for when rbd's lock_on_read
feature is used.
