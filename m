From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH RESEND 0/3] Possibly lost multipath-tools patches
Date: Thu, 11 Apr 2019 12:27:11 +0200
Message-ID: <20190411102714.12026-1-mwilck@suse.com>
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

Hello Christophe,

lest they be forgotten, the patches in this series have been previously
submitted to dm-devel, and got positive review. Please apply at your
convenience. Ben's latest series "[PATCH v3 00/17] Misc Multipath patches"
is IMO also ready for merging.

Patches 2/3 and 3/3 were part of my "[RFC PATCH 0/6] multipath-tools: Fix
remaining shutdown delay issues" series in January. These two got acked by
Ben. They are independent of the rest of the series, which still needs more
work. I made a small change to patch 3/3: the original patch had renamed
"running_state" to "_running_state" to make the compiler catch all accesses
to this variable. After fixing all references, I believe that the renaming
isn't necessary any more, and not doing it improves the readability of the
patch.

Regards
Martin

Chongyun Wu (1):
  multipathd: fix daemon not really shutdown

Dominique Leuenberger (1):
  multipath-tools: Build: properly parse systemd's version

Martin Wilck (1):
  multipathd: protect all access to running_state

 Makefile.inc      |  9 +++++--
 multipathd/main.c | 60 ++++++++++++++++++++++++++++++-----------------
 2 files changed, 46 insertions(+), 23 deletions(-)

-- 
2.21.0
