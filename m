From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: Re: dm create error
Date: Mon, 2 Feb 2015 14:03:11 -0600
Message-ID: <20150202200311.GG11463@ask-08.lab.msp.redhat.com>
References: <CAE6Xo7gFEx75vBotN1KKcRriUTe6S-rUNWd1LNDciXK5uwMuaA@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <CAE6Xo7gFEx75vBotN1KKcRriUTe6S-rUNWd1LNDciXK5uwMuaA@mail.gmail.com>
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
List-Id: dm-devel.ids

On Tue, Jan 27, 2015 at 05:33:09PM +0800, Xiaoqiang Zhou wrote:
>    Hi ALL:
>    A  A  A  I have some problem with dm. A 
>    A  A  A  when I add a multipath occur some error in message file:
>    A  A  A 
>    Jan 27 17:09:41 localhost kernel: device-mapper: table: 253:5: multipath:
>    error getting deviceA 
>    Jan 27 17:09:41 localhost kernel: device-mapper: ioctl: error adding
>    target to tableA 

This looks like one of the path devices to this device may already be in
use.

-Ben


>    Jan 27 17:09:41 localhost multipathd: uevent 'add' from
>    '/devices/virtual/block/dm-5'A 
>    Jan 27 17:09:41 localhost multipathd: uevent 'remove' from
>    '/devices/virtual/block/dm-5'A 
>    Jan 27 17:09:41 localhost multipathd: dm-5: remove map (uevent)A 
>    Jan 27 17:09:41 localhost multipathd: dm-5: No DM_NAME in uevent,
>    ignoringA 
>    Jan 27 17:09:41 localhost multipathd: uevent 'remove' from
>    '/devices/virtual/block/dm-5'A 
>    Jan 27 17:09:41 localhost multipathd: dm-5: remove map (uevent)A 
>    Jan 27 17:09:41 localhost multipathd: dm-5: No DM_NAME in uevent, ignoring
>    A  A  A  A [root@localhost ovirt-node-nfs]# multipath -lA 
>    Jan 27 17:22:56 | multipath.conf +6, invalid keyword: getuid_calloutA 
>    Jan 27 17:22:56 | multipath.conf +21, invalid keyword: getuid_calloutA 
>    Jan 27 17:22:56 | multipath.conf +41, invalid keyword: getuid_calloutA 
>    Jan 27 17:22:56 | libdevmapper version 1.02.84-RHEL7 (2014-03-26)A 
>    Jan 27 17:22:56 | DM multipath kernel driver v1.6.0A 
>    Jan 27 17:22:56 | loading /lib64/multipath/libcheckdirectio.so checkerA 
>    Jan 27 17:22:56 | loading /lib64/multipath/libprioconst.so prioritizerA 
>    Jan 27 17:22:56 | Discover device
>    /sys/devices/pci0000:00/0000:00:02.2/0000:03:00.0/host0/target0:2:0/0:2:0:0/block/sdaA 
>    Jan 27 17:22:56 | sda: not found in pathvecA 
>    Jan 27 17:22:56 | sda: mask = 0x21A 
>    Jan 27 17:22:56 | sda: dev_t = 8:0A 
>    Jan 27 17:22:56 | open
>    '/sys/devices/pci0000:00/0000:00:02.2/0000:03:00.0/host0/target0:2:0/0:2:0:0/block/sda/size'A 
>    Jan 27 17:22:56 | sda: size = 3904897024A 
>    Jan 27 17:22:56 | sda: vendor = DELLA 
>    Jan 27 17:22:56 | sda: product = PERC H310A 
>    Jan 27 17:22:56 | sda: rev = 2.12A 
>    Jan 27 17:22:56 | sda: h:b:t:l = 0:2:0:0A 
>    Jan 27 17:22:56 | open
>    '/sys/devices/pci0000:00/0000:00:02.2/0000:03:00.0/host0/target0:2:0/0:2:0:0/state'A 
>    Jan 27 17:22:56 | sda: path state = runningA 
> 
>    Jan 27 17:22:56 | Discover device
>    /sys/devices/pci0000:00/0000:00:02.2/0000:03:00.0/host0/target0:2:0/0:2:0:0/block/sda/sda1A 
>    Jan 27 17:22:56 | Discover device
>    /sys/devices/pci0000:00/0000:00:02.2/0000:03:00.0/host0/target0:2:0/0:2:0:0/block/sda/sda2A 
>    Jan 27 17:22:56 | Discover device
>    /sys/devices/pci0000:00/0000:00:1f.2/ata5/host5/target5:0:0/5:0:0:0/block/sr0A 
>    Jan 27 17:22:56 | sr0: device node name blacklistedA 
>    Jan 27 17:22:56 | Discover device /sys/devices/virtual/block/loop0A 
>    Jan 27 17:22:56 | loop0: device node name blacklistedA 
>    Jan 27 17:22:56 | Discover device /sys/devices/virtual/block/loop1A 
>    Jan 27 17:22:56 | loop1: device node name blacklistedA 
>    Jan 27 17:22:56 | Discover device /sys/devices/virtual/block/dm-0A 
>    Jan 27 17:22:56 | dm-0: device node name blacklistedA 
>    Jan 27 17:22:56 | Discover device /sys/devices/virtual/block/dm-1A 
>    Jan 27 17:22:56 | dm-1: device node name blacklistedA 
>    Jan 27 17:22:56 | Discover device /sys/devices/virtual/block/dm-2A 
>    Jan 27 17:22:56 | dm-2: device node name blacklistedA 
>    Jan 27 17:22:56 | Discover device /sys/devices/virtual/block/dm-3A 
>    Jan 27 17:22:56 | dm-3: device node name blacklistedA 
>    Jan 27 17:22:56 | Discover device /sys/devices/virtual/block/dm-4A 
>    Jan 27 17:22:56 | dm-4: device node name blacklistedA 
>    Jan 27 17:22:56 | Discovery status 0A 
>    ===== paths list =====A 
>    uuid hcil dev dev_t pri dm_st chk_st vend/prod/rev dev_stA 
>    0:2:0:0 sda 8:0 -1 undef undef DELL ,PERC H310 runningA 
>    Jan 27 17:22:56 | unloading const prioritizerA 
>    Jan 27 17:22:56 | unloading directio checker
>    [root@localhost etc]# cat multipath.confA 
>    # RHEV REVISION 1.1A 
> 
>    defaults {A 
>    polling_interval 5A 
>    #getuid_callout "/usr/lib/udev/scsi_id --whitelisted --replace-whitespace
>    --device=/dev/%n"A 
>    getuid_callout "/lib/udev/scsi_id --whitelisted --replace-whitespace
>    --device=/dev/%n"A 
>    no_path_retry 5A 
>    user_friendly_names noA 
>    flush_on_last_del yesA 
>    fast_io_fail_tmo 5A 
>    dev_loss_tmo 30A 
>    max_fds 4096A 
>    verbosity 4A 
>    }A 
> 
>    devices {A 
>    device {A 
>    vendor "HITACHI"A 
>    product "DF.*"A 
>    #getuid_callout "/usr/lib/udev/scsi_id --whitelisted --replace-whitespace
>    --device=/dev/%n"A 
>    getuid_callout "/lib/udev/scsi_id --whitelisted --replace-whitespace
>    --device=/dev/%n"A 
>    }A 
>    device {A 
>    vendor "COMPELNT"A 
>    product "Compellent Vol"A 
>    no_path_retry 5A 
>    }A 
>    device {A 
>    # multipath.conf.defaultA 
>    vendor "DGC"A 
>    product ".*"A 
>    product_blacklist "LUNZ"A 
>    path_grouping_policy "group_by_prio"A 
>    path_checker "emc_clariion"A 
>    hardware_handler "1 emc"A 
>    prio "emc"A 
>    failback immediateA 
>    rr_weight "uniform"A 
>    # vdsm required configurationA 
>    #getuid_callout "/usr/lib/udev/scsi_id --whitelisted --replace-whitespace
>    --device=/dev/%n"A 
>    getuid_callout "/lib/udev/scsi_id --whitelisted --replace-whitespace
>    --device=/dev/%n"A 
>    features "0"A 
>    no_path_retry 5A 
>    }A 
>    }A 
>    [root@localhost etc]#A 
>    I can not fix this issue .A This problem is hard enough to perplex .A 
>    someone can give me some suggest with it.

> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
