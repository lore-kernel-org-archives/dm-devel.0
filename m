From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: Re: multipath-tools and queue-length/service-time path
	selectors oops
Date: Tue, 15 Sep 2009 11:10:29 +0900
Message-ID: <4AAEF795.9060301@ct.jp.nec.com>
References: <20090911213435.GA1590@thumper2> <4AADA753.6000205@ct.jp.nec.com>
	<20090914151251.GA17421@thumper2>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20090914151251.GA17421@thumper2>
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

On 09/15/2009 12:12 AM +0900, Andy wrote:
> On Mon, Sep 14, 2009 at 11:15:47AM +0900, Kiyoshi Ueda wrote:
>> Hi Andy,
>>
>> Thank you for reporting this.
>>
>> On 2009/09/12 6:34 +0900, Andy wrote:
>>> When I try to change the path selector in multipath.conf to queue-length or
>>> service-time I get a kernel oops.
>> I'd like to see the information of your environment, so could you
>> give me the followings?
> 
> This is a test system, so there is no problem try things out on it.
> 
> version information:
> 
> Distribution : Debian squeeze/sid
> kernel: 2.6.31
> 
> multipath-tools v0.4.9 (04/04, 2009)
> 
> dmsetup --version
> Library version:   1.02.36 (2009-08-06)
> Driver version:    4.15.0
> 
> 
> multipath.conf part:
> 
> multipath {
> 	wwid 			350002ac000020246
> 	path_grouping_policy	multibus
> 	# path_selector		"round-robin 0"
> 	path_selector		"queue-length"
> 	rr_min_io		8	# u02 io count
> 	alias 			u02 
> }

OK, thanks.
Please specify the path_selector part in the same way as
round-robin like below:

	path_selector	"queue-length 0"

Note that '0' is the required argument which specifies the number
of path_selector parameters.

I think this is a bug in the parameter parsing of multipath target
driver, not queue-length/service-time specific.

Thanks,
Kiyoshi Ueda
