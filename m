From: Kent Overstreet <koverstreet@google.com>
Subject: [Bcache v13 05/16] Export get_random_int()
Date: Wed, 9 May 2012 23:09:13 -0400
Message-ID: <5278ad493eb3ad441b2091b4c119d741e47f5c97.1336619038.git.koverstreet@google.com>
References: <cover.1336619038.git.koverstreet@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <cover.1336619038.git.koverstreet@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org, dm-devel@redhat.com
Cc: tejun@google.com, agk@redhat.com
List-Id: dm-devel.ids

This is needed for bcache - it needs a fast source of random numbers for
the throttling code in order to fuzz IO sizes, but the random numbers
don't need to be any good (and it immediately converts it to a
binomially distributed random number with popcount anyways).

Signed-off-by: Kent Overstreet <koverstreet@google.com>
---
 drivers/char/random.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index 54ca8b2..ec4dd79 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -1357,6 +1357,7 @@ unsigned int get_random_int(void)
 
 	return ret;
 }
+EXPORT_SYMBOL(get_random_int);
 
 /*
  * randomize_range() returns a start address such that
-- 
1.7.9.rc2
