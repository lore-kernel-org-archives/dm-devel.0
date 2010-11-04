From: Heinz Mauelshagen <heinzm@redhat.com>
Subject: Re: kernel update and dmraid causing grub errors
Date: Thu, 04 Nov 2010 13:32:32 +0100
Message-ID: <1288873952.26244.39.camel@o>
References: <4CCF3EC4.1020708@suddenlinkmail.com>
	<1288785893.25565.42.camel@o>  <4CD1E8BC.4060806@suddenlinkmail.com>
Reply-To: heinzm@redhat.com, device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4CD1E8BC.4060806@suddenlinkmail.com>
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

On Wed, 2010-11-03 at 17:57 -0500, David C. Rankin wrote:
> On 11/03/2010 07:04 AM, Heinz Mauelshagen wrote:
> > - host protected area changes going together with the kernel changes
> >   (eg. the "Error 24: Attempt to access block outside partition");
> >   try the libata.ignore_hpa kernel paramaters described
> >   in the kernel source Documentation/kernel-parameters.txt
> >   to test for this one
> 
> Heinz,
> 
> 	I have testing with both libata.ignore_hpa=0 (default) and libata.ignore_hpa=1
> (ignore limits, using full disk), but there is no change. I still get grub Error
> 24: (this is also with a newer 2.6.36-3 kernel). So I'm stumped again. If you
> have any other ideas, please let me know. I'm happy to test on this end.

I overlooked you said it's a grub error, which occurs before any kernel
argument is being processed. Hmm, this could be a grub flaw then
identifying the disk size wrong or getting an offset wrong to load data
from. Did grub change with the kernel installed?

Heinz

> 
> 	I have gone ahead and made the metadata available in case it will help. I have
> also included the fdisk info as well:
> 
>   http://www.3111skyline.com/dl/bugs/dmraid/dmraid.nvidia/
> 
>   http://www.3111skyline.com/dl/bugs/dmraid/fdisk-l-info-20100817.txt
> 
> Thank you for your help.
> 
