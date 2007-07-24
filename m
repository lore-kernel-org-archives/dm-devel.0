From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: dm: device mapper code cleanup.
Date: Tue, 24 Jul 2007 12:51:06 +0400
Message-ID: <20070724085106.GD20538@dnb.sw.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1764584AbXGXIuw@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

I've prepared patch-set which i hope makes dm code safer and better :)
- First tree patches fix various leaks.
- Last five patches just convert kmalloc + memset couple to single kzalloc
   (probably it should be folded to one commit).
