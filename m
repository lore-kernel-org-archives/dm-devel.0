From: mwilck@suse.com
Subject: [PATCH v3 00/87] multipath-tools series part VII:
	addional patches
Date: Wed, 19 Aug 2020 15:18:15 +0200
Message-ID: <20200819131819.13493-1-mwilck@suse.com>
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

This is v3 of part VII of a larger patch series for multipath-tools I've
been preparing. It's based on the previously submitted part VI.

The full series will also be available here:
https://github.com/mwilck/multipath-tools/tree/ups/submit-200819
This part is tagged "submit-200819-7".

This part contains patches added since the v1 and v2 submissions of the series.
One is Liu's fix for disassemble_map(), rebased on top of my previous changes
to that function.

84/87, related to inconsistent alias settings, belongs logically to part III.
I couldn't add it there because it would have changed the numbering in the
series wrt v1, which I wanted to avoid.

Changes v2 -> v3, as suggested by Ben Marzinski:

 84/87 "libmultipath: add consistency check for alias settings"
   - fixed possible freeing of NULL pointer
   - search vector backwards in add_binding()
   - avoid fd leak in check_alias_settings()

 85/87 "libmultipath: alias.c: use strtok_r() instead of strtok()"
   - new, provide thread safety in alias.c

 86/87 "libmultipath: adopt_paths(): set pp->mpp only on success"
   - new, implement Ben's suggestion in his review of patch 54 in the
     v2 series ("[PATCH v2 44/54] libmultipath: adopt_paths(): don't 
     bail out on single path failure")

Besides, a trivial warning fix was added (87/87).

Martin Wilck (6):
  multipath: check_path_valid(): eliminate some failure modes
  libmultipath: alias: static const variable for BINDINGS_FILE_HEADER
  libmultipath: add consistency check for alias settings
  libmultipath: alias.c: use strtok_r() instead of strtok()
  libmultipath: adopt_paths(): set pp->mpp only on success
  libmultipath: fix a -Wformat-truncation warning from gcc 10

Zhiqiang Liu (1):
  libmultipath: free pp if store_path fails in disassemble_map

 libmultipath/alias.c       | 294 +++++++++++++++++++++++++++++++++++--
 libmultipath/alias.h       |  15 +-
 libmultipath/dmparser.c    |  12 +-
 libmultipath/structs_vec.c |  15 +-
 libmultipath/util.c        |   6 +-
 multipath/main.c           |  21 +--
 multipathd/main.c          |   3 +
 7 files changed, 327 insertions(+), 39 deletions(-)

-- 
2.28.0
