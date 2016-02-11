From: Zdenek Kabelac <zdenek.kabelac@gmail.com>
Subject: Re: Occasional dmsetup resume lockups
Date: Thu, 11 Feb 2016 22:26:40 +0100
Message-ID: <56BCFC90.5030508@gmail.com>
References: <20160211204736.GA18164@alpha.arachsys.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20160211204736.GA18164@alpha.arachsys.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

Dne 11.2.2016 v 21:47 Richard Davies napsal(a):
> Hi,
>
> We have been seeing occasional "dmsetup resume" lockups on a variety of
> kernels when swapping tables.
>
> I am wondering if we are making a simple scripting mistake
> (e.g. we do not run "dmsetup suspend", but my impression is that the need
> for this was replaced by INACTIVE tables?)
>
> Alternatively, what can we do to help debug this further, please?
>
>

There could be number of reasons - but since you mention you operate
with life device -  aren't you actually running your 'dmsetup
from a device you manipulate with - aka your root volume ?

lvm2 locks itself into memory to avoid any page swapping issues.

You could also try debugging kernel on serial console with sysrq+t
to see what's get blocked on disk access.

Regards

Zdenek
