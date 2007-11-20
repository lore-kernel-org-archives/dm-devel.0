From: Tore Anderson <tore@linpro.no>
Subject: Re: CLARiiON failover modes and DM.
Date: Tue, 20 Nov 2007 08:46:37 +0100
Message-ID: <474290DD.2080004@linpro.no>
References: <940B4FF1F5958E4F96FC83C055A2F2611B8C6A@exch-2003.incipient.waltham>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <940B4FF1F5958E4F96FC83C055A2F2611B8C6A@exch-2003.incipient.waltham>
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

* Paul Cote

> I have found the definitions of all CX failover modes. The SAN admin 
> assigned failover mode 3. Will DM support option 3 assuming that I 
> follow EMC's guidance wrt the appropriate settings for the CX in 
> multipath.conf? ... Or should we reassign the failover mode to 1 per 
> your email? It seems to me that the path state status will differ 
> significantly based on the failover modes; specifically 1 or 3. We
> don't have FLARE 26 so ALUA mode is N/A.
> 
> The failover definitions are:
> 1) Passive not ready; a command failure when I/O issued to non-owning
> SP.
> 2) quiet trespass on I/O to non-owning SP
> 3) passive always ready; some commands (TUR) return "passive always
> ready" status.

Mode 1 is what I've used on my CX so far (no support for ALUA yet).
You'll get lots of I/O failures when something wants to access the
passive paths (to scan for partition tables, PV signatures, and so on),
but they're harmless and can be disregarded.  You'll need path_checker
emc_clariion, hardware_handler emc, prio_callout mpath_prio_emc, and
path_grouping_policy group_by_prio  I think this is the default mode
multipath-tools is set up to handle, so unless you can invite EMC over
for a FLARE 26 upgrade party, I think this is the one you want.

Mode 2 you don't want unless you really know what you're doing.  This
will cause the I/O that failed in mode 1 to cause a volume trespass.  So
if you boot node 2 in a cluster, the data volumes will bounce around
wildly between SPs until it has finished booting, which'll affect I/O
from the production nodes in your cluster.  Same problem if you run
"vgdisplay", "fdisk -l", run HAL (maybe), and so on.

Mode 3 I never tried but it sounds like it's like mode 1, only that the
TEST UNIT READY will succeed.  If that's the case the only difference is
probably that you could use path_checker tur instead of path_checker emc.

Regards
-- 
Tore Anderson
