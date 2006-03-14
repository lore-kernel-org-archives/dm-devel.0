From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [RFC] New interface for dm-io to handle timed requests
Date: Tue, 14 Mar 2006 14:15:10 -0600
Message-ID: <4417244E.5080707@cs.wisc.edu>
References: <44169897.1080900@de.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <44169897.1080900@de.ibm.com>
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

Stefan Bader wrote:
> Some days ago we proposed an extension to the device mapper that allows 
> to specify a timeout after which a given request should return as 
> successful, even if some of the target devices did not react by that 
> time.  As we cannot return a request to the upper layers as long as some 
> io is still running and possibly modifying referenced pages, we also 
> need a way to handle those requests.
> The ideal solution would be to have an interface in the block layer that 
> allows us to cancel any submitted requests. But since such a change will 
> take quite a lot discussions and work, we want to emulate such a 
> behavior in the dm core for now.
> 

The scsi people and some block people have been talking about moving 
more error handling functionality into the block layer for a while and 
it is slowing moving that way. It could probably be done faster if 
people did not concentrate on one subsystem :)

Maybe you should post to lkml and linux-scsi and get some responses from 
them before adding it to dm core. If a post already went out to those 
list my fault for missing it.
