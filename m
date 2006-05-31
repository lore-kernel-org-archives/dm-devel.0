From: "Harik A'ttar" <harik@chaos.ao.net>
Subject: Re: mirroring
Date: Wed, 31 May 2006 19:15:55 -0400
Message-ID: <447E23AB.1030408@chaos.ao.net>
References: <dc915e7688b9d1184493c7f81c5ca330@redhat.com>
	<200605181256.31974.jw0_lists@headissue.com>
Reply-To: LVM general discussion and development <linux-lvm@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-lvm-bounces@redhat.com>
In-Reply-To: <200605181256.31974.jw0_lists@headissue.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/linux-lvm>,
	<mailto:linux-lvm-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/linux-lvm>
List-Post: <mailto:linux-lvm@redhat.com>
List-Help: <mailto:linux-lvm-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/linux-lvm>,
	<mailto:linux-lvm-request@redhat.com?subject=subscribe>
Sender: linux-lvm-bounces@redhat.com
Errors-To: linux-lvm-bounces@redhat.com
To: LVM general discussion and development <linux-lvm@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Jens Wilke wrote:
> On Thursday 18 May 2006 10:05, Jonathan E Brassow wrote:
>> I think most of the device-mapper and LVM2 patches for mirroring have
>> been put into CVS.  device-mapper kernel patches for various kernels
>> can be found at https://www.brassow.com/mirroring.
> 
> It's working better without https ;)
> 
> http://www.brassow.com/mirroring

Wow, that's rather a mess.

diff --git a/Makefile b/Makefile
index cb57905..b93f75f 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
  VERSION = 2
  PATCHLEVEL = 6
  SUBLEVEL = 16
-EXTRAVERSION =
+EXTRAVERSION = .16
  NAME=Sliding Snow Leopard

  # *DOCUMENTATION*

You've merged the 2.6.16.16 patch with the mirroring patch.   Can you 
redo the patch from the same versions?

_______________________________________________
linux-lvm mailing list
linux-lvm@redhat.com
https://www.redhat.com/mailman/listinfo/linux-lvm
read the LVM HOW-TO at http://tldp.org/HOWTO/LVM-HOWTO/
