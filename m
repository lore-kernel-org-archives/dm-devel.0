From: christophe varoqui <christophe.varoqui@free.fr>
Subject: Re: multipathd.init
Date: Sun, 03 Apr 2005 21:59:13 +0200
Message-ID: <1112558353.8118.67.camel@zezette>
References: <20050401204048.GI14307@agk.surrey.redhat.com>
	<1112389744.8118.26.camel@zezette>
	<20050401211902.GL14307@agk.surrey.redhat.com>
	<1112390705.8118.34.camel@zezette> <1112521418.8118.49.camel@zezette>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1112521418.8118.49.camel@zezette>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids


> 
> What needs to be done to have libdevmapper and libsysfs packages include
> their respective klibc build version ? What about klibc shared objects
> vs static ?
> 

As a kick-off, here is a little clean up patch.
I guess it's harmless anyway.

diff -ur devmapper-1.01.00/lib/libdm-file.c
devmapper-1.01.00.klibcbuild/lib/libdm-file.c
--- devmapper-1.01.00/lib/libdm-file.c  2005-01-06 19:22:44.000000000
+0100
+++ devmapper-1.01.00.klibcbuild/lib/libdm-file.c       2005-04-03
21:26:13.000000000 +0200
@@ -16,7 +16,6 @@
 #include "lib.h"
 #include "libdm-file.h"
 -#include <sys/file.h>
 #include <fcntl.h>
 #include <dirent.h>
 #include <malloc.h>

-- 
christophe varoqui <christophe.varoqui@free.fr>
