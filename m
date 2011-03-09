From: Heinz Mauelshagen <heinzm@redhat.com>
Subject: Re: How does dm-thinp handle the our of space error?
Date: Wed, 09 Mar 2011 09:56:19 +0100
Message-ID: <1299660979.3310.5.camel@o>
References: <AANLkTi=HYPv+U-JiBbjrhAHrZOXVihs2LaGniA_m=r5O@mail.gmail.com>
Reply-To: heinzm@redhat.com, device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <AANLkTi=HYPv+U-JiBbjrhAHrZOXVihs2LaGniA_m=r5O@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
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

On Wed, 2011-03-09 at 11:59 +0800, Xie Gang wrote:
> Hi,
>  
> The storage may run out of space and could not provision the space.
> So, how does thinp handle such error since thinp is transparent to
> uper layer filesystem?

It either postpones the bios until userspace has reacted growing the
pool _or_ it errors the ios depending on the related policy set.

This is defined by constructore parameter
 * 4: policy = "error|postpone":
 *             if pool runs full, bios will be errored or postponed
 *             (ie. application writes will stall)

Heinz

>  
> Thanks,
> 
> -- 
> Xie Gang
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
