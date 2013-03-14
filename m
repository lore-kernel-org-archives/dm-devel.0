From: "Bryn M. Reeves" <bmr@redhat.com>
Subject: Re: Can DM-Multipath work on non-SCSI block device
Date: Thu, 14 Mar 2013 10:41:12 +0000
Message-ID: <5141A948.3010403@redhat.com>
References: <CAKNWCPZGKuA=TGOm3_Wzq+vwFc75W-1yviLuMwvX85st5Y-i=A@mail.gmail.com>
	<51419874.50308@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <51419874.50308@suse.de>
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

On 03/14/2013 09:29 AM, Hannes Reinecke wrote:
> On 03/14/2013 08:58 AM, Ahmed Al-Mehdi wrote:
>> Hello,
>>
>> I read the documentation on the dm-multipath home page:
>> htttp://christophe.varoqui.free.fr/refbook.html
>> <http://christophe.varoqui.free.fr/refbook.html> , that describes
>> how the userspace multipath tool detects and maps (scsi) devices.
>> However, would like to confirm, does the dm-multipath utilty only
>> work with SCSI devices.  Is there any option to make it (or fake it)
>> to work with non-SCSI  block device.
>>
> If you can figure out a way on how to get a unique _disk_ id without
> SCSI, sure.

E.g. cciss devices are supported using the cciss_id program - that's a 
good example of a very "non-scsi" device type working with multipath.

As well as the WWID problem you'll need to come up with some scheme for 
faking unique HCIL values for the devices since multipath userspace 
cares about that. The cciss approach is to force lun and channel to '0' 
for all devices and to use the CCISS controller (cN) and disk (dN) 
values for the host and id (aka target) values.

See the functions in discovery.c with a cciss_ prefix for more examples.

Regards,
Bryn.
