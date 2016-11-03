From: Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com>
Subject: Re: Multipaths getting cross-linked on IBM Power-8 after
 adding wwids
Date: Thu, 3 Nov 2016 11:13:30 -0200
Message-ID: <f6d6500d-9b82-4c7b-0fbd-b6cbfac09cd9@linux.vnet.ibm.com>
References: <3B555D3246724D4EB3187D3CFCD9D0482DC98E20@NOTTSVEX01.uk.csi>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <3B555D3246724D4EB3187D3CFCD9D0482DC98E20@NOTTSVEX01.uk.csi>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Andy D'Arcy Jewell <Andy.D'ArcyJewell@csiltd.co.uk>, "dm-devel@redhat.com" <dm-devel@redhat.com>
Cc: Mike Leigh <Mike.Leigh@csiltd.co.uk>
List-Id: dm-devel.ids

Hey Andy,

On 10/31/2016 11:40 AM, Andy D'Arcy Jewell wrote:

 > We have been battling with this issue with help from IBM support,
 > but I'd like to understand the situation a bit better, so thought
 > I'd go to the source ;-)

Thanks for reaching out; you've found someone. ;)

> cat /etc/issue
> IBM_PowerKVM release 2.1.1 build 62 service (pkvm2_1_1)
> Kernel \r on a \m (\l)

The multipath-tools source code in PowerKVM 2.1.1 is older than
what the upstream community works with -- this problem probably
doesn't occur w/ the upstream sources.

So, let me help you off list; I'll follow up w/ you privately.

> So my questions are:
> a) Is this expected behaviour or a bug?

No, data corruption and WWID confusion are not expected; although
the correspondence between bindings/wwids in initramfs and rootfs
has been required on multipath-tools/distros for some time now.

If you're right about no reboots (so the difference between wwids/
bindings in initramfs & rootfs is not a problem), then this is a
bug.

> b) If a bug, is there a fix?

Once we confirm the initramfs/rootfs mismatch is not a concern,
and this is reproducible, yes, I'll be happy to land you a fix.

> c) Is there any further information you need to help diagnose?

Yup.

1) Is this problem reproducible? ie, you can recreate it with a
some steps in house?

2) If so, please enable verbosity 3 in multipath.conf, restart
multipathd, and try to reproduce the problem. Then let's check
the logs.

I'll reply to your e-mail so we can follow up.

cheers,

-- 
Mauricio Faria de Oliveira
IBM Linux Technology Center
