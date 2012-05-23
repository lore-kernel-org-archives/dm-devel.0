From: Cedric Buissart <cbuissar@redhat.com>
Subject: [PATCH]] multipath-tools : Minor typo in
	multipath.conf.annotated
Date: Wed, 23 May 2012 14:47:35 +0200
Message-ID: <4FBCDC67.1020503@redhat.com>
Reply-To: cbuissar@redhat.com, device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
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

path checking alorithm <= should be algorithm
---
  multipath.conf.annotated |    2 +-
  1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/multipath.conf.annotated b/multipath.conf.annotated
index c8e8218..8700d33 100644
--- a/multipath.conf.annotated
+++ b/multipath.conf.annotated
@@ -491,7 +491,7 @@
  ##
  #              # name    : path_checker, checker
  #              # scope   : multipathd & multipathd
-#              # desc    : path checking alorithm to use to check path 
state
+#              # desc    : path checking algorithm to use to check path 
state
  #              # values  : 
readsector0|tur|emc_clariion|hp_sw|directio|rdac|
  #              #           cciss_tur
  #              #
-- 
1.7.7.6

-- 
Cedric Buissart,
Technical Support Engineer.
Red Hat UK Ltd
200 Fowler Avenue IQ Farnborough, Farnborough, Hants GU14 7JP

Registered in England and Wales under Company Registration No. 03798903
Directors: Michael Cunningham (USA), Mark Hegarty (Ireland), Matt Parson
(USA), Charlie Peters (USA)
