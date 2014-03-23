From: Hannes Reinecke <hare@suse.de>
Subject: Re: Multipath not using multiple NICs at once
Date: Sun, 23 Mar 2014 15:26:09 +0100
Message-ID: <532EEF01.3070400@suse.de>
References: <532E5E55.2090209@gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"; Format="flowed"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <532E5E55.2090209@gmail.com>
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

On 03/23/2014 05:08 AM, Eric wrote:
> Hello,
>
> I'm fairly new to multipath and I am having an issue with it not using
> all of my NICs. Currently, my node has 4 gigE NICs to my storage network
> and the SAN has 8 gigE NICs to the same network and I am attempting to
> setup multipath with ISCSI in order to utilize more than 1 gigabit
> connection. However, when I use nload to check the network usage, you
> can see the traffic hop around the NICs. For example, data would send
> for 2-3 seconds on eth1, then stops and starts on eth2, then stops and
> starts back up on eth3. All perfectly distributed, but in this setup,
> unable to reach beyond the capacity of a 1 gigabit connection.
>
> I have each NIC on a different network (e.g. 10.1.1.0/24 for eth1,
> 10.1.2.0/24 for eth2, etc.). Netstat shows that the connections are
> being made each to different IPs:
>
> tcp        0      0 10.1.3.8:35493          10.1.5.241:3260 ESTABLISHED
> tcp        0      0 10.1.3.8:53972          10.1.3.241:3260 ESTABLISHED
> tcp        0      0 10.1.6.8:41090          10.1.4.241:3260 ESTABLISHED
> tcp        0      0 10.1.1.8:50754          10.1.1.241:3260 ESTABLISHED
> tcp        0      0 10.1.6.8:49780          10.1.5.241:3260 ESTABLISHED
> tcp        0      0 10.1.1.8:36938          10.1.6.241:3260 ESTABLISHED
> tcp        0      0 10.1.6.8:52009          10.1.6.241:3260 ESTABLISHED
> tcp        0      0 10.1.5.8:51630          10.1.1.241:3260 ESTABLISHED
> tcp        0      0 10.1.5.8:54481          10.1.4.241:3260 ESTABLISHED
> tcp        0      0 10.1.1.8:54504          10.1.5.241:3260 ESTABLISHED
> tcp        0      0 10.1.5.8:58229          10.1.3.241:3260 ESTABLISHED
> tcp        0      0 10.1.3.8:49031          10.1.1.241:3260 ESTABLISHED
> tcp        0      0 10.1.5.8:40551          10.1.6.241:3260 ESTABLISHED
> tcp        0      0 10.1.4.8:45016          10.1.5.241:3260 ESTABLISHED
> tcp        0      0 10.1.4.8:55665          10.1.4.241:3260 ESTABLISHED
> tcp        0      0 10.1.6.8:57472          10.1.3.241:3260 ESTABLISHED
> tcp        0      0 10.1.6.8:39278          10.1.1.241:3260 ESTABLISHED
> tcp        0      0 10.1.4.8:41329          10.1.6.241:3260 ESTABLISHED
> tcp        0      0 10.1.5.8:33553          10.1.5.241:3260 ESTABLISHED
> tcp        0      0 10.1.3.8:48950          10.1.6.241:3260 ESTABLISHED
> tcp        0      0 10.1.4.8:54752          10.1.1.241:3260 ESTABLISHED
> tcp        0      0 10.1.1.8:40911          10.1.4.241:3260 ESTABLISHED
> tcp        0      0 10.1.4.8:41135          10.1.3.241:3260 ESTABLISHED
> tcp        0      0 10.1.3.8:44606          10.1.4.241:3260 ESTABLISHED
> tcp        0      0 10.1.1.8:54677          10.1.3.241:3260 ESTABLISHED
>
> (10.1.*.8 is the node and 10.1.*.241 is the SAN)
>
> Here is my /etc/multipath.conf:
>
> defaults {
>          path_grouping_policy    multibus
>          path_selector           readsector0
>          polling_interval        3
>          path_selector           "round-robin 0"
>          failback                immediate
>          features                "0"
>          no_path_retry           1
>          rr_weight               uniform
>          rr_min_io               100
> #       user_friendly_names     yes
> }
>
> Both servers are running Ubuntu 12.04LTS.
>
> Any ideas?
>
Probably a routing issue. What is the routing table?

Cheers,

Hannes
-- =

Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
