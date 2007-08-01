From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [RFC] Naming of dm-multipath hardware handler modules
Date: Wed, 01 Aug 2007 12:06:30 -0500
Message-ID: <46B0BD96.6090601@cs.wisc.edu>
References: <1185913012.4392.46.camel@linux-cxyg>
	<46B0B731.1070601@cs.wisc.edu> <46B0B7DB.9020208@cs.wisc.edu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <46B0B7DB.9020208@cs.wisc.edu>
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

Mike Christie wrote:
> Mike Christie wrote:
>> And dm-emc.c should probably be changed,
> 
> Oops scratch that. I am not sure. I think we talked about that and I was 
> not sure if there was going to be some userspcae bits like initrd tools 
> that might be looking for dm-emc instead of dm-mpath-emc. And well, I 
> was not sure if having dm-rdac be named dm-mpath-rdac might break tools 
> too, but I guess Alasdair was convinced it would be ok or he would not 
> have asked for the change.
> 


Actually scrach that :) we should change dm-emc.c since we make the 
module name like the old style. I was thinking about some of the other 
alternatives that were brought up.
