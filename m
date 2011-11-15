From: Gianluca Cecchi <gianluca.cecchi@gmail.com>
Subject: Re: info on enabling only one path with rdac and DS4700
Date: Tue, 15 Nov 2011 23:35:53 +0100
Message-ID: <CAG2kNCyHk+vosO1+TtNwLUcH5AJP-cPn8m5nCDhVkenXFFxfjw@mail.gmail.com>
References: <CAG2kNCx2FSBFcKQQ5qRNNdY8c8OZ6iR+WY4XPUy21mttYn-wuw@mail.gmail.com>
	<1321389505.23295.4.camel@lapoo.opensvc.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1321389505.23295.4.camel@lapoo.opensvc.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
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

On Tue, Nov 15, 2011 at 9:38 PM, Christophe Varoqui wrote:

>>
>> Is there any config option I can force to use only one path at a time
>> in the active controller, instead of two (sdb and sdc in my case) in
>> round robin as I see in iostat?
>>
> What ever the reason you'd want to do that, setting the path group
> policy to failover would create 4 1-path groups. I'd have 1 active paths
> and 3 spares.
>

Hi,
thank you all for the helpful answers.
Some more details to explain better:
- this system is a reinstall where before there was RH EL 4.x 32bit with rdac
rdac experience was a pain in terms of being not up2date and also
providing sometimes "unnecessary" kernel panic
(eg when running "mppUtil -o" to show options...)
So I would like now to go through device-mapper-multipath on rh el 5 x86_64

- This storage array is not under my total control
It is used by other systems, mainly Windows systems and other rh el
(these ones using using rdac...)
Win admins told me that standard drivers installation for that OS
keeps by default only one of the two paths of the active controller
for I/O operations.
And normally they keep this default as config.
So I wanted to investigate the chance to mimic this behaviour with multipath...

- One possible reason to force one fixed path as primary could be to
"statically" balance overall I/O to the storage array using one path
for some of the systems and the other one for the remaining ones
Possibly same results using round robin for each server connected, IMO

- I'm going to check tomorrow about AVT current configuration as noted
inside one of the answers.
BTW: on the storage array there are snmp traps configured.
After enabling multipath and rebooting the system, I still see the
trap below, sent by the storage (only one)... Could it be related to
this kind of configuration option at storage side?

Here the snmp message
Summary
Node ID: XXXX_DS4700
Host IP Address:
Host ID: Out-of-Band
Event Error Code: 4011
Event occurred: 15-nov-2011 14.49.36
Event Message: Logical Drive not on preferred path due to ADT/RDAC failover
Component type: Controller
Component location: Controller in slot B

- On the presented LUN I configured a PV, VG, LV and ext4 fs (not system fs)
At reboot at host side I see messages related to duplicated PV IDs for
the paths (sdb, sdc, sdd, sde): they comes before vg activation and
before multipathd start...
Is this normal, because at the first vgscan run during boot, multipath
configuration has not been instantiated yet..?
I have to check, but I don't remember similar messages with eh el 5.7
in other SAN configurations, where the VG is not a system VG....

Thanks again
