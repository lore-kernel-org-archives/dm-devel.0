From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [bug report] dm zoned: metadata version 2
Date: Wed, 13 May 2020 12:36:41 +0300
Message-ID: <20200513093616.GA347693@mwanda>
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

The patch 70978208ec91: "dm zoned: metadata version 2" from May 11,
2020, leads to the following static checker warning:

	drivers/md/dm-zoned-target.c:1047 dmz_iterate_devices()
	warn: was expecting a 64 bit value instead of '~(zone_nr_sectors - 1)'

drivers/md/dm-zoned-target.c
  1039  static int dmz_iterate_devices(struct dm_target *ti,
  1040                                 iterate_devices_callout_fn fn, void *data)
  1041  {
  1042          struct dmz_target *dmz = ti->private;
  1043          unsigned int zone_nr_sectors = dmz_zone_nr_sectors(dmz->metadata);
  1044          sector_t capacity;
  1045          int r;
  1046  
  1047          capacity = dmz->dev[0].capacity & ~(zone_nr_sectors - 1);

sector_t is a u64 and zone_nr_sectors is a u32.  It means that the high
32 bits are always cleared.  Making zone_nr_sectors a sector_t, u64 or
even an int would fix this problem.

  1048          r = fn(ti, dmz->ddev[0], 0, capacity, data);
  1049          if (!r && dmz->ddev[1]) {
  1050                  capacity = dmz->dev[1].capacity & ~(zone_nr_sectors - 1);
  1051                  r = fn(ti, dmz->ddev[1], 0, capacity, data);
  1052          }
  1053          return r;
  1054  }

regards,
dan carpenter
