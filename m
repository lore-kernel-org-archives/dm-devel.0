From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH 0/5] new devices + one fix
Date: Sun, 24 Sep 2017 01:38:58 +0200
Message-ID: <20170923233903.24792-1-xose.vazquez@gmail.com>
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

Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>

Xose Vazquez Perez (5):
  multipath-tools: add XIOtech/Magnitude to hardware table
  multipath-tools: add XIV/NEXTRA to hardware table
  multipath-tools: delete libdmmp.pc in uninstall
  multipath-tools: add TMS/RamSan to hardware table
  multipath-tools: add AccelStor/NeoSapphire to hardware table

 libdmmp/Makefile       |  1 +
 libmultipath/hwtable.c | 27 ++++++++++++++++++++++-----
 2 files changed, 23 insertions(+), 5 deletions(-)

-- 
2.13.5
