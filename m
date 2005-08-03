From: "Christopher C. Weis" <ccweis@gmail.com>
Subject: Re: RE: dm-devel Digest, Vol 18, Issue 2
Date: Wed, 03 Aug 2005 15:33:58 -0500
Message-ID: <42F12A36.1090205@gmail.com>
References: <C2EEB4E538D3DC48BF57F391F422779321AB99@SRMANNING.eng.emc.com>	<1123014429.20148.3.camel@zezette>	<d6dcfcc90508021449d4de066@mail.gmail.com>	<d6dcfcc90508022001702e46c9@mail.gmail.com>
	<1123095225.21778.45.camel@zezette>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1123095225.21778.45.camel@zezette>
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

christophe varoqui wrote:

>>                
>>        
>>        
>>        Does this mean that "group_by_serial" utilizes a
>>        "default_prio_callout" program/script as well, or is there
>>        another callout (or something totally different that I'm
>>        missing)?
>>
>>I've verified that by writing my own "default_prio_callout" script I
>>can achieve what I want with both the "group_by_priority" and
>>"failover" policies.  Once I get done testing/tweaking the script,
>>I'll post it in case anyone else wants it.
>>
>>I can't seem to make group_by_serial work, although I'm not sure I
>>understand this policy very well.  It sounds like it's supposed to
>>make all paths that go to a particular controller (serial?) be in the
>>same priority group.  For me, it's no different than multibus.
>>Probably my misunderstanding, so I'm open to any suggestions...
>>
>>    
>>
>"/sbin/multipath -v4" will verbosely show you the path discovery phase,
>including the discovered serials.
>
>May be you'll understand better what happens with your hardware.
>
>Regards,	
>  
>
Ahhh, that makes things much clearer.  Thanks a bunch everyone.

~Chris
