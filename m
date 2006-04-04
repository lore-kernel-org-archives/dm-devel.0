From: Christophe Varoqui <christophe.varoqui@free.fr>
Subject: Re: creating partition mappings with different delimiters
Date: Tue, 04 Apr 2006 19:49:49 +0200
Message-ID: <4432B1BD.3080709@free.fr>
References: <1144081162.3111.32.camel@gator.sc.steeleye.com>	<1144097506.3111.81.camel@gator.sc.steeleye.com>	<44319246.6040008@free.fr>	<20060404132417.GH5783@vienna.egenera.com>	<1144157784.3111.60.camel@gator.sc.steeleye.com>
	<20060404144612.GJ5783@vienna.egenera.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20060404144612.GJ5783@vienna.egenera.com>
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


>> It seems to me that volume managers, aka LVM or the like, is where folks
>> should be heading and the faster we can move them in that direction the
>> better.  The volume managers provide so much more flexibility than
>> partitions.
>>
>>     
>
> Maybe so. But they also add another layer of complexity for
> booting. I'd like the steps between me and a successful boot 
> to be as complex as required but no more so.
>
>   
True, just as the whole SAN is just another layer layer of complexity 
for booting and swaping : zoning and selective storage presentation 
errors are common, not to mention software shortcomings.

System on SAN is just a bit more risky. Not doing it also cuts down on 
the main use for partitions.

Big data volumes can be handled just fine by storage arrays internal 
volume managers.

My opinions, anyway.
So subject to frequent oscillations ;)

Regards,
cvaroqui
