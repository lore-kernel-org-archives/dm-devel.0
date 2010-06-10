From: "Patrick J. LoPresti" <lopresti@gmail.com>
Subject: [PATCH] Fix kernel NULL pointer dereference in dm-mpath.c
Date: Thu, 10 Jun 2010 12:33:05 -0700
Message-ID: <AANLkTilQx3qv6HIi83nYIoC9QRvgS4lJiC42UlcanhSs@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: dm-devel@redhat.com, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: dm-devel.ids

I discovered this when I accidentally put the following in my
/etc/multipath.conf file:

      path_selector least_pending

...instead of this:

    path_selector "least_pending 0"

To my surprise, this resulted in a NULL pointer dereference in the
kernel.  The bug (and fix) is trivial:

--- linux/drivers/md/dm-mpath.c 2010-05-20 03:06:58.000000000 -0700
+++ linux-patl/drivers/md/dm-mpath.c    2010-06-10 12:22:49.000000000 -0700
@@ -736,12 +736,13 @@
        for (i = 0; i < pg->nr_pgpaths; i++) {
                struct pgpath *pgpath;
                struct arg_set path_args;

                if (as->argc < nr_params) {
                        ti->error = "not enough path parameters";
+                       r = -EINVAL;
                        goto bad;
                }

                path_args.argc = nr_params;
                path_args.argv = as->argv;

Without this patch, the parse_priority_group function can return 0,
which the caller (multipath_ctr()) immediately dereferences.  Bang!

I have confirmed that this bug still exists in 2.6.32.9 and 2.6.35-rc2.

 - Pat

P.S.  Are the Coverity folks still running the kernel through their
tool?  This seems like the sort of thing it would catch.
