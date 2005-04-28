From: "goggin, edward" <egoggin@emc.com>
Subject: RE: How is the multipath pg policy group-by-nodename
	any	differen t than the failover policy?
Date: Thu, 28 Apr 2005 14:53:19 -0400
Message-ID: <C2EEB4E538D3DC48BF57F391F422779321A95A@SRMANNING.eng.emc.com>
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

On Wed, 27 Apr 2005 21:38:34 +0100, Arthur Bergman wrote:

> All the path have the same serial, but the show up from different nodes.

Not sure what this means.  The group-by-node-name policy implies assigning
paths with similar node name attribute to the same group.  For SCSI, seems
like the multipath configurator assigns the node name attribute to be the
combination of SCSI initiator and target addresses (in linux, host
no/channel no/target id).  This should be different for every path which
would cause each path to be assigned to a different path group.

How is the resultant path grouping any different than if you used the
failover
path grouping policy instead? 
