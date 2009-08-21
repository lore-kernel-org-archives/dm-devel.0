From: Mark Goodwin <mgoodwin@redhat.com>
Subject: Re: Issue with setting uid/gid/mode in multipath.conf
Date: Fri, 21 Aug 2009 12:30:46 +1000
Message-ID: <4A8E06D6.70606@redhat.com>
References: <1250796306.746.6.camel@chandra-ubuntu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1250796306.746.6.camel@chandra-ubuntu>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: sekharan@linux.vnet.ibm.com, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Chandra Seetharaman wrote:
> Hi Benjamin,
> 
> I have a small issue with setting the uid/gid/mode with multipath tools.
> 
> I have the following in my /etc/mulitpath.conf file
> ------------------
> multipaths {
>         multipath {
>                 wwid 3600a0b800011a1ee00003f834a3f7a65
>                 alias dev4
>                 mode    0666
>                 uid     1001
>                 gid     1001
>         }
> }
> -------------------
> 
> After adding this, I do a "multipath -F" following by "multipath" (or
> multipath -F followed by /etc/init.d/multipathd restart), I see the
> attributes are set properly on the device.
> 
> I reboot the system, the device is created (under /dev/mapper) but
> attributes are not set as defined in the multipath.conf file.
> 
> Have you seen this issue ? 
> 
> I am using RHEL 5.3 ga version (kernel and tools).
> 

yes we've recently also seen this issue and can reproduce it without
any need for a reboot, see https://bugzilla.redhat.com/518575

It seems to be a racy interaction of some kind between udevd and multipathd.

Cheers
-- Mark
