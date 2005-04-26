From: Mikael Andersson <mikael@karett.se>
Subject: Update: Disk io deadlocks during large-file io
Date: Tue, 26 Apr 2005 19:13:31 +0200
Message-ID: <426E76BB.2060201@karett.se>
References: <4267F307.8080009@karett.se>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4267F307.8080009@karett.se>
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
Cc: axboe@suse.de
List-Id: dm-devel.ids

With md raid1 instead of dm-mirror i get no lockups during similar
workloads or any other workload i've managed to produce. Everything is
the same except that i'm using md instead of dm-mirror.

>Disk io deadlocks during large-file io.
>
>During heavy disk io involving creating large files, some parts
>of the kernel locks up. In most cases all disk output becomes
>impossible, but sometimes you can write small things to disk, like
>echo > test.txt might work sometimes. On reiserfs the lockups tend to be
>more severe. The problem only occurs when i have both disks in my device
>mapper mirror installed. if i remove one of the SATA cables, everything
>works perfectly , except that devicemapper complains that the mirror is
>degraded.
>  
>
See previous mail for complete information about the problem, or feel
free to ask me for any further details.
I'll try running dm-mirror on two other disks i've got which is on
another controller to see if i can reproduce the problem there also.

/Mikael Andersson
