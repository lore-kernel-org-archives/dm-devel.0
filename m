From: Todd Gill <tgill@redhat.com>
Subject: Re: [PATCH v4 1/1] add display of map information in
 JSON format
Date: Fri, 20 May 2016 15:59:07 -0400
Message-ID: <573F6C8B.8080008@redhat.com>
References: <1463592394-18974-1-git-send-email-tgill@redhat.com>
	<1463592394-18974-2-git-send-email-tgill@redhat.com>
	<20160519135032.GA969@redhat.com>
Reply-To: tgill@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20160519135032.GA969@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Gris Ge <fge@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids


Hi Gris,

On 05/19/2016 09:50 AM, Gris Ge wrote:
> On Wed, May 18, 2016 at 01:26:34PM -0400, Todd Gill wrote:
>>
>> v4:
>>
>> removed space in major_version and minor_version keys.
> Hi Todd,
> 
> Few things:
>     * Please provide path group id from 'pgindex' of struct path.

The paths are contained inside the groups they belong.  Why do we need
the 'pgindex'?

> 
>     * Replace key name 'host adapter' with 'host_adapter'.

I followed what is displayed via 'multipathd show wildcards'.  You are
thinking there should not be spaces in keys?  Valid JSON does allow
spaces in keys.  I thought it was best to be consistent with the
description of the wild card.

>     * Remove output properties as many as you can, only expose
>       those with clear user case and good definition.
>       For API, it's easy to add but hard to remove or change.
>       For example: IMHO, we don't need to expose
>       hcil, next_check, size, serial right now,

These values are already available via the format specifiers for output.
 I think we are already committed to them.

> 
>     * Performance concern. I am getting bad performance(25 seconds
>       while previous 'raw format' way only take 1.5 seconds) on 10k
>       disks. I am still investigating which part slow things down.
> 

There are performance problems with systems that have a large number of
maps (3k+).  But they are not related to the JSON changes.  The JSON
displays in less time than "show maps topology".

I think if we want to address the performance/scale issues - we should
do it with a separate patch set.

Thanks,
Todd
