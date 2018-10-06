From: Stef Walter <stefw@redhat.com>
Subject: [PATCH 0/1] Fix kpart -d regression where matching
	devices not found
Date: Sat,  6 Oct 2018 09:38:55 +0200
Message-ID: <20181006073856.15246-1-stefw@redhat.com>
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
Cc: Stef Walter <stefw@redhat.com>
List-Id: dm-devel.ids

The Lorax project found a regression in kpartx -d behavior introduced
by the following commit: 9bdfa3eb8e24b668e6c2bb882cddb0ccfe23ed5b

This patch should fix the problem. It's easy to reproduce this problem
(I did it on Fedora 28) with the following commands:

        # kpartx -av disk.img
        ...
        # kpartx -dv disk.img

Notice that the loop devices and partition mappings created by the first
command are not cleaned up by the second command.

Stef Walter (1):
  kpartx: Use absolute paths to create mappings

 kpartx/kpartx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

-- 
2.17.1
