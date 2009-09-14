From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: Re: multipath-tools and queue-length/service-time path
	selectors oops
Date: Mon, 14 Sep 2009 11:15:47 +0900
Message-ID: <4AADA753.6000205@ct.jp.nec.com>
References: <20090911213435.GA1590@thumper2>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20090911213435.GA1590@thumper2>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
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

Hi Andy,

Thank you for reporting this.

On 2009/09/12 6:34 +0900, Andy wrote:
> When I try to change the path selector in multipath.conf to queue-length or
> service-time I get a kernel oops.

I'd like to see the information of your environment, so could you
give me the followings?
  - multipath.conf which causes the oops.
  - The output of "multipath -v3" when the oops occurs.
  - Your distribution and its version.
  - The version of multipath-tools package (e.g. device-mapper-multipath in RHEL).
  - You don't hit the oops when you use round-robin, right?
    If so, can you give me the result of the following commands after you
    configure your multipath device using round-robin?
      * "multipath -ll"
      * "dmsetup table"

Thanks,
Kiyoshi Ueda
