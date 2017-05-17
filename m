From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 0/2] Small multipath fixes
Date: Wed, 17 May 2017 17:24:44 +0200
Message-ID: <20170517152446.2526-1-mwilck@suse.com>
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
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, Hannes Reinecke <hare@suse.de>, Bart Van Assche <Bart.VanAssche@sandisk.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Two minor fixes that I found necessary recently.

Both touch potentially bigger issues - the first one print.c, which
might need some general overhaul at some time in the future, and the
second one the build process of multipath tools, which is currently
lacking an "autobuild" mechanism.

My intention at was to keep the patches small and non-controversial,
therefore I didn't delve into the big issues just yet.

Changes wrt v1 (suggestions by Bart Van Assche):
- patch 1/2: replaced ENDLINE by a function
- patch 2/2: Removed nonstandard <<< construct, and made sure STACKPROT is only
  set once per makefile.

Martin Wilck (2):
  libmultipath: print.c: make sure lines are 0-terminated
  multipath-tools: fix compilation with gcc < 4.9

 Makefile.inc         | 15 ++++++++++++++-
 libmultipath/print.c | 25 +++++++++++++++++--------
 2 files changed, 31 insertions(+), 9 deletions(-)

-- 
2.12.2
