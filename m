From: "Geoff Galitz" <geoff@galitz.org>
Subject: RE: multipathd dies at startup
Date: Wed, 25 Jun 2008 11:40:59 +0200
Message-ID: <8C152752565D473EA81F20817D4B0E7A@geoffPC>
References: <6FFEF66445B249919BAE6BA748041FE7@geoffPC>
	<4861882A.4020801@finnzi.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4861882A.4020801@finnzi.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: 'device-mapper development' <dm-devel@redhat.com>
List-Id: dm-devel.ids



Thanks for the reply.  Just for the record it is now fixed.  Here is what
happened:

Tested on Centos 5.1 i368: multipathd died reliably
Tested on Centos 5.1 x86_64:  works like a charm

And then it turns out that Centos 5.2 came down the line just last night =
for
me, so I updated and now multipathd works for me in both i386 and x86_64.

Again, thanks for the help.

-geoff


Geoff Galitz
Blankenheim NRW, Deutschland
http://www.galitz.org

-----Original Message-----
From: dm-devel-bounces@redhat.com [mailto:dm-devel-bounces@redhat.com] On
Behalf Of Finnur =D6rn Gu=F0mundsson
Sent: Mittwoch, 25. Juni 2008 01:50
To: device-mapper development
Subject: Re: [dm-devel] multipathd dies at startup

Geoff Galitz wrote:
>
> I am trying to get dm-multipath configured to support my iSCSI setup, b=
ut
I
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
> vendor "IET"=20
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
>  =20
Hi,
Having recently hit the same issue, it was a SELinux problem in my case.
Try: setenforce 0 ; service multipathd restart

See if it works for you. I also remember seeing a fix from RHEL/CentOS=20
regarding this.

Thanks,
Finnur

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel
