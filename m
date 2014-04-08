From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 0/9] dm-crypt patches
Date: Tue, 8 Apr 2014 11:44:17 -0400
Message-ID: <20140408154416.GB4723@redhat.com>
References: <alpine.LRH.2.02.1404051359500.8509@file01.intranet.prod.int.rdu2.redhat.com>
	<534414DD.1040500@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <534414DD.1040500@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Ondrej Kozina <okozina@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>, Mikulas Patocka <mpatocka@redhat.com>
List-Id: dm-devel.ids

On Tue, Apr 08 2014 at 11:25am -0400,
Ondrej Kozina <okozina@redhat.com> wrote:

> Hi,
> 
> I ran all tests again and with new version and everything passed
> even on raid5 back end, so it's right time to paste here some
> performance results:

Thanks for sharing the results.  The system is a pretty low-end machine,
certainly doesn't showcase the intended configuration (improved CPU
scalability on a system with many cores).

BUT it is a useful data point to have.  Because it reflects that the
improvements are realized even on systems without many cores or AES.

> Requirements:
> ------------
> http://okozina.fedorapeople.org/dmcrypt-tests.tar.xz
> compiled fio package
> 
> Performance tests are based on script in subdirectory 1/ in
> http://okozina.fedorapeople.org/dmcrypt-tests.tar.xz
> 
> The result tables were aggregated from output of following fio command:
> 
> fio --output=log --latency-log=log --bandwidth-log=log \
> --name=global --rw=$3 --size=1G --bsrange=1k-128k \
> --filename=$1 \
> --name=job1 --name=job2 --name=job3 --name=job4 \
> --end_fsync=1
> 
> $1 - test device
> $3 - read/write mode see explanation of TEST NAME column below

How is it that you've extracted these results from the test run?  I'd be
open to rerunning the same on my testbed (1 Intel Xeon E5649 Westmere-EP
with 12 logical cores, AES, and 6 SAS devices for RAID, 1 STEC PCIe SSD)

I could also yield this testbed to you if that'd be easier than you
telling me how to extract the test results.

BTW, it seems odd to me that the tests run all the fsx and dt tests yet
only the FIO tests are what you're reporting.. would save time to just
disable the non-fio tests wouldn't it?
