From: Rik van Riel <riel@redhat.com>
Subject: Re: Regarding dm-ioband tests
Date: Tue, 15 Sep 2009 11:58:07 -0400
Message-ID: <4AAFB98F.80201@redhat.com>
References: <20090909105122.GF8828@linux.vnet.ibm.com>
	<20090910.165849.104059407.ryov@valinux.co.jp>
	<20090911095347.GD4474@linux.vnet.ibm.com>
	<20090916.001237.226784704.ryov@valinux.co.jp>
	<20090915151952.GH4846@balbir.in.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20090915151952.GH4846@balbir.in.ibm.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: balbir@linux.vnet.ibm.com
Cc: dhaval@linux.vnet.ibm.com, guijianfeng@cn.fujitsu.com, linux-kernel@vger.kernel.org, jmoyer@redhat.com, dm-devel@redhat.com, nauman@google.com, agk@redhat.com, jens.axboe@oracle.com, akpm@linux-foundation.org, vgoyal@redhat.com
List-Id: dm-devel.ids

Balbir Singh wrote:
> * Ryo Tsuruta <ryov@valinux.co.jp> [2009-09-16 00:12:37]:

>> Why it is so bad to have multiple ways to configure? I think that it
>> rather gains in flexibility of configurations.
>>
> 
> The main issue I see is user confusion and distro issues. If a distro
> compiles cgroups and dmsetup provides both methods, what method
> do we recommend to end users? Also should system management tool
> support two configuration mechanisms for the same functionality?

It gets worse.

If the distro sets up things via cgroups and the admin tries
to use dmsetup - how does the configuration propagate between
the two mechanisms?

The sysadmin would expect that any changes made via dmsetup
will become visible via the config tools (that use cgroups),
too.

This will quickly increase the code requirements to ridiculous
proportions - or leave sysadmins confused and annoyed.

Neither is a good option, IMHO.

-- 
All rights reversed.
