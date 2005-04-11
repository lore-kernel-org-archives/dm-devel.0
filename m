From: Mike Christie <mikenc@us.ibm.com>
Subject: Re: New -udm?
Date: Mon, 11 Apr 2005 15:56:57 -0700
Message-ID: <425B00B9.7000804@us.ibm.com>
References: <C2EEB4E538D3DC48BF57F391F422779321A8EF@SRMANNING.eng.emc.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <C2EEB4E538D3DC48BF57F391F422779321A8EF@SRMANNING.eng.emc.com>
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

goggin, edward wrote:
> 
> I don't see a way around needing to use pre-allocated bio memory
> which is reserved strictly for this purpose -- albeit it is possible
> that a single bio could be reserved for making progress in serial
> fashion across all multipaths which are in this state.
> 
> 

Hey back on the subject of bio allocations. Is failback going to stay
in userspace? If so, the bio allocation there suffers from the same
problem. Would it work to have a fs_bio_set and block_bio_set so
the allocations coming into the block layer would use the fs set and
everything below (like block/scsi_ioctl or hw handlers) would use the
block layer one (today everyone uses the fs_bio_set which causes problems)?
If you stacked multipath on top of multipath I guess this would not work.
Or will you need per device bio sets?

For sg io there other allocations, so this just handles the bio itself.
