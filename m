From: Arthur Bergman <sky@nanisky.com>
Subject: Re: Making failover work quickly with QLogic HBAs
Date: Thu, 21 Apr 2005 17:44:27 +0100
Message-ID: <bd596d34f638b6fe011e296d85cdcee2@nanisky.com>
References: <20050421122328.GJ17315@marowsky-bree.de>
	<b4415a5867f3b25c8166bea8febd4b79@nanisky.com>
	<20050421134853.GM17315@marowsky-bree.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0 (Apple Message framework v619.2)
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20050421134853.GM17315@marowsky-bree.de>
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

On 21 Apr 2005, at 14:48, Lars Marowsky-Bree wrote:

> On 2005-04-21T14:21:25, Arthur Bergman <sky@nanisky.com> wrote:
>
>> There has been discussions that this is not supported behaviour and
>> could cause problems, in particular the supported configurations of 
>> big
>> blue for their SDD multipath product states that you shouldn't do
>> this...
>
> This is about DM multipath, not about SDD multipath, so I couldn't care
> less about what big blue supports there ;-)
>

I have heard the same from all the different vendors...


> But seriously, can you point me at those discussions? Are there any 
> real
> problems caused by this beyond the depreciated sdd multipath...? It
> seems to help quite a bit for me; w/o, failover times are inacceptable.
>
>

It does help for us too, however most recently i saw this discussed on 
the dm-devel list... Search for qlogic.

https://www.redhat.com/archives/dm-devel/2005-February/msg00084.html

Cheers
Arthur


-----
CTO @ Fotango Ltd
+447834716919
http://www.fotango.com/



______________________________________________________________________
This email has been scanned by the MessageLabs Email Security System.
For more information please visit http://www.messagelabs.com/email 
______________________________________________________________________
