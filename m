From: Tore Anderson <tore@linpro.no>
Subject: Re: defining paths with DDN 8500
Date: Thu, 13 Sep 2007 10:33:11 +0200
Message-ID: <46E8F5C7.6050005@linpro.no>
References: <43123.80742.qm@web51104.mail.re2.yahoo.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <43123.80742.qm@web51104.mail.re2.yahoo.com>
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

* Mike White

> I'm working with the multipathing package and a DDN 8500.  I've been
> able to successfully configure  failover and failback.  The system is
> configured as such:
>     qla_port_1 ----  ctrl A port 4 ---- LUN 3 (LUN 7)
>     qla_port_2 ----  ctrl B port 4 ---- LUN 7 (LUN 3)
> 
> Where LUN 3 is on a dedicated port to qla_port_1 and qla_port_2 is
> dedicated to LUN 7.
> 
> The problem that I'm having is all the traffic is going through
> qla_port_1, qla_port_2 appears to be sitting idle until a failover.
> 
> To compensate, I've been using dmsetup to force the qla_port_2 ----
> LUN 7 path.
> 
> Is there a better way than using dmsetup to do this?  multipath isn't
> an option, as it negatively impacts performance.

  Sounds like you're in need of a prio_callout.  I'm not familiar with
 your hardware so I don't know if there's already one available, if not,
 make a simple script that for example prints "2" for the paths you want
 to prefer and "1" for the ones you want to use as backups.  Then set
 path_grouping_policy to "failover".  You might also want to set
 failback to "immediate".

Regards
-- 
Tore Anderson
