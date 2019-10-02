From: Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH 0/3] Rebased multipath-tools patches
Date: Wed, 2 Oct 2019 06:48:02 +0000
Message-ID: <20191002064655.2669-1-martin.wilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, Chongyun Wu <wu.chongyun@h3c.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>, Martin Wilck <Martin.Wilck@suse.com>
List-Id: dm-devel.ids

From: Martin Wilck <mwilck@suse.com>

Hi Christophe,

here are the three patches that needed rebasing after
your last merge.

Regards,
Martin


Chongyun Wu (1):
  multipathd: "san_path_err" failure optimization

Martin Wilck (2):
  multipath.conf: add "enable_foreign" parameter
  multipath.conf.5: document foreign library support

 libmultipath/config.h      |  1 +
 libmultipath/defaults.h    |  2 ++
 libmultipath/dict.c        |  6 +++++
 libmultipath/foreign.c     | 53 +++++++++++++++++++++++++++++++++++---
 libmultipath/foreign.h     |  3 ++-
 multipath/main.c           |  2 +-
 multipath/multipath.conf.5 | 40 ++++++++++++++++++++++++++++
 multipathd/main.c          | 19 +++++++++++++-
 8 files changed, 119 insertions(+), 7 deletions(-)

-- 
2.23.0
