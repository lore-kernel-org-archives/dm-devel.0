From: Randy Dunlap <rdunlap-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: [PATCH 04/13] Documentation/admin-guide: media/building: drop doubled words
Date: Fri,  3 Jul 2020 20:20:11 -0700
Message-ID: <20200704032020.21923-5-rdunlap@infradead.org>
References: <20200704032020.21923-1-rdunlap@infradead.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20200704032020.21923-1-rdunlap-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Randy Dunlap <rdunlap-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Mauro Carvalho Chehab <mchehab-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-media-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Trond Myklebust <trond.myklebust-F/q8l9xzQnoyLce1RVWEUA@public.gmane.org>, Anna Schumaker <anna.schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org>, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Srinivas Pandruvada <srinivas.pandruvada-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Len Brown <lenb-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-pm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, platform-driver-x86-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Darrick J . Wong" <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: dm-devel.ids

Drop some doubled words.

Signed-off-by: Randy Dunlap <rdunlap-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>
Cc: linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Mauro Carvalho Chehab <mchehab-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-media-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
---
 Documentation/admin-guide/media/building.rst |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- linux-next-20200701.orig/Documentation/admin-guide/media/building.rst
+++ linux-next-20200701/Documentation/admin-guide/media/building.rst
@@ -90,7 +90,7 @@ built as modules.
        Those GPU-specific drivers are selected via the ``Graphics support``
        menu, under ``Device Drivers``.
 
-       When a GPU driver supports supports HDMI CEC, it will automatically
+       When a GPU driver supports HDMI CEC, it will automatically
        enable the CEC core support at the media subsystem.
 
 Media dependencies
@@ -244,7 +244,7 @@ functionality.
    If you have an hybrid card, you may need to enable both ``Analog TV``
    and ``Digital TV`` at the menu.
 
-When using this option, the defaults for the the media support core
+When using this option, the defaults for the media support core
 functionality are usually good enough to provide the basic functionality
 for the driver. Yet, you could manually enable some desired extra (optional)
 functionality using the settings under each of the following
