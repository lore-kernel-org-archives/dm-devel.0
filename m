From: Tore Anderson <tore@linpro.no>
Subject: Re: Re: Round Robin vs Active/Passive
Date: Thu, 05 Jun 2008 08:54:55 +0200
Message-ID: <48478DBF.3060709@linpro.no>
References: <ABFD05FF09D13E4883B757E75603624D011E95B6@ex-sea1.vistocorp.com>	<ABFD05FF09D13E4883B757E75603624D011E95BB@ex-sea1.vistocorp.com>	<483468AD.7@linpro.no>	<000301c8bbe5$4f1091d0$cf42e3c1@pitagora.it>	<20080523071654.GB380@pentland.suse.de>	<4836798F.4060100@linpro.no><000401c8bcc0$d29e94d0$cf42e3c1@pitagora.it>	<4836A075.9090008@linpro.no>
	<01d601c8bd1a$c5fd99b0$0201a8c0@zeug>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <01d601c8bd1a$c5fd99b0$0201a8c0@zeug>
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

* Sebastian Herbszt

> The comment and code from libmultipath/prioritizers/emc.c
> 
>  if ( /* Effective initiator type */
>       sense_buffer[27] != 0x03
>   /*
>    * Failover mode should be set to 1 (PNR failover mode)
>    * or 4 (ALUA failover mode).
>    */
>   || (((sense_buffer[28] & 0x07) != 0x04) &&
>       ((sense_buffer[28] & 0x07) != 0x06))
>   /* Arraycommpath should be set to 1 */
>   || (sense_buffer[30] & 0x04) != 0x04) {
>   pp_emc_log(0, "path not correctly configured for failover");
>  }
> 
> doesn't help with the detection part?

Not really, there's no way I can put this into a device{} section to
differentiate between two CLARiiONs running different failover modes.

What I need to do is this:

# My new CX3-40f which supports ALUA (preferred) as well as PNR
device {
	vendor DGC
	product *
	product_blacklist LUNZ
	alua_capable yes
	[..ALUA optimised settings...]
}

# My old CX200, only supports PNR
device {
	vendor DGC
	product *
	product_blacklist LUNZ
	alua_capable no
	[..PNR optimised settings...]
}

...but there's no such thing as the "alua_capable" setting or any other
setting that can be used to distinguish between the two CLARiiONs, as
far as I know, so I have to use both arrays in PNR mode even though the
newest one of them supports ALUA.

Please prove me wrong...  ;-)

Regards,
-- 
Tore Anderson
