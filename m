From: Ray Van Dolson <rvandolson@esri.com>
Subject: Re: multipathd: sdc: readsector0 checker reports path
	is down
Date: Thu, 8 Jan 2009 12:16:50 -0800
Message-ID: <20090108201648.GA8583@esri.com>
References: <20090108193137.GA3953@esri.com>
	<20090108195643.GB20058@mars.virtualiron.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20090108195643.GB20058@mars.virtualiron.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "open-iscsi@googlegroups.com" <open-iscsi@googlegroups.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Thu, Jan 08, 2009 at 11:56:43AM -0800, Konrad Rzeszutek wrote:
> 
> On Thu, Jan 08, 2009 at 11:31:38AM -0800, Ray Van Dolson wrote:
> > I'm still getting the hang of iSCSI and multipath, so bear with me if
> > this is a FAQ that I've missed...
> > 
> > I have a host attaching to an MD3000i via iSCSI/dm-multipath that is
> > working but showing a lot of the following errors in syslog:
> > 
> >   multipathd: sdc: readsector0 checker reports path is down
> 
> You are using the wrong path checker, wrong path priority program,
> and no hardware path checker :-(
> 
> Here is what you need in your multipath.conf file:
> 
>  #   
>     # DELL :D3000i :: Active-Passive RDAC
>     # Note: The same as the IBM DS3300
>     #   
>     device {
>         vendor          "DELL"
>         product         "MD3000i"
>         product_blacklist   "Universal Xport"
>         features        "1 queue_if_no_path"
>         path_grouping_policy    group_by_prio
>         hardware_handler    "1 rdac"
>         path_checker        rdac
>         prio            "rdac"
>         failback        immediate
>     }   
> 
> 
> Thought you might need to replace the 'prio	"rdac"' with
> 'prio_callout	"/sbin/mpath_prio_rdac" as I think RHEL5/CentOS5 uses
> the old calling convention.
> 
> This should get rid of your down errors and show your passive/active path
> properly.

Thanks.  I had to remove the features line -- got an Unrecognised
feature request error otherwise.

Thanks again,
Ray
