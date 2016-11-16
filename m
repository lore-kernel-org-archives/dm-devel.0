From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH 2/7] dm: Simplify dm_table_determine_type()
Date: Wed, 16 Nov 2016 13:53:24 -0800
Message-ID: <5b14e4ad-3ce3-2deb-f120-946c756b2930@sandisk.com>
References: <e83f8718-9e73-5544-3bcc-4d9851b90ba1@sandisk.com>
	<4b4da27f-1540-db69-dce7-431b61b164ef@sandisk.com>
	<20161116145426.GA23071@redhat.com>
	<87380b73-6863-d19d-8d16-613fb097e07b@sandisk.com>
	<20161116211101.GA24875@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20161116211101.GA24875@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On 11/16/2016 01:11 PM, Mike Snitzer wrote:
> On Wed, Nov 16 2016 at  3:14pm -0500,
> Bart Van Assche <bart.vanassche@sandisk.com> wrote:
>> After having added WARN_ON_ONCE(sq_count == 0 && mq_count == 0)
>> close to the end of dm_table_determine_type() the following output
>> appeared:
>>
>> WARNING: CPU: 0 PID: 2458 at drivers/md/dm-table.c:966
>> dm_table_complete+0x60e/0x6b0 [dm_mod]
>> [ ... ]
>> Call Trace:
>>  [<ffffffff81329b45>] dump_stack+0x68/0x93
>>  [<ffffffff810650e6>] __warn+0xc6/0xe0
>>  [<ffffffff810651b8>] warn_slowpath_null+0x18/0x20
>>  [<ffffffffa0021c8e>] dm_table_complete+0x60e/0x6b0 [dm_mod]
>>  [<ffffffffa00245cd>] table_load+0x13d/0x330 [dm_mod]
>>  [<ffffffffa0024490>] ? retrieve_status+0x1b0/0x1b0 [dm_mod]
>>  [<ffffffffa0025145>] ctl_ioctl+0x1f5/0x520 [dm_mod]
>>  [<ffffffffa002547e>] dm_ctl_ioctl+0xe/0x20 [dm_mod]
>>  [<ffffffff811f26cf>] do_vfs_ioctl+0x8f/0x6b0
>>  [<ffffffff811ff41c>] ? __fget+0x10c/0x200
>>  [<ffffffff811ff310>] ? expand_files+0x2a0/0x2a0
>>  [<ffffffff811f2d2c>] SyS_ioctl+0x3c/0x70
>>  [<ffffffff8163f9aa>] entry_SYSCALL_64_fastpath+0x18/0xad
>>
>> Is it intentional that dm_table_determine_type() can get called for
>> a dm device with an empty table?
>
> What table were you trying to load when this occurred?
>
> Targets like the 'error' target don't have any devices.

Hello Mike,

This was the result of a table load issued by multipathd. Do you want me 
to add more debug code such that the details of the table load request 
are logged?

Thanks,

Bart.
