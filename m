From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: Re: [RFC PATCH 1/2] dm-mpath: interface change
	for	preparation
Date: Fri, 30 Jan 2009 17:06:21 +0900
Message-ID: <4982B4FD.3070103@ct.jp.nec.com>
References: <0D1E8821739E724A86F4D16902CE275C13FF9B0272@inbmail01.lsi.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <0D1E8821739E724A86F4D16902CE275C13FF9B0272@inbmail01.lsi.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "Chauhan, Vijay" <Vijay.Chauhan@lsi.com>
Cc: device-mapper development <dm-devel@redhat.com>, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

Hi Vijay,

Thank you for the comment.

On 01/30/2009 01:42 PM +0900, Chauhan, Vijay wrote:
> Hi Kiyoshi/Alasdair,
> 
> Just a thought. As we are changing __choose_pgpath parameters
> in this patch, will it be good to use BIO rather than nr_bytes
> as parameter? Availability of BIO in loadbalancing interface can
> provide more flexibility for coming up with new load balancing
> in future.

I understand that very much.
But I'd like to keep independency of path-selector from the type
of I/O structure as much as possible, since both bio-based targets
and request-based targets may want to use the same path-selector
in the future.  (e.g. multipath, which is requset-based,
and mirror, which is bio-based.)

So if we need only a few arguments, non-structured parameters
would be good, I think.
Do you have any idea what other parameters in BIO are useful for
load balancing decision?

Thanks,
Kiyoshi Ueda
