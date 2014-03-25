From: Eric <iggiggitoo@gmail.com>
Subject: Re: Multipath not using multiple NICs at once
Date: Tue, 25 Mar 2014 09:55:48 -0400
Message-ID: <53318AE4.2000308@gmail.com>
References: <532E5E55.2090209@gmail.com> <532EEF01.3070400@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <532EEF01.3070400@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
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

On 3/23/2014 10:26 AM, Hannes Reinecke wrote:
> On 03/23/2014 05:08 AM, Eric wrote:
>> Hello,
>>
>> I'm fairly new to multipath and I am having an issue with it not using
>> all of my NICs. Currently, my node has 4 gigE NICs to my storage network
>> and the SAN has 8 gigE NICs to the same network and I am attempting to
>> setup multipath with ISCSI in order to utilize more than 1 gigabit
>> connection. However, when I use nload to check the network usage, you
>> can see the traffic hop around the NICs. For example, data would send
>> for 2-3 seconds on eth1, then stops and starts on eth2, then stops and
>> starts back up on eth3. All perfectly distributed, but in this setup,
>> unable to reach beyond the capacity of a 1 gigabit connection.
>>
>> I have each NIC on a different network (e.g. 10.1.1.0/24 for eth1,
>> 10.1.2.0/24 for eth2, etc.). Netstat shows that the connections are
>> being made each to different IPs:
>>
>> tcp        0      0 10.1.3.8:35493          10.1.5.241:3260 ESTABLISHED
>> tcp        0      0 10.1.3.8:53972          10.1.3.241:3260 ESTABLISHED
>> tcp        0      0 10.1.6.8:41090          10.1.4.241:3260 ESTABLISHED
>> tcp        0      0 10.1.1.8:50754          10.1.1.241:3260 ESTABLISHED
>> tcp        0      0 10.1.6.8:49780          10.1.5.241:3260 ESTABLISHED
>> tcp        0      0 10.1.1.8:36938          10.1.6.241:3260 ESTABLISHED
>> tcp        0      0 10.1.6.8:52009          10.1.6.241:3260 ESTABLISHED
>> tcp        0      0 10.1.5.8:51630          10.1.1.241:3260 ESTABLISHED
>> tcp        0      0 10.1.5.8:54481          10.1.4.241:3260 ESTABLISHED
>> tcp        0      0 10.1.1.8:54504          10.1.5.241:3260 ESTABLISHED
>> tcp        0      0 10.1.5.8:58229          10.1.3.241:3260 ESTABLISHED
>> tcp        0      0 10.1.3.8:49031          10.1.1.241:3260 ESTABLISHED
>> tcp        0      0 10.1.5.8:40551          10.1.6.241:3260 ESTABLISHED
>> tcp        0      0 10.1.4.8:45016          10.1.5.241:3260 ESTABLISHED
>> tcp        0      0 10.1.4.8:55665          10.1.4.241:3260 ESTABLISHED
>> tcp        0      0 10.1.6.8:57472          10.1.3.241:3260 ESTABLISHED
>> tcp        0      0 10.1.6.8:39278          10.1.1.241:3260 ESTABLISHED
>> tcp        0      0 10.1.4.8:41329          10.1.6.241:3260 ESTABLISHED
>> tcp        0      0 10.1.5.8:33553          10.1.5.241:3260 ESTABLISHED
>> tcp        0      0 10.1.3.8:48950          10.1.6.241:3260 ESTABLISHED
>> tcp        0      0 10.1.4.8:54752          10.1.1.241:3260 ESTABLISHED
>> tcp        0      0 10.1.1.8:40911          10.1.4.241:3260 ESTABLISHED
>> tcp        0      0 10.1.4.8:41135          10.1.3.241:3260 ESTABLISHED
>> tcp        0      0 10.1.3.8:44606          10.1.4.241:3260 ESTABLISHED
>> tcp        0      0 10.1.1.8:54677          10.1.3.241:3260 ESTABLISHED
>>
>> (10.1.*.8 is the node and 10.1.*.241 is the SAN)
>>
>> Here is my /etc/multipath.conf:
>>
>> defaults {
>>          path_grouping_policy    multibus
>>          path_selector           readsector0
>>          polling_interval        3
>>          path_selector           "round-robin 0"
>>          failback                immediate
>>          features                "0"
>>          no_path_retry           1
>>          rr_weight               uniform
>>          rr_min_io               100
>> #       user_friendly_names     yes
>> }
>>
>> Both servers are running Ubuntu 12.04LTS.
>>
>> Any ideas?
>>
> Probably a routing issue. What is the routing table?
>
> Cheers,
>
> Hannes
Hannes,

Here's the output of "route -n":

0.0.0.0         209.124.44.1    0.0.0.0         UG    100 0        0 br0
10.1.1.0        0.0.0.0         255.255.255.0   U     0 0        0 br1
10.1.3.0        0.0.0.0         255.255.255.0   U     0 0        0 eth2
10.1.4.0        0.0.0.0         255.255.255.0   U     0 0        0 eth3
10.1.5.0        0.0.0.0         255.255.255.0   U     0 0        0 eth4
10.1.6.0        0.0.0.0         255.255.255.0   U     0 0        0 eth5
10.2.5.0        0.0.0.0         255.255.255.0   U     0 0        0 virbr2
192.168.122.0   0.0.0.0         255.255.255.0   U     0 0        0 virbr0
209.124.44.0    0.0.0.0         255.255.255.0   U     0 0        0 br0

br0 is a bridge to eth0 and br1 is a bridge to eth1. eth1-5 are on the 
network with the SAN.

Regards,
Eric
