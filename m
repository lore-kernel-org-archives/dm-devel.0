From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [bug report] dm zoned: per-device reclaim
Date: Fri, 5 Jun 2020 15:37:10 +0300
Message-ID: <20200605123710.GA988175@mwanda>
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
Content-Disposition: inline
To: hare@suse.de
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Hello Hannes Reinecke,

The patch a99e0ceaa832: "dm zoned: per-device reclaim" from Jun 2,
2020, leads to the following static checker warning:

	drivers/md/dm-zoned-reclaim.c:428 dmz_do_reclaim()
	error: potentially dereferencing uninitialized 'rzone'.

drivers/md/dm-zoned-reclaim.c
   364  static int dmz_do_reclaim(struct dmz_reclaim *zrc)
   365  {
   366          struct dmz_metadata *zmd = zrc->metadata;
   367          struct dm_zone *dzone;
   368          struct dm_zone *rzone;
                                ^^^^^

   369          unsigned long start;
   370          int ret;
   371  
   372          /* Get a data zone */
   373          dzone = dmz_get_zone_for_reclaim(zmd, zrc->dev_idx,
   374                                           dmz_target_idle(zrc));
   375          if (!dzone) {
   376                  DMDEBUG("(%s/%u): No zone found to reclaim",
   377                          dmz_metadata_label(zmd), zrc->dev_idx);
   378                  return -EBUSY;
   379          }
   380  
   381          start = jiffies;
   382          if (dmz_is_cache(dzone) || dmz_is_rnd(dzone)) {
   383                  if (!dmz_weight(dzone)) {
   384                          /* Empty zone */
   385                          dmz_reclaim_empty(zrc, dzone);
   386                          ret = 0;
   387                  } else {
   388                          /*
   389                           * Reclaim the random data zone by moving its
   390                           * valid data blocks to a free sequential zone.
   391                           */
   392                          ret = dmz_reclaim_rnd_data(zrc, dzone);
   393                  }
   394                  rzone = dzone;
   395  
   396          } else {
   397                  struct dm_zone *bzone = dzone->bzone;
   398                  sector_t chunk_block = 0;
   399  
   400                  ret = dmz_first_valid_block(zmd, bzone, &chunk_block);
   401                  if (ret < 0)
   402                          goto out;

"rzone" is uninitialized if "ret < 0".

   403  
   404                  if (ret == 0 || chunk_block >= dzone->wp_block) {
   405                          /*
   406                           * The buffer zone is empty or its valid blocks are
   407                           * after the data zone write pointer.
   408                           */
   409                          ret = dmz_reclaim_buf(zrc, dzone);
   410                          rzone = bzone;
   411                  } else {
   412                          /*
   413                           * Reclaim the data zone by merging it into the
   414                           * buffer zone so that the buffer zone itself can
   415                           * be later reclaimed.
   416                           */
   417                          ret = dmz_reclaim_seq_data(zrc, dzone);
   418                          rzone = dzone;
   419                  }
   420          }
   421  out:
   422          if (ret) {
   423                  if (ret == -EINTR)
   424                          DMDEBUG("(%s/%u): reclaim zone %u interrupted",
   425                                  dmz_metadata_label(zmd), zrc->dev_idx,
   426                                  rzone->id);
   427                  else
   428                          DMDEBUG("(%s/%u): Failed to reclaim zone %u, err %d",
   429                                  dmz_metadata_label(zmd), zrc->dev_idx,
   430                                  rzone->id, ret);
                                        ^^^^^^^^^
Dereference.

   431                  dmz_unlock_zone_reclaim(dzone);
   432                  return ret;
   433          }
   434  
   435          ret = dmz_flush_metadata(zrc->metadata);
   436          if (ret) {
   437                  DMDEBUG("(%s/%u): Metadata flush for zone %u failed, err %d",
   438                          dmz_metadata_label(zmd), zrc->dev_idx, rzone->id, ret);
   439                  return ret;
   440          }
   441  
   442          DMDEBUG("(%s/%u): Reclaimed zone %u in %u ms",
   443                  dmz_metadata_label(zmd), zrc->dev_idx,
   444                  rzone->id, jiffies_to_msecs(jiffies - start));
   445          return 0;
   446  }

regards,
dan carpenter
