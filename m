From: Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: dmzone trigger problem with zone reclaim
Date: Mon, 9 Jul 2018 07:39:38 +0000
Message-ID: <BN3PR0401MB137730536F37F360BBA5C4B8E7440@BN3PR0401MB1377.namprd04.prod.outlook.com>
References: <6798699e-81d0-3a11-a6d2-5ee003b40cf8@huawei.com>
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
To: yangerkun <yangerkun@huawei.com>, "agk@redhat.com" <agk@redhat.com>, "snitzer@redhat.com" <snitzer@redhat.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>, "miaoxie@huawei.com" <miaoxie@huawei.com>
List-Id: dm-devel.ids

On 2018/07/09 16:22, yangerkun wrote:
> Hi,
> Nowdays, i am trying dm-zoned+f2fs to use SMR block device. But, there 
> is a problem that i can not distinguish it is problem of block device or 
> the software.

f2fs has native support for zoned block devices (host managed SMR disks). So
there is no need for dm-zoned with f2fs. Simply run "mkfs.f2fs -m /dev/<disk
name>" and mount your file system.

> 
> The steps and phenomena of recurrence are as follows:
> 1.dmzadm --format /dev/sdf
> 2.echo "0 `blockdev --getsize /dev/sdf` zoned /dev/sdf" | dmsetup create 
> dmz-`basename /dev/sdf`
> 3.mkfs.f2fs /dev/mapper/dmz-sdf
> Then, dm-zoned will reclaim some rnd zone, and the problem will trigger 
> as follow:
> dmz_reclaim
> 	->dmz_reclaim_rnd_data
> 		->dmz_reclaim_copy
> 			->dmz_reclaim_align_wp
> 				->blkdev_issue_zeroout
> The return error is EIO:
> [ 4536.178190] sas: Enter sas_scsi_recover_host busy: 2 failed: 2
> [ 4536.184040] sas: trying to find task 0x00000000b423196b
> [ 4536.189268] sas: sas_scsi_find_task: aborting task 0x00000000b423196b
> [ 4536.249110] sas: sas_scsi_find_task: task 0x00000000b423196b is done
> [ 4536.255464] sas: sas_eh_handle_sas_errors: task 0x00000000b423196b is 
> done
> [ 4536.262345] sas: ata6: end_device-0:0:8: cmd error handler
> [ 4536.267864] sas: ata1: end_device-0:0:0: dev error handler
> [ 4536.267871] sas: ata2: end_device-0:0:1: dev error handler
> [ 4536.267879] sas: ata3: end_device-0:0:3: dev error handler
> [ 4536.267895] sas: ata4: end_device-0:0:4: dev error handler
> [ 4536.267905] sas: ata5: end_device-0:0:5: dev error handler
> [ 4536.267915] sas: ata6: end_device-0:0:8: dev error handler
> [ 4536.267919] ata6.00: sense data available but port frozen
> [ 4536.267921] ata6.00: sense data available but port frozen
> [ 4536.267925] ata6.00: exception Emask 0x1 SAct 0x60 SErr 0x0 action 
> 0x6 frozen
> [ 4536.267930] ata6.00: failed command: WRITE FPDMA QUEUED
> [ 4536.267934] ata6.00: cmd 61/00:00:00:08:87/04:00:03:00:00/40 tag 5 
> ncq dma 524288 out
>           res 43/04:00:00:00:00/00:00:00:00:00/00 Emask 0x5 (timeout)
> [ 4536.267936] ata6.00: status: { DRDY SENSE ERR }
> [ 4536.267937] ata6.00: error: { ABRT }
> [ 4536.267939] ata6.00: failed command: WRITE FPDMA QUEUED
> [ 4536.267943] ata6.00: cmd 61/00:00:00:0c:87/04:00:03:00:00/40 tag 6 
> ncq dma 524288 out
>           res 43/04:00:00:00:00/00:00:00:00:00/00 Emask 0x1 (device error)
> [ 4536.267945] ata6.00: status: { DRDY SENSE ERR }
> [ 4536.267946] ata6.00: error: { ABRT }
> [ 4536.267948] ata6: hard resetting link

This looks like either a disk problem or an HBA problem.
What HBA are you using ? Not all SAS HBAs behave correctly with host-managed disks.


> [ 4536.274454] sas: broadcast received: 0
> [ 4536.383437] sas: REVALIDATION DEFERRED on port 0, pid:18191
> [ 4536.389010] sas: broadcast received: 0
> [ 4536.392752] sas: broadcast received: 0
> [ 4536.396494] sas: broadcast received: 0
> [ 4536.400236] sas: broadcast received: 0
> [ 4536.403977] sas: broadcast received: 0
> [ 4536.407718] sas: broadcast received: 0
> [ 4536.411460] sas: broadcast received: 0
> [ 4536.415202] sas: broadcast received: 0
> [ 4536.418944] sas: broadcast received: 0
> [ 4536.422685] sas: broadcast received: 0
> [ 4536.426427] sas: broadcast received: 0
> [ 4536.430168] sas: broadcast received: 0
> [ 4536.433904] sas: broadcast received: 0
> [ 4536.437646] sas: broadcast received: 0
> [ 4536.441388] sas: broadcast received: 0
> [ 4538.459884] ata6.00: NCQ Send/Recv Log not supported
> [ 4538.466881] ata6.00: NCQ Send/Recv Log not supported
> [ 4538.472894] ata6.00: configured for UDMA/133
> [ 4538.477179] ata6: EH complete
> [ 4538.480194] sas: --- Exit sas_scsi_recover_host: busy: 0 failed: 2 
> tries: 1
> [ 4538.480198] sas: broadcast received: 0
> [ 4538.490924] sas: REVALIDATING DOMAIN on port 0, pid:17922
> [ 4538.497366] sas: Expander phy change count has changed
> [ 4538.503341] sas: ex 500e004aaaaaaa1f phy8 originated BROADCAST(CHANGE)
> [ 4538.510109] sas: ex 500e004aaaaaaa1f phy 0x8 broadcast flutter
> [ 4538.517490] sas: done REVALIDATING DOMAIN on port 0, pid:17922, res 0x0
> [ 4551.682209] sas: Enter sas_scsi_recover_host busy: 2 failed: 2
> [ 4551.688047] sas: trying to find task 0x0000000046927847
> [ 4551.693280] sas: sas_scsi_find_task: aborting task 0x0000000046927847
> [ 4551.752529] sas: sas_scsi_find_task: task 0x0000000046927847 is done
> [ 4551.758880] sas: sas_eh_handle_sas_errors: task 0x0000000046927847 is 
> done
> [ 4551.765758] sas: ata6: end_device-0:0:8: cmd error handler
> [ 4551.771271] sas: ata1: end_device-0:0:0: dev error handler
> [ 4551.771279] sas: ata2: end_device-0:0:1: dev error handler
> [ 4551.771287] sas: ata3: end_device-0:0:3: dev error handler
> [ 4551.771294] sas: ata4: end_device-0:0:4: dev error handler
> [ 4551.771297] sas: ata5: end_device-0:0:5: dev error handler
> [ 4551.771301] sas: ata6: end_device-0:0:8: dev error handler
> [ 4551.771306] ata6.00: sense data available but port frozen
> [ 4551.771307] ata6.00: sense data available but port frozen
> [ 4551.771310] ata6.00: exception Emask 0x1 SAct 0x300 SErr 0x0 action 
> 0x6 frozen
> [ 4551.771313] ata6.00: failed command: WRITE FPDMA QUEUED
> [ 4551.771317] ata6.00: cmd 61/00:00:00:0c:87/04:00:03:00:00/40 tag 8 
> ncq dma 524288 out
>           res 43/04:00:00:0c:87/00:04:03:00:00/40 Emask 0x5 (timeout)
> [ 4551.771318] ata6.00: status: { DRDY SENSE ERR }
> [ 4551.771320] ata6.00: error: { ABRT }
> [ 4551.771321] ata6.00: failed command: WRITE FPDMA QUEUED
> [ 4551.771325] ata6.00: cmd 61/00:00:00:08:87/04:00:03:00:00/40 tag 9 
> ncq dma 524288 out
>           res 43/04:00:00:0c:87/00:04:03:00:00/40 Emask 0x1 (device error)
> [ 4551.771327] ata6.00: status: { DRDY SENSE ERR }
> [ 4551.771328] ata6.00: error: { ABRT }
> [ 4551.771330] ata6: hard resetting link
> [ 4551.774432] sas: broadcast received: 0
> [ 4551.774438] sas: REVALIDATION DEFERRED on port 0, pid:15800
> [ 4551.774466] sas: broadcast received: 0
> [ 4551.774494] sas: broadcast received: 0
> [ 4551.774522] sas: broadcast received: 0
> [ 4551.774551] sas: broadcast received: 0
> [ 4551.774579] sas: broadcast received: 0
> [ 4551.774608] sas: broadcast received: 0
> [ 4551.774637] sas: broadcast received: 0
> [ 4551.854272] sas: broadcast received: 0
> [ 4551.922385] sas: broadcast received: 0
> [ 4551.926121] sas: broadcast received: 0
> [ 4551.929864] sas: broadcast received: 0
> [ 4551.933606] sas: broadcast received: 0
> [ 4551.937348] sas: broadcast received: 0
> [ 4551.941089] sas: broadcast received: 0
> [ 4551.944831] sas: broadcast received: 0
> [ 4553.947340] ata6.00: NCQ Send/Recv Log not supported
> [ 4553.954438] ata6.00: NCQ Send/Recv Log not supported
> [ 4553.960445] ata6.00: configured for UDMA/133
> [ 4553.964727] ata6: EH complete
> [ 4553.967723] sas: --- Exit sas_scsi_recover_host: busy: 0 failed: 2 
> tries: 1
> [ 4553.967726] sas: broadcast received: 0
> [ 4553.967735] sas: REVALIDATING DOMAIN on port 0, pid:18193
> [ 4553.984913] sas: Expander phy change count has changed
> [ 4553.990947] sas: ex 500e004aaaaaaa1f phy8 originated BROADCAST(CHANGE)
> [ 4553.997680] sas: ex 500e004aaaaaaa1f phy 0x8 broadcast flutter
> [ 4554.005030] sas: done REVALIDATING DOMAIN on port 0, pid:18193, res 0x0
> [ 4566.678209] sas: Enter sas_scsi_recover_host busy: 2 failed: 2
> [ 4566.684047] sas: trying to find task 0x0000000046927847
> [ 4566.689274] sas: sas_scsi_find_task: aborting task 0x0000000046927847
> [ 4566.748663] sas: sas_scsi_find_task: task 0x0000000046927847 is done
> [ 4566.755015] sas: sas_eh_handle_sas_errors: task 0x0000000046927847 is 
> done
> [ 4566.761896] sas: ata6: end_device-0:0:8: cmd error handler
> [ 4566.767409] sas: ata1: end_device-0:0:0: dev error handler
> [ 4566.767416] sas: ata2: end_device-0:0:1: dev error handler
> [ 4566.767422] sas: ata3: end_device-0:0:3: dev error handler
> [ 4566.767430] sas: ata4: end_device-0:0:4: dev error handler
> [ 4566.767432] sas: ata5: end_device-0:0:5: dev error handler
> [ 4566.767435] sas: ata6: end_device-0:0:8: dev error handler
> [ 4566.767440] ata6.00: sense data available but port frozen
> [ 4566.767442] ata6.00: sense data available but port frozen
> [ 4566.767444] ata6.00: exception Emask 0x1 SAct 0x1800 SErr 0x0 action 
> 0x6 frozen
> [ 4566.767447] ata6.00: failed command: WRITE FPDMA QUEUED
> [ 4566.767451] ata6.00: cmd 61/00:00:00:08:87/04:00:03:00:00/40 tag 11 
> ncq dma 524288 out
>           res 43/04:00:00:08:87/00:04:03:00:00/40 Emask 0x5 (timeout)
> [ 4566.767452] ata6.00: status: { DRDY SENSE ERR }
> [ 4566.767454] ata6.00: error: { ABRT }
> [ 4566.767455] ata6.00: failed command: WRITE FPDMA QUEUED
> [ 4566.767459] ata6.00: cmd 61/00:00:00:0c:87/04:00:03:00:00/40 tag 12 
> ncq dma 524288 out
>           res 43/04:00:00:08:87/00:04:03:00:00/40 Emask 0x1 (device error)
> [ 4566.767460] ata6.00: status: { DRDY SENSE ERR }
> [ 4566.767461] ata6.00: error: { ABRT }
> [ 4566.767464] ata6: hard resetting link
> [ 4566.775447] sas: broadcast received: 0
> [ 4566.883322] sas: REVALIDATION DEFERRED on port 0, pid:18238
> [ 4566.888893] sas: broadcast received: 0
> [ 4566.892634] sas: broadcast received: 0
> [ 4566.896376] sas: broadcast received: 0
> [ 4566.900118] sas: broadcast received: 0
> [ 4566.903859] sas: broadcast received: 0
> [ 4566.907601] sas: broadcast received: 0
> [ 4566.911343] sas: broadcast received: 0
> [ 4566.915084] sas: broadcast received: 0
> [ 4566.918826] sas: broadcast received: 0
> [ 4566.922567] sas: broadcast received: 0
> [ 4566.926308] sas: broadcast received: 0
> [ 4566.930044] sas: broadcast received: 0
> [ 4566.933786] sas: broadcast received: 0
> [ 4566.937527] sas: broadcast received: 0
> [ 4566.941268] sas: broadcast received: 0
> [ 4568.955383] ata6.00: NCQ Send/Recv Log not supported
> [ 4568.963034] ata6.00: NCQ Send/Recv Log not supported
> [ 4568.969047] ata6.00: configured for UDMA/133
> [ 4568.973333] ata6: EH complete
> [ 4568.976328] sas: --- Exit sas_scsi_recover_host: busy: 0 failed: 2 
> tries: 1
> [ 4568.976332] sas: broadcast received: 0
> [ 4568.987038] sas: REVALIDATING DOMAIN on port 0, pid:17922
> [ 4568.993476] sas: Expander phy change count has changed
> [ 4568.999504] sas: ex 500e004aaaaaaa1f phy8 originated BROADCAST(CHANGE)
> [ 4569.006254] sas: ex 500e004aaaaaaa1f phy 0x8 broadcast flutter
> [ 4569.013597] sas: done REVALIDATING DOMAIN on port 0, pid:17922, res 0x0
> [ 4581.930193] sas: Enter sas_scsi_recover_host busy: 2 failed: 2
> [ 4581.936034] sas: trying to find task 0x0000000046927847
> [ 4581.941261] sas: sas_scsi_find_task: aborting task 0x0000000046927847
> [ 4582.001409] sas: sas_scsi_find_task: task 0x0000000046927847 is done
> [ 4582.007762] sas: sas_eh_handle_sas_errors: task 0x0000000046927847 is 
> done
> [ 4582.014640] sas: ata6: end_device-0:0:8: cmd error handler
> [ 4582.020152] sas: ata1: end_device-0:0:0: dev error handler
> [ 4582.020158] sas: ata2: end_device-0:0:1: dev error handler
> [ 4582.020166] sas: ata3: end_device-0:0:3: dev error handler
> [ 4582.020171] sas: ata4: end_device-0:0:4: dev error handler
> [ 4582.020178] sas: ata5: end_device-0:0:5: dev error handler
> [ 4582.020179] sas: ata6: end_device-0:0:8: dev error handler
> [ 4582.020184] ata6.00: sense data available but port frozen
> [ 4582.020185] ata6.00: sense data available but port frozen
> [ 4582.020187] ata6.00: NCQ disabled due to excessive errors
> [ 4582.020188] ata6.00: exception Emask 0x1 SAct 0xc000 SErr 0x0 action 
> 0x6 frozen
> [ 4582.020190] ata6.00: failed command: WRITE FPDMA QUEUED
> [ 4582.020194] ata6.00: cmd 61/00:00:00:0c:87/04:00:03:00:00/40 tag 14 
> ncq dma 524288 out
>           res 43/04:00:00:0c:87/00:04:03:00:00/40 Emask 0x5 (timeout)
> [ 4582.020195] ata6.00: status: { DRDY SENSE ERR }
> [ 4582.020196] ata6.00: error: { ABRT }
> [ 4582.020198] ata6.00: failed command: WRITE FPDMA QUEUED
> [ 4582.020201] ata6.00: cmd 61/00:00:00:08:87/04:00:03:00:00/40 tag 15 
> ncq dma 524288 out
>           res 43/04:00:00:0c:87/00:04:03:00:00/40 Emask 0x1 (device error)
> [ 4582.020203] ata6.00: status: { DRDY SENSE ERR }
> [ 4582.020204] ata6.00: error: { ABRT }
> [ 4582.020206] ata6: hard resetting link
> [ 4582.025469] sas: broadcast received: 0
> [ 4582.025476] sas: REVALIDATION DEFERRED on port 0, pid:18191
> [ 4582.025505] sas: broadcast received: 0
> [ 4582.025533] sas: broadcast received: 0
> [ 4582.025561] sas: broadcast received: 0
> [ 4582.025590] sas: broadcast received: 0
> [ 4582.025619] sas: broadcast received: 0
> [ 4582.025649] sas: broadcast received: 0
> [ 4582.169474] sas: broadcast received: 0
> [ 4582.173225] sas: broadcast received: 0
> [ 4582.176968] sas: broadcast received: 0
> [ 4582.180710] sas: broadcast received: 0
> [ 4582.184452] sas: broadcast received: 0
> [ 4582.188194] sas: broadcast received: 0
> [ 4582.191937] sas: broadcast received: 0
> [ 4582.195678] sas: broadcast received: 0
> [ 4582.199420] sas: broadcast received: 0
> [ 4584.187387] ata6.00: NCQ Send/Recv Log not supported
> [ 4584.194424] ata6.00: NCQ Send/Recv Log not supported
> [ 4584.200434] ata6.00: configured for UDMA/133
> [ 4584.204718] ata6: EH complete
> [ 4584.207714] sas: --- Exit sas_scsi_recover_host: busy: 0 failed: 2 
> tries: 1
> [ 4584.207719] sas: broadcast received: 0
> [ 4584.218446] sas: REVALIDATING DOMAIN on port 0, pid:15800
> [ 4584.224907] sas: Expander phy change count has changed
> [ 4584.230935] sas: ex 500e004aaaaaaa1f phy8 originated BROADCAST(CHANGE)
> [ 4584.237667] sas: ex 500e004aaaaaaa1f phy 0x8 broadcast flutter
> [ 4584.242183] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
> [ 4584.245029] sas: done REVALIDATING DOMAIN on port 0, pid:15800, res 0x0
> [ 4584.249321] sas: ata6: end_device-0:0:8: cmd error handler
> [ 4584.261444] sas: ata1: end_device-0:0:0: dev error handler
> [ 4584.261450] sas: ata2: end_device-0:0:1: dev error handler
> [ 4584.261455] sas: ata3: end_device-0:0:3: dev error handler
> [ 4584.261461] sas: ata4: end_device-0:0:4: dev error handler
> [ 4584.261465] sas: ata5: end_device-0:0:5: dev error handler
> [ 4584.261467] sas: ata6: end_device-0:0:8: dev error handler
> [ 4584.266971] sd 0:0:5:0: [sdf] tag#0 UNKNOWN(0x2003) Result: 
> hostbyte=0x00 driverbyte=0x08
> [ 4584.302489] sd 0:0:5:0: [sdf] tag#0 Sense Key : 0x5 [current]
> [ 4584.308318] sd 0:0:5:0: [sdf] tag#0 ASC=0x21 ASCQ=0x4
> [ 4584.313453] sd 0:0:5:0: [sdf] tag#0 CDB: opcode=0x8a 8a 00 00 00 00 
> 00 03 87 08 00 00 00 04 00 00 00
> [ 4584.322579] print_req_error: I/O error, dev sdf, sector 59181056
> [ 4584.328614] sas: --- Exit sas_scsi_recover_host: busy: 0 failed: 1 
> tries: 1
> [ 4584.358188] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
> [ 4584.364022] sas: ata6: end_device-0:0:8: cmd error handler
> [ 4584.369532] sas: ata1: end_device-0:0:0: dev error handler
> [ 4584.369539] sas: ata2: end_device-0:0:1: dev error handler
> [ 4584.369558] sas: ata3: end_device-0:0:3: dev error handler
> [ 4584.369564] sas: ata4: end_device-0:0:4: dev error handler
> [ 4584.369573] sas: ata5: end_device-0:0:5: dev error handler
> [ 4584.369621] sas: ata6: end_device-0:0:8: dev error handler
> [ 4584.369856] sd 0:0:5:0: [sdf] tag#0 UNKNOWN(0x2003) Result: 
> hostbyte=0x00 driverbyte=0x08
> [ 4584.369859] sd 0:0:5:0: [sdf] tag#0 Sense Key : 0x5 [current]
> [ 4584.369861] sd 0:0:5:0: [sdf] tag#0 ASC=0x21 ASCQ=0x4
> [ 4584.369864] sd 0:0:5:0: [sdf] tag#0 CDB: opcode=0x8a 8a 00 00 00 00 
> 00 03 87 0c 00 00 00 04 00 00 00
> [ 4584.369865] print_req_error: I/O error, dev sdf, sector 59182080
> [ 4584.436640] sas: --- Exit sas_scsi_recover_host: busy: 0 failed: 1 
> tries: 1
> [ 4584.680697] device-mapper: zoned reclaim: (sdf): Align zone 112 wp 0 
> to 57856 (wp+57856) blocks failed -5
> 
> 
> With another way, just go through 1 and 2, and then use dd to do flush 
> data into block device. The rnd zone size is 23GB, use dd to do write in 
> this area won't trigger error, but while try to write the first sector 
> in seq zone, it will trigger problem as follow.
> [ 4779.730183] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
> [ 4779.736031] sas: ata6: end_device-0:0:8: cmd error handler
> [ 4779.741546] sas: ata1: end_device-0:0:0: dev error handler
> [ 4779.741550] sas: ata2: end_device-0:0:1: dev error handler
> [ 4779.741575] sas: ata3: end_device-0:0:3: dev error handler
> [ 4779.741585] sas: ata4: end_device-0:0:4: dev error handler
> [ 4779.741593] sas: ata5: end_device-0:0:5: dev error handler
> [ 4779.741598] sas: ata6: end_device-0:0:8: dev error handler
> [ 4779.741859] sd 0:0:5:0: [sdf] tag#0 UNKNOWN(0x2003) Result: 
> hostbyte=0x00 driverbyte=0x08
> [ 4779.741863] sd 0:0:5:0: [sdf] tag#0 Sense Key : 0x5 [current]
> [ 4779.741865] sd 0:0:5:0: [sdf] tag#0 ASC=0x21 ASCQ=0x4
> [ 4779.741868] sd 0:0:5:0: [sdf] tag#0 CDB: opcode=0x8a 8a 00 00 00 00 
> 00 03 00 00 00 00 00 00 01 00 00
> [ 4779.741870] print_req_error: I/O error, dev sdf, sector 50331648
> [ 4779.808664] sas: --- Exit sas_scsi_recover_host: busy: 0 failed: 1 
> tries: 1
> 
> Since there is only one device, i cannot contrast the appearance with 
> other SMR block device. Can you help me?
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
> 


-- 
Damien Le Moal
Western Digital Research
