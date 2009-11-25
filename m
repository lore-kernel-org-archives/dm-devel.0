From: malahal@us.ibm.com
Subject: Re: [PATCH 7/7] Hold all write bios when errors are handled
Date: Wed, 25 Nov 2009 15:20:10 -0800
Message-ID: <20091125232010.GA5968@us.ibm.com>
References: <Pine.LNX.4.64.0911180711510.21358@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.0911180712340.21358@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.0911180713150.21358@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.0911180718540.21358@hs20-bc2-1.build.redhat.com>
	<20091123055835.GA28981@us.ibm.com>
	<Pine.LNX.4.64.0911240638250.27545@hs20-bc2-1.build.redhat.com>
	<20091124191704.GB7971@us.ibm.com>
	<Pine.LNX.4.64.0911250807500.14481@hs20-bc2-1.build.redhat.com>
	<20091125202346.GB1673@us.ibm.com> <4B0DB408.6020906@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <4B0DB408.6020906@redhat.com>
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

Takahiro Yasui [tyasui@redhat.com] wrote:
> I think again the scenario which Mikulas pointed. It looks double failures
> (fails happened on two legs), and human intervention would be acceptable.
> However, how do we know if the second leg contains valid data?
> 
> There might be two cases.
> 
>   1) System crashed during write operations without any disk failures, and
>      the first leg fails at the next boot.
> 
>      We can use the secondary leg because data in the secondary leg is valid.
> 
>   2) System crashed after the secondary leg failed, and the first leg fails
>      and the secondary leg gets back online at the next boot.
> 
>      We can't use the secondary leg because data might be stale.
> 
> I haven't checked the contents of log disk, but I guess we can't
> differentiate these cases from log disks.

There were plans to add a new region state to make sure that all the
mirror legs have same data after a "crash". Currently your best bet is a
complete resync after a crash! I am not sure if the state is written to
log disk though. It may be possible to distinguish the above two cases
with this...

Or just have LVM meta data that records a device failure. Suspend writes
[for any kind of leg] and record device failure in the LVM meta data and
restart writes. This requires LVM meta data change though!

> Another possibility I thought was error messages.
> If any error messages for the secondary leg are recorded, we can judge that
> the secondary leg contains stale data, but I suspect that it is not a secure
> way because syslog might not be written in disk before system crash.

We should be able to fix it in the LVM meta data!
