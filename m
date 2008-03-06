From: syrius.ml@no-log.org
Subject: Re: multipath and iscsi nullio/dm-zero tests
Date: Thu, 06 Mar 2008 22:51:31 +0100
Message-ID: <87hcfjehw7.87fxv3ehw7@87ejanehw7.message.id>
References: <87ablfjsem.878x0zjsem@877igjjsem.message.id>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <87ablfjsem.878x0zjsem@877igjjsem.message.id> (syrius ml's
	message of "Tue\, 04 Mar 2008 00\:32\:01 +0100")
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

syrius.ml@no-log.org writes:

> dd if=/dev/zero of=/dev/dm-8 bs=4k count=10M
> 10485760+0 records in
> 10485760+0 records out
> 42949672960 bytes (43 GB) copied, 137.751 seconds, 312 MB/s
>
> dd of=/dev/null if=/dev/dm-8 bs=4k count=10M
> 10485760+0 records in
> 10485760+0 records out
> 42949672960 bytes (43 GB) copied, 364.401 seconds, 118 MB/s

sorry to insist.
Can anybody give me a hint about my "issues" ?

-- 
