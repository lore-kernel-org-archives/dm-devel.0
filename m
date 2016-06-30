From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH 0/5] multipath-tools: Makefiles housekeeping
Date: Thu, 30 Jun 2016 15:44:13 +0200
Message-ID: <1467294253-19376-1-git-send-email-xose.vazquez@gmail.com>
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
  multipath-tools: delete spec/rpm traces from Makefile
  multipath-tools: merge RPM_OPT_FLAGS into OPTFLAGS
  multipath-tools: don't create /usr/share/doc/mpathpersist/ from make install
  multipath-tools: don't create /etc/init.d from make install
  multipath-tools: make uninstall leaves traces behind

 Makefile                 | 9 ---------
 Makefile.inc             | 7 ++-----
 libmpathpersist/Makefile | 3 ++-
 multipathd/Makefile      | 2 --
 4 files changed, 4 insertions(+), 17 deletions(-)

-- 
2.7.4
