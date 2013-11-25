From: Akira Hayakawa <ruby.wktk@gmail.com>
Subject: [Question] dm-cache table
Date: Mon, 25 Nov 2013 19:54:39 +0900
Message-ID: <52932C6F.5000306@gmail.com>
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

Hi,

dm-cache saves the ctr args in .ctr (copy_ctr_copy)
and uses it to make table. 

        case STATUSTYPE_TABLE:
                format_dev_t(buf, cache->metadata_dev->bdev->bd_dev);
                DMEMIT("%s ", buf);
                format_dev_t(buf, cache->cache_dev->bdev->bd_dev);
                DMEMIT("%s ", buf);
                format_dev_t(buf, cache->origin_dev->bdev->bd_dev);
                DMEMIT("%s", buf);

                for (i = 0; i < cache->nr_ctr_args - 1; i++)
                        DMEMIT(" %s", cache->ctr_args[i]);
                if (cache->nr_ctr_args)
                        DMEMIT(" %s", cache->ctr_args[cache->nr_ctr_args - 1]);
        }

If it accepted migrate_threshold in .ctr and the parameter
changed later. The actual value and what is seen in table
become inconsistent right? Is this intentionally designed?

If table is just the copy of the ctr args,
why don't we implement it in dm framework?

Akira
