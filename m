From: Christophe Varoqui <christophe.varoqui@free.fr>
Subject: Re: Experiences with multipath-tools and EMC CLARiiON
Date: Thu, 10 Feb 2005 10:11:59 +0100
Message-ID: <420B255F.8000100@free.fr>
References: <200502091314.56085.tore@linpro.no>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
In-Reply-To: <200502091314.56085.tore@linpro.no>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
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

Tore Anderson wrote:

>  Host-based failover doesn't seem to work, or at least I cannot figure
> out how to do it.  "sg_start -s /dev/sdb 1" gives me this:
>
>  sync_cache: SCSI status: Check Condition 
>   Fixed format, current;  Sense key: Not Ready
>   Additional sense: Logical unit not ready, manual intervention required
>
>  I guess the "tresspass" command is a proprietary thing and what is
> needed is just a userspace utility that is able to send the same thing
> down the fibre as the dm-emc kernel module is.
>
>  
>
Yes, "sg_start -s /dev/sdb 1" is not an adequate mean to force a 
host-driven failover for the clariion hardware. You need the trespass 
tool included in recent sg3_utils package.

For the rest, I guess Lars will be able to give you more feedback.

>  Cristophe:  Should I make a summary of this email and add it to your
> TestedEnvironments page?  I'm not sure if I could've made it work by
> configuring multipathd in another way (for instance the numbers on the
> hardware_handler line I just found in some mailing list archive, I have
> no idea what they mean) - so I'm a bit afraid of ending up updating it
> with flat-out incorrect information.
>
>  
>
We'll do that as soon as Lars has helped you refining your config.

Regards,
cvaroqui

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel
