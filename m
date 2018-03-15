From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [bug report] dm: add statistics support
Date: Thu, 15 Mar 2018 17:25:32 +0300
Message-ID: <20180315142532.GA29284@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: mpatocka@redhat.com
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

[ This code is half a decade old so probably removing the dead code is
  fine?  - dan ]

Hello Mikulas Patocka,

The patch fd2ed4d25270: "dm: add statistics support" from Aug 16,
2013, leads to the following static checker warning:

	drivers/md/dm-stats.c:371 dm_stats_create()
	warn: dead code because of 's->id == ((~0 >> 1))' and 'tmp_s->id < s->id'

drivers/md/dm-stats.c
   361          mutex_lock(&stats->mutex);
   362          s->id = 0;
   363          list_for_each(l, &stats->list) {
   364                  tmp_s = container_of(l, struct dm_stat, list_entry);
   365                  if (WARN_ON(tmp_s->id < s->id)) {
                                    ^^^^^^^^^^^^^^^^^
This condition means that s->id can't be INT_MAX.

   366                          r = -EINVAL;
   367                          goto out_unlock_resume;
   368                  }
   369                  if (tmp_s->id > s->id)
   370                          break;
   371                  if (unlikely(s->id == INT_MAX)) {
                                     ^^^^^^^^^^^^^^^^
So we can probably remove this dead code?  Was something else intended?

   372                          r = -ENFILE;
   373                          goto out_unlock_resume;
   374                  }
   375                  s->id++;
   376          }
   377          ret_id = s->id;
   378          list_add_tail_rcu(&s->list_entry, l);
   379          mutex_unlock(&stats->mutex);
   380  
   381          resume_callback(md);
   382  
   383          return ret_id;
   384  
   385  out_unlock_resume:
   386          mutex_unlock(&stats->mutex);
   387          resume_callback(md);
   388  out:
   389          dm_stat_free(&s->rcu_head);
   390          return r;
   391  }

regards,
dan carpenter
