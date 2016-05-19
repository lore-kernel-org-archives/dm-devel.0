From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: multipath-tools: irrelevant files
Date: Thu, 19 May 2016 17:24:18 +0200
Message-ID: <d0c31716-4350-4b97-90e3-caf238cc687b@gmail.com>
References: <CAE+k_g+Eh3H1EAiJ0jm7P-efGbOOwpWRtYmvXyR9qhhHtefV7g@mail.gmail.com>
	<571DF852.6030604@redhat.com>
	<CAE+k_gKQcx+QR9bfEp1Wy8BawD14L2G5O0Yw-d0=CffBHqYbrA@mail.gmail.com>
	<571E0E7A.4050703@redhat.com>
	<CABr-GnfxOKz8gxDju20Hx3T9Tn74Zz9FhjF1dBk8weEBJMOmLg@mail.gmail.com>
	<1986ca6b-d281-4faf-2b50-11c3dc132463@gmail.com>
	<571F026C.5040102@suse.de>
	<20160427224601.GG26117@octiron.msp.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20160427224601.GG26117@octiron.msp.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Benjamin Marzinski <bmarzins@redhat.com>, Hannes Reinecke <hare@suse.de>, Christophe Varoqui <christophe.varoqui@opensvc.com>, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On 04/28/2016 12:46 AM, Benjamin Marzinski wrote:

> On Tue, Apr 26, 2016 at 07:53:48AM +0200, Hannes Reinecke wrote:
>> On 04/25/2016 10:14 PM, Xose Vazquez Perez wrote:
>>> Btw, are these relevant ?
> 
> For all that I didn't comment on, I feel the same way as Hannes.
> 
>>> getuid/usb_id
>> Huh? What is that doing there?
>> It should really have been moved to the udev package ...
>>
>>> kpartx/kpartx_id
>>> kpartx/kpartx.rules
>> See above. Yes, they are relevant (at least for us)
> 
> Like I said, Red Hat doesn't use them. I'll post our multipath.rules
> shortly.
> 
>>> multipath/01_udev
>>> multipath/02_multipath
>> Not used anymore with systemd/dracut
>>
>>> multipath/11-dm-mpath.rules
>> Yep. Absolutely required.
>>
>>> multipath.conf.annotated
>>> multipath.conf.defaults
>>> multipath.conf.synthetic
>> Actually, I never saw the need for those.
>> Can we at least have them merged?
> 
> I don't think they are being kept up to date anymore.  The 'defaults'
> information can be gotten from a running system, and it includes the
> changes from the config files, so it's much more useful. I have no idea
> what people would use 'synthetic' for besides an example of what a
> config would look like. And the 'annotated' information is all in the
> multipath.conf manpage. Red Hat doesn't ship these files anymore. I'd be
> happy to see them go.
>  
>>> multipathd/multipathd.init.debian
>>> multipathd/multipathd.init.redhat
>>> multipathd/multipathd.init.suse
>> Old init scripts; doubtful value.
>>
>>> multipathd/multipathd.service
>>> multipathd/multipathd.socket
>> systemd service definitions. Yes, required.
> 
> Red Hat has a slightly different multipathd.service file, and we don't
> ship the socket file.  Since multipathd should always be running, I
> don't really see the need. Also, if you start multipathd manually
> (instead of through udev) this causes problems with multipathd not
> getting messages.
> 
> For those interested, here's a diff of our multipath.service
> 
> diff --git a/multipathd/multipathd.service
> b/multipathd/multipathd.service
> index d5f8606..1e5dfab 100644
> --- a/multipathd/multipathd.service
> +++ b/multipathd/multipathd.service
> @@ -2,9 +2,10 @@
>  Description=Device-Mapper Multipath Device Controller
>  Before=iscsi.service iscsid.service lvm2-activation-early.service
>  Before=local-fs-pre.target
> -After=multipathd.socket
> +ConditionPathExists=/etc/multipath.conf
> +ConditionKernelCommandLine=!nompath
>  DefaultDependencies=no
> -Wants=local-fs-pre.target multipathd.socket blk-availability.service
> +Wants=local-fs-pre.target blk-availability.service
>  Conflicts=shutdown.target
>  
>  [Service]
> @@ -12,9 +13,9 @@ Type=notify
>  NotifyAccess=main
>  LimitCORE=infinity
>  ExecStartPre=/sbin/modprobe dm-multipath
> +ExecStartPre=-/sbin/multipath -A
>  ExecStart=/sbin/multipathd -d -s
>  ExecReload=/sbin/multipathd reconfigure
>  
>  [Install]
>  WantedBy=sysinit.target
> -Also=multipathd.socket
> 
> 
> Aside from dropping the socket, it checks that /etc/multipath.conf
> exists, and that the kernel wasn't started with "nompath". Also it runs
> "multipath -A" this reads the kernel commandline from /proc/cmdline, and
> adds any wwids listed as part of any mpath.wwid=<wwid> parameters.
> Hannes NACKed this patch, so the option isn't present upsteam.
> 
>  
>>> multipath/multipath.init.suse
>> Old init script; not used anymore.
>>
>>> multipath/multipath.rules
>> Yep. used for udev.
>>
>>> multipath-tools.spec.in
>>>
>> Well; due to our buildservice we have to keep a separate spec file
>> anyway. So ATM we don't use it.

Hi Christophe, more files could be deleted as Benjamin and
Hannes have suggested in this thread.

I sent also four patches last month, and they're still pending:
https://www.redhat.com/archives/dm-devel/2016-April/thread.html#00453


BTW, there are not new tar files at http://christophe.varoqui.free.fr/ ,
latest is 0.5.0

-thanks-
