From: "Bryn M. Reeves" <bmr@redhat.com>
Subject: Re: Suse sles10 SP1 -> SP2 update question
Date: Wed, 07 Jan 2009 10:42:15 +0000
Message-ID: <49648707.6000903@redhat.com>
References: <03FB5D708BE3C8448E8079186A56CDE60104231E@BTIBURMAIL.bustech.com>
Reply-To: bmr@redhat.com, device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <03FB5D708BE3C8448E8079186A56CDE60104231E@BTIBURMAIL.bustech.com>
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

Charlie Sharkey wrote:
>  
> I'm not sure if this is the correct place for this question or not.
> If not, please let me know.
>  
> After updating my Suse Sles10 SP1 system  (2.6.16.46-0.12-smp) with the
> kernel rpm from SP2 (2.6.16.60-0.21-smp) devices that mounted (by label)
> are mounting as non multipathed devices. For example, a device that
> previously
> mounted as:  /dev/dm-5  now mounts as:  /dev/sdj1  
>  
> The devices mount ok, they're just not mounting as multipathed devices. 
> If I reboot, there is about a one in five chance that they will mount
> ok.

The fact that there's a one in five or so chance it'll work suggests a 
race somewhere. I've often seen these with new kernels that take a bit 
longer to initialise the underlying SCSI devices, causing them to be 
absent when the initscripts run the multipath command to detect and 
configure multipath maps.

I'm not sure exactly where this is done in the SuSE initscripts, but it 
should be easy enough to find with a bit of grepping. Try adding a 
"sleep 5" just before the multipath command runs.

Alternately, if SLES10 supports the udevsettle command that gives a more 
elegant way of syncing up with udev's device creation. Instead of a 
sleep add a command like:

udevsettle --timeout=30

We've added these to some of the RHEL5 initscripts to fix bugs like this.

Regards,
Bryn.
