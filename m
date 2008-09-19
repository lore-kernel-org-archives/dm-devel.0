From: Ryo Tsuruta <ryov@valinux.co.jp>
Subject: [PATCH 0/5] bio-cgroup: Introduction
Date: Fri, 19 Sep 2008 20:01:07 +0900 (JST)
Message-ID: <20080919.200107.193703747.ryov@valinux.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1753886AbYISLBU@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, dm-devel@redhat.com, containers@lists.linux-foundation.org, virtualization@lists.linux-foundation.org, xen-devel@lists.xensource.com
Cc: fernando@oss.ntt.co.jp, balbir@linux.vnet.ibm.com, xemul@openvz.org, agk@sourceware.org
List-Id: dm-devel.ids

Hi everyone,

Here are new releases of bio-cgroup.
Changes from the previous version are as follows:

- Accurate dirty-page tracking
  Support migrating pages between bio-cgroups with minimum overhead,
  but I think such a situation is quite rare.

- Fix a bug of swapcache page handling
  Sometimes, "bad page state" is occurred since the memory controller
  has temporarily changed the swapcache page handling.

The following is the list of patches:

  [PATCH 0/5] bio-cgroup: Introduction
  [PATCH 1/5] bio-cgroup: Split the cgroup memory subsystem into two parts
  [PATCH 2/5] bio-cgroup: Remove a lot of "#ifdef"s
  [PATCH 3/5] bio-cgroup: Implement the bio-cgroup
  [PATCH 4/5] bio-cgroup: Add a cgroup support to dm-ioband
  [PATCH 5/5] bio-cgroup: Dirty page tracking

You have to apply the patch dm-ioband v1.5.0 before applying this
series of patches. The dm-ioband patch can be found at:
http://people.valinux.co.jp/~ryov/dm-ioband/

And you have to select the following config options when compiling kernel:
  CONFIG_CGROUPS=y
  CONFIG_CGROUP_BIO=y
And I recommend you should also select the options for cgroup memory
subsystem, because it makes it possible to give some I/O bandwidth
and some memory to a certain cgroup to control delayed write requests
and the processes in the cgroup will be able to make pages dirty only
inside the cgroup even when the given bandwidth is narrow.
  CONFIG_RESOURCE_COUNTERS=y
  CONFIG_CGROUP_MEM_RES_CTLR=y

Please see the following site for more information:
http://people.valinux.co.jp/~ryov/bio-cgroup/

 --------------------------------------------------------

The following shows how to use dm-ioband with cgroups.
Please assume that you want make two cgroups, which we call "bio cgroup"
here, to track down block I/Os and assign them to ioband device "ioband1".

First, mount the bio cgroup filesystem.

 # mount -t cgroup -o bio none /cgroup/bio

Then, make new bio cgroups and put some processes in them.

 # mkdir /cgroup/bio/bgroup1
 # mkdir /cgroup/bio/bgroup2
 # echo 1234 > /cgroup/bio/bgroup1/tasks
 # echo 5678 > /cgroup/bio/bgroup1/tasks

Now, check the ID of each bio cgroup which is just created.

 # cat /cgroup/bio/bgroup1/bio.id
   1
 # cat /cgroup/bio/bgroup2/bio.id
   2

Finally, attach the cgroups to "ioband1" and assign them weights.

 # dmsetup message ioband1 0 type cgroup
 # dmsetup message ioband1 0 attach 1
 # dmsetup message ioband1 0 attach 2
 # dmsetup message ioband1 0 weight 1:30
 # dmsetup message ioband1 0 weight 2:60

You can also make use of the dm-ioband administration tool if you want.
The tool will be found here:
http://people.valinux.co.jp/~kaizuka/dm-ioband/iobandctl/manual.html
You can set up the device with the tool as follows.
In this case, you don't need to know the IDs of the cgroups.

 # iobandctl.py group /dev/mapper/ioband1 cgroup /cgroup/bio/bgroup1:30 /cgroup/bio/bgroup2:60

Thanks,
Ryo Tsuruta
