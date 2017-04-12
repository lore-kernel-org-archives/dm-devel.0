From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: [PATCH 0/2] RFC: multipath proposals
Date: Wed, 12 Apr 2017 17:15:08 -0500
Message-ID: <1492035310-27525-1-git-send-email-bmarzins@redhat.com>
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

I'm interested if anyone has any opinions on either of these two patches.

Benjamin Marzinski (2):
  multipath: Merge the DELL MD3xxx device configs
  multipath: attempt at common multipath.rules

 kpartx/kpartx.rules       |  8 --------
 libmultipath/hwtable.c    | 26 +-------------------------
 multipath/multipath.rules | 27 ++++++++++++++++++++++++---
 3 files changed, 25 insertions(+), 36 deletions(-)

-- 
1.8.3.1
