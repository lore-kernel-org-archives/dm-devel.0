From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: Re: [PATCH] multipath-tools: add Pure Storage device to
 hardware table
Date: Thu, 16 Jun 2016 17:55:19 +0200
Message-ID: <f67e41f8-4783-df57-63bb-1e9403b1893d@gmail.com>
References: <1465835437-18350-1-git-send-email-xose.vazquez@gmail.com>
	<575F9C9C.4060007@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <575F9C9C.4060007@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Hannes Reinecke <hare@suse.de>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On 06/14/2016 07:56 AM, Hannes Reinecke wrote:

> On 06/13/2016 06:30 PM, Xose Vazquez Perez wrote:
> [...]
>> diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
>> index a126b7c..c4258e1 100644
>> --- a/libmultipath/hwtable.c
>> +++ b/libmultipath/hwtable.c
>> @@ -1195,6 +1195,22 @@ static struct hwentry default_hw[] = {
>>  		.minio         = 128,
>>  	},
>>  	/*
>> +	 * Pure Storage, Inc.
>> +	 *
>> +	 * Maintainer : Christophe Varoqui
>> +	 * Mail : christophe.varoqui@opensvc.com
>> +	 */
>>
> Please drop the 'Maintainer' line.
> Christophe is the maintainer of the multipath-tools package itself, so
> everything which doesn't have an explicit owner is maintained by him anyway.
>
> Plus I think it's a bad style, appointing someone to become a maintainer
> without having asked first.

It was made that way originally, see 1b6188ce. So I followed the stream.
But I see lately any patch for new hardware includes a maintainer.

Even the controller/vendor families were disorganized.

I will do it.
