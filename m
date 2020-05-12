From: mwilck@suse.com
Subject: [PATCH 0/2] More minor libmultipath fixes
Date: Tue, 12 May 2020 22:38:20 +0200
Message-ID: <20200512203822.18910-1-mwilck@suse.com>
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
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

From: Martin Wilck <mwilck@suse.com>

Hi Christophe, hi Ben,

this is a follow-up on yesterday's "Minor fixes for multipath-tools"
series. It adds fixes for sporadic build failures I observed.
The libsg move is a long-overdue cleanup.

Regards
Martin

Martin Wilck (2):
  libmultipath: move libsg into libmultipath
  multipath-tools Makefile: add install dependency

 Makefile                            | 4 ++++
 libmultipath/Makefile               | 3 ++-
 libmultipath/checkers/Makefile      | 6 +++---
 libmultipath/{checkers => }/libsg.c | 0
 libmultipath/{checkers => }/libsg.h | 0
 libmultipath/prioritizers/Makefile  | 2 +-
 6 files changed, 10 insertions(+), 5 deletions(-)
 rename libmultipath/{checkers => }/libsg.c (100%)
 rename libmultipath/{checkers => }/libsg.h (100%)

-- 
2.26.2
