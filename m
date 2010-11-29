From: Christophe Varoqui <christophe.varoqui@gmail.com>
Subject: Re: [Multipath DOCS] Some possibly deprecated info
Date: Mon, 29 Nov 2010 23:37:43 +0100
Message-ID: <1291070263.25014.21.camel@zezette>
References: <4BCB3327.1040407@il.ibm.com>
Reply-To: christophe.varoqui@opensvc.com,
        device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4BCB3327.1040407@il.ibm.com>
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

On dim., 2010-04-18 at 19:28 +0300, Oren Held wrote:
> Hello,
> 
> Inhttp://christophe.varoqui.free.fr/refbook.html, "the multipathd
> daemon" pargagraph states:
> "This daemon executes the external multipath config tool when events
> occur."
> 
> As far as I understand from the current code this is no more true, for
> multipathd uses libmultipath to create new maps, and not real
> execution of an external binary.
> 
You're right. I will update the doc.

> (And.. of course it could be easier if docs were moved to some wiki
> space..)
> 
Actually it was on a wiki. But I got more defacement than
contributions ...

Thanks,

-- 
Christophe Varoqui <christophe.varoqui@opensvc.com>
OpenSVC
