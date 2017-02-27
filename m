From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH] Avoid that reloading a map sporadically
 triggers I/O errors
Date: Mon, 27 Feb 2017 07:18:44 -0800
Message-ID: <f95d0a86-5165-2c92-e824-449212bad9eb@sandisk.com>
References: <85315cb2-6908-70c6-78b7-06b6c1071f6b@sandisk.com>
	<d044817b-ea55-f42f-3895-5c539260ed80@sandisk.com>
	<20170104195643.GK2732@octiron.msp.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20170104195643.GK2732@octiron.msp.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Hello Christophe,

The patch below was posted more than three months ago but has not yet 
received any feedback from you. Had I sent this patch to the right 
person? Do you perhaps want me to repost it?

Bart.

On 01/04/17 11:56, Benjamin Marzinski wrote:
> On Wed, Dec 07, 2016 at 03:37:44PM -0800, Bart Van Assche wrote:
>
> ACK
>
> -Ben
>
>> Christophe and Hannes, do you want to comment on this patch?
>>
>> Thanks,
>>
>> Bart.
>>
>> On 11/18/2016 01:33 PM, Bart Van Assche wrote:
>>> Avoid that reloading a map while there are no paths triggers a flush
>>> and hence unwanted I/O errors if 'queue_if_no_path' is enabled.
>>>
>>> Fixes: commit d569988e7528 ("libmultipath: Fixup 'DM_DEVICE_RELOAD' handling")
>>> Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
>>> Cc: Hannes Reinecke <hare@suse.de>
>>> ---
>>> libmultipath/devmapper.c | 2 +-
>>> 1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
>>> index f92ebce..31f1962 100644
>>> --- a/libmultipath/devmapper.c
>>> +++ b/libmultipath/devmapper.c
>>> @@ -390,7 +390,7 @@ int dm_addmap_reload(struct multipath *mpp, char *params, int flush)
>>> 			      params, ADDMAP_RO, SKIP_KPARTX_OFF);
>>> 	}
>>> 	if (r)
>>> -		r = dm_simplecmd(DM_DEVICE_RESUME, mpp->alias, flush,
>>> +		r = dm_simplecmd(DM_DEVICE_RESUME, mpp->alias, !flush,
>>> 				 1, udev_flags, 0);
>>> 	return r;
>>> }
