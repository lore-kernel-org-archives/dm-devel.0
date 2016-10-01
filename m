From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 0/9] md/dm-table: Fine-tuning for several function
 implementations
Date: Sat, 1 Oct 2016 09:41:03 +0200
Message-ID: <45984567-4421-5f8d-ddf3-eb2a769a1860@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <kernel-janitors-owner@vger.kernel.org>
Sender: kernel-janitors-owner@vger.kernel.org
To: dm-devel@redhat.com, linux-raid@vger.kernel.org, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, Shaohua Li <shli@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org, Julia Lawall <julia.lawall@lip6.fr>
List-Id: dm-devel.ids

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sat, 1 Oct 2016 09:35:43 +0200

Some update suggestions were taken into account
from static source code analysis.

Markus Elfring (9):
  Use kmalloc_array() in realloc_argv()
  Reduce the scope for a variable in dm_table_verify_integrity()
  Delete an unnecessary variable initialisation in dm_table_register_integrity()
  Delete an unnecessary variable initialisation in dm_split_args()
  Move an assignment for the variable "end" in dm_split_args()
  Combine substrings for ten messages
  Adjust one function call together with a variable assignment
  Delete an unwanted space in high()
  Delete an unwanted space in dm_table_get_integrity_disk()

 drivers/md/dm-table.c | 51 ++++++++++++++++++++-------------------------------
 1 file changed, 20 insertions(+), 31 deletions(-)

-- 
2.10.0

