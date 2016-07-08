From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH 00/14] update and general clean up of
	multipath.conf.5
Date: Fri,  8 Jul 2016 19:49:45 +0200
Message-ID: <1468000199-15566-1-git-send-email-xose.vazquez@gmail.com>
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

Final result in PDF(35k): https://drive.google.com/file/d/0B_B6YmEmO7cDa09mdTlGa1NlSWc

Xose Vazquez Perez (14):
  multipath-tools: replace bold<->italic in multipath.conf.5
  multipath-tools: add alias_prefix to multipath.conf.5
  multipath-tools: add partition_delimiter to multipath.conf.5
  multipath-tools: correct and add default values in multipath.conf.5
  multipath-tools: clarify DGC/EMC arrays info at multipath.conf.5
  multipath-tools: clarify ONTAP class info at multipath.conf.5
  multipath-tools: clarify RDAC class info at multipath.conf.5
  multipath-tools: clarify HP/COMPAQ/DEC Active/Standby arrays info at multipath.conf.5
  multipath-tools: mark hardware-dependent features in multipath.conf.5
  multipath-tools: add default value for hardware_handler in multipath.conf.5
  multipath-tools: add cciss_tur path_checker to multipath.conf.5
  multipath-tools: list undocumented prioritizers in multipath.conf.5
  multipath-tools: add undocumented features to multipath.conf.5
  multipath-tools: minor edit of multipath/multipath.conf.5

 multipath/multipath.conf.5 | 342 +++++++++++++++++++++++++++------------------
 1 file changed, 209 insertions(+), 133 deletions(-)

Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
-- 
2.7.4
