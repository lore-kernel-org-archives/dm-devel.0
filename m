From: shenghui <shhuiw@foxmail.com>
Subject: How to understand dm-writecache/memory_entry
Date: Sun, 21 Oct 2018 21:18:27 +0800
Message-ID: <2577.9046970003$1540204360@news.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
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
To: Mikulas Patocka <dm-devel@redhat.com>
List-Id: dm-devel.ids

Hi Mikulas,

Sorry to trouble you again.

I'm reading the source code of dm-writecache, and noticed:
-----------------------------------------------------
static struct wc_memory_entry *memory_entry(struct dm_writecache *wc, struct wc_entry *e)
{
	if (is_power_of_2(sizeof(struct wc_entry)) && 0)    // why this?
		return &sb(wc)->entries[e - wc->entries];
	else
		return &sb(wc)->entries[e->index];
}

Seems there is something wrong with the if condition, right?

Thanks,
shenghui
