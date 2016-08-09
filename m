From: Mike Christie <mchristi@redhat.com>
Subject: Re: PATCH 0/4] multipath-tools: Ceph rbd support v2
Date: Tue, 9 Aug 2016 13:26:40 -0500
Message-ID: <57AA2060.20708@redhat.com>
References: <1470657710-28081-1-git-send-email-mchristi@redhat.com>
	<CABr-Gnf1vfGOMGcP8YF2tFMy5Z2Buwp7H9iXfCzuDC-S+FE7AA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------060600050407060606070907"
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CABr-Gnf1vfGOMGcP8YF2tFMy5Z2Buwp7H9iXfCzuDC-S+FE7AA@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

This is a multi-part message in MIME format.
--------------060600050407060606070907
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit

On 08/09/2016 10:36 AM, Christophe Varoqui wrote:
> Merged.
> 

Thanks.

> I think it is worth advertizing here that the build now requires rados.h.
> 

Sorry about adding the silly dependency. How about the attached patch to
make the rbd checker only be built if the user requests it. In the
documentation for my use, I will describe how to build it. This way
majority of users will not be bothered.


> Thanks.
> 
> On Mon, Aug 8, 2016 at 2:01 PM, Mike Christie <mchristi@redhat.com> wrote:
> 
>> The following patches made over Christophe's tree today,
>> add Ceph rbd support for handling blacklisted devices.
>>
>>
>> This is not general support for rbd and multipath. There is
>> no boot/root support and it does not support features like
>> multibus. My use is for HA configurations, specifically for exporting
>> rbd images through multiple LIO instances. In this case, we have one
>> rbd instance that has the ceph rbd exclusive lock and it can send
>> WRITE requests. If that host becomes unreachable, then another host
>> will grab the lock, and blacklist the original host to prevent it from
>> sending stale IO (when blacklisted IO will be failed by the OSD).
>>
>> To recover from that type of scenario, this patchset adds a repair()
>> callout to the checker. If the path is in the PATH_DOWN state this
>> callout can be used to fix it up. For my case, I am remapping
>> the device to flush stale IO and cleanup the old lock,
>> and then unblacklisting the path, so it can be used again.
>>
>> Changes since v1:
>> - Drop ID_UID use and implemented sysfs getuid support.
>> - Drop settings that were defaults and follow template.
>> - Fix ceph auth/user.
>>
>>
> 
> 
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
> 


--------------060600050407060606070907
Content-Type: text/x-patch;
	name="0001-PATCH-checker-do-not-build-rbd-by-default.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename*0="0001-PATCH-checker-do-not-build-rbd-by-default.patch"

From 4d0bfdfc032d4fabf0ac08ba105125ded168bd95 Mon Sep 17 00:00:00 2001
From: Mike Christie <mchristi@redhat.com>
Date: Tue, 9 Aug 2016 13:19:41 -0500
Subject: [PATCH 1/1] checker: do not build rbd by default

rbd is not a common driver and users will probably not have the
tools/libs
to use it. Make the rbd checker not built by default.

Signed-off-by: Mike Christie <mchristi@redhat.com>
---
 libmultipath/checkers/Makefile | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/libmultipath/checkers/Makefile b/libmultipath/checkers/Makefile
index 5fd2099..aeb425f 100644
--- a/libmultipath/checkers/Makefile
+++ b/libmultipath/checkers/Makefile
@@ -11,8 +11,11 @@ LIBS= \
 	libcheckdirectio.so \
 	libcheckemc_clariion.so \
 	libcheckhp_sw.so \
-	libcheckrdac.so \
-	libcheckrbd.so
+	libcheckrdac.so
+
+ifneq ($(CHECKER_RBD),)
+LIBS += libcheckrbd.so
+endif
 
 CFLAGS += -I..
 
-- 
2.7.2


--------------060600050407060606070907
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--------------060600050407060606070907--
