From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: Adding target device caused an alignment
	inconsistency
Date: Tue, 1 Mar 2016 16:06:49 -0800
Message-ID: <56D62E99.1070707@sandisk.com>
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
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On 03/01/2016 03:43 PM, Bart Van Assche wrote:
> After having run multipath -f + another reconfigure I noticed that the
> optimal_io_size parameter for multipath devices is zero (io_opt) but
> that blk_stack_limits() expects that that parameter is not zero. So i
> tried to repeat the test described in commit
> e9637415a92cf25ad800b7fdeddcd30cce7b44ab:
>
> # modprobe scsi_debug dev_size_mb=10 num_tgts=1 opt_blks=1536
> # lsscsi | grep debug
> [17352:0:0:0]disk    Linux    scsi_debug       0184  /dev/sds
> # cat /sys/block/sds/queue/optimal_io_size
> 1536
> # dmsetup create node --table "0 100 linear /dev/sds 0"
> (hangs in the semop() system call)
> ^C

(again replying to my own e-mail)

Apparently this works fine with kernel v4.5-rc6:

# modprobe scsi_debug dev_size_mb=10 num_tgts=1 opt_blks=1536
# lsscsi | grep debug
[42:0:0:0]   disk    Linux    scsi_debug       0184  /dev/sdai
# cat /sys/block/sdai/queue/optimal_io_size
786432
# dmsetup create node --table "0 100 linear /dev/sdai 0"
# dmsetup table | grep linear
node: 0 100 linear 66:32 0
# dmsetup ls | grep node
node    (254:2)
# cat /sys/block/dm-2/queue/optimal_io_size
786432

I will report this to the proper bugzilla. Sorry for the noise.

Bart.
