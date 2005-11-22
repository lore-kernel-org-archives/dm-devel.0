From: Josef Whiter <jwhiter@redhat.com>
Subject: Re: What's the status on I/O-stats for dm block devices?
Date: Tue, 22 Nov 2005 18:33:11 -0500
Message-ID: <4383AAB7.1070504@redhat.com>
References: <20051122223701.GA23045@shuttle.vanvergehaald.nl>
Reply-To: dm-devel@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20051122223701.GA23045@shuttle.vanvergehaald.nl>
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

Toon van der Pas wrote:

>Hi,
>
>I'm running a newsserver with the newsspool on LVM2.
>It's working great for years already. Thanks for the great software!
>
>Question: Device mapper doesn't provide I/O-statistics yet.
>I found a bug in de Linux kernel bug tracker about this topic,
>with a patch from Kevin Corry. I added a comment to the bug report,
>asking about the status of the patch, and got a reply from Jens Axboe.
>He advised me to ask my question on this list.
>
>See: http://bugme.osdl.org/show_bug.cgi?id=1806
>
>Could anybody comment on Jens' reply, and tell me wether we can
>expect a solution? I can't imagine I'm the only one needing this...
>
>Thanks.
>
>--
>dm-devel mailing list
>dm-devel@redhat.com
>https://www.redhat.com/mailman/listinfo/dm-devel
>  
>
IIRC, there was a patch submitted recently to address this, so I'm 
assuming it will be released relatively soon.  It looks somewhat like 
the patch you described above, just a little simpler.  Thank you,

Josef

-- 
Josef Whiter, RHCE
Global Support Services
Red Hat, Inc.
919-754-3700 x44429
