From: "goggin, edward" <egoggin@emc.com>
Subject: RE: Automatic failback with multipath
Date: Fri, 11 Nov 2005 12:30:19 -0500
Message-ID: <C2EEB4E538D3DC48BF57F391F422779321ADF5@srmanning.eng.emc.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: 'device-mapper development' <dm-devel@redhat.com>
List-Id: dm-devel.ids

This issue was somehow erroneously associated with ONLY
EMC CLARiiON arrays but is by no means restricted to them.

The same problem will happen with dm multipath and any
storage array which has multiple path groups of differing
priorities configured for a block device.

I believe the problem has existed for quite some time and
does span the 0.4.4 and 0.4.5 releases of multipath-tools.

The previously mentioned work around will work for all
storage array types.

> -----Original Message-----
> From: dm-devel-bounces@redhat.com 
> [mailto:dm-devel-bounces@redhat.com] On Behalf Of 
> Dale.R.Fowle@seagate.com
> Sent: Friday, November 11, 2005 12:21 PM
> To: dm-devel@redhat.com
> Subject: [dm-devel] Automatic failback with multipath
> 
> 
> Hi all,
> 
> I recently saw a workaround that was given in a previous query about
> automatic failback with EMC arrays. I'm testing a different 
> array, but I
> tried the 'failback immediate' option in the 
> /etc/multipath.conf file and
> it doesn't do automatic failback. I wound up having to reset 
> the path with
> 'multipath -v2 -p failover' for multipath to scan the 
> re-enabled path and
> update it's own status. Am I missing something or is this a 
> known issue?
> 
> Also, is this an issue just with multipath-tools 0.4.4 or has 
> anyone seen
> this in 0.4.5.? The only reason I'm not using 0.4.5 is 
> because I've had
> issues getting it to make/compile.
> 
> Any help would be appreciated.
> 
> Thanks,
> Dale
> 
> Dale Fowle
> Seagate Technology
> Colorado Springs, CO
> 719-388-5584
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
> 
