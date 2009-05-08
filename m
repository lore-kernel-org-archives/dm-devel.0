From: Rik van Riel <riel@redhat.com>
Subject: Re: IO scheduler based IO Controller V2
Date: Fri, 08 May 2009 10:24:50 -0400
Message-ID: <4A0440B2.7040300@redhat.com>
References: <1241553525-28095-1-git-send-email-vgoyal@redhat.com>	<20090505132441.1705bfad.akpm@linux-foundation.org>	<20090506023332.GA1212@redhat.com> <20090507.091858.226775723.ryov@valinux.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1759207AbZEHOaJ@vger.kernel.org>
In-Reply-To: <20090507.091858.226775723.ryov@valinux.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
To: Ryo Tsuruta <ryov@valinux.co.jp>
Cc: vgoyal@redhat.com, akpm@linux-foundation.org, nauman@google.com, dpshah@google.com, lizf@cn.fujitsu.com, mikew@google.com, fchecconi@gmail.com, paolo.valente@unimore.it, jens.axboe@oracle.com, fernando@oss.ntt.co.jp, s-uchida@ap.jp.nec.com, taka@valinux.co.jp, guijianfeng@cn.fujitsu.com, jmoyer@redhat.com, dhaval@linux.vnet.ibm.com, balbir@linux.vnet.ibm.com, linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org, righi.andrea@gmail.com, agk@redhat.com, dm-devel@redhat.com, snitzer@redhat.com, m-ikeda@ds.jp.nec.com, peterz@infradead.org
List-Id: dm-devel.ids

Ryo Tsuruta wrote:
> Hi Vivek,
> 
>> Ryo, dm-ioband breaks the notion of classes and priority of CFQ because
>> of FIFO dispatch of buffered bios. Apart from that it tries to provide
>> fairness in terms of actual IO done and that would mean a seeky workload
>> will can use disk for much longer to get equivalent IO done and slow down
>> other applications. Implementing IO controller at IO scheduler level gives
>> us tigher control. Will it not meet your requirements? If you got specific
>> concerns with IO scheduler based contol patches, please highlight these and
>> we will see how these can be addressed.
> 
> I'd like to avoid making complicated existing IO schedulers and other
> kernel codes and to give a choice to users whether or not to use it.
> I know that you chose an approach that using compile time options to
> get the same behavior as old system, but device-mapper drivers can be
> added, removed and replaced while system is running.

I do not believe that every use of cgroups will end up with
a separate logical volume for each group.

In fact, if you look at group-per-UID usage, which could be
quite common on shared web servers and shell servers, I would
expect all the groups to share the same filesystem.

I do not believe dm-ioband would be useful in that configuration,
while the IO scheduler based IO controller will just work.

-- 
All rights reversed.
