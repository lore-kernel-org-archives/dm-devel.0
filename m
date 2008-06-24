From: =?ISO-8859-1?Q?Finnur_=D6rn_Gu=F0mundsson?= <finnzi@finnzi.com>
Subject: Re: multipathd dies at startup
Date: Tue, 24 Jun 2008 23:50:02 +0000
Message-ID: <4861882A.4020801@finnzi.com>
References: <6FFEF66445B249919BAE6BA748041FE7@geoffPC>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <6FFEF66445B249919BAE6BA748041FE7@geoffPC>
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

Geoff Galitz wrote:
>
> I am trying to get dm-multipath configured to support my iSCSI setup, but I
> have a problem with multipathd dieing silently at startup.
>
> kernel 2.6.18-53.1.21.el5
> package: device-mapper-multipath-0.4.7-12.el5_1.4
> distro: Centos 5.1
>
> Multpath config:
>
>
>
> -----------------------------------
> # Blacklist all devices by default. Remove this to enable multipathing
> # on the default devices.
> blacklist {
> devnode "*"
> }
>
> blacklist_exceptions {
> device {
> vendor "IET" 
> product "VIRTUAL-DISK"
> }
> }
>
> multipaths {
> multipath {
> wwid 14945540000000000000000000100000037800f000000d00f
> alias yellow
> path_grouping_policy multibus
> path_checker readsector0
> path_selector "round-robin 0"
> failback immediate
> rr_weight priorities
> no_path_retry 5
> }
> }
>
> device {
> vendor "IET"
> product "VIRTUAL-DISK"
> path_grouping_policy failover
> features "1 queue_if_no_path"
> failback immediate
> }
> }
>
>
>
>
> Geoff Galitz
> Blankenheim NRW, Deutschland
> http://www.galitz.org
>
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
>   
Hi,
Having recently hit the same issue, it was a SELinux problem in my case.
Try: setenforce 0 ; service multipathd restart

See if it works for you. I also remember seeing a fix from RHEL/CentOS 
regarding this.

Thanks,
Finnur
