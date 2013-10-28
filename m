From: dongmao zhang <dmzhang@suse.com>
Subject: [PATCH 0/1] patches to improve cluster raid1 performance
	[V3]
Date: Mon, 28 Oct 2013 18:07:02 +0800
Message-ID: <cover.1382949020.git.dmzhang@suse.com>
References: <yes>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <yes>
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

use DM_INTEGRATED_FLUSH to indicate the new option of flush request.
when using DM_INTEGRATED_FLUSH, the payload of flush request is the 
same as mark region request.

'X' means we have this kind of request, while '0' means none.

mark request :     X               X               0

clear request:     X               0               X

flush method:    payload_flush   payload_flush   delayed flush

dongmao zhang (1):
  improve the performance of dm-log-userspace

 drivers/md/dm-log-userspace-base.c    |  133 +++++++++++++++++++++++++++++----
 include/uapi/linux/dm-log-userspace.h |    6 +-
 2 files changed, 121 insertions(+), 18 deletions(-)

-- 
1.7.3.4
