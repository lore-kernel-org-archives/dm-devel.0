From: Hannes Reinecke <hare@suse.de>
Subject: Re: deterministic io throughput in multipath
Date: Mon, 19 Dec 2016 13:09:00 +0100
Message-ID: <dd06c6d1-5b0e-a06c-6923-8caee729fd6c@suse.de>
References: <1649d4b8538d4b4cb1efacdfe8cf31eb@BRMWP-EXMB12.corp.brocade.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1649d4b8538d4b4cb1efacdfe8cf31eb@BRMWP-EXMB12.corp.brocade.com>
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

On 12/19/2016 12:50 PM, Muneendra Kumar M wrote:
> Customers using Linux host (mostly RHEL host) using a SAN network for
> block storage, complain the Linux multipath stack is not resilient to
> handle non-deterministic storage network behaviors. This has caused many
> customer move away to non-linux based servers. The intent of the below
> patch and the prevailing issues are given below. With the below design
> we are seeing the Linux multipath stack becoming resilient to such
> network issues. We hope by getting this patch accepted will help in more
> Linux server adoption that use SAN network.
> =

> I have already sent the design details to the community in a different
> mail chain and the details are available in the below link.
> =

> https://www.redhat.com/archives/dm-devel/2016-December/msg00122.html.
> =

> Can you please go through the design and send the comments to us.  =

> =

This issue is coming up from time to time.
Standard answer here is that  using 'service-time' as a path selector
_should_ already give you the expected results; namely any path
exhibiting intermediate I/O errors should have a higher latency than any
functional path.
Hence the 'service-time' path selector should switch away from those
paths automatically.

Have you tried this?

Cheers,

Hannes
-- =

Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
