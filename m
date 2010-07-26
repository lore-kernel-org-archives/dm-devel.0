From: Mikulas Patocka <mpatocka@redhat.com>
Subject: BIO_RW_SYNCIO
Date: Mon, 26 Jul 2010 17:53:40 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.1007261747560.12939@hs20-bc2-1.build.redhat.com>
References: <Pine.LNX.4.64.0904161948420.312@hs20-bc2-1.build.redhat.com>
	<20090417063615.GE4593@kernel.dk>
	<Pine.LNX.4.64.0904200220290.22707@hs20-bc2-1.build.redhat.com>
	<20090421072903.GY4593@kernel.dk>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20090421072903.GY4593@kernel.dk>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Jens Axboe <jens.axboe@oracle.com>
Cc: dm-devel@redhat.com, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

Hi Jens

I found out that when I remove BIO_RW_SYNCIO from dm-kcopyd.c, performance 
when writing to the snapshot origin is increased twice. In this workload, 
snapshot driver reads a lot of 8k chunks from one place on the disk and 
writes them to the other place on the same disk. Without BIO_RW_SYNCIO, it 
is twice faster with CFQ scheduler.

What does BIO_RW_SYNCIO exactly do? Does it attempt to decrease latency 
and decrease throughput? (so that disk head seeks more between the source 
and destination and it causes performance degradation) Is there some 
general guidance, when use BIO_RW_SYNCIO and when not?

Mikulas
