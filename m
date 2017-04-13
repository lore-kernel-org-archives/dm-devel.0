From: Eric Ren <zren@suse.com>
Subject: [Report] crash tool cannot resolve struct dm_table
	properly
Date: Thu, 13 Apr 2017 10:01:58 +0800
Message-ID: <ed7ae3a8-f053-fb4b-8523-c09b8c725ed9@suse.com>
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
To: device-mapper development <dm-devel@redhat.com>, Mikulas Patocka <mpatocka@redhat.com>
List-Id: dm-devel.ids

Hi Mikulas,

When inspecting on coredump with crash tool, I find that 'dm_table' cannot be resolved 
properly as follows:

===
crash> struct dm_table
struct dm_table {
     int undefined__;
}
SIZE: 4
===

Looks this issue is introduced by 83d5e5b (dm: optimize use SRCU and RCU) with this code:
===
+/*
+ * A dummy definition to make RCU happy.
+ * struct dm_table should never be dereferenced in this file.
  + */ +struct dm_table {
+ int undefined__;
+};
+
===

It stops me from looking into dm_table when analyzing coredump. Is there any workaround?
or can be fixed somehow?

Regards,
Eric
