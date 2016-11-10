From: Gioh Kim <gi-oh.kim@profitbricks.com>
Subject: Re: [PATCH] multipathd: deferred device adding
Date: Thu, 10 Nov 2016 16:54:04 +0100
Message-ID: <8806d3b0-c507-3e2b-a7ff-fed6fbdfcb0a@profitbricks.com>
References: <1478790321-8539-1-git-send-email-gi-oh.kim@profitbricks.com>
	<5a8c5ffb-2dae-0e5c-3341-1f02ab3cd4dc@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <5a8c5ffb-2dae-0e5c-3341-1f02ab3cd4dc@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Hannes Reinecke <hare@suse.de>, christophe.varoqui@opensvc.com
Cc: dm-devel@redhat.com, benjamin.drung@profitbricks.com
List-Id: dm-devel.ids


On 10.11.2016 16:19, Hannes Reinecke wrote:
> On 11/10/2016 04:05 PM, Gioh Kim wrote:
>> Current multipathd always receives events from udev
>> and add devices to topology immediately. For example,
>> if sdb is added, multipathd receives the event from sdb
>> and add sdb into the topology.
>> But some platform needs to defer adding new device
>> until user adds device manually, for instance, with "multipathd add sdb".
>>
>> I tested this patch to disable ueventloop.
>> There was no problem on my platform.
>>
>> Is there a configuration for multipath.conf or udev rule
>> for deferred device adding?
>> Or what about adding new configuration for that?
>>
>> Signed-off-by: Gioh Kim <gi-oh.kim@profitbricks.com>
>> ---
>>  multipathd/main.c | 6 ++++--
>>  1 file changed, 4 insertions(+), 2 deletions(-)
>>
> Please elaborate.
>
> Which platforms would be needing that?
>
> Cheers,
>
> Hannes

Hi Hannes,

I thank you for the response.

The platform is the custom platform based on debian jessie distribution.

And new sdX device is created when the remote storage volume is connected via SCST.

I don't want to create a dm device when sdX is created because there are other jobs before export the volume.

For example, I need to change the size or format or copy data into sdb.

I want to create the dm device when I finished the setup.

I could disabled the socket in multipath udev rule file with v0.4.9.
But I cannot find a way to ignore the uevent.


-- 
Best regards,
Gioh Kim
TEL: 0176 2697 8962
