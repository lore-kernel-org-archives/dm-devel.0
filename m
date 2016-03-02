From: Zdenek Kabelac <zkabelac@redhat.com>
Subject: Re: Adding target device caused an alignment
	inconsistency
Date: Wed, 2 Mar 2016 09:41:59 +0100
Message-ID: <56D6A757.5020706@redhat.com>
References: <56D616DF.3010505@sandisk.com> <56D6290D.1080906@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <56D6290D.1080906@sandisk.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Bart Van Assche <bart.vanassche@sandisk.com>, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Dne 2.3.2016 v 00:43 Bart Van Assche napsal(a):
> On 03/01/2016 02:25 PM, Bart Van Assche wrote:
>> With kernel 4.4.0 (openSuSE Tumbleweed) I see the following message
>> appear systematically in the kernel log if udev reports a new path to
>> multipathd:
>>
>> [958779.753012] device-mapper: table: 254:0: adding target device sdg
>> caused an alignment inconsistency: physical_block_size=4096,
>> logical_block_size=512, alignment_offset=0, start=0
>>
>> This did not happen with previous kernel versions. This causes the
>> initiator to report the new paths as faulty until I run the following
>> command:
>>
>> echo reconfigure | multipathd -k
>>
>> Is this a know issue?
>
> (replying to my own e-mail)
>
> After having run multipath -f + another reconfigure I noticed that the
> optimal_io_size parameter for multipath devices is zero (io_opt) but that
> blk_stack_limits() expects that that parameter is not zero. So i tried to
> repeat the test described in commit e9637415a92cf25ad800b7fdeddcd30cce7b44ab:
>
> # modprobe scsi_debug dev_size_mb=10 num_tgts=1 opt_blks=1536
> # lsscsi | grep debug
> [17352:0:0:0]disk    Linux    scsi_debug       0184  /dev/sds
> # cat /sys/block/sds/queue/optimal_io_size
> 1536
> # dmsetup create node --table "0 100 linear /dev/sds 0"
> (hangs in the semop() system call)
> ^C
>


It's known  there was a broken  patch in  4.5-rc0-rc4
which mistakenly used  'sector' units instead of bytes of
optimal_io_size.

So it seems someone has backported this broken patch without the fixing part 
to the stable 4.4 kernel.

Zdenek
