From: Martin Wilck <mwilck@suse.com>
Subject: Recent multipath-tools patches from Huawei
Date: Mon, 10 Aug 2020 16:34:42 +0200
Message-ID: <140e431094a118a5276f6964921cc120bda2dc49.camel@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
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
To: Zhiqiang Liu <liuzhiqiang26@huawei.com>, linfeilong@huawei.com, Yanxiaodan <yanxiaodan@huawei.com>, lixiaokeng <lixiaokeng@huawei.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Hi Liu,

thanks again for your valuable contributions and meticulous code
review. I've added your patches in my upstream-queue branch now:

https://github.com/openSUSE/multipath-tools/commits/upstream-queue

Not applied yet: 

 - libmultipath: free pp if store_path fails in disassemble_map:
   As noted before, this will be merged with my series for
   disassemble_map().
 - libmultipath: fix a memory leak in set_ble_device:
   Please fix minor issues I mentioned
 - vector: return null when realloc fails in vector_alloc_slot func
   Needs improvement

Please double-check if I've missed anything. 

Next time, please send your patches as a series. That makes it
much easier for others to make sure they don't miss any.
And please, don't add "[dm-devel]" explicitly in your email
subject, mailman will take care of that.

Regards
Martin
