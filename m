From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: dm-rq queue stalls
Date: Wed, 17 Jan 2018 21:49:00 +0000
Message-ID: <1516225739.2820.66.camel@wdc.com>
References: <a096db4d-1c32-4682-844d-4a7fc02d47da@email.android.com>
	<1516218304.2820.51.camel@wdc.com> <20180117201417.GA6455@redhat.com>
	<1516224450.2820.59.camel@wdc.com> <20180117213736.GB6756@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180117213736.GB6756@redhat.com>
Content-Language: en-US
Content-ID: <9F32B2826021114FA3C96BB6BBE7E6DE@namprd04.prod.outlook.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "snitzer@redhat.com" <snitzer@redhat.com>
Cc: "axboe@kernel.dk" <axboe@kernel.dk>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "loberman@redhat.com" <loberman@redhat.com>, "ming.lei@redhat.com" <ming.lei@redhat.com>
List-Id: dm-devel.ids

On Wed, 2018-01-17 at 16:37 -0500, Mike Snitzer wrote:
> How critical is it to have the latest SCSI changes that are queued for
> 4.16?

Hello Mike,

The IB tests I ran do not depend on any recent SCSI initiator (drivers/scsi)
or SRP driver changes. However, if you want to run the SRP drivers on top of
the rdma_rxe driver then you will need the latest version of the SRP initiator
and target drivers, including some patches that are not yet upstream (but
should go upstream soon).

The test I ran may depend on the SCSI target (drivers/target) patches in my
tree. The SCSI target patches in my tree significantly simplify the session
shutdown code. The patch for simplification of session shutdown may be a bug
fix. However, the original code is so hairy that I have not yet tried to figure
out whether or not my changes improve the behavior of the session shutdown code.

Bart.
