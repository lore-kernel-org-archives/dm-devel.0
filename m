From: Konrad Rzeszutek <konrad@virtualiron.com>
Subject: Re: An multipath performance issue on RHEL 5
Date: Tue, 13 Jan 2009 10:23:06 -0500
Message-ID: <20090113152306.GA19158@mars.virtualiron.com>
References: <496C5ABB.8040602@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <496C5ABB.8040602@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
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

On Tue, Jan 13, 2009 at 05:11:23PM +0800, dwu wrote:
> A customer has done a test of multipath on RHEL 5, and he found that the 
> speed is 30-40MB/sec, but it can reach 160MB/sec when using EMC powerpath 

Does it reach that when do a test on individual disks in the setup
with EMC powerpath?

>
> [root@clnode2 ~]# hdparm -t /dev/mapper/mpath0
>
> /dev/mapper/mpath0:
> Timing buffered disk reads: 118 MB in 3.01 seconds = 39.22 MB/sec
> [root@clnode2 ~]# hdparm -t /dev/mapper/mpath5
>
> /dev/mapper/mpath5:
> Timing buffered disk reads: 132 MB in 3.04 seconds = 43.38 MB/sec
> [root@clnode2 tmp]# hdparm -t /dev/sdm
>
> /dev/sdm:
> Timing buffered disk reads: 112 MB in 3.04 seconds = 36.89 MB/sec
> [root@clnode2 tmp]# hdparm -t /dev/sdaa
>
> /dev/sdaa:
> Timing buffered disk reads: 108 MB in 3.02 seconds = 35.81 MB/sec
> [root@clnode2 tmp]# hdparm -t /dev/sdf
>
> /dev/sdf:
> Timing buffered disk reads: read() failed: Input/output error
> [root@clnode2 tmp]# hdparm -t /dev/sdt
>
> /dev/sdt:
> Timing buffered disk reads: read() failed: Input/output error
>

Since you did the test on the underlaying SCSI subsystem (that
was the next thing to test) - which has no connection to multipath
it eliminates the multipath layer. When you do the hdparam test
on RHEL4 OS on those disks - are the numbers the same?

Is your RHEL4 rig the same exact machine with the same exact
fibre connection? You could have the RHEL5 using a 1GB connection
while the RHEL4 might be using 2GB?
