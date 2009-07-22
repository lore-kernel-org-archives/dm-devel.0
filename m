From: Milan Broz <mbroz@redhat.com>
Subject: Re: [PATCH][RFC] Emulate BLKRRPART on device-mapper
Date: Wed, 22 Jul 2009 10:12:56 +0200
Message-ID: <4A66CA08.9080509@redhat.com>
References: <200907081414.50698.knikanth@suse.de>
	<20090720182324.GD32330@agk-dp.fab.redhat.com>
	<4A65E912.6020706@redhat.com> <4A66BA60.2020500@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4A66BA60.2020500@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Hannes Reinecke <hare@suse.de>
Cc: Nikanth Karthikesan <knikanth@suse.de>, device-mapper development <dm-devel@redhat.com>, Alasdair G Kergon <agk@redhat.com>, Jens Axboe <jens.axboe@oracle.com>
List-Id: dm-devel.ids

Hannes Reinecke wrote:
>> +	/* partitions handled in userspace, just send change event */
>> +	if (disk_userspace_partitions(disk)) {
>> +		kobject_uevent(&disk_to_dev(disk)->kobj, KOBJ_CHANGE);
>> +		return 0;
>> +	}
>> +
> Wrong. If you do it here, you'll never be able to catch any size changes
> of the disk. You'll have to move it to after the 'bdev->bd_invalidated = 0'
> line.

Yes, for non-DM devices which want to use that flag.

For device-mapper device, size can change only by mapping table change
which always generate change uevent.

> I would suggest renaming it to GENHD_FL_USERSPACE_PARTITIONS, as this is
> more in line with the function of the flag.

no problem here:-)

Milan
