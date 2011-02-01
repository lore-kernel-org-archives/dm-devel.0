From: Malahal Naineni <malahal@us.ibm.com>
Subject: Re: multipath: change the DEFAULT_MINIO for the request
 based multipath
Date: Tue, 1 Feb 2011 01:51:37 -0800
Message-ID: <20110201095137.GA1951@us.ibm.com>
References: <4D392FBD.5080207@ce.jp.nec.com>
	<1295599627.23625.16.camel@zezette>
	<20110121141204.GE30411@redhat.com>
	<1295621193.23625.37.camel@zezette>
	<20110121173930.GB20278@us.ibm.com>
	<4D3E9020.6010009@ce.jp.nec.com> <20110126022307.GA512@us.ibm.com>
	<1296518031.6483.106.camel@zezette>
	<20110201081303.GA31174@us.ibm.com>
	<1296550809.6483.132.camel@zezette>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1296550809.6483.132.camel@zezette>
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

Christophe Varoqui [christophe.varoqui@gmail.com] wrote:
> That's because there are /etc/multipath.conf in the wild right now,
> created with non rq capable kernels. rr_min_io meant something then. It
> seems not fair to change the meaning of that tunable upon upgrade.
> People do cut-and-paste from old docs (corp or googled) and from peers
> systems ... this approach minimize the risk of killing the perf by
> accident. And I don't see downsides.

Agreed.

>  dm_drv_get_rq (void)
>  {
>         unsigned int minv_dmrq[3] = {1, 1, 0};
> -       unsigned int *v;
> -
> -       v = zalloc(3);
> -       if (!v)
> -               return 0;
> +       unsigned int version[3] = {0, 0, 0};
> +        unsigned int * v = version;

You could just say 'unsigned int v[3] = {0, 0, 0};' and remove the extra
pointer variable.

> +       unsigned int version[3] = {0, 0, 0};
> +        unsigned int * v = version;

Same as above.

Looks good. Thank you.

--Malahal.
