From: Thomas Berton <thomas.berton@kreno.be>
Subject: Re: device-mapper: device /dev/hdc too small for target
Date: Tue, 14 Feb 2006 09:16:44 +0100
Message-ID: <43F191EC.6080207@kreno.be>
References: <43E8DAD6.3030208@kreno.be>
	<20060207184106.GB22775@tik.ee.ethz.ch>	<43E8EFA0.6050805@kreno.be>
	<03ee370c27de419c858856bf24f5dadf@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <03ee370c27de419c858856bf24f5dadf@redhat.com>
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

Jonathan E Brassow wrote:
> md and dm are two different things.  LVM uses dm, not md.
>
> I can't really say I see what is wrong, but your binaries seem to be 
> pretty old...
>
> "device-mapper: 4.1.0-ioctl (2003-12-10) initialised: dm@uk.sistina.com"
My apologies for the late response.
The problem seems to be fixed when using the latest (at the moment) 
vanilla kernel sources, 2.6.15-4.
Thank you Jonathan for pointing me into the good direction!

I hope this information is of any use to other lvm users with strange 
problems.

Greetings,
Thomas.
