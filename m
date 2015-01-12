From: Suresh Babu Kandukuru <suresh.babu.kandukuru@oracle.com>
Subject: Re: Device mapper target driver for Write tracking or
 Write split
Date: Mon, 12 Jan 2015 02:04:04 -0800 (PST)
Message-ID: <fe1cdf55-ce8a-4914-aeba-699cd928a969@default>
References: <e1aa69e2-7af2-4003-8b8c-5a2b6987a3e2@default>
	<20150109142313.GB24745@redhat.com>
	<a6164707-a0dc-426d-9324-a5fba2170682@default>
	<20150109151337.GA17009@localhost.localdomain>
	<932defdc-db0a-4f1d-9812-1685199aed3a@default>
	<20150109165924.GB17009@localhost.localdomain>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20150109165924.GB17009@localhost.localdomain>
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
Cc: bmr@redhat.com
List-Id: dm-devel.ids

Thanks Bryn.

>>Aside from mentioning CDP and replicating data to another appliance you
>>haven't really stated what you're trying to do.

[Suresh]  - >  Bascilly I would like tap/track the  all writes happening that mapped lun on the host   ( take it as any block device on the host ) , in the format of Offset, Length and Data  . and then send this data to CDP appliace . This CDP appliance has the target lun which is intially synced to source lun on the host .  after receving the writes happening  on  host , this cdp applicance apply writes to target lun . so both source lun and target luns are  in sync all the time .  Can you advise me anything better now ?. Thanks again 

-----Original Message-----
From: Bryn M. Reeves [mailto:bmr@redhat.com] 
Sent: Friday, January 09, 2015 10:29 PM
To: device-mapper development
Cc: vgoyal@redhat.com
Subject: Re: [dm-devel] Device mapper target driver for Write tracking or Write split

On Fri, Jan 09, 2015 at 07:51:08AM -0800, Suresh Babu Kandukuru wrote:
> Bryn, Thanks for quick reply. Below items helps to do mirroring and replication . I am looking for something which  can track writes( device mapper based block level filter driver)   as explained in the below diagram in Linux open source community .

Anything that's doing mirroring or replication (or many other useful
target functions) is going to need to 'track' writes (normally by
copying them and keeping track of the copies in the target).

The device-mapper core provides infrastructure to help with this but if
none of the existing dm targets provide the functionality you need then
you will either need to create one from scratch or extend whatever
current target best matches your needs.

Aside from mentioning CDP and replicating data to another appliance you
haven't really stated what you're trying to do.

Regards,
Bryn.

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel
