From: "goggin, edward" <egoggin@emc.com>
Subject: RE: regarding DM device for a single path.
Date: Fri, 5 Aug 2005 14:34:36 -0400
Message-ID: <C2EEB4E538D3DC48BF57F391F422779321ABBA@SRMANNING.eng.emc.com>
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
To: "'dm-devel@redhat.com'" <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Wednesday, August 03, 2005 10:21 AM
Murthy, Narasimha Doraswamy (STSD) wrote

> Hi Alasdair,
> 
> Kindly clarify on the following,
> 
>  
> 
> 1.	I tested your latest user space tools with 2.6.9-11.41 kernel.
> Used the default created devices for multipathing. The path status is
> getting updated appropriately for HSV200 arrays.  However the failback
> functionality is not working for me. I have configure value for
> "failback" variable in /etc/multipath.conf as zero for immediate
> failback, but when the failed path in the original path group 
> comes back
> online, the IO is not failed back the old pathgroup.

I think this can happen if all of your paths are assigned a
priority value of 0 or less (-1 is assigned to a path's priority
when there is an error invoking the get_priority callout).
Since the path groups are assigned their priority based on a
summation of path priorities, the call to select_path_group
from switch_pathgroup called from checkerloop in multipathd
never changes the active path group from its current setting
ff none of the path groups have a priority "greater than zero".

If this is the case, simply setting the path priority callout
field for the storage system or the block device in question
to "none" will set the priority field of each path to the
block device to 1.  Assuming the path groups have a similar
number of paths and all the paths are active, all path groups
should end up having the same priority.  The first path group
discovered by multipathd will be the one which is considered
to be the highest priority path group and the one failed back
to every time.  This should fix the problem you cite.
