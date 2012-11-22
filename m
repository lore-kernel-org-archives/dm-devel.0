From: Guangliang Zhao <gzhao@suse.com>
Subject: [PATCH 0/3] add resync speed control for dm-raid1
Date: Thu, 22 Nov 2012 14:27:50 +0800
Message-ID: <1353565673-4233-1-git-send-email-gzhao@suse.com>
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
To: linux-kernel@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids

Hi,

These patches are used to add resync speed control for dm-raid1. The
second and third patch provide support for user-space tool dmsetup.

Guangliang Zhao (3):
  dm raid1: add resync speed control for dm-raid1
  dm raid1: add interface to set resync speed
  dm raid1: add interface to get resync speed

 drivers/md/dm-raid1.c |   93 +++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 90 insertions(+), 3 deletions(-)

-- 
1.7.10.4
