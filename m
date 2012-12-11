From: Phillip Susi <psusi@cfl.rr.com>
Subject: Re: dm-cache module
Date: Tue, 11 Dec 2012 16:49:15 -0500
Message-ID: <50C7AA5B.1040601@cfl.rr.com>
References: <4BA5623F.8040502@daevel.fr> <20100321033704.GA6448@redhat.com>
	<15606e421003202156n21de56a6n868f84bf737cce51@mail.gmail.com>
	<1269270327.21395.42.camel@o> <4BD7906E.6010602@daevel.fr>
	<1272442907.2031.79.camel@o> <1272463344.2031.91.camel@o>
	<4DE93315.3090903@cfl.rr.com> <1307354794.752.7.camel@o>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1307354794.752.7.camel@o>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: heinzm@redhat.com, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Well here we are a year and a half later, and I still don't see this.
Am I missing it or has it not materialized?

On 6/6/2011 6:06 AM, Heinz Mauelshagen wrote:
> On Fri, 2011-06-03 at 15:16 -0400, Phillip Susi wrote:
>> What ever came of this?  It doesn't look like either competing cache 
>> target has made it into mainline yet.
> 
> Right.
> 
> We are working on a device-mapper caching target which shares code for
> block, btree and transaction management with thin provisioning and
> multiple snapshot targets which are aiming to go upstream shortly. This
> is aiming at code sharing rather than distinct implementations of the
> aforementioned functionalities.
> All of those will receive LVM2 support as we go.
> 
> Heinz
