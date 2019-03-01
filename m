From: Nikos Tsironis <ntsironis@arrikto.com>
Subject: Re: [PATCH 3/3] dm snapshot: Use fine-grained locking
 scheme
Date: Fri, 1 Mar 2019 11:15:57 +0200
Message-ID: <56d004f3-7a12-95c5-0781-0ba8353f81b3@arrikto.com>
References: <20181220180651.4879-1-ntsironis@arrikto.com>
	<20181220180651.4879-4-ntsironis@arrikto.com>
	<alpine.LRH.2.02.1902281628500.28557@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <alpine.LRH.2.02.1902281628500.28557@file01.intranet.prod.int.rdu2.redhat.com>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: dm-devel@redhat.com, snitzer@redhat.com, agk@redhat.com, iliastsi@arrikto.com
List-Id: dm-devel.ids

On 2/28/19 11:37 PM, Mikulas Patocka wrote:
> Hi
> 
> I looked at the patches, and they could be merged into the kernel 5.2.
> 
> Please, split this last patch - it is too big and too hard to understand.
> 
> For example, you can split it into three patches:
> [PATCH 3/5] replace mutex with rm_semaphore (basically a revert of 
> 	ae1093be5a0ef997833e200a0dafb9ed0b1ff4fe)
> [PATCH 4/5] replace normal lists with locked lists (but still leave the 
> 	global lock)
> [PATCH 5/5] change down_write to down_read and the rest of the changes
> 
> ... so that the resulting file is the same.

Hi Mikulas,

Thanks for your feedback. I will split the third patch as you requested
and I will send a second version of these patches.

Thanks,
Nikos
