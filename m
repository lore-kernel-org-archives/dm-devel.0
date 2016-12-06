From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH 0/2] multipath-tools: Add security hardening
	build flags
Date: Tue,  6 Dec 2016 02:31:01 +0100
Message-ID: <20161206013101.10724-1-xose.vazquez@gmail.com>
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
Cc: device-mapper development <dm-devel@redhat.com>, Xose Vazquez Perez <xose.vazquez@gmail.com>
List-Id: dm-devel.ids

Xose Vazquez Perez (2):
  multipath-tools: Replace -fstack-protector with -fstack-protector-strong
  multipath-tools: Add -Werror compilation flags

 Makefile.inc | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
-- 
2.11.0
