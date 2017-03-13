From: Ivan Zahariev <famzah@icdsoft.com>
Subject: LVM gives "modprobe" errors on non-modular monolithic
	Linux kernels
Date: Mon, 13 Mar 2017 14:15:38 +0200
Message-ID: <1cc4879f-a9a6-dd4c-c430-2a4dc3652e62@icdsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
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

Hello,

Here is an example of the problem:

    # lvconvert --yes --type cache --cachepolicy smq --cachepool
    vg0/lv_cache_s188-vp vg0/s188

    modprobe: ERROR: ../libkmod/libkmod.c:557 kmod_search_moddep() could
    not open moddep file '/lib/modules/4.4.30-grsec/modules.dep.bin'
       /sbin/modprobe failed: 1


Strace shows that "lvconvert" calls "modprobe" because it can't find 
some paths in "/sys/module":

  * /sys/module/dm_cache_smq
  * /sys/module/dm_cache_mq


At the same time, these modules are already in the kernel. Here is a proof:

    root@sm-srv228:~# zgrep -i cache /proc/config.gz |grep -i dm
    CONFIG_DM_CACHE=y
    CONFIG_DM_CACHE_MQ=y
    CONFIG_DM_CACHE_SMQ=y
    CONFIG_DM_CACHE_CLEANER=y


So the real problem is that the modules are compiled in the monolithic 
kernel but are not seen in "/sys/module". At the same time, even with a 
monolithic kernel, some modules do have their corresponding directories 
in "/sys/module", like the "dm_cache" module, for example:

    root@sm-srv228:~# find /sys/module/dm_cache -type f
    /sys/module/dm_cache/parameters/cache_copy_throttle


My naive research concluded that non-modular monolithic Linux kernels 
export the compiled-in modules in "/sys/module" only if one of the 
following is true:

  * the kernel module exports any parameters in the
    "/sys/module/$module/parameters" directory
  * or the kernel module has a "version" file "/sys/module/$module/version"


In a nutshell, please export a "version" of all "dm_cache_*" modules, so 
that even in monolithic Linux kernels we can have a directory in 
"/sys/module" for them. This way the LVM2 tools won't give out sporadic 
"modprobe" errors when ran on monolithic Linux kernels.

Does all this make sense? Is the patch something trivial which we can 
backport into our custom 4.4.30 Linux kernel?

Thanks.
--Ivan
