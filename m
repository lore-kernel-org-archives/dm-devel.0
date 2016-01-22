From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v2] dm pref-path: provides preferred path
 load balance policy
Date: Fri, 22 Jan 2016 14:42:32 +0100
Message-ID: <56A231C8.90602@suse.de>
References: <1453469502-15606-1-git-send-email-ravikanth.nalla@hpe.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1453469502-15606-1-git-send-email-ravikanth.nalla@hpe.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
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

On 01/22/2016 02:31 PM, Ravikanth Nalla wrote:
> v2:
>   - changes merged with latest mainline and functionality re-verified.
>   - performed additional tests to illustrate performance benefits of
>     using this feature in certain configuration.
> =

> In a dm multipath environment, providing end user with an option of
> selecting preferred path for an I/O in the SAN based on path speed,
> health status and user preference is found to be useful. This allows
> a user to select a reliable path over flakey/bad paths thereby
> achieving higher I/O success rate. The specific scenario in which
> it is found to be useful is where a user has a need to eliminate
> the paths experiencing frequent I/O errors due to SAN failures and
> use the best performing path for I/O whenever it is available.
> =

> Another scenario where it is found to be useful is in providing
> option for user to select a high speed path (say 16GB/8GB FC)
> over alternative low speed paths (4GB/2GB FC).
> =

> A new dm path selector kernel loadable module named "dm_pref_path"
> is introduced to handle preferred path load balance policy
> (pref-path) operations. The key operations of this policy is to
> select and return user specified path from the current discovered
> online/ healthy paths. If the user specified path do not exist in
> the online/ healthy paths list due to path being currently in
> failed state or user has mentioned wrong device information, it
> will fall back to round-robin policy, where all the online/ healthy
> paths are given equal preference.
> =

> Functionality provided in this module is verified on wide variety
> of servers ( with 2 CPU sockets, 4 CPU sockets and 8 CPU sockets).
> Additionally in some specific multipathing configurations involving
> varied path speeds, proposed preferred path policy provided some
> performance improvements over existing round-robin and service-time
> load balance policies.
> =

Shouldn't service-time provide similar functionality?
After all, for all scenarios described above the preferred path
would have a lower service time, so they should be selected
automatically, no?

Cheers,

Hannes
-- =

Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
