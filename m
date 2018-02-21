From: Lance Gropper <lance.gropper@mtifilm.com>
Subject: Re: DM Multipath limits
Date: Wed, 21 Feb 2018 13:37:30 -0800
Message-ID: <6ecc1b52-3ea2-ba95-f433-1dbb962feb03@mtifilm.com>
References: <3cbeed05-179d-bbd9-ac5a-3357a28eabac@mtifilm.com>
	<28F84C7B272904439CAA1BFB4BEF4D7463ED67@MX203CL04.corp.emc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <28F84C7B272904439CAA1BFB4BEF4D7463ED67@MX203CL04.corp.emc.com>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "berthiaume, wayne" <Wayne.Berthiaume@dell.com>, "christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: dm-devel.ids

Hello Wayne:

I still have to test this, but it looks like exactly what I was looking 
for. Many thanks.

Lance


On 2/21/2018 1:22 PM, berthiaume, wayne wrote:
> Hi Lance.
>
> 	We've qualified 16k devices. There are changes you will need to make to achieve this. You can refer to Dell EMC's Host Connectivity Guide
> for Linux page 19 for an example with RHEL 7.
>
> Regards,
> Wayne.
>
> Wayne Berthiaume
> Manager, E-Lab Engineering Platform Qualification Team
> Dell EMC | Infrastructure Solutions Group | Platform and System Engineering | Infrastructure Engineering & Operations | e2e Validation Lab (E-LAB)
>   "FOLLOW" E-Lab Engineering at https://inside.emc.com/community/active/EOS2/elab
> Confidentiality Notice: This email message, including any attachments, is for the sole use of the intended recipient(s) and may contain confidential or proprietary information. Any unauthorized review, use, disclosure or distribution is prohibited. If you are not the intended recipient, immediately contact the sender by reply e-mail and destroy all copies of the original message.
>
>
> -----Original Message-----
> From: dm-devel-bounces@redhat.com [mailto:dm-devel-bounces@redhat.com] On Behalf Of Lance Gropper
> Sent: Wednesday, January 10, 2018 12:11 PM
> To: christophe.varoqui@opensvc.com; dm-devel@redhat.com
> Subject: [dm-devel] DM Multipath limits
>
> Hello Christophe:
>
> We ran into a situation yesterday, where it appears there is a limit on the number of targets that DM Multipath can use. We are switching to a switch/zoning configuration at our office which may present as many as
> 2500 targets to the system. Yesterday, we were testing a smaller config, and the limit on the number of targets appears to be 640. When we exceed 640, the system locks up. When we try 656 targets, it locks up, then if we back out the last 16 targets and replace them with 16 different ones, it still locks up. We backed off the zoning for the meantime (which cripples the connection/bandwidth) to about 280 targets, but every filesystem multipaths properly.
>
> Do you know what is going on, and is there some way to increase this limit?
>
> Lance
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
