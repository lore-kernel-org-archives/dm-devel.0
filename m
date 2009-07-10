From: Takahiro Yasui <tyasui@redhat.com>
Subject: Re: [RFC][PATCH] dm-mirror: fix data corruption
Date: Fri, 10 Jul 2009 15:14:40 -0400
Message-ID: <4A579320.1040709@redhat.com>
References: <4A568333.6090901@redhat.com> <4A572313.1050402@ce.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4A572313.1050402@ce.jp.nec.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: j-nomura@ce.jp.nec.com
Cc: device-mapper development <dm-devel@redhat.com>, Mikulas Patocka <mpatocka@redhat.com>, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

Hi Nomura-san,

On 07/10/09 07:16, Jun'ichi Nomura wrote:
> Hi Yasui-san,
> 
> Takahiro Yasui wrote:
>> This is a prototype patch to fix data corruption issue on dm-raid1.
>> It is just a draft patch and is not tested well, but let me post it
>> to review and discuss this in-kernel superblock approach.
>>
>> I appreciate your comments and suggestions.
> <snip>
>>   * Introduce superblock area
>>
>>     A superblock area is related to a mirror leg on a one-to-one basis and
>>     keeps a sequential number to decide the default mirror when the mirror
>>     is resumed.
> 
> If you are to introduce kernel-managed RAID1 superblock,
> isn't it possible to use the on-disk format compatible to md's?
> Then the kernel code to handle the superblock may be shared between
> md and dm in future, which I think is even better and would help
> dm/md convergence.

Thank you for the comment. You are right and sharing the kernel code to
handle superblock between md and dm would be better toward merging dm/md.
I would like to introduce this in-kernel superblock approach, but userspace
approach handled by dmeventd seems to be preferred. I try to check the
possibility to reduce overhead of error handling in userspace.

Thanks,
Taka
