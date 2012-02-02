From: Zdenek Kabelac <zkabelac@redhat.com>
Subject: Re: [linux-lvm] New LVM2 release 2.02.89:
 Thinly-provisioned logical volumes
Date: Thu, 02 Feb 2012 10:41:29 +0100
Message-ID: <4F2A5A49.9060407@redhat.com>
References: <20120201124144.GA23056@agk-dp.fab.redhat.com>
	<20120131132318.GH16447@agk-dp.fab.redhat.com>
	<20120127025701.GB16767@agk-dp.fab.redhat.com>
	<1eaeb3d5.c6e.135332dea21.Coremail.chaimvy@163.com>
	<5162be66.9cd.13538125472.Coremail.chaimvy@163.com>
	<407b84bc.164f.1353bb4d438.Coremail.chaimvy@163.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <407b84bc.164f.1353bb4d438.Coremail.chaimvy@163.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: "Busby.Cheung" <chaimvy@163.com>, Alasdair G Kergon <agk@redhat.com>, LVM general discussion and development <linux-lvm@redhat.com>
List-Id: dm-devel.ids

Dne 2.2.2012 02:36, Busby.Cheung napsal(a):
> Hi Alasdair,
>
>               The kernel mesg log "failed to resize data device" while use dmsetup CMDs to create pool will be ok.
>
> use LVM2 cmd mesgs:
> ---------------------------
>
> [root@host2 ~]# pvs
>    Ignoring too small pv_min_size 512KB, using default 2048KB.
>    PV         VG         Fmt  Attr PSize   PFree
>    /dev/sda2  VolGroup00 lvm2 a--  931.41G      0
>    /dev/sdg   vg_pool    lvm2 a--  931.51G 931.51G
>    /dev/sdl   vg_pool    lvm2 a--  931.51G 931.51G
> [root@host2 ~]# vgs
>    Ignoring too small pv_min_size 512KB, using default 2048KB.
>    VG         #PV #LV #SN Attr   VSize   VFree
>    VolGroup00   1   2   0 wz--n- 931.41G      0
>    vg_pool      2   0   0 wz--n-   1.82T   1.82T
> [root@host2 ~]# lvcreate -L65G -T vg_pool/pool
>    Ignoring too small pv_min_size 512KB, using default 2048KB.
>    Rounding up size to full physical extent 4.00 MB
>    device-mapper: resume ioctl on  failed: Cannot allocate memory
>    Unable to resume vg_pool-pool-tpool (253:12)
>    Aborting. Failed to activate thin pool.
> [root@host2 ~]# dmesg
> device-mapper: space map checker: Loading debug space map from disk.  This may take some time
> device-mapper: space map checker: Load complete
> device-mapper: thin: failed to resize data device
> [root@host2 ~]# cat /var/log/messages
> Feb  2 09:14:45 host2 kernel: device-mapper: space map checker: Loading debug space map from disk.  This may take some time
> Feb  2 09:14:45 host2 kernel: device-mapper: space map checker: Load complete
> Feb  2 09:14:45 host2 kernel: device-mapper: thin: failed to resize data device
>
>   --------------------------
> use dmsetup cmd:
>
> [root@host2 ~]# lvcreate -n metadata_lv -L40M  vg_pool
>    Ignoring too small pv_min_size 512KB, using default 2048KB.
>    Logical volume "metadata_lv" created
> [root@host2 ~]# lvcreate -n data_lv -L300G vg_pool
>    Ignoring too small pv_min_size 512KB, using default 2048KB.
>    Logical volume "data_lv" created
> [root@host2 ~]# dmsetup create pool --table "0 209715200 thin-pool /dev/vg_pool/metadata_lv /dev/vg_pool/data_lv  1024  20000"
> [root@host2 ~]# dmsetup status
> vg_pool-metadata_lv: 0 81920 linear
> VolGroup00-LogVol01: 0 24510464 linear
> vg_pool-pool-tpool: 0 136314880 thin-pool 0 76/1024 0/0 -
> vg_pool-pool_tdata: 0 136314880 linear
> VolGroup00-LogVol00: 0 1928790016 linear
> vg_pool-pool_tmeta: 0 8192 linear
> pool: 0 209715200 thin-pool 0 21/10240 0/204800 -
> vg_pool-data_lv: 0 629145600 linear
>
> [root@host2 ~]# dmesg
> device-mapper: space map checker: Loading debug space map from disk.  This may take some time
> device-mapper: space map checker: Load complete
> device-mapper: thin: failed to resize data device
> device-mapper: space map checker: Loading debug space map from disk.  This may take some time
> device-mapper: space map checker: Load complete
> device-mapper: space map checker: free block counts differ, checker 1020, sm-disk:948
> device-mapper: space map checker: free block counts differ, checker 10236, sm-disk:10219
>

Have you tried to build kernel without CONFIG_DM_DEBUG_SPACE_MAPS and 
CONFIG_DM_DEBUG_BLOCK_STACK_TRACING ?

These two options are there only for debugging - and have major impact on 
performance (and possibly on memory resource as well).

To check consistency of metadata there are now user-space tools available.

Zdenek
