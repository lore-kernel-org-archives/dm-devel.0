From: Scott Dungan <scott@gps.caltech.edu>
Subject: Re: Manual failback commands
Date: Wed, 03 Feb 2010 08:49:40 -0800
Message-ID: <4B69A924.7010000@gps.caltech.edu>
References: <4B68C5A7.8090303@gps.caltech.edu>
	<1265159278.19083.11.camel@zezette>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1265159278.19083.11.camel@zezette>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids


> On mar., 2010-02-02 at 16:39 -0800, Scott Dungan wrote:
>    
>> Hello all.
>>
>> If we set a device to manual failback, how does one command the
>> multipathd service to reinstate the path when we have decided the path
>> is indeed ready to accept IO?
>>
>>      
> paths are automatically reinstated by multipathd.
>
> The 'failback' parameter means the original path_group is not
> re-activated after a switch-over to a secondary path_group.
>
> You can force multipathd to not reinstate a path using the CLI (or
> pro-actively disable it).
>    
Thanks for the clarification. I think I understand this better now. 
Would it be possible to post CLI example(s) of reinstating or disabling 
a path? I cannot seem to find such an example in documentation or other 
available resources.

Regards,

-Scott
