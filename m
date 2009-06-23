From: Charlie Brady <charlieb-dm-devel@budge.apana.org.au>
Subject: RDAC path checker status change messages
Date: Tue, 23 Jun 2009 15:50:13 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0906231548060.18687@e-smith.charlieb.ott.istop.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids


It seems to me that this patch is required, to fix a problem with "path 
down" messages being logged when the path transitions to up (and 
presumably ghost).

--- libcheckers/rdac.c.orig     2009-06-23 15:38:05.371422000 -0400
+++ libcheckers/rdac.c  2009-06-23 15:39:28.020843000 -0400
@@ -105,5 +105,12 @@
                 return PATH_DOWN;
         }

-       return ((inq.avtcvp & 0x1) ? PATH_UP : PATH_GHOST);
+       if (inq.avtcvp & 0x1) {
+               MSG(c, MSG_RDAC_UP);
+               return PATH_UP;
+       }
+       else {
+               MSG(c, MSG_RDAC_GHOST);
+               return PATH_GHOST;
+       }
  }
