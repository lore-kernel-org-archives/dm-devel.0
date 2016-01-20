From: Eric Wheeler <dm-devel@lists.ewheeler.net>
Subject: How can I get my sector size (via queue_limits?) from a
	dm_target?
Date: Tue, 19 Jan 2016 19:32:35 -0800 (PST)
Message-ID: <alpine.LRH.2.11.1601191922570.22808@mail.ewheeler.net>
Reply-To: device-mapper development <dm-devel@redhat.com>
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
To: dm-devel@redhat.com
List-Id: dm-devel.ids

Hello all,

dm_target->len gives me sector count, but I need to know the default 
sector size discovered by the blk stacking code without assuming 512b.

Now that I have the dm .iterate_devices callback defined and my 
queue_limits are sane by default, how can I get a pointer to the 
queue_limits structure for my device given a dm_target structure?

It looks like I should call dm_get_md_queue() after getting the md from 
dm_table_get_md(target->table), but dm_get_md_queue is not an exported 
symbol.

Also, is that value correct within the .ctr, or only after the .ctr 
returns?  If after, how can I hook in after limits are assigned but before 
.map gets called?  Otherwise stated, I would like to know the stacked 
queue_limits corrected for lower layers within the .ctr function.

Thanks for your help!

-Eric
