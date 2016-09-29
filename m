From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 00/10] dm snapshot: Fine-tuning for several function
 implementations
Date: Thu, 29 Sep 2016 11:02:56 +0200
Message-ID: <080668d9-1e1e-e208-f9ea-ff718e8070e5@users.sourceforge.net>
References: <566ABCD9.1060404@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <566ABCD9.1060404@users.sourceforge.net>
Sender: linux-raid-owner@vger.kernel.org
To: dm-devel@redhat.com, linux-raid@vger.kernel.org, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, Shaohua Li <shli@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org, Julia Lawall <julia.lawall@lip6.fr>
List-Id: dm-devel.ids

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Thu, 29 Sep 2016 10:35:43 +0200

Some update suggestions were taken into account
from static source code analysis.

Markus Elfring (10):
  Use kmalloc_array() in init_origin_hash()
  Delete two error messages for a failed memory allocation
  Delete an unnecessary variable initialisation in snapshot_map()
  Rename a jump label in pending_complete()
  Delete unnecessary variable initialisations in pending_complete()
  Delete an unnecessary variable initialisation in snapshot_ctr()
  Delete an unnecessary variable initialisation in merge_callback()
  Delete an unnecessary variable initialisation in remove_single_exception_chunk()
  Combine substrings for seven error messages
  Delete five unwanted spaces behind "list_for_each_entry"

 drivers/md/dm-snap.c | 69 +++++++++++++++++++++++-----------------------------
 1 file changed, 30 insertions(+), 39 deletions(-)

-- 
2.10.0

