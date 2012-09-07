From: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 0/2] Avoid deadlocks with bio allocation
Date: Fri,  7 Sep 2012 15:12:51 -0700
Message-ID: <1347055973-11581-1-git-send-email-koverstreet@google.com>
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org
List-Id: dm-devel.ids

These patches were part of the block cleanups series I just sent out, but I
split them off. Nothing's changed with them lately, the last thing I added was
a bit of logic to the "punt to rescue" code to only punt bios that were
allocated from the current bio_set.

Kent Overstreet (2):
  block: Reorder struct bio_set
  block: Avoid deadlocks with bio allocation by stacking drivers

 fs/bio.c            | 87 +++++++++++++++++++++++++++++++++++++++++++++++++++--
 include/linux/bio.h | 75 +++++++++++++++++++++++++--------------------
 2 files changed, 126 insertions(+), 36 deletions(-)

-- 
1.7.12
