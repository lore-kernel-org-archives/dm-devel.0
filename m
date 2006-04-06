From: Bernd Zeimetz <bernd@bzed.de>
Subject: Re: 	[Fwd: Multipath,
	page allocation failure during bonnie++]
Date: Thu, 06 Apr 2006 19:35:59 +0200
Message-ID: <4435517F.4020509@bzed.de>
References: <34881.212.34.68.21.1144132842.squirrel@extern.x-cellent.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <34881.212.34.68.21.1144132842.squirrel@extern.x-cellent.com>
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

Hi,
> Its a RH4 AS U3 kernel (2.6.9-34) with the device-mapper-multipath 0.45.
>   
you should update your Kernel and the multipath-tools. I didn't get them 
working stable before 2.6.13 and multipath-tools 0.4.6. If you have a 
look at the git you'll see that updating to 0.4.8 is worth the work.
Unfortunately christophe's wiki seems to be down, there's more info.


Best regards,
greetings from Darmstadt.


Bernd
