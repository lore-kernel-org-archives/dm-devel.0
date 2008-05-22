From: Tore Anderson <tore@linpro.no>
Subject: Re: Round Robin vs Active/Passive
Date: Thu, 22 May 2008 13:57:10 +0200
Message-ID: <48355F96.8040603@linpro.no>
References: <8a6b34b03e0524aa66c862534fee9b7a@www3.mail.volny.cz><18484.2693.62883.535755@notabene.brown>	<ABFD05FF09D13E4883B757E75603624D011E95B6@ex-sea1.vistocorp.com>	<ABFD05FF09D13E4883B757E75603624D011E95BB@ex-sea1.vistocorp.com>	<483468AD.7@linpro.no>
	<000301c8bbe5$4f1091d0$cf42e3c1@pitagora.it>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <000301c8bbe5$4f1091d0$cf42e3c1@pitagora.it>
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

* Domenico Viggiani

> Sorry for question: is this how new ALUA mode works for EMC Clariion
> CX arrays?

Yes, that's right.  Except for the fact that mpath_prio_emc will
correctly detect the preferred controller, while mpath_prio_hds_modular
only checks even/odd LUNs.

> Are default settings suitable for this new failover mode?

You don't have to use the EMC specific hardware handler or path checker
any longer.  This is what I use for my CX3:

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

Note that the host is no longer able to explicitly trespass the volume
between controllers.  I actually see that as an advantage, especially in
cluster environments.  If the host wants to change controllers it can
simply do so and wait for the CX to implicitly trespass the volume (due
to the I/O coming mostly to the passive controller).  This works very
well, and I consider it a huge improvement over the old
Passive-Not-Ready mode you had to use earlier (hwhandler "emc").

Note that there's also a new ALUA-specific hardware handler available
now.  I never tried it, so I can't tell how it differs from my setup.

Regards,
-- 
Tore Anderson
