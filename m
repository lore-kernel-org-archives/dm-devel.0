From: Jeff Cook <jeff@deserettechnology.com>
Subject: Re: dm-crypt TRIM support
Date: Tue, 12 Jul 2011 11:47:14 -0600
Message-ID: <4E1C88A2.4020500@deserettechnology.com>
References: <4E0A3EF2.4090608@deserettechnology.com>
	<4E0A4545.6070401@redhat.com>
Reply-To: jeff@deserettechnology.com,
        device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4E0A4545.6070401@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Milan Broz <mbroz@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Thank you for the update. I would really like TRIM support on my
dm-crypt SSD and I'm not worried about the revelations that may be
discernible regarding trimmed space, etc.

Can you help me understand how I can pass the TRIM command through the
dm-crypt layer? I've looked through the device-mapper code in the kernel
and based on the implementation of TRIM in other dm clients it looks
like it should be relatively straightforward to get the message sent in
dm-crypt. Can you give me a couple of pointers or a brief outline of
what functions would need modification? I am not concerned with making
this optional at the moment since the patch would not (yet) be aimed for
mainline inclusion.

Please let me know if I am mistaken. I appreciate the quick response and
the efforts you've put toward this so far. Thanks again. :)

From
Jeff

Jeff Cook
(801) 231-3157
jeff@deserettechnology.com

On 06/28/2011 03:19 PM, Milan Broz wrote:
> On 06/28/2011 10:52 PM, Jeff Cook wrote:
>> After mounting a LUKS partition on my SSD, I get a message that the
>> discard mount option is ignored. In my research, I have seen many
>> conflicting reports on whether this functionality was available or not.
>> The last reliable mail I can find was from January and indicated that an
>> expected release of configurable discard support over dm-crypt in
>> 2.6.39. Can anyone let me know if this target was reached, and if not,
>> where development on TRIM support for dm-crypt volumes currently stands?
> 
> right, dm-crypt doesn't support TRIM yet.
> 
> I would like to add optional support for it but no code is submitted yet.
> No ETA currently.
> 
> Milan
