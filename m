From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 0/3] Clang fixes
Date: Tue,  9 Aug 2016 09:31:10 +0200
Message-ID: <1470727873-10502-1-git-send-email-hare@suse.de>
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
To: Christophe Varoqui <christophe.varoqui@gmail.com>
Cc: dm-devel@redhat.com, Xose Vazquez Perez <xose.vazquez@gmail.com>
List-Id: dm-devel.ids

Hi Christophe,

Xose found some issues when building with clang.

Hannes Reinecke (3):
  libmultipath/discovery.c: use 'unsigned long' instead of 'unsigned int'
  libmultipath/parser.c: correctly terminate buffer
  multipath: fixup check for out-of-scope maps

 libmultipath/discovery.c | 2 +-
 libmultipath/parser.c    | 2 +-
 multipath/main.c         | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

-- 
2.6.6
