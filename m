From: mwilck@suse.com
Subject: [PATCH v2 00/84] multipath-tools series part VII:
	addional patches
Date: Wed, 12 Aug 2020 13:35:57 +0200
Message-ID: <20200812113601.26658-1-mwilck@suse.com>
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

This is part VI of a larger patch series for multipath-tools I've been preparing.
It's based on the previously submitted part VI.

The full series will also be available here:
https://github.com/mwilck/multipath-tools/tree/ups/submit-2008
This part is tagged "submit-200812-7".

This part contains patches added since the v1 submission of the series. One
is Liu's fix for disassemble_map(), rebased on top of my previous changes
to that function.

84/84, related to inconsistent alias settings, belongs logically to part III.
I couldn't add it there because it would have changed the numbering in the
series wrt v1, which I wanted to avoid.

Martin Wilck (3):
  multipath: check_path_valid(): eliminate some failure modes
  libmultipath: alias: static const variable for BINDINGS_FILE_HEADER
  libmultipath: add consistency check for alias settings

Zhiqiang Liu (1):
  libmultipath: free pp if store_path fails in disassemble_map

 libmultipath/alias.c    | 274 +++++++++++++++++++++++++++++++++++++++-
 libmultipath/alias.h    |  15 +--
 libmultipath/dmparser.c |  12 +-
 multipath/main.c        |  21 +--
 multipathd/main.c       |   3 +
 5 files changed, 301 insertions(+), 24 deletions(-)

-- 
2.28.0
