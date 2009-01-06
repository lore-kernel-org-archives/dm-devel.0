From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: dm-table-rework-reference-counting.patch
Date: Tue, 06 Jan 2009 16:16:50 +0900
Message-ID: <49630562.3090107@ct.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Alasdair G Kergon <agk@redhat.com>, Mikulas Patocka <mpatocka@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Hi Alasdair, Mikulas,

Although I'm not sure this is correct, don't we need to convert
the following 2 dm_table_put()s to dm_table_destroy()?
Otherwise, the created table won't be destroyed and memory leak
will happen in such error cases?

drivers/md/dm-ioctl.c:table_load()
1060         r = dm_table_create(&t, get_mode(param), param->target_count, md);
1061         if (r)
1062                 goto out;
1063 
1064         r = populate_table(t, param, param_size);
1065         if (r) {
1066                 dm_table_put(t);
1067                 goto out;
1068         }
1069 
1070         down_write(&_hash_lock);
1071         hc = dm_get_mdptr(md);
1072         if (!hc || hc->md != md) {
1073                 DMWARN("device has been removed from the dev hash table.");
1074                 dm_table_put(t);
1075                 up_write(&_hash_lock);
1076                 r = -ENXIO;
1077                 goto out;
1078         }

Thanks,
Kiyoshi Ueda
