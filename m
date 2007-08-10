From: Jan Blunck <jblunck@suse.de>
Subject: [patch 00/11] device-mapper cleanups
Date: Fri, 10 Aug 2007 22:02:04 +0200
Message-ID: <33205.198965925$1186776753@news.gmane.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
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
To: agk@redhat.com
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

Here are some device-mapper cleanups. Most patches touch only the snapshot
target since I'm working on some major changes there.

Included in this patch set is only trivial patches and one bugfix to let the
current code compile with CONFIG_LBD.

Cheers,
Jan

-- 
