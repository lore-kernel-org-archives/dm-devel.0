From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH] dm-crypt: limit the number of allocated pages
Date: Sat, 19 Aug 2017 00:59:12 +0000
Message-ID: <1503104350.2620.1.camel@wdc.com>
References: <alpine.LRH.2.02.1708132240130.18210@file01.intranet.prod.int.rdu2.redhat.com>
	<22930.1510.64868.411152@quad.stoffel.home>
	<alpine.LRH.2.02.1708142001390.24994@file01.intranet.prod.int.rdu2.redhat.com>
	<22933.58742.629722.398176@quad.stoffel.home>
	<alpine.LRH.2.02.1708181253450.30782@file01.intranet.prod.int.rdu2.redhat.com>
	<22935.14792.87054.266777@quad.stoffel.home>
	<alpine.LRH.2.02.1708181523190.30782@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <alpine.LRH.2.02.1708181523190.30782@file01.intranet.prod.int.rdu2.redhat.com>
Content-Language: en-US
Content-ID: <49B975ED7F8AC74D8F96D232A7347C31@namprd04.prod.outlook.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "john@stoffel.org" <john@stoffel.org>, "mpatocka@redhat.com" <mpatocka@redhat.com>
Cc: "msnitzer@redhat.com" <msnitzer@redhat.com>, "tom.ty89@gmail.com" <tom.ty89@gmail.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "okozina@redhat.com" <okozina@redhat.com>, "hch@lst.de" <hch@lst.de>, "mbroz@redhat.com" <mbroz@redhat.com>
List-Id: dm-devel.ids

On Fri, 2017-08-18 at 20:18 -0400, Mikulas Patocka wrote:
> Some times ago I made a patch that limits the number of in-flight bios in 
> device mapper - see this:
> http://people.redhat.com/~mpatocka/patches/kernel/dm-limit-outstanding-bios/

It would be great to have this functionality upstream ... Do you have any
plans to submit this patch to the device mapper maintainer, Mike Snitzer?

Bart.
