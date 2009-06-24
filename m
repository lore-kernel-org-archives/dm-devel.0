From: Paul Menage <menage@google.com>
Subject: Re: [PATCH 18/20] io-controller: Support per cgroup per device
	weights and io class
Date: Wed, 24 Jun 2009 14:52:19 -0700
Message-ID: <6599ad830906241452t76e64815s7d68a22a6e746a59@mail.gmail.com>
References: <1245443858-8487-1-git-send-email-vgoyal@redhat.com>
	 <1245443858-8487-19-git-send-email-vgoyal@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1753607AbZFXVwj@vger.kernel.org>
In-Reply-To: <1245443858-8487-19-git-send-email-vgoyal@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org, dm-devel@redhat.com, jens.axboe@oracle.com, nauman@google.com, dpshah@google.com, lizf@cn.fujitsu.com, mikew@google.com, fchecconi@gmail.com, paolo.valente@unimore.it, ryov@valinux.co.jp, fernando@oss.ntt.co.jp, s-uchida@ap.jp.nec.com, taka@valinux.co.jp, guijianfeng@cn.fujitsu.com, jmoyer@redhat.com, dhaval@linux.vnet.ibm.com, balbir@linux.vnet.ibm.com, righi.andrea@gmail.com, m-ikeda@ds.jp.nec.com, jbaron@redhat.com, agk@redhat.com, snitzer@redhat.com, akpm@linux-foundation.org, peterz@infradead.org
List-Id: dm-devel.ids

On Fri, Jun 19, 2009 at 1:37 PM, Vivek Goyal<vgoyal@redhat.com> wrote:
>
> You can use the following format to play with the new interface.
> #echo DEV:weight:ioprio_class > /patch/to/cgroup/policy
> weight=0 means removing the policy for DEV.
>
> Examples:
> Configure weight=300 ioprio_class=2 on /dev/hdb in this cgroup
> # echo /dev/hdb:300:2 > io.policy
> # cat io.policy
> dev weight class
> /dev/hdb 300 2

I think that the read and write should be consistent. Can you just use
white-space separation for both, rather than colon-separation for
writes and white-space separation for reads?

Also, storing device inode paths statically as strings into the
io_policy structure seems wrong, since it's quite possible for the
device node that was used originally to be gone by the time that
someone reads the io.policy file, or renamed, or even replaced with an
inode that refers to to a different block device

My preferred alternatives would be:

- read/write the value as a device number rather than a name
- read/write the block device's actual name (e.g. hda or sda) rather
than a path to the inode

Paul
