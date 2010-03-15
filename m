From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH 4/4] Test chunk size against both origin and
 snapshot sector size
Date: Mon, 15 Mar 2010 11:54:32 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.1003151153300.2471@hs20-bc2-1.build.redhat.com>
References: <Pine.LNX.4.64.1003150201270.12526@hs20-bc2-1.build.redhat.com>
	<20100315145224.GE6853@redhat.com>
	<Pine.LNX.4.64.1003151106290.20210@hs20-bc2-1.build.redhat.com>
	<20100315153031.GA14350@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20100315153031.GA14350@redhat.com>
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
Cc: device-mapper development <dm-devel@redhat.com>, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

> > The Linux bio stack and page cache require that bdev_logical_block_size() 
> > is power of two.
> 
> OK, I'll have a look, but it sounds like we could use:
> (chunk_size & (bdev_logical_block_size(...) - 1))

We could, but it doesn't matter anyway because it's just initialization 
and it's not performance critical.

Mikulas
