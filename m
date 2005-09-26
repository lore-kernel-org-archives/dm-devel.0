From: Stefan Bader <Stefan.Bader@de.ibm.com>
Subject: Re: [multipath-tools] multipath -ll and offline devices
Date: Mon, 26 Sep 2005 11:08:05 +0200
Message-ID: <OF0C2F4897.5FD0B0FC-ONC1257088.0031BFAC-C1257088.003203CE@de.ibm.com>
References: <20050926075803.GD27319@free.fr>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20050926075803.GD27319@free.fr>
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

Hi Christophe,

looks good. After setting a device offline it is reported as failed by 
'multipath -ll'.
Just calling 'multipath' will remove the offline device which makes sense. 
The path
can be re-established by calling multipath again after returning the 
device to online
state.

Thanks.
Stefan

SW Linux on zSeries Development & Services
Stefan.Bader@de.ibm.com
----------------------------------------------------------------------------------
  When all other means of communication fail, try words.



Christophe Varoqui <christophe.varoqui@free.fr> 
Sent by: dm-devel-bounces@redhat.com
26.09.2005 09:58
Please respond to
device-mapper development


To
device-mapper development <dm-devel@redhat.com>
cc

Subject
Re: [dm-devel] [multipath-tools] multipath -ll and offline devices






On Fri, Sep 23, 2005 at 03:56:50PM +0200, Stefan Bader wrote:
> Hi, 
> 
> I got a report about strange behaviour of "multipath -l" if one of the 
> devices that are used for
> multipathing is set offline. In that case the code in libmultipath 
> (discovery.c) just ends processing
> and the output is incomplete.
> 
> The problem is that setting a scsi device offline (through sysfs state 
> attribute) will remove the
> device node in /dev. And this will cause pathinfo to abort which gives 
no 
> output at all.
> This looks strange and in that situation the path could be assumed as 
> failed. On the other hand
> if the device node just had been removed "failed" wouldn't be a correct 
> state.
> 
> One solution might be to use the state attribute of the scsi device 
> (wasn't that once called online?
> *sigh*) to check for an offline device and set the path state to failed 
in 
> that case. Or should the map
> get updated as soon as the device is set offline, to remove the path?
>
Thanks for the report,

I merged a fix.
Can you report on its behaviour ?
 
Regards,
cvaroqui

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel
