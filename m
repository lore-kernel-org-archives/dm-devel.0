From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: CPU hotplug issue in dm-crypt driver
Date: Tue, 27 Mar 2012 15:24:21 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.1203271512520.28619@file.rdu.redhat.com>
References: <547dd161c75a98c7bcf4fb7a4d54b914.squirrel@www.codeaurora.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <547dd161c75a98c7bcf4fb7a4d54b914.squirrel@www.codeaurora.org>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
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

Hi

On Mon, 26 Mar 2012, mittals@codeaurora.org wrote:

> Hi,
> 
> We are using dm-crypt driver to encrypt Android Phone on a 2 core target.
> We saw random failures (kernel panics) in scatterwalk code when we were
> trying to bring secondary cpu online and offline randomly.
> 
> I looked into the dm-crypt driver(drivers/md/dm-crypt.c) and put a hack in
> the kcryptd_queue_crypt function to acquire hotplug lock (using
> get_online_cpus()), just before adding new work in work queue and release
> this lock (using put_online_cpus) after completing work in kcryptd_crypt
> function.
> With this i didn't see any issue during encryption.
> 
> So my questions are -
> 
> 1) Is it a know problem that there is some issue with dm-crypt driver with
> cpu hotplug?

Yes it is a known problem. Not only dm-crypt is affected, there are other 
kernel parts that can crash too, see: 
http://www.redhat.com/archives/dm-devel/2012-March/msg00035.html

> 2) If yes, then can someone suggest me a cleaner way to resolve this issue?

Another possible solution is to flush dm-crypt workqueues in an unplug 
hook. Another possible solution is to use these patches: 
http://people.redhat.com/mpatocka/patches/kernel/dm-crypt-paralelizace/current/ 
--- they add paralelization to dm-crypt and as a side effect, they remove 
the dm-crypt bug. You can actually use only the first five patches: 
dm-crypt-fix-mempool-deadlock.patch, dm-crypt-test-error.patch, 
dm-crypt-rename-pending.patch, dm-crypt-global-static-cipher-data.patch, 
dm-crypt-remove-percpu.patch.

But, as a general solution, I'd recommend to not use CPU unplug at all. 
There are other kernel parts that have the same bug as dm-crypt and it is 
not trivial to find them.

Mikulas

> Thanks in advance!
> 
> --Shashank
> 
> Sent by an employee of the Qualcomm Innovation Center, Inc.
> The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
> 
