From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: dm-rq queue stalls
Date: Wed, 17 Jan 2018 18:27:05 +0000
Message-ID: <1516213623.2820.30.camel@wdc.com>
References: <1516212342.2820.26.camel@wdc.com>
	<20180117181852.GA5798@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180117181852.GA5798@redhat.com>
Content-Language: en-US
Content-ID: <266FEAB336A2564C94E21D173DAB93B2@namprd04.prod.outlook.com>
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

On Wed, 2018-01-17 at 13:18 -0500, Mike Snitzer wrote:
> But Ming Lei should be able to help make sense of this situation too.
> Also Laurence may be able to help reproduce your specific srp-test on
> his testbed.

Hello Mike,

Something that I should have mentioned in my previous e-mail is that the
command-line option -c for srp-test means "use the rdma_rxe driver over a
local Ethernet interface". So that test can be run in any virtual machine.

The stall also occurs on an IB setup and occurs even more frequent on such
a setup.

Thanks,

Bart.
