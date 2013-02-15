From: Eric Wheeler <dm-devel@ew.ewheeler.org>
Subject: Re: dm-thinp BUG at
 drivers/md/persistent-data/dm-btree-remove.c:188
Date: Thu, 14 Feb 2013 19:49:29 -0800 (PST)
Message-ID: <alpine.DEB.2.00.1302141935030.50852@ware.dreamhost.com>
References: <alpine.DEB.2.00.1302141757240.50852@ware.dreamhost.com>
	<20130215023400.GM24130@agk-dp.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20130215023400.GM24130@agk-dp.fab.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Alasdair G Kergon <agk@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids


On Fri, 15 Feb 2013, Alasdair G Kergon wrote:

> On Thu, Feb 14, 2013 at 06:07:56PM -0800, Eric Wheeler wrote:
>> Does this indicate a corrupt volume or metadata volume?
>
> It could be a software bug.
> It is always worth trying the newest code, but I don't spot any
> obvious change that could be related to this.
>
>> Let me know what other data I can collect, if any.  The VM seems to hang
>> every few hours or so but I'm not sure what triggers it yet.
>
> Please provide the basic parameters of the device e.g.

The volume names have been sanitized in the output so I can publish them.

old_pool is no longer in use.  It is mostly broken because I ran out of 
metadata space on old_pool and started over with "pool" which has a 
16GB tmeta volume.

>  dmsetup info -c
Name          Maj Min Stat Open Targ Event  UUID
old_pool-aac     252  19 L--w    0    1      0 LVM-WxsniE1DiB1bDGpIIVIIOmutTcY2O12ZPDUdZs0WdzwBrW4u7IbKt4TDmjHlkqY1
old_pool-aad     252  27 L--w    0    1      0 LVM-WxsniE1DiB1bDGpIIVIIOmutTcY2O12ZrMmwdOg0acMW47R2FtVN8IpC9mC7fPBu
old_pool-aae     252  18 L--w    0    1      0 LVM-WxsniE1DiB1bDGpIIVIIOmutTcY2O12ZL4oAew8Xj9qIUAlirz1mUDO6uC1YbeL2
old_pool-aaf     252  24 L--w    0    1      0 LVM-WxsniE1DiB1bDGpIIVIIOmutTcY2O12Z17AKABzVOfxVoiBOZxf7AFHVcfaNtBv4
old_pool-aaj     252  25 L--w    0    1      0 LVM-WxsniE1DiB1bDGpIIVIIOmutTcY2O12ZAx5amNe2T4yjsJ9M1yUC0Com8nHNOvoS
old_pool-aak     252  23 L--w    0    1      0 LVM-WxsniE1DiB1bDGpIIVIIOmutTcY2O12ZlUyYiVcr10r9jZ2BjjcPp8XVwdnRrtxR
old_pool-aal     252  26 L--w    0    1      0 LVM-WxsniE1DiB1bDGpIIVIIOmutTcY2O12ZrULTcdi88MO327hUEPpXUyGkfaUCUMdj
old_pool-aan     252  20 L--w    0    1      0 LVM-WxsniE1DiB1bDGpIIVIIOmutTcY2O12ZNwC8lugqdj0mesi4xCWeuSqxm5ZOYe5B
old_pool-aap     252  22 L--w    0    1      0 LVM-WxsniE1DiB1bDGpIIVIIOmutTcY2O12ZFj8gsjzrQ9yrMfpZrRiij70wylJeY4Na
old_pool-aar     252  21 L--w    0    1      0 LVM-WxsniE1DiB1bDGpIIVIIOmutTcY2O12ZKeqf7ouRzMEYTMKDQ8wn9dYZyIDTo844
old_pool-aas     252  28 L--w    0    1      0 LVM-WxsniE1DiB1bDGpIIVIIOmutTcY2O12Ze9dwbC2jPEaZKfbB8bwH4ZKWJtXyic2h
old_pool-pool    252  17 L--w    0    1      0 LVM-WxsniE1DiB1bDGpIIVIIOmutTcY2O12Z7GcAvP20FSMxLI3Y8gyG1el4eCejvMdr
old_pool-pool_tdata  252  15 L--w    1    2      0 LVM-WxsniE1DiB1bDGpIIVIIOmutTcY2O12ZzEM36WwdDz6TqSu4RAZcQPEIPWA6KaE5
old_pool-pool_tmeta  252  14 L--w    1    1      0 LVM-WxsniE1DiB1bDGpIIVIIOmutTcY2O12Zitg1ZQFu0lywXtXtATOGazFE8IUB6YXv
old_pool-pool-tpool  252  16 L--w   12    1      0 LVM-WxsniE1DiB1bDGpIIVIIOmutTcY2O12Z7GcAvP20FSMxLI3Y8gyG1el4eCejvMdr-tpool
pool-aaa         252   7 L--w    0    1      0 LVM-eEgPyKYcZaM3BYBtSTHwLKuoodqbRH4ayHUOZJPgmAV9CMxty7w93RbpRHPq29HK
pool-aab         252  10 L--w    0    1      0 LVM-eEgPyKYcZaM3BYBtSTHwLKuoodqbRH4aUMJFnLqsGdoVJ6HzhqFLvdFUX06Fu4rN
pool-aag         252  12 L--w    0    1      0 LVM-eEgPyKYcZaM3BYBtSTHwLKuoodqbRH4aHTPViI0Hb56ico35QgtQF3H9818AVw37
pool-aah         252   6 L--w    0    1      0 LVM-eEgPyKYcZaM3BYBtSTHwLKuoodqbRH4actTmWGAa3LiXwLu6txzj6BqrmardzapF
pool-aai         252  11 L--w    0    1      0 LVM-eEgPyKYcZaM3BYBtSTHwLKuoodqbRH4anpU9NKpY0O4UmQn0QXIrei5qRlK58JTV
pool-aam         252   8 L--w    1    1      0 LVM-eEgPyKYcZaM3BYBtSTHwLKuoodqbRH4aALhd9AEoF3OfcTBP8HaS0Mrekh1K2sa8
pool-aao         252   9 L--w    0    1      0 LVM-eEgPyKYcZaM3BYBtSTHwLKuoodqbRH4amxFrrZasqAPxj5SmHeIG8PYRc2fGWsgb
pool-aaq         252  13 L--w    0    1      0 LVM-eEgPyKYcZaM3BYBtSTHwLKuoodqbRH4aB3scAqJPBoUn33F4Fl20c0PRYCNWPPzA
pool-pool        252   5 L--w    0    1      0 LVM-eEgPyKYcZaM3BYBtSTHwLKuoodqbRH4aX6UHd24HwxSfe4Ek9DKe7Gn3EzHqReP0
pool-pool_tdata  252   3 L--w    1    2      0 LVM-eEgPyKYcZaM3BYBtSTHwLKuoodqbRH4aBxn6jyhL5FW1sQJ1HVKAfLak929VgkOw
pool-pool_tmeta  252   2 L--w    1    1      0 LVM-eEgPyKYcZaM3BYBtSTHwLKuoodqbRH4aN82ZJRYEgmqfufReLDshPnoNxubeFX60
pool-pool-tpool  252   4 L--w    9    1      0 LVM-eEgPyKYcZaM3BYBtSTHwLKuoodqbRH4aX6UHd24HwxSfe4Ek9DKe7Gn3EzHqReP0-tpool
VolGroup-lv_root 252   0 L--w    1    2      0 LVM-Jx5Plzd03Rc9hfDqdz5wYGDbwXbi0hzg2HsYRt9T7mKFtmxFKGl13mab0fnyB0T0
VolGroup-lv_swap 252   1 L--w    2    1      0 LVM-Jx5Plzd03Rc9hfDqdz5wYGDbwXbi0hzgq0MV3ZgxgmkesoXuxzJlHRQNGFe8KzRj

>  dmsetup table

old_pool-aac: 0 41943040 thin 252:16 2
old_pool-aad: 0 41943040 thin 252:16 18
old_pool-aae: 0 629145600 thin 252:16 1
old_pool-aaf: 0 31457280 thin 252:16 7
old_pool-aaj: 0 41943040 thin 252:16 16
old_pool-aak: 0 31457280 thin 252:16 6
old_pool-aal_swap: 0 16777216 thin 252:16 17
old_pool-aan: 0 62496768 thin 252:16 3
old_pool-aap: 0 62914560 thin 252:16 5
old_pool-aar: 0 41943040 thin 252:16 4
old_pool-aas: 0 629145600 thin 252:16 19
old_pool-pool: 0 1027604480 linear 252:16 0
old_pool-pool_tdata: 0 419430400 linear 253:16 2048
old_pool-pool_tdata: 419430400 608174080 linear 253:16 419637248
old_pool-pool_tmeta: 0 204800 linear 253:16 419432448
old_pool-pool-tpool: 0 1027604480 thin-pool 252:14 252:15 256 0 0
pool-aaa: 0 629145600 thin 252:4 3
pool-aab: 0 79691776 thin 252:4 6
pool-aag: 0 79273984 thin 252:4 8
pool-aah: 0 31457280 thin 252:4 1
pool-aai: 0 62914560 thin 252:4 7
pool-aam: 0 41943040 thin 252:4 4
pool-aao: 0 52428800 thin 252:4 5
pool-aaq: 0 629145600 thin 252:4 9
pool-pool: 0 1006632960 linear 252:4 0
pool-pool_tdata: 0 838860800 linear 253:32 2048
pool-pool_tdata: 838860800 167772160 linear 253:32 872417280
pool-pool_tmeta: 0 33161216 linear 253:32 838862848
pool-pool-tpool: 0 1006632960 thin-pool 252:2 252:3 128 0 0
VolGroup-lv_root: 0 13713408 linear 253:2 2048
VolGroup-lv_root: 13713408 14680064 linear 253:2 15747072
VolGroup-lv_swap: 0 2031616 linear 253:2 13715456


>  dmsetup status

old_pool-aac: 0 41943040 thin 37725952 41943039
old_pool-aad: 0 41943040 thin 30514176 41943039
old_pool-aae: 0 629145600 thin 326287616 625017087
old_pool-aaf: 0 31457280 thin 21150464 31457279
old_pool-aaj: 0 41943040 thin 36858880 41943039
old_pool-aak: 0 31457280 thin 20298496 31375871
old_pool-aal_swap: 0 16777216 thin 279808 280831
old_pool-aan: 0 62496768 thin 60272128 62476543
old_pool-aap: 0 62914560 thin 59126016 62901503
old_pool-aar: 0 41943040 thin 31097344 41943039
old_pool-aas: 0 629145600 thin 299941376 625017087
old_pool-pool: 0 1027604480 linear
old_pool-pool_tdata: 0 419430400 linear
old_pool-pool_tdata: 419430400 608174080 linear
old_pool-pool_tmeta: 0 204800 linear
old_pool-pool-tpool: 0 1027604480 thin-pool 197 25586/25600 3229287/4014080 - rw no_discard_passdown
pool-aaa: 0 629145600 thin 207272576 624951423
pool-aab: 0 79691776 thin 42822656 79508223
pool-aag: 0 79273984 thin 62524416 79273983
pool-aah: 0 31457280 thin 19696256 31375871
pool-aai: 0 62914560 thin 47576320 62901503
pool-aam: 0 41943040 thin 12874880 39770495
pool-aao: 0 52428800 thin 32009600 52283647
pool-aaq: 0 629145600 thin 170327040 624951423
pool-pool: 0 1006632960 linear
pool-pool_tdata: 0 838860800 linear
pool-pool_tdata: 838860800 167772160 linear
pool-pool_tmeta: 0 33161216 linear
pool-pool-tpool: 0 1006632960 thin-pool 42 4890/4145152 4553196/7864320 - rw no_discard_passdown
VolGroup-lv_root: 0 13713408 linear
VolGroup-lv_root: 13713408 14680064 linear
VolGroup-lv_swap: 0 2031616 linear

> and then I think we'll probably want to see your metadata (or
> the relevant part of it) at the point where it hangs.

Here's the whole dump:

http://www.globallinuxsecurity.pro/out/pool_tmeta.dump.gz

> The trace shows it's applying a 'discard' to the metadata and releasing
> blocks when the problem occurs.

Is this the same 'discard' as in the ATA discard sense, or just deleting 
something from its tree?

-Eric

>
> Alasdair
>
>

--
Eric Wheeler
www.globallinuxsecurity.pro
