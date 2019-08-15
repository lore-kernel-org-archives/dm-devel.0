From: Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH 0/2] multipath-tools: Add option to disable NVMe
 ("foreign") support
Date: Thu, 15 Aug 2019 14:46:53 +0000
Message-ID: <20190815144638.5664-1-martin.wilck@suse.com>
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
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, Benjamin Marzinski <bmarzins@redhat.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>, Martin Wilck <Martin.Wilck@suse.com>
List-Id: dm-devel.ids

From: Martin Wilck <mwilck@suse.com>

Hi Christophe, hi Ben,

This is my alternative take to Ben's "multipath: add print_foreign option"
patch. I'd prefer it because it's more generic and more flexible for future
extensions.

Regards
Martin

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
 multipathd/main.c          |  2 +-
 8 files changed, 102 insertions(+), 7 deletions(-)

-- 
2.22.0
