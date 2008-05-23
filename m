From: Tore Anderson <tore@linpro.no>
Subject: Re: Round Robin vs Active/Passive
Date: Fri, 23 May 2008 10:00:15 +0200
Message-ID: <4836798F.4060100@linpro.no>
References: <ABFD05FF09D13E4883B757E75603624D011E95B6@ex-sea1.vistocorp.com>	<ABFD05FF09D13E4883B757E75603624D011E95BB@ex-sea1.vistocorp.com>	<483468AD.7@linpro.no>
	<000301c8bbe5$4f1091d0$cf42e3c1@pitagora.it>
	<20080523071654.GB380@pentland.suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20080523071654.GB380@pentland.suse.de>
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

* Hannes Reinecke

> No. Alua is completely different. You have to use
> 
> prio_callout "/sbin/mpath_prio_alua /dev/%n"
> 
> for this.
> Although the normal EMC configuration continues to work, too.
> And also note that you have to change the failover mode
> to '4' to enable ALUA on the Clariion.

Hmm, interesting.  Apologies if I've been spreading misinformation!

Now you made me curious.  How does using an array (in ALUA failover mode
4) with my configuration:

        device {
                vendor                  DGC
                product                 *
                product_blacklist       LUNZ
                path_grouping_policy    group_by_prio
                path_checker            tur
                no_path_retry           queue
                prio_callout            "/sbin/mpath_prio_emc /dev/%n"
                failback                immediate
        }

differ from using the ALUA specific code in multipath-tools?  I believe
it would look something like this?

        device {
                vendor                  DGC
                product                 *
                product_blacklist       LUNZ
                path_grouping_policy    group_by_prio
                path_checker            tur
                no_path_retry           queue
                prio_callout            "/sbin/mpath_prio_alua /dev/%n"
                failback                immediate
                hardware_handler        "1 alua"
        }

I assume the ALUA bits are able to explicitly tell the CLARiiON to
transfer volume ownership from one controller to another (something I
don't think is desired in clustered environments anyway - the array
should have a better understanding of the optimal location of the volume
than the hosts, who could be in disagreement and end up moving the
volume back and forth), but what other differences are there?

I'm speaking strictly from a user's point of view here - the differences
"under the hood" isn't that interesting to me as long as it ends up
working the same way and in an equally reliable manner.

Regards,
-- 
Tore Anderson
