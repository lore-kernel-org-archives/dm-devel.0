From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH 0/4] make tur the default path checker
Date: Thu, 23 Jun 2016 15:42:16 +0200
Message-ID: <1466689340-5590-1-git-send-email-xose.vazquez@gmail.com>
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
Cc: Matthias Rudolph <matthias.rudolph@hds.com>, Xose Vazquez Perez <xose.vazquez@gmail.com>, Yacine Kheddache <yacine@alyseo.com>, device-mapper development <dm-devel@redhat.com>, "Brian King,
	IBM" <brking@linux.vnet.ibm.com>, Srinivasan Ramani <srinivas.ramani@oracle.com>, Sean Stewart <sean.stewart@netapp.com>, Shyam Sundar <g.shyamsundar@yahoo.co.in>, "Bart Brooks,
	Pivot3" <bartb@pivot3.com>, "Edward Goggin, EMC" <egoggin@emc.com>
List-Id: dm-devel.ids

Based on previous Hannes's work.
He says:
"For years I've been telling our customers to use the 'tur' checker
as the current default 'directio' will cause spurious path failures
under high load."

Xose Vazquez Perez (4):
  multipath-tools: change the default path checker from directio to tur
  multipath-tools: update path checker info in multipath.conf.5
  multipath-tools: replace TUR with DEFAULT_CHECKER in hwtable
  multipath-tools: replace DIRECTIO with DEFAULT_CHECKER in hwtable

 libmultipath/checkers.h    |   2 +-
 libmultipath/hwtable.c     | 100 ++++++++++++++++++++++-----------------------
 multipath/multipath.conf.5 |   8 ++--
 3 files changed, 56 insertions(+), 54 deletions(-)

Cc: Shyam Sundar <g.shyamsundar@yahoo.co.in>
Cc: Edward Goggin, EMC <egoggin@emc.com>
Cc: Matthias Rudolph <matthias.rudolph@hds.com>
Cc: Brian King, IBM <brking@linux.vnet.ibm.com>
Cc: Yacine Kheddache <yacine@alyseo.com>
Cc: Srinivasan Ramani <srinivas.ramani@oracle.com>
Cc: Bart Brooks, Pivot3 <bartb@pivot3.com>
Cc: Martin George <marting@netapp.com>
Cc: Sean Stewart <sean.stewart@netapp.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
-- 
2.5.5
