From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: dm-rq queue stalls
Date: Wed, 17 Jan 2018 19:29:29 +0000
Message-ID: <1516217368.2820.39.camel@wdc.com>
References: <1516212342.2820.26.camel@wdc.com>
	<20180117181852.GA5798@redhat.com>
	<1516213796.31083.2.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1516213796.31083.2.camel@redhat.com>
Content-Language: en-US
Content-ID: <0D71945F5194AF48B7DC3419B0BB9315@namprd04.prod.outlook.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "loberman@redhat.com" <loberman@redhat.com>, "snitzer@redhat.com" <snitzer@redhat.com>
Cc: "axboe@kernel.dk" <axboe@kernel.dk>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "ming.lei@redhat.com" <ming.lei@redhat.com>
List-Id: dm-devel.ids

On Wed, 2018-01-17 at 13:29 -0500, Laurence Oberman wrote:
> If you can share your exact fio run scriptparameters I can try this on
> my mlx5 test bed using the same kernel you are using.
> Ming has access to the same test bed as well.
> Is this direct to devices, or on a file system etc. etc.
> 
> Are these from the tests directory in the srp test kit of yours.

Hello Laurence,

This issue can be reproduced as follows:
* Clone the block-scsi-for-next branch from https://github.com/bvanassche/linux
  (commit cd0b6b9f8779).
* Clone the srp-test project from https://github.com/bvanassche/srp-test.
* Modify /etc/multipath.conf as indicated in the README.md file of the srp-test
  project and restart multipathd.

If you prefer the rdma_rxe driver, run the following command:

srp-test/run_tests -c -d -r 10 -q 1 -t 02-mq -e kyber

Or if you prefer to run the test against an IB driver (mlx4, mlx5, ..) on an IB
system, run the following command:

srp-test/run_tests -d -r 10 -q 1 -t 02-mq

If running one of the above commands once would not be sufficient to trigger the
lockup, rerun the command a few times.

Bart.
