From: Konrad Rzeszutek <konrad@virtualiron.com>
Subject: Re: Re: multipath-tools support for SGI TP9700...
Date: Thu, 26 Jun 2008 07:20:16 -0400
Message-ID: <20080626112016.GA11085@mars.virtualiron.com>
References: <1213307328.25460.34.camel@plop>
	<OF677BDEF1.5E2665CA-ON86257474.0014369D-85257474.001A7D70@mck.us.ray.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <OF677BDEF1.5E2665CA-ON86257474.0014369D-85257474.001A7D70@mck.us.ray.com>
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
Cc: Christophe Varoqui <christophe.varoqui@free.fr>
List-Id: dm-devel.ids

> their original SP when the FC cable was reconnected.  Am I to assume that 
> RDAC or other multipath software will not tell the storage to failback 
> trepassed LUNs?

It will if the priority received from the prio_callout (or in more recent
version prio) is greater for the set of the trespassed LUNs and you are using
the right prio group policy. Try having this value in the new configuration
for the RDAC setup:

               path_grouping_policy    group_by_prio
